USE `bitel_ecommerce`;

ALTER TABLE tbl_promo MODIFY promo_discount DECIMAL(6,6) DEFAULT NULL;

UPDATE tbl_promo SET active = 0 WHERE product_variation_id IS NULL AND allow_all_variations = 1;