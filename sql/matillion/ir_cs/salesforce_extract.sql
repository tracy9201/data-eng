SELECT 
  account_status__c, 
  accountsource,
  specialty__c, 
  name, 
  upper(zendesk_support_organization_id_temp__c), 
  revance_territory__C, 
  revance_region__c, 
  upper(opul_organization_id__c),
  revance_customer_number__c
FROM rvsalesforce.account 
where zendesk_support_organization_id_temp__c is not null 
  or opul_organization_id__c is not null