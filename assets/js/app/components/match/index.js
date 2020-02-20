import React from 'react'
import { Redirect, Route, Link } from 'react-router-dom'
import Point from './point'
import Modal from '../Modal'

import { spring, AnimatedRoute } from 'react-router-transition'
import Won from '../../containers/Won'

function bounce(val) {
  return spring(val, {
    stiffness: 330,
    damping: 22,
  });
}

class Match extends React.Component {
  state = {
    id: this.props.id || this.props.match.params.id
  }

  componentDidMount() {
    if (this.state.id && !this.props.game.connected) {
      this.props.connectToMatch(this.state.id)
    }

    if (this.props.game.ended) {
      this.props.history.push(this.props.match.url + '/won')
    }
  }

  componentDidUpdate() {
    if (this.state.id && !this.props.game.connected) {
      this.props.connectToMatch(this.state.id)
    }

    if (this.props.game.ended && !this.props.location.pathname.includes('won')) {
      this.props.history.push(this.props.match.url + '/won')
    }
  }

  componentWillUnmount() {
    if (this.props.game.connected) {
      this.props.disconnectFromMatch(this.props.game.id)
    }
  }

  pointFor(player) {
    if (!this.props.game.serving) {
      this.props.startServing(player)
    } else {
      this.props.addPoint(player)
    }
  }

  render() {
    return (
      <React.Fragment>
        <div className="container">
          <div className="intro"><div className="text" onClick={() => {
            this.props.history.push(this.props.match.url + '/won')
          }}>Go!</div></div>

          <AnimatedRoute
            path={`${this.props.match.url}/won`}
            component={Won}
            atEnter={{ scale: 0 }}
            atLeave={{ scale: 0 }}
            atActive={{ scale: bounce(1) }}
            mapStyles={(styles) => ({
              transform: `scale(${styles.scale})`,
              pointerEvents: styles.scale == 1 ? 'all' : 'none'
            })}
            className="scaled"
          />

          <div className="players">
            <div className="player ping">
              {/* <div className="photo" style={{ backgroundImage: 'url(/images/jurre_3.png)' }}></div> */}

              <div className="score" onClick={() => !this.props.game.ended && this.pointFor('ping')}>
                <Point point={this.props.game.points.ping} />
              </div>

              <div className="info">
                <div className="player-name">{this.props.game.players.ping ? this.props.game.players.ping.name : '-'}</div>

                {this.props.game.serving == 'ping' && (
                  <div className="serving">Opslag</div>
                )}
              </div>
            </div>
            <div className="player pong">
              <div className="score" onClick={() => !this.props.game.ended && this.pointFor('pong')}>
                <Point point={this.props.game.points.pong} />
              </div>

              <div className="info">
                <div className="player-name">{this.props.game.players.pong ? this.props.game.players.pong.name : '-'}</div>

                {this.props.game.serving == 'pong' && (
                  <div className="serving">Opslag</div>
                )}
              </div>
            </div>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

export default Match
