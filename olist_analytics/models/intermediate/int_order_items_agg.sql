-- Grain: one row per order. Item-level facts aggregated.
with items as (
    select * from {{ ref('stg_order_items') }}
),

aggregated as (
    select
        order_id,
        count(*)                      as item_count,
        count(distinct seller_id)     as seller_count,
        sum(price)                    as items_price_total,
        sum(freight_value)            as freight_total
    from items
    group by order_id
)

select * from aggregated