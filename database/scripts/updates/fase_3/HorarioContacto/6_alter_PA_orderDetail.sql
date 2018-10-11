DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_orderDetail`$$

CREATE PROCEDURE `PA_orderDetail`(
  IN order_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  SET order_id = IFNULL(order_id, 0);
  SET select_query = 'SELECT
    ORD.*, OST.*, IDT.`idtype_name`, SIDT.idschedule_name,
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
    LEFT JOIN tbl_schedule as SIDT
      ON ORD.`idschedule_id` = SIDT.`idschedule_id`  
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
END$$

DELIMITER ;