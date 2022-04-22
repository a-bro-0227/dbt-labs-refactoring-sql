
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.stg_device_orders 
  
   as (
    with
    d as (select * from raw.interview_sample_data.interview_devices),

    do as (
    select distinct
        cast(d.type_id as float) as order_id,
        first_value(d.device) over (
        partition by d.type_id
        order by
        d.created_at rows between unbounded preceding
        and unbounded following
        ) as device,
        case
            when d.device = 'web' then 'desktop'
            when d.device in ('ios-app', 'android-app') then 'mobile-app'
            when d.device in ('mobile', 'tablet') then 'mobile-web'
            when nullif(d.device, '') is null then 'unknown'
            else 'error'
        end as purchase_device_type
    from d
    where d.type = 'order'
    )

select * from do
  );
