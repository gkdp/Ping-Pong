import { combineReducers } from 'redux';
import match from './match';
import meta from './meta';

export default combineReducers({
  match,
  meta,
})
