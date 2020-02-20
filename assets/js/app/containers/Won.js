import { connect } from 'react-redux';
import { connectToMatch, disconnectFromMatch, addPoint } from '../actions';
import Won from '../components/won';

const mapStateToProps = ({ match }) => {
  return {
    game: match,
  };
}

export default connect(mapStateToProps, {
  connectToMatch,
  disconnectFromMatch,
})(Won)
