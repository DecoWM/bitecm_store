
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- ------------------------------------------
-- ------------------------------------------
-- STORED PROCEDURES
-- ------------------------------------------
-- ------------------------------------------
USE `bitel_ecommerce` ;

-- ------------------------------------------
-- Affiliation List
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_affiliationList;

DELIMITER $$
--
-- Procedimiento para listar las afiliaciones
--
CREATE PROCEDURE PA_affiliationList()
BEGIN
    --
    SELECT affiliation_id,affiliation_name,affiliation_slug
        FROM tbl_affiliation
        ORDER BY weight ASC;

END $$

DELIMITER ;

-- ------------------------------------------
-- Brand List
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_brandList;

DELIMITER $$
--
-- Procedimiento para listar las afiliaciones
--
CREATE PROCEDURE PA_brandList()
BEGIN
    --
    SELECT brand_id,brand_name
        FROM tbl_brand
        ORDER BY weight ASC;

END $$

DELIMITER ;

-- ------------------------------------------
-- Plan List
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_planList;

DELIMITER $$
--
-- Procedimiento para listar los planes
--
CREATE PROCEDURE PA_planList(
  _plan_type INT
)
BEGIN

  SET _plan_type = IFNULL(_plan_type, -1); -- set value if null

  SELECT *
    FROM tbl_plan
  WHERE IF(_plan_type > 0, plan_type = _plan_type, 1)
  ORDER BY  weight ASC;

END $$

DELIMITER ;

-- ------------------------------------------
-- Varation Type List
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_variationTypeList;

DELIMITER $$
--
-- Procedimiento para listar los tipos de variaciones
--
CREATE PROCEDURE PA_variationTypeList()
BEGIN
    --
    SELECT *
        FROM tbl_variation_type
        ORDER BY weight ASC;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Detail
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productDetail;

DELIMITER $$
--
-- Procedimiento para obtener del detalle de un producto sin variación
--
CREATE PROCEDURE PA_productDetail(
  IN product_id INT
)
BEGIN
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  DECLARE where_segment TEXT;
  DECLARE stored_query TEXT;
  
  SET select_segment = 'SELECT
    PRD.*,
    PRD.`product_image_url` as picture_url,
    BRN.`brand_name`, BRN.`brand_slug`,
    CAT.`category_name`, CAT.`category_id`,
    STM.`stock_model_id`, STM.`stock_model_code`,
    CLR.`color_id`, CLR.`color_name`';

  SET join_segment = '
    FROM tbl_product as PRD
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    INNER JOIN tbl_category as CAT
      ON PRD.`category_id` = CAT.`category_id`
    LEFT JOIN tbl_stock_model as STM
      ON PRD.`product_id` = STM.`product_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`';

  SET where_segment = CONCAT('
    WHERE PRD.`product_id` = ',
    product_id, '
  ');

  SET stored_query = CONCAT(select_segment, join_segment, where_segment);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Detail
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productVariationDetail;

DELIMITER $$
--
-- Procedimiento para obtener del detalle de un producto con variación
--
CREATE PROCEDURE PA_productVariationDetail(
  IN product_variation_id INT
)
BEGIN
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  DECLARE where_segment TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE stored_query TEXT;
  
  SET select_segment = 'SELECT
    PRD.*, PRM.`promo_id`,
    PRD.`product_image_url` as picture_url,
    BRN.`brand_name`, BRN.`brand_slug`,
    CAT.`category_name`, CAT.`category_id`,
    STM.`stock_model_id`, STM.`stock_model_code`,
    CLR.`color_id`, CLR.`color_name`,
    PRD_VAR.`product_variation_price` as product_price,
    PLN.`plan_id`, PLN.`plan_name`,
    PLN.`plan_price`, PLN.`plan_slug`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price';

  SET select_idpromo_segment = '
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
      AND
      (
        (
          PRMsub.allow_all_variations = 1
          AND PRMsub.`product_variation_id` IS NULL
          AND
          (
            (
              PRMsub.`allowed_variation_type_id` IS NOT NULL
              AND PRMsub.`allowed_variation_type_id` = PRD_VAR.`variation_type_id`
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
  ';

  SET join_segment = CONCAT('
    FROM tbl_product as PRD
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    INNER JOIN tbl_category as CAT
      ON PRD.`category_id` = CAT.`category_id`
    LEFT JOIN tbl_stock_model as STM
      ON PRD.`product_id` = STM.`product_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    LEFT JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    LEFT JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    LEFT JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
        AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )
  ');

  SET where_segment = CONCAT('
    WHERE PRD_VAR.`product_variation_id` = ', 
    product_variation_id, '
  ');

  SET stored_query = CONCAT(select_segment, join_segment, where_segment);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Search
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productSearch;

DELIMITER $$
--
-- Procedimiento para listar equipos sin variacion con filtrado / paginado
--
CREATE PROCEDURE PA_productSearch(
  IN product_categories VARCHAR(200),
  IN product_brands VARCHAR(200),
  IN product_price_ini DECIMAL(6,2),
  IN product_price_end DECIMAL(6,2),
  IN product_string_search VARCHAR(255),
  IN pag_total_by_page INT, -- Items per page
  IN pag_actual INT, -- Actual page
  IN sort_by VARCHAR(50),
  IN sort_direction VARCHAR(5),
  IN product_ignore_ids VARCHAR(50)
)
BEGIN
  --
  DECLARE pag_ini INT;
  DECLARE pag_end INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE cad_order TEXT;
  DECLARE cad_order_comma VARCHAR(2);
  DECLARE select_segment TEXT;
  DECLARE select_idpromo_segment TEXT; -- subquery for promotional id
  DECLARE join_segment TEXT;
  -- conditional string query
  SET cad_condition = "";
  SET cad_order = " ";
  SET cad_order_comma = " ";
  -- checking null values
  SET product_categories = IFNULL(product_categories, ''); -- set value if null
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');
  SET sort_by = IFNULL(sort_by,'');
  SET sort_direction = IFNULL(sort_direction,'');
  SET product_ignore_ids = IFNULL(product_ignore_ids,'');

  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (product_categories <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id IN (', product_categories, ')');
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;
  -- setting actual page if wrong value
  IF (pag_actual < 1) THEN
    SET pag_actual = 1;
  END IF;
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD.product_price), IFNULL(PRM.promo_price,PRD.product_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD.product_price), IFNULL(PRM.promo_price,PRD.product_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD.product_price), IFNULL(PRM.promo_price,PRD.product_price)) <= ',product_price_end);
  END IF;
  -- conditional filter for ignore ids products and not stock
  IF (product_ignore_ids <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_id NOT IN (', product_ignore_ids,')');
    SET cad_condition = CONCAT(cad_condition, ' AND STM.stock_model_id IS NOT NULL');
  END IF;

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = '
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
    ORDER BY PRMsub.product_variation_id desc -- priority for product variation defined
    LIMIT 0,1
    ';

  SET select_segment = 'SELECT
    DISTINCT(PRD.`product_id`),
    PRM.*, PRD.*, STM.`stock_model_id`,
    PRD.`product_image_url` AS picture_url,
    BRN.`brand_name`, BRN.`brand_slug`,
    ROUND(IFNULL(PRM.promo_price,0),2) as promo_price,';

  SET join_segment = CONCAT('
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Check stock models
    LEFT JOIN tbl_stock_model as STM
      ON PRD.`product_id` = STM.`product_id`
    -- Check promos
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  -- checking if is search query
  IF product_string_search <> ''  THEN
    -- is a search and require MATCH
    SET stored_query = CONCAT(select_segment, '
      MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''') as pscore,
      MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''') as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR PRD.product_model like ''%',product_string_search,'%''
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')
        OR BRN.`brand_name` like ''%',product_string_search,'%'' )
    ');
    -- order
    SET cad_order = ' ORDER BY (mscore + pscore) DESC';
    SET cad_order_comma = ', ';
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment, '
      1 as pscore, 1 as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1');
    -- order
    SET cad_order = ' ORDER BY ';
    SET cad_order_comma = '';
  END IF;

  SET cad_order = CONCAT(cad_order, cad_order_comma, '
    ISNULL(STM.`stock_model_id`),
    PRD.`product_priority` DESC,
    ISNULL(PRM.`publish_at`),
    PRM.`publish_at` DESC,
    ISNULL(PRD.`product_tag`),
    PRD.`publish_at` DESC');

  SET cad_condition = CONCAT(cad_condition, '
    GROUP BY PRD.product_id ');

  -- ORDER BY
  IF (sort_by <> '') THEN
    SET cad_order = CONCAT(cad_order, ', PRD.', sort_by);
    IF(sort_direction IN ('ASC','DESC')) THEN
      SET cad_order = CONCAT(cad_order, " ", sort_direction);
    END IF;
  ELSE
    SET cad_order = '';
  END IF;

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition, cad_order);

  -- filter to pagination
  IF (pag_ini > 0 AND pag_total_by_page > 0) THEN
    SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_ini,',', pag_total_by_page);
  ELSE
    IF (pag_total_by_page > 0) THEN
      SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_total_by_page);
    END IF;
  END IF;
  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Count
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productCount;

DELIMITER $$
--
-- Procedimiento para contar el total de equipos sin variacion con filtrado
--
CREATE PROCEDURE PA_productCount(
  IN product_categories VARCHAR(200),
  IN product_brands VARCHAR(200),
  IN product_price_ini DECIMAL(6,2),
  IN product_price_end DECIMAL(6,2),
  IN product_string_search VARCHAR(255),
  IN product_ignore_ids VARCHAR(50)
)
BEGIN
  --
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE select_segment TEXT;
  DECLARE select_idpromo_segment TEXT; -- subquery for promotional id
  DECLARE join_segment TEXT;
  -- conditional string query
  SET cad_condition = "";
  -- checking null values
  SET product_categories = IFNULL(product_categories, ''); -- set value if null
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');
  SET product_ignore_ids = IFNULL(product_ignore_ids,'');

  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (product_categories <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id IN (', product_categories, ')');
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;

  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD.product_price), IFNULL(PRM.promo_price,PRD.product_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD.product_price), IFNULL(PRM.promo_price,PRD.product_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD.product_price), IFNULL(PRM.promo_price,PRD.product_price)) <= ',product_price_end);
  END IF;
  -- conditional filter for ignore ids products and not stock
  IF (product_ignore_ids <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_id NOT IN (', product_ignore_ids,')');
    SET cad_condition = CONCAT(cad_condition, ' AND STM.stock_model_id IS NOT NULL');
  END IF;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = '
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
    ORDER BY PRMsub.product_variation_id desc -- priority for product variation defined
    LIMIT 0,1
  ';

  SET select_segment = 'SELECT COUNT(PRD.`product_id`)';

  SET join_segment = CONCAT('
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Check stock models
    LEFT JOIN tbl_stock_model as STM
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
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')  )
    ');
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment,
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1');
  END IF;

  SET cad_condition = CONCAT(cad_condition, '
    GROUP BY PRD.product_id ');

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT('SELECT COUNT(*) as total_products FROM (', stored_query, cad_condition,') as t');


  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product By Slug
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productBySlug;

DELIMITER $$
--
-- Procedimiento para obtener un equipo prepago por su url
--
CREATE PROCEDURE PA_productBySlug(
  IN brand_slug VARCHAR(150),
  IN product_slug VARCHAR(150),
  IN color_slug VARCHAR(150)
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET brand_slug = IFNULL(brand_slug, '');
  SET product_slug = IFNULL(product_slug, '');
  SET color_slug = IFNULL(color_slug, '');

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = '
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
    ORDER BY PRMsub.product_variation_id desc -- priority for product variation defined
    LIMIT 0,1
  ';

  SET select_query = 'SELECT
    DISTINCT(PRD.product_id),
    BRN.`brand_id`, BRN.`brand_name`,BRN.`brand_slug`';

  SET from_query = '
    FROM tbl_product as PRD
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`';

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND BRN.`brand_slug` = "', brand_slug, '"
      AND PRD.`product_slug` = "', product_slug, '"'
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

  SET select_query = CONCAT(select_query, ',
    PRM.*, PRD.*,
    ROUND(IFNULL(PRM.promo_price,0),2) as promo_price');
  SET from_query = CONCAT(from_query, '
    -- Check promos
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  SET where_query = CONCAT(where_query, ' LIMIT 1');

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product By Stock
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productByStock;

DELIMITER $$
--
-- Procedimiento para obtener un equipo prepago por su stock model code
--
CREATE PROCEDURE PA_productByStock(
  IN stock_model_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET stock_model_id = IFNULL(stock_model_id, 0);

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = '
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
    ORDER BY PRMsub.product_variation_id desc -- priority for product variation defined
    LIMIT 0,1
  ';

  SET select_query = 'SELECT
    DISTINCT(PRD.product_id), PRM.*, PRD.*,
    STM.`stock_model_id`, STM.`stock_model_code`,
    BRN.`brand_name`, BRN.`brand_slug`,
    CLR.`color_name`, CLR.`color_slug`,
    ROUND(IFNULL(PRM.promo_price,0),2) as promo_price';

  SET from_query = CONCAT('
    FROM tbl_stock_model as STM
    INNER JOIN tbl_product as PRD
      ON STM.`product_id` = PRD.`product_id`
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND STM.`stock_model_id` = ', stock_model_id
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Prepago Search
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productSearchPrepago;

DELIMITER $$
--
-- Procedimiento para listar equipos prepago con filtrado / paginado
--
CREATE PROCEDURE PA_productSearchPrepago(
  IN product_categories VARCHAR(200),
  IN product_brands VARCHAR(200),
  IN plan_id INT,
  IN product_price_ini DECIMAL(6,2),
  IN product_price_end DECIMAL(6,2),
  IN product_string_search VARCHAR(255),
  IN pag_total_by_page INT, -- Items per page
  IN pag_actual INT, -- Actual page
  IN sort_by VARCHAR(50),
  IN sort_direction VARCHAR(5),
  IN product_tag VARCHAR(255),
  IN product_ignore_ids VARCHAR(50)
)
BEGIN
  --
  DECLARE pag_ini INT;
  DECLARE pag_end INT;
  DECLARE variation_type_id INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE cad_order TEXT;
  DECLARE cad_order_comma VARCHAR(2);
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;

  -- conditional string query
  SET variation_type_id = 1; -- Prepaid
  SET cad_condition = "";
  SET cad_order = " ";
  SET cad_order_comma = " ";
  -- checking null values
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET plan_id = IFNULL(plan_id, 0); -- set value 14 (Prepago B-Voz) if null
  SET product_categories = IFNULL(product_categories, ''); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');
  SET sort_by = IFNULL(sort_by,'');
  SET sort_direction = IFNULL(sort_direction,'');
  SET product_tag = IFNULL(product_tag, '');
  SET product_ignore_ids = IFNULL(product_ignore_ids,'');
  -- setting actual page if wrong value
  IF (pag_actual < 1) THEN
    SET pag_actual = 1;
  END IF;
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) <= ',product_price_end);
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

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
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

  SET select_segment = 'SELECT
    DISTINCT(PRD.`product_id`),
    PRM.*, PRD.*, STM.`stock_model_id`,
    PRD.`product_image_url` AS picture_url,
    PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    PLN.`plan_id`, PLN.`plan_name`, PLN.`plan_price`, PLN.`plan_slug`,
    BRN.`brand_name`, BRN.`brand_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price,';

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
    LEFT JOIN tbl_stock_model as STM
      ON PRD.`product_id` = STM.`product_id`
    -- Check promos
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  -- checking if is search query
  IF product_string_search <> ''  THEN
    -- is a search and require MATCH
    SET stored_query = CONCAT(select_segment, '
      MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''') as pscore,
      MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''') as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1
        AND PRD_VAR.`active` = 1
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR PRD.product_model like ''%',product_string_search,'%''
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')
        OR BRN.`brand_name` like ''%',product_string_search,'%''  )
    ');
    -- order
    SET cad_order = ' ORDER BY (mscore + pscore) DESC';
    SET cad_order_comma = ', ';
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment, '
      1 as pscore, 1 as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1
        AND PRD_VAR.`active` = 1');
    -- order
    SET cad_order = ' ORDER BY ';
    SET cad_order_comma = '';
  END IF;

  SET cad_order = CONCAT(cad_order, cad_order_comma, '
    ISNULL(STM.`stock_model_id`),
    PRD.`product_priority` DESC,
    ISNULL(PRM.`publish_at`),
    PRM.`publish_at` DESC,
    ISNULL(PRD.`product_tag`),
    PRD.`publish_at` DESC');

  SET cad_condition = CONCAT(cad_condition, '
    AND PRD_VAR.`variation_type_id` = ', variation_type_id);

  -- ORDER BY
  IF (sort_by <> '') THEN
    SET cad_order = CONCAT(cad_order, ', PRD.', sort_by);
    IF(sort_direction IN ('ASC','DESC')) THEN
      SET cad_order = CONCAT(cad_order, " ", sort_direction);
    END IF;
  ELSE
    SET cad_order = '';
  END IF;

  SET cad_condition = CONCAT(cad_condition, '
    GROUP BY PRD.product_id ');

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition, cad_order);

  -- filter to pagination
  IF (pag_ini > 0 AND pag_total_by_page > 0) THEN
    SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_ini,',', pag_total_by_page);
  ELSE
    IF (pag_total_by_page > 0) THEN
      SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_total_by_page);
    END IF;
  END IF;
  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Prepago Count
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productCountPrepago;

DELIMITER $$
--
-- Procedimiento para contar el total equipos prepago con filtrado
--
CREATE PROCEDURE PA_productCountPrepago(
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
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) <= ',product_price_end);
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
    LEFT JOIN tbl_stock_model as STM
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

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Prepago By Slug
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productPrepagoBySlug;

DELIMITER $$
--
-- Procedimiento para obtener un equipo prepago por su url
--
CREATE PROCEDURE PA_productPrepagoBySlug(
  IN brand_slug VARCHAR(150),
  IN product_slug VARCHAR(150),
  IN plan_slug VARCHAR(150),
  IN color_slug VARCHAR(150)
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  DECLARE variation_type_id INT;

  SET brand_slug = IFNULL(brand_slug, '');
  SET product_slug = IFNULL(product_slug, '');
  SET plan_slug = IFNULL(plan_slug, '');
  SET color_slug = IFNULL(color_slug, '');
  SET variation_type_id = 1; -- Prepago

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
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
    PRM.*, PRD.*, PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    BRN.`brand_id`, BRN.`brand_name`, BRN.`brand_slug`,
    PLN.`plan_id`, PLN.`plan_name`, PLN.`plan_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price';

  SET from_query = '
    FROM tbl_product as PRD
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`';

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND BRN.`brand_slug` = "', brand_slug, '"
      AND PRD.`product_slug` = "', product_slug, '"
      AND PLN.`plan_slug` = "', plan_slug, '"'
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
    AND PRD_VAR.`variation_type_id` = 1');

  SET where_query = CONCAT(where_query, ' LIMIT 1');

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Prepago By Stock
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productPrepagoByStock;

DELIMITER $$
--
-- Procedimiento para obtener un equipo prepago por su stock model code
--
CREATE PROCEDURE PA_productPrepagoByStock(
  IN stock_model_id INT,
  IN product_variation_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  DECLARE variation_type_id INT;

  SET stock_model_id = IFNULL(stock_model_id, 0);
  SET product_variation_id = IFNULL(product_variation_id, 0);
  SET variation_type_id = 1; -- Prepago

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
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
    DISTINCT(PRD.product_id), PRM.*, PRD.*,
    STM.`stock_model_id`, STM.`stock_model_code`,
    PRD_VAR.`variation_type_id`,
    PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    PRD_VAR.`reason_code`, PRD_VAR.`product_package`,
    BRN.`brand_name`, BRN.`brand_slug`,
    PLN.`plan_name`, PLN.`plan_slug`,
    PLN.`plan_price`, PLN.`product_code`,
    CLR.`color_name`, CLR.`color_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price';

  SET from_query = CONCAT('
    FROM tbl_stock_model as STM
    INNER JOIN tbl_product as PRD
      ON STM.`product_id` = PRD.`product_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND STM.`stock_model_id` = ', stock_model_id, '
      AND PRD_VAR.`product_variation_id` = ', product_variation_id
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Postpago Search
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productSearchPostpago;

DELIMITER $$
--
-- Procedimiento para listar equipos postpago con filtrado / paginado
--


CREATE PROCEDURE PA_productSearchPostpago(
  IN product_categories VARCHAR(200),
  IN product_brands VARCHAR(200),
  IN affiliation_id INT,
  IN plan_id INT,
  IN contract_id INT,
  IN product_price_ini DECIMAL(6,2),
  IN product_price_end DECIMAL(6,2),
  IN product_string_search VARCHAR(255),
  IN pag_total_by_page INT, -- Items per page
  IN pag_actual INT, -- Actual page
  IN sort_by VARCHAR(50),
  IN sort_direction VARCHAR(5),
  IN product_tag VARCHAR(255),
  IN product_ignore_ids VARCHAR(50)
)
BEGIN

  --
  DECLARE pag_ini INT;
  DECLARE pag_end INT;
  DECLARE variation_type_id INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE cad_order TEXT;
  DECLARE cad_order_comma VARCHAR(2);
  DECLARE select_segment TEXT;
  DECLARE select_idpromo_segment TEXT; -- subquery for promotional id
  DECLARE join_segment TEXT;

  -- conditional string query
  SET variation_type_id = 2; -- Postpaid
  SET cad_condition = "";
  SET cad_order = " ";
  SET cad_order_comma = " ";
  -- checking null values
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET product_categories = IFNULL(product_categories, ''); -- set value if null
  SET plan_id = IFNULL(plan_id, 7); -- set value 7 (Postpago iChip 99.9) if null
  SET affiliation_id = IFNULL(affiliation_id, 1); -- set value 1 (Portabilidad) if null
  SET contract_id = IFNULL(contract_id, 1); -- set value 1 (18 meses) if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET product_string_search = IFNULL(product_string_search, '');
  SET sort_by = IFNULL(sort_by, '');
  SET sort_direction = IFNULL(sort_direction, '');
  SET product_tag = IFNULL(product_tag, '');
  SET product_ignore_ids = IFNULL(product_ignore_ids, '');
  -- setting actual page if wrong value
  IF (pag_actual < 1) THEN
    SET pag_actual = 1;
  END IF;
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) <= ',product_price_end);
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
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.plan_id = ', plan_id);
  END IF;
  -- conditional filter for affiliation
  IF (affiliation_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.affiliation_id = ', affiliation_id);
  END IF;
  -- conditional filter for contract
  IF (contract_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.contract_id = ', contract_id);
  END IF;
  -- conditional filter for tag product (nuevo / destacado)
  IF (product_tag <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_tag IN (', product_tag, ')');
    SET cad_condition = CONCAT(cad_condition, ' AND STM.stock_model_id IS NOT NULL');
  END IF;
  -- conditional filter for manufacturer
  IF (product_ignore_ids <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_id NOT IN (', product_ignore_ids,')');
    SET cad_condition = CONCAT(cad_condition, ' AND STM.stock_model_id IS NOT NULL');
  END IF;

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
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

  SET select_segment = 'SELECT
    DISTINCT(PRD.`product_id`), PRD.*, PRD.`product_image_url` AS picture_url, PRD_VAR.`product_variation_id`, PRD_VAR.`product_variation_price` as product_price,
    PRM.promo_id, PRM.promo_price, PRM.promo_discount, PRM.promo_add_product_price, PRM.promo_add_product_discount, PRM.promo_title, PRM.promo_description, PRM.`publish_at`, STM.`stock_model_id`,
    PLN.`plan_id`, PLN.`plan_name`,
    PLN.`plan_price`, PLN.`plan_slug`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    BRN.`brand_name`, BRN.`brand_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price,';

  SET join_segment = CONCAT('
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Get product variations
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    -- Filter by affiliation
    INNER JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    -- Filter by plan
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    -- Filter by contract
    INNER JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    -- Check stock models
    LEFT JOIN tbl_stock_model as STM
      ON PRD.`product_id` = STM.`product_id`
    -- Check promos
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  -- checking if is search query
  IF product_string_search <> ''  THEN
    -- is a search and require MATCH
    SET stored_query = CONCAT(select_segment, '
      MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''') as pscore,
      MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''') as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1
        AND PRD_VAR.`active` = 1
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR PRD.product_model like ''%',product_string_search,'%''
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')
        OR BRN.`brand_name` like ''%',product_string_search,'%''  )
    ');
    -- order
    SET cad_order = ' ORDER BY (mscore + pscore) DESC';
    SET cad_order_comma = ', ';
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment, '
      1 as pscore, 1 as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRD.`active` = 1
        AND PRD_VAR.`active` = 1');
    -- order
    SET cad_order = ' ORDER BY ';
    SET cad_order_comma = '';
  END IF;

  SET cad_order = CONCAT(cad_order, cad_order_comma, '
    ISNULL(STM.`stock_model_id`),
    PRD.`product_priority` DESC,
    ISNULL(PRM.`publish_at`),
    PRM.`publish_at` DESC,
    ISNULL(PRD.`product_tag`),
    PRD.`publish_at` DESC');

  -- validation for PLAN and promo price
  SET cad_condition = CONCAT(cad_condition, '
    AND PRD_VAR.`variation_type_id` = ',variation_type_id,'
    GROUP BY PRD.product_id
    ');

  -- ORDER BY
  IF (sort_by <> '') THEN
    SET cad_order = CONCAT(cad_order, ', PRD.', sort_by);
    IF(sort_direction IN ('ASC','DESC')) THEN
      SET cad_order = CONCAT(cad_order, " ", sort_direction);
    END IF;
  ELSE
    SET cad_order = '';
  END IF;

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition, cad_order);

  -- filter to pagination
  IF (pag_ini > 0 AND pag_total_by_page > 0) THEN
    SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_ini,',', pag_total_by_page);
  ELSE
    IF (pag_total_by_page > 0) THEN
      SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_total_by_page);
    END IF;
  END IF;
  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Postpago Count
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productCountPostpago;

DELIMITER $$
--
-- Procedimiento para contar el total equipos postpago con filtrado
--
CREATE PROCEDURE PA_productCountPostpago(
  IN product_categories VARCHAR(200),
  IN product_brands VARCHAR(200),
  IN affiliation_id INT,
  IN plan_id INT,
  IN contract_id INT,
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
  DECLARE select_segment TEXT;
  DECLARE select_idpromo_segment TEXT; -- subquery for promotional id
  DECLARE join_segment TEXT;
  
  -- conditional string query
  SET variation_type_id = 2; -- Postpaid
  SET cad_condition = "";
  -- checking null values
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET product_categories = IFNULL(product_categories, ''); -- set value if null
  SET plan_id = IFNULL(plan_id, 7); -- set value 7 (Postpago iChip 99.9) if null
  SET affiliation_id = IFNULL(affiliation_id, 1); -- set value 1 (Portabilidad) if null
  SET contract_id = IFNULL(contract_id, 1); -- set value 1 (18 meses) if null
  SET product_string_search = IFNULL(product_string_search, '');
  SET product_tag = IFNULL(product_tag, '');
  SET product_ignore_ids = IFNULL(product_ignore_ids, '');

  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    -- SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) <= ',product_price_end);
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands, ')');
  END IF;
  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (product_categories <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id IN (', product_categories, ')');
  END IF;
  -- conditional filter for plan
  IF (plan_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.plan_id = ', plan_id);
  END IF;
  -- conditional filter for affiliation
  IF (affiliation_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.affiliation_id = ', affiliation_id);
  END IF;
  -- conditional filter for contract
  IF (contract_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.contract_id = ', contract_id);
  END IF;
  -- conditional filter for tag product (nuevo / destacado)
  IF (product_tag <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_tag IN (', product_tag, ')');
    SET cad_condition = CONCAT(cad_condition, ' AND STM.stock_model_id IS NOT NULL');
  END IF;
  -- conditional filter for manufacturer
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
          AND PRD_VAR.`product_variation_id` IS NOT NULL
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
    -- Filter by affiliation
    INNER JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    -- Filter by plan
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    -- Filter by contract
    INNER JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    -- Check stock models
    LEFT JOIN tbl_stock_model as STM
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

  -- validation for PLAN and promo price
  SET cad_condition = CONCAT(cad_condition, '
    AND PRD_VAR.`variation_type_id` = ',variation_type_id,'
    ');

  SET cad_condition = CONCAT(cad_condition, '
    GROUP BY PRD.product_id ');

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT('select count(*) as total_products from (',stored_query, cad_condition, ') as t');

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Postpago By Slug
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productPostpagoBySlug;

DELIMITER $$
--
-- Procedimiento para obtener un equipo postpago por su url
--
CREATE PROCEDURE PA_productPostpagoBySlug(
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
    PLN.`plan_id`, PLN.`plan_name`, PLN.`plan_slug`,
    CTR.`contract_id`, CTR.`contract_name`, CTR.`contract_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price';

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
    WHERE BRN.`brand_slug` = "', brand_slug, '"
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

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Postpago By Stock
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productPostpagoByStock;

DELIMITER $$
--
-- Procedimiento para obtener un equipo prepago por su stock model code
--
CREATE PROCEDURE PA_productPostpagoByStock(
  IN stock_model_id INT,
  IN product_variation_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  DECLARE variation_type_id INT;

  SET stock_model_id = IFNULL(stock_model_id, 0);
  SET product_variation_id = IFNULL(product_variation_id, 0);
  SET variation_type_id = 2; -- Postpaid

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
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
    DISTINCT(PRD.product_id), PRM.*, PRD.*,
    STM.`stock_model_id`, STM.`stock_model_code`,
    PRD_VAR.`variation_type_id`,
    PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    PRD_VAR.`reason_code`, PRD_VAR.`product_package`,
    BRN.`brand_name`, BRN.`brand_slug`,
    PLN.`plan_name`, PLN.`plan_slug`,
    PLN.`plan_price`, PLN.`product_code`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    CLR.`color_name`, CLR.`color_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price';

  SET from_query = CONCAT('
    FROM tbl_stock_model as STM
    INNER JOIN tbl_product as PRD
      ON STM.`product_id` = PRD.`product_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    INNER JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    INNER JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND STM.`stock_model_id` = ', stock_model_id, '
      AND PRD_VAR.`product_variation_id` = ', product_variation_id
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Promo Search
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productSearchPromo;

DELIMITER $$
--
-- Procedimiento para listar promociones con filtrado / paginado
--
CREATE PROCEDURE PA_productSearchPromo(
  IN variation_type_id INT,
  IN plan_pre_id INT,
  IN plan_post_id INT,
  IN affiliation_id INT,
  IN contract_id INT,
  IN product_brands VARCHAR(200),
  IN product_price_ini DECIMAL(6,2),
  IN product_price_end DECIMAL(6,2),
  IN product_string_search VARCHAR(255),
  IN pag_total_by_page INT, -- Items per page
  IN pag_actual INT, -- Actual page
  IN sort_by VARCHAR(50),
  IN sort_direction VARCHAR(5)
)
BEGIN
  --
  DECLARE pag_ini INT;
  DECLARE pag_end INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE cad_order TEXT;
  DECLARE cad_order_comma VARCHAR(2);
  DECLARE select_segment TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE join_segment TEXT;
  DECLARE cond_variations TEXT;
  -- conditional string query
  SET cad_condition = "";
  SET cad_order = " ";
  SET cad_order_comma = " ";
  -- checking null values
  SET variation_type_id = IFNULL(variation_type_id, -1); -- set value if null
  SET plan_pre_id = IFNULL(plan_pre_id, -1); -- set value if null
  SET plan_post_id = IFNULL(plan_post_id, -1); -- set value if null
  SET affiliation_id = IFNULL(affiliation_id, -1); -- set value if null
  SET contract_id = IFNULL(contract_id, -1); -- set value if null
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 12); -- set value if null
  SET product_string_search = IFNULL(product_string_search, '');
  SET sort_by = IFNULL(sort_by, '');
  SET sort_direction = IFNULL(sort_direction, '');

  -- variation type
  IF (variation_type_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.`variation_type_id` IS NOT NULL');
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.`variation_type_id` = ', variation_type_id);
  END IF;
  -- setting actual page if wrong value
  IF (pag_actual < 1) THEN
    SET pag_actual = 1;
  END IF;
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) <= ',product_price_end);
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  IF (plan_pre_id > 0 AND plan_post_id > 0 AND affiliation_id > 0 AND contract_id > 0) THEN
    SET cond_variations = CONCAT('
      AND PRMsub.`product_variation_id` IS NULL
      AND
      (
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 1
          AND PRD_VAR.`variation_type_id` = 1
          AND PRD_VAR.`plan_id` = ', plan_pre_id, '
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 2
          AND PRD_VAR.`variation_type_id` = 2
          AND PRD_VAR.`plan_id` = ', plan_post_id, '
          AND PRD_VAR.`affiliation_id` = ', affiliation_id, '
          AND PRD_VAR.`contract_id` = ', contract_id, '
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 1
          AND PRD_VAR.`plan_id` = ', plan_pre_id, '
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 2
          AND PRD_VAR.`plan_id` = ', plan_post_id, '
          AND PRD_VAR.`affiliation_id` = ', affiliation_id, '
          AND PRD_VAR.`contract_id` = ', contract_id, '
        )
      )
    ');
  ELSE
    SET cond_variations = '
      AND PRMsub.`product_variation_id` IS NULL
      AND
      (
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 1
          AND PRD_VAR.`variation_type_id` = 1
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 2
          AND PRD_VAR.`variation_type_id` = 2
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 1
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 2
        )
      )
    ';
  END IF;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
      AND
      (
        (
          PRMsub.allow_all_variations = 1
          ', cond_variations, '
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

  SET select_segment = 'SELECT
    PRM.*, PRD.*, PRD_VAR.*,
    PRD.`product_image_url` AS picture_url,
    STM.`stock_model_id`,
    PLN.`plan_id`, PLN.`plan_name`,
    PLN.`plan_price`, PLN.`plan_slug`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    BRN.`brand_name`, BRN.`brand_slug`,
    ROUND(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price,';

  SET join_segment = CONCAT('
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Get product variations
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    LEFT JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    LEFT JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    -- Check stock models
    LEFT JOIN tbl_stock_model as STM
      ON PRD.`product_id` = STM.`product_id`
    -- Check promos
    LEFT JOIN tbl_promo as PRM
      ON (PRD.`product_id` = PRM.`product_id`
          AND IF((', select_idpromo_segment, ') IS NOT NULL, PRM.promo_id = (', select_idpromo_segment, '), PRM.promo_id = 0)
      )');

  -- checking if is search query
  IF product_string_search <> ''  THEN
    -- is a search and require MATCH
    SET stored_query = CONCAT(select_segment, '
      MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''') as pscore,
      MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''') as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRM.`active` = 1 AND PRD.`active` = 1
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR PRD.product_model like ''%',product_string_search,'%''
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')
        OR BRN.`brand_name` like ''%',product_string_search,'%''  )
    ');
    -- order
    SET cad_order = ' ORDER BY (mscore + pscore) DESC';
    SET cad_order_comma = ', ';
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment, '
      1 as pscore, 1 as mscore',
      join_segment, '
      -- Filter by search words
      WHERE PRM.`active` = 1 AND PRD.`active` = 1');
    -- order
    SET cad_order = ' ORDER BY ';
    SET cad_order_comma = '';
  END IF;

  SET cad_order = CONCAT(cad_order, cad_order_comma, '
    PRD.`product_priority` DESC,
    PRM.`publish_at` DESC,
    ISNULL(PRD.`product_tag`),
    PRD.`publish_at` DESC');

  SET cad_condition = CONCAT(cad_condition, '
    AND STM.`stock_model_id` IS NOT NULL
    AND PRM.`promo_id` IS NOT NULL
    AND PRM.`publish_at` IS NOT NULL
    GROUP BY PRM.`promo_id`');

  -- ORDER BY
  IF (sort_by <> '') THEN
    SET cad_order = CONCAT(cad_order, ',', 'PRM.', sort_by);
    IF(sort_direction IN ('ASC','DESC')) THEN
      SET cad_order = CONCAT(cad_order, " ", sort_direction);
    END IF;
  END IF;

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition, cad_order);

  -- filter to pagination
  IF (pag_ini > 0 AND pag_total_by_page > 0) THEN
    SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_ini,',', pag_total_by_page);
  ELSE
    IF (pag_total_by_page > 0) THEN
      SET stored_query = CONCAT(stored_query, ' LIMIT ',pag_total_by_page);
    END IF;
  END IF;
  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Promo Count
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productCountPromo;

DELIMITER $$
--
-- Procedimiento para contar promociones con filtrado y busqueda
--
CREATE PROCEDURE PA_productCountPromo(
  IN variation_type_id INT,
  IN plan_pre_id INT,
  IN plan_post_id INT,
  IN affiliation_id INT,
  IN contract_id INT,
  IN product_brands VARCHAR(200),
  IN product_price_ini DECIMAL(6,2),
  IN product_price_end DECIMAL(6,2),
  IN product_string_search VARCHAR(255)
)
BEGIN
  --
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE select_segment TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE join_segment TEXT;
  DECLARE cond_variations TEXT;
  -- conditional string query
  SET cad_condition = "";
  -- checking null values
  SET variation_type_id = IFNULL(variation_type_id, -1); -- set value if null
  SET plan_pre_id = IFNULL(plan_pre_id, -1); -- set value if null
  SET plan_post_id = IFNULL(plan_post_id, -1); -- set value if null
  SET affiliation_id = IFNULL(affiliation_id, -1); -- set value if null
  SET contract_id = IFNULL(contract_id, -1); -- set value if null
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET product_string_search = IFNULL(product_string_search, '');

  -- variation type
  IF (variation_type_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.`variation_type_id` IS NOT NULL');
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.`variation_type_id` = ', variation_type_id);
  END IF;
  
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND (IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) >= ',product_price_ini);
  END IF;
  IF (product_price_ini < 1 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)) <= ',product_price_end);
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;

  IF (plan_pre_id > 0 AND plan_post_id > 0 AND affiliation_id > 0 AND contract_id > 0) THEN
    SET cond_variations = CONCAT('
      AND PRMsub.`product_variation_id` IS NULL
      AND
      (
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 1
          AND PRD_VAR.`variation_type_id` = 1
          AND PRD_VAR.`plan_id` = ', plan_pre_id, '
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 2
          AND PRD_VAR.`variation_type_id` = 2
          AND PRD_VAR.`plan_id` = ', plan_post_id, '
          AND PRD_VAR.`affiliation_id` = ', affiliation_id, '
          AND PRD_VAR.`contract_id` = ', contract_id, '
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 1
          AND PRD_VAR.`plan_id` = ', plan_pre_id, '
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 2
          AND PRD_VAR.`plan_id` = ', plan_post_id, '
          AND PRD_VAR.`affiliation_id` = ', affiliation_id, '
          AND PRD_VAR.`contract_id` = ', contract_id, '
        )
      )
    ');
  ELSE
    SET cond_variations = '
      AND PRMsub.`product_variation_id` IS NULL
      AND
      (
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 1
          AND PRD_VAR.`variation_type_id` = 1
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NOT NULL
          AND PRMsub.`allowed_variation_type_id` = 2
          AND PRD_VAR.`variation_type_id` = 2
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 1
        )
        OR
        (
          PRMsub.`allowed_variation_type_id` IS NULL
          AND PRD_VAR.`variation_type_id` = 2
        )
      )
    ';
  END IF;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = CONCAT('
    SELECT
      PRMsub.promo_id
    FROM
      tbl_promo as PRMsub
    WHERE
      PRMsub.product_id = PRD.product_id
      AND
      (
        (
          PRMsub.allow_all_variations = 1
          ', cond_variations, '
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

  SET select_segment = 'SELECT COUNT(PRM.promo_id) as total_promos';

  SET join_segment = CONCAT('
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Get product variations
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    INNER JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    INNER JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    -- Check stock models
    LEFT JOIN tbl_stock_model as STM
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
      WHERE PRM.`active` = 1 AND PRD.`active` = 1
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')
        OR BRN.`brand_name` like ''%',product_string_search,'%''  )
    ');
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment,
      join_segment, '
      -- Filter by search words
      WHERE PRM.`active` = 1 AND PRD.`active` = 1');
  END IF;

  IF (plan_pre_id > 0 AND plan_post_id > 0 AND affiliation_id > 0 AND contract_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, '
      AND STM.`stock_model_id` IS NOT NULL
      AND PRM.`promo_id` IS NOT NULL
      AND PRM.`publish_at` IS NOT NULL

      GROUP BY PRM.`promo_id`');
  ELSE
    SET cad_condition = CONCAT(cad_condition, '
      AND STM.`stock_model_id` IS NOT NULL
      AND PRM.`promo_id` IS NOT NULL
      AND PRM.`publish_at` IS NOT NULL

      GROUP BY PRM.`promo_id`');
  END IF;

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT('select count(*) as total_promos from (',stored_query, cad_condition, ') as t');

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Images By Stock
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productImagesByStock;

DELIMITER $$
--
-- Procedimiento para obtener las imÃ¡genes de un equipo
--
CREATE PROCEDURE PA_productImagesByStock(
  IN stock_model_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET stock_model_id = IFNULL(stock_model_id, 0);

  SET select_query = 'SELECT
    stock_model_id,
    product_image_url ';

  SET from_query = 'FROM `tbl_product_image`';

  SET where_query = CONCAT('
    WHERE active = 1
      AND stock_model_id = ', stock_model_id, '
    ORDER BY weight DESC'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Product Stock Models
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_productStockModels;

DELIMITER $$
--
-- Procedimiento para obtener las colores de un equipo
--
CREATE PROCEDURE PA_productStockModels(
    IN product_id INT,
    IN color_required BOOLEAN
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET product_id = IFNULL(product_id, 0);
  SET color_required = IFNULL(color_required, 0);

  SET select_query = 'SELECT
    STM.`stock_model_id`,
    STM.`stock_model_code`,
    CLR.`color_id`,
    CLR.`color_name`,
    CLR.`color_hexcode`,
    CLR.`color_slug` ';

  SET from_query = '
    FROM tbl_stock_model as STM
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`';

  SET where_query = CONCAT('
    WHERE STM.`product_id` = ', product_id);

  IF (color_required > 0) THEN
    SET where_query = CONCAT(where_query, '
      AND CLR.`color_id` IS NOT NULL'
    );
  END IF;

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Order Item
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_orderItems;

DELIMITER $$
--
-- Procedimiento para obtener un equipo prepago por su stock model code
--
CREATE PROCEDURE PA_orderItems(
  IN order_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE select_idpromo_segment TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET order_id = IFNULL(order_id, 0);

  SET select_query = 'SELECT
    OIT.*, PRM.*, PRD.*,
    STM.`stock_model_id`, STM.`stock_model_code`,
    PRD_VAR.`variation_type_id`,
    PRD_VAR.`product_variation_id`,
    IFNULL(PRD_VAR.`product_variation_price`, PRD.`product_price`) as product_price,
    PRD_VAR.`reason_code`, PRD_VAR.`product_package`,
    BRN.`brand_name`, BRN.`brand_slug`,
    PLN.`plan_name`, PLN.`plan_slug`,
    PLN.`plan_price`, PLN.`product_code`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    CLR.`color_id`, CLR.`color_name`, CLR.`color_slug`,
    ROUND(
      IF(
        PRD_VAR.`product_variation_id` IS NOT NULL,
        IF(
          PRM.promo_discount IS NOT NULL,
          ((1-PRM.promo_discount) * PRD_VAR.`product_variation_price`), 
          IFNULL(PRM.promo_price, PRD_VAR.`product_variation_price`)
        ),
        IF(
          PRM.promo_discount IS NOT NULL,
          ((1-PRM.promo_discount) * PRD.`product_price`), 
          IFNULL(PRM.promo_price, PRD.`product_price`)
        )
      )
    ,2) as promo_price';

  SET from_query = CONCAT('
    FROM tbl_order_item as OIT
    INNER JOIN tbl_stock_model as STM
      ON OIT.`stock_model_id` = STM.`stock_model_id`
    INNER JOIN tbl_product as PRD
      ON STM.`product_id` = PRD.`product_id`
    INNER JOIN tbl_brand as BRN
      ON BRN.`brand_id` = PRD.`brand_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD_VAR.`product_variation_id` = OIT.`product_variation_id`
    LEFT JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    LEFT JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    LEFT JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`
    LEFT JOIN tbl_promo as PRM
      ON PRM.promo_id = OIT.promo_id
  ');

  SET where_query = CONCAT('
    WHERE OIT.`order_id` = ',
    order_id
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Order Search
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_orderSearch;

DELIMITER $$
--
-- Procedimiento para obtener el detalle de una orden
--
CREATE PROCEDURE PA_orderSearch(
  IN pag_total_by_page INT, -- Items per page
  IN pag_actual INT, -- Actual page
  IN sort_by VARCHAR(50),
  IN sort_direction VARCHAR(5)
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  DECLARE pag_ini INT;
  DECLARE pag_end INT;

  SET pag_total_by_page = IFNULL(pag_total_by_page, 0); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  -- SET product_string_search = IFNULL(product_string_search, '');
  SET sort_by = IFNULL(sort_by, '');
  SET sort_direction = IFNULL(sort_direction, '');

  SET select_query = 'SELECT
    ORD.*, OIT.*,
    OSH.`order_status_history_id`,
    OST.`order_status_name`,
    IDT.`idtype_name`,
    BCH.`branch_name`,
    ORD.`created_at`,
    IFNULL(ORD.`updated_at`, ORD.`created_at`) as updated_date';

  SET from_query = '
    FROM tbl_order as ORD
    INNER JOIN (
      SELECT OSH.*
      FROM tbl_order_status_history as OSH
      INNER JOIN (
        SELECT MAX(OSH.`order_status_history_id`) as `order_status_history_id`
        FROM tbl_order_status_history as OSH
        GROUP BY OSH.`order_id`
      ) sOSH ON OSH.`order_status_history_id` = sOSH.`order_status_history_id`
    ) OSH ON ORD.`order_id` = OSH.`order_id`
    INNER JOIN tbl_order_status as OST
      ON OSH.`order_status_id` = OST.`order_status_id`
    INNER JOIN (
      SELECT
        OIT.*,
        VAR.`variation_type_name`,
        PLN.`plan_name`,
        AFF.`affiliation_name`
      FROM tbl_order_item as OIT
      LEFT JOIN tbl_product_variation as PRD_VAR
        ON OIT.`product_variation_id` = PRD_VAR.`product_variation_id`
      LEFT JOIN tbl_variation_type as VAR
        ON PRD_VAR.`variation_type_id` = VAR.`variation_type_id`
      LEFT JOIN tbl_plan as PLN
        ON PRD_VAR.`plan_id` = PLN.`plan_id`
      LEFT JOIN tbl_affiliation as AFF
        ON PRD_VAR.`affiliation_id` = AFF.`affiliation_id`
      ORDER BY ISNULL(PRD_VAR.`product_variation_id`)
    ) OIT ON ORD.`order_id` = OIT.`order_id`
    LEFT JOIN tbl_idtype as IDT
      ON ORD.`idtype_id` = IDT.`idtype_id`
    LEFT JOIN tbl_branch as BCH
      ON ORD.`branch_id` = BCH.`branch_id`';

  SET where_query = '
    GROUP BY ORD.`order_id`
    ORDER BY ORD.`created_at` DESC
  ';

  -- ORDER BY
  IF (sort_by <> '') THEN
    SET where_query = CONCAT(where_query, ', ORD.', sort_by);
    IF(sort_direction IN ('ASC','DESC')) THEN
      SET where_query = CONCAT(where_query, " ", sort_direction);
    END IF;
  END IF;

  -- setting actual page if wrong value
  IF (pag_actual < 1) THEN
    SET pag_actual = 1;
  END IF;
  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  -- filter to pagination
  IF (pag_ini > 0 AND pag_total_by_page > 0) THEN
    SET where_query = CONCAT(where_query, ' LIMIT ',pag_ini,',', pag_total_by_page);
  ELSE
    IF (pag_total_by_page > 0) THEN
      SET where_query = CONCAT(where_query, ' LIMIT ',pag_total_by_page);
    END IF;
  END IF;

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Order Detail
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_orderDetail;

DELIMITER $$
--
-- Procedimiento para obtener el detalle de una orden
--
CREATE PROCEDURE PA_orderDetail(
  IN order_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET order_id = IFNULL(order_id, 0);

  SET select_query = 'SELECT
    ORD.*, OST.*, IDT.`idtype_name`,
    PMT.`method_name`, BCH.`branch_name`,
    BD.`district_name` as billing_district,
    DD.`district_name` as delivery_district,
    ORD.`created_at` as order_date,
    OSH.`created_at` as status_date';

  SET from_query = '
    FROM tbl_order as ORD
    LEFT JOIN tbl_order_status_history as OSH
      ON ORD.`order_id` = OSH.`order_id`
    LEFT JOIN tbl_order_status as OST
      ON OSH.`order_status_id` = OST.`order_status_id`
    LEFT JOIN tbl_idtype as IDT
      ON ORD.`idtype_id` = IDT.`idtype_id`
    LEFT JOIN tbl_payment_method as PMT
      ON ORD.`payment_method_id` = PMT.`payment_method_id`
    LEFT JOIN tbl_branch as BCH
      ON ORD.`branch_id` = BCH.`branch_id`
    LEFT JOIN tbl_district as BD
      ON ORD.`billing_district` = BD.`district_id`
    LEFT JOIN tbl_district as DD
      ON ORD.`delivery_district` = DD.`district_id`';

  SET where_query = CONCAT('
    WHERE ORD.`order_id` = ', order_id, '
    ORDER BY OSH.`created_at` DESC
    LIMIT 1'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Order Status History
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_orderStatusHistory;

DELIMITER $$
--
-- Procedimiento para obtener el detalle de una orden
--
CREATE PROCEDURE PA_orderStatusHistory(
  IN order_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET order_id = IFNULL(order_id, 0);

  SET select_query = 'SELECT
    OSH.*, OST.`order_status_name`';

  SET from_query = '
    FROM tbl_order_status_history as OSH
    LEFT JOIN tbl_order_status as OST
      ON OSH.`order_status_id` = OST.`order_status_id`';

  SET where_query = CONCAT('
    WHERE OSH.`order_id` = ', order_id, '
    ORDER BY OSH.`created_at` DESC'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END $$

DELIMITER ;

-- ------------------------------------------
-- Plan Slug by ID
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_planSlug;

DELIMITER $$
--
-- Procedimiento para el slug de un plan por su id
--
CREATE PROCEDURE PA_planSlug(
  IN plan_id INT
)
BEGIN

  SELECT PLN.`plan_slug`
  FROM tbl_plan as PLN
  WHERE PLN.`active` = 1 AND PLN.`plan_id` = plan_id;

END $$

DELIMITER ;

-- ------------------------------------------
-- Affiliation Slug by ID
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_affiliationSlug;

DELIMITER $$
--
-- Procedimiento para el slug de una afiliaciÃ³n por su id
--
CREATE PROCEDURE PA_affiliationSlug(
  IN affiliation_id INT
)
BEGIN

  SELECT AFF.`affiliation_slug`
  FROM tbl_affiliation as AFF
  WHERE AFF.`active` = 1 AND AFF.`affiliation_id` = affiliation_id;

END $$

DELIMITER ;

-- ------------------------------------------
-- Contract Slug by ID
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_contractSlug;

DELIMITER $$
--
-- Procedimiento para el slug de un contrato por su id
--
CREATE PROCEDURE PA_contractSlug(
  IN contract_id INT
)
BEGIN

  SELECT CTR.`contract_slug`
  FROM tbl_contract as CTR
  WHERE CTR.`active` = 1 AND CTR.`contract_id` = contract_id;

END $$

DELIMITER ;


-- ------------------------------------------
-- Disctricts List with Branch asiggned
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_districtList;

DELIMITER $$
--
-- Procedimiento para listar distritos pertenecientes a un branch
--
CREATE PROCEDURE PA_districtList(
)
BEGIN

  SELECT DS.`district_id`, DS.`province_id`, DS.`branch_id`, DS.`district_name`
  FROM tbl_branch as BR
  INNER JOIN tbl_district as DS ON BR.`branch_id`=DS.`branch_id`
  WHERE DS.`active`=1 AND BR.`active`=1
  ORDER BY DS.`district_name` ASC;

END $$

DELIMITER ;


-- ------------------------------------------
-- Get the branch ID for and District ID
-- ------------------------------------------

DROP PROCEDURE IF EXISTS PA_branchByDistrict;

DELIMITER $$
--
-- Procedimiento para obtener el branch_id de un distrito
--
CREATE PROCEDURE PA_branchByDistrict(
  IN _district_id INT
)
BEGIN

  SELECT BR.`branch_id`
  FROM tbl_branch as BR
  INNER JOIN tbl_district as DS ON BR.`branch_id`=DS.`branch_id`
  WHERE DS.`district_id` = _district_id;

END $$

DELIMITER ;
