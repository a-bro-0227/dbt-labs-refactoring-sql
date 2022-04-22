
{% set cols = ['tax_amount_cents', 'amount_cents', 'amount_shipping_cents'] %}

with
    o as (select * from {{ ref('stg_orders') }} ),
    p as (select * from {{ source('interview_sample_data', 'interview_payments') }}),

    p1 as (
    select
        order_id,

        {%- for c in cols %}
            sum(case when status = 'completed' then {{c}} else 0 end) as gross_{{c}},
        {%- endfor %}

        sum(case
            when status = 'completed' then tax_amount_cents + amount_cents + amount_shipping_cents else 0
            end
            ) as gross_total_amount_cents
    from p
    group by order_id
    ),

    pa as (

        select
            p1.*,
            case
                when o.currency = 'usd' then o.amount_total_cents
                else p1.gross_total_amount_cents
            end as total_amount_cents
        from o
        left join p1
        on o.order_id = p1.order_id
    )

select * from pa
