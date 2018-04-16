USE `bitel_ecommerce` ;

ALTER TABLE tbl_plan ADD COLUMN vende_en_chip TINYINT(4) DEFAULT 0 AFTER active;
ALTER TABLE tbl_plan ADD COLUMN disponible_en_chip TINYINT(1) DEFAULT 0 AFTER vende_en_chip;