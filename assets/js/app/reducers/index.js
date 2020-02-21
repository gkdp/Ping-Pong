import { combineReducers } from 'redux';
import highscore from './highscore';
import match from './match';
import meta from './meta';

export default combineReducers({
  highscore,
  match,
  meta,
})
