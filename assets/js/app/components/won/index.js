import React from 'react'

class Won extends React.Component {
  state = {
    id: this.props.id || this.props.match.params.id
  }

  componentDidMount() {
    if (this.state.id && !this.props.game.connected) {
      this.props.connectToMatch(this.state.id)
    }
  }

  componentWillUnmount() {
    if (this.props.game.connected) {
      this.props.disconnectFromMatch(this.props.game.id)
    }
  }

  render() {
    return (
      <React.Fragment>
        <div className="container won">
          Congrats
        </div>
      </React.Fragment>
    );
  }
}

export default Won
