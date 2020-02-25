import { connect } from 'react-redux';
import { startMatch } from '../actions';
import { withRouter } from 'react-router-dom';
import Home from '../components/home';

const mapStateToProps = ({ match }) => {
  return {
    id: match.id,
    wonRedirect: match.wonRedirect,
  };
}

export default connect(mapStateToProps, {
  startMatch,
})(withRouter(Home))
