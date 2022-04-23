
with
    d as (select * from {{ source('interview_sample_data', 'interview_devices') }})

select * from d