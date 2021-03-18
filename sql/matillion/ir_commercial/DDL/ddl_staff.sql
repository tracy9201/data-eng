DROP TABLE IF  EXISTS ir_commercial.ddl_staff.sql;

CREATE TABLE IF NOT EXISTS ir_commercial.staff (   
    user_id BIGINT   ENCODE raw   ,
    title VARCHAR(255)   ENCODE raw   ,
    firstname VARCHAR(MAX)   ENCODE raw   ,
    lastname VARCHAR(MAX)   ENCODE raw   ,
    role VARCHAR(255)   ENCODE raw   ,
    email VARCHAR(MAX)   ENCODE raw   ,
    organization_id BIGINT   ENCODE raw   ,
    created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw   ,
    deprecated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw   ,
    zendesk_user_id BIGINT   ENCODE raw   ,
    pricinple_epxert boolean   ENCODE raw   ,
    commssion_percentage NUMERIC(18,2)   ENCODE raw   ,
    primary key(user_id) 
)
DISTSTYLE ALL
SORTKEY (user_id)
;