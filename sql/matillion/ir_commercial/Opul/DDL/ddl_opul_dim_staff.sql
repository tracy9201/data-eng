DROP TABLE IF  EXISTS ir_commercial_opul.opul_dim_staff;

CREATE TABLE IF NOT EXISTS ir_commercial_opul.opul_dim_staff (   
    staff_id BIGINT   ENCODE raw   ,
    status VARCHAR(50)   ENCODE raw   ,
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
    gx_provider_id VARCHAR(64)   ENCODE raw ,
    updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw ,
    dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw ,
    primary key(staff_id) 
)
DISTSTYLE ALL
;