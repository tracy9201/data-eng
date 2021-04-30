import React from 'react'
import { render } from 'react-dom'
import App from '@components/statement/app'

const startup = () => {
  render(<App />, document.getElementById('vis'))
}

startup()

if (module.hot) {
  module.hot.accept('../components/statement/app', () => {
    startup()
  })
}
