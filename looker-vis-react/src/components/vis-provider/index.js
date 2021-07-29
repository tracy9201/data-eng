/* eslint-disable no-unused-vars */
import React, { useEffect, useState } from 'react'
import DataContext from '@utils/context'

const VisProvider = ({
  id,
  label,
  options,
  isRequiredDimension = false,
  children,
}) => {
  const [context, setContext] = useState()
  useEffect(() => {
    looker.plugins.visualizations.add({
      id: id,
      label: label,
      options: options,
      // Set up the initial state of the visualization
      create: function (element, config) {
        //
      },
      // Render in response to the data or settings changing
      updateAsync: function (
        data,
        element,
        config,
        queryResponse,
        details,
        done
      ) {
        // Clear any errors from previous updates
        this.clearErrors()
        setContext({
          data: data,
          element: element,
          config: config,
          queryResponse: queryResponse,
          details: details,
        })
        // Throw some errors and exit if the shape of the data isn't what this chart needs
        if (
          isRequiredDimension &&
          queryResponse.fields.dimensions.length == 0
        ) {
          this.addError({
            title: 'No Dimensions',
            message: 'This chart requires dimensions.',
          })
          return
        }
        done()
      },
    })
  }, [])

  return <DataContext.Provider value={context}>{children}</DataContext.Provider>
}

export default VisProvider
