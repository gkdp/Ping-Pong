import { connect } from 'react-redux';
import { retrieveHighscores } from '../actions';
import Information from '../components/information';

const mapStateToProps = ({ match }) => {
  return {
    game: match,
  };
}

export default connect(mapStateToProps, {
  retrieveHighscores,
})(Information)
