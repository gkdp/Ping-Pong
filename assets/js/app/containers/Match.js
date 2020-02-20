import { connect } from 'react-redux';
import { connectToMatch, disconnectFromMatch, addPoint } from '../actions';
import Match from '../components/match';

const mapStateToProps = ({ match }) => {
  return {
    id: match.id,
    game: match,
  };
}

export default connect(mapStateToProps, {
  connectToMatch,
  disconnectFromMatch,
  addPoint,
})(Match)
