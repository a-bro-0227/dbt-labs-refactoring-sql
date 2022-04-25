select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select *
from raw.interview_sample_data.interview_orders
where order_id is null



      
    ) dbt_internal_test