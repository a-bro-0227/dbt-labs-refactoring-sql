
with
    p as (select * from {{ source('interview_sample_data', 'interview_payments')}}),

    pa as (
    select
        order_id,
    sum(case
            when status = 'completed' then tax_amount_cents else 0
        end
        ) as gross_tax_amount_cents,
    sum(case
            when status = 'completed' then amount_cents else 0
        end
        ) as gross_amount_cents,
    sum(case
            when status = 'completed' then amount_shipping_cents else 0
        end
        ) as gross_shipping_amount_cents,
    sum(case
            when status = 'completed' then tax_amount_cents + amount_cents + amount_shipping_cents else 0
        end
        ) as gross_total_amount_cents
    from p
    group by order_id
    )

select * from pa
