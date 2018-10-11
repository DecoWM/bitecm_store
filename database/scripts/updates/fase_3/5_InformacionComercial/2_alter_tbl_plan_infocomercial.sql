USE `bitel_ecommerce`;

ALTER TABLE tbl_plan_infocomercial ADD COLUMN tipo TINYINT DEFAULT 0 AFTER weight;
