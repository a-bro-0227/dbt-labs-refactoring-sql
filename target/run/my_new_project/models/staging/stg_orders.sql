
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.stg_orders 
  
   as (
    with
    o as (select * from raw.interview_sample_data.interview_orders)

select * from o
  );
