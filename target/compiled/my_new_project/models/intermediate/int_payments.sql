

with
    o as (select * from PE_ALEXANDER_B.abrown_dbt_interview.stg_orders ),
    p as (select * from raw.interview_sample_data.interview_payments),

    p1 as (
    select
        order_id,
            sum(case when status = 'completed' then tax_amount_cents else 0 end) as gross_tax_amount_cents,
            sum(case when status = 'completed' then amount_cents else 0 end) as gross_amount_cents,
            sum(case when status = 'completed' then amount_shipping_cents else 0 end) as gross_amount_shipping_cents,

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