-- Grain: one row per item per order
with source as (
    select * from {{ source('raw', 'raw_order_items') }}
)
select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date    as shipping_limit_at,
    price,
    freight_value
from source