
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.stg_payments 
  
   as (
    with
    p as (select * from raw.interview_sample_data.interview_payments)

select * from p
  );
