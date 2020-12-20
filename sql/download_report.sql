
----- Data Pipeline: v4_download_report ---------------------
----- Redshift Table: v4_download_report ---------------------
----- Looker View: download_report ---------------------
 
 
 SELECT public.report_generation_jobs.id,
   public.report_generation_jobs.created_at,
   organization_id,
   public.report_generation_jobs.status,
   public.report_generation_jobs.name as report_name,
   organization_data.name as practice
 FROM public.report_generation_jobs join organization_data on organization_data.id = organization_id