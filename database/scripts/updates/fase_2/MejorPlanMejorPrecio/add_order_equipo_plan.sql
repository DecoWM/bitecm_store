USE `bitel_ecommerce` ;

ALTER TABLE tbl_order_item ADD COLUMN equipo_plan TINYINT(4) DEFAULT 0 AFTER active;
