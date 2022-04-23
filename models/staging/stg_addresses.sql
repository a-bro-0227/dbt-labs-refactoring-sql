
with
    a as (select * from {{ source('interview_sample_data', 'interview_addresses')}})

select * from a

