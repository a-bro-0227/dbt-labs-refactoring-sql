
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.stg_devices 
  
   as (
    with
    d as (select * from raw.interview_sample_data.interview_devices)

select * from d
  );
