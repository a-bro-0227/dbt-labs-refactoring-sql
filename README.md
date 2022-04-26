# dbt Labs - Partner Engineer - Interview Project - refactoring-sql

## Overview

Hi There,

My name is Alex Brown and in this repo is my project for dbt Labs Partner Engineering position.

In this `readme` I am going to go over the importance and process for refactoring the [original query provided]( https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/_archive/orginal_query.sql) into a modularized ecosystem of sql models and jinja using dbt.

The original query provided is long, complex, and hard to read. This type of coding I like to refer to as a "vertical landscape" (with peaks and valleys). When programming, it is best practice to modularize your code so it is easier to understand and troubleshoot. Breaking it out into separate models, macros, and functions with dbt allows you to create linage graphs, write easier to read syntax using the "source function", test assumptions about our source data, and easily create documentation all in easy to use interface.

 ## Process

The first step I take when refactoring a code is to copy-pasting to a new sql file. I want to leave the orginal query in-tack so I am able to reference it and use it for checking throughout the project. I'll talk more about this in the audit section.

After copy-pasting to a new sql file, I always start with finding the source tables in the SQL query I am going to refactor. These can usually be identified by the `from` and `join` clauses. The source tables I identified in the original query are as follows:

```
`dbt-public.interview_task.orders`
`dbt-public.interview_task.devices`
`dbt-public.interview_task.addresses`
`dbt-public.interview_task.payments`
```

The tables identified actually have the wrong `db.info_schema`. I changed that through the dtb interface by clicking `ctrl + h` which brings up find and replace feature. I set my find to `dbt-public.interview_task.` and my replace to `dbt-public.interview_task_`. This allows me to successfully run the code.

After the source tables are identified, I stage the project to enable my-self to `source` the database tables throughout the project. To start this, I created a [`_sources.yml`](https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/staging/_sources.yml) file where I can create documentation and tests four our tables.

After I set up my sources, I create [`staging` models](https://github.com/alexb523/dbt-labs-refactoring-sql/tree/main/models/staging) to load tables and do very minor manipulations.

When my initial tables are staged, I can create more complex models/CTE's in my intermediate folder. Here is an example of one of the more complex intermediate models: [`intr_payments.sql`](https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/marts/core/intermediate/intr_payments.sql)

In this query I use the `ref` function to call my staging models `stg_ orders` and `stg_payments` and a`jinja` function to compile the same statement on multiple columns. I then aggregate those fields into the CTE `p1`. With those aggregated columns, I create the variable `gross_total_amount` and my final model where I join my orders table and use a case statement to calculated the field `gross_total_amount`.

Notices how I also use the `ref` function to call my [`stg_ orders`] model: https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/marts/core/intermediate/intr_first_order.sql
