
    
    

select
    order_id as unique_field,
    count(*) as n_records

from PE_ALEXANDER_B.abrown_dbt_interview.intr_first_order
where order_id is not null
group by order_id
having count(*) > 1


