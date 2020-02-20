const initialState = {
  container: window.localStorage.getItem('container') != 1,
}

const meta = (state, action) => {
  if (state === void 0) {
    return initialState;
  }

  switch (action.type) {
    case 'TOGGLE_CONTAINER':
      window.localStorage.setItem('container', state.container ? 1 : 0)

      return {
        ...state,
        container: !state.container,
      }
    default:
      return state
  }
}

export default meta
