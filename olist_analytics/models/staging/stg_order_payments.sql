-- Grain: one row per payment. Orders can have many rows.
with source as (
    select * from {{ source('raw', 'raw_order_payments') }}
)
select
    order_id,
    payment_sequential,
    lower(payment_type)      as payment_type,
    payment_installments,
    payment_value
from source