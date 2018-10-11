USE `bitel_ecommerce`;

ALTER TABLE tbl_plan_infocomercial ADD COLUMN weight TINYINT DEFAULT 0 AFTER plan_infocomercial_flag_cantidad;