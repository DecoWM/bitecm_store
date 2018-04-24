USE bitel_ecommerce;

ALTER TABLE tbl_product_variation ADD COLUMN best_plan TINYINT(1) DEFAULT 0 AFTER active;