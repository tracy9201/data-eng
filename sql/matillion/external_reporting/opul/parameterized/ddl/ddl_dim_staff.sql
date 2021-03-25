DROP TABLE IF EXISTS dwh_opul_{environment}.dim_staff;

CREATE TABLE IF NOT EXISTS dwh_opul_{environment}.dim_staff
(

  id  BIGINT  ENCODE  raw
  ,created_at  TIMESTAMP WITHOUT TIME ZONE ENCODE  raw
  ,updated_at  TIMESTAMP WITHOUT TIME ZONE ENCODE  raw
  ,deprecated_at TIMESTAMP WITHOUT TIME ZONE ENCODE  raw
  ,status  INTEGER ENCODE  raw
  ,user_id BIGINT  ENCODE  raw
  ,commission  INTEGER ENCODE  raw
  ,role_name VARCHAR(9)  ENCODE  raw
  ,title VARCHAR(32) ENCODE  raw
  ,firstname VARCHAR(MAX)  ENCODE  raw
  ,lastname  VARCHAR(MAX)  ENCODE  raw
  ,staff_name  VARCHAR(MAX)  ENCODE  raw
  ,role  INTEGER ENCODE  raw
  ,email VARCHAR(MAX)  ENCODE  raw
  ,mobile  VARCHAR(MAX)  ENCODE  raw
  ,organization_id BIGINT  ENCODE  raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(id)
  ,UNIQUE(id, updated_at)
)
DISTSTYLE ALL
SORTKEY (user_id)
;