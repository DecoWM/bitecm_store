SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_orderStatusHistory`$$

CREATE PROCEDURE `PA_orderStatusHistory`(
  IN order_id INT
)
BEGIN
  DECLARE stored_query TEXT;
  DECLARE select_query TEXT;
  DECLARE from_query TEXT;
  DECLARE where_query TEXT;
  SET order_id = IFNULL(order_id, 0);
  SET select_query = 'SELECT
    OSH.*, OST.`order_status_name`, OST.`weight`, OST.`weight2`';
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

DELIMITER ;