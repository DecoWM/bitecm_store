USE `bitel_ecommerce`;

ALTER TABLE tbl_store ADD COLUMN branch_id INT(11) NOT NULL AFTER store_id;

ALTER TABLE tbl_store ADD CONSTRAINT fk_tbl_store_tbl_branch FOREIGN KEY (branch_id) REFERENCES tbl_branch (branch_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
