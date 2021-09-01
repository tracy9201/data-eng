With Main as (
SELECT 
  account_status__c as status, 
  accountsource, 
  case when specialty__c = 'Please Update' then 'N/A' 
    when specialty__c ='Medical Spa' then 'Medspa' 
    when specialty__c ='Derm' then 'DERMATOLOGY' 
    else specialty__c end as customer_type, 
    name, 
  upper(zendesk_support_organization_id_temp__c) as organization_id, 
  revance_territory__c as revance_territory__c,
  revance_region__c as revance_region
FROM salesforcenew.account 
order by _sdc_batched_at desc
)
select * from Main
