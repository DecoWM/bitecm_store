use bitel_ecommerce;

set sql_mode=(select replace(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

delete o from tbl_product_variation as o 
left join (
  select max(product_variation_id) as product_variation_id
  from tbl_product_variation
  where variation_type_id = 2
  group by product_id, plan_id, affiliation_id, contract_id
  order by product_variation_id
) as p on o.`product_variation_id` = p.`product_variation_id`
where o.`variation_type_id` = 2
  and p.`product_variation_id` is null;

set sql_mode=(select concat(@@sql_mode, ',ONLY_FULL_GROUP_BY'));