DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_productPostpagoBySlug`$$

CREATE PROCEDURE `PA_productPostpagoBySlug`(
  IN brand_slug VARCHAR(150),
  IN product_slug VARCHAR(150),
  IN affiliation_slug VARCHAR(150),
  IN plan_slug VARCHAR(150),
  IN contract_slug VARCHAR(150),
  IN color_slug VARCHAR(150)
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_idpromo_segment TEXT; -- variable for promo subquery
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  DECLARE variation_type_id INT;
  SET brand_slug = IFNULL(brand_slug, '');
  SET product_slug = IFNULL(product_slug, '');
  SET affiliation_slug = IFNULL(affiliation_slug, '');
  SET plan_slug = IFNULL(plan_slug, '');
  SET contract_slug = IFNULL(contract_slug, '');
  SET color_slug = IFNULL(color_slug, '');
  SET variation_type_id = 2; -- Postpaid
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
  SET select_query = 'SELECT
    DISTINCT(PRD.product_id),
    PRM.*, PRD.*,
    PRD_VAR.`variation_type_id`,
    PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    BRN.`brand_id`, BRN.`brand_name`, BRN.`brand_slug`,
    AFF.`affiliation_id`, AFF.`affiliation_name`, AFF.`affiliation_slug`,
    PLN.`plan_id`, PLN.`plan_name`, PLN.`plan_slug`, PLN.`plan_price`,
    CTR.`contract_id`, CTR.`contract_name`, CTR.`contract_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, IFNULL(PRM.promo_price,((1-PRM.promo_discount) * PRD_VAR.product_variation_price)), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price';
  SET from_query = '
    FROM tbl_product as PRD
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    INNER JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    INNER JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`';
  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND PRD_VAR.`active` = 1
      AND BRN.`brand_slug` = "', brand_slug, '"
      AND PRD.`product_slug` = "', product_slug, '"
      AND AFF.`affiliation_slug` = "', affiliation_slug, '"
      AND PLN.`plan_slug` = "', plan_slug, '"
      AND CTR.`contract_slug` = "', contract_slug, '"'
  );
  IF (color_slug <> '') THEN
    SET select_query = CONCAT(select_query, ',
      STM.`stock_model_id`, STM.`stock_model_code`,
      CLR.`color_id`, CLR.`color_name`');
    SET from_query = CONCAT(from_query, '
      LEFT JOIN tbl_stock_model as STM
        ON (PRD.`product_id` = STM.`product_id` AND STM.`active` = 1)
      INNER JOIN tbl_color as CLR
        ON STM.`color_id` = CLR.`color_id`');
    SET where_query = CONCAT(where_query, '
      AND CLR.color_slug = "', color_slug, '"');
  ELSE
    SET select_query = CONCAT(select_query, ',
      STM.`stock_model_id`, STM.`stock_model_code`,
      CLR.`color_id`, CLR.`color_name`');
    SET from_query = CONCAT(from_query, '
      LEFT JOIN tbl_stock_model as STM
        ON (PRD.`product_id` = STM.`product_id` AND STM.`active` = 1)
      LEFT JOIN tbl_color as CLR
        ON STM.`color_id` = CLR.`color_id`');
  END IF;
  SET from_query = CONCAT(from_query, '
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');
  SET where_query = CONCAT(where_query, '
    AND PRD_VAR.`variation_type_id` = 2');
  SET where_query = CONCAT(where_query, ' LIMIT 1');
  SET stored_query = CONCAT(select_query, from_query, where_query);
  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;
END$$

DELIMITER ;