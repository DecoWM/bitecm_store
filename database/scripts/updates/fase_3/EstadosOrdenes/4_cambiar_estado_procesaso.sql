USE `bitel_ecommerce`;

UPDATE tbl_order_status SET order_status_name = 'Aceptado' WHERE order_status_name = 'Procesado';
