DROP TABLE IF EXISTS ir_commercial.membershiplength_vs_daysbetweenappts;

CREATE TABLE IF NOT EXISTS ir_commercial.membershiplength_vs_daysbetweenappts
(

  gx_provider_id VARCHAR(64)   ENCODE raw
  ,business_name bigint ENCODE raw
  ,membership_length bigint ENCODE raw
  ,avg_membership_length bigint ENCODE raw
  ,primary key(gx_provider_id)
)
;
