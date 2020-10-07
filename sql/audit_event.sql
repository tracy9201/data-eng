----- Data Pipeline: v4_audit_event ---------------------
 ----- Redshift Table: v4_audit_event ---------------------
----- Looker View: audit_event ---------------------
 
 
 select id,
   user_id,
   created_at,
   data::json->0->'table' as active_table,
   data::json->0->'type' as active_type
 from audit_event