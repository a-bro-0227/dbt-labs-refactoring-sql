with
    d as (select * from raw.interview_sample_data.interview_devices)

select cast(d.type_id as float) as order_id, * from d where d.type = 'order'