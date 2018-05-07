SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_productCountPrepago`$$

CREATE PROCEDURE `PA_productCountPrepago`(
  IN product_categories VARCHAR(200),
  IN product_brands VARCHAR(200),
  IN plan_id INT,
  IN product_price_ini DECIMAL(6,2),
  IN product_price_end DECIMAL(6,2),
  IN product_string_search VARCHAR(255),
  IN product_tag VARCHAR(255),
  IN product_ignore_ids VARCHAR(50)
)
BEGIN
  --
  DECLARE variation_type_id INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  -- conditional string query
  SET variation_type_id = 1; -- Prepaid
  SET cad_condition = "";
  -- checking null values
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET plan_id = IFNULL(plan_id, 14); -- set value 14 (Prepago B-Voz) if null
  SET product_categories = IFNULL(product_categories, ''); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');
  SET product_tag = IFNULL(product_tag, '');
  SET product_ignore_ids = IFNULL(product_ignore_ids,'');
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, IFNULL(PRM.promo_price,((1-PRM.promo_discount) * PRD_VAR.product_variation_price)), IFNULL(PRM.promo_price,product_variation_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, IFNULL(PRM.promo_price,((1-PRM.promo_discount) * PRD_VAR.product_variation_price)), IFNULL(PRM.promo_price,product_variation_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, IFNULL(PRM.promo_price,((1-PRM.promo_discount) * PRD_VAR.product_variation_price)), IFNULL(PRM.promo_price,product_variation_price)) <= ',product_price_end);
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;
  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (product_categories <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id IN (', product_categories, ')');
  END IF;
  -- conditional filter for plan
  IF (plan_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PLN.plan_id = ', plan_id);
  ELSE
        -- conditional best_plan = TODOS
	IF (plan_id = 0) THEN
		SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.best_plan = 1');
	END IF;  
  END IF;
  -- conditional filter for tag product (nuevo / destacado)
  IF (product_tag <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_tag IN (', product_tag, ')');
    SET cad_condition = CONCAT(cad_condition, ' AND STM.stock_model_id IS NOT NULL');
  END IF;
  -- conditional filter for ignore ids products and not stock
  IF (product_ignore_ids <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_id NOT IN (', product_ignore_ids,')');
    SET cad_condition = CONCAT(cad_condition, ' AND STM.stock_model_id IS NOT NULL');
  END IF;
  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
      AND PRMsub.active = 1
      AND
      (
        (
          PRMsub.allow_all_variations = 1
          AND PRMsub.`product_variation_id` IS NULL
          AND
          (
            (
              PRMsub.`allowed_variation_type_id` IS NOT NULL
              AND PRMsub.`allowed_variation_type_id` = ', 
              variation_type_id, '
            )
            OR
            (
              PRMsub.`allowed_variation_type_id` IS NULL
            )
          )
        )
        OR
        (
          PRMsub.allow_all_variations = 0
          AND PRMsub.`product_variation_id` IS NOT NULL
          AND PRMsub.`product_variation_id` = PRD_VAR.`product_variation_id`
        )
      )
    ORDER BY PRMsub.product_variation_id desc -- priority for product variation defined
    LIMIT 0,1
  ');
  SET select_segment = 'SELECT COUNT(PRD.product_id) as total_products';
  SET join_segment = CONCAT('
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Get product variations
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    -- Filter by plan
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    -- Check stock models
    LEFT JOIN (
      SELECT stock_model_id, product_id
      FROM tbl_stock_model
      WHERE active = 1
    ) as STM
      ON PRD.`product_id` = STM.`product_id`
    -- Check promos
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');
  -- checking if is search query
  IF product_string_search <> ''  THEN
    -- is a search and require MATCH
    SET stored_query = CONCAT(select_segment,
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1
        AND PRD_VAR.`active` = 1
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')
        OR BRN.`brand_name` like ''%',product_string_search,'%''  )
    ');
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment,
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1
        AND PRD_VAR.`active` = 1');
  END IF;
  SET cad_condition = CONCAT(cad_condition, '
    AND PRD_VAR.`variation_type_id` = ',variation_type_id);
  SET cad_condition = CONCAT(cad_condition, '
    GROUP BY PRD.product_id ');
  -- CONCAT query, condition AND order
  SET stored_query = CONCAT('select count(*) as total_products from (',stored_query, cad_condition, ') as t');
  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;
END$$

DELIMITER ;