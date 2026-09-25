-- Grain: one row per order. Joins customer + item + payment facts.
-- Business rules:
--   * delivery metrics computed ONLY for delivered orders (structural nulls excluded by design)
--   * is_late = delivered after the promised estimated date
with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

item_agg as (
    select * from {{ ref('int_order_items_agg') }}
),

payment_agg as (
    select * from {{ ref('int_order_payments_agg') }}
),

enriched as (
    select
        o.order_id,
        o.customer_id,
        c.customer_state,
        c.customer_city,
        o.order_status,
        o.purchased_at,
        o.approved_at,
        o.shipped_at,
        o.delivered_at,
        o.estimated_delivery_at,

        -- delivery SLA metrics (null unless delivered)
        case when o.order_status = 'delivered'
             then datediff('day', o.purchased_at, o.delivered_at)
        end                                          as delivery_days,

        case when o.order_status = 'delivered'
                  and o.delivered_at > o.estimated_delivery_at
             then true
             when o.order_status = 'delivered'
             then false
        end                                          as is_late,

        -- rolled-up facts
        coalesce(i.item_count, 0)                    as item_count,
        coalesce(i.seller_count, 0)                  as seller_count,
        coalesce(i.items_price_total, 0)             as items_price_total,
        coalesce(i.freight_total, 0)                 as freight_total,
        coalesce(p.payment_total, 0)                 as payment_total

    from orders o
    left join customers   c on o.customer_id = c.customer_id
    left join item_agg    i on o.order_id    = i.order_id
    left join payment_agg p on o.order_id    = p.order_id
)

select * from enriched