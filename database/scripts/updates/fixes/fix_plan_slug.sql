USE `bitel_ecommerce`;
UPDATE tbl_plan SET plan_slug = concat(left(plan_slug,length(plan_slug)-2),'_',right(plan_slug,2)) WHERE plan_id IN (16,19,22,25,28);
