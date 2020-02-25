import { Socket } from 'phoenix'
import { receiveMatch, connectedToMatch, updatePoints, updateServing, matchHasBeenWon, doSocketReduce } from './actions/index'

export default (store) => {
  const socket = new Socket('/socket', {
    params: {}
  })

  // Connect the socket.
  socket.connect()

  const channel = socket.channel('match:lobby')

  channel.on('reduce', (params) => {
    store.dispatch(doSocketReduce(params.type, params.payload))
  })

  // Join the channel.
  channel.join()
    .receive('ok', ({ match }) => {
      store.dispatch(receiveMatch(match))
    })

  const channels = {}

  return next => action => {
    switch (action.type) {
      case 'CONNECT_TO_MATCH':
        if(channels[action.match.id] != void 0) {
          break;
        }

        channels[action.match.id] = socket.channel('match:game:' + action.match.id)

        channels[action.match.id].on('score', (params) => {
          store.dispatch(updatePoints(params.ping, params.pong))
        })

        channels[action.match.id].on('serve', (params) => {
          store.dispatch(updateServing(params.serving))
        })

        channels[action.match.id].on('won', (params) => {
          store.dispatch(matchHasBeenWon(params.won_by, params.ended_at))
        })

        channels[action.match.id].on('reduce', (params) => {
          store.dispatch(doSocketReduce(params.type, params.payload))
        })

        channels[action.match.id].join()
          .receive('ok', ({ match }) => {
            store.dispatch(connectedToMatch(match))
          })
        break;

      case 'DISCONNECT_FROM_MATCH':
        channels[action.match.id].leave()
        break;

      case 'START_MATCH':
        channel.push('start').receive('ok', ({ match }) => {
          store.dispatch(receiveMatch(match))
        })
        break;

      case 'SEND_TO_MATCH':
        channels[store.getState().match.id]
          .push(action.event, action.payload)
          .receive('ok', ({ type = null, payload = {} }) => {
            if (type) {
              store.dispatch(doSocketReduce(type, payload))
            }
          })
        break;

      case 'SEND_TO_LOBBY':
        channel
          .push(action.event, action.payload)
          .receive('ok', ({ type = null, payload = {} }) => {
            if (type) {
              store.dispatch(doSocketReduce(type, payload))
            }
          })
        break;
    }

    return next(action)
  }
}
