
-- import cte's
/*

step notes:

pull out source tables into cte's
create a _source.yml file in order to source those tables (which makes a pretty, more inuitive dag)
extract cte's we found in query:
    `dbt-public.interview_task.orders` o
    `dbt-public.interview_task.devices` d
    `dbt-public.interview_task.orders` as fo -- potentially redunant
    `dbt-public.interview_task.addresses` oa 
    `dbt-public.interview_task.payments`

a couple of errors that were resolved in the set up:
  data type `int64` to `float`
  rename raw source tables from `dbt-public.interview_` to: `raw.interview_sample_data.interview_`
  transform to lower case (using command pallet -- F1)
    
*/


-- logical cte's
-- final cte's
-- select statement

select
  *,
  amount_total_cents / 100 as amount_total,
  gross_total_amount_cents/ 100 as gross_total_amount,
  total_amount_cents/ 100 as total_amount,
  gross_tax_amount_cents/ 100 as gross_tax_amount,
  gross_amount_cents/ 100 as gross_amount,
  gross_shipping_amount_cents/ 100 as gross_shipping_amount 

from (
    
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
      case
        when oa.country_code is null then 'null country'
        when oa.country_code = 'us' then 'us'
        when oa.country_code != 'us' then 'international'
      end as country_type,
      o.shipping_method,
      case
        when d.device = 'web' then 'desktop'
        when d.device in ('ios-app', 'android-app') then 'mobile-app'
        when d.device in ('mobile', 'tablet') then 'mobile-web'
        when nullif(d.device, '') is null then 'unknown'
        else 'error'
      end as purchase_device_type,
      d.device as purchase_device,
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
    from raw.interview_sample_data.interview_orders o
    left join (
        select
          distinct cast(d.type_id as float) as order_id,
          first_value(d.device) over (
            partition by d.type_id
            order by
              d.created_at rows between unbounded preceding
              and unbounded following
          ) as device
        from raw.interview_sample_data.interview_devices d
        where d.type = 'order'
    ) d on d.order_id = o.order_id
    left join (
        select
          fo.user_id,
          min(fo.order_id) as first_order_id
        from raw.interview_sample_data.interview_orders as fo
        where
          fo.status != 'cancelled'
        group by
          fo.user_id
      ) fo on o.user_id = fo.user_id
    left join raw.interview_sample_data.interview_addresses oa 
      on oa.order_id = o.order_id
    left join (
        select
          order_id,
          sum(
            case
              when status = 'completed' then tax_amount_cents
              else 0
            end
          ) as gross_tax_amount_cents,
          sum(
            case
              when status = 'completed' then amount_cents
              else 0
            end
          ) as gross_amount_cents,
          sum(
            case
              when status = 'completed' then amount_shipping_cents
              else 0
            end
        ) as gross_shipping_amount_cents,
          sum(
            case
              when status = 'completed' then tax_amount_cents + amount_cents + amount_shipping_cents
              else 0
            end
          ) as gross_total_amount_cents
        from raw.interview_sample_data.interview_payments
        group by order_id
    ) pa on pa.order_id = o.order_id
  )

