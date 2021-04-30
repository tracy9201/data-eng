import React from 'react'
import Table from '@components/table/table'
import VisProvider from '@components/vis-provider'

const App = () => {
  const options = {
    table_title: {
      type: 'string',
      label: 'Table title',
      placeholder: 'Enter here for table title',
    },
    table_description: {
      type: 'string',
      label: 'The description',
      placeholder: 'Enter here for table description',
    },
    table_font_size: {
      type: 'string',
      label: 'Font size',
      placeholder: 'Enter here to change table data font size',
    },
  }
  return (
    <VisProvider id="vis-react-table-provider" options={options}>
      <Table />
    </VisProvider>
  )
}

export default App
