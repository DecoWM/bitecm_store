DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_deptprovdistbrachList`$$

CREATE PROCEDURE `PA_deptprovdistbrachList`()

BEGIN
    --
    SELECT C.departament_id , C.departament_name,  A.province_id, B.province_name, A.district_id, A.district_name, A.branch_id, D.branch_name
FROM tbl_district A
INNER JOIN tbl_province B ON A.province_id = B.province_id
INNER JOIN tbl_department C ON C.departament_id = B.departament_id
INNER JOIN tbl_branch D ON D.branch_id = A.branch_id
WHERE A.branch_id IS NOT NULL AND
      C.active = 1 AND
      B.active = 1 AND
      A.active = 1 AND
      D.active = 1 
ORDER BY C.departament_id DESC, A.district_name ASC ;
END$$

DELIMITER ;