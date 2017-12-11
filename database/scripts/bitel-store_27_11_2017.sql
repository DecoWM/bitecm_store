-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-12-2017 a las 23:03:00
-- Versión del servidor: 5.7.20-log
-- Versión de PHP: 7.1.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bitel_ecommerce`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_affiliationList` ()  BEGIN
    --
    DECLARE stored_query TEXT;
    
    SET stored_query = '
        SELECT affiliation_id,affiliation_name,affiliation_slug
        FROM tbl_affiliation
        ORDER BY weight ASC';

    -- Executing query
    SET @consulta = stored_query;
    -- select @consulta;
    PREPARE exec_strquery FROM @consulta;
    EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_affiliationSlug` (IN `affiliation_id` INT)  BEGIN
  
  SELECT AFF.`affiliation_slug`
  FROM tbl_affiliation as AFF
  WHERE AFF.`active` = 1 AND AFF.`affiliation_id` = affiliation_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_branchByDistrict` (IN `_district_id` INT)  BEGIN

  SELECT BR.`branch_id`
  FROM tbl_branch as BR 
  INNER JOIN tbl_district as DS ON BR.`branch_id`=DS.`branch_id`
  WHERE DS.`district_id` = _district_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_brandList` ()  BEGIN
    --
    DECLARE stored_query TEXT;
    
    SET stored_query = '
        SELECT brand_id,brand_name
        FROM tbl_brand
        ORDER BY weight ASC';

    -- Executing query
    SET @consulta = stored_query;
    -- select @consulta;
    PREPARE exec_strquery FROM @consulta;
    EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_contractSlug` (IN `contract_id` INT)  BEGIN

  SELECT CTR.`contract_slug`
  FROM tbl_contract as CTR
  WHERE CTR.`active` = 1 AND CTR.`contract_id` = contract_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_districtList` ()  BEGIN

  SELECT DS.`district_id`, DS.`province_id`, DS.`branch_id`, DS.`district_name`
  FROM tbl_branch as BR 
  INNER JOIN tbl_district as DS ON BR.`branch_id`=DS.`branch_id`
  WHERE DS.`active`=1 AND BR.`active`=1
  ORDER BY DS.`district_name` ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_orderDetail` (IN `order_id` INT)  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  
  SET order_id = IFNULL(order_id, 0);

  SET select_query = 'SELECT
    ORD.*, OST.*, IDT.`idtype_name`,
    PMT.`method_name`, BCH.`branch_name`,
    PMT.`method_name`,
    ORD.`created_at` as order_date,
    OSH.`created_at` as status_date';

  SET from_query = '
    FROM tbl_order as ORD
    INNER JOIN tbl_order_status_history as OSH
      ON ORD.`order_id` = OSH.`order_id`
    INNER JOIN tbl_order_status as OST
      ON OSH.`order_status_id` = OST.`order_status_id`
    INNER JOIN tbl_idtype as IDT
      ON ORD.`idtype_id` = IDT.`idtype_id`
    INNER JOIN tbl_payment_method as PMT
      ON ORD.`payment_method_id` = PMT.`payment_method_id`
    INNER JOIN tbl_branch as BCH
      ON ORD.`branch_id` = BCH.`branch_id`';

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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_orderItems` (IN `order_id` INT)  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  
  SET order_id = IFNULL(order_id, 0);

  SET select_query = 'SELECT
    OIT.*, PRM.*, PRD.*,
    STM.`stock_model_id`, STM.`stock_model_code`,
    PRD_VAR.`variation_type_id`,
    PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price`,
    BRN.`brand_name`, BRN.`brand_slug`,
    PLN.`plan_name`, PLN.`plan_slug`,
    PLN.`plan_price`, PLN.`product_code`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    CLR.`color_name`, CLR.`color_slug`';

  SET from_query = '
    FROM tbl_order_item as OIT
    INNER JOIN tbl_stock_model as STM
      ON OIT.`stock_model_id` = STM.`stock_model_id`
    INNER JOIN tbl_product as PRD
      ON STM.`product_id` = PRD.`product_id`
    INNER JOIN tbl_brand as BRN
      ON BRN.`brand_id` = PRD.`brand_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD_VAR.`product_id` = PRD.`product_id`
    LEFT JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    LEFT JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    LEFT JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`
    LEFT JOIN tbl_promo as PRM
      ON PRM.`promo_id` = OIT.`promo_id`';

  SET where_query = CONCAT('
    WHERE OIT.`order_id` = ', order_id, '
      AND (OIT.`product_variation_id` = PRD_VAR.`product_variation_id`
        OR OIT.`product_variation_id` IS NULL)
      AND (OIT.`promo_id` = PRM.`promo_id`
        OR OIT.`promo_id` IS NULL)'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_orderSearch` (IN `pag_total_by_page` INT, IN `pag_actual` INT, IN `sort_by` VARCHAR(50), IN `sort_direction` VARCHAR(5))  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  DECLARE pag_ini INT;
  DECLARE pag_end INT;

  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  -- SET product_string_search = IFNULL(product_string_search, '');
  SET sort_by = IFNULL(sort_by, '');
  SET sort_direction = IFNULL(sort_direction, '');

  SET select_query = 'SELECT
    ORD.*, OIT.*,
    OST.`order_status_name`,
    ORD.`created_at`,
    IDT.`idtype_name`,
    BCH.`branch_name`,
    VAR.`variation_type_name`,
    PLN.`plan_name`,
    AFF.`affiliation_name`';

  SET from_query = '
    FROM tbl_order as ORD
    INNER JOIN tbl_order_item as OIT
      ON ORD.`order_id` = OIT.`order_id`
    LEFT JOIN tbl_order_status_history as OSH
      ON ORD.`order_id` = OSH.`order_id`
    LEFT JOIN tbl_order_status as OST
      ON OSH.`order_status_id` = OST.`order_status_id`
    LEFT JOIN tbl_idtype as IDT
      ON ORD.`idtype_id` = IDT.`idtype_id`
    LEFT JOIN tbl_branch as BCH
      ON ORD.`branch_id` = BCH.`branch_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON OIT.`product_variation_id` = PRD_VAR.`product_variation_id`
    LEFT JOIN tbl_variation_type as VAR
      ON PRD_VAR.`variation_type_id` = VAR.`variation_type_id`
    LEFT JOIN tbl_plan as PLN
      ON PRD_VAR.`plan_id` = PLN.`plan_id`
    LEFT JOIN tbl_affiliation as AFF
      ON PRD_VAR.`affiliation_id` = AFF.`affiliation_id`';

  SET where_query = 'GROUP BY ORD.`order_id`';

  SET where_query = CONCAT(where_query, '
    ORDER BY OSH.`created_at` DESC');
  
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_orderStatusHistory` (IN `order_id` INT)  BEGIN
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_planList` (`plan_type` INT)  BEGIN
  --
  DECLARE stored_query TEXT;

  SET plan_type = IFNULL(plan_type, -1); -- set value if null  
  
  SET stored_query = '
    SELECT *
    FROM tbl_plan';

  IF (plan_type > 0) THEN
    SET stored_query = CONCAT(stored_query, ' WHERE plan_type = ', plan_type);
  END IF;

  SET stored_query = CONCAT(stored_query, ' ORDER BY weight ASC');

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_planSlug` (IN `plan_id` INT)  BEGIN
  
  SELECT PLN.`plan_slug`
  FROM tbl_plan as PLN
  WHERE PLN.`active` = 1 AND PLN.`plan_id` = plan_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productBySlug` (IN `brand_slug` VARCHAR(150), IN `product_slug` VARCHAR(150), IN `color_slug` VARCHAR(150))  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  
  SET brand_slug = IFNULL(brand_slug, '');
  SET product_slug = IFNULL(product_slug, '');
  SET color_slug = IFNULL(color_slug, '');

  SET select_query = 'SELECT
    DISTINCT(PRD.product_id),
    BRN.`brand_id`, BRN.`brand_name`';

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
        ON PRD.`product_id` = STM.`product_id`
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
        ON PRD.`product_id` = STM.`product_id`
      LEFT JOIN tbl_color as CLR
        ON STM.`color_id` = CLR.`color_id`');
  END IF;

  SET select_query = CONCAT(select_query, ',
    PRM.*, PRD.*');
  SET from_query = CONCAT(from_query, '
    LEFT JOIN tbl_promo as PRM
      ON PRD.`product_id` = PRM.`product_id`');
  SET where_query = CONCAT(where_query, ' 
    AND (PRM.`product_variation_id` IS NULL
      OR PRM.`promo_id` IS NULL)');

  SET where_query = CONCAT(where_query, ' LIMIT 1');

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productByStock` (IN `stock_model_id` INT)  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  
  SET stock_model_id = IFNULL(stock_model_id, 0);

  SET select_query = 'SELECT
    DISTINCT(PRD.product_id), PRM.*, PRD.*,
    STM.`stock_model_id`, STM.`stock_model_code`,
    BRN.`brand_name`, BRN.`brand_slug`,
    CLR.`color_name`, CLR.`color_slug`,';

  SET from_query = '
    FROM tbl_stock_model as STM
    INNER JOIN tbl_product as PRD
      ON STM.`product_id` = PRD.`product_id`
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`
    LEFT JOIN tbl_promo as PRM
      ON PRD.`product_id` = PRM.`product_id`';

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND STM.`stock_model_id` = ', stock_model_id, '
      AND (PRM.`product_variation_id` IS NULL
        OR PRM.`promo_id` IS NULL)'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productCount` (IN `category_id` INT, IN `product_brands` VARCHAR(200), IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255))  BEGIN
  --
  DECLARE stored_query TEXT;
  DECLARE cad_condition VARCHAR(255);
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;

  -- conditional string query
  SET cad_condition = "";

  -- checking null values
  SET category_id = IFNULL(category_id, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');
  
  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (category_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id = ', category_id);
  END IF;
  -- conditional filter for brand
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND (PRD.product_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_price >= ',product_price_ini);
  END IF;

  SET select_segment = 'SELECT COUNT(PRD.product_id) as total_products';

  SET join_segment = '
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`';

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

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productCountPostpago` (IN `category_id` INT, IN `product_brands` VARCHAR(200), IN `affiliation_id` INT, IN `plan_id` INT, IN `contract_id` INT, IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255))  BEGIN
  --
  DECLARE stored_query TEXT;
  DECLARE cad_condition VARCHAR(255);
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  -- conditional string query
  SET cad_condition = "";
  -- checking null values
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET category_id = IFNULL(category_id, -1); -- set value if null
  SET plan_id = IFNULL(plan_id, -1); -- set value if null
  SET affiliation_id = IFNULL(affiliation_id, -1); -- set value if null
  SET contract_id = IFNULL(contract_id, -1); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');

  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ',product_price_ini);
  END IF;
  -- conditional filter for brand
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;
  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (category_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id = ', category_id);
  END IF;
  -- conditional filter for plan
  IF (plan_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PLN.plan_id = ', plan_id);
  ELSE
    SET cad_condition = CONCAT(cad_condition, ' AND PLN.plan_id = 1');
  END IF;
  -- conditional filter for affiliation
  IF (affiliation_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND AFF.affiliation_id = ', affiliation_id);
  ELSE
    SET cad_condition = CONCAT(cad_condition, ' AND AFF.affiliation_id = 7');
  END IF;
  -- conditional filter for contract
  IF (contract_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND CTR.contract_id = ', contract_id);
  ELSE
    SET cad_condition = CONCAT(cad_condition, ' AND CTR.contract_id = 1');
  END IF;

  SET select_segment = 'SELECT COUNT(PRD.product_id) as total_products';

  SET join_segment = '
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Get product variations
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    -- Filter by affiliation
    LEFT JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    -- Filter by plan
    LEFT JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    -- Filter by contract
    INNER JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`';

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

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productCountPrepago` (IN `category_id` INT, IN `product_brands` VARCHAR(200), IN `plan_id` INT, IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255))  BEGIN
  --
  DECLARE stored_query TEXT;
  DECLARE cad_condition VARCHAR(255);
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  -- conditional string query
  SET cad_condition = "";
  -- checking null values
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET category_id = IFNULL(category_id, -1); -- set value if null
  SET plan_id = IFNULL(plan_id, -1); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');

  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND (PRD_VAR.product_variation_price BETWEEN ', (product_price_ini - 0.5), ' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD_VAR.product_variation_price >= ', product_price_ini);
  END IF;
  -- conditional filter for brand
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;
  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (category_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id = ', category_id);
  END IF;
  -- conditional filter for plan
  IF (plan_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PLN.plan_id = ', plan_id);
  ELSE
    SET cad_condition = CONCAT(cad_condition, ' AND PLN.plan_id = 14');
  END IF;

  SET select_segment = 'SELECT COUNT(PRD.product_id) as total_products';

  SET join_segment = '
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Get product variations
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRD.`product_id` = PRD_VAR.`product_id`
    -- Filter by plan
    INNER JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`';

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

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productCountPromo` (IN `plan_pre_id` INT, IN `plan_post_id` INT, IN `product_brands` VARCHAR(200), IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255))  BEGIN
  --
  DECLARE pag_ini INT;
  DECLARE pag_end INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  -- conditional string query
  SET cad_condition = "";
  -- checking null values
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET product_string_search = IFNULL(product_string_search, '');
  SET plan_pre_id = IFNULL(plan_pre_id, -1); -- set value if null
  SET plan_post_id = IFNULL(plan_post_id, -1); -- set value if null
  
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND (PRM.promo_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRM.promo_price >= ',product_price_ini);
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;

  SET select_segment = 'SELECT COUNT(PRM.promo_id) as total_promos';

  SET join_segment = '
    FROM tbl_promo as PRM
    INNER JOIN tbl_product as PRD
      ON PRD.`product_id` = PRM.`product_id`
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    INNER JOIN tbl_category as CAT
      ON PRD.`category_id` = CAT.`category_id`
    LEFT JOIN tbl_product_variation as PRD_VAR
      ON PRM.`product_variation_id` = PRD_VAR.`product_variation_id`
    LEFT JOIN tbl_affiliation as AFF
      ON AFF.`affiliation_id` = PRD_VAR.`affiliation_id`
    LEFT JOIN tbl_plan as PLN
      ON PLN.`plan_id` = PRD_VAR.`plan_id`
    LEFT JOIN tbl_contract as CTR
      ON CTR.`contract_id` = PRD_VAR.`contract_id`';

  -- checking if is search query
  IF product_string_search <> ''  THEN
    -- is a search and require MATCH
    SET stored_query = CONCAT(select_segment,
      join_segment, '
      -- Filter by search words
      WHERE PRM.`active` = 1 AND PRD.`active` = 1
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')  )
    ');
  ELSE
    -- If this is not a search
    SET stored_query = CONCAT(select_segment, 
      join_segment, '
      -- Filter by search words
      WHERE PRM.`active` = 1 AND PRD.`active` = 1');
  END IF;

  IF (plan_pre_id > 0 AND plan_post_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, '
      AND PRM.`promo_id` IS NOT NULL
      AND ((PRM.`allow_all_variations` = TRUE
          AND PRD_VAR.`product_variation_id` IS NOT NULL
          AND ((PRD_VAR.`variation_type_id` = 1
              AND PRD_VAR.`plan_id` = ', plan_pre_id, ')
            OR (PRD_VAR.`variation_type_id` = 2
              AND PRD_VAR.`plan_id` = ', plan_post_id, ')))
        OR PRM.`product_variation_id` IS NULL
        OR PRM.`product_variation_id` = PRD_VAR.`product_variation_id`)
      GROUP BY PRM.`promo_id`');
  ELSE
    SET cad_condition = CONCAT(cad_condition, '
      AND PRM.`promo_id` IS NOT NULL
      AND (PRM.`allow_all_variations` = TRUE
        OR PRM.`product_variation_id` IS NULL
        OR PRM.`product_variation_id` = PRD_VAR.`product_variation_id`)
      GROUP BY PRM.`promo_id`');
  END IF;

  -- CONCAT query, condition AND order
  SET stored_query = CONCAT(stored_query, cad_condition);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productDetail` (IN `product_id` INT)  BEGIN
  --
  SELECT
    PRD.*,
    PRD.`product_image_url` as picture_url,
    BRN.`brand_name`, BRN.`brand_slug`,
    CAT.`category_name`, CAT.`category_id`
  FROM tbl_product as PRD
  INNER JOIN tbl_brand as BRN
    ON PRD.`brand_id` = BRN.`brand_id`
  INNER JOIN tbl_category as CAT
    ON PRD.`category_id` = CAT.`category_id`
  WHERE PRD.`product_id` = product_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productImagesByStock` (IN `stock_model_id` INT)  BEGIN
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
    WHERE stock_model_id = ', stock_model_id
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productPostpagoBySlug` (IN `brand_slug` VARCHAR(150), IN `product_slug` VARCHAR(150), IN `affiliation_slug` VARCHAR(150), IN `plan_slug` VARCHAR(150), IN `contract_slug` VARCHAR(150), IN `color_slug` VARCHAR(150))  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET brand_slug = IFNULL(brand_slug, '');
  SET product_slug = IFNULL(product_slug, '');
  SET affiliation_slug = IFNULL(affiliation_slug, '');
  SET plan_slug = IFNULL(plan_slug, '');
  SET contract_slug = IFNULL(contract_slug, '');
  SET color_slug = IFNULL(color_slug, '');

  SET select_query = 'SELECT
    DISTINCT(PRD.product_id),
    PRM.*, PRD.*, 
    PRD_VAR.`variation_type_id`,
    PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    BRN.`brand_id`, BRN.`brand_name`, BRN.`brand_slug`,
    AFF.`affiliation_id`, AFF.`affiliation_name`, AFF.`affiliation_slug`,
    PLN.`plan_id`, PLN.`plan_name`, PLN.`plan_slug`,
    CTR.`contract_id`, CTR.`contract_name`, CTR.`contract_slug`';

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
        ON PRD.`product_id` = STM.`product_id`
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
        ON PRD.`product_id` = STM.`product_id`
      LEFT JOIN tbl_color as CLR
        ON STM.`color_id` = CLR.`color_id`');
  END IF;

  SET from_query = CONCAT(from_query, '
    LEFT JOIN tbl_promo as PRM
      ON PRD.`product_id` = PRM.`product_id`');
  SET where_query = CONCAT(where_query, ' 
    AND PRD_VAR.`variation_type_id` = 2
    AND ((PRM.`allow_all_variations` = TRUE
        AND (PRM.`allowed_variation_type_id` = 2
          OR PRM.`allowed_variation_type_id` IS NULL))
      OR PRM.`product_variation_id` = PRD_VAR.`product_variation_id`
      OR PRM.`promo_id` IS NULL)');

  SET where_query = CONCAT(where_query, ' LIMIT 1');

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productPostpagoByStock` (IN `stock_model_id` INT, IN `product_variation_id` INT)  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  
  SET stock_model_id = IFNULL(stock_model_id, 0);
  SET product_variation_id = IFNULL(product_variation_id, 0);

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
    CLR.`color_name`, CLR.`color_slug`';

  SET from_query = '
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
      ON PRD.`product_id` = PRM.`product_id`';

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND STM.`stock_model_id` = ', stock_model_id, '
      AND PRD_VAR.`product_variation_id` = ', product_variation_id,' 
      AND ((PRM.`allow_all_variations` = TRUE
          AND (PRM.`allowed_variation_type_id` = 2
            OR PRM.`allowed_variation_type_id` IS NULL))
        OR PRM.`product_variation_id` = PRD_VAR.`product_variation_id`
        OR PRM.`promo_id` IS NULL)'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productPrepagoBySlug` (IN `brand_slug` VARCHAR(150), IN `product_slug` VARCHAR(150), IN `plan_slug` VARCHAR(150), IN `color_slug` VARCHAR(150))  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  
  SET brand_slug = IFNULL(brand_slug, '');
  SET product_slug = IFNULL(product_slug, '');
  SET plan_slug = IFNULL(plan_slug, '');
  SET color_slug = IFNULL(color_slug, '');

  SET select_query = 'SELECT
    DISTINCT(PRD.product_id),
    PRM.*, PRD.*, PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    BRN.`brand_id`, BRN.`brand_name`, BRN.`brand_slug`,
    PLN.`plan_id`, PLN.`plan_name`, PLN.`plan_slug`';

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
        ON PRD.`product_id` = STM.`product_id`
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
        ON PRD.`product_id` = STM.`product_id`
      LEFT JOIN tbl_color as CLR
        ON STM.`color_id` = CLR.`color_id`');
  END IF;

  SET from_query = CONCAT(from_query, '
    LEFT JOIN tbl_promo as PRM
      ON PRD.`product_id` = PRM.`product_id`');
  SET where_query = CONCAT(where_query, ' 
    AND PRD_VAR.`variation_type_id` = 1
    AND ((PRM.`allow_all_variations` = TRUE
      AND (PRM.`allowed_variation_type_id` = 1
        OR PRM.`allowed_variation_type_id` IS NULL))
      OR PRM.`product_variation_id` = PRD_VAR.`product_variation_id`
      OR PRM.`promo_id` IS NULL)');

  SET where_query = CONCAT(where_query, ' LIMIT 1');

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productPrepagoByStock` (IN `stock_model_id` INT, IN `product_variation_id` INT)  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  
  SET stock_model_id = IFNULL(stock_model_id, 0);
  SET product_variation_id = IFNULL(product_variation_id, 0);

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
    CLR.`color_name`, CLR.`color_slug`';

  SET from_query = '
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
      ON PRD.`product_id` = PRM.`product_id`';

  SET where_query = CONCAT('
    WHERE PRD.`active` = 1
      AND STM.`stock_model_id` = ', stock_model_id, '
      AND PRD_VAR.`product_variation_id` = ', product_variation_id,' 
      AND ((PRM.`allow_all_variations` = TRUE
          AND (PRM.`allowed_variation_type_id` = 1
            OR PRM.`allowed_variation_type_id` IS NULL))
        OR PRM.`product_variation_id` = PRD_VAR.`product_variation_id`
        OR PRM.`promo_id` IS NULL)'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productSearch` (IN `category_id` INT, IN `product_brands` VARCHAR(200), IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255), IN `pag_total_by_page` INT, IN `pag_actual` INT, IN `sort_by` VARCHAR(50), IN `sort_direction` VARCHAR(5))  BEGIN
  --
  DECLARE pag_ini INT;
  DECLARE pag_end INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE cad_order TEXT;
  DECLARE cad_order_comma VARCHAR(2);
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  -- conditional string query
  SET cad_condition = "";
  SET cad_order = " ";
  SET cad_order_comma = " ";
  -- checking null values
  SET category_id = IFNULL(category_id, -1); -- set value if null
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');
  SET sort_by = IFNULL(sort_by,'');
  SET sort_direction = IFNULL(sort_direction,'');
  
  -- conditional filter for category (smartphone, tablet, basic, etc)
  IF (category_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id = ', category_id);
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
    SET cad_condition = CONCAT(cad_condition, ' AND (PRD.product_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.product_price >= ',product_price_ini);
  END IF;

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  SET select_segment = 'SELECT
    DISTINCT(PRD.`product_id`),
    PRM.*, PRD.*, STM.`stock_model_id`,
    PRD.`product_image_url` AS picture_url,
    BRN.`brand_name`, BRN.`brand_slug`,';

  SET join_segment = '
    FROM tbl_product as PRD
    -- Filter by brand
    INNER JOIN tbl_brand as BRN
      ON PRD.`brand_id` = BRN.`brand_id`
    -- Check stock models
    LEFT JOIN tbl_stock_model as STM
      ON PRD.`product_id` = STM.`product_id`
    -- Check promos
    LEFT JOIN tbl_promo as PRM
      ON PRD.`product_id` = PRM.`product_id`';

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
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')  )
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
    ISNULL(PRM.`publish_at`),
    PRM.`publish_at` DESC');

  SET cad_condition = CONCAT(cad_condition, '
    AND (
      (
        PRM.`promo_id` IS NOT NULL
        AND PRM.`active` = 1
        AND PRM.`product_variation_id` IS NULL
        AND PRM.`allow_all_variations` = 0
        AND PRM.`publish_at` IS NOT NULL
      )
      OR PRM.`promo_id` IS NULL
    )');

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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productSearchPostpago` (IN `category_id` INT, IN `product_brands` VARCHAR(200), IN `affiliation_id` INT, IN `plan_id` INT, IN `contract_id` INT, IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255), IN `pag_total_by_page` INT, IN `pag_actual` INT, IN `sort_by` VARCHAR(50), IN `sort_direction` VARCHAR(5))  BEGIN

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
  SET category_id = IFNULL(category_id, -1); -- set value if null
  SET plan_id = IFNULL(plan_id, 7); -- set value 7 (Postpago iChip 99.9) if null
  SET affiliation_id = IFNULL(affiliation_id, 1); -- set value 1 (Portabilidad) if null
  SET contract_id = IFNULL(contract_id, 1); -- set value 1 (18 meses) if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET product_string_search = IFNULL(product_string_search, '');
  SET sort_by = IFNULL(sort_by, '');
  SET sort_direction = IFNULL(sort_direction, '');
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
  IF (category_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id = ', category_id);
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

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = 'SELECT
        PRMsub.promo_id
    FROM
    tbl_promo as PRMsub
    WHERE
        PRMsub.product_id = PRD.product_id
    AND
        (
            PRMsub.allow_all_variations = 1
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

    ';

  SET select_segment = 'SELECT
    DISTINCT(PRD.`product_id`), PRD.*, PRD.`product_image_url` AS picture_url, PRD_VAR.`product_variation_id`, PRD_VAR.`product_variation_price` as product_price,
    
    PRM.promo_id, PRM.promo_price, PRM.promo_discount, PRM.promo_add_product_price, PRM.promo_add_product_discount, PRM.promo_title, PRM.promo_description, PRM.`publish_at`, STM.`stock_model_id`,
    PLN.`plan_id`, PLN.`plan_name`,
    PLN.`plan_price`, PLN.`plan_slug`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    BRN.`brand_name`, BRN.`brand_slug`,
    FORMAT(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price,';

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
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')  )
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
    ISNULL(PRM.`publish_at`),
    PRM.`publish_at` DESC');

  -- validation for PLAN and promo price
  SET cad_condition = CONCAT(cad_condition, ' 
    AND PRD_VAR.`variation_type_id` = ',variation_type_id,'
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productSearchPrepago` (IN `category_id` INT, IN `product_brands` VARCHAR(200), IN `plan_id` INT, IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255), IN `pag_total_by_page` INT, IN `pag_actual` INT, IN `sort_by` VARCHAR(50), IN `sort_direction` VARCHAR(5))  BEGIN
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
  SET plan_id = IFNULL(plan_id, 14); -- set value 14 (Prepago B-Voz) if null
  SET category_id = IFNULL(category_id, -1); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET product_string_search = IFNULL(product_string_search,'');
  SET sort_by = IFNULL(sort_by,'');
  SET sort_direction = IFNULL(sort_direction,'');
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
  IF (category_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.category_id = ', category_id);
  END IF;
  -- conditional filter for plan
  IF (plan_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PLN.plan_id = ', plan_id);
  END IF;

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  -- Define the price promo select segment (subQuery)
  SET select_idpromo_segment = 'SELECT
        PRMsub.promo_id
    FROM
    tbl_promo as PRMsub
    WHERE
        PRMsub.product_id = PRD.product_id
    AND
        (
            PRMsub.allow_all_variations = 1
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

    ';

  SET select_segment = 'SELECT
    DISTINCT(PRD.`product_id`),
    PRM.*, PRD.*, STM.`stock_model_id`,
    PRD.`product_image_url` AS picture_url,
    PRD_VAR.`product_variation_id`,
    PRD_VAR.`product_variation_price` as product_price,
    PLN.`plan_id`, PLN.`plan_name`, PLN.`plan_price`, PLN.`plan_slug`,
    BRN.`brand_name`, BRN.`brand_slug`,
    FORMAT(IF(PRM.promo_discount IS NOT NULL, ((1-PRM.promo_discount) * PRD_VAR.product_variation_price), IFNULL(PRM.promo_price,product_variation_price)),2) as promo_price,';

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
        AND (MATCH(PRD.`product_model`, PRD.`product_keywords`, PRD.`product_description`) AGAINST(''',product_string_search,''')
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')  )
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
    ISNULL(PRM.`publish_at`),
    PRM.`publish_at` DESC');

  SET cad_condition = CONCAT(cad_condition, ' 
    AND PRD_VAR.`variation_type_id` = ',variation_type_id);

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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productSearchPromo` (IN `plan_pre_id` INT, IN `plan_post_id` INT, IN `affiliation_id` INT, IN `contract_id` INT, IN `product_brands` VARCHAR(200), IN `product_price_ini` DECIMAL(6,2), IN `product_price_end` DECIMAL(6,2), IN `product_string_search` VARCHAR(255), IN `pag_total_by_page` INT, IN `pag_actual` INT, IN `sort_by` VARCHAR(50), IN `sort_direction` VARCHAR(5))  BEGIN
  --
  DECLARE pag_ini INT;
  DECLARE pag_end INT;
  DECLARE stored_query TEXT;
  DECLARE cad_condition TEXT;
  DECLARE cad_order VARCHAR(70);
  DECLARE cad_order_comma VARCHAR(2);
  DECLARE select_segment TEXT;
  DECLARE join_segment TEXT;
  -- conditional string query
  SET cad_condition = "";
  SET cad_order = " ";
  SET cad_order_comma = " ";
  -- checking null values
  SET plan_pre_id = IFNULL(plan_pre_id, -1); -- set value if null
  SET plan_post_id = IFNULL(plan_post_id, -1); -- set value if null
  SET affiliation_id = IFNULL(affiliation_id, -1); -- set value if null
  SET contract_id = IFNULL(contract_id, -1); -- set value if null
  SET product_price_ini = IFNULL(product_price_ini, -1); -- set value if null
  SET product_price_end = IFNULL(product_price_end, -1); -- set value if null
  SET product_brands = IFNULL(product_brands, ''); -- set value if null
  SET pag_actual = IFNULL(pag_actual, 0); -- set value if null
  SET pag_total_by_page = IFNULL(pag_total_by_page, 8); -- set value if null
  SET product_string_search = IFNULL(product_string_search, '');
  SET sort_by = IFNULL(sort_by, '');
  SET sort_direction = IFNULL(sort_direction, '');
  -- setting actual page if wrong value
  IF (pag_actual < 1) THEN
    SET pag_actual = 1;
  END IF;
  -- cad_condition filter for price
  IF (product_price_ini > 0 AND product_price_end > 0) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND (PRM.promo_price BETWEEN ',(product_price_ini - 0.5),' AND ', (product_price_end + 0.5) , ') ');
  END IF;
  IF (product_price_ini > 0 AND product_price_end < 1) THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRM.promo_price >= ',product_price_ini);
  END IF;
  -- conditional filter for manufacturer
  IF (product_brands <> '') THEN
    SET cad_condition = CONCAT(cad_condition, ' AND PRD.brand_id IN (', product_brands,')');
  END IF;

  -- Define the inital row
  SET pag_ini = (pag_actual - 1) * pag_total_by_page;
  -- Define the final row
  SET pag_end = pag_actual * pag_total_by_page;

  SET select_segment = 'SELECT
    PRM.*, PRD.*, PRD_VAR.*,
    PRD.`product_image_url` AS picture_url,
    STM.`stock_model_id`,
    PLN.`plan_id`, PLN.`plan_name`,
    PLN.`plan_price`, PLN.`plan_slug`,
    AFF.`affiliation_name`, AFF.`affiliation_slug`,
    CTR.`contract_name`, CTR.`contract_slug`,
    BRN.`brand_name`, BRN.`brand_slug`,';

  SET join_segment = '
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
      ON PRD.`product_id` = PRM.`product_id`';

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
        OR MATCH(BRN.`brand_name`) AGAINST(''',product_string_search,''')  )
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

  IF (plan_pre_id > 0 AND plan_post_id > 0 AND affiliation_id > 0 AND contract_id > 0) THEN
    SET cad_condition = CONCAT(cad_condition, '
      AND STM.`stock_model_id` IS NOT NULL
      AND PRM.`promo_id` IS NOT NULL
      AND PRM.`publish_at` IS NOT NULL
      AND (
        PRD_VAR.`product_variation_id` IS NULL
        OR
        (
          PRM.`allow_all_variations` = FALSE
          AND PRM.`product_variation_id` IS NOT NULL
          AND PRD_VAR.`product_variation_id` IS NOT NULL
          AND PRM.`product_variation_id` = PRD_VAR.`product_variation_id`
        )
        OR
        (
          PRM.`allow_all_variations` = TRUE
          AND PRM.`product_variation_id` IS NULL
          AND PRD_VAR.`product_variation_id` IS NOT NULL
          AND
          (
            (
              PRM.`allowed_variation_type_id` IS NOT NULL
              AND PRM.`allowed_variation_type_id` = 1
              AND PRD_VAR.`variation_type_id` = 1
              AND PRD_VAR.`plan_id` = ', plan_pre_id, '
            )
            OR
            (
              PRM.`allowed_variation_type_id` IS NOT NULL
              AND PRM.`allowed_variation_type_id` = 2
              AND PRD_VAR.`variation_type_id` = 2
              AND PRD_VAR.`plan_id` = ', plan_post_id, '
              AND PRD_VAR.`affiliation_id` = ', affiliation_id, '
              AND PRD_VAR.`contract_id` = ', contract_id, '
            )
            OR
            (
              PRM.`allowed_variation_type_id` IS NULL
              AND PRD_VAR.`variation_type_id` = 1
              AND PRD_VAR.`plan_id` = ', plan_pre_id, '
            )
            OR
            (
              PRM.`allowed_variation_type_id` IS NULL
              AND PRD_VAR.`variation_type_id` = 2
              AND PRD_VAR.`plan_id` = ', plan_post_id, '
              AND PRD_VAR.`affiliation_id` = ', affiliation_id, '
              AND PRD_VAR.`contract_id` = ', contract_id, '
            )
          )
        )
      )
      GROUP BY PRM.`promo_id`');
  ELSE
    SET cad_condition = CONCAT(cad_condition, '
      AND STM.`stock_model_id` IS NOT NULL
      AND PRM.`promo_id` IS NOT NULL
      AND PRM.`publish_at` IS NOT NULL
      AND (
        PRD_VAR.`product_variation_id` IS NULL
        OR
        (
          PRM.`allow_all_variations` = FALSE
          AND PRM.`product_variation_id` IS NOT NULL
          AND PRD_VAR.`product_variation_id` IS NOT NULL
          AND PRM.`product_variation_id` = PRD_VAR.`product_variation_id`
        )
        OR
        (
          PRM.`allow_all_variations` = TRUE
          AND PRM.`product_variation_id` IS NULL
          AND PRD_VAR.`product_variation_id` IS NOT NULL
          AND
          (
            (
              PRM.`allowed_variation_type_id` IS NOT NULL
              AND PRM.`allowed_variation_type_id` = 1
              AND PRD_VAR.`variation_type_id` = 1
            )
            OR
            (
              PRM.`allowed_variation_type_id` IS NOT NULL
              AND PRM.`allowed_variation_type_id` = 2
              AND PRD_VAR.`variation_type_id` = 2
            )
            OR
            (
              PRM.`allowed_variation_type_id` IS NULL
              AND PRD_VAR.`variation_type_id` = 1
            )
            OR
            (
              PRM.`allowed_variation_type_id` IS NULL
              AND PRD_VAR.`variation_type_id` = 2
            )
          )
        )
      )
      GROUP BY PRM.`promo_id`');
  END IF;

  -- ORDER BY
  IF (sort_by <> '') THEN
    SET cad_order = CONCAT(cad_order, cad_order_comma, 'PRM.', sort_by);
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_productStockModels` (IN `product_id` INT)  BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;

  SET product_id = IFNULL(product_id, 0);

  SET select_query = 'SELECT
    STM.`stock_model_id`,
    STM.`stock_model_code`,
    CLR.`color_id`,
    CLR.`color_hexcode`,
    CLR.`color_slug` ';

  SET from_query = '
    FROM tbl_stock_model as STM
    LEFT JOIN tbl_color as CLR
      ON STM.`color_id` = CLR.`color_id`';

  SET where_query = CONCAT('
    WHERE STM.`product_id` = ', product_id, '
      AND CLR.`color_id` IS NOT NULL'
  );

  SET stored_query = CONCAT(select_query, from_query, where_query);

  -- Executing query
  SET @consulta = stored_query;
  -- select @consulta;
  PREPARE exec_strquery FROM @consulta;
  EXECUTE exec_strquery;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_variationTypeList` ()  BEGIN
    --
    DECLARE stored_query TEXT;
    
    SET stored_query = '
        SELECT *
        FROM tbl_variation_type
        ORDER BY weight ASC';

    -- Executing query
    SET @consulta = stored_query;
    -- select @consulta;
    PREPARE exec_strquery FROM @consulta;
    EXECUTE exec_strquery;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_affiliation`
--

CREATE TABLE `tbl_affiliation` (
  `affiliation_id` int(11) NOT NULL,
  `affiliation_name` varchar(45) NOT NULL,
  `affiliation_slug` varchar(150) DEFAULT NULL,
  `weight` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_affiliation`
--

INSERT INTO `tbl_affiliation` (`affiliation_id`, `affiliation_name`, `affiliation_slug`, `weight`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Portabilidad', 'portabilidad', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Linea Nueva', 'linea-nueva', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(3, 'Renovación', 'renovacion', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_branch`
--

CREATE TABLE `tbl_branch` (
  `branch_id` int(11) NOT NULL,
  `branch_name` varchar(50) NOT NULL,
  `zip_code` varchar(50) NOT NULL,
  `branch_address` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_branch`
--

INSERT INTO `tbl_branch` (`branch_id`, `branch_name`, `zip_code`, `branch_address`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'LI1', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1),
(2, 'LI2', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1),
(3, 'LI3', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1),
(4, 'LI4', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1),
(5, 'LI5', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1),
(6, 'LI6', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1),
(7, 'LI7', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1),
(8, 'LI8', '', NULL, '2017-12-11 12:49:13', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_brand`
--

CREATE TABLE `tbl_brand` (
  `brand_id` int(11) NOT NULL,
  `brand_name` varchar(20) NOT NULL,
  `brand_slug` varchar(150) DEFAULT NULL,
  `weight` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_brand`
--

INSERT INTO `tbl_brand` (`brand_id`, `brand_name`, `brand_slug`, `weight`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Alcatel', 'alcatel', 1, '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Bitel', 'bitel', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(3, 'Huawei', 'huawei', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(4, 'Lenovo', 'lenovo', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(5, 'LG', 'lg', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(6, 'Samsung', 'samsung', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(7, 'Sky', 'sky', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_category`
--

CREATE TABLE `tbl_category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(25) NOT NULL,
  `category_slug` varchar(150) DEFAULT NULL,
  `allow_variation` tinyint(1) NOT NULL DEFAULT '1',
  `weight` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_category`
--

INSERT INTO `tbl_category` (`category_id`, `category_name`, `category_slug`, `allow_variation`, `weight`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Equipos', 'equipos', 1, 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Accesorios', 'accesorios', 0, 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_color`
--

CREATE TABLE `tbl_color` (
  `color_id` int(11) NOT NULL,
  `color_name` varchar(50) NOT NULL,
  `color_hexcode` varchar(8) DEFAULT NULL,
  `color_slug` varchar(150) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_color`
--

INSERT INTO `tbl_color` (`color_id`, `color_name`, `color_hexcode`, `color_slug`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Black', '000000', 'black', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Grey', 'D3D3D3', 'grey', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(3, 'Silver', 'BCC6CC', 'silver', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(4, 'Rose', 'FFE4E1', 'rose', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(5, 'Titan', '0C2340', 'titan', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_contract`
--

CREATE TABLE `tbl_contract` (
  `contract_id` int(11) NOT NULL,
  `contract_name` varchar(50) NOT NULL,
  `contract_months` int(11) NOT NULL,
  `contract_slug` varchar(150) DEFAULT NULL,
  `weight` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_contract`
--

INSERT INTO `tbl_contract` (`contract_id`, `contract_name`, `contract_months`, `contract_slug`, `weight`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, '18 meses', 18, '18-meses', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_department`
--

CREATE TABLE `tbl_department` (
  `departament_id` int(11) NOT NULL,
  `departament_name` varchar(50) NOT NULL,
  `country_id` int(11) NOT NULL DEFAULT '51',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_department`
--

INSERT INTO `tbl_department` (`departament_id`, `departament_name`, `country_id`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'AMAZONAS', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2, 'ANCASH', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3, 'APURIMAC', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(4, 'AREQUIPA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(5, 'AYACUCHO', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(6, 'CAJAMARCA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(7, 'CALLAO', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(8, 'CUSCO', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(9, 'HUANCAVELICA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(10, 'HUANUCO', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(11, 'ICA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(12, 'JUNIN', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(13, 'LA LIBERTAD', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(14, 'LAMBAYEQUE', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(15, 'LIMA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(16, 'LORETO', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(17, 'MADRE DE DIOS', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(18, 'MOQUEGUA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(19, 'PASCO', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(20, 'PIURA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(21, 'PUNO', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(22, 'SAN MARTIN', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(23, 'TACNA', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(24, 'TUMBES', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(25, 'UCAYALI', 167, NULL, NULL, NULL, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_district`
--

CREATE TABLE `tbl_district` (
  `disctric_id` int(11) NOT NULL,
  `province_id` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `district_name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_district`
--

INSERT INTO `tbl_district` (`disctric_id`, `province_id`, `branch_id`, `district_name`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 1, NULL, 'CHACHAPOYAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2, 1, NULL, 'ASUNCION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3, 1, NULL, 'BALSAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(4, 1, NULL, 'CHETO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(5, 1, NULL, 'CHILIQUIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(6, 1, NULL, 'CHUQUIBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(7, 1, NULL, 'GRANADA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(8, 1, NULL, 'HUANCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(9, 1, NULL, 'LA JALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(10, 1, NULL, 'LEIMEBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(11, 1, NULL, 'LEVANTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(12, 1, NULL, 'MAGDALENA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(13, 1, NULL, 'MARISCAL CASTILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(14, 1, NULL, 'MOLINOPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(15, 1, NULL, 'MONTEVIDEO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(16, 1, NULL, 'OLLEROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(17, 1, NULL, 'QUINJALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(18, 1, NULL, 'SAN FRANCISCO DE DAGUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(19, 1, NULL, 'SAN ISIDRO DE MAINO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(20, 1, NULL, 'SOLOCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(21, 1, NULL, 'SONCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(22, 2, NULL, 'BAGUA 5/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(23, 2, NULL, 'ARAMANGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(24, 2, NULL, 'COPALLIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(25, 2, NULL, 'EL PARCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(26, 2, NULL, 'IMAZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(27, 2, NULL, 'LA PECA 5/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(28, 3, NULL, 'JUMBILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(29, 3, NULL, 'CHISQUILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(30, 3, NULL, 'CHURUJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(31, 3, NULL, 'COROSHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(32, 3, NULL, 'CUISPES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(33, 3, NULL, 'FLORIDA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(34, 3, NULL, 'JAZAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(35, 3, NULL, 'RECTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(36, 3, NULL, 'SAN CARLOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(37, 3, NULL, 'SHIPASBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(38, 3, NULL, 'VALERA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(39, 3, NULL, 'YAMBRASBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(40, 4, NULL, 'NIEVA 6/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(41, 4, NULL, 'EL CENEPA 6/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(42, 4, NULL, 'RIO SANTIAGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(43, 5, NULL, 'LAMUD', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(44, 5, NULL, 'CAMPORREDONDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(45, 5, NULL, 'COCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(46, 5, NULL, 'COLCAMAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(47, 5, NULL, 'CONILA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(48, 5, NULL, 'INGUILPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(49, 5, NULL, 'LONGUITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(50, 5, NULL, 'LONYA CHICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(51, 5, NULL, 'LUYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(52, 5, NULL, 'LUYA VIEJO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(53, 5, NULL, 'MARIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(54, 5, NULL, 'OCALLI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(55, 5, NULL, 'OCUMAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(56, 5, NULL, 'PISUQUIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(57, 5, NULL, 'PROVIDENCIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(58, 5, NULL, 'SAN CRISTOBAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(59, 5, NULL, 'SAN FRANCISCO DEL YESO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(60, 5, NULL, 'SAN JERONIMO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(61, 5, NULL, 'SAN JUAN DE LOPECANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(62, 5, NULL, 'SANTA CATALINA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(63, 5, NULL, 'SANTO TOMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(64, 5, NULL, 'TINGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(65, 5, NULL, 'TRITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(66, 6, NULL, 'SAN NICOLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(67, 6, NULL, 'CHIRIMOTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(68, 6, NULL, 'COCHAMAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(69, 6, NULL, 'HUAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(70, 6, NULL, 'LIMABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(71, 6, NULL, 'LONGAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(72, 6, NULL, 'MARISCAL BENAVIDES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(73, 6, NULL, 'MILPUC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(74, 6, NULL, 'OMIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(75, 6, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(76, 6, NULL, 'TOTORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(77, 6, NULL, 'VISTA ALEGRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(78, 7, NULL, 'BAGUA GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(79, 7, NULL, 'CAJARURO 6/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(80, 7, NULL, 'CUMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(81, 7, NULL, 'EL MILAGRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(82, 7, NULL, 'JAMALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(83, 7, NULL, 'LONYA GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(84, 7, NULL, 'YAMON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(85, 8, NULL, 'HUARAZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(86, 8, NULL, 'COCHABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(87, 8, NULL, 'COLCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(88, 8, NULL, 'HUANCHAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(89, 8, NULL, 'INDEPENDENCIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(90, 8, NULL, 'JANGAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(91, 8, NULL, 'LA LIBERTAD', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(92, 8, NULL, 'OLLEROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(93, 8, NULL, 'PAMPAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(94, 8, NULL, 'PARIACOTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(95, 8, NULL, 'PIRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(96, 8, NULL, 'TARICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(97, 9, NULL, 'AIJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(98, 9, NULL, 'CORIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(99, 9, NULL, 'HUACLLAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(100, 9, NULL, 'LA MERCED', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(101, 9, NULL, 'SUCCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(102, 10, NULL, 'LLAMELLIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(103, 10, NULL, 'ACZO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(104, 10, NULL, 'CHACCHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(105, 10, NULL, 'CHINGAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(106, 10, NULL, 'MIRGAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(107, 10, NULL, 'SAN JUAN DE RONTOY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(108, 11, NULL, 'CHACAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(109, 11, NULL, 'ACOCHACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(110, 12, NULL, 'CHIQUIAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(111, 12, NULL, 'ABELARDO PARDO LEZAMETA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(112, 12, NULL, 'ANTONIO RAYMONDI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(113, 12, NULL, 'AQUIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(114, 12, NULL, 'CAJACAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(115, 12, NULL, 'CANIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(116, 12, NULL, 'COLQUIOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(117, 12, NULL, 'HUALLANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(118, 12, NULL, 'HUASTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(119, 12, NULL, 'HUAYLLACAYAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(120, 12, NULL, 'LA PRIMAVERA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(121, 12, NULL, 'MANGAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(122, 12, NULL, 'PACLLON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(123, 12, NULL, 'SAN MIGUEL DE CORPANQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(124, 12, NULL, 'TICLLOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(125, 13, NULL, 'CARHUAZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(126, 13, NULL, 'ACOPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(127, 13, NULL, 'AMASHCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(128, 13, NULL, 'ANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(129, 13, NULL, 'ATAQUERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(130, 13, NULL, 'MARCARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(131, 13, NULL, 'PARIAHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(132, 13, NULL, 'SAN MIGUEL DE ACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(133, 13, NULL, 'SHILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(134, 13, NULL, 'TINCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(135, 13, NULL, 'YUNGAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(136, 14, NULL, 'SAN LUIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(137, 14, NULL, 'SAN NICOLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(138, 14, NULL, 'YAUYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(139, 15, NULL, 'CASMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(140, 15, NULL, 'BUENA VISTA ALTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(141, 15, NULL, 'COMANDANTE NOEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(142, 15, NULL, 'YAUTAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(143, 16, NULL, 'CORONGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(144, 16, NULL, 'ACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(145, 16, NULL, 'BAMBAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(146, 16, NULL, 'CUSCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(147, 16, NULL, 'LA PAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(148, 16, NULL, 'YANAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(149, 16, NULL, 'YUPAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(150, 17, NULL, 'HUARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(151, 17, NULL, 'ANRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(152, 17, NULL, 'CAJAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(153, 17, NULL, 'CHAVIN DE HUANTAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(154, 17, NULL, 'HUACACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(155, 17, NULL, 'HUACCHIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(156, 17, NULL, 'HUACHIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(157, 17, NULL, 'HUANTAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(158, 17, NULL, 'MASIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(159, 17, NULL, 'PAUCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(160, 17, NULL, 'PONTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(161, 17, NULL, 'RAHUAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(162, 17, NULL, 'RAPAYAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(163, 17, NULL, 'SAN MARCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(164, 17, NULL, 'SAN PEDRO DE CHANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(165, 17, NULL, 'UCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(166, 18, NULL, 'HUARMEY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(167, 18, NULL, 'COCHAPETI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(168, 18, NULL, 'CULEBRAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(169, 18, NULL, 'HUAYAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(170, 18, NULL, 'MALVAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(171, 19, NULL, 'CARAZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(172, 19, NULL, 'HUALLANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(173, 19, NULL, 'HUATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(174, 19, NULL, 'HUAYLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(175, 19, NULL, 'MATO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(176, 19, NULL, 'PAMPAROMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(177, 19, NULL, 'PUEBLO LIBRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(178, 19, NULL, 'SANTA CRUZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(179, 19, NULL, 'SANTO TORIBIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(180, 19, NULL, 'YURACMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(181, 20, NULL, 'PISCOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(182, 20, NULL, 'CASCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(183, 20, NULL, 'ELEAZAR GUZMAN BARRON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(184, 20, NULL, 'FIDEL OLIVAS ESCUDERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(185, 20, NULL, 'LLAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(186, 20, NULL, 'LLUMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(187, 20, NULL, 'LUCMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(188, 20, NULL, 'MUSGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(189, 21, NULL, 'OCROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(190, 21, NULL, 'ACAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(191, 21, NULL, 'CAJAMARQUILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(192, 21, NULL, 'CARHUAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(193, 21, NULL, 'COCHAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(194, 21, NULL, 'CONGAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(195, 21, NULL, 'LLIPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(196, 21, NULL, 'SAN CRISTOBAL DE RAJAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(197, 21, NULL, 'SAN PEDRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(198, 21, NULL, 'SANTIAGO DE CHILCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(199, 22, NULL, 'CABANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(200, 22, NULL, 'BOLOGNESI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(201, 22, NULL, 'CONCHUCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(202, 22, NULL, 'HUACASCHUQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(203, 22, NULL, 'HUANDOVAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(204, 22, NULL, 'LACABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(205, 22, NULL, 'LLAPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(206, 22, NULL, 'PALLASCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(207, 22, NULL, 'PAMPAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(208, 22, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(209, 22, NULL, 'TAUCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(210, 23, NULL, 'POMABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(211, 23, NULL, 'HUAYLLAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(212, 23, NULL, 'PAROBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(213, 23, NULL, 'QUINUABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(214, 24, NULL, 'RECUAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(215, 24, NULL, 'CATAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(216, 24, NULL, 'COTAPARACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(217, 24, NULL, 'HUAYLLAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(218, 24, NULL, 'LLACLLIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(219, 24, NULL, 'MARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(220, 24, NULL, 'PAMPAS CHICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(221, 24, NULL, 'PARARIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(222, 24, NULL, 'TAPACOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(223, 24, NULL, 'TICAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(224, 25, NULL, 'CHIMBOTE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(225, 25, NULL, 'CACERES DEL PERU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(226, 25, NULL, 'COISHCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(227, 25, NULL, 'MACATE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(228, 25, NULL, 'MORO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(229, 25, NULL, 'NEPEÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(230, 25, NULL, 'SAMANCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(231, 25, NULL, 'SANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(232, 25, NULL, 'NUEVO CHIMBOTE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(233, 26, NULL, 'SIHUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(234, 26, NULL, 'ACOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(235, 26, NULL, 'ALFONSO UGARTE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(236, 26, NULL, 'CASHAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(237, 26, NULL, 'CHINGALPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(238, 26, NULL, 'HUAYLLABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(239, 26, NULL, 'QUICHES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(240, 26, NULL, 'RAGASH', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(241, 26, NULL, 'SAN JUAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(242, 26, NULL, 'SICSIBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(243, 27, NULL, 'YUNGAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(244, 27, NULL, 'CASCAPARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(245, 27, NULL, 'MANCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(246, 27, NULL, 'MATACOTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(247, 27, NULL, 'QUILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(248, 27, NULL, 'RANRAHIRCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(249, 27, NULL, 'SHUPLUY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(250, 27, NULL, 'YANAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(251, 28, NULL, 'ABANCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(252, 28, NULL, 'CHACOCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(253, 28, NULL, 'CIRCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(254, 28, NULL, 'CURAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(255, 28, NULL, 'HUANIPACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(256, 28, NULL, 'LAMBRAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(257, 28, NULL, 'PICHIRHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(258, 28, NULL, 'SAN PEDRO DE CACHORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(259, 28, NULL, 'TAMBURCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(260, 29, NULL, 'ANDAHUAYLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(261, 29, NULL, 'ANDARAPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(262, 29, NULL, 'CHIARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(263, 29, NULL, 'HUANCARAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(264, 29, NULL, 'HUANCARAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(265, 29, NULL, 'HUAYANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(266, 29, NULL, 'KISHUARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(267, 29, NULL, 'PACOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(268, 29, NULL, 'PACUCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(269, 29, NULL, 'PAMPACHIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(270, 29, NULL, 'POMACOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(271, 29, NULL, 'SAN ANTONIO DE CACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(272, 29, NULL, 'SAN JERONIMO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(273, 29, NULL, 'SAN MIGUEL DE CHACCRAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(274, 29, NULL, 'SANTA MARIA DE CHICMO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(275, 29, NULL, 'TALAVERA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(276, 29, NULL, 'TUMAY HUARACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(277, 29, NULL, 'TURPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(278, 29, NULL, 'KAQUIABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(279, 30, NULL, 'ANTABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(280, 30, NULL, 'EL ORO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(281, 30, NULL, 'HUAQUIRCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(282, 30, NULL, 'JUAN ESPINOZA MEDRANO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(283, 30, NULL, 'OROPESA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(284, 30, NULL, 'PACHACONAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(285, 30, NULL, 'SABAINO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(286, 31, NULL, 'CHALHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(287, 31, NULL, 'CAPAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(288, 31, NULL, 'CARAYBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(289, 31, NULL, 'CHAPIMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(290, 31, NULL, 'COLCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(291, 31, NULL, 'COTARUSE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(292, 31, NULL, 'HUAYLLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(293, 31, NULL, 'JUSTO APU SAHUARAURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(294, 31, NULL, 'LUCRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(295, 31, NULL, 'POCOHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(296, 31, NULL, 'SAN JUAN DE CHACÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(297, 31, NULL, 'SAÑAYCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(298, 31, NULL, 'SORAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(299, 31, NULL, 'TAPAIRIHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(300, 31, NULL, 'TINTAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(301, 31, NULL, 'TORAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(302, 31, NULL, 'YANACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(303, 32, NULL, 'TAMBOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(304, 32, NULL, 'COTABAMBAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(305, 32, NULL, 'COYLLURQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(306, 32, NULL, 'HAQUIRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(307, 32, NULL, 'MARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(308, 32, NULL, 'CHALLHUAHUACHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(309, 33, NULL, 'CHINCHEROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(310, 33, NULL, 'ANCO-HUALLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(311, 33, NULL, 'COCHARCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(312, 33, NULL, 'HUACCANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(313, 33, NULL, 'OCOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(314, 33, NULL, 'ONGOY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(315, 33, NULL, 'URANMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(316, 33, NULL, 'RANRACANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(317, 34, NULL, 'CHUQUIBAMBILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(318, 34, NULL, 'CURPAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(319, 34, NULL, 'GAMARRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(320, 34, NULL, 'HUAYLLATI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(321, 34, NULL, 'MAMARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(322, 34, NULL, 'MICAELA BASTIDAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(323, 34, NULL, 'PATAYPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(324, 34, NULL, 'PROGRESO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(325, 34, NULL, 'SAN ANTONIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(326, 34, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(327, 34, NULL, 'TURPAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(328, 34, NULL, 'VILCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(329, 34, NULL, 'VIRUNDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(330, 34, NULL, 'CURASCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(331, 35, NULL, 'AREQUIPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(332, 35, NULL, 'ALTO SELVA ALEGRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(333, 35, NULL, 'CAYMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(334, 35, NULL, 'CERRO COLORADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(335, 35, NULL, 'CHARACATO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(336, 35, NULL, 'CHIGUATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(337, 35, NULL, 'JACOBO HUNTER', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(338, 35, NULL, 'LA JOYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(339, 35, NULL, 'MARIANO MELGAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(340, 35, NULL, 'MIRAFLORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(341, 35, NULL, 'MOLLEBAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(342, 35, NULL, 'PAUCARPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(343, 35, NULL, 'POCSI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(344, 35, NULL, 'POLOBAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(345, 35, NULL, 'QUEQUEÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(346, 35, NULL, 'SABANDIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(347, 35, NULL, 'SACHACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(348, 35, NULL, 'SAN JUAN DE SIGUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(349, 35, NULL, 'SAN JUAN DE TARUCANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(350, 35, NULL, 'SANTA ISABEL DE SIGUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(351, 35, NULL, 'SANTA RITA DE SIGUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(352, 35, NULL, 'SOCABAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(353, 35, NULL, 'TIABAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(354, 35, NULL, 'UCHUMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(355, 35, NULL, 'VITOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(356, 35, NULL, 'YANAHUARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(357, 35, NULL, 'YARABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(358, 35, NULL, 'YURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(359, 35, NULL, 'JOSE LUIS BUSTAMANTE Y RIVERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(360, 36, NULL, 'CAMANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(361, 36, NULL, 'JOSE MARIA QUIMPER', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(362, 36, NULL, 'MARIANO NICOLAS VALCARCEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(363, 36, NULL, 'MARISCAL CACERES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(364, 36, NULL, 'NICOLAS DE PIEROLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(365, 36, NULL, 'OCOÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(366, 36, NULL, 'QUILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(367, 36, NULL, 'SAMUEL PASTOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(368, 37, NULL, 'CARAVELI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(369, 37, NULL, 'ACARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(370, 37, NULL, 'ATICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(371, 37, NULL, 'ATIQUIPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(372, 37, NULL, 'BELLA UNION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(373, 37, NULL, 'CAHUACHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(374, 37, NULL, 'CHALA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(375, 37, NULL, 'CHAPARRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(376, 37, NULL, 'HUANUHUANU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(377, 37, NULL, 'JAQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(378, 37, NULL, 'LOMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(379, 37, NULL, 'QUICACHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(380, 37, NULL, 'YAUCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(381, 38, NULL, 'APLAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(382, 38, NULL, 'ANDAGUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(383, 38, NULL, 'AYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(384, 38, NULL, 'CHACHAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(385, 38, NULL, 'CHILCAYMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(386, 38, NULL, 'CHOCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(387, 38, NULL, 'HUANCARQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(388, 38, NULL, 'MACHAGUAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(389, 38, NULL, 'ORCOPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(390, 38, NULL, 'PAMPACOLCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(391, 38, NULL, 'TIPAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(392, 38, NULL, 'UÑON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(393, 38, NULL, 'URACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(394, 38, NULL, 'VIRACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(395, 39, NULL, 'CHIVAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(396, 39, NULL, 'ACHOMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(397, 39, NULL, 'CABANACONDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(398, 39, NULL, 'CALLALLI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(399, 39, NULL, 'CAYLLOMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(400, 39, NULL, 'COPORAQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(401, 39, NULL, 'HUAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(402, 39, NULL, 'HUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(403, 39, NULL, 'ICHUPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(404, 39, NULL, 'LARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(405, 39, NULL, 'LLUTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(406, 39, NULL, 'MACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(407, 39, NULL, 'MADRIGAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(408, 39, NULL, 'SAN ANTONIO DE CHUCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(409, 39, NULL, 'SIBAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(410, 39, NULL, 'TAPAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(411, 39, NULL, 'TISCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(412, 39, NULL, 'TUTI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(413, 39, NULL, 'YANQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(414, 39, NULL, 'MAJES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(415, 40, NULL, 'CHUQUIBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(416, 40, NULL, 'ANDARAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(417, 40, NULL, 'CAYARANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(418, 40, NULL, 'CHICHAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(419, 40, NULL, 'IRAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(420, 40, NULL, 'RIO GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(421, 40, NULL, 'SALAMANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(422, 40, NULL, 'YANAQUIHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(423, 41, NULL, 'MOLLENDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(424, 41, NULL, 'COCACHACRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(425, 41, NULL, 'DEAN VALDIVIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(426, 41, NULL, 'ISLAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(427, 41, NULL, 'MEJIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(428, 41, NULL, 'PUNTA DE BOMBON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(429, 42, NULL, 'COTAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(430, 42, NULL, 'ALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(431, 42, NULL, 'CHARCANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(432, 42, NULL, 'HUAYNACOTAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(433, 42, NULL, 'PAMPAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(434, 42, NULL, 'PUYCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(435, 42, NULL, 'QUECHUALLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(436, 42, NULL, 'SAYLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(437, 42, NULL, 'TAURIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(438, 42, NULL, 'TOMEPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(439, 42, NULL, 'TORO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(440, 43, NULL, 'AYACUCHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(441, 43, NULL, 'ACOCRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(442, 43, NULL, 'ACOS VINCHOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(443, 43, NULL, 'CARMEN ALTO 7/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(444, 43, NULL, 'CHIARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(445, 43, NULL, 'OCROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(446, 43, NULL, 'PACAYCASA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(447, 43, NULL, 'QUINUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(448, 43, NULL, 'SAN JOSE DE TICLLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(449, 43, NULL, 'SAN JUAN BAUTISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(450, 43, NULL, 'SANTIAGO DE PISCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(451, 43, NULL, 'SOCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(452, 43, NULL, 'TAMBILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(453, 43, NULL, 'VINCHOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(454, 43, NULL, 'JESUS NAZARENO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(455, 44, NULL, 'CANGALLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(456, 44, NULL, 'CHUSCHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(457, 44, NULL, 'LOS MOROCHUCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(458, 44, NULL, 'MARIA PARADO DE BELLIDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(459, 44, NULL, 'PARAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(460, 44, NULL, 'TOTOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(461, 45, NULL, 'SANCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(462, 45, NULL, 'CARAPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(463, 45, NULL, 'SACSAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(464, 45, NULL, 'SANTIAGO DE LUCANAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(465, 46, NULL, 'HUANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(466, 46, NULL, 'AYAHUANCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(467, 46, NULL, 'HUAMANGUILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(468, 46, NULL, 'IGUAIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(469, 46, NULL, 'LURICOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(470, 46, NULL, 'SANTILLANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(471, 46, NULL, 'SIVIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(472, 46, NULL, 'LLOCHEGUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(473, 47, NULL, 'SAN MIGUEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(474, 47, NULL, 'ANCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(475, 47, NULL, 'AYNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(476, 47, NULL, 'CHILCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(477, 47, NULL, 'CHUNGUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(478, 47, NULL, 'LUIS CARRANZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(479, 47, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(480, 47, NULL, 'TAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(481, 48, NULL, 'PUQUIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(482, 48, NULL, 'AUCARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(483, 48, NULL, 'CABANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(484, 48, NULL, 'CARMEN SALCEDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(485, 48, NULL, 'CHAVIÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(486, 48, NULL, 'CHIPAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(487, 48, NULL, 'HUAC-HUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(488, 48, NULL, 'LARAMATE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(489, 48, NULL, 'LEONCIO PRADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(490, 48, NULL, 'LLAUTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(491, 48, NULL, 'LUCANAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(492, 48, NULL, 'OCAÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(493, 48, NULL, 'OTOCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(494, 48, NULL, 'SAISA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(495, 48, NULL, 'SAN CRISTOBAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(496, 48, NULL, 'SAN JUAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(497, 48, NULL, 'SAN PEDRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(498, 48, NULL, 'SAN PEDRO DE PALCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(499, 48, NULL, 'SANCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(500, 48, NULL, 'SANTA ANA DE HUAYCAHUACHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(501, 48, NULL, 'SANTA LUCIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(502, 49, NULL, 'CORACORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(503, 49, NULL, 'CHUMPI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(504, 49, NULL, 'CORONEL CASTAÑEDA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(505, 49, NULL, 'PACAPAUSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(506, 49, NULL, 'PULLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(507, 49, NULL, 'PUYUSCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(508, 49, NULL, 'SAN FRANCISCO DE RAVACAYCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(509, 49, NULL, 'UPAHUACHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(510, 50, NULL, 'PAUSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(511, 50, NULL, 'COLTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(512, 50, NULL, 'CORCULLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(513, 50, NULL, 'LAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(514, 50, NULL, 'MARCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(515, 50, NULL, 'OYOLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(516, 50, NULL, 'PARARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(517, 50, NULL, 'SAN JAVIER DE ALPABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(518, 50, NULL, 'SAN JOSE DE USHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(519, 50, NULL, 'SARA SARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(520, 51, NULL, 'QUEROBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(521, 51, NULL, 'BELEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(522, 51, NULL, 'CHALCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(523, 51, NULL, 'CHILCAYOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(524, 51, NULL, 'HUACAÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(525, 51, NULL, 'MORCOLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(526, 51, NULL, 'PAICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(527, 51, NULL, 'SAN PEDRO DE LARCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(528, 51, NULL, 'SAN SALVADOR DE QUIJE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(529, 51, NULL, 'SANTIAGO DE PAUCARAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(530, 51, NULL, 'SORAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(531, 52, NULL, 'HUANCAPI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(532, 52, NULL, 'ALCAMENCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(533, 52, NULL, 'APONGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(534, 52, NULL, 'ASQUIPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(535, 52, NULL, 'CANARIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(536, 52, NULL, 'CAYARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(537, 52, NULL, 'COLCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(538, 52, NULL, 'HUAMANQUIQUIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(539, 52, NULL, 'HUANCARAYLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(540, 52, NULL, 'HUAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(541, 52, NULL, 'SARHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(542, 52, NULL, 'VILCANCHOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(543, 53, NULL, 'VILCAS HUAMAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(544, 53, NULL, 'ACCOMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(545, 53, NULL, 'CARHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(546, 53, NULL, 'CONCEPCION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(547, 53, NULL, 'HUAMBALPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(548, 53, NULL, 'INDEPENDENCIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(549, 53, NULL, 'SAURAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(550, 53, NULL, 'VISCHONGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(551, 54, NULL, 'CAJAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(552, 54, NULL, 'ASUNCION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(553, 54, NULL, 'CHETILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(554, 54, NULL, 'COSPAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(555, 54, NULL, 'ENCAÑADA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(556, 54, NULL, 'JESUS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(557, 54, NULL, 'LLACANORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(558, 54, NULL, 'LOS BAÑOS DEL INCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(559, 54, NULL, 'MAGDALENA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(560, 54, NULL, 'MATARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(561, 54, NULL, 'NAMORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(562, 54, NULL, 'SAN JUAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(563, 55, NULL, 'CAJABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(564, 55, NULL, 'CACHACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(565, 55, NULL, 'CONDEBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(566, 55, NULL, 'SITACOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(567, 56, NULL, 'CELENDIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(568, 56, NULL, 'CHUMUCH', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(569, 56, NULL, 'CORTEGANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(570, 56, NULL, 'HUASMIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(571, 56, NULL, 'JORGE CHAVEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(572, 56, NULL, 'JOSE GALVEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(573, 56, NULL, 'MIGUEL IGLESIAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(574, 56, NULL, 'OXAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(575, 56, NULL, 'SOROCHUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(576, 56, NULL, 'SUCRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(577, 56, NULL, 'UTCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(578, 56, NULL, 'LA LIBERTAD DE PALLAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(579, 57, NULL, 'CHOTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(580, 57, NULL, 'ANGUIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(581, 57, NULL, 'CHADIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(582, 57, NULL, 'CHIGUIRIP', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(583, 57, NULL, 'CHIMBAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(584, 57, NULL, 'CHOROPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(585, 57, NULL, 'COCHABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(586, 57, NULL, 'CONCHAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(587, 57, NULL, 'HUAMBOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(588, 57, NULL, 'LAJAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(589, 57, NULL, 'LLAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(590, 57, NULL, 'MIRACOSTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(591, 57, NULL, 'PACCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(592, 57, NULL, 'PION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(593, 57, NULL, 'QUEROCOTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(594, 57, NULL, 'SAN JUAN DE LICUPIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(595, 57, NULL, 'TACABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(596, 57, NULL, 'TOCMOCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(597, 57, NULL, 'CHALAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(598, 58, NULL, 'CONTUMAZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(599, 58, NULL, 'CHILETE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(600, 58, NULL, 'CUPISNIQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(601, 58, NULL, 'GUZMANGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(602, 58, NULL, 'SAN BENITO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(603, 58, NULL, 'SANTA CRUZ DE TOLED', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(604, 58, NULL, 'TANTARICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(605, 58, NULL, 'YONAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(606, 59, NULL, 'CUTERVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(607, 59, NULL, 'CALLAYUC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(608, 59, NULL, 'CHOROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(609, 59, NULL, 'CUJILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(610, 59, NULL, 'LA RAMADA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(611, 59, NULL, 'PIMPINGOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(612, 59, NULL, 'QUEROCOTILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(613, 59, NULL, 'SAN ANDRES DE CUTERVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(614, 59, NULL, 'SAN JUAN DE CUTERVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(615, 59, NULL, 'SAN LUIS DE LUCMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(616, 59, NULL, 'SANTA CRUZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(617, 59, NULL, 'SANTO DOMINGO DE LA CAPILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(618, 59, NULL, 'SANTO TOMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(619, 59, NULL, 'SOCOTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(620, 59, NULL, 'TORIBIO CASANOVA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(621, 60, NULL, 'BAMBAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(622, 60, NULL, 'CHUGUR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(623, 60, NULL, 'HUALGAYOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(624, 61, NULL, 'JAEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(625, 61, NULL, 'BELLAVISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(626, 61, NULL, 'CHONTALI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(627, 61, NULL, 'COLASAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(628, 61, NULL, 'HUABAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(629, 61, NULL, 'LAS PIRIAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(630, 61, NULL, 'POMAHUACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(631, 61, NULL, 'PUCARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(632, 61, NULL, 'SALLIQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(633, 61, NULL, 'SAN FELIPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(634, 61, NULL, 'SAN JOSE DEL ALTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(635, 61, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(636, 62, NULL, 'SAN IGNACIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(637, 62, NULL, 'CHIRINOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(638, 62, NULL, 'HUARANGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(639, 62, NULL, 'LA COIPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(640, 62, NULL, 'NAMBALLE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(641, 62, NULL, 'SAN JOSE DE LOURDES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(642, 62, NULL, 'TABACONAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(643, 63, NULL, 'PEDRO GALVEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(644, 63, NULL, 'CHANCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(645, 63, NULL, 'EDUARDO VILLANUEVA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(646, 63, NULL, 'GREGORIO PITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(647, 63, NULL, 'ICHOCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(648, 63, NULL, 'JOSE MANUEL QUIROZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(649, 63, NULL, 'JOSE SABOGAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(650, 64, NULL, 'SAN MIGUEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(651, 64, NULL, 'BOLIVAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(652, 64, NULL, 'CALQUIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(653, 64, NULL, 'CATILLUC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(654, 64, NULL, 'EL PRADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(655, 64, NULL, 'LA FLORIDA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(656, 64, NULL, 'LLAPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(657, 64, NULL, 'NANCHOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(658, 64, NULL, 'NIEPOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(659, 64, NULL, 'SAN GREGORIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(660, 64, NULL, 'SAN SILVESTRE DE COCHAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(661, 64, NULL, 'TONGOD', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(662, 64, NULL, 'UNION AGUA BLANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(663, 65, NULL, 'SAN PABLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(664, 65, NULL, 'SAN BERNARDINO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(665, 65, NULL, 'SAN LUIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(666, 65, NULL, 'TUMBADEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(667, 66, NULL, 'SANTA CRUZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(668, 66, NULL, 'ANDABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(669, 66, NULL, 'CATACHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(670, 66, NULL, 'CHANCAYBAÑOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(671, 66, NULL, 'LA ESPERANZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(672, 66, NULL, 'NINABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(673, 66, NULL, 'PULAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(674, 66, NULL, 'SAUCEPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(675, 66, NULL, 'SEXI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(676, 66, NULL, 'UTICYACU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(677, 66, NULL, 'YAUYUCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(678, 67, 4, 'CALLAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(679, 67, 4, 'BELLAVISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(680, 67, 4, 'CARMEN DE LA LEGUA REYNOSO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(681, 67, 4, 'LA PERLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(682, 67, 4, 'LA PUNTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(683, 67, 6, 'VENTANILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(684, 68, NULL, 'CUSCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(685, 68, NULL, 'CCORCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(686, 68, NULL, 'POROY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(687, 68, NULL, 'SAN JERONIMO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(688, 68, NULL, 'SAN SEBASTIAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(689, 68, NULL, 'SANTIAGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(690, 68, NULL, 'SAYLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(691, 68, NULL, 'WANCHAQ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(692, 69, NULL, 'ACOMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(693, 69, NULL, 'ACOPIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(694, 69, NULL, 'ACOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(695, 69, NULL, 'MOSOC LLACTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(696, 69, NULL, 'POMACANCHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(697, 69, NULL, 'RONDOCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(698, 69, NULL, 'SANGARARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(699, 70, NULL, 'ANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(700, 70, NULL, 'ANCAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(701, 70, NULL, 'CACHIMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(702, 70, NULL, 'CHINCHAYPUJIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(703, 70, NULL, 'HUAROCONDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(704, 70, NULL, 'LIMATAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(705, 70, NULL, 'MOLLEPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(706, 70, NULL, 'PUCYURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(707, 70, NULL, 'ZURITE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(708, 71, NULL, 'CALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(709, 71, NULL, 'COYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(710, 71, NULL, 'LAMAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(711, 71, NULL, 'LARES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(712, 71, NULL, 'PISAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(713, 71, NULL, 'SAN SALVADOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(714, 71, NULL, 'TARAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(715, 71, NULL, 'YANATILE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(716, 72, NULL, 'YANAOCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(717, 72, NULL, 'CHECCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(718, 72, NULL, 'KUNTURKANKI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(719, 72, NULL, 'LANGUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(720, 72, NULL, 'LAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(721, 72, NULL, 'PAMPAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(722, 72, NULL, 'QUEHUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(723, 72, NULL, 'TUPAC AMARU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(724, 73, NULL, 'SICUANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(725, 73, NULL, 'CHECACUPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(726, 73, NULL, 'COMBAPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(727, 73, NULL, 'MARANGANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(728, 73, NULL, 'PITUMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(729, 73, NULL, 'SAN PABLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(730, 73, NULL, 'SAN PEDRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(731, 73, NULL, 'TINTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(732, 74, NULL, 'SANTO TOMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(733, 74, NULL, 'CAPACMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(734, 74, NULL, 'CHAMACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(735, 74, NULL, 'COLQUEMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(736, 74, NULL, 'LIVITACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(737, 74, NULL, 'LLUSCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(738, 74, NULL, 'QUIÑOTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(739, 74, NULL, 'VELILLE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(740, 75, NULL, 'ESPINAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(741, 75, NULL, 'CONDOROMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(742, 75, NULL, 'COPORAQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(743, 75, NULL, 'OCORURO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(744, 75, NULL, 'PALLPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(745, 75, NULL, 'PICHIGUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(746, 75, NULL, 'SUYCKUTAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO `tbl_district` (`disctric_id`, `province_id`, `branch_id`, `district_name`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(747, 75, NULL, 'ALTO PICHIGUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(748, 76, NULL, 'SANTA ANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(749, 76, NULL, 'ECHARATE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(750, 76, NULL, 'HUAYOPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(751, 76, NULL, 'MARANURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(752, 76, NULL, 'OCOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(753, 76, NULL, 'QUELLOUNO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(754, 76, NULL, 'KIMBIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(755, 76, NULL, 'SANTA TERESA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(756, 76, NULL, 'VILCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(757, 76, NULL, 'PICHARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(758, 77, NULL, 'PARURO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(759, 77, NULL, 'ACCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(760, 77, NULL, 'CCAPI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(761, 77, NULL, 'COLCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(762, 77, NULL, 'HUANOQUITE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(763, 77, NULL, 'OMACHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(764, 77, NULL, 'PACCARITAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(765, 77, NULL, 'PILLPINTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(766, 77, NULL, 'YAURISQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(767, 78, NULL, 'PAUCARTAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(768, 78, NULL, 'CAICAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(769, 78, NULL, 'CHALLABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(770, 78, NULL, 'COLQUEPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(771, 78, NULL, 'HUANCARANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(772, 78, NULL, 'KOSÑIPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(773, 79, NULL, 'URCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(774, 79, NULL, 'ANDAHUAYLILLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(775, 79, NULL, 'CAMANTI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(776, 79, NULL, 'CCARHUAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(777, 79, NULL, 'CCATCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(778, 79, NULL, 'CUSIPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(779, 79, NULL, 'HUARO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(780, 79, NULL, 'LUCRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(781, 79, NULL, 'MARCAPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(782, 79, NULL, 'OCONGATE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(783, 79, NULL, 'OROPESA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(784, 79, NULL, 'QUIQUIJANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(785, 80, NULL, 'URUBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(786, 80, NULL, 'CHINCHERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(787, 80, NULL, 'HUAYLLABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(788, 80, NULL, 'MACHUPICCHU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(789, 80, NULL, 'MARAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(790, 80, NULL, 'OLLANTAYTAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(791, 80, NULL, 'YUCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(792, 81, NULL, 'HUANCAVELICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(793, 81, NULL, 'ACOBAMBILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(794, 81, NULL, 'ACORIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(795, 81, NULL, 'CONAYCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(796, 81, NULL, 'CUENCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(797, 81, NULL, 'HUACHOCOLPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(798, 81, NULL, 'HUAYLLAHUARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(799, 81, NULL, 'IZCUCHACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(800, 81, NULL, 'LARIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(801, 81, NULL, 'MANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(802, 81, NULL, 'MARISCAL CACERES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(803, 81, NULL, 'MOYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(804, 81, NULL, 'NUEVO OCCORO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(805, 81, NULL, 'PALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(806, 81, NULL, 'PILCHACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(807, 81, NULL, 'VILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(808, 81, NULL, 'YAULI 8/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(809, 81, NULL, 'ASCENSION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(810, 81, NULL, 'HUANDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(811, 82, NULL, 'ACOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(812, 82, NULL, 'ANDABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(813, 82, NULL, 'ANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(814, 82, NULL, 'CAJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(815, 82, NULL, 'MARCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(816, 82, NULL, 'PAUCARA 8/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(817, 82, NULL, 'POMACOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(818, 82, NULL, 'ROSARIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(819, 83, NULL, 'LIRCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(820, 83, NULL, 'ANCHONGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(821, 83, NULL, 'CALLANMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(822, 83, NULL, 'CCOCHACCASA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(823, 83, NULL, 'CHINCHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(824, 83, NULL, 'CONGALLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(825, 83, NULL, 'HUANCA-HUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(826, 83, NULL, 'HUAYLLAY GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(827, 83, NULL, 'JULCAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(828, 83, NULL, 'SAN ANTONIO DE ANTAPARCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(829, 83, NULL, 'SANTO TOMAS DE PATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(830, 83, NULL, 'SECCLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(831, 84, NULL, 'CASTROVIRREYNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(832, 84, NULL, 'ARMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(833, 84, NULL, 'AURAHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(834, 84, NULL, 'CAPILLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(835, 84, NULL, 'CHUPAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(836, 84, NULL, 'COCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(837, 84, NULL, 'HUACHOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(838, 84, NULL, 'HUAMATAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(839, 84, NULL, 'MOLLEPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(840, 84, NULL, 'SAN JUAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(841, 84, NULL, 'SANTA ANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(842, 84, NULL, 'TANTARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(843, 84, NULL, 'TICRAPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(844, 85, NULL, 'CHURCAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(845, 85, NULL, 'ANCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(846, 85, NULL, 'CHINCHIHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(847, 85, NULL, 'EL CARMEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(848, 85, NULL, 'LA MERCED', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(849, 85, NULL, 'LOCROJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(850, 85, NULL, 'PAUCARBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(851, 85, NULL, 'SAN MIGUEL DE MAYOCC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(852, 85, NULL, 'SAN PEDRO DE CORIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(853, 85, NULL, 'PACHAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(854, 86, NULL, 'HUAYTARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(855, 86, NULL, 'AYAVI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(856, 86, NULL, 'CORDOVA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(857, 86, NULL, 'HUAYACUNDO ARMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(858, 86, NULL, 'LARAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(859, 86, NULL, 'OCOYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(860, 86, NULL, 'PILPICHACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(861, 86, NULL, 'QUERCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(862, 86, NULL, 'QUITO-ARMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(863, 86, NULL, 'SAN ANTONIO DE CUSICANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(864, 86, NULL, 'SAN FRANCISCO DE SANGAYAICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(865, 86, NULL, 'SAN ISIDRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(866, 86, NULL, 'SANTIAGO DE CHOCORVOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(867, 86, NULL, 'SANTIAGO DE QUIRAHUARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(868, 86, NULL, 'SANTO DOMINGO DE CAPILLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(869, 86, NULL, 'TAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(870, 87, NULL, 'PAMPAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(871, 87, NULL, 'ACOSTAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(872, 87, NULL, 'ACRAQUIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(873, 87, NULL, 'AHUAYCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(874, 87, NULL, 'COLCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(875, 87, NULL, 'DANIEL HERNANDEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(876, 87, NULL, 'HUACHOCOLPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(877, 87, NULL, 'HUARIBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(878, 87, NULL, 'ÑAHUIMPUQUIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(879, 87, NULL, 'PAZOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(880, 87, NULL, 'QUISHUAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(881, 87, NULL, 'SALCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(882, 87, NULL, 'SALCAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(883, 87, NULL, 'SAN MARCOS DE ROCCHAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(884, 87, NULL, 'SURCUBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(885, 87, NULL, 'TINTAY PUNCU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(886, 88, NULL, 'HUANUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(887, 88, NULL, 'AMARILIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(888, 88, NULL, 'CHINCHAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(889, 88, NULL, 'CHURUBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(890, 88, NULL, 'MARGOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(891, 88, NULL, 'QUISQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(892, 88, NULL, 'SAN FRANCISCO DE CAYRAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(893, 88, NULL, 'SAN PEDRO DE CHAULAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(894, 88, NULL, 'SANTA MARIA DEL VALLE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(895, 88, NULL, 'YARUMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(896, 88, NULL, 'PILLCO MARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(897, 89, NULL, 'AMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(898, 89, NULL, 'CAYNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(899, 89, NULL, 'COLPAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(900, 89, NULL, 'CONCHAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(901, 89, NULL, 'HUACAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(902, 89, NULL, 'SAN FRANCISCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(903, 89, NULL, 'SAN RAFAEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(904, 89, NULL, 'TOMAY KICHWA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(905, 90, NULL, 'LA UNION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(906, 90, NULL, 'CHUQUIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(907, 90, NULL, 'MARIAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(908, 90, NULL, 'PACHAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(909, 90, NULL, 'QUIVILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(910, 90, NULL, 'RIPAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(911, 90, NULL, 'SHUNQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(912, 90, NULL, 'SILLAPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(913, 90, NULL, 'YANAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(914, 91, NULL, 'HUACAYBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(915, 91, NULL, 'CANCHABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(916, 91, NULL, 'COCHABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(917, 91, NULL, 'PINRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(918, 92, NULL, 'LLATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(919, 92, NULL, 'ARANCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(920, 92, NULL, 'CHAVIN DE PARIARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(921, 92, NULL, 'JACAS GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(922, 92, NULL, 'JIRCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(923, 92, NULL, 'MIRAFLORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(924, 92, NULL, 'MONZON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(925, 92, NULL, 'PUNCHAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(926, 92, NULL, 'PUÑOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(927, 92, NULL, 'SINGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(928, 92, NULL, 'TANTAMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(929, 93, NULL, 'RUPA-RUPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(930, 93, NULL, 'DANIEL ALOMIA ROBLES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(931, 93, NULL, 'HERMILIO VALDIZAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(932, 93, NULL, 'JOSE CRESPO Y CASTILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(933, 93, NULL, 'LUYANDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(934, 93, NULL, 'MARIANO DAMASO BERAUN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(935, 94, NULL, 'HUACRACHUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(936, 94, NULL, 'CHOLON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(937, 94, NULL, 'SAN BUENAVENTURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(938, 95, NULL, 'PANAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(939, 95, NULL, 'CHAGLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(940, 95, NULL, 'MOLINO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(941, 95, NULL, 'UMARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(942, 96, NULL, 'PUERTO INCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(943, 96, NULL, 'CODO DEL POZUZO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(944, 96, NULL, 'HONORIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(945, 96, NULL, 'TOURNAVISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(946, 96, NULL, 'YUYAPICHIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(947, 97, NULL, 'JESUS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(948, 97, NULL, 'BAÑOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(949, 97, NULL, 'JIVIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(950, 97, NULL, 'QUEROPALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(951, 97, NULL, 'RONDOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(952, 97, NULL, 'SAN FRANCISCO DE ASIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(953, 97, NULL, 'SAN MIGUEL DE CAURI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(954, 98, NULL, 'CHAVINILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(955, 98, NULL, 'CAHUAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(956, 98, NULL, 'CHACABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(957, 98, NULL, 'APARICIO POMARES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(958, 98, NULL, 'JACAS CHICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(959, 98, NULL, 'OBAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(960, 98, NULL, 'PAMPAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(961, 98, NULL, 'CHORAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(962, 99, NULL, 'ICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(963, 99, NULL, 'LA TINGUIÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(964, 99, NULL, 'LOS AQUIJES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(965, 99, NULL, 'OCUCAJE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(966, 99, NULL, 'PACHACUTEC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(967, 99, NULL, 'PARCONA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(968, 99, NULL, 'PUEBLO NUEVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(969, 99, NULL, 'SALAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(970, 99, NULL, 'SAN JOSE DE LOS MOLINOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(971, 99, NULL, 'SAN JUAN BAUTISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(972, 99, NULL, 'SANTIAGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(973, 99, NULL, 'SUBTANJALLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(974, 99, NULL, 'TATE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(975, 99, NULL, 'YAUCA DEL ROSARIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(976, 100, NULL, 'CHINCHA ALTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(977, 100, NULL, 'ALTO LARAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(978, 100, NULL, 'CHAVIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(979, 100, NULL, 'CHINCHA BAJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(980, 100, NULL, 'EL CARMEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(981, 100, NULL, 'GROCIO PRADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(982, 100, NULL, 'PUEBLO NUEVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(983, 100, NULL, 'SAN JUAN DE YANAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(984, 100, NULL, 'SAN PEDRO DE HUACARPANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(985, 100, NULL, 'SUNAMPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(986, 100, NULL, 'TAMBO DE MORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(987, 101, NULL, 'NAZCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(988, 101, NULL, 'CHANGUILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(989, 101, NULL, 'EL INGENIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(990, 101, NULL, 'MARCONA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(991, 101, NULL, 'VISTA ALEGRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(992, 102, NULL, 'PALPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(993, 102, NULL, 'LLIPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(994, 102, NULL, 'RIO GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(995, 102, NULL, 'SANTA CRUZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(996, 102, NULL, 'TIBILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(997, 103, NULL, 'PISCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(998, 103, NULL, 'HUANCANO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(999, 103, NULL, 'HUMAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1000, 103, NULL, 'INDEPENDENCIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1001, 103, NULL, 'PARACAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1002, 103, NULL, 'SAN ANDRES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1003, 103, NULL, 'SAN CLEMENTE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1004, 103, NULL, 'TUPAC AMARU INCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1005, 104, NULL, 'HUANCAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1006, 104, NULL, 'CARHUACALLANGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1007, 104, NULL, 'CHACAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1008, 104, NULL, 'CHICCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1009, 104, NULL, 'CHILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1010, 104, NULL, 'CHONGOS ALTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1011, 104, NULL, 'CHUPURO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1012, 104, NULL, 'COLCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1013, 104, NULL, 'CULLHUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1014, 104, NULL, 'EL TAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1015, 104, NULL, 'HUACRAPUQUIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1016, 104, NULL, 'HUALHUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1017, 104, NULL, 'HUANCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1018, 104, NULL, 'HUASICANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1019, 104, NULL, 'HUAYUCACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1020, 104, NULL, 'INGENIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1021, 104, NULL, 'PARIAHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1022, 104, NULL, 'PILCOMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1023, 104, NULL, 'PUCARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1024, 104, NULL, 'QUICHUAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1025, 104, NULL, 'QUILCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1026, 104, NULL, 'SAN AGUSTIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1027, 104, NULL, 'SAN JERONIMO DE TUNAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1028, 104, NULL, 'SAÑO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1029, 104, NULL, 'SAPALLANGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1030, 104, NULL, 'SICAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1031, 104, NULL, 'SANTO DOMINGO DE ACOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1032, 104, NULL, 'VIQUES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1033, 105, NULL, 'CONCEPCION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1034, 105, NULL, 'ACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1035, 105, NULL, 'ANDAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1036, 105, NULL, 'CHAMBARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1037, 105, NULL, 'COCHAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1038, 105, NULL, 'COMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1039, 105, NULL, 'HEROINAS TOLEDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1040, 105, NULL, 'MANZANARES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1041, 105, NULL, 'MARISCAL CASTILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1042, 105, NULL, 'MATAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1043, 105, NULL, 'MITO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1044, 105, NULL, 'NUEVE DE JULIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1045, 105, NULL, 'ORCOTUNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1046, 105, NULL, 'SAN JOSE DE QUERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1047, 105, NULL, 'SANTA ROSA DE OCOPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1048, 106, NULL, 'CHANCHAMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1049, 106, NULL, 'PERENE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1050, 106, NULL, 'PICHANAQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1051, 106, NULL, 'SAN LUIS DE SHUARO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1052, 106, NULL, 'SAN RAMON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1053, 106, NULL, 'VITOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1054, 107, NULL, 'JAUJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1055, 107, NULL, 'ACOLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1056, 107, NULL, 'APATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1057, 107, NULL, 'ATAURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1058, 107, NULL, 'CANCHAYLLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1059, 107, NULL, 'CURICACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1060, 107, NULL, 'EL MANTARO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1061, 107, NULL, 'HUAMALI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1062, 107, NULL, 'HUARIPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1063, 107, NULL, 'HUERTAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1064, 107, NULL, 'JANJAILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1065, 107, NULL, 'JULCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1066, 107, NULL, 'LEONOR ORDOÑEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1067, 107, NULL, 'LLOCLLAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1068, 107, NULL, 'MARCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1069, 107, NULL, 'MASMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1070, 107, NULL, 'MASMA CHICCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1071, 107, NULL, 'MOLINOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1072, 107, NULL, 'MONOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1073, 107, NULL, 'MUQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1074, 107, NULL, 'MUQUIYAUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1075, 107, NULL, 'PACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1076, 107, NULL, 'PACCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1077, 107, NULL, 'PANCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1078, 107, NULL, 'PARCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1079, 107, NULL, 'POMACANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1080, 107, NULL, 'RICRAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1081, 107, NULL, 'SAN LORENZO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1082, 107, NULL, 'SAN PEDRO DE CHUNAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1083, 107, NULL, 'SAUSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1084, 107, NULL, 'SINCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1085, 107, NULL, 'TUNAN MARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1086, 107, NULL, 'YAULI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1087, 107, NULL, 'YAUYOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1088, 108, NULL, 'JUNIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1089, 108, NULL, 'CARHUAMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1090, 108, NULL, 'ONDORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1091, 108, NULL, 'ULCUMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1092, 109, NULL, 'SATIPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1093, 109, NULL, 'COVIRIALI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1094, 109, NULL, 'LLAYLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1095, 109, NULL, 'MANZARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1096, 109, NULL, 'PAMPAHERMOSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1097, 109, NULL, 'PANGOA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1098, 109, NULL, 'RIO NEGRO 9/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1099, 109, NULL, 'RIO TAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1100, 110, NULL, 'TARMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1101, 110, NULL, 'ACOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1102, 110, NULL, 'HUARICOLCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1103, 110, NULL, 'HUASAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1104, 110, NULL, 'LA UNION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1105, 110, NULL, 'PALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1106, 110, NULL, 'PALCAMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1107, 110, NULL, 'SAN PEDRO DE CAJAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1108, 110, NULL, 'TAPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1109, 111, NULL, 'LA OROYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1110, 111, NULL, 'CHACAPALPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1111, 111, NULL, 'HUAY-HUAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1112, 111, NULL, 'MARCAPOMACOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1113, 111, NULL, 'MOROCOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1114, 111, NULL, 'PACCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1115, 111, NULL, 'SANTA BARBARA DE CARHUACAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1116, 111, NULL, 'SANTA ROSA DE SACCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1117, 111, NULL, 'SUITUCANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1118, 111, NULL, 'YAULI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1119, 112, NULL, 'CHUPACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1120, 112, NULL, 'AHUAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1121, 112, NULL, 'CHONGOS BAJO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1122, 112, NULL, 'HUACHAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1123, 112, NULL, 'HUAMANCACA CHICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1124, 112, NULL, 'SAN JUAN DE ISCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1125, 112, NULL, 'SAN JUAN DE JARPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1126, 112, NULL, 'TRES DE DICIEMBRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1127, 112, NULL, 'YANACANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1128, 113, NULL, 'TRUJILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1129, 113, NULL, 'EL PORVENIR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1130, 113, NULL, 'FLORENCIA DE MORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1131, 113, NULL, 'HUANCHACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1132, 113, NULL, 'LA ESPERANZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1133, 113, NULL, 'LAREDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1134, 113, NULL, 'MOCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1135, 113, NULL, 'POROTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1136, 113, NULL, 'SALAVERRY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1137, 113, NULL, 'SIMBAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1138, 113, NULL, 'VICTOR LARCO HERRERA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1139, 114, NULL, 'ASCOPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1140, 114, NULL, 'CHICAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1141, 114, NULL, 'CHOCOPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1142, 114, NULL, 'MAGDALENA DE CAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1143, 114, NULL, 'PAIJAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1144, 114, NULL, 'RAZURI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1145, 114, NULL, 'SANTIAGO DE CAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1146, 114, NULL, 'CASA GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1147, 115, NULL, 'BOLIVAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1148, 115, NULL, 'BAMBAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1149, 115, NULL, 'CONDORMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1150, 115, NULL, 'LONGOTEA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1151, 115, NULL, 'UCHUMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1152, 115, NULL, 'UCUNCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1153, 116, NULL, 'CHEPEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1154, 116, NULL, 'PACANGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1155, 116, NULL, 'PUEBLO NUEVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1156, 117, NULL, 'JULCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1157, 117, NULL, 'CALAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1158, 117, NULL, 'CARABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1159, 117, NULL, 'HUASO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1160, 118, NULL, 'OTUZCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1161, 118, NULL, 'AGALLPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1162, 118, NULL, 'CHARAT', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1163, 118, NULL, 'HUARANCHAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1164, 118, NULL, 'LA CUESTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1165, 118, NULL, 'MACHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1166, 118, NULL, 'PARANDAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1167, 118, NULL, 'SALPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1168, 118, NULL, 'SINSICAP', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1169, 118, NULL, 'USQUIL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1170, 119, NULL, 'SAN PEDRO DE LLOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1171, 119, NULL, 'GUADALUPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1172, 119, NULL, 'JEQUETEPEQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1173, 119, NULL, 'PACASMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1174, 119, NULL, 'SAN JOSE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1175, 120, NULL, 'TAYABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1176, 120, NULL, 'BULDIBUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1177, 120, NULL, 'CHILLIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1178, 120, NULL, 'HUANCASPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1179, 120, NULL, 'HUAYLILLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1180, 120, NULL, 'HUAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1181, 120, NULL, 'ONGON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1182, 120, NULL, 'PARCOY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1183, 120, NULL, 'PATAZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1184, 120, NULL, 'PIAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1185, 120, NULL, 'SANTIAGO DE CHALLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1186, 120, NULL, 'TAURIJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1187, 120, NULL, 'URPAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1188, 121, NULL, 'HUAMACHUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1189, 121, NULL, 'CHUGAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1190, 121, NULL, 'COCHORCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1191, 121, NULL, 'CURGOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1192, 121, NULL, 'MARCABAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1193, 121, NULL, 'SANAGORAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1194, 121, NULL, 'SARIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1195, 121, NULL, 'SARTIMBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1196, 122, NULL, 'SANTIAGO DE CHUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1197, 122, NULL, 'ANGASMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1198, 122, NULL, 'CACHICADAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1199, 122, NULL, 'MOLLEBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1200, 122, NULL, 'MOLLEPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1201, 122, NULL, 'QUIRUVILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1202, 122, NULL, 'SANTA CRUZ DE CHUCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1203, 122, NULL, 'SITABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1204, 123, NULL, 'CASCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1205, 123, NULL, 'LUCMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1206, 123, NULL, 'MARMOT', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1207, 123, NULL, 'SAYAPULLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1208, 124, NULL, 'VIRU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1209, 124, NULL, 'CHAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1210, 124, NULL, 'GUADALUPITO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1211, 125, NULL, 'CHICLAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1212, 125, NULL, 'CHONGOYAPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1213, 125, NULL, 'ETEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1214, 125, NULL, 'ETEN PUERTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1215, 125, NULL, 'JOSE LEONARDO ORTIZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1216, 125, NULL, 'LA VICTORIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1217, 125, NULL, 'LAGUNAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1218, 125, NULL, 'MONSEFU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1219, 125, NULL, 'NUEVA ARICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1220, 125, NULL, 'OYOTUN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1221, 125, NULL, 'PICSI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1222, 125, NULL, 'PIMENTEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1223, 125, NULL, 'REQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1224, 125, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1225, 125, NULL, 'SAÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1226, 125, NULL, 'CAYALTI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1227, 125, NULL, 'PATAPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1228, 125, NULL, 'POMALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1229, 125, NULL, 'PUCALA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1230, 125, NULL, 'TUMAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1231, 126, NULL, 'FERREÑAFE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1232, 126, NULL, 'CAÑARIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1233, 126, NULL, 'INCAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1234, 126, NULL, 'MANUEL ANTONIO MESONES MURO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1235, 126, NULL, 'PITIPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1236, 126, NULL, 'PUEBLO NUEVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1237, 127, NULL, 'LAMBAYEQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1238, 127, NULL, 'CHOCHOPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1239, 127, NULL, 'ILLIMO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1240, 127, NULL, 'JAYANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1241, 127, NULL, 'MOCHUMI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1242, 127, NULL, 'MORROPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1243, 127, NULL, 'MOTUPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1244, 127, NULL, 'OLMOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1245, 127, NULL, 'PACORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1246, 127, NULL, 'SALAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1247, 127, NULL, 'SAN JOSE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1248, 127, NULL, 'TUCUME', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1249, 128, 4, 'LIMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1250, 128, 6, 'ANCON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1251, 128, 2, 'ATE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1252, 128, 3, 'BARRANCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1253, 128, 4, 'BREÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1254, 128, 6, 'CARABAYLLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1255, 128, 2, 'CHACLACAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1256, 128, 3, 'CHORRILLOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1257, 128, 2, 'CIENEGUILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1258, 128, 1, 'COMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1259, 128, 7, 'EL AGUSTINO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1260, 128, 1, 'INDEPENDENCIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1261, 128, 4, 'JESUS MARIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1262, 128, 2, 'LA MOLINA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1263, 128, 7, 'LA VICTORIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1264, 128, 4, 'LINCE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1265, 128, 1, 'LOS OLIVOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1266, 128, 2, 'LURIGANCHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1267, 128, 8, 'LURIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1268, 128, 4, 'MAGDALENA DEL MAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1269, 128, NULL, 'MAGDALENA VIEJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1270, 128, 3, 'MIRAFLORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1271, 128, 2, 'PACHACAMAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1272, 128, 8, 'PUCUSANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1273, 128, 6, 'PUENTE PIEDRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1274, 128, 8, 'PUNTA HERMOSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1275, 128, NULL, 'PUNTA NEGRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1276, 128, 1, 'RIMAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1277, 128, 8, 'SAN BARTOLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1278, 128, 7, 'SAN BORJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1279, 128, 4, 'SAN ISIDRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1280, 128, 7, 'SAN JUAN DE LURIGANCHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1281, 128, 3, 'SAN JUAN DE MIRAFLORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1282, 128, 2, 'SAN LUIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1283, 128, 1, 'SAN MARTIN DE PORRES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1284, 128, 4, 'SAN MIGUEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1285, 128, 2, 'SANTA ANITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1286, 128, 8, 'SANTA MARIA DEL MAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1287, 128, 6, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1288, 128, 3, 'SANTIAGO DE SURCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1289, 128, 3, 'SURQUILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1290, 128, 8, 'VILLA EL SALVADOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1291, 128, 2, 'VILLA MARIA DEL TRIUNFO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1292, 129, NULL, 'BARRANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1293, 129, NULL, 'PARAMONGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1294, 129, NULL, 'PATIVILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1295, 129, NULL, 'SUPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1296, 129, NULL, 'SUPE PUERTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1297, 130, NULL, 'CAJATAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1298, 130, NULL, 'COPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1299, 130, NULL, 'GORGOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1300, 130, NULL, 'HUANCAPON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1301, 130, NULL, 'MANAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1302, 131, NULL, 'CANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1303, 131, NULL, 'ARAHUAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1304, 131, NULL, 'HUAMANTANGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1305, 131, NULL, 'HUAROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1306, 131, NULL, 'LACHAQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1307, 131, NULL, 'SAN BUENAVENTURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1308, 131, NULL, 'SANTA ROSA DE QUIVES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1309, 132, NULL, 'SAN VICENTE DE CAÑETE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1310, 132, NULL, 'ASIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1311, 132, NULL, 'CALANGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1312, 132, NULL, 'CERRO AZUL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1313, 132, NULL, 'CHILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1314, 132, NULL, 'COAYLLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1315, 132, NULL, 'IMPERIAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1316, 132, NULL, 'LUNAHUANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1317, 132, NULL, 'MALA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1318, 132, NULL, 'NUEVO IMPERIAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1319, 132, NULL, 'PACARAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1320, 132, NULL, 'QUILMANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1321, 132, NULL, 'SAN ANTONIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1322, 132, NULL, 'SAN LUIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1323, 132, NULL, 'SANTA CRUZ DE FLORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1324, 132, NULL, 'ZUÑIGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1325, 133, NULL, 'HUARAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1326, 133, NULL, 'ATAVILLOS ALTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1327, 133, NULL, 'ATAVILLOS BAJO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1328, 133, NULL, 'AUCALLAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1329, 133, NULL, 'CHANCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1330, 133, NULL, 'IHUARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1331, 133, NULL, 'LAMPIAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1332, 133, NULL, 'PACARAOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1333, 133, NULL, 'SAN MIGUEL DE ACOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1334, 133, NULL, 'SANTA CRUZ DE ANDAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1335, 133, NULL, 'SUMBILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1336, 133, NULL, 'VEINTISIETE DE NOVIEMBRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1337, 134, NULL, 'MATUCANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1338, 134, NULL, 'ANTIOQUIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1339, 134, NULL, 'CALLAHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1340, 134, NULL, 'CARAMPOMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1341, 134, NULL, 'CHICLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1342, 134, NULL, 'CUENCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1343, 134, NULL, 'HUACHUPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1344, 134, NULL, 'HUANZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1345, 134, NULL, 'HUAROCHIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1346, 134, NULL, 'LAHUAYTAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1347, 134, NULL, 'LANGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1348, 134, NULL, 'LARAOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1349, 134, NULL, 'MARIATANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1350, 134, NULL, 'RICARDO PALMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1351, 134, NULL, 'SAN ANDRES DE TUPICOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1352, 134, NULL, 'SAN ANTONIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1353, 134, NULL, 'SAN BARTOLOME', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1354, 134, NULL, 'SAN DAMIAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1355, 134, NULL, 'SAN JUAN DE IRIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1356, 134, NULL, 'SAN JUAN DE TANTARANCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1357, 134, NULL, 'SAN LORENZO DE QUINTI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1358, 134, NULL, 'SAN MATEO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1359, 134, NULL, 'SAN MATEO DE OTAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1360, 134, NULL, 'SAN PEDRO DE CASTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1361, 134, NULL, 'SAN PEDRO DE HUANCAYRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1362, 134, NULL, 'SANGALLAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1363, 134, NULL, 'SANTA CRUZ DE COCACHACRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1364, 134, NULL, 'SANTA EULALIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1365, 134, NULL, 'SANTIAGO DE ANCHUCAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1366, 134, NULL, 'SANTIAGO DE TUNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1367, 134, NULL, 'SANTO DOMINGO DE LOS OLLERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1368, 134, NULL, 'SURCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1369, 135, NULL, 'HUACHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1370, 135, NULL, 'AMBAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1371, 135, NULL, 'CALETA DE CARQUIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1372, 135, NULL, 'CHECRAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1373, 135, NULL, 'HUALMAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1374, 135, NULL, 'HUAURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1375, 135, NULL, 'LEONCIO PRADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1376, 135, NULL, 'PACCHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1377, 135, NULL, 'SANTA LEONOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1378, 135, NULL, 'SANTA MARIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1379, 135, NULL, 'SAYAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1380, 135, NULL, 'VEGUETA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1381, 136, NULL, 'OYON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1382, 136, NULL, 'ANDAJES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1383, 136, NULL, 'CAUJUL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1384, 136, NULL, 'COCHAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1385, 136, NULL, 'NAVAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1386, 136, NULL, 'PACHANGARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1387, 137, NULL, 'YAUYOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1388, 137, NULL, 'ALIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1389, 137, NULL, 'AYAUCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1390, 137, NULL, 'AYAVIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1391, 137, NULL, 'AZANGARO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1392, 137, NULL, 'CACRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1393, 137, NULL, 'CARANIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1394, 137, NULL, 'CATAHUASI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1395, 137, NULL, 'CHOCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1396, 137, NULL, 'COCHAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1397, 137, NULL, 'COLONIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1398, 137, NULL, 'HONGOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1399, 137, NULL, 'HUAMPARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1400, 137, NULL, 'HUANCAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1401, 137, NULL, 'HUANGASCAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1402, 137, NULL, 'HUANTAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1403, 137, NULL, 'HUAÑEC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1404, 137, NULL, 'LARAOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1405, 137, NULL, 'LINCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1406, 137, NULL, 'MADEAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1407, 137, NULL, 'MIRAFLORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1408, 137, NULL, 'OMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1409, 137, NULL, 'PUTINZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1410, 137, NULL, 'QUINCHES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1411, 137, NULL, 'QUINOCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1412, 137, NULL, 'SAN JOAQUIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1413, 137, NULL, 'SAN PEDRO DE PILAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1414, 137, NULL, 'TANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1415, 137, NULL, 'TAURIPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1416, 137, NULL, 'TOMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1417, 137, NULL, 'TUPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1418, 137, NULL, 'VIÑAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1419, 137, NULL, 'VITIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1420, 138, NULL, 'IQUITOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1421, 138, NULL, 'ALTO NANAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1422, 138, NULL, 'FERNANDO LORES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1423, 138, NULL, 'INDIANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1424, 138, NULL, 'LAS AMAZONAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1425, 138, NULL, 'MAZAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1426, 138, NULL, 'NAPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1427, 138, NULL, 'PUNCHANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1428, 138, NULL, 'PUTUMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1429, 138, NULL, 'TORRES CAUSANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1430, 138, NULL, 'BELEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1431, 138, NULL, 'SAN JUAN BAUTISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1432, 138, NULL, 'TENIENTE MANUEL CLAVERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1433, 139, NULL, 'YURIMAGUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1434, 139, NULL, 'BALSAPUERTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1435, 139, NULL, 'JEBEROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1436, 139, NULL, 'LAGUNAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1437, 139, NULL, 'SANTA CRUZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1438, 139, NULL, 'TENIENTE CESAR LOPEZ ROJAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1439, 140, NULL, 'NAUTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1440, 140, NULL, 'PARINARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1441, 140, NULL, 'TIGRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1442, 140, NULL, 'TROMPETEROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1443, 140, NULL, 'URARINAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1444, 141, NULL, 'RAMON CASTILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1445, 141, NULL, 'PEBAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1446, 141, NULL, 'YAVARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1447, 141, NULL, 'SAN PABLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1448, 142, NULL, 'REQUENA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1449, 142, NULL, 'ALTO TAPICHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1450, 142, NULL, 'CAPELO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1451, 142, NULL, 'EMILIO SAN MARTIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1452, 142, NULL, 'MAQUIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1453, 142, NULL, 'PUINAHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1454, 142, NULL, 'SAQUENA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1455, 142, NULL, 'SOPLIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1456, 142, NULL, 'TAPICHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1457, 142, NULL, 'JENARO HERRERA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1458, 142, NULL, 'YAQUERANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1459, 143, NULL, 'CONTAMANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1460, 143, NULL, 'INAHUAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1461, 143, NULL, 'PADRE MARQUEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1462, 143, NULL, 'PAMPA HERMOSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1463, 143, NULL, 'SARAYACU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1464, 143, NULL, 'VARGAS GUERRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1465, 144, NULL, 'BARRANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1466, 144, NULL, 'CAHUAPANAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1467, 144, NULL, 'MANSERICHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1468, 144, NULL, 'MORONA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1469, 144, NULL, 'PASTAZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1470, 144, NULL, 'ANDOAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1471, 145, NULL, 'TAMBOPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO `tbl_district` (`disctric_id`, `province_id`, `branch_id`, `district_name`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1472, 145, NULL, 'INAMBARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1473, 145, NULL, 'LAS PIEDRAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1474, 145, NULL, 'LABERINTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1475, 146, NULL, 'MANU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1476, 146, NULL, 'FITZCARRALD', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1477, 146, NULL, 'MADRE DE DIOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1478, 146, NULL, 'HUEPETUHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1479, 147, NULL, 'IÑAPARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1480, 147, NULL, 'IBERIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1481, 147, NULL, 'TAHUAMANU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1482, 148, NULL, 'MOQUEGUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1483, 148, NULL, 'CARUMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1484, 148, NULL, 'CUCHUMBAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1485, 148, NULL, 'SAMEGUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1486, 148, NULL, 'SAN CRISTOBAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1487, 148, NULL, 'TORATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1488, 149, NULL, 'OMATE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1489, 149, NULL, 'CHOJATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1490, 149, NULL, 'COALAQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1491, 149, NULL, 'ICHUÑA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1492, 149, NULL, 'LA CAPILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1493, 149, NULL, 'LLOQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1494, 149, NULL, 'MATALAQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1495, 149, NULL, 'PUQUINA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1496, 149, NULL, 'QUINISTAQUILLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1497, 149, NULL, 'UBINAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1498, 149, NULL, 'YUNGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1499, 150, NULL, 'ILO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1500, 150, NULL, 'EL ALGARROBAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1501, 150, NULL, 'PACOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1502, 151, NULL, 'CHAUPIMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1503, 151, NULL, 'HUACHON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1504, 151, NULL, 'HUARIACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1505, 151, NULL, 'HUAYLLAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1506, 151, NULL, 'NINACACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1507, 151, NULL, 'PALLANCHACRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1508, 151, NULL, 'PAUCARTAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1509, 151, NULL, 'SAN FCO.DE ASIS DE YARUSYAC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1510, 151, NULL, 'SIMON BOLIVAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1511, 151, NULL, 'TICLACAYAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1512, 151, NULL, 'TINYAHUARCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1513, 151, NULL, 'VICCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1514, 151, NULL, 'YANACANCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1515, 152, NULL, 'YANAHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1516, 152, NULL, 'CHACAYAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1517, 152, NULL, 'GOYLLARISQUIZGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1518, 152, NULL, 'PAUCAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1519, 152, NULL, 'SAN PEDRO DE PILLAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1520, 152, NULL, 'SANTA ANA DE TUSI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1521, 152, NULL, 'TAPUC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1522, 152, NULL, 'VILCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1523, 153, NULL, 'OXAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1524, 153, NULL, 'CHONTABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1525, 153, NULL, 'HUANCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1526, 153, NULL, 'PALCAZU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1527, 153, NULL, 'POZUZO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1528, 153, NULL, 'PUERTO BERMUDEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1529, 153, NULL, 'VILLA RICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1530, 154, NULL, 'PIURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1531, 154, NULL, 'CASTILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1532, 154, NULL, 'CATACAOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1533, 154, NULL, 'CURA MORI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1534, 154, NULL, 'EL TALLAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1535, 154, NULL, 'LA ARENA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1536, 154, NULL, 'LA UNION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1537, 154, NULL, 'LAS LOMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1538, 154, NULL, 'TAMBO GRANDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1539, 155, NULL, 'AYABACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1540, 155, NULL, 'FRIAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1541, 155, NULL, 'JILILI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1542, 155, NULL, 'LAGUNAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1543, 155, NULL, 'MONTERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1544, 155, NULL, 'PACAIPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1545, 155, NULL, 'PAIMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1546, 155, NULL, 'SAPILLICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1547, 155, NULL, 'SICCHEZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1548, 155, NULL, 'SUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1549, 156, NULL, 'HUANCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1550, 156, NULL, 'CANCHAQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1551, 156, NULL, 'EL CARMEN DE LA FRONTERA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1552, 156, NULL, 'HUARMACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1553, 156, NULL, 'LALAQUIZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1554, 156, NULL, 'SAN MIGUEL DE EL FAIQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1555, 156, NULL, 'SONDOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1556, 156, NULL, 'SONDORILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1557, 157, NULL, 'CHULUCANAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1558, 157, NULL, 'BUENOS AIRES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1559, 157, NULL, 'CHALACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1560, 157, NULL, 'LA MATANZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1561, 157, NULL, 'MORROPON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1562, 157, NULL, 'SALITRAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1563, 157, NULL, 'SAN JUAN DE BIGOTE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1564, 157, NULL, 'SANTA CATALINA DE MOSSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1565, 157, NULL, 'SANTO DOMINGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1566, 157, NULL, 'YAMANGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1567, 158, NULL, 'PAITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1568, 158, NULL, 'AMOTAPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1569, 158, NULL, 'ARENAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1570, 158, NULL, 'COLAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1571, 158, NULL, 'LA HUACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1572, 158, NULL, 'TAMARINDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1573, 158, NULL, 'VICHAYAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1574, 159, NULL, 'SULLANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1575, 159, NULL, 'BELLAVISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1576, 159, NULL, 'IGNACIO ESCUDERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1577, 159, NULL, 'LANCONES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1578, 159, NULL, 'MARCAVELICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1579, 159, NULL, 'MIGUEL CHECA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1580, 159, NULL, 'QUERECOTILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1581, 159, NULL, 'SALITRAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1582, 160, NULL, 'PARIÑAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1583, 160, NULL, 'EL ALTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1584, 160, NULL, 'LA BREA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1585, 160, NULL, 'LOBITOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1586, 160, NULL, 'LOS ORGANOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1587, 160, NULL, 'MANCORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1588, 161, NULL, 'SECHURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1589, 161, NULL, 'BELLAVISTA DE LA UNION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1590, 161, NULL, 'BERNAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1591, 161, NULL, 'CRISTO NOS VALGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1592, 161, NULL, 'VICE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1593, 161, NULL, 'RINCONADA LLICUAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1594, 162, NULL, 'PUNO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1595, 162, NULL, 'ACORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1596, 162, NULL, 'AMANTANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1597, 162, NULL, 'ATUNCOLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1598, 162, NULL, 'CAPACHICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1599, 162, NULL, 'CHUCUITO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1600, 162, NULL, 'COATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1601, 162, NULL, 'HUATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1602, 162, NULL, 'MAÑAZO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1603, 162, NULL, 'PAUCARCOLLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1604, 162, NULL, 'PICHACANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1605, 162, NULL, 'PLATERIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1606, 162, NULL, 'SAN ANTONIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1607, 162, NULL, 'TIQUILLACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1608, 162, NULL, 'VILQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1609, 163, NULL, 'AZANGARO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1610, 163, NULL, 'ACHAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1611, 163, NULL, 'ARAPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1612, 163, NULL, 'ASILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1613, 163, NULL, 'CAMINACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1614, 163, NULL, 'CHUPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1615, 163, NULL, 'JOSE DOMINGO CHOQUEHUANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1616, 163, NULL, 'MUÑANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1617, 163, NULL, 'POTONI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1618, 163, NULL, 'SAMAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1619, 163, NULL, 'SAN ANTON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1620, 163, NULL, 'SAN JOSE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1621, 163, NULL, 'SAN JUAN DE SALINAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1622, 163, NULL, 'SANTIAGO DE PUPUJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1623, 163, NULL, 'TIRAPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1624, 164, NULL, 'MACUSANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1625, 164, NULL, 'AJOYANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1626, 164, NULL, 'AYAPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1627, 164, NULL, 'COASA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1628, 164, NULL, 'CORANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1629, 164, NULL, 'CRUCERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1630, 164, NULL, 'ITUATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1631, 164, NULL, 'OLLACHEA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1632, 164, NULL, 'SAN GABAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1633, 164, NULL, 'USICAYOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1634, 165, NULL, 'JULI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1635, 165, NULL, 'DESAGUADERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1636, 165, NULL, 'HUACULLANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1637, 165, NULL, 'KELLUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1638, 165, NULL, 'PISACOMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1639, 165, NULL, 'POMATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1640, 165, NULL, 'ZEPITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1641, 166, NULL, 'ILAVE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1642, 166, NULL, 'CAPAZO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1643, 166, NULL, 'PILCUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1644, 166, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1645, 166, NULL, 'CONDURIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1646, 167, NULL, 'HUANCANE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1647, 167, NULL, 'COJATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1648, 167, NULL, 'HUATASANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1649, 167, NULL, 'INCHUPALLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1650, 167, NULL, 'PUSI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1651, 167, NULL, 'ROSASPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1652, 167, NULL, 'TARACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1653, 167, NULL, 'VILQUE CHICO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1654, 168, NULL, 'LAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1655, 168, NULL, 'CABANILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1656, 168, NULL, 'CALAPUJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1657, 168, NULL, 'NICASIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1658, 168, NULL, 'OCUVIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1659, 168, NULL, 'PALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1660, 168, NULL, 'PARATIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1661, 168, NULL, 'PUCARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1662, 168, NULL, 'SANTA LUCIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1663, 168, NULL, 'VILAVILA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1664, 169, NULL, 'AYAVIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1665, 169, NULL, 'ANTAUTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1666, 169, NULL, 'CUPI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1667, 169, NULL, 'LLALLI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1668, 169, NULL, 'MACARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1669, 169, NULL, 'NUÑOA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1670, 169, NULL, 'ORURILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1671, 169, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1672, 169, NULL, 'UMACHIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1673, 170, NULL, 'MOHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1674, 170, NULL, 'CONIMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1675, 170, NULL, 'HUAYRAPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1676, 170, NULL, 'TILALI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1677, 171, NULL, 'PUTINA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1678, 171, NULL, 'ANANEA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1679, 171, NULL, 'PEDRO VILCA APAZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1680, 171, NULL, 'QUILCAPUNCU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1681, 171, NULL, 'SINA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1682, 172, NULL, 'JULIACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1683, 172, NULL, 'CABANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1684, 172, NULL, 'CABANILLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1685, 172, NULL, 'CARACOTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1686, 173, NULL, 'SANDIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1687, 173, NULL, 'CUYOCUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1688, 173, NULL, 'LIMBANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1689, 173, NULL, 'PATAMBUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1690, 173, NULL, 'PHARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1691, 173, NULL, 'QUIACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1692, 173, NULL, 'SAN JUAN DEL ORO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1693, 173, NULL, 'YANAHUAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1694, 173, NULL, 'ALTO INAMBARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1695, 173, NULL, 'SAN PEDRO DE PUTINA PUNCU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1696, 174, NULL, 'YUNGUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1697, 174, NULL, 'ANAPIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1698, 174, NULL, 'COPANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1699, 174, NULL, 'CUTURAPI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1700, 174, NULL, 'OLLARAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1701, 174, NULL, 'TINICACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1702, 174, NULL, 'UNICACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1703, 175, NULL, 'MOYOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1704, 175, NULL, 'CALZADA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1705, 175, NULL, 'HABANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1706, 175, NULL, 'JEPELACIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1707, 175, NULL, 'SORITOR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1708, 175, NULL, 'YANTALO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1709, 176, NULL, 'BELLAVISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1710, 176, NULL, 'ALTO BIAVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1711, 176, NULL, 'BAJO BIAVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1712, 176, NULL, 'HUALLAGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1713, 176, NULL, 'SAN PABLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1714, 176, NULL, 'SAN RAFAEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1715, 177, NULL, 'SAN JOSE DE SISA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1716, 177, NULL, 'AGUA BLANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1717, 177, NULL, 'SAN MARTIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1718, 177, NULL, 'SANTA ROSA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1719, 177, NULL, 'SHATOJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1720, 178, NULL, 'SAPOSOA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1721, 178, NULL, 'ALTO SAPOSOA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1722, 178, NULL, 'EL ESLABON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1723, 178, NULL, 'PISCOYACU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1724, 178, NULL, 'SACANCHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1725, 178, NULL, 'TINGO DE SAPOSOA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1726, 179, NULL, 'LAMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1727, 179, NULL, 'ALONSO DE ALVARADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1728, 179, NULL, 'BARRANQUITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1729, 179, NULL, 'CAYNARACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1730, 179, NULL, 'CUÑUMBUQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1731, 179, NULL, 'PINTO RECODO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1732, 179, NULL, 'RUMISAPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1733, 179, NULL, 'SAN ROQUE DE CUMBAZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1734, 179, NULL, 'SHANAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1735, 179, NULL, 'TABALOSOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1736, 179, NULL, 'ZAPATERO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1737, 180, NULL, 'JUANJUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1738, 180, NULL, 'CAMPANILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1739, 180, NULL, 'HUICUNGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1740, 180, NULL, 'PACHIZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1741, 180, NULL, 'PAJARILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1742, 181, NULL, 'PICOTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1743, 181, NULL, 'BUENOS AIRES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1744, 181, NULL, 'CASPISAPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1745, 181, NULL, 'PILLUANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1746, 181, NULL, 'PUCACACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1747, 181, NULL, 'SAN CRISTOBAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1748, 181, NULL, 'SAN HILARION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1749, 181, NULL, 'SHAMBOYACU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1750, 181, NULL, 'TINGO DE PONASA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1751, 181, NULL, 'TRES UNIDOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1752, 182, NULL, 'RIOJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1753, 182, NULL, 'AWAJUN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1754, 182, NULL, 'ELIAS SOPLIN VARGAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1755, 182, NULL, 'NUEVA CAJAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1756, 182, NULL, 'PARDO MIGUEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1757, 182, NULL, 'POSIC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1758, 182, NULL, 'SAN FERNANDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1759, 182, NULL, 'YORONGOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1760, 182, NULL, 'YURACYACU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1761, 183, NULL, 'TARAPOTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1762, 183, NULL, 'ALBERTO LEVEAU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1763, 183, NULL, 'CACATACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1764, 183, NULL, 'CHAZUTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1765, 183, NULL, 'CHIPURANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1766, 183, NULL, 'EL PORVENIR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1767, 183, NULL, 'HUIMBAYOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1768, 183, NULL, 'JUAN GUERRA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1769, 183, NULL, 'LA BANDA DE SHILCAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1770, 183, NULL, 'MORALES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1771, 183, NULL, 'PAPAPLAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1772, 183, NULL, 'SAN ANTONIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1773, 183, NULL, 'SAUCE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1774, 183, NULL, 'SHAPAJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1775, 184, NULL, 'TOCACHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1776, 184, NULL, 'NUEVO PROGRESO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1777, 184, NULL, 'POLVORA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1778, 184, NULL, 'SHUNTE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1779, 184, NULL, 'UCHIZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1780, 185, NULL, 'TACNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1781, 185, NULL, 'ALTO DE LA ALIANZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1782, 185, NULL, 'CALANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1783, 185, NULL, 'CIUDAD NUEVA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1784, 185, NULL, 'INCLAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1785, 185, NULL, 'PACHIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1786, 185, NULL, 'PALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1787, 185, NULL, 'POCOLLAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1788, 185, NULL, 'SAMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1789, 185, NULL, 'CRNEL.GREGORIO ALBARRACIN LANCHIPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1790, 186, NULL, 'CANDARAVE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1791, 186, NULL, 'CAIRANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1792, 186, NULL, 'CAMILACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1793, 186, NULL, 'CURIBAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1794, 186, NULL, 'HUANUARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1795, 186, NULL, 'QUILAHUANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1796, 187, NULL, 'LOCUMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1797, 187, NULL, 'ILABAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1798, 187, NULL, 'ITE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1799, 188, NULL, 'TARATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1800, 188, NULL, 'CHUCATAMANI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1801, 188, NULL, 'ESTIQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1802, 188, NULL, 'ESTIQUE-PAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1803, 188, NULL, 'SITAJARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1804, 188, NULL, 'SUSAPAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1805, 188, NULL, 'TARUCACHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1806, 188, NULL, 'TICACO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1807, 189, NULL, 'TUMBES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1808, 189, NULL, 'CORRALES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1809, 189, NULL, 'LA CRUZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1810, 189, NULL, 'PAMPAS DE HOSPITAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1811, 189, NULL, 'SAN JACINTO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1812, 189, NULL, 'SAN JUAN DE LA VIRGEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1813, 190, NULL, 'ZORRITOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1814, 190, NULL, 'CASITAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1815, 190, NULL, 'CANOAS DE PUNTA SAL 8/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1816, 191, NULL, 'ZARUMILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1817, 191, NULL, 'AGUAS VERDES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1818, 191, NULL, 'MATAPALO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1819, 191, NULL, 'PAPAYAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1820, 192, NULL, 'CALLERIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1821, 192, NULL, 'CAMPOVERDE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1822, 192, NULL, 'IPARIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1823, 192, NULL, 'MASISEA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1824, 192, NULL, 'YARINACOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1825, 192, NULL, 'NUEVA REQUENA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1826, 192, NULL, 'MANANTAY 9/', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1827, 193, NULL, 'RAYMONDI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1828, 193, NULL, 'SEPAHUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1829, 193, NULL, 'TAHUANIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1830, 193, NULL, 'YURUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1831, 194, NULL, 'PADRE ABAD', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1832, 194, NULL, 'IRAZOLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1833, 194, NULL, 'CURIMANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1834, 195, NULL, 'PURUS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1835, 128, 2, 'CHOSICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1836, 128, 2, 'HUAYCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1837, 128, 2, 'MANCHAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1838, 128, 4, 'PUEBLO LIBRE', NULL, NULL, NULL, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_idtype`
--

CREATE TABLE `tbl_idtype` (
  `idtype_id` int(11) NOT NULL,
  `idtype_name` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_idtype`
--

INSERT INTO `tbl_idtype` (`idtype_id`, `idtype_name`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'DNI', '2017-12-05 12:32:41', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Carnet de extranjería', '2017-12-05 12:32:41', NULL, NULL, 1, NULL, NULL, 1),
(3, 'Pasaporte', '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_order`
--

CREATE TABLE `tbl_order` (
  `order_id` int(11) NOT NULL,
  `idtype_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `tracking_code` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `id_number` varchar(50) NOT NULL,
  `billing_district` int(11) NOT NULL,
  `billing_phone` varchar(20) NOT NULL,
  `source_operator` varchar(45) DEFAULT NULL,
  `porting_phone` varchar(45) DEFAULT NULL,
  `delivery_address` varchar(100) NOT NULL,
  `delivery_district` int(11) NOT NULL,
  `contact_email` varchar(100) NOT NULL,
  `contact_phone` varchar(20) NOT NULL,
  `credit_status` enum('Pendiente','Aprobada','Rechazada','Observada') DEFAULT 'Pendiente',
  `has_debt` tinyint(1) NOT NULL DEFAULT '0',
  `isdn_status` enum('0','5','4','6') NOT NULL DEFAULT '0',
  `porting_request_id` varchar(20) DEFAULT NULL,
  `mnp_request_id` varchar(20) DEFAULT NULL,
  `porting_state_code` varchar(20) DEFAULT NULL,
  `porting_status` varchar(20) DEFAULT NULL,
  `porting_status_desc` varchar(20) DEFAULT NULL,
  `total` decimal(6,2) NOT NULL,
  `total_igv` decimal(6,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_order`
--

INSERT INTO `tbl_order` (`order_id`, `idtype_id`, `payment_method_id`, `branch_id`, `tracking_code`, `first_name`, `last_name`, `id_number`, `billing_district`, `billing_phone`, `source_operator`, `porting_phone`, `delivery_address`, `delivery_district`, `contact_email`, `contact_phone`, `credit_status`, `has_debt`, `isdn_status`, `porting_request_id`, `mnp_request_id`, `porting_state_code`, `porting_status`, `porting_status_desc`, `total`, `total_igv`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 1, 4, NULL, NULL, 'Cliente', 'Prueba 1', '45678910', 1252, '987654321', NULL, NULL, 'Av. Javier Prado 123', 1252, 'cliente.prueba@gmail.com', '987654321', 'Pendiente', 0, '0', NULL, NULL, NULL, NULL, NULL, '1500.00', '1770.00', '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1),
(2, 1, 3, NULL, '12345876', 'juan', 'perez', '12345876', 1252, '898982982928', 'Entel Perú S.A', '94959594851', 'direm', 1270, 'development@forceclose.pe', '26328382', 'Pendiente', 0, '0', NULL, NULL, NULL, NULL, NULL, '9.00', '10.62', '2017-12-11 15:36:27', NULL, NULL, 1, NULL, NULL, 1),
(3, 1, 3, 3, '12345876', 'juan', 'perez', '12345876', 1252, '898982982928', 'Entel Perú S.A', '94959594851', 'direm', 1270, 'development@forceclose.pe', '26328382', 'Pendiente', 0, '0', NULL, NULL, NULL, NULL, NULL, '9.00', '10.62', '2017-12-11 15:54:30', NULL, NULL, 1, NULL, NULL, 1),
(4, 1, 3, 3, '12345876', 'juan', 'perez', '12345876', 1252, '898982982928', 'Entel Perú S.A', '94959594851', 'direm', 1270, 'development@forceclose.pe', '26328382', 'Pendiente', 0, '0', NULL, NULL, NULL, NULL, NULL, '9.00', '10.62', '2017-12-11 15:59:31', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_order_item`
--

CREATE TABLE `tbl_order_item` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `stock_model_id` int(11) NOT NULL,
  `product_variation_id` int(11) DEFAULT NULL,
  `promo_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1',
  `subtotal` decimal(6,2) NOT NULL,
  `subtotal_igv` decimal(6,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_order_item`
--

INSERT INTO `tbl_order_item` (`order_item_id`, `order_id`, `stock_model_id`, `product_variation_id`, `promo_id`, `quantity`, `subtotal`, `subtotal_igv`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 1, 6, 228, 3, 1, '1500.00', '1770.00', '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1),
(2, 2, 7, 501, 3, 1, '9.00', '10.62', '2017-12-11 15:36:27', NULL, NULL, 1, NULL, NULL, 1),
(3, 3, 7, 501, 3, 1, '9.00', '10.62', '2017-12-11 15:54:30', NULL, NULL, 1, NULL, NULL, 1),
(4, 4, 7, 501, 3, 1, '9.00', '10.62', '2017-12-11 15:59:31', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_order_status`
--

CREATE TABLE `tbl_order_status` (
  `order_status_id` int(11) NOT NULL,
  `order_status_name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_order_status`
--

INSERT INTO `tbl_order_status` (`order_status_id`, `order_status_name`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Pendiente', '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Procesado', '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1),
(3, 'Cancelado', '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1),
(4, 'Entregado', '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1),
(5, 'Completado', '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_order_status_history`
--

CREATE TABLE `tbl_order_status_history` (
  `order_status_history_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `order_status_id` int(11) NOT NULL,
  `notify_customer` tinyint(1) DEFAULT '0',
  `comment` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_order_status_history`
--

INSERT INTO `tbl_order_status_history` (`order_status_history_id`, `order_id`, `order_status_id`, `notify_customer`, `comment`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 1, 1, 0, NULL, '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1),
(2, 2, 1, 0, NULL, '2017-12-11 15:36:27', NULL, NULL, 1, NULL, NULL, 1),
(3, 3, 1, 0, NULL, '2017-12-11 15:54:30', NULL, NULL, 1, NULL, NULL, 1),
(4, 4, 1, 0, NULL, '2017-12-11 15:59:31', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_payment_method`
--

CREATE TABLE `tbl_payment_method` (
  `payment_method_id` int(11) NOT NULL,
  `method_name` varchar(50) NOT NULL,
  `method_icon_url` varchar(100) DEFAULT NULL,
  `method_tip` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_payment_method`
--

INSERT INTO `tbl_payment_method` (`payment_method_id`, `method_name`, `method_icon_url`, `method_tip`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Visa', NULL, NULL, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Mastercard', NULL, NULL, '2017-12-05 12:32:41', NULL, NULL, 1, NULL, NULL, 1),
(3, 'American Express', NULL, NULL, '2017-12-05 12:32:41', NULL, NULL, 1, NULL, NULL, 1),
(4, 'En efectivo', NULL, 'Lorem ipsum dolor sit amet lorem ipsum dolor sithem', '2017-12-05 12:32:41', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_plan`
--

CREATE TABLE `tbl_plan` (
  `plan_id` int(11) NOT NULL,
  `plan_type` enum('Prepago','Postpago') NOT NULL,
  `plan_name` varchar(50) NOT NULL,
  `plan_price` decimal(6,2) NOT NULL,
  `plan_data_cap` varchar(45) NOT NULL,
  `plan_unlimited_calls` tinyint(1) NOT NULL DEFAULT '1',
  `plan_unlimited_rpb` tinyint(1) NOT NULL DEFAULT '1',
  `plan_unlimited_sms` tinyint(1) NOT NULL DEFAULT '1',
  `plan_unlimited_whatsapp` tinyint(1) NOT NULL DEFAULT '1',
  `plan_free_facebook` tinyint(1) NOT NULL DEFAULT '1',
  `product_code` varchar(20) DEFAULT NULL,
  `plan_slug` varchar(150) DEFAULT NULL,
  `weight` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_plan`
--

INSERT INTO `tbl_plan` (`plan_id`, `plan_type`, `plan_name`, `plan_price`, `plan_data_cap`, `plan_unlimited_calls`, `plan_unlimited_rpb`, `plan_unlimited_sms`, `plan_unlimited_whatsapp`, `plan_free_facebook`, `product_code`, `plan_slug`, `weight`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Postpago', 'iChip 29,90', '29.90', '', 1, 1, 1, 1, 1, 'ICHIP_29_90', 'ichip-29_90', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Postpago', 'iChip 29,90', '29.90', '', 1, 1, 1, 1, 1, 'ICHIP_29_90_Voz', 'ichip-29_90-voz', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(3, 'Postpago', 'iChip 29,90', '29.90', '', 1, 1, 1, 1, 1, 'ICHIP_29_90_3', 'ichip-29_90-3', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(4, 'Postpago', 'iChip 49,90', '49.90', '', 1, 1, 1, 1, 1, 'ICHIP_49_90', 'ichip-49_90', 1, '2017-12-05 12:32:36', NULL, NULL, 1, NULL, NULL, 1),
(5, 'Postpago', 'iChip 69,90', '69.90', '', 1, 1, 1, 1, 1, 'ICHIP_69_90', 'ichip-69_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(6, 'Postpago', 'iChip 89,90', '89.90', '', 1, 1, 1, 1, 1, 'ICHIP_89_90', 'ichip-89_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(7, 'Postpago', 'iChip 99,90', '99.90', '', 1, 1, 1, 1, 1, 'ICHIP_99_90', 'ichip-99_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(8, 'Postpago', 'iChip 129,90', '129.90', '', 1, 1, 1, 1, 1, 'ICHIP_129_90', 'ichip-129_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(9, 'Postpago', 'iChip 149,90', '149.90', '', 1, 1, 1, 1, 1, 'ICHIP_149_90', 'ichip-149_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(10, 'Postpago', 'iChip 169,90', '169.90', '', 1, 1, 1, 1, 1, 'ICHIP_169_90', 'ichip-169_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(11, 'Postpago', 'Giga Max 19,90', '19.90', '', 1, 1, 1, 1, 1, 'GIGA_19_90 ', 'giga-max-19_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(12, 'Postpago', 'Giga Max 29,90', '29.90', '', 1, 1, 1, 1, 1, 'GIGA_29_90 ', 'giga-max-29_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(13, 'Postpago', 'Giga Max 49,90', '49.90', '', 1, 1, 1, 1, 1, 'GIGA_49_90 ', 'giga-max-49_90', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(14, 'Prepago', 'B-Voz', '0.00', '', 1, 1, 1, 1, 1, 'PRE_BVOZ15', 'b-voz', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1),
(15, 'Prepago', 'Bifri 5', '0.00', '', 1, 1, 1, 1, 1, 'PRE_BIFRI5', 'bifri-5', 1, '2017-12-05 12:32:37', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_product`
--

CREATE TABLE `tbl_product` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL COMMENT 'Marca del dispositivo\n',
  `product_model` varchar(50) NOT NULL,
  `product_image_url` varchar(150) DEFAULT NULL,
  `product_keywords` varchar(100) DEFAULT NULL,
  `product_price` decimal(6,2) NOT NULL,
  `product_description` varchar(500) DEFAULT NULL,
  `product_general_specifications` text,
  `product_data_sheet` varchar(70) DEFAULT NULL COMMENT 'URL del documento de especificaciones técnicas\n',
  `product_ram_memory` decimal(5,2) DEFAULT NULL,
  `product_internal_memory` decimal(6,2) DEFAULT NULL,
  `product_screen_size` varchar(5) DEFAULT NULL,
  `product_camera_1` varchar(6) DEFAULT NULL,
  `product_camera_2` varchar(6) DEFAULT NULL,
  `product_camera_3` varchar(6) DEFAULT NULL,
  `product_camera_4` varchar(6) DEFAULT NULL,
  `product_processor_name` varchar(25) DEFAULT NULL,
  `product_processor_value` varchar(12) DEFAULT NULL,
  `product_processor_cores` varchar(20) DEFAULT NULL,
  `product_band` varchar(3) DEFAULT NULL COMMENT '2G / 3G / 4G',
  `product_slug` varchar(150) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `publish_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `publish_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_product`
--

INSERT INTO `tbl_product` (`product_id`, `category_id`, `brand_id`, `product_model`, `product_image_url`, `product_keywords`, `product_price`, `product_description`, `product_general_specifications`, `product_data_sheet`, `product_ram_memory`, `product_internal_memory`, `product_screen_size`, `product_camera_1`, `product_camera_2`, `product_camera_3`, `product_camera_4`, `product_processor_name`, `product_processor_value`, `product_processor_cores`, `product_band`, `product_slug`, `created_at`, `updated_at`, `deleted_at`, `publish_at`, `created_by`, `updated_by`, `deleted_by`, `publish_by`, `active`) VALUES
(1, 1, 1, 'A3 XL', 'ALCATEL/ALCATEL-A3-XL.jpg', NULL, '449.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'a3-xl', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(2, 1, 2, 'L640', 'BITEL/BITEL-L640.jpg', NULL, '259.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'l640', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(3, 1, 2, 'B9501', 'BITEL/Bitel-B9501.jpg', NULL, '259.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'b9501', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(4, 1, 3, 'Y360II', 'HUAWEII/HUAWEI-Y360-II.jpg', NULL, '259.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'y360ii', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(5, 1, 3, 'Y6 II Compact', 'HUAWEII/Huawei-Y6-II-Compact.jpg', NULL, '439.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'y6-ii-compact', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(6, 1, 3, 'P9 Lite', 'HUAWEII/Huawei-P9-Lite.jpg', NULL, '779.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'p9-lite', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(7, 1, 3, 'P9', 'HUAWEII/Huawei-P9.jpg', NULL, '1679.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'p9', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(8, 1, 3, 'Y5II', 'HUAWEII/Huawei-Y5-II.jpg', NULL, '299.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'y5ii', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(9, 1, 3, 'P8 Lite', 'HUAWEII/Huawei-P8-Lite.jpg', NULL, '599.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'p8-lite', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(10, 1, 4, 'Vibe b', 'LENOVO/Lenovo-Vibe-b.jpg', NULL, '259.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vibe-b', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(11, 1, 5, 'K10 2017', 'LG/LG-K10-2017.jpg', NULL, '599.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'k10-2017', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(12, 1, 5, 'G6 New', 'LG/LG-G6.jpg', NULL, '2699.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'g6-new', '2017-12-05 12:32:37', NULL, NULL, '2017-12-05 12:32:37', 1, NULL, NULL, 1, 1),
(13, 1, 5, 'K4 2017', 'LG/LG-K4-2017.jpg', NULL, '399.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'k4-2017', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(14, 1, 5, 'Stylus 3', 'LG/LG-STYLUS-3.jpg', NULL, '1799.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'stylus-3', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(15, 1, 5, 'X Power K220', 'LG/LG-X-POWER-K220.jpg', NULL, '599.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'x-power-k220', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(16, 1, 5, 'X220M', 'LG/LG-X-220m.jpg', NULL, '299.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'x220m', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(17, 1, 6, 'Galaxy J7 Prime', 'SAMSUNG/SAMSUNG-GALAXY-J7-PRIME.jpg', NULL, '999.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'galaxy-j7-prime', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(18, 1, 6, 'S7', 'SAMSUNG/SAMSUNG-S7.jpg', NULL, '2499.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 's7', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(19, 1, 6, 'S7 Edge', 'SAMSUNG/SAMSUNG-S7-EDGE.jpg', NULL, '2999.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 's7-edge', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(20, 1, 7, '5.0', 'SKY/SKY-5.0-.jpg', NULL, '259.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5.0', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(21, 1, 2, 'Chip Bifri 5', NULL, NULL, '5.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chip-bifri-5', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(22, 2, 5, 'Headset 1', 'accesorios.jpg', NULL, '449.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-1', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(23, 2, 5, 'Headset 2', 'accesorios.jpg', NULL, '249.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-2', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(24, 2, 5, 'Headset 3', 'accesorios.jpg', NULL, '149.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-3', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(25, 2, 5, 'Headset 4', 'accesorios.jpg', NULL, '349.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-4', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(26, 2, 5, 'Headset 5', 'accesorios.jpg', NULL, '649.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-5', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(27, 2, 6, 'Headset 6', 'accesorios.jpg', NULL, '549.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-6', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(28, 2, 6, 'Headset 7', 'accesorios.jpg', NULL, '849.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-7', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(29, 2, 6, 'Headset 8', 'accesorios.jpg', NULL, '749.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-8', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(30, 2, 6, 'Headset 9', 'accesorios.jpg', NULL, '1049.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-9', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(31, 2, 6, 'Headset 10', 'accesorios.jpg', NULL, '1449.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-10', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(32, 2, 5, 'Headset 11', 'accesorios.jpg', NULL, '449.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-11', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(33, 2, 5, 'Headset 12', 'accesorios.jpg', NULL, '249.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-12', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(34, 2, 5, 'Headset 13', 'accesorios.jpg', NULL, '149.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-13', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(35, 2, 5, 'Headset 14', 'accesorios.jpg', NULL, '349.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-14', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(36, 2, 5, 'Headset 15', 'accesorios.jpg', NULL, '649.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-15', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(37, 2, 6, 'Headset 16', 'accesorios.jpg', NULL, '549.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-16', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(38, 2, 6, 'Headset 17', 'accesorios.jpg', NULL, '849.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-17', '2017-12-05 12:32:38', NULL, NULL, '2017-12-05 12:32:38', 1, NULL, NULL, 1, 1),
(39, 2, 6, 'Headset 18', 'accesorios.jpg', NULL, '749.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-18', '2017-12-05 12:32:39', NULL, NULL, '2017-12-05 12:32:39', 1, NULL, NULL, 1, 1),
(40, 2, 6, 'Headset 19', 'accesorios.jpg', NULL, '1049.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-19', '2017-12-05 12:32:39', NULL, NULL, '2017-12-05 12:32:39', 1, NULL, NULL, 1, 1),
(41, 2, 6, 'Headset 20', 'accesorios.jpg', NULL, '1449.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'headset-20', '2017-12-05 12:32:39', NULL, NULL, '2017-12-05 12:32:39', 1, NULL, NULL, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_product_image`
--

CREATE TABLE `tbl_product_image` (
  `product_image_id` int(11) NOT NULL,
  `stock_model_id` int(11) NOT NULL,
  `product_image_url` varchar(150) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_product_image`
--

INSERT INTO `tbl_product_image` (`product_image_id`, `stock_model_id`, `product_image_url`, `weight`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 1, 'HUAWEII/Huawei-P9.jpg', 1, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1),
(2, 2, 'HUAWEII/Huawei-P9.jpg', 1, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1),
(3, 3, 'LG/LG-G6.jpg', 1, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1),
(4, 4, 'LG/LG-STYLUS-3.jpg', 1, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1),
(5, 5, 'LG/LG-STYLUS-3.jpg', 1, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1),
(6, 6, 'SAMSUNG/SAMSUNG-S7.jpg', 1, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1),
(7, 7, 'SAMSUNG/SAMSUNG-S7-EDGE.jpg', 1, '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_product_variation`
--

CREATE TABLE `tbl_product_variation` (
  `product_variation_id` int(11) NOT NULL,
  `variation_type_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `plan_id` int(11) DEFAULT NULL,
  `affiliation_id` int(11) DEFAULT NULL,
  `contract_id` int(11) DEFAULT NULL,
  `product_variation_price` decimal(6,2) NOT NULL,
  `reason_code` varchar(8) DEFAULT NULL,
  `product_package` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_product_variation`
--

INSERT INTO `tbl_product_variation` (`product_variation_id`, `variation_type_id`, `product_id`, `plan_id`, `affiliation_id`, `contract_id`, `product_variation_price`, `reason_code`, `product_package`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 2, 1, 1, 2, 1, '359.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(2, 2, 1, 2, 2, 1, '359.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(3, 2, 1, 3, 2, 1, '359.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(4, 2, 1, 4, 2, 1, '359.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(5, 2, 1, 5, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(6, 2, 1, 6, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(7, 2, 1, 7, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(8, 2, 1, 8, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(9, 2, 1, 9, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(10, 2, 1, 10, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(11, 2, 1, 11, 2, 1, '409.00', NULL, NULL, '2017-12-05 12:32:42', NULL, NULL, 1, NULL, NULL, 1),
(12, 2, 1, 12, 2, 1, '359.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(13, 2, 1, 13, 2, 1, '359.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(14, 2, 2, 1, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(15, 2, 2, 2, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(16, 2, 2, 3, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(17, 2, 2, 4, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(18, 2, 2, 5, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(19, 2, 2, 6, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(20, 2, 2, 7, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(21, 2, 2, 8, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(22, 2, 2, 9, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(23, 2, 2, 10, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(24, 2, 2, 11, 2, 1, '219.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(25, 2, 2, 12, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(26, 2, 2, 13, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(27, 2, 3, 1, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(28, 2, 3, 2, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(29, 2, 3, 3, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(30, 2, 3, 4, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:43', NULL, NULL, 1, NULL, NULL, 1),
(31, 2, 3, 5, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(32, 2, 3, 6, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(33, 2, 3, 7, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(34, 2, 3, 8, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(35, 2, 3, 9, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(36, 2, 3, 10, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(37, 2, 3, 11, 2, 1, '219.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(38, 2, 3, 12, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(39, 2, 3, 13, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(40, 2, 4, 1, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(41, 2, 4, 2, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(42, 2, 4, 3, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(43, 2, 4, 4, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(44, 2, 4, 5, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(45, 2, 4, 6, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(46, 2, 4, 7, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(47, 2, 4, 8, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(48, 2, 4, 9, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(49, 2, 4, 10, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(50, 2, 4, 11, 2, 1, '219.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(51, 2, 4, 12, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(52, 2, 4, 13, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(53, 2, 5, 1, 2, 1, '329.00', NULL, NULL, '2017-12-05 12:32:44', NULL, NULL, 1, NULL, NULL, 1),
(54, 2, 5, 2, 2, 1, '329.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(55, 2, 5, 3, 2, 1, '329.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(56, 2, 5, 4, 2, 1, '249.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(57, 2, 5, 5, 2, 1, '249.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(58, 2, 5, 6, 2, 1, '249.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(59, 2, 5, 7, 2, 1, '119.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(60, 2, 5, 8, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(61, 2, 5, 9, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(62, 2, 5, 10, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(63, 2, 5, 11, 2, 1, '359.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(64, 2, 5, 12, 2, 1, '329.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(65, 2, 5, 13, 2, 1, '249.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(66, 2, 6, 1, 2, 1, '669.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(67, 2, 6, 2, 2, 1, '669.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(68, 2, 6, 3, 2, 1, '669.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(69, 2, 6, 4, 2, 1, '669.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(70, 2, 6, 5, 2, 1, '629.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(71, 2, 6, 6, 2, 1, '629.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(72, 2, 6, 7, 2, 1, '629.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(73, 2, 6, 8, 2, 1, '599.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(74, 2, 6, 9, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(75, 2, 6, 10, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(76, 2, 6, 11, 2, 1, '709.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(77, 2, 6, 12, 2, 1, '669.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(78, 2, 6, 13, 2, 1, '669.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(79, 2, 7, 1, 2, 1, '1499.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(80, 2, 7, 2, 2, 1, '1499.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(81, 2, 7, 3, 2, 1, '1499.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(82, 2, 7, 4, 2, 1, '1499.00', NULL, NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(83, 2, 7, 5, 2, 1, '1499.00', '90541', NULL, '2017-12-05 12:32:45', NULL, NULL, 1, NULL, NULL, 1),
(84, 2, 7, 6, 2, 1, '1299.00', '90542', NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(85, 2, 7, 7, 2, 1, '1299.00', '90543', NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(86, 2, 7, 8, 2, 1, '1099.00', '90544', NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(87, 2, 7, 9, 2, 1, '999.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(88, 2, 7, 10, 2, 1, '999.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(89, 2, 7, 11, 2, 1, '1549.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(90, 2, 7, 12, 2, 1, '1499.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(91, 2, 7, 13, 2, 1, '1499.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(92, 2, 8, 1, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(93, 2, 8, 2, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(94, 2, 8, 3, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(95, 2, 8, 4, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(96, 2, 8, 5, 2, 1, '219.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(97, 2, 8, 6, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(98, 2, 8, 7, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(99, 2, 8, 8, 2, 1, '149.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(100, 2, 8, 9, 2, 1, '119.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(101, 2, 8, 10, 2, 1, '119.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(102, 2, 8, 11, 2, 1, '259.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(103, 2, 8, 12, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(104, 2, 8, 13, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(105, 2, 9, 1, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(106, 2, 9, 2, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(107, 2, 9, 3, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(108, 2, 9, 4, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(109, 2, 9, 5, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(110, 2, 9, 6, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:46', NULL, NULL, 1, NULL, NULL, 1),
(111, 2, 9, 7, 2, 1, '399.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(112, 2, 9, 8, 2, 1, '399.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(113, 2, 9, 9, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(114, 2, 9, 10, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(115, 2, 9, 11, 2, 1, '539.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(116, 2, 9, 12, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(117, 2, 9, 13, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(118, 2, 10, 1, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(119, 2, 10, 2, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(120, 2, 10, 3, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(121, 2, 10, 4, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(122, 2, 10, 5, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(123, 2, 10, 6, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(124, 2, 10, 7, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(125, 2, 10, 8, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(126, 2, 10, 9, 2, 1, '9.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(127, 2, 10, 10, 2, 1, '9.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(128, 2, 10, 11, 2, 1, '219.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(129, 2, 10, 12, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(130, 2, 10, 13, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(131, 2, 11, 1, 2, 1, '599.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(132, 2, 11, 2, 2, 1, '599.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(133, 2, 11, 3, 2, 1, '599.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(134, 2, 11, 4, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(135, 2, 11, 5, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(136, 2, 11, 6, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(137, 2, 11, 7, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(138, 2, 11, 8, 2, 1, '259.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(139, 2, 11, 9, 2, 1, '159.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(140, 2, 11, 10, 2, 1, '159.00', NULL, NULL, '2017-12-05 12:32:47', NULL, NULL, 1, NULL, NULL, 1),
(141, 2, 11, 11, 2, 1, '599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(142, 2, 11, 12, 2, 1, '599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(143, 2, 11, 13, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(144, 2, 12, 1, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(145, 2, 12, 2, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(146, 2, 12, 3, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(147, 2, 12, 4, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(148, 2, 12, 5, 2, 1, '2399.00', '90541', NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(149, 2, 12, 6, 2, 1, '1999.00', '90542', NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(150, 2, 12, 7, 2, 1, '1999.00', '90543', NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(151, 2, 12, 8, 2, 1, '1999.00', '90544', NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(152, 2, 12, 9, 2, 1, '1599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(153, 2, 12, 10, 2, 1, '1599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(154, 2, 12, 11, 2, 1, '2639.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(155, 2, 12, 12, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(156, 2, 12, 13, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(157, 2, 13, 1, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(158, 2, 13, 2, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(159, 2, 13, 3, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(160, 2, 13, 4, 2, 1, '259.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(161, 2, 13, 5, 2, 1, '79.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(162, 2, 13, 6, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(163, 2, 13, 7, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(164, 2, 13, 8, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(165, 2, 13, 9, 2, 1, '9.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(166, 2, 13, 10, 2, 1, '9.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(167, 2, 13, 11, 2, 1, '339.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(168, 2, 13, 12, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:48', NULL, NULL, 1, NULL, NULL, 1),
(169, 2, 13, 13, 2, 1, '259.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(170, 2, 14, 1, 2, 1, '699.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(171, 2, 14, 2, 2, 1, '699.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(172, 2, 14, 3, 2, 1, '699.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(173, 2, 14, 4, 2, 1, '699.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(174, 2, 14, 5, 2, 1, '659.00', '90541', NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(175, 2, 14, 6, 2, 1, '629.00', '90542', NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(176, 2, 14, 7, 2, 1, '629.00', '90543', NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(177, 2, 14, 8, 2, 1, '599.00', '90544', NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(178, 2, 14, 9, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(179, 2, 14, 10, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(180, 2, 14, 11, 2, 1, '739.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(181, 2, 14, 12, 2, 1, '699.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(182, 2, 14, 13, 2, 1, '699.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(183, 2, 15, 1, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(184, 2, 15, 2, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(185, 2, 15, 3, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(186, 2, 15, 4, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(187, 2, 15, 5, 2, 1, '479.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(188, 2, 15, 6, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(189, 2, 15, 7, 2, 1, '459.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(190, 2, 15, 8, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(191, 2, 15, 9, 2, 1, '159.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(192, 2, 15, 10, 2, 1, '159.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(193, 2, 15, 11, 2, 1, '539.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(194, 2, 15, 12, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(195, 2, 15, 13, 2, 1, '499.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(196, 2, 16, 1, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(197, 2, 16, 2, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(198, 2, 16, 3, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:49', NULL, NULL, 1, NULL, NULL, 1),
(199, 2, 16, 4, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(200, 2, 16, 5, 2, 1, '219.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(201, 2, 16, 6, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(202, 2, 16, 7, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(203, 2, 16, 8, 2, 1, '259.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(204, 2, 16, 9, 2, 1, '159.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(205, 2, 16, 10, 2, 1, '159.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(206, 2, 16, 11, 2, 1, '259.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(207, 2, 16, 12, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(208, 2, 16, 13, 2, 1, '239.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(209, 2, 17, 1, 2, 1, '899.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(210, 2, 17, 2, 2, 1, '899.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(211, 2, 17, 3, 2, 1, '899.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(212, 2, 17, 4, 2, 1, '799.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(213, 2, 17, 5, 2, 1, '699.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(214, 2, 17, 6, 2, 1, '399.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(215, 2, 17, 7, 2, 1, '399.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(216, 2, 17, 8, 2, 1, '299.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(217, 2, 17, 9, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(218, 2, 17, 10, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(219, 2, 17, 11, 2, 1, '939.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(220, 2, 17, 12, 2, 1, '899.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(221, 2, 17, 13, 2, 1, '799.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(222, 2, 18, 1, 2, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(223, 2, 18, 2, 2, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(224, 2, 18, 3, 2, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(225, 2, 18, 4, 2, 1, '2299.00', NULL, NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(226, 2, 18, 5, 2, 1, '2299.00', '90541', NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(227, 2, 18, 6, 2, 1, '2199.00', '90542', NULL, '2017-12-05 12:32:50', NULL, NULL, 1, NULL, NULL, 1),
(228, 2, 18, 7, 2, 1, '2199.00', '90543', NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(229, 2, 18, 8, 2, 1, '1999.00', '90544', NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(230, 2, 18, 9, 2, 1, '1999.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(231, 2, 18, 10, 2, 1, '1999.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(232, 2, 18, 11, 2, 1, '2439.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(233, 2, 18, 12, 2, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(234, 2, 18, 13, 2, 1, '2299.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(235, 2, 19, 1, 2, 1, '2899.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(236, 2, 19, 2, 2, 1, '2899.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(237, 2, 19, 3, 2, 1, '2899.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(238, 2, 19, 4, 2, 1, '2799.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(239, 2, 19, 5, 2, 1, '2799.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(240, 2, 19, 6, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(241, 2, 19, 7, 2, 1, '2599.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(242, 2, 19, 8, 2, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(243, 2, 19, 9, 2, 1, '2199.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(244, 2, 19, 10, 2, 1, '2199.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(245, 2, 19, 11, 2, 1, '2939.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(246, 2, 19, 12, 2, 1, '2899.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(247, 2, 19, 13, 2, 1, '2799.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(248, 2, 20, 1, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(249, 2, 20, 2, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(250, 2, 20, 3, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(251, 2, 20, 4, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(252, 2, 20, 5, 2, 1, '59.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(253, 2, 20, 6, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(254, 2, 20, 7, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(255, 2, 20, 8, 2, 1, '19.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(256, 2, 20, 9, 2, 1, '9.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(257, 2, 20, 10, 2, 1, '9.00', NULL, NULL, '2017-12-05 12:32:51', NULL, NULL, 1, NULL, NULL, 1),
(258, 2, 20, 11, 2, 1, '219.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(259, 2, 20, 12, 2, 1, '199.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(260, 2, 20, 13, 2, 1, '99.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(261, 2, 1, 1, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(262, 2, 1, 2, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(263, 2, 1, 3, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(264, 2, 1, 4, 1, 1, '229.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(265, 2, 1, 5, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(266, 2, 1, 6, 1, 1, '99.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(267, 2, 1, 7, 1, 1, '99.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(268, 2, 1, 8, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(269, 2, 1, 9, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(270, 2, 1, 10, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(271, 2, 1, 11, 1, 1, '409.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(272, 2, 1, 12, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(273, 2, 1, 13, 1, 1, '229.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(274, 2, 2, 1, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(275, 2, 2, 2, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(276, 2, 2, 3, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(277, 2, 2, 4, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(278, 2, 2, 5, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(279, 2, 2, 6, 1, 1, '19.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(280, 2, 2, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:52', NULL, NULL, 1, NULL, NULL, 1),
(281, 2, 2, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(282, 2, 2, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(283, 2, 2, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(284, 2, 2, 11, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(285, 2, 2, 12, 1, 1, '170.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(286, 2, 2, 13, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(287, 2, 3, 1, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(288, 2, 3, 2, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(289, 2, 3, 3, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(290, 2, 3, 4, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(291, 2, 3, 5, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(292, 2, 3, 6, 1, 1, '19.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(293, 2, 3, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(294, 2, 3, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(295, 2, 3, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(296, 2, 3, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(297, 2, 3, 11, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(298, 2, 3, 12, 1, 1, '170.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(299, 2, 3, 13, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(300, 2, 4, 1, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(301, 2, 4, 2, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(302, 2, 4, 3, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(303, 2, 4, 4, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(304, 2, 4, 5, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(305, 2, 4, 6, 1, 1, '19.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(306, 2, 4, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(307, 2, 4, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(308, 2, 4, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(309, 2, 4, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(310, 2, 4, 11, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:53', NULL, NULL, 1, NULL, NULL, 1),
(311, 2, 4, 12, 1, 1, '170.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(312, 2, 4, 13, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(313, 2, 5, 1, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(314, 2, 5, 2, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(315, 2, 5, 3, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(316, 2, 5, 4, 1, 1, '229.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(317, 2, 5, 5, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(318, 2, 5, 6, 1, 1, '99.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(319, 2, 5, 7, 1, 1, '99.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(320, 2, 5, 8, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(321, 2, 5, 9, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(322, 2, 5, 10, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(323, 2, 5, 11, 1, 1, '359.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(324, 2, 5, 12, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(325, 2, 5, 13, 1, 1, '229.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(326, 2, 6, 1, 1, 1, '669.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(327, 2, 6, 2, 1, 1, '669.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(328, 2, 6, 3, 1, 1, '669.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(329, 2, 6, 4, 1, 1, '669.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(330, 2, 6, 5, 1, 1, '629.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(331, 2, 6, 6, 1, 1, '629.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(332, 2, 6, 7, 1, 1, '499.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(333, 2, 6, 8, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(334, 2, 6, 9, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(335, 2, 6, 10, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(336, 2, 6, 11, 1, 1, '709.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(337, 2, 6, 12, 1, 1, '669.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(338, 2, 6, 13, 1, 1, '669.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(339, 2, 7, 1, 1, 1, '1399.00', NULL, NULL, '2017-12-05 12:32:54', NULL, NULL, 1, NULL, NULL, 1),
(340, 2, 7, 2, 1, 1, '1399.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(341, 2, 7, 3, 1, 1, '1399.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(342, 2, 7, 4, 1, 1, '1399.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(343, 2, 7, 5, 1, 1, '1299.00', '90584', NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(344, 2, 7, 6, 1, 1, '1199.00', '90585', NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(345, 2, 7, 7, 1, 1, '1199.00', '90586', NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(346, 2, 7, 8, 1, 1, '999.00', '90587', NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(347, 2, 7, 9, 1, 1, '999.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(348, 2, 7, 10, 1, 1, '999.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(349, 2, 7, 11, 1, 1, '1549.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(350, 2, 7, 12, 1, 1, '1399.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(351, 2, 7, 13, 1, 1, '1399.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(352, 2, 8, 1, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(353, 2, 8, 2, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(354, 2, 8, 3, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(355, 2, 8, 4, 1, 1, '129.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(356, 2, 8, 5, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(357, 2, 8, 6, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(358, 2, 8, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(359, 2, 8, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(360, 2, 8, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(361, 2, 8, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(362, 2, 8, 11, 1, 1, '259.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(363, 2, 8, 12, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(364, 2, 8, 13, 1, 1, '129.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(365, 2, 9, 1, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(366, 2, 9, 2, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:55', NULL, NULL, 1, NULL, NULL, 1),
(367, 2, 9, 3, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(368, 2, 9, 4, 1, 1, '259.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(369, 2, 9, 5, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(370, 2, 9, 6, 1, 1, '99.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(371, 2, 9, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(372, 2, 9, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(373, 2, 9, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(374, 2, 9, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(375, 2, 9, 11, 1, 1, '539.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(376, 2, 9, 12, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(377, 2, 9, 13, 1, 1, '259.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(378, 2, 10, 1, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(379, 2, 10, 2, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(380, 2, 10, 3, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(381, 2, 10, 4, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(382, 2, 10, 5, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(383, 2, 10, 6, 1, 1, '19.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(384, 2, 10, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(385, 2, 10, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(386, 2, 10, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(387, 2, 10, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(388, 2, 10, 11, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(389, 2, 10, 12, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(390, 2, 10, 13, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(391, 2, 11, 1, 1, 1, '559.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(392, 2, 11, 2, 1, 1, '559.00', NULL, NULL, '2017-12-05 12:32:56', NULL, NULL, 1, NULL, NULL, 1),
(393, 2, 11, 3, 1, 1, '559.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(394, 2, 11, 4, 1, 1, '499.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(395, 2, 11, 5, 1, 1, '499.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(396, 2, 11, 6, 1, 1, '459.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(397, 2, 11, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(398, 2, 11, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(399, 2, 11, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(400, 2, 11, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(401, 2, 11, 11, 1, 1, '599.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(402, 2, 11, 12, 1, 1, '559.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(403, 2, 11, 13, 1, 1, '499.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(404, 2, 12, 1, 1, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(405, 2, 12, 2, 1, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(406, 2, 12, 3, 1, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(407, 2, 12, 4, 1, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(408, 2, 12, 5, 1, 1, '2299.00', '90584', NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(409, 2, 12, 6, 1, 1, '2099.00', '90585', NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(410, 2, 12, 7, 1, 1, '1999.00', '90586', NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(411, 2, 12, 8, 1, 1, '1599.00', '90587', NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(412, 2, 12, 9, 1, 1, '799.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(413, 2, 12, 10, 1, 1, '499.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(414, 2, 12, 11, 1, 1, '2639.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(415, 2, 12, 12, 1, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(416, 2, 12, 13, 1, 1, '2399.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(417, 2, 13, 1, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(418, 2, 13, 2, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(419, 2, 13, 3, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(420, 2, 13, 4, 1, 1, '1.00', NULL, NULL, '2017-12-05 12:32:57', NULL, NULL, 1, NULL, NULL, 1),
(421, 2, 13, 5, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(422, 2, 13, 6, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(423, 2, 13, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(424, 2, 13, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(425, 2, 13, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(426, 2, 13, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(427, 2, 13, 11, 1, 1, '339.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(428, 2, 13, 12, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(429, 2, 13, 13, 1, 1, '1.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(430, 2, 14, 1, 1, 1, '659.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(431, 2, 14, 2, 1, 1, '659.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(432, 2, 14, 3, 1, 1, '659.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(433, 2, 14, 4, 1, 1, '599.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(434, 2, 14, 5, 1, 1, '599.00', '90584', NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(435, 2, 14, 6, 1, 1, '329.00', '90585', NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(436, 2, 14, 7, 1, 1, '199.00', '90586', NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(437, 2, 14, 8, 1, 1, '9.00', '90587', NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(438, 2, 14, 9, 1, 1, '499.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(439, 2, 14, 10, 1, 1, '499.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(440, 2, 14, 11, 1, 1, '739.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(441, 2, 14, 12, 1, 1, '659.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(442, 2, 14, 13, 1, 1, '599.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(443, 2, 15, 1, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(444, 2, 15, 2, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(445, 2, 15, 3, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(446, 2, 15, 4, 1, 1, '259.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(447, 2, 15, 5, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(448, 2, 15, 6, 1, 1, '99.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(449, 2, 15, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:58', NULL, NULL, 1, NULL, NULL, 1),
(450, 2, 15, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(451, 2, 15, 9, 1, 1, '159.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(452, 2, 15, 10, 1, 1, '159.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(453, 2, 15, 11, 1, 1, '539.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(454, 2, 15, 12, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(455, 2, 15, 13, 1, 1, '259.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(456, 2, 16, 1, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(457, 2, 16, 2, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(458, 2, 16, 3, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(459, 2, 16, 4, 1, 1, '129.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(460, 2, 16, 5, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(461, 2, 16, 6, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(462, 2, 16, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(463, 2, 16, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(464, 2, 16, 9, 1, 1, '159.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(465, 2, 16, 10, 1, 1, '159.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(466, 2, 16, 11, 1, 1, '259.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(467, 2, 16, 12, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(468, 2, 16, 13, 1, 1, '129.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(469, 2, 17, 1, 1, 1, '799.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(470, 2, 17, 2, 1, 1, '799.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(471, 2, 17, 3, 1, 1, '799.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(472, 2, 17, 4, 1, 1, '659.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(473, 2, 17, 5, 1, 1, '679.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(474, 2, 17, 6, 1, 1, '399.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(475, 2, 17, 7, 1, 1, '299.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(476, 2, 17, 8, 1, 1, '99.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(477, 2, 17, 9, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(478, 2, 17, 10, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:32:59', NULL, NULL, 1, NULL, NULL, 1),
(479, 2, 17, 11, 1, 1, '939.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(480, 2, 17, 12, 1, 1, '799.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(481, 2, 17, 13, 1, 1, '659.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(482, 2, 18, 1, 1, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(483, 2, 18, 2, 1, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(484, 2, 18, 3, 1, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(485, 2, 18, 4, 1, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(486, 2, 18, 5, 1, 1, '2199.00', '90584', NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(487, 2, 18, 6, 1, 1, '2199.00', '90585', NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(488, 2, 18, 7, 1, 1, '1999.00', '90586', NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(489, 2, 18, 8, 1, 1, '1699.00', '90587', NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(490, 2, 18, 9, 1, 1, '1999.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(491, 2, 18, 10, 1, 1, '1999.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(492, 2, 18, 11, 1, 1, '2439.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(493, 2, 18, 12, 1, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(494, 2, 18, 13, 1, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(495, 2, 19, 1, 1, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(496, 2, 19, 2, 1, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(497, 2, 19, 3, 1, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(498, 2, 19, 4, 1, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(499, 2, 19, 5, 1, 1, '2599.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(500, 2, 19, 6, 1, 1, '2599.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(501, 2, 19, 7, 1, 1, '2499.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(502, 2, 19, 8, 1, 1, '2099.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(503, 2, 19, 9, 1, 1, '2199.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(504, 2, 19, 10, 1, 1, '2199.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(505, 2, 19, 11, 1, 1, '2939.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(506, 2, 19, 12, 1, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(507, 2, 19, 13, 1, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(508, 2, 20, 1, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:33:00', NULL, NULL, 1, NULL, NULL, 1),
(509, 2, 20, 2, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(510, 2, 20, 3, 1, 1, '199.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(511, 2, 20, 4, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(512, 2, 20, 5, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(513, 2, 20, 6, 1, 1, '19.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(514, 2, 20, 7, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(515, 2, 20, 8, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(516, 2, 20, 9, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(517, 2, 20, 10, 1, 1, '9.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(518, 2, 20, 11, 1, 1, '219.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(519, 2, 20, 12, 1, 1, '179.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1);
INSERT INTO `tbl_product_variation` (`product_variation_id`, `variation_type_id`, `product_id`, `plan_id`, `affiliation_id`, `contract_id`, `product_variation_price`, `reason_code`, `product_package`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(520, 2, 20, 13, 1, 1, '59.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(521, 2, 1, 1, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(522, 2, 1, 2, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(523, 2, 1, 3, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(524, 2, 1, 4, 3, 1, '229.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(525, 2, 1, 5, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(526, 2, 1, 6, 3, 1, '99.00', NULL, NULL, '2017-12-05 12:33:01', NULL, NULL, 1, NULL, NULL, 1),
(527, 2, 1, 7, 3, 1, '99.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(528, 2, 1, 8, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(529, 2, 1, 9, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(530, 2, 1, 10, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(531, 2, 1, 11, 3, 1, '409.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(532, 2, 1, 12, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(533, 2, 1, 13, 3, 1, '229.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(534, 2, 2, 1, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(535, 2, 2, 2, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(536, 2, 2, 3, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(537, 2, 2, 4, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(538, 2, 2, 5, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(539, 2, 2, 6, 3, 1, '19.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(540, 2, 2, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(541, 2, 2, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(542, 2, 2, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:02', NULL, NULL, 1, NULL, NULL, 1),
(543, 2, 2, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(544, 2, 2, 11, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(545, 2, 2, 12, 3, 1, '170.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(546, 2, 2, 13, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(547, 2, 3, 1, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(548, 2, 3, 2, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(549, 2, 3, 3, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(550, 2, 3, 4, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(551, 2, 3, 5, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(552, 2, 3, 6, 3, 1, '19.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(553, 2, 3, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(554, 2, 3, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(555, 2, 3, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(556, 2, 3, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(557, 2, 3, 11, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(558, 2, 3, 12, 3, 1, '170.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(559, 2, 3, 13, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(560, 2, 4, 1, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(561, 2, 4, 2, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(562, 2, 4, 3, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(563, 2, 4, 4, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(564, 2, 4, 5, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(565, 2, 4, 6, 3, 1, '19.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(566, 2, 4, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:03', NULL, NULL, 1, NULL, NULL, 1),
(567, 2, 4, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(568, 2, 4, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(569, 2, 4, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(570, 2, 4, 11, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(571, 2, 4, 12, 3, 1, '170.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(572, 2, 4, 13, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(573, 2, 5, 1, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(574, 2, 5, 2, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(575, 2, 5, 3, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(576, 2, 5, 4, 3, 1, '229.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(577, 2, 5, 5, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(578, 2, 5, 6, 3, 1, '99.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(579, 2, 5, 7, 3, 1, '99.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(580, 2, 5, 8, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(581, 2, 5, 9, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(582, 2, 5, 10, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(583, 2, 5, 11, 3, 1, '359.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(584, 2, 5, 12, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(585, 2, 5, 13, 3, 1, '229.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(586, 2, 6, 1, 3, 1, '669.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(587, 2, 6, 2, 3, 1, '669.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(588, 2, 6, 3, 3, 1, '669.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(589, 2, 6, 4, 3, 1, '669.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(590, 2, 6, 5, 3, 1, '629.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(591, 2, 6, 6, 3, 1, '629.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(592, 2, 6, 7, 3, 1, '499.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(593, 2, 6, 8, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(594, 2, 6, 9, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(595, 2, 6, 10, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(596, 2, 6, 11, 3, 1, '709.00', NULL, NULL, '2017-12-05 12:33:04', NULL, NULL, 1, NULL, NULL, 1),
(597, 2, 6, 12, 3, 1, '669.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(598, 2, 6, 13, 3, 1, '669.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(599, 2, 7, 1, 3, 1, '1399.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(600, 2, 7, 2, 3, 1, '1399.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(601, 2, 7, 3, 3, 1, '1399.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(602, 2, 7, 4, 3, 1, '1399.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(603, 2, 7, 5, 3, 1, '1299.00', '90584', NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(604, 2, 7, 6, 3, 1, '1199.00', '90585', NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(605, 2, 7, 7, 3, 1, '1199.00', '90586', NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(606, 2, 7, 8, 3, 1, '999.00', '90587', NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(607, 2, 7, 9, 3, 1, '999.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(608, 2, 7, 10, 3, 1, '999.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(609, 2, 7, 11, 3, 1, '1549.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(610, 2, 7, 12, 3, 1, '1399.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(611, 2, 7, 13, 3, 1, '1399.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(612, 2, 8, 1, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(613, 2, 8, 2, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(614, 2, 8, 3, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(615, 2, 8, 4, 3, 1, '129.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(616, 2, 8, 5, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(617, 2, 8, 6, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(618, 2, 8, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(619, 2, 8, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(620, 2, 8, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(621, 2, 8, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(622, 2, 8, 11, 3, 1, '259.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(623, 2, 8, 12, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(624, 2, 8, 13, 3, 1, '129.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(625, 2, 9, 1, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:05', NULL, NULL, 1, NULL, NULL, 1),
(626, 2, 9, 2, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(627, 2, 9, 3, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(628, 2, 9, 4, 3, 1, '259.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(629, 2, 9, 5, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(630, 2, 9, 6, 3, 1, '99.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(631, 2, 9, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(632, 2, 9, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(633, 2, 9, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(634, 2, 9, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(635, 2, 9, 11, 3, 1, '539.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(636, 2, 9, 12, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(637, 2, 9, 13, 3, 1, '259.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(638, 2, 10, 1, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(639, 2, 10, 2, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(640, 2, 10, 3, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(641, 2, 10, 4, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(642, 2, 10, 5, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(643, 2, 10, 6, 3, 1, '19.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(644, 2, 10, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(645, 2, 10, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(646, 2, 10, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(647, 2, 10, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(648, 2, 10, 11, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(649, 2, 10, 12, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(650, 2, 10, 13, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:06', NULL, NULL, 1, NULL, NULL, 1),
(651, 2, 11, 1, 3, 1, '559.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(652, 2, 11, 2, 3, 1, '559.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(653, 2, 11, 3, 3, 1, '559.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(654, 2, 11, 4, 3, 1, '499.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(655, 2, 11, 5, 3, 1, '499.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(656, 2, 11, 6, 3, 1, '459.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(657, 2, 11, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(658, 2, 11, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(659, 2, 11, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(660, 2, 11, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(661, 2, 11, 11, 3, 1, '599.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(662, 2, 11, 12, 3, 1, '559.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(663, 2, 11, 13, 3, 1, '499.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(664, 2, 12, 1, 3, 1, '2399.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(665, 2, 12, 2, 3, 1, '2399.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(666, 2, 12, 3, 3, 1, '2399.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(667, 2, 12, 4, 3, 1, '2399.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(668, 2, 12, 5, 3, 1, '2299.00', '90584', NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(669, 2, 12, 6, 3, 1, '2099.00', '90585', NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(670, 2, 12, 7, 3, 1, '1999.00', '90586', NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(671, 2, 12, 8, 3, 1, '1599.00', '90587', NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(672, 2, 12, 9, 3, 1, '799.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(673, 2, 12, 10, 3, 1, '499.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(674, 2, 12, 11, 3, 1, '2639.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(675, 2, 12, 12, 3, 1, '2399.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(676, 2, 12, 13, 3, 1, '2399.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(677, 2, 13, 1, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(678, 2, 13, 2, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(679, 2, 13, 3, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:07', NULL, NULL, 1, NULL, NULL, 1),
(680, 2, 13, 4, 3, 1, '1.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(681, 2, 13, 5, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(682, 2, 13, 6, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(683, 2, 13, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(684, 2, 13, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(685, 2, 13, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(686, 2, 13, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(687, 2, 13, 11, 3, 1, '339.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(688, 2, 13, 12, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(689, 2, 13, 13, 3, 1, '1.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(690, 2, 14, 1, 3, 1, '659.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(691, 2, 14, 2, 3, 1, '659.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(692, 2, 14, 3, 3, 1, '659.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(693, 2, 14, 4, 3, 1, '599.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(694, 2, 14, 5, 3, 1, '599.00', '90584', NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(695, 2, 14, 6, 3, 1, '329.00', '90585', NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(696, 2, 14, 7, 3, 1, '199.00', '90586', NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(697, 2, 14, 8, 3, 1, '9.00', '90587', NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(698, 2, 14, 9, 3, 1, '499.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(699, 2, 14, 10, 3, 1, '499.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(700, 2, 14, 11, 3, 1, '739.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(701, 2, 14, 12, 3, 1, '659.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(702, 2, 14, 13, 3, 1, '599.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(703, 2, 15, 1, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(704, 2, 15, 2, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(705, 2, 15, 3, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(706, 2, 15, 4, 3, 1, '259.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(707, 2, 15, 5, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:08', NULL, NULL, 1, NULL, NULL, 1),
(708, 2, 15, 6, 3, 1, '99.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(709, 2, 15, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(710, 2, 15, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(711, 2, 15, 9, 3, 1, '159.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(712, 2, 15, 10, 3, 1, '159.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(713, 2, 15, 11, 3, 1, '539.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(714, 2, 15, 12, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(715, 2, 15, 13, 3, 1, '259.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(716, 2, 16, 1, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(717, 2, 16, 2, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(718, 2, 16, 3, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(719, 2, 16, 4, 3, 1, '129.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(720, 2, 16, 5, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(721, 2, 16, 6, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(722, 2, 16, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(723, 2, 16, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(724, 2, 16, 9, 3, 1, '159.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(725, 2, 16, 10, 3, 1, '159.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(726, 2, 16, 11, 3, 1, '259.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(727, 2, 16, 12, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(728, 2, 16, 13, 3, 1, '129.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(729, 2, 17, 1, 3, 1, '799.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(730, 2, 17, 2, 3, 1, '799.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(731, 2, 17, 3, 3, 1, '799.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(732, 2, 17, 4, 3, 1, '659.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(733, 2, 17, 5, 3, 1, '679.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(734, 2, 17, 6, 3, 1, '399.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(735, 2, 17, 7, 3, 1, '299.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(736, 2, 17, 8, 3, 1, '99.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(737, 2, 17, 9, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:09', NULL, NULL, 1, NULL, NULL, 1),
(738, 2, 17, 10, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(739, 2, 17, 11, 3, 1, '939.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(740, 2, 17, 12, 3, 1, '799.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(741, 2, 17, 13, 3, 1, '659.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(742, 2, 18, 1, 3, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(743, 2, 18, 2, 3, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(744, 2, 18, 3, 3, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(745, 2, 18, 4, 3, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(746, 2, 18, 5, 3, 1, '2199.00', '90584', NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(747, 2, 18, 6, 3, 1, '2199.00', '90585', NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(748, 2, 18, 7, 3, 1, '1999.00', '90586', NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(749, 2, 18, 8, 3, 1, '1699.00', '90587', NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(750, 2, 18, 9, 3, 1, '1999.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(751, 2, 18, 10, 3, 1, '1999.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(752, 2, 18, 11, 3, 1, '2439.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(753, 2, 18, 12, 3, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(754, 2, 18, 13, 3, 1, '2299.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(755, 2, 19, 1, 3, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(756, 2, 19, 2, 3, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(757, 2, 19, 3, 3, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(758, 2, 19, 4, 3, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(759, 2, 19, 5, 3, 1, '2599.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(760, 2, 19, 6, 3, 1, '2599.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(761, 2, 19, 7, 3, 1, '2499.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(762, 2, 19, 8, 3, 1, '2099.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(763, 2, 19, 9, 3, 1, '2199.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(764, 2, 19, 10, 3, 1, '2199.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(765, 2, 19, 11, 3, 1, '2939.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(766, 2, 19, 12, 3, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:10', NULL, NULL, 1, NULL, NULL, 1),
(767, 2, 19, 13, 3, 1, '2799.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(768, 2, 20, 1, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(769, 2, 20, 2, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(770, 2, 20, 3, 3, 1, '199.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(771, 2, 20, 4, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(772, 2, 20, 5, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(773, 2, 20, 6, 3, 1, '19.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(774, 2, 20, 7, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(775, 2, 20, 8, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(776, 2, 20, 9, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(777, 2, 20, 10, 3, 1, '9.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(778, 2, 20, 11, 3, 1, '219.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(779, 2, 20, 12, 3, 1, '179.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(780, 2, 20, 13, 3, 1, '59.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(791, 1, 1, 14, NULL, NULL, '449.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(792, 1, 2, 14, NULL, NULL, '259.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(793, 1, 3, 14, NULL, NULL, '259.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(794, 1, 4, 14, NULL, NULL, '259.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(795, 1, 5, 14, NULL, NULL, '439.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(796, 1, 6, 14, NULL, NULL, '779.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(797, 1, 7, 14, NULL, NULL, '1679.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(798, 1, 8, 14, NULL, NULL, '299.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(799, 1, 9, 14, NULL, NULL, '599.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(800, 1, 10, 14, NULL, NULL, '259.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(801, 1, 11, 14, NULL, NULL, '599.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(802, 1, 12, 14, NULL, NULL, '2699.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(803, 1, 13, 14, NULL, NULL, '399.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(804, 1, 14, 14, NULL, NULL, '1799.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(805, 1, 15, 14, NULL, NULL, '599.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(806, 1, 16, 14, NULL, NULL, '299.00', NULL, NULL, '2017-12-05 12:33:11', NULL, NULL, 1, NULL, NULL, 1),
(807, 1, 17, 14, NULL, NULL, '999.00', NULL, NULL, '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1),
(808, 1, 18, 14, NULL, NULL, '2499.00', NULL, NULL, '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1),
(809, 1, 19, 14, NULL, NULL, '2999.00', NULL, NULL, '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1),
(810, 1, 20, 14, NULL, NULL, '259.00', NULL, NULL, '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1),
(811, 1, 21, 15, NULL, NULL, '5.00', NULL, NULL, '2017-12-05 12:33:12', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_promo`
--

CREATE TABLE `tbl_promo` (
  `promo_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_variation_id` int(11) DEFAULT NULL,
  `add_product_id` int(11) DEFAULT NULL,
  `promo_price` decimal(6,2) DEFAULT NULL,
  `promo_discount` decimal(6,2) DEFAULT NULL,
  `promo_add_product_price` decimal(6,2) DEFAULT NULL,
  `promo_add_product_discount` decimal(6,2) DEFAULT NULL,
  `promo_title` varchar(50) DEFAULT NULL,
  `promo_description` varchar(500) DEFAULT NULL,
  `promo_start_date` datetime NOT NULL,
  `promo_expiration_date` datetime NOT NULL,
  `allow_all_variations` tinyint(1) NOT NULL DEFAULT '0',
  `allowed_variation_type_id` int(11) DEFAULT NULL COMMENT '2: postpago\n1: prepago\nnull: todos',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `publish_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `publish_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que define tipo postpago o prepago';

--
-- Volcado de datos para la tabla `tbl_promo`
--

INSERT INTO `tbl_promo` (`promo_id`, `product_id`, `product_variation_id`, `add_product_id`, `promo_price`, `promo_discount`, `promo_add_product_price`, `promo_add_product_discount`, `promo_title`, `promo_description`, `promo_start_date`, `promo_expiration_date`, `allow_all_variations`, `allowed_variation_type_id`, `created_at`, `updated_at`, `deleted_at`, `publish_at`, `created_by`, `updated_by`, `deleted_by`, `publish_by`, `active`) VALUES
(1, 10, NULL, NULL, NULL, '0.10', NULL, NULL, NULL, NULL, '2017-11-26 00:00:00', '2017-12-28 00:00:00', 1, NULL, '2017-12-05 12:32:40', '2017-12-07 15:15:17', NULL, '2017-12-05 12:32:40', 1, NULL, NULL, 1, 1),
(2, 12, NULL, NULL, NULL, '0.15', NULL, NULL, NULL, NULL, '2017-11-26 00:00:00', '2017-12-28 00:00:00', 1, NULL, '2017-12-05 12:32:40', '2017-12-07 15:15:32', NULL, '2017-12-05 12:32:40', 1, NULL, NULL, 1, 1),
(3, 19, NULL, NULL, '9.00', NULL, NULL, NULL, NULL, NULL, '2017-11-26 00:00:00', '2017-12-28 00:00:00', 1, NULL, '2017-12-05 12:32:40', '2017-12-07 17:57:33', NULL, '2017-12-05 12:32:40', 1, NULL, NULL, 1, 1),
(4, 18, 488, NULL, NULL, '0.25', NULL, NULL, 'promocion navideña', 'esta es una promoción de navidad!', '2017-12-07 17:56:13', '2017-12-28 00:00:00', 0, NULL, '2017-12-07 17:56:13', '2017-12-07 18:24:49', NULL, '2017-12-07 18:09:34', 1, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_province`
--

CREATE TABLE `tbl_province` (
  `province_id` int(11) NOT NULL,
  `departament_id` int(11) NOT NULL,
  `province_name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_province`
--

INSERT INTO `tbl_province` (`province_id`, `departament_id`, `province_name`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 1, 'CHACHAPOYAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2, 1, 'BAGUA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3, 1, 'BONGARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(4, 1, 'CONDORCANQUI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(5, 1, 'LUYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(6, 1, 'RODRIGUEZ DE MENDOZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(7, 1, 'UTCUBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(8, 2, 'HUARAZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(9, 2, 'AIJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(10, 2, 'ANTONIO RAYMONDI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(11, 2, 'ASUNCION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(12, 2, 'BOLOGNESI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(13, 2, 'CARHUAZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(14, 2, 'CARLOS F. FITZCARRALD', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(15, 2, 'CASMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(16, 2, 'CORONGO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(17, 2, 'HUARI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(18, 2, 'HUARMEY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(19, 2, 'HUAYLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(20, 2, 'MARISCAL LUZURIAGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(21, 2, 'OCROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(22, 2, 'PALLASCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(23, 2, 'POMABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(24, 2, 'RECUAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(25, 2, 'SANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(26, 2, 'SIHUAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(27, 2, 'YUNGAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(28, 3, 'ABANCAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(29, 3, 'ANDAHUAYLAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(30, 3, 'ANTABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(31, 3, 'AYMARAES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(32, 3, 'COTABAMBAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(33, 3, 'CHINCHEROS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(34, 3, 'GRAU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(35, 4, 'AREQUIPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(36, 4, 'CAMANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(37, 4, 'CARAVELI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(38, 4, 'CASTILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(39, 4, 'CAYLLOMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(40, 4, 'CONDESUYOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(41, 4, 'ISLAY', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(42, 4, 'LA UNION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(43, 5, 'HUAMANGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(44, 5, 'CANGALLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(45, 5, 'HUANCA SANCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(46, 5, 'HUANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(47, 5, 'LA MAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(48, 5, 'LUCANAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(49, 5, 'PARINACOCHAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(50, 5, 'PAUCAR DEL SARA SARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(51, 5, 'SUCRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(52, 5, 'VICTOR FAJARDO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(53, 5, 'VILCAS HUAMAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(54, 6, 'CAJAMARCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(55, 6, 'CAJABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(56, 6, 'CELENDIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(57, 6, 'CHOTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(58, 6, 'CONTUMAZA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(59, 6, 'CUTERVO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(60, 6, 'HUALGAYOC', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(61, 6, 'JAEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(62, 6, 'SAN IGNACIO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(63, 6, 'SAN MARCOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(64, 6, 'SAN MIGUEL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(65, 6, 'SAN PABLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(66, 6, 'SANTA CRUZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(67, 7, 'CALLAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(68, 8, 'CUSCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(69, 8, 'ACOMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(70, 8, 'ANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(71, 8, 'CALCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(72, 8, 'CANAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(73, 8, 'CANCHIS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(74, 8, 'CHUMBIVILCAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(75, 8, 'ESPINAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(76, 8, 'LA CONVENCION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(77, 8, 'PARURO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(78, 8, 'PAUCARTAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(79, 8, 'QUISPICANCHI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(80, 8, 'URUBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(81, 9, 'HUANCAVELICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(82, 9, 'ACOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(83, 9, 'ANGARAES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(84, 9, 'CASTROVIRREYNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(85, 9, 'CHURCAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(86, 9, 'HUAYTARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(87, 9, 'TAYACAJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(88, 10, 'HUANUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(89, 10, 'AMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(90, 10, 'DOS DE MAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(91, 10, 'HUACAYBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(92, 10, 'HUAMALIES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(93, 10, 'LEONCIO PRADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(94, 10, 'MARAÑON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(95, 10, 'PACHITEA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(96, 10, 'PUERTO INCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(97, 10, 'LAURICOCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(98, 10, 'YAROWILCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(99, 11, 'ICA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(100, 11, 'CHINCHA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(101, 11, 'NAZCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(102, 11, 'PALPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(103, 11, 'PISCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(104, 12, 'HUANCAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(105, 12, 'CONCEPCION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(106, 12, 'CHANCHAMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(107, 12, 'JAUJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(108, 12, 'JUNIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(109, 12, 'SATIPO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(110, 12, 'TARMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(111, 12, 'YAULI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(112, 12, 'CHUPACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(113, 13, 'TRUJILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(114, 13, 'ASCOPE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(115, 13, 'BOLIVAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(116, 13, 'CHEPEN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(117, 13, 'JULCAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(118, 13, 'OTUZCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(119, 13, 'PACASMAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(120, 13, 'PATAZ', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(121, 13, 'SANCHEZ CARRION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(122, 13, 'SANTIAGO DE CHUCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(123, 13, 'GRAN CHIMU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(124, 13, 'VIRU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(125, 14, 'CHICLAYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(126, 14, 'FERREÑAFE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(127, 14, 'LAMBAYEQUE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(128, 15, 'LIMA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(129, 15, 'BARRANCA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(130, 15, 'CAJATAMBO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(131, 15, 'CANTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(132, 15, 'CAÑETE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(133, 15, 'HUARAL', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(134, 15, 'HUAROCHIRI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(135, 15, 'HUAURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(136, 15, 'OYON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(137, 15, 'YAUYOS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(138, 16, 'MAYNAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(139, 16, 'ALTO AMAZONAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(140, 16, 'LORETO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(141, 16, 'MARISCAL RAMON CASTILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(142, 16, 'REQUENA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(143, 16, 'UCAYALI', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(144, 16, 'DATEM DEL MARAÑON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(145, 17, 'TAMBOPATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(146, 17, 'MANU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(147, 17, 'TAHUAMANU', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(148, 18, 'MARISCAL NIETO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(149, 18, 'GENERAL SANCHEZ CERRO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(150, 18, 'ILO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(151, 19, 'PASCO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(152, 19, 'DANIEL ALCIDES CARRION', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(153, 19, 'OXAPAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(154, 20, 'PIURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(155, 20, 'AYABACA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(156, 20, 'HUANCABAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(157, 20, 'MORROPON', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(158, 20, 'PAITA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(159, 20, 'SULLANA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(160, 20, 'TALARA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(161, 20, 'SECHURA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(162, 21, 'PUNO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(163, 21, 'AZANGARO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(164, 21, 'CARABAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(165, 21, 'CHUCUITO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(166, 21, 'EL COLLAO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(167, 21, 'HUANCANE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(168, 21, 'LAMPA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(169, 21, 'MELGAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(170, 21, 'MOHO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(171, 21, 'SAN ANTONIO DE PUTINA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(172, 21, 'SAN ROMAN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(173, 21, 'SANDIA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(174, 21, 'YUNGUYO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(175, 22, 'MOYOBAMBA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(176, 22, 'BELLAVISTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(177, 22, 'EL DORADO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(178, 22, 'HUALLAGA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(179, 22, 'LAMAS', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(180, 22, 'MARISCAL CACERES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(181, 22, 'PICOTA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(182, 22, 'RIOJA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(183, 22, 'SAN MARTIN', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(184, 22, 'TOCACHE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(185, 23, 'TACNA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(186, 23, 'CANDARAVE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(187, 23, 'JORGE BASADRE', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(188, 23, 'TARATA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(189, 24, 'TUMBES', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(190, 24, 'CONTRALMIRANTE VILLAR', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(191, 24, 'ZARUMILLA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(192, 25, 'CORONEL PORTILLO', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(193, 25, 'ATALAYA', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(194, 25, 'PADRE ABAD', NULL, NULL, NULL, NULL, NULL, NULL, 1),
(195, 25, 'PURUS', NULL, NULL, NULL, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_stock_model`
--

CREATE TABLE `tbl_stock_model` (
  `stock_model_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `color_id` int(11) DEFAULT NULL,
  `stock_model_code` varchar(8) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_stock_model`
--

INSERT INTO `tbl_stock_model` (`stock_model_id`, `product_id`, `color_id`, `stock_model_code`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 7, 2, '053039', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(2, 7, 3, '053040', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(3, 12, NULL, '053074', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(4, 14, 4, '053069', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(5, 14, 5, '053068', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(6, 18, 1, '053032', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(7, 19, 1, '053033', '2017-12-05 12:32:39', NULL, NULL, 1, NULL, NULL, 1),
(8, 22, NULL, '053070', '2017-12-05 12:32:40', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_user`
--

CREATE TABLE `tbl_user` (
  `id` int(11) NOT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `user_email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_user`
--

INSERT INTO `tbl_user` (`id`, `user_name`, `user_email`, `password`, `remember_token`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Agente Prueba', 'agente.prueba@bitel.pe', '$2y$10$uxajRLmSd08NUSzIqJslw.17vHKahezEKRshOefldRoqnJEmS34sO', NULL, '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_variation_type`
--

CREATE TABLE `tbl_variation_type` (
  `variation_type_id` int(11) NOT NULL,
  `variation_type_name` varchar(20) NOT NULL,
  `variation_type_slug` varchar(150) DEFAULT NULL,
  `allow_plan` tinyint(1) NOT NULL DEFAULT '1',
  `allow_affiliation` tinyint(1) NOT NULL DEFAULT '1',
  `allow_contract` tinyint(1) NOT NULL DEFAULT '1',
  `weight` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT '1',
  `updated_by` int(11) DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tbl_variation_type`
--

INSERT INTO `tbl_variation_type` (`variation_type_id`, `variation_type_name`, `variation_type_slug`, `allow_plan`, `allow_affiliation`, `allow_contract`, `weight`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`, `deleted_by`, `active`) VALUES
(1, 'Prepago', 'prepago', 1, 0, 0, 1, '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1),
(2, 'Postpago', 'postpago', 1, 1, 1, 1, '2017-12-05 12:32:35', NULL, NULL, 1, NULL, NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tbl_affiliation`
--
ALTER TABLE `tbl_affiliation`
  ADD PRIMARY KEY (`affiliation_id`);
ALTER TABLE `tbl_affiliation` ADD FULLTEXT KEY `indx_srch_affiliation_slug` (`affiliation_slug`);

--
-- Indices de la tabla `tbl_branch`
--
ALTER TABLE `tbl_branch`
  ADD PRIMARY KEY (`branch_id`);

--
-- Indices de la tabla `tbl_brand`
--
ALTER TABLE `tbl_brand`
  ADD PRIMARY KEY (`brand_id`);
ALTER TABLE `tbl_brand` ADD FULLTEXT KEY `indx_srchbrand` (`brand_name`);
ALTER TABLE `tbl_brand` ADD FULLTEXT KEY `indx_srch_brand_slug` (`brand_slug`);

--
-- Indices de la tabla `tbl_category`
--
ALTER TABLE `tbl_category`
  ADD PRIMARY KEY (`category_id`);
ALTER TABLE `tbl_category` ADD FULLTEXT KEY `indx_srch_category_slug` (`category_slug`);

--
-- Indices de la tabla `tbl_color`
--
ALTER TABLE `tbl_color`
  ADD PRIMARY KEY (`color_id`);
ALTER TABLE `tbl_color` ADD FULLTEXT KEY `indx_srch_color_slug` (`color_slug`);

--
-- Indices de la tabla `tbl_contract`
--
ALTER TABLE `tbl_contract`
  ADD PRIMARY KEY (`contract_id`);
ALTER TABLE `tbl_contract` ADD FULLTEXT KEY `indx_srch_contract_slug` (`contract_slug`);

--
-- Indices de la tabla `tbl_department`
--
ALTER TABLE `tbl_department`
  ADD PRIMARY KEY (`departament_id`);

--
-- Indices de la tabla `tbl_district`
--
ALTER TABLE `tbl_district`
  ADD PRIMARY KEY (`disctric_id`),
  ADD KEY `fk_tbl_district_tbl_province1_idx` (`province_id`),
  ADD KEY `fk_tbl_district_tbl_branch1_idx` (`branch_id`);

--
-- Indices de la tabla `tbl_idtype`
--
ALTER TABLE `tbl_idtype`
  ADD PRIMARY KEY (`idtype_id`);

--
-- Indices de la tabla `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_tbl_order_tbl_idtype1_idx` (`idtype_id`),
  ADD KEY `fk_tbl_order_tbl_payment_method1_idx` (`payment_method_id`),
  ADD KEY `fk_tbl_order_tbl_branch1_idx` (`branch_id`),
  ADD KEY `fk_tbl_order_tbl_district01_idx` (`billing_district`),
  ADD KEY `fk_tbl_order_tbl_district_delivery_idx` (`delivery_district`);

--
-- Indices de la tabla `tbl_order_item`
--
ALTER TABLE `tbl_order_item`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `fk_tbl_order_item_tbl_order1_idx` (`order_id`),
  ADD KEY `fk_tbl_order_item_tbl_stock_model1_idx` (`stock_model_id`),
  ADD KEY `fk_tbl_order_item_tbl_product_variation1_idx` (`product_variation_id`),
  ADD KEY `fk_tbl_order_item_tbl_promo1_idx` (`promo_id`);

--
-- Indices de la tabla `tbl_order_status`
--
ALTER TABLE `tbl_order_status`
  ADD PRIMARY KEY (`order_status_id`);

--
-- Indices de la tabla `tbl_order_status_history`
--
ALTER TABLE `tbl_order_status_history`
  ADD PRIMARY KEY (`order_status_history_id`),
  ADD KEY `fk_tbl_order_status_history_tbl_order1_idx` (`order_id`),
  ADD KEY `fk_tbl_order_status_history_tbl_order_status1_idx` (`order_status_id`);

--
-- Indices de la tabla `tbl_payment_method`
--
ALTER TABLE `tbl_payment_method`
  ADD PRIMARY KEY (`payment_method_id`);

--
-- Indices de la tabla `tbl_plan`
--
ALTER TABLE `tbl_plan`
  ADD PRIMARY KEY (`plan_id`);
ALTER TABLE `tbl_plan` ADD FULLTEXT KEY `indx_srch_plan_slug` (`plan_slug`);

--
-- Indices de la tabla `tbl_product`
--
ALTER TABLE `tbl_product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `fk_tbl_product_tbl_brand1_idx` (`brand_id`),
  ADD KEY `fk_tbl_product_tbl_category1_idx` (`category_id`);
ALTER TABLE `tbl_product` ADD FULLTEXT KEY `indx_srchproduct` (`product_model`,`product_keywords`,`product_description`);
ALTER TABLE `tbl_product` ADD FULLTEXT KEY `indx_srch_product_slug` (`product_slug`);

--
-- Indices de la tabla `tbl_product_image`
--
ALTER TABLE `tbl_product_image`
  ADD PRIMARY KEY (`product_image_id`),
  ADD KEY `fk_tbl_product_image_tbl_stock_model1_idx` (`stock_model_id`);

--
-- Indices de la tabla `tbl_product_variation`
--
ALTER TABLE `tbl_product_variation`
  ADD PRIMARY KEY (`product_variation_id`),
  ADD KEY `fk_tbl_product_variation_tbl_variation_type1_idx` (`variation_type_id`),
  ADD KEY `fk_tbl_product_variation_tbl_product1_idx` (`product_id`),
  ADD KEY `fk_tbl_product_variation_tbl_affiliation1_idx` (`affiliation_id`),
  ADD KEY `fk_tbl_product_variation_tbl_plan1_idx` (`plan_id`),
  ADD KEY `fk_tbl_product_variation_tbl_contract1_idx` (`contract_id`);

--
-- Indices de la tabla `tbl_promo`
--
ALTER TABLE `tbl_promo`
  ADD PRIMARY KEY (`promo_id`),
  ADD KEY `fk_tbl_promo_tbl_product1_idx` (`product_id`),
  ADD KEY `fk_tbl_promo_tbl_product_variation1_idx` (`product_variation_id`),
  ADD KEY `fk_tbl_promo_tbl_product2_idx` (`add_product_id`),
  ADD KEY `fk_tbl_promo_tbl_variation_type1_idx` (`allowed_variation_type_id`);

--
-- Indices de la tabla `tbl_province`
--
ALTER TABLE `tbl_province`
  ADD PRIMARY KEY (`province_id`),
  ADD KEY `fk_tbl_province_tbl_department1_idx` (`departament_id`);

--
-- Indices de la tabla `tbl_stock_model`
--
ALTER TABLE `tbl_stock_model`
  ADD PRIMARY KEY (`stock_model_id`),
  ADD KEY `fk_tbl_stock_model_tbl_product1_idx` (`product_id`),
  ADD KEY `fk_tbl_stock_model_tbl_color1_idx` (`color_id`);

--
-- Indices de la tabla `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tbl_variation_type`
--
ALTER TABLE `tbl_variation_type`
  ADD PRIMARY KEY (`variation_type_id`);
ALTER TABLE `tbl_variation_type` ADD FULLTEXT KEY `indx_srch_variation_type_slug` (`variation_type_slug`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tbl_affiliation`
--
ALTER TABLE `tbl_affiliation`
  MODIFY `affiliation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_branch`
--
ALTER TABLE `tbl_branch`
  MODIFY `branch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tbl_brand`
--
ALTER TABLE `tbl_brand`
  MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_category`
--
ALTER TABLE `tbl_category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tbl_color`
--
ALTER TABLE `tbl_color`
  MODIFY `color_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tbl_contract`
--
ALTER TABLE `tbl_contract`
  MODIFY `contract_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tbl_department`
--
ALTER TABLE `tbl_department`
  MODIFY `departament_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `tbl_district`
--
ALTER TABLE `tbl_district`
  MODIFY `disctric_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1839;

--
-- AUTO_INCREMENT de la tabla `tbl_idtype`
--
ALTER TABLE `tbl_idtype`
  MODIFY `idtype_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_order`
--
ALTER TABLE `tbl_order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tbl_order_item`
--
ALTER TABLE `tbl_order_item`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tbl_order_status`
--
ALTER TABLE `tbl_order_status`
  MODIFY `order_status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tbl_order_status_history`
--
ALTER TABLE `tbl_order_status_history`
  MODIFY `order_status_history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tbl_payment_method`
--
ALTER TABLE `tbl_payment_method`
  MODIFY `payment_method_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tbl_plan`
--
ALTER TABLE `tbl_plan`
  MODIFY `plan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `tbl_product`
--
ALTER TABLE `tbl_product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de la tabla `tbl_product_image`
--
ALTER TABLE `tbl_product_image`
  MODIFY `product_image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_product_variation`
--
ALTER TABLE `tbl_product_variation`
  MODIFY `product_variation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=812;

--
-- AUTO_INCREMENT de la tabla `tbl_promo`
--
ALTER TABLE `tbl_promo`
  MODIFY `promo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tbl_province`
--
ALTER TABLE `tbl_province`
  MODIFY `province_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=196;

--
-- AUTO_INCREMENT de la tabla `tbl_stock_model`
--
ALTER TABLE `tbl_stock_model`
  MODIFY `stock_model_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tbl_variation_type`
--
ALTER TABLE `tbl_variation_type`
  MODIFY `variation_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_district`
--
ALTER TABLE `tbl_district`
  ADD CONSTRAINT `fk_tbl_district_tbl_branch1` FOREIGN KEY (`branch_id`) REFERENCES `tbl_branch` (`branch_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_district_tbl_province1` FOREIGN KEY (`province_id`) REFERENCES `tbl_province` (`province_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD CONSTRAINT `fk_tbl_order_tbl_branch1` FOREIGN KEY (`branch_id`) REFERENCES `tbl_branch` (`branch_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_tbl_district_billing` FOREIGN KEY (`billing_district`) REFERENCES `tbl_district` (`disctric_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_tbl_district_delivery` FOREIGN KEY (`delivery_district`) REFERENCES `tbl_district` (`disctric_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_tbl_idtype1` FOREIGN KEY (`idtype_id`) REFERENCES `tbl_idtype` (`idtype_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_tbl_payment_method1` FOREIGN KEY (`payment_method_id`) REFERENCES `tbl_payment_method` (`payment_method_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_order_item`
--
ALTER TABLE `tbl_order_item`
  ADD CONSTRAINT `fk_tbl_order_item_tbl_order1` FOREIGN KEY (`order_id`) REFERENCES `tbl_order` (`order_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_item_tbl_product_variation1` FOREIGN KEY (`product_variation_id`) REFERENCES `tbl_product_variation` (`product_variation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_item_tbl_promo1` FOREIGN KEY (`promo_id`) REFERENCES `tbl_promo` (`promo_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_item_tbl_stock_model1` FOREIGN KEY (`stock_model_id`) REFERENCES `tbl_stock_model` (`stock_model_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_order_status_history`
--
ALTER TABLE `tbl_order_status_history`
  ADD CONSTRAINT `fk_tbl_order_status_history_tbl_order1` FOREIGN KEY (`order_id`) REFERENCES `tbl_order` (`order_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_status_history_tbl_order_status1` FOREIGN KEY (`order_status_id`) REFERENCES `tbl_order_status` (`order_status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_product`
--
ALTER TABLE `tbl_product`
  ADD CONSTRAINT `fk_tbl_product_tbl_brand1` FOREIGN KEY (`brand_id`) REFERENCES `tbl_brand` (`brand_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_product_tbl_category1` FOREIGN KEY (`category_id`) REFERENCES `tbl_category` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_product_image`
--
ALTER TABLE `tbl_product_image`
  ADD CONSTRAINT `fk_tbl_product_image_tbl_stock_model1` FOREIGN KEY (`stock_model_id`) REFERENCES `tbl_stock_model` (`stock_model_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_product_variation`
--
ALTER TABLE `tbl_product_variation`
  ADD CONSTRAINT `fk_tbl_product_variation_tbl_affiliation1` FOREIGN KEY (`affiliation_id`) REFERENCES `tbl_affiliation` (`affiliation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_product_variation_tbl_contract1` FOREIGN KEY (`contract_id`) REFERENCES `tbl_contract` (`contract_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_product_variation_tbl_plan1` FOREIGN KEY (`plan_id`) REFERENCES `tbl_plan` (`plan_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_product_variation_tbl_product1` FOREIGN KEY (`product_id`) REFERENCES `tbl_product` (`product_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_product_variation_tbl_variation_type1` FOREIGN KEY (`variation_type_id`) REFERENCES `tbl_variation_type` (`variation_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_promo`
--
ALTER TABLE `tbl_promo`
  ADD CONSTRAINT `fk_tbl_promo_tbl_product1` FOREIGN KEY (`product_id`) REFERENCES `tbl_product` (`product_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_promo_tbl_product2` FOREIGN KEY (`add_product_id`) REFERENCES `tbl_product` (`product_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_promo_tbl_product_variation1` FOREIGN KEY (`product_variation_id`) REFERENCES `tbl_product_variation` (`product_variation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_promo_tbl_variation_type1` FOREIGN KEY (`allowed_variation_type_id`) REFERENCES `tbl_variation_type` (`variation_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_province`
--
ALTER TABLE `tbl_province`
  ADD CONSTRAINT `fk_tbl_province_tbl_department1` FOREIGN KEY (`departament_id`) REFERENCES `tbl_department` (`departament_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tbl_stock_model`
--
ALTER TABLE `tbl_stock_model`
  ADD CONSTRAINT `fk_tbl_stock_model_tbl_color1` FOREIGN KEY (`color_id`) REFERENCES `tbl_color` (`color_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_stock_model_tbl_product1` FOREIGN KEY (`product_id`) REFERENCES `tbl_product` (`product_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
