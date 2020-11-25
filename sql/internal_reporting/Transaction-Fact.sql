select 
    id as transaction_id,
    status, 
    user_id, 
    payment_method,
    amount, 
    device_id,
    created_at,
    updated_at, 
    created_by,
    gratuity_amount, 
    customer_type,
    payment_detail
from transactions