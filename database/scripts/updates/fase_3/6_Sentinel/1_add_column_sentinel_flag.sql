USE `bitel_ecommerce`;

ALTER TABLE tbl_product ADD COLUMN product_sentinel TINYINT(1) NOT NULL DEFAULT 0 AFTER product_priority;

UPDATE tbl_product SET product_sentinel = 0;
