USE `bitel_ecommerce`;

ALTER TABLE tbl_order MODIFY COLUMN first_name VARCHAR(150) NOT NULL;
ALTER TABLE tbl_order MODIFY COLUMN last_name VARCHAR(100) NULL;