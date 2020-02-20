export const RECEIVE_MATCH = 'RECEIVE_MATCH'
export const CONNECT_TO_MATCH = 'CONNECT_TO_MATCH'
export const DISCONNECT_FROM_MATCH = 'DISCONNECT_FROM_MATCH'
export const CONNECTED_TO_MATCH = 'CONNECTED_TO_MATCH'
export const UPDATE_POINTS = 'UPDATE_POINTS'
export const MATCH_HAS_BEEN_WON = 'MATCH_HAS_BEEN_WON'
export const START_MATCH = 'START_MATCH'

// Mutations
export const ADD_POINT = 'ADD_POINT'

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

export function startMatch(ping, pong) {
  return {
    type: START_MATCH,
    players: {
      ping,
      pong,
    },
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
      players: {
        ping: match.players.ping,
        pong: match.players.pong,
      },
      points: {
        ping: match.points.ping,
        pong: match.points.pong,
      },
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
    type: ADD_POINT,
    for: type,
  }
}

export function matchHasBeenWon(won_by, ended_at) {
  return {
    type: MATCH_HAS_BEEN_WON,
    won_by,
    ended_at,
  }
}
