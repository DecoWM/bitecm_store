USE `bitel_ecommerce` ;

ALTER TABLE `tbl_product` MODIFY COLUMN `product_tag` enum('Nuevo','Destacado','Promoción') DEFAULT NULL;
