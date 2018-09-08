USE `bitel_ecommerce`;
UPDATE tbl_plan SET plan_slug = concat(left(plan_slug,5),'-plus',mid(plan_slug,6,(length(plan_slug)-2)-5),'_',right(plan_slug,2)) WHERE plan_id IN (40,49,52,55,58);