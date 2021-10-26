WITH dim_practice_odf_mapping as 
( 	
SELECT distinct  	
    od.id AS k_practice_id, 	
    om.payfac_merchant_id as payfac_merchant_id, 	
    cp.mid as card_processing_mid, 	
    od.merchant_id as org_data_merchant_id, 	
    od.gx_provider_id, 	
    od.created_at, 	
    od.updated_at, 	
    cp.mid_type, 	
    cp.store_number, 	
    cp.merchant_category_code, 	
    current_timestamp::timestamp as dwh_created_at, 	
    timezone AS practice_time_zone 	
FROM internal_merchant_opul.card_processing cp  	
JOIN internal_kronos_opul.organization_merchant om 
    on cp.merchant_id = om.payfac_merchant_id 	
JOIN internal_kronos_opul.organization_data od 
    on od.merchant_id = om.id  
) 
SELECT * FROM dim_practice_odf_mapping