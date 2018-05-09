USE `bitel_ecommerce`;

ALTER TABLE tbl_product ADD COLUMN product_memory_ram VARCHAR(10) AFTER product_processor_name;
