-- Fact table: one row per order (grain: order).
-- Measures: delivery SLA, item counts, monetary totals.
-- Keys: order_id (PK), customer_id, plus first-seller for light seller slicing.
with enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

items as (
    select * from {{ ref('stg_order_items') }}
),

-- one representative seller per order (orders can span multiple sellers)
primary_seller as (
    select
        order_id,
        seller_id,
        row_number() over (
            partition by order_id
            order by price desc          -- seller of the priciest item
        ) as seller_rank
    from items
),

final as (
    select
        e.order_id,
        e.customer_id,
        ps.seller_id                     as primary_seller_id,
        e.order_status,
        e.customer_state,
        e.customer_city,
        e.purchased_at,
        e.delivered_at,
        e.estimated_delivery_at,
        e.delivery_days,
        e.is_late,
        e.item_count,
        e.seller_count,
        e.items_price_total,
        e.freight_total,
        e.payment_total
    from enriched e
    left join primary_seller ps
        on e.order_id = ps.order_id
       and ps.seller_rank = 1
)

select * from final