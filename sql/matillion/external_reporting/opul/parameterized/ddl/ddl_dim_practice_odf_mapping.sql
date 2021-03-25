DROP TABLE IF  EXISTS dwh_opul_{environment}.dim_practice_odf_mapping;

CREATE TABLE IF NOT EXISTS dwh_opul_{environment}.dim_practice_odf_mapping
(
    k_practice_id BIGINT  ENCODE raw
    ,payfac_merchant_id BIGINT  ENCODE raw
    ,card_processing_mid VARCHAR(32)  ENCODE raw
    ,org_data_merchant_id BIGINT  ENCODE raw
    ,gx_provider_id VARCHAR(32) ENCODE raw
    ,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
    ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
    ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
)
DISTSTYLE ALL
SORTKEY (gx_provider_id,k_practice_id)
;
