SELECT

sub.id AS subscription_id,
sub.status,
sub.cycles,
sub.quantity,
sub.is_subscription,
sub.period_unit,
sub.period,
gx_subscription_id,
sub.plan_id,
sub.offering_id,
sub.type AS subscription_type,
ad_hoc_offering_id

FROM subscription sub
left join ad_hoc_offering ad on ad.id = ad_hoc_offering_id
