DROP TABLE IF EXISTS ir_commercial.Consumer_Subscription;

CREATE TABLE IF NOT EXISTS ir_commercial.Consumer_Subscription
(
  gx_provider_id varchar(64) ENCODE raw,
  MemberCount BIGINT ENCODE raw,
  SubcriberMemberCount BIGINT ENCODE raw,
  primary key(gx_provider_id)
)
;