import { connect } from 'react-redux';
import { retrieveHighscores } from '../actions';
import Highscore from '../components/highscore';

const mapStateToProps = ({ match, highscore }) => {
  return {
    highscore,
    game: match,
  };
}

export default connect(mapStateToProps, {
  retrieveHighscores,
})(Highscore)
