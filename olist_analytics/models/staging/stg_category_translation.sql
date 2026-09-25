-- Grain: one row per category.
-- Note: RAW was originally ingested with the header row as data (72 rows,
-- machine-named columns C1/C2). Root cause fixed by re-ingesting with
-- SKIP_HEADER enabled. No downstream workaround required.

with source as (
    select * from {{ source('raw', 'raw_category_translation') }}
),

renamed as (
    select
        product_category_name,
        product_category_name_english    as product_category_name_en
    from source
)

select * from renamed