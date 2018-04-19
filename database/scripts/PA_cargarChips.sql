DELIMITER $$

USE `bitel_ecommerce`$$

CREATE PROCEDURE PA_cargarChips()
BEGIN
DECLARE _brand_id INT(11);
DECLARE _product_id INT(11);

-- insertar en tabla brand
INSERT INTO tbl_brand (brand_name, brand_slug, weight, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES('Bitel','Bitel',1,NOW(),NULL,NULL,1,NULL,NULL,1);

SELECT MAX(brand_id) INTO _brand_id FROM tbl_brand;

-- insertar el producto 
INSERT INTO tbl_product (category_id, brand_id, product_model, product_image_url, product_keywords, product_price, product_description, product_general_specifications, product_data_sheet, product_external_memory, product_internal_memory, product_screen_size, product_camera_1, product_camera_2, product_camera_3, product_camera_4, product_processor_name, product_processor_power, product_processor_cores, product_band, product_radio, product_wlan, product_bluetooth, product_os, product_gps, product_battery, product_slug, product_tag, product_priority, created_at, updated_at, deleted_at, publish_at, created_by, updated_by, deleted_by, publish_by, active)
VALUES (4, _brand_id, 'iChip','productos/chipbitel.jpg',NULL,1.00,NULL,NULL,'data_sheets/Ficha_tecnica_SAMSUNG_GALAXY_J7 PRIME.pdf',128,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chip-bitel',NULL,1,NOW(),NULL,NULL,NOW(),1,NULL,NULL,1,1);

-- insertar variaciones del chip
-- variation_type_id: 1-2 1=postpago, 2=prepago
-- product_id: 4
-- plan_id: 1-13
-- affiliation_id: 1-3
-- contract_id: 1

SELECT MAX(product_id) INTO _product_id FROM tbl_product;

-- CHIP POSTPAGO
INSERT INTO tbl_product_variation (variation_type_id, product_id, plan_id, affiliation_id, contract_id, product_variation_price, reason_code, product_package, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (2,_product_id,1,1,1,1.00,NULL,NULL,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_product_variation (variation_type_id, product_id, plan_id, affiliation_id, contract_id, product_variation_price, reason_code, product_package, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (2,_product_id,4,1,1,1.00,NULL,NULL,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_product_variation (variation_type_id, product_id, plan_id, affiliation_id, contract_id, product_variation_price, reason_code, product_package, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (2,_product_id,5,1,1,1.00,NULL,NULL,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_product_variation (variation_type_id, product_id, plan_id, affiliation_id, contract_id, product_variation_price, reason_code, product_package, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (2,_product_id,8,1,1,1.00,NULL,NULL,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_product_variation (variation_type_id, product_id, plan_id, affiliation_id, contract_id, product_variation_price, reason_code, product_package, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (2,_product_id,1,2,1,1.00,NULL,NULL,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_product_variation (variation_type_id, product_id, plan_id, affiliation_id, contract_id, product_variation_price, reason_code, product_package, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (2,_product_id,1,3,1,1.00,NULL,NULL,NOW(),NULL,NULL,1,NULL,NULL,1);

-- insertar en la tabla stock
INSERT INTO tbl_stock_model (product_id, color_id, stock_model_code, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (_product_id,NULL,'053039',NOW(),NULL,NULL,1,NULL,NULL,1);

-- CHIP PREPAGO
INSERT INTO tbl_product_variation (variation_type_id, product_id, plan_id, affiliation_id, contract_id, product_variation_price, reason_code, product_package, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES (1,_product_id,14,NULL,NULL,1.00,NULL,NULL,NOW(),NULL,NULL,1,NULL,NULL,1);

END$$

DELIMITER ;

CALL PA_cargarChips();