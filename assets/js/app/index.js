import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import socket from './socket';
import rootReducer from './reducers';
import Routing from './components/Routing';

import 'babel-polyfill';

const store = createStore(
  rootReducer,
  applyMiddleware(thunk, socket)
)

const Providing = () => (
  <Provider store={store}>
    <Routing />
  </Provider>
)

ReactDOM.render(
  <Providing />,
  document.getElementById('app')
)

if (module.hot) {
  module.hot.accept(() => {
    ReactDOM.render(
      <Providing />,
      document.getElementById('app')
    );
  });
}
