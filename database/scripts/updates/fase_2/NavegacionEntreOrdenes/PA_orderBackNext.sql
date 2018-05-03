SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_orderBackNext`$$

CREATE PROCEDURE `PA_orderBackNext`(IN _order_id INT(11))
BEGIN

DECLARE _order_next INT(11);
DECLARE _order_back INT(11);

SELECT IFNULL(MIN(order_id),0) INTO _order_back FROM tbl_order_status_history WHERE order_id > _order_id ORDER BY created_at DESC LIMIT 1;
SELECT IFNULL(MAX(order_id),0) INTO _order_next FROM tbl_order_status_history WHERE order_id < _order_id ORDER BY created_at DESC LIMIT 1;

SELECT _order_back AS 'order_back', _order_next AS 'order_next';

END$$

DELIMITER ;