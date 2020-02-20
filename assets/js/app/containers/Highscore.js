import { connect } from 'react-redux';
import { connectToMatch, disconnectFromMatch, addPoint } from '../actions';
import Highscore from '../components/highscore';

const mapStateToProps = ({ match }) => {
  return {
    //
  };
}

export default connect(mapStateToProps, {
  //
})(Highscore)
