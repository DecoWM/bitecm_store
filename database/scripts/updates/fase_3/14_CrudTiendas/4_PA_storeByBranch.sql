DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_storesByBranch`$$

CREATE PROCEDURE `PA_storesByBranch`(IN _branch_id INT(11))
BEGIN
		SELECT store_id, store_name FROM tbl_store WHERE branch_id = _branch_id AND active = 1 ORDER BY store_id ASC;
	END$$

DELIMITER ;