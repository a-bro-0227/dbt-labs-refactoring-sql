
-- list tables
{% set tables = ['orders', 'devices', 'orders', 'addresses', 'payments'] %}

{#

-- basic test
{% for t in tables %}
    table name is: raw.interview_sample_data.interview_{{t}}
{% endfor %}

-- testing tables
{%- for t in tables %}
    {{t}} as ( select * from raw.interview_sample_data.interview_{{t}} ),
{%- endfor %}



{%- for t in tables %}
    {{t}} as select * from { source('interview_sample_data', 'interview_'{{t}}) }
{%- endfor %}

#}

select * from {{ source('interview_sample_data', 'interview_devices') }}
