import React from 'react'
import { render } from 'react-dom'
import App from '@components/string/app'

const startup = () => {
  render(<App />, document.getElementById('vis'))
}

startup()

if (module.hot) {
  module.hot.accept('../components/string/app', () => {
    startup()
  })
}
