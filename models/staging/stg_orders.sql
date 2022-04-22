with
    o as (select * from {{ source('interview_sample_data', 'interview_orders') }})

select * from o