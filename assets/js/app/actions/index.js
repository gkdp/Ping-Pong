export const RECEIVE_MATCH = 'RECEIVE_MATCH'
export const CONNECT_TO_MATCH = 'CONNECT_TO_MATCH'
export const DISCONNECT_FROM_MATCH = 'DISCONNECT_FROM_MATCH'
export const CONNECTED_TO_MATCH = 'CONNECTED_TO_MATCH'
export const UPDATE_POINTS = 'UPDATE_POINTS'
export const UPDATE_SERVING = 'UPDATE_SERVING'
export const MATCH_HAS_BEEN_WON = 'MATCH_HAS_BEEN_WON'
export const START_MATCH = 'START_MATCH'
export const SEND_TO_LOBBY = 'SEND_TO_LOBBY'
export const SEND_TO_MATCH = 'SEND_TO_MATCH'

export function receiveMatch(id, started) {
  return {
    type: RECEIVE_MATCH,
    match: {
      id: id,
      started: started || null,
    },
  }
}

export function connectToMatch(id) {
  return {
    type: CONNECT_TO_MATCH,
    match: {
      id: id,
    },
  }
}

export function startMatch() {
  return {
    type: START_MATCH,
  }
}

export function disconnectFromMatch(id) {
  return {
    type: DISCONNECT_FROM_MATCH,
    match: {
      id: id,
    },
  }
}

export function connectedToMatch(match) {
  return {
    type: CONNECTED_TO_MATCH,
    match: {
      id: match.id,
      started: match.started,
      ended: match.ended,
      won_by: match.won_by,
      serving: match.serving,
      players: {
        ping: match.players.ping,
        pong: match.players.pong,
      },
      points: {
        ping: match.points.ping,
        pong: match.points.pong,
      },
      information: match.information,
    },
  }
}

export function updatePoints(ping, pong) {
  return {
    type: UPDATE_POINTS,
    points: {
      ping: ping,
      pong: pong,
    },
  }
}

export function addPoint(type) {
  return {
    type: SEND_TO_MATCH,
    event: 'point',
    payload: {
      for: type,
    },
  }
}

export function updateServing(id) {
  return {
    type: UPDATE_SERVING,
    serving: id,
  }
}

export function startServing(type) {
  return {
    type: SEND_TO_MATCH,
    event: 'serve',
    payload: {
      for: type,
    },
  }
}

export function matchHasBeenWon(won_by, ended_at) {
  return {
    type: MATCH_HAS_BEEN_WON,
    won_by,
    ended_at,
  }
}

export function retrieveHighscores() {
  return {
    type: SEND_TO_LOBBY,
    event: 'highscores',
    payload: {},
  }
}

export function retrievePoints() {
  return {
    type: SEND_TO_MATCH,
    event: 'points',
    payload: {},
  }
}

export function doSocketReduce(type, payload) {
  return {
    type: type,
    payload,
  }
}
