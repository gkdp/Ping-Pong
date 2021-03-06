const initialState = {
  id: null,
  started: null,
  ended: null,
  won_by: null,
  wonRedirect: false,
  connected: null,
  serving: null,
  matchpoint: null,
  players: {
    ping: null,
    pong: null,
  },
  points: {
    ping: 0,
    pong: 0,
    all: null,
  },
  information: null,
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
          all: state.points.all,
          ping: action.points.ping,
          pong: action.points.pong,
        },
      }

    case 'UPDATE_SERVING':
      return {
        ...state,
        serving: action.serving,
      }

    case 'UPDATE_MATCHPOINT':
      return {
        ...state,
        matchpoint: action.matchpoint,
      }

    case 'CONNECTED_TO_MATCH':
      return {
        ...initialState,
        id: action.match.id,
        started: action.match.started,
        ended: action.match.ended,
        won_by: action.match.won_by,
        serving: action.match.serving,
        matchpoint: action.match.matchpoint,
        connected: true,
        players: {
          ping: action.match.players.ping,
          pong: action.match.players.pong,
        },
        points: {
          all: null,
          ping: action.match.points.ping,
          pong: action.match.points.pong,
        },
        information: action.match.information,
      }

    case 'GAME_STARTED':
      return {
        ...state,
        started: action.payload.started,
      }

    case 'UPDATE_MATCH_PLAYERS':
      return {
        ...state,
        players: {
          ping: action.payload.players.ping,
          pong: action.payload.players.pong,
        },
        information: action.payload.information,
      }

    case 'MATCH_HAS_BEEN_WON':
      return {
        ...state,
        ended: action.ended_at,
        won_by: action.won_by,
        wonRedirect: true,
      }

    case 'ALL_POINTS':
      return {
        ...state,
        points: {
          ...state.points,
          all: action.payload.points,
        },
      }

    default:
      return state
  }
}

export default match
