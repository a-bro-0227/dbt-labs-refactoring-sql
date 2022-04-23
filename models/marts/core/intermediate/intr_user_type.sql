with
    o as (select * from {{ ref('stg_orders') }}),
    fo as (select * from {{ ref('intr_first_order') }}),
    ut as (
        select
            o.order_id,
            case
                when fo.first_order_id = o.order_id then 'new'
                else 'repeat'
            end as user_type
        from o
        left join fo
            on o.user_id = fo.user_id

    )

select * from ut

