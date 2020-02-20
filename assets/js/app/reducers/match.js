const initialState = {
  id: null,
  started: null,
  ended: null,
  won_by: null,
  connected: null,
  players: {
    ping: null,
    pong: null,
  },
  points: {
    ping: 0,
    pong: 0,
  },
}

const match = (state, action) => {
  if (state === void 0) {
    return initialState;
  }

  switch (action.type) {
    case 'RECEIVE_MATCH':
      return {
        ...initialState,
        id: action.match.id,
        started: action.match.started,
      }

    case 'UPDATE_POINT':
      return {
        ...state,
        points: {
          ...state.points,
          [action.for]: action.points,
        },
      }

    case 'UPDATE_POINTS':
      return {
        ...state,
        points: {
          ping: action.points.ping,
          pong: action.points.pong,
        },
      }

    case 'CONNECTED_TO_MATCH':
      return {
        ...initialState,
        id: action.match.id,
        started: action.match.started,
        ended: action.match.ended,
        won_by: action.match.won_by,
        connected: true,
        players: {
          ping: action.match.players.ping,
          pong: action.match.players.pong,
        },
        points: {
          ping: action.match.points.ping,
          pong: action.match.points.pong,
        },
      }

    case 'MATCH_HAS_BEEN_WON':
      return {
        ...state,
        ended: action.ended_at,
        won_by: action.won_by,
      }

    default:
      return state
  }
}

export default match
