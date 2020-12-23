with staff_details as
(
    select
    staff_data.id,
    staff_data.created_at,
    staff_data.updated_at,
    staff_data.deprecated_at,
    staff_data.status,
    user_id,
    commission,
    title,
    firstname,
    lastname,
    role,
    email,
    mobile,
    organization_id
    FROM kronos_opul.staff_data
    JOIN kronos_opul.users on user_id = users.id
)
select * from staff_details
