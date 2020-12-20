----- Data Pipeline: v4_k_organizationdata ---------------------
----- Redshift Table: v4_k_organizationdata ---------------------
----- Looker View: organization_data ---------------------

select organization_data.id,
  organization_data.created_at,
  organization_data.updated_at,
  organization_data.deprecated_at,
  organization_data.status,
  organization_data.gx_provider_id,
  organization_data.currency,
  organization_data.rate,
  organization_data.per_member_rate,
  organization_data.address_id,
  organization_data.signer_id,
  organization_data.merchant_id,
  organization_data.timezone,
  organization_data.gx_org_customer_id,
  organization_data.title,
  organization_data.firstname,
  organization_data.lastname,
  organization_data.role,
  organization_data.email,
  organization_data.mobile,
  organization_data.organization_id
  users.lastname as practice_name
from organization_data
  join users on users.organization_id = organization_data.id
where role = 7