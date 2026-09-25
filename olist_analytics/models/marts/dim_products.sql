-- Dimension: one row per product, with English category names.
-- Left join translation: products with null categories are KEPT (known issue, documented).
with products as (
    select * from {{ ref('stg_products') }}
),

translation as (
    select * from {{ ref('stg_category_translation') }}
),

final as (
    select
        p.product_id,
        t.product_category_name_en     as product_category,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm,
        p.product_photos_qty
    from products p
    left join translation t
        on p.product_category_name = t.product_category_name
)

select * from final