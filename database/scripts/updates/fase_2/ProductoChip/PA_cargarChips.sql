DELIMITER $$

USE `bitel_ecommerce`$$

CREATE PROCEDURE PA_cargarChips()
BEGIN
  DECLARE _product_id INT(11);

  -- insertar variaciones del chip
  -- variation_type_id: 1-2 1=postpago, 2=prepago
  -- product_id: 4
  -- plan_id: 1-13
  -- affiliation_id: 1-3
  -- contract_id: 1

  SELECT product_id INTO _product_id FROM tbl_product WHERE category_id = 4 LIMIT 1;

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
