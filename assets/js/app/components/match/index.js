import React from 'react'
import { Redirect, Route, Link } from 'react-router-dom'
import TextTransition, { presets } from 'react-text-transition'
import Point from './point'
import Fade from 'react-fade-opacity'
import UIfx from 'uifx'

import { spring, AnimatedRoute } from 'react-router-transition'
import Finished from '../../containers/Finished'
import Information from '../../containers/information'

function bounce(val) {
  return spring(val, {
    stiffness: 330,
    damping: 22,
  });
}

class Match extends React.Component {
  state = {
    id: this.props.id || this.props.match.params.id,
    hasPlayers: false,
    hadPlayers: false,

    count: 0,
  }

  interval = null

  sounds = {
    score: null,
    matchpoint: null,
  }

  componentDidMount() {
    if (this.state.id && !this.props.game.connected) {
      this.props.connectToMatch(this.state.id)
    }

    if (this.props.game.connected) {
      if (this.props.game.players.ping && this.props.game.players.pong) {
        this.setState({
          hasPlayers: true,
        })
      }
    }

    if (this.props.game.ended) {
      this.props.history.push(this.props.match.url + '/finished')
    }

    this.sounds.score = new UIfx('/sounds/score.mp3')
    this.sounds.matchpoint = new UIfx('/sounds/matchpoint.wav')
  }

  componentDidUpdate(prev) {
    if (this.state.id && !this.props.game.connected) {
      this.props.connectToMatch(this.state.id)
    }

    if (this.props.game.ended && !this.props.location.pathname.includes('finished')) {
      this.props.history.push(this.props.match.url + '/finished')
    }

    if (prev.game.connected && prev.game.serving != this.props.game.serving && this.props.game.serving && !this.props.game.ended) {
      if ('speechSynthesis' in window) {
          function setSpeech() {
            return new Promise(
                function (resolve, reject) {
                    let synth = window.speechSynthesis;
                    let id;

                    id = setInterval(() => {
                        if (synth.getVoices().length !== 0) {
                            resolve(synth.getVoices());
                            clearInterval(id);
                        }
                    }, 10);
                }
            )
        }

        setSpeech().then((voices) => {
          var msg = new SpeechSynthesisUtterance();
          msg.voice = voices[0];
          msg.text = `${this.props.game.players[this.props.game.serving].name} heeft nu opslag!`;

          speechSynthesis.speak(msg)
        })
      }
    }

    if (prev.game.connected && prev.game.matchpoint != this.props.game.matchpoint && this.props.game.matchpoint) {
      this.sounds.matchpoint.play(0.7)
    }

    if (prev && this.props.game.connected) {
      const had = prev.game.players.ping && prev.game.players.pong

      if (!had && this.props.game.players.ping && this.props.game.players.pong && !this.props.game.won_by) {
        if (prev.game.connected) {
          setTimeout(() => {
            this.setState({
              hasPlayers: true,
            })
          }, 3000)

          this.setState({
            count: 3,
          })

          this.interval = setInterval(() => {
            if (this.state.count <= 0) {
              clearInterval(this.interval)
              this.interval = null
              return
            }

            this.setState({
              count: --this.state.count,
            })
          }, 1000)
        } else{
          this.setState({
            hasPlayers: true,
            hadPlayers: true,
          })
        }
      }
    }

    if (prev.game.started) {
      if (prev.game.points.ping < this.props.game.points.ping || prev.game.points.pong < this.props.game.points.pong) {
        this.sounds.score.play(0.7)
      }
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
      <div className="match">
        <div className="container">
          <div className="intro"><div className="text" onClick={() => {
            this.props.history.push(this.props.match.url + '/finished')
          }}>Go!</div></div>

          {this.state.hasPlayers && this.props.game.connected && !this.props.game.serving && (
            <Fade delay={this.state.hadPlayers ? 0 : 2000} in={true} interval={this.state.hadPlayers ? 0 : 50}>
              <div className="who">
                <div className="text">Opslag voor?</div>
              </div>
            </Fade>
          )}

          <AnimatedRoute
            path="/match/:id/finished"
            component={Finished}
            atEnter={{ scale: 0 }}
            atLeave={{ scale: 0 }}
            atActive={{ scale: bounce(1) }}
            mapStyles={(styles) => ({
              transform: `scale(${styles.scale})`,
              height: '100%',
            })}
            className="scaled"
          />

          {this.state.count > 0 && (
            <div className="countdown">
              <TextTransition
                text={this.state.count}
                springConfig={presets.gentle}
              />
            </div>
          )}

          <div className={`players${this.state.hasPlayers ? ' has-players' : ''}`}>
            <div className="player ping">
              {/* <div className="photo" style={{ backgroundImage: 'url(/images/jurre_3.png)' }}></div> */}

              {!this.state.hasPlayers && this.props.game.players.ping && (
                <div className="info-big">
                  <div className="player-name">{this.props.game.players.ping.name}</div>
                </div>
              )}

              {this.state.hasPlayers && (
                <>
                  <div className="score" onClick={() => !this.props.game.ended && this.pointFor('ping')}>
                    <Point point={this.props.game.points.ping} />

                    {this.props.game.matchpoint == 'ping' && (
                      <div className="matchpoint">Matchpoint</div>
                    )}
                  </div>

                  <div className="info">
                    <div className="player-name">{this.props.game.players.ping ? this.props.game.players.ping.name : '-'}</div>

                    {this.props.game.serving == 'ping' && (
                      <div className="serving">Opslag</div>
                    )}
                  </div>
                </>
              )}

              {this.props.game.connected && !this.state.hadPlayers && (
                <>
                  <div className="vs-ping"></div>
                  <div className="vs-ping-letter">V</div>
                </>
              )}
            </div>

            <div className="player pong">
              {!this.state.hasPlayers && this.props.game.players.pong && (
                <div className="info-big">
                  <div className="player-name">{this.props.game.players.pong.name}</div>
                </div>
              )}

              {this.state.hasPlayers && (
                <>
                  <div className="score" onClick={() => !this.props.game.ended && this.pointFor('pong')}>
                    <Point point={this.props.game.points.pong} />

                    {this.props.game.matchpoint == 'pong' && (
                      <div className="matchpoint">Matchpoint</div>
                    )}
                  </div>

                  <div className="info">
                    <div className="player-name">{this.props.game.players.pong ? this.props.game.players.pong.name : '-'}</div>

                    {this.props.game.serving == 'pong' && (
                      <div className="serving">Opslag</div>
                    )}
                  </div>
                </>
              )}

              {this.props.game.connected && !this.state.hadPlayers && (
                <>
                  <div className="vs-pong"></div>
                  <div className="vs-pong-letter">S</div>
                </>
              )}
            </div>
          </div>
        </div>

        <Information />
      </div>
    );
  }
}

export default Match
