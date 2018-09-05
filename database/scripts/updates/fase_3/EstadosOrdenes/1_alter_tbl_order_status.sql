USE `bitel_ecommerce`;

ALTER TABLE tbl_order_status ADD COLUMN weight TINYINT(1) AFTER order_status_name;

ALTER TABLE tbl_order_status ADD COLUMN weight2 TINYINT(1) AFTER weight;