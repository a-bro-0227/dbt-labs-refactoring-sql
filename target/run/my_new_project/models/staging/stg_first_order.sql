
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.stg_first_order 
  
   as (
    with
    o as (select * from raw.interview_sample_data.interview_orders),

    fo as (
        select
            fo.user_id,
            min(fo.order_id) as first_order_id
        from o as fo
        where fo.status != 'cancelled'
        group by fo.user_id
    )

select * from fo
  );
