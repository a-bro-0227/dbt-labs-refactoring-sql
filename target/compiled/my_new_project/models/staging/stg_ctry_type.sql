with
    a as (select * from raw.interview_sample_data.interview_addresses),

 ct as (
    select
      a.order_id,
      case
        when a.country_code is null then 'null country'
        when a.country_code = 'us' then 'us'
        when a.country_code != 'us' then 'international'
      end as country_type
    from a
  )

select * from ct