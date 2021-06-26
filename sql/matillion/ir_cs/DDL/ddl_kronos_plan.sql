DROP 
  TABLE IF EXISTS ir_cs.kronos_plan;
CREATE TABLE IF NOT EXISTS ir_cs.kronos_plan (
  plan_id int4, 
  gx_plan_id varchar(64), 
  user_id int4, 
  plan_first_date varchar, 
  created_at timestamp, 
  updated_at timestamp, 
  deprecated_at timestamp, 
  plan_active int4, 
  plan_ended_date varchar, 
  member_recoganize int4, 
  num_of_subscription int4, 
  on_boarding_date timestamp, 
  primary key(plan_id), 
  UNIQUE(plan_id)
) DISTKEY (plan_id) SORTKEY (plan_id);
