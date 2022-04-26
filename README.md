# dbt Labs - Partner Engineer - Interview Project - refactoring-sql

## overview

Hi There,

My name is Alex Brown and in this repo is my project for dbt Labs Partner Engineering position.

In this `readme` I am going to go over the importance and process for refactoring the [original query provided]( https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/_archive/orginal_query.sql) into a modularized ecosystem of sql models and jinja using dbt.

The original query provided is long, complex, and hard to read. This type of coding I like to refer to as a "vertical landscape" (with peaks and valleys). When programming, it is best practice to modularize your code so it is easier to understand and troubleshoot. Breaking it out into separate models, macros, and functions with dbt allows you to create linage graphs, write easier to read syntax, test assumptions about data, and easily create documentation all in easy to use interface.

 ## process

### staging and sourcing

The first step I take when refactoring a code is to copy-pasting to a new sql file. It is best practice to leave the original query in-tack so I am able to reference it often and use it for checking throughout the project. *I'll talk more about this in the audit section.*

After copy-pasting to a new sql file, I always start with finding the source tables in the SQL query I am going to refactor. These can usually be identified by the `from` and `join` clauses. The source tables I identified in the original query are as follows:

```
`dbt-public.interview_task.orders`
`dbt-public.interview_task.devices`
`dbt-public.interview_task.addresses`
`dbt-public.interview_task.payments`
```

The tables identified actually have the wrong `db.info_schema`. That can be changed through the dbt interface by clicking `ctrl + h` which brings up find and replace feature. I set my find to `dbt-public.interview_task.` and my replace to `dbt-public.interview_task_`. This allows me to successfully run the code.

After the source tables are identified, I stage the project to enable my-self to `source` the database tables throughout the project. This is done in the [`_sources.yml`](https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/staging/_sources.yml) file. In the `source.yml` file you can create documentation and tests associated with your source tables.

Sourcing your tables also enables the use of the dbt `{{ source }}` function. Sourcing your tables 
creates a dependency between the model and the source table. Tables sourced from the database are identified with green in the picture below

*picture coming*

After the `_sources.yml` is set up, I create [`staging` models](https://github.com/alexb523/dbt-labs-refactoring-sql/tree/main/models/staging) to *load* tables from the data warehouse. Very minor manipulations and standardizing are done at this step.

### intermediate

After the initial staging, I use [`intermediate` models](https://github.com/alexb523/dbt-labs-refactoring-sql/tree/main/models/marts/core/intermediate) to create more complex models/CTE's.

Here is an example of one of the more complex intermediate models: [`intr_payments.sql`](https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/marts/core/intermediate/intr_payments.sql)

In this query I use the `ref` function to call my staging models [`stg_orders`](https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/staging/stg_orders.sql) and [`stg_payments`](https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/staging/stg_payments.sql) and a `jinja` function to compile the same statement on multiple columns. I then aggregate those fields into the CTE `p1`. With those aggregated columns, I create the variable `gross_total_amount` and my final model where I join my orders table and use a case statement to calculated the field `gross_total_amount`.

*Notices how I also use the `ref` function to call my [`intr_first_orders`](https://github.com/alexb523/dbt-labs-refactoring-sql/blob/main/models/marts/core/intermediate/intr_first_order.sql) model.*

#### jinjia statement
