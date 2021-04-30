import React, { useContext, useState, useEffect } from 'react'
import { Helmet } from 'react-helmet'
import clsx from 'clsx'
import DataContext from '@utils/context'
import {
  testIfCurrency,
  hashmapConvert,
  parseSanitizedHTML,
} from '@utils/helper'

// NOTE: This table only contains dimensions and measures data. Not aggregate_table

const Table = () => {
  const context = useContext(DataContext)
  const { data, queryResponse, config } = context || {}
  const [dataSet, setDataSet] = useState([])
  const [totalData, setTotalData] = useState({})

  const dimLength = queryResponse?.fields?.dimensions?.length
  const measLength = queryResponse?.fields?.measures?.length
  const calTableLength = queryResponse?.fields?.table_calculations?.length

  useEffect(() => {
    if (!data) {
      return
    }
    const temp = []
    // NOTE: convert row looker data
    for (let i = 0; i < data.length; i++) {
      const duplicatedLabelCount = {}
      let map = {}
      for (let j = 0; j < dimLength + measLength + calTableLength; j++) {
        let key, label
        //////////////////// NOTE: assign key ////////////////////
        if (j >= 0 && j < dimLength) {
          key = queryResponse.fields.dimensions[j]?.name
        } else if (j >= dimLength && j < dimLength + measLength) {
          key = queryResponse.fields.measures[j - dimLength]?.name
        } else if (
          j >= dimLength + measLength &&
          j < dimLength + measLength + calTableLength
        ) {
          key =
            queryResponse.fields.table_calculations[
              j - (dimLength + measLength)
            ]?.name
        }
        //////////////////// NOTE: assign label ////////////////////
        if (j >= 0 && j < dimLength) {
          label = queryResponse.fields.dimensions[j]?.label_short
        } else if (j >= dimLength && j < dimLength + measLength) {
          label = queryResponse.fields.measures[j - dimLength]?.label_short
        } else if (
          j >= dimLength + measLength &&
          j < dimLength + measLength + calTableLength
        ) {
          label =
            queryResponse.fields.table_calculations[
              j - (dimLength + measLength)
            ]?.label
        }
        map = hashmapConvert(
          map,
          label,
          LookerCharts.Utils.htmlForCell(data[i][key]),
          duplicatedLabelCount
        )
      }
      temp.push(map)
      setDataSet(temp)
    }
    // NOTE: caculate total data, only measures have total data
    let tempTotal = {}
    if (queryResponse.totals_data) {
      let label
      const duplicatedLabelCount = {}
      const tableTotalsData = {}
      for (let i = 0; i < dimLength + measLength + calTableLength; i++) {
        if (i === 0) {
          tempTotal['totals'] = '<span>Total</span>'
        } else if (i !== 0 && i < dimLength) {
          tempTotal[`dim-${i + 1}`] = ''
        } else if (i >= dimLength && i < dimLength + measLength) {
          label = queryResponse.fields.measures[i - dimLength]?.label_short
          tempTotal = hashmapConvert(
            tempTotal,
            label,
            Object.values(queryResponse.totals_data)[i - dimLength]?.html,
            duplicatedLabelCount
          )
          setTotalData(tempTotal)
        } else if (
          i >= dimLength + measLength &&
          i < dimLength + measLength + calTableLength
        ) {
          label =
            queryResponse.fields.table_calculations[
              i - (dimLength + measLength)
            ]?.label
          if (!tableTotalsData[label]) {
            tableTotalsData[label] =
              '' +
              Object.values(queryResponse.totals_data)[i - dimLength]?.rendered
          }
          tempTotal = hashmapConvert(
            tempTotal,
            label,
            tableTotalsData[label],
            duplicatedLabelCount
          )
        }
      }
    }
  }, [data])

  if (!data || dataSet.length === 0) {
    return 'Loading...'
  }

  return (
    <div
      className="vis-react-table__div"
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
            .vis-container{
              background: rgb(246, 246, 247); 
            }
            #vis {
              height: fit-content;
            }
            .vis-table-config__container {
              padding: 24px 0 30px 0;
              background: #ffffff;
              width: 100%;
            }
            .vis-table-config_title {
              font-size: 28px;
              line-height: 1.5;
              color: #1C1C1C;
              margin: 10px 0;
            }
            .vis-table-config_des {
              font-size: 16px;
              line-height: 1.5;
              color: #525252;
              margin: 10px 0;
            }
            .vis-table {
              position: relative;
              width: 100%;
              border-collapse: collapse;
              color: #000;
              padding-left:32px;
            }
            .vis-table thead, .vis-table tbody, .vis-table tfoot {
              position: relative;
            }
            .vis-table th, .vis-table td {
              font-size: 14px;
              padding: 0 12px;
              height: 48px;
            }
            .vis-table th p, .vis-table td p {
              margin: 0;
            }
            .vis-table th {
              border-bottom: 1px solid #000000;
              font-weight: bolder;
              color: #1C1C1C;
            }
            .vis-table th, .vis-table td {
              text-align: left;
            }
            .vis-table tbody tr {
              border-bottom: 1px solid #E0E0E0;
            }
            .vis-table tbody tr:last-child {
              border-bottom: 1px solid #000000;
            }
            .vis-table tfoot tr {
              bottom: 0;
              background: #fff;
              width: 100%;
              font-weight: bolder;
            }
            .vis-table .text-align-right {
              text-align: right;
            }
        `,
          },
        ]}
      />
      {(config.table_title || config.table_description) && (
        <div className="vis-table-config__container">
          <h1 className="vis-table-config_title">{config.table_title}</h1>
          <p className="vis-table-config_des">{config.table_description}</p>
        </div>
      )}
      <table className="vis-table">
        <thead>
          <tr>
            {Object.keys(dataSet[0]).map((label, index) => (
              <th
                key={`vis-table-header-${index}`}
                className={clsx({
                  'text-align-right': testIfCurrency(dataSet[0][label]),
                })}
              >
                {label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {dataSet.map((obj, index) => (
            <tr key={`vis-table-body-row-${index}`}>
              {Object.values(obj).map((value, index) => (
                <td
                  key={`vis-table-body-row-${index}`}
                  className={clsx({
                    'text-align-right': testIfCurrency(value),
                  })}
                  style={{
                    fontSize: config.table_font_size,
                  }}
                >
                  {parseSanitizedHTML(value)}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
        <tfoot>
          <tr>
            {totalData &&
              Object.values(totalData).map((value, index) => (
                <td
                  key={`vis-table-body-foot-${index}`}
                  className={clsx({
                    'text-align-right': testIfCurrency(value),
                  })}
                >
                  {parseSanitizedHTML(value)}
                </td>
              ))}
          </tr>
        </tfoot>
      </table>
    </div>
  )
}

export default Table
