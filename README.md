# dbt Labs - Partner Engineer - Interview Project - refactoring-sql

## Overview

Hi There,

My name is Alex Brown and in this repo is my project for dbt Labs Partner Engineering position.

In this read me I am going to go over the importance and process for refactoring the original query provided ( https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/_archive/orginal_query.sql) into a modularized ecosystem of sql models and jinja using dbt.

The original query provided is long, complex, and hard to read. This type of coding I like to refer to as a "vertical landscape" (with peaks and valleys). When programming, it is best practice to modularize your code so it is easier to understand and troubleshoot. Breaking it out into separate models, macros, and functions with dbt allows you to create linage graphs, write easier to read syntax using the "source function", test assumptions about our source data and documentation all in easy to use interface.

 ## Process

This first step I take (after copy-pasting to a new sql file) when refactoring SQL is to find the source tables. These can usually be easily identified in the `from` and `join` clauses. The source tables I identified in this original query are as follow:

```
`dbt-public.interview_task.orders`
`dbt-public.interview_task.devices`
`dbt-public.interview_task.addresses`
`dbt-public.interview_task.payments`
```

The tables identified actually have the wrong `db.info_schema`. I changed that through the interface by using `ctrl + h` and then find and replace where my find is `dbt-public.interview_task.` and replace is `dbt-public.interview_task_`. This allows me to successfully run the code.

After the source tables are identified, I staged the project to enable my-self to `source` the database tables throughout the project. To start this, I created a `_sources.yml` file (https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/staging/_sources.yml) where I can create documentation and tests four our tables.

After I set up my sources, I create `staging` models (https://github.com/alexb523/dbt-labs-refactoring-sql/tree/main/models/staging) to load tables and do very minor manipulations.

When my initial tables are staged, I create more complex models/CTE's in my intermediate folder. Here is an example of one of the more complex intermediate models: https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/marts/core/intermediate/intr_payments.sql

In this query I use the `ref` function to call my staging models `stg_ orders` and `stg_payments` and a`jinja` function to compile the same statement on multiple columns. I then aggregate those fields into the CTE `p1`. With those aggregated columns, I create the variable `gross_total_amount` and my final model where I join my orders table and use a case statement to calculated the field `gross_total_amount`.

Notices how I also use the `ref` function to call my `stg_ orders` model again here: https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/marts/core/intermediate/intr_first_order.sql