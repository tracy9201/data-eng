import React, { useContext, useState, useEffect } from 'react'
import { Helmet } from 'react-helmet'
import DataContext from '@utils/context'
import { parseSanitizedHTML } from '@utils/helper'

const Stmt = () => {
  const context = useContext(DataContext)
  const { data, queryResponse, config } = context || {}
  const [dataSet, setDataSet] = useState([])

  useEffect(() => {
    if (!data) {
      return
    }
    setDataSet(data[0])
  }, [data])

  if (!data || dataSet.length === 0) {
    return 'Loading...'
  }

  return (
    <div
      className="vis-react-stmt__div"
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
            .logo_opul {
              margin: 30px 0 50px 0;
            }
            .vis-react-stmt_des__container{
              width: 100%;
              display: flex;
              position: relative;
              align-items: flex-start;
              flex-wrap: wrap;
              padding-top: 30px;
            }
            .vis-react-stmt_des__left{
              width: 60%;
            }
            .vis-react-stmt_des__right{
              width: 40%;
            }
            .vis-react-stmt_des__right p {
              margin: 0 0 10px 0 !important;
            }
        `,
          },
        ]}
      />
      <img
        border="0"
        alt="opul logo"
        src="https://i.ibb.co/gg02GjG/Opul-Logo.png"
        className="logo_opul"
      ></img>
      <h1
        className="vis-react-stmt_title__container"
        style={{ margin: '40px 0 25px 0', width: '100%' }}
      >
        Card Processing Statement
      </h1>
      <div className="vis-react-stmt_des__container">
        <div className="vis-react-stmt_des__left">
          <p
            style={{
              fontSize: `${24}px`,
              marginTop: 0,
              marginBottom: `${10}px`,
            }}
          >
            {config.stmt_practice_name
              ? config.stmt_practice_name
              : 'Practice Name'}
          </p>
          <p
            style={{
              fontSize: `${18}px`,
              marginTop: `${10}px`,
              marginBottom: 0,
            }}
          >
            {config.stmt_practice_address
              ? config.stmt_practice_address
              : 'Practice Address'}
          </p>
          <p
            style={{
              fontSize: `${18}px`,
              marginTop: `${10}px`,
              marginBottom: 0,
            }}
          >
            {config.stmt_practice_ste ? config.stmt_practice_ste : 'Suite #'}
          </p>
          <p
            style={{
              fontSize: `${18}px`,
              marginTop: `${10}px`,
              marginBottom: 0,
            }}
          >
            {config.stmt_practice_zip
              ? config.stmt_practice_zip
              : 'City, Zipcode'}
          </p>
        </div>
        <div className="vis-react-stmt_des__right ">
          {parseSanitizedHTML(
            data[0][queryResponse.fields?.dimensions[0]?.name].html
          )}
          <span
            style={{
              display: 'block',
              margin: '0 12px 5px 0',
              fontWeight: 'bold',
              float: 'left',
            }}
          >
            Customer Service:
          </span>
          <div style={{ display: 'inline-block', float: 'left' }}>
            <a
              href="https://www.opul.com"
              target="_blank"
              style={{
                textDecoration: 'none',
                color: '#1C1C1C',
                margin: '0 0 10px 0 ',
                display: '  block',
              }}
              rel="noreferrer"
            >
              www.opul.com
            </a>
            <p>925-678-5377</p>
            <p>hello@opul.com</p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Stmt
