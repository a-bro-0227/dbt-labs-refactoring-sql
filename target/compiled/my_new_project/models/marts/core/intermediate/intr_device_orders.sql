with
    d as ((select * from PE_ALEXANDER_B.abrown_dbt_interview.stg_devices)),

    d1 as (
        select distinct
            d.order_id,
            first_value(d.device) over (
                partition by d.type_id
                order by
                d.created_at rows between unbounded preceding
                and unbounded following
            ) as device
        from d
    ),

    do as (
        select
            d.*,
            d1.device,
            case
                when d.device = 'web' then 'desktop'
                when d.device in ('ios-app', 'android-app') then 'mobile-app'
                when d.device in ('mobile', 'tablet') then 'mobile-web'
                when nullif(d.device, '') is null then 'unknown'
                else 'error'
            end as purchase_device_type
        from d
        left join d1
            on d.order_id = d1.order_id
        
    )

select * from do