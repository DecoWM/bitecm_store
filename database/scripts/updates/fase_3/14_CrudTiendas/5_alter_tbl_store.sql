USE `bitel_ecommerce`;

ALTER TABLE tbl_store ADD COLUMN district_id INT(11) NOT NULL DEFAULT 1 AFTER store_id;
ALTER TABLE tbl_store ADD COLUMN store_slug VARCHAR(12) NULL AFTER store_name;
ALTER TABLE tbl_store DROP COLUMN zip_code;
ALTER TABLE tbl_store ADD COLUMN store_ubigeo VARCHAR(10) NULL AFTER store_slug;

ALTER TABLE tbl_store ADD CONSTRAINT fk_tbl_store_tbl_district FOREIGN KEY (district_id) REFERENCES tbl_district (district_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
