import React from 'react';
import { Redirect } from 'react-router-dom';

class Home extends React.Component {
  state = {
    redirect: null,
    players: [],
    match: {
      ping: '',
      pong: '',
    },
  }

  componentDidMount() {
    fetch('/api/players')
      .then(d => d.json())
      .then((players) => {
        this.setState({
          players,
          match: {
            ping: players[0].id,
            pong: players[1].id,
          }
        })
      })
  }

  componentDidUpdate() {
    if (this.props.id) {
      this.setState({
        redirect: '/match/' + this.props.id
      })
    }
  }

  selectPing(e) {
    this.setState({
      match: {
        ...this.state.match,
        ping: e.target.value,
      }
    })
  }

  selectPong(e) {
    this.setState({
      match: {
        ...this.state.match,
        pong: e.target.value,
      }
    })
  }

  render() {
    if (this.state.redirect) {
      return <Redirect to={this.state.redirect} />
    }

    return (
      <React.Fragment>
        <div className="container welcome">
          <div className="control">
            Speler #1
            <select onChange={this.selectPing.bind(this)} value={this.state.match.ping}>
              {this.state.players.map((player) =>
                this.state.match.pong != player.id || <option key={player.id} value={player.id}>{player.name}</option>
              )}
            </select>
          </div>

          <div className="control">
            Speler #2
            <select onChange={this.selectPong.bind(this)} value={this.state.match.pong}>
              {this.state.players.map((player) =>
                this.state.match.ping != player.id || <option key={player.id} value={player.id}>{player.name}</option>
              )}
            </select>
          </div>

          <div className="control">
            <button onClick={() => this.props.startMatch(this.state.match.ping, this.state.match.pong)}>Start</button>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

export default Home
