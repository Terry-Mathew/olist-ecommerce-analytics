-- Grain: one row per review. Note: an order can have more than one review.
with source as (
    select * from {{ source('raw', 'raw_order_reviews') }}
)
select
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date     as reviewed_at,
    review_answer_timestamp  as review_answered_at
from source