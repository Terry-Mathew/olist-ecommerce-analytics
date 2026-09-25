-- Staging model: clean and standardize raw orders
-- Grain: one row per order

with source as (
    select * from {{ source('raw', 'raw_orders') }}
),

renamed as (
    select
        order_id                              as order_id,
        customer_id                           as customer_id,
        lower(order_status)                   as order_status,
        order_purchase_timestamp              as purchased_at,
        order_approved_at                     as approved_at,
        order_delivered_carrier_date          as shipped_at,
        order_delivered_customer_date         as delivered_at,
        order_estimated_delivery_date         as estimated_delivery_at
    from source
)

select * from renamed