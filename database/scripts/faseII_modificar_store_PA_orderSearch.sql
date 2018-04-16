DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_orderSearch`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_orderSearch`(
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
        AFF.`affiliation_name`,
        PRO.`product_model`
      FROM tbl_order_item as OIT
      LEFT JOIN tbl_product_variation as PRD_VAR
        ON OIT.`product_variation_id` = PRD_VAR.`product_variation_id`
      LEFT JOIN tbl_variation_type as VAR
        ON PRD_VAR.`variation_type_id` = VAR.`variation_type_id`
      LEFT JOIN tbl_plan as PLN
        ON PRD_VAR.`plan_id` = PLN.`plan_id`
      LEFT JOIN tbl_affiliation as AFF
        ON PRD_VAR.`affiliation_id` = AFF.`affiliation_id`
      LEFT JOIN tbl_product as PRO
        ON OIT.`product_variation_id` = PRD_VAR.`product_variation_id` AND
           PRD_VAR.`product_id` = PRO.`product_id`
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
END$$

DELIMITER ;