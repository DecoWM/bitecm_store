DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_scheduleList`$$

CREATE PROCEDURE `PA_scheduleList`()
BEGIN
		SELECT idschedule_id, idschedule_name
		FROM tbl_schedule
		ORDER BY idschedule_id ASC;
	END$$

DELIMITER ;