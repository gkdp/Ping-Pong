import React from 'react'
// import Confetti from 'react-confetti'
import { parseISO, differenceInSeconds, zonedTimeToUtc } from 'date-fns'

class Finished extends React.Component {
  state = {
    id: this.props.id || this.props.match.params.id
  }

  componentDidMount() {
    if (this.state.id && !this.props.game.connected) {
      this.props.connectToMatch(this.state.id)
    }

    if (this.props.game.connected) {
      this.props.retrievePoints()
    }
  }

  componentDidUpdate(prev) {
    if (!prev.game.connected && this.props.game.connected) {
      this.props.retrievePoints()
    }
  }

  componentWillUnmount() {
    if (this.props.game.connected) {
      this.props.disconnectFromMatch(this.props.game.id)
    }
  }

  renderTimeline() {
    if (!this.props.game.connected) {
      return null
    }

    const ended = parseISO(this.props.game.ended)
    const started = parseISO(this.props.game.started)

    const total = differenceInSeconds(
      ended,
      started
    )

    return (
      <div className="points">
        {this.props.game.points.all && this.props.game.points.all.map((point, i) => {
          const inTime = differenceInSeconds(
            parseISO(point.time),
            started
          )

          return <div className={`point ${point.player}`} style={{left: ((inTime/total)*100) + '%'}} key={i} />
        })}
      </div>
    )
  }

  render() {
    return (
      <React.Fragment>
        <div className="container won">
          {/* <Confetti /> */}

          <div className="overlay">
            <div className="won-by-container">
              <div className="won-by">
                Gewonnen door
              </div>
              <div className="won-by-name">
                Jurre
              </div>
            </div>

            <div className="timeline-container">
              {this.renderTimeline()}
            </div>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

export default Finished
