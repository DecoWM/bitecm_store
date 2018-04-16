USE `bitel_ecommerce`;

ALTER TABLE tbl_user ADD COLUMN user_rol ENUM('1','2','3') NOT NULL AFTER user_email;

UPDATE tbl_user SET user_rol = 1 WHERE id = 1;