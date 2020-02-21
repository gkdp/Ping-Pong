const initialState = {
  players: [],
}

const highscore = (state, action) => {
  if (state === void 0) {
    return initialState;
  }

  switch (action.type) {
    case 'UPDATE_HIGHSCORES':
      return {
        ...state,
        players: action.payload.players,
      }

    default:
      return state
  }
}

export default highscore
