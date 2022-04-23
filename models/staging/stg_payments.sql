

with
    p as (select * from {{ source('interview_sample_data', 'interview_payments') }})

select * from p