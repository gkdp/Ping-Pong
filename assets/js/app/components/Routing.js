import React from 'react'
import { HashRouter as Router, Route, Switch } from 'react-router-dom'
import { spring, AnimatedSwitch, AnimatedRoute } from 'react-router-transition'

import NotFound from './NotFound'
import Home from '../containers/Home'
import Match from '../containers/Match'
import Highscore from '../containers/Highscore'

class Routing extends React.Component {
  render() {
    return (
      <Router hashType="hashbang">
        <div className="page">
          <Switch>
            <Route path="/" exact component={Home} />

            <Route path="/match/:id" component={Match} />

            <Route component={NotFound}/>
          </Switch>
        </div>

        <Highscore />
      </Router>
    )
  }
}

export default Routing
