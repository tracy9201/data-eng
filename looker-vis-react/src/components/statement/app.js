import React from 'react'
import Stmt from '@components/statement/stmt'
import VisProvider from '@components/vis-provider'

const App = () => {
  const options = {
    stmt_practice_name: {
      type: 'string',
      label: 'The practice name',
      placeholder: 'Enter the practice name',
    },
    stmt_practice_address: {
      type: 'string',
      label: 'The practice, the address',
      placeholder: 'Enter here the address for the practice if applicaple',
    },
    stmt_practice_ste: {
      type: 'string',
      label: 'The practice, the suite',
      placeholder: 'Enter here the suite for the practice if applicaple',
    },
    stmt_practice_zip: {
      type: 'string',
      label: 'The practice, the zipcode',
      placeholder: 'Enter here the zipcode for the practice if applicaple',
    },
  }
  return (
    <VisProvider options={options}>
      <Stmt id="opul-statement" />
    </VisProvider>
  )
}

export default App
