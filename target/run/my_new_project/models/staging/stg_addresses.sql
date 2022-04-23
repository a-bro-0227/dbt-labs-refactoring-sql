
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.stg_addresses 
  
   as (
    with
    a as (select * from raw.interview_sample_data.interview_addresses)

select * from a
  );
