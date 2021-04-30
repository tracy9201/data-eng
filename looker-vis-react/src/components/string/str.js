import React, { useContext, useState, useEffect } from 'react'
import { Helmet } from 'react-helmet'
import DataContext from '@utils/context'
import { parseSanitizedHTML } from '@utils/helper'

const Str = () => {
  const context = useContext(DataContext)
  const { data, queryResponse } = context || {}
  const [dataSet, setDataSet] = useState([])

  useEffect(() => {
    if (!data) {
      return
    }
    setDataSet(data)
  }, [data])

  if (!data || dataSet.length === 0) {
    return 'Loading...'
  }

  return (
    <div
      className="vis-react-str__div"
      style={{ padding: '0 28px', position: 'relative' }}
    >
      <Helmet
        style={[
          {
            cssText: `
            @font-face {
              font-family: "ApercuPro-Regular";
              src: url("../../../../public/font/ApercuPro.woff2") format("woff2"),
                  url("../../../../public/font/ApercuPro.woff") format("woff");
            }
            @font-face {
              font-family: "ApercuPro-Medium";
              src: url("../../../../public/font/ApercuPro-Medium.woff2") format("woff2"),
                  url("../../../../public/font/ApercuPro-Medium.woff") format("woff");
            }
            body {
              font-family: 'ApercuPro', 'Open Sans', arial, sans-serif;
            }
        `,
          },
        ]}
      />
      {parseSanitizedHTML(
        data[0][queryResponse.fields?.dimensions[0]?.name].html
      )}
    </div>
  )
}

export default Str
