USE `bitel_ecommerce`;

UPDATE tbl_order_status SET weight = 1, weight2 = 1 WHERE order_status_name = 'Pendiente';
UPDATE tbl_order_status SET weight = 2, weight2 = 3 WHERE order_status_name = 'Procesado';
UPDATE tbl_order_status SET weight = 4, weight2 = 0 WHERE order_status_id = 3;
UPDATE tbl_order_status SET weight = 7, weight2 = 0 WHERE order_status_name = 'Cancelado';
UPDATE tbl_order_status SET weight = 5, weight2 = 0 WHERE order_status_name = 'Completado';
UPDATE tbl_order_status SET weight = 3, weight2 = 0 WHERE order_status_name = 'Programado';
UPDATE tbl_order_status SET weight = 6, weight2 = 2 WHERE order_status_name = 'No Contactado';
