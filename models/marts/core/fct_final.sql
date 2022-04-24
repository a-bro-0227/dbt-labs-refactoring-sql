
with
  o  as (select * from {{ ref('stg_orders') }}),
  do as (select * from {{ ref('intr_device_orders') }}),
  ct as (select * from {{ ref('intr_ctry_type') }}),
  pa as (select * from {{ ref('intr_payments') }}),
  ut as (select * from {{ ref('intr_user_type')}}),

  final as (

    select
        o.order_id,
        o.user_id,
        o.created_at,
        o.updated_at,
        o.shipped_at,
        o.currency,
        o.order_status,
        o.order_status_category,
        ct.country_type,
        o.shipping_method,
        do.purchase_device_type,
        do.device as purchase_device,
        ut.user_type,
        o.amount_total_cents,
        pa.gross_tax_amount,
        pa.gross_amount,
        pa.gross_amount_shipping,
        pa.gross_total_amount

      from o

      left join do
        on do.order_id = o.order_id

      left join ut
        on o.order_id = ut.order_id

      left join ct 
        on ct.order_id = o.order_id

      left join pa
        on pa.order_id = o.order_id
  )

select * from final