import React from 'react'
import { render } from 'react-dom'
import App from '@components/table/app'

const startup = () => {
  render(<App />, document.getElementById('vis'))
}

startup()

if (module.hot) {
  module.hot.accept('../components/table/app', () => {
    startup()
  })
}
