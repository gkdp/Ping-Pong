import { connect } from 'react-redux';
import { connectToMatch, disconnectFromMatch, retrievePoints } from '../actions';
import Finished from '../components/finished';

const mapStateToProps = ({ match }) => {
  return {
    game: match,
  };
}

export default connect(mapStateToProps, {
  connectToMatch,
  disconnectFromMatch,
  retrievePoints,
})(Finished)
