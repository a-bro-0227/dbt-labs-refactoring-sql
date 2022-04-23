
    round(sum(case when status = 'completed' then tax_amount_cents else 0 end) / 100, 2) as gross_tax_amount_cents,
    round(sum(case when status = 'completed' then amount_cents else 0 end) / 100, 2) as gross_amount_cents,
    round(sum(case when status = 'completed' then amount_shipping_cents else 0 end) / 100, 2) as gross_amount_shipping_cents,