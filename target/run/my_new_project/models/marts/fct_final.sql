
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.fct_final 
  
   as (
    with
  o as (select * from raw.interview_sample_data.interview_orders),
  do as ( select * from PE_ALEXANDER_B.abrown_dbt_interview.stg_device_orders ),
  fo as ( PE_ALEXANDER_B.abrown_dbt_interview.stg_first_order ),
  pa as ( PE_ALEXANDER_B.abrown_dbt_interview.stg_payments ),
  ct as ( PE_ALEXANDER_B.abrown_dbt_interview.stg_ctry_type ),

  -- final cte's

  final as (

    select
        o.order_id,
        o.user_id,
        o.created_at,
        o.updated_at,
        o.shipped_at,
        o.currency,
        o.status as order_status,
        case
          when o.status in (
            'paid',
            'completed',
            'shipped'
          ) then 'completed'
          else o.status
        end as order_status_category,
        ct.country_type,
        o.shipping_method,
        do.purchase_device_type,
        do.device as purchase_device,
        case
          when fo.first_order_id = o.order_id then 'new'
          else 'repeat'
        end as user_type,
        o.amount_total_cents,
        pa.gross_total_amount_cents,
        case
          when o.currency = 'usd' then o.amount_total_cents
          else pa.gross_total_amount_cents
        end as total_amount_cents,
        pa.gross_tax_amount_cents,
        pa.gross_amount_cents,
        pa.gross_shipping_amount_cents
      from o

      left join do
        on do.order_id = o.order_id

      left join fo
        on o.user_id = fo.user_id

      left join ct 
        on ct.order_id = o.order_id

      left join pa
        on pa.order_id = o.order_id
  )

-- select statement


select
  *,
  amount_total_cents / 100 as amount_total,
  gross_total_amount_cents/ 100 as gross_total_amount,
  total_amount_cents/ 100 as total_amount,
  gross_tax_amount_cents/ 100 as gross_tax_amount,
  gross_amount_cents/ 100 as gross_amount,
  gross_shipping_amount_cents/ 100 as gross_shipping_amount

from final
  );
