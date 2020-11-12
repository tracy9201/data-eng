------------SrcRDSDataNode5  payment_summary---------------

SELECT
        * 
    FROM
        ( SELECT
            'credit_'||cast(credit.id AS text) AS sales_id,
            credit.name AS sales_name,
            credit.amount AS sales_amount,
            credit.type AS sales_type,
            credit.status AS sales_status,
            credit.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            CASE 
                WHEN credit.id IS NOT NULL THEN '' 
            END AS transaction_id,
            credit.name AS payment_id,
            '0000000000000000' AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            credit.created_by AS staff_user_id,
            NULL AS device_id,
            NULL AS gratuity_amount,
            NULL AS is_voided 
        FROM
            credit 
        LEFT JOIN
            subscription 
                ON subscription.id = credit.subscription_id 
        LEFT JOIN
            plan 
                ON credit.plan_id = plan.id 
        LEFT JOIN
            customer 
                ON customer.id = plan.customer_id 
        LEFT JOIN
            provider 
                ON provider.id = provider_id 
        WHERE
            credit.id IS NOT NULL 
            AND credit.status =1 

        UNION

        SELECT
            'payment_'||cast(payment.id AS text) AS sales_id,
            payment.name AS sales_name,
            payment.amount AS sales_amount,
            payment.type AS sales_type,
            payment.status AS sales_status,
            payment.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            payment.transaction_id,
            CASE 
                WHEN payment.type ='credit_card' THEN account_number 
                ELSE payment.name 
            END AS payment_id,
            cpg.tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            payment.created_by AS staff_user_id,
            payment.device_id,
            gratuity.amount AS gratuity_amount,
            NULL AS is_voided 
        FROM
            payment 
        LEFT JOIN
            subscription 
                ON subscription.id = payment.subscription_id 
        LEFT JOIN
            gratuity 
                ON gratuity.id = payment.gratuity_id 
        LEFT JOIN
            plan 
                ON payment.plan_id = plan.id 
        LEFT JOIN
            customer 
                ON customer.id = customer_id 
        LEFT JOIN
            provider 
                ON provider.id = provider_id 
        LEFT JOIN
            gateway_transaction gt
                ON gt.payment_id = payment.id 
        LEFT JOIN
            card_payment_gateway cpg
                ON cpg.id = gt.card_payment_gateway_id 
        LEFT JOIN
            card 
                ON cpg.card_id = card.id 
        WHERE
            payment.id IS NOT NULL 
            AND payment.status = 1 

        UNION

        SELECT
            'refund1_'||cast(refund.id AS text) AS sales_id,
            refund.name AS sales_name,
            refund.amount AS sales_amount,
            refund.type AS sales_type,
            refund.status AS sales_status,
            refund.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            CASE 
                WHEN refund.id IS NOT NULL THEN '' 
            END AS transaction_id,
            CASE 
                WHEN refund.type = 'credit_card' THEN last4 
                ELSE refund.reason 
            END AS payment_id,
            cpg.tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            refund.created_by AS staff_user_id,
            NULL AS device_id,
            gratuity.amount AS gratuity_amount,
            NULL AS is_voided 
        FROM
            refund 
        LEFT JOIN
            gratuity 
                ON gratuity.id = refund.gratuity_id 
        LEFT JOIN
            subscription 
                ON subscription_id = subscription.id 
        LEFT JOIN
            plan 
                ON subscription.plan_id = plan.id 
        LEFT JOIN
            customer 
                ON customer.id = plan.customer_id 
        LEFT JOIN
            provider 
                ON provider.id = provider_id 
        LEFT JOIN
            gateway_transaction gt
                ON refund.gateway_transaction_id = gt.id 
        LEFT JOIN
            card_payment_gateway cpg
                ON cpg.id = gt.card_payment_gateway_id 
        LEFT JOIN
            card 
                ON cpg.card_id = card.id 
        WHERE
            subscription_id IS NOT NULL 
            AND refund.status =20 
            AND refund.is_void = 'f'  
        
        UNION
        
        SELECT 
            'refund3_'||cast(refund.id AS text) AS sales_id, 
            refund.name AS sales_name, 
            refund.amount AS sales_amount, 
            refund.type AS sales_type, 
            refund.status AS sales_status,
            refund.created_at AS sales_created_at, 
            customer.encrypted_ref_id AS gx_customer_id, 
            provider.encrypted_ref_id AS gx_provider_id, gt.transaction_id,
            CASE 
                WHEN refund.type = 'credit_card' THEN last4 
                ELSE refund.reason 
            END AS payment_id, 
            cpg.tokenization, 
            subscription.encrypted_ref_id AS gx_subscription_id, 
            refund.created_by AS staff_user_id, 
            NULL AS device_id, 
            gratuity.amount AS gratuity_amount, 
            NULL AS is_voided
        FROM 
            refund
        LEFT JOIN 
            gratuity 
                ON gratuity.id = refund.gratuity_id
        LEFT JOIN 
            gateway_transaction gt 
                ON gateway_transaction_id = gt.id
        LEFT JOIN 
            payment 
                ON gt.payment_id = payment.id
        LEFT JOIN 
            plan 
                ON payment.plan_id = plan.id
        LEFT JOIN 
            subscription 
                ON payment.subscription_id = subscription.id
        LEFT JOIN 
            customer 
                ON customer.id = plan.customer_id
        LEFT JOIN 
            provider 
                ON provider.id = provider_id
        LEFT JOIN 
            card_payment_gateway cpg 
                ON cpg.id = gt.card_payment_gateway_id
        LEFT JOIN 
            card 
                ON cpg.card_id = card.id
        WHERE 
            refund.subscription_id IS NULL 
            AND gt.invoice_item_id IS NULL  
            AND source_object_name = 'refund' 
            AND refund.status =20 
            AND refund.is_void = 'f'

        UNION
                
        SELECT
            'tran_'||cast(gt.id AS text) AS sales_id,
            gt.name AS sales_name,
            gt.amount AS sales_amount,
            gt.type AS sales_type,
            gt.status AS sales_status,
            gt.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            transaction_id,
            last4 AS payment_id ,
            cpg.tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            NULL AS staff_user_id,
            NULL AS device_id,
            gt.gratuity_amount,
            NULL AS is_voided 
        FROM
            gateway_transaction gt
        LEFT JOIN
            invoice 
                ON invoice_id = invoice.id 
        LEFT JOIN
            invoice_item 
                ON invoice_item_id = invoice_item.id 
        LEFT JOIN
            subscription 
                ON subscription.id = invoice_item.subscription_id 
        LEFT JOIN
            plan 
                ON invoice.plan_id = plan.id 
        LEFT JOIN
            customer 
                ON customer.id = plan.customer_id 
        LEFT JOIN
            provider 
                ON provider.id = provider_id 
        LEFT JOIN
            card_payment_gateway cpg
                ON cpg.id = gt.card_payment_gateway_id 
        LEFT JOIN
            card 
                ON cpg.card_id = card.id 
        WHERE
            source_object_name  = 'card_payment_gateway' 
            AND gt.status = 20 
            AND gt.payment_id IS NULL  
            AND gt.is_voided = 'f'  

        UNION

        SELECT
            'void1_'||cast(settlement.id AS text) AS sales_id,
            gt.name AS sales_name,
            settlement.tendered * 100 AS sales_amount,
            gt.type AS sales_type,
            settlement.status AS sales_status,
            settlement.authd_date AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            gt.transaction_id,
            settlement.last_four AS payment_id,
            cpg.tokenization AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            NULL AS staff_user_id,
            NULL AS device_id,
            gt.gratuity_amount AS gratuity_amount,
            gt.is_voided::text AS is_voided 
        FROM
            settlement 
        LEFT JOIN
            gateway_transaction gt 
                ON gt.id = gateway_transaction_id 
        LEFT JOIN
            invoice 
                ON gt.invoice_id = invoice.id 
        LEFT JOIN
            invoice_item 
                ON invoice_item.id = gt.invoice_item_id 
        LEFT JOIN
            subscription 
                ON subscription.id = invoice_item.subscription_id 
        LEFT JOIN
            plan 
                ON invoice.plan_id = plan.id 
        LEFT JOIN
            customer 
                ON customer_id = customer.id 
        LEFT JOIN
            provider 
                ON provider_id = provider.id 
        LEFT JOIN
            card_payment_gateway cpg
                ON cpg.id = gt.card_payment_gateway_id 
        WHERE
            settlement.settlement_status = 'Voided' 
            AND gt.invoice_id IS NOT NULL  
            AND gt.is_voided = 'f'

        UNION

        SELECT
            'void2_'||cast(settlement.id AS text) AS sales_id,
            gt.name AS sales_name,
            settlement.tendered *100 AS sales_amount,
            gt.type AS sales_type,
            settlement.status AS sales_status,
            settlement.authd_date AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            gt.transaction_id,
            settlement.last_four AS payment_id,
            cpg.tokenization AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            NULL AS staff_user_id,
            NULL AS device_id,
            gt.gratuity_amount AS gratuity_amount,
            gt.is_voided::text AS is_voided 
        FROM
            settlement 
        LEFT JOIN
            gateway_transaction gt
                ON gt.id = gateway_transaction_id 
        LEFT JOIN
            payment 
                ON  payment_id = payment.id 
        LEFT JOIN
            subscription 
                ON subscription.id = payment.subscription_id 
        LEFT JOIN
            plan 
                ON payment.plan_id = plan.id 
        LEFT JOIN
            customer 
                ON customer_id = customer.id 
        LEFT JOIN
            provider 
                ON provider_id = provider.id 
        LEFT JOIN
            card_payment_gateway cpg
                ON cpg.id = gt.card_payment_gateway_id 
        WHERE
            settlement.settlement_status = 'Voided' 
            AND invoice_id IS NULL 
            AND gt.is_voided = 'f'

        UNION
        
        SELECT
            'void3_'||cast(refund.id AS text) AS sales_id,
            refund.name AS sales_name,
            refund.amount AS sales_amount,
            refund.type AS sales_type,
            refund.status AS sales_status,
            refund.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            CASE 
                WHEN refund.id IS NOT NULL THEN '' 
            END AS transaction_id,
            refund.reason AS payment_id,
            cpg.tokenization AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            refund.created_by AS staff_user_id,
            NULL AS device_id,
            gratuity.amount AS gratuity_amount,
            refund.is_void::text AS is_voided 
        FROM
            refund 
        LEFT JOIN
            gratuity 
                ON gratuity.id = refund.gratuity_id 
        LEFT JOIN
            gateway_transaction gt
                ON refund.gateway_transaction_id = gt.id 
        LEFT JOIN
            invoice_item 
                ON gt.invoice_item_id = invoice_item.id 
        LEFT JOIN
            subscription 
                ON invoice_item.subscription_id = subscription.id 
        LEFT JOIN
            plan 
                ON subscription.plan_id = plan.id 
        LEFT JOIN
            customer 
                ON customer.id = plan.customer_id 
        LEFT JOIN
            provider 
                ON provider.id = provider_id 
        LEFT JOIN
            card_payment_gateway cpg
                ON cpg.id = gt.card_payment_gateway_id 
        WHERE
            refund.status =20 
            AND refund.is_void = 't'  
            AND gt.payment_id IS NULL
            
        UNION
        
        SELECT 
            'void4_'||cast(refund.id AS text) AS sales_id, 
            refund.name AS sales_name, 
            refund.amount AS sales_amount, 
            refund.type AS sales_type, 
            refund.status AS sales_status, 
            refund.created_at AS sales_created_at, 
            customer.encrypted_ref_id AS gx_customer_id, 
            provider.encrypted_ref_id AS gx_provider_id,  
            CASE WHEN refund.id IS NOT NULL THEN '' END AS transaction_id,  
            refund.reason AS payment_id, 
            cpg.tokenization AS tokenization, 
            subscription.encrypted_ref_id AS gx_subscription_id, 
            refund.created_by AS staff_user_id, 
            NULL AS device_id, gratuity.amount AS gratuity_amount, 
            refund.is_void::text AS is_voided
         FROM refund
         LEFT JOIN 
             gratuity 
                 ON gratuity.id = refund.gratuity_id
         LEFT JOIN 
             subscription 
                 ON refund.subscription_id = subscription.id
         LEFT JOIN 
             gateway_transaction gt
                 ON refund.gateway_transaction_id = gt.id
         LEFT JOIN 
             payment 
                 ON payment.id = payment_id
         LEFT JOIN 
             plan 
                 ON payment.plan_id = plan.id
         LEFT JOIN 
             customer 
                 ON customer.id = plan.customer_id
         LEFT JOIN 
             provider 
                 ON provider.id = provider_id
        LEFT JOIN
            card_payment_gateway cpg
                ON cpg.id = gt.card_payment_gateway_id 
         WHERE  
             refund.status =20 
             AND refund.is_void = 't' 
             AND gt.payment_id IS NOT NULL
    ) AS a   
GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16



 -------------------------------------------SrcRDSDataNode2 product_sales-------------------------------

SELECT
        * 
    FROM
        (  SELECT
            subscription.id AS subscription_id,
            subscription.encrypted_ref_id AS k_subscirption_id,
            subscription.quantity,
            subscription.unit_name,
            subscription.remaining_payment,
            subscription.balance,
            subscription.discount_percentages,
            subscription.discount_amts,
            subscription.coupons,
            subscription.credits,
            subscription.payments,
            subscription.total_installment,
            subscription.tax,
            subscription.subtotal,
            subscription.total,
            subscription.START_date,
            subscription.END_date,
            subscription.end_count,
            subscription.END_unit,
            subscription.proration,
            subscription.auto_renewal,
            subscription.renewal_count,
            subscription.name AS subscription_name,
            subscription.created_at AS subscription_created,
            subscription.updated_at AS subscription_updated_at,
            subscription.canceled_at AS subscription_canceled_at,
            plan.id AS plan_id,
            plan.encrypted_ref_id AS k_plan_id,
            customer_id,
            customer.encrypted_ref_id AS k_customer_id,
            provider_id,
            provider.encrypted_ref_id AS k_provider_id,
            now()  
        FROM
            subscription  
        JOIN
            plan 
                ON plan_id = plan.id  
        JOIN
            customer 
                ON customer.id = customer_id  
        JOIN
            provider 
                ON provider.id = provider_id  
        WHERE
            subscription.status = 1 
            and subscription.auto_renewal = 't'  

        UNION
        
        SELECT
            subscription.id AS subscription_id,
            subscription.encrypted_ref_id AS k_subscirption_id,
            subscription.quantity,
            subscription.unit_name,
            subscription.remaining_payment,
            subscription.balance,
            subscription.discount_percentages,
            subscription.discount_amts,
            subscription.coupons,
            subscription.credits,
            subscription.payments,
            subscription.total_installment,
            subscription.tax,
            subscription.subtotal,
            subscription.total,
            subscription.START_date,
            subscription.END_date,
            subscription.end_count,
            subscription.END_unit,
            subscription.proration,
            subscription.auto_renewal,
            subscription.renewal_count,
            subscription.name AS subscription_name,
            subscription.created_at AS subscription_created,
            subscription.updated_at AS subscription_updated_at,
            subscription.canceled_at AS subscription_canceled_at,
            plan.id AS plan_id,
            plan.encrypted_ref_id AS k_plan_id,
            customer_id,
            customer.encrypted_ref_id AS k_customer_id,
            provider_id,
            provider.encrypted_ref_id AS k_provider_id,
            now()  
        FROM
            subscription  
        JOIN
            plan 
                ON plan_id = plan.id  
        JOIN
            invoice 
                on subscription.plan_id = invoice.plan_id  
        JOIN
            customer 
                ON customer.id = customer_id  
        JOIN
            provider 
                ON provider.id = provider_id  
        WHERE
            subscription.status = 1 
            AND subscription.auto_renewal = 'f' 
            AND invoice.status =20   
    )  as a   
GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33