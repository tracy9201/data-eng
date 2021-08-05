DROP TABLE IF EXISTS dwh_hint${environment}.p2pe_device;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.p2pe_device
(
  id	                  bigint ENCODE RAW,
  organization_id	      bigint ENCODE RAW,
  created_at	          timestamp without time zone ENCODE RAW,
  updated_at	          timestamp without time zone ENCODE RAW,
  hsn	                  varchar(100) ENCODE RAW,
  merchant_id	          varchar(100) ENCODE RAW,
  label	                varchar(100) ENCODE RAW,
  activation_code	      varchar(100) ENCODE RAW,
  status	              varchar(30) ENCODE RAW,
  shipping_street_line1	varchar(50) ENCODE RAW,
  shipping_street_line2	varchar(50) ENCODE RAW,
  shipping_city	        varchar(50) ENCODE RAW,
  shipping_state	      varchar(10) ENCODE RAW,
  shipping_zip          integer ENCODE RAW,
  shipping_country	    varchar(30) ENCODE RAW,
  styles	              varchar(65535) ENCODE RAW,
  shipping_date	        timestamp without time zone ENCODE RAW,
  tracking_url	        varchar(100) ENCODE RAW,
  archive_reason	      varchar(1000) ENCODE RAW,
  device_location	      varchar(500) ENCODE RAW,
  device_type_id	      bigint ENCODE RAW,
  status_changed_at	    timestamp without time zone ENCODE RAW,
  device_uuid	          varchar(65535) ENCODE RAW,
  deprecated_at	        timestamp without time zone ENCODE RAW
) DISTKEY(id);
