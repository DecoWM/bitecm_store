USE `bitel_ecommerce`;

ALTER TABLE tbl_order ADD COLUMN type_number_carry ENUM('Prepaid','Postpaid') AFTER affiliation_type;
