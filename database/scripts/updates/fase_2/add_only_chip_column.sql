USE `bitel_ecommerce`;

ALTER TABLE tbl_plan ADD COLUMN plan_only_chip tinyint(1) NOT NULL AFTER plan_price;
UPDATE tbl_plan SET plan_only_chip = 0;