USE `bitel_ecommerce`;

ALTER TABLE tbl_order ADD COLUMN store_id INT(11) NULL AFTER idschedule_id;
