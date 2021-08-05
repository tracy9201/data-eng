DROP TABLE IF EXISTS dwh_hint${environment}.users;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.users
(
  id	                  bigint ENCODE RAW,
  created_at	          timestamp without time zone ENCODE RAW,
  updated_at	          timestamp without time zone ENCODE RAW,
  deprecated_at	        timestamp without time zone ENCODE RAW,
  status	              integer ENCODE RAW,
  title	                varchar(32) ENCODE RAW,
  firstname	            varchar(65535) ENCODE RAW,
  lastname	            varchar(65535) ENCODE RAW,
  password	            varchar(255) ENCODE RAW,
  salt	                varchar(255) ENCODE RAW,
  last_login_attempt_at	bigint ENCODE RAW,
  last_login_at	        bigint ENCODE RAW,
  role	                integer ENCODE RAW,
  email	                varchar(65535) ENCODE RAW,
  mobile	              varchar(255) ENCODE RAW,
  organization_id	      bigint ENCODE RAW,
  thumbnail	            varchar(255) ENCODE RAW,
  color	                varchar(8) ENCODE RAW,
  firebase_token	      varchar(255) ENCODE RAW,
  invite_sent_date	    timestamp without time zone ENCODE RAW,
  deactivated_date	    timestamp without time zone ENCODE RAW,
  activated_date	      timestamp without time zone ENCODE RAW,
  zendesk_user_id	      bigint	 ENCODE RAW
) DISTKEY(id);
