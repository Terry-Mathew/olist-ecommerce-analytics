-- Grain: one row per order. Payments aggregated.
-- Raw payments can have multiple rows per order (installments, split types).
with payments as (
    select * from {{ ref('stg_order_payments') }}
),

aggregated as (
    select
        order_id,
        sum(payment_value)            as payment_total,
        max(payment_installments)     as max_installments
    from payments
    group by order_id
)

select * from aggregated