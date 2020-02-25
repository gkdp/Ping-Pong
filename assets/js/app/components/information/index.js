import React from 'react'

class Information extends React.Component {
  render() {
    return (
      <React.Fragment>
        <div className="information">
          <div className="line">{this.props.game.information}</div>
        </div>
      </React.Fragment>
    );
  }
}

export default Information
