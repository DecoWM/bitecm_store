USE `bitel_ecommerce`;

ALTER TABLE tbl_order ADD COLUMN idschedule_id INT(11) NOT NULL DEFAULT 1 AFTER terminos_condiciones;

ALTER TABLE tbl_order ADD CONSTRAINT fk_tbl_order_tbl_schedule FOREIGN KEY (idschedule_id) REFERENCES tbl_schedule (idschedule_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
