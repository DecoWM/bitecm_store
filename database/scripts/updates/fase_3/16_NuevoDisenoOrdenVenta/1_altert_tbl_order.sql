USE `bitel_ecommerce`;

ALTER TABLE tbl_order DROP FOREIGN KEY fk_tbl_order_tbl_district_billing;
ALTER TABLE tbl_order DROP INDEX fk_tbl_order_tbl_district01_idx;
ALTER TABLE tbl_order MODIFY COLUMN billing_phone VARCHAR(20) NULL;