import React from 'react'
import TextTransition, { presets } from 'react-text-transition'

const Point = ({ point }) => {
  // const [index, setIndex] = React.useState(0);

  return (
    <div className="point">
      <TextTransition
        text={point}
        springConfig={presets.wobbly}
      />
    </div>
  )
}

export default Point
