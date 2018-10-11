USE `bitel_ecommerce`;

ALTER TABLE tbl_order ADD COLUMN terminos_condiciones TINYINT(1) DEFAULT 0 AFTER total_igv;