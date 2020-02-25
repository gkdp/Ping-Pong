import React from 'react'
// import Confetti from 'react-confetti'
import { parseISO, differenceInSeconds, zonedTimeToUtc } from 'date-fns'
import TextTransition, { presets } from 'react-text-transition'
import UIfx from 'uifx'

class Finished extends React.Component {
  state = {
    id: this.props.id || this.props.match.params.id,
    count: 0,
  }

  interval = null

  sounds = {
    finished: null,
  }

  componentDidMount() {
    if (this.state.id != this.props.game.id || !this.props.game.connected) {
      this.props.connectToMatch(this.state.id)
    }

    if (this.props.game.connected && this.state.id == this.props.game.id) {
      this.startRetrievePoints()
    }

    if (this.props.game.wonRedirect) {
      this.sounds.finished = new UIfx('./sounds/finished.mp3')

      // this.sounds.finished.play(0.7)
    }
  }

  componentDidUpdate(prev) {
    if ((!prev.game.connected && this.props.game.connected) || (prev.game.id && prev.game.id != this.props.game.id)) {
      this.startRetrievePoints()
    }
  }

  componentWillUnmount() {
    if (this.props.game.connected) {
      this.props.disconnectFromMatch(this.props.game.id)
    }
  }

  startRetrievePoints() {
    this.props.retrievePoints()

    if (this.props.game.wonRedirect) {
      this.setState({
        count: 5,
      })

      this.interval = setInterval(() => {
        if (this.state.count <= 1) {
          clearInterval(this.interval)
          this.interval = null
          this.props.history.push('/')
          return
        }

        this.setState({
          count: --this.state.count,
        })
      }, 1000)
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

  render() { console.log(this.props.game)
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
                {this.props.game.won_by && this.props.game.won_by.name}
              </div>
            </div>

            <div className="timeline-container">
              {this.renderTimeline()}
            </div>

            {this.state.count > 0 && (
              <div className="countdown">
                <TextTransition
                  text={this.state.count}
                  springConfig={presets.gentle}
                />
              </div>
            )}
          </div>
        </div>
      </React.Fragment>
    );
  }
}

export default Finished
