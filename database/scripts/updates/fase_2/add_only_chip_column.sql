USE `bitel_ecommerce`;

ALTER TABLE tbl_plan ADD COLUMN plan_only_chip tinyint(1) NULL DEFAULT 0 AFTER plan_price;
UPDATE tbl_plan SET plan_only_chip = 0;