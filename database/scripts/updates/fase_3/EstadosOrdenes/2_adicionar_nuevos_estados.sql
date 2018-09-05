USE `bitel_ecommerce`;

INSERT INTO tbl_order_status (order_status_name, weight, weight2, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active) 
VALUE('Programado',0,0,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_order_status (order_status_name, weight, weight2, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active) 
VALUE('No Contactado',0,0,NOW(),NULL,NULL,1,NULL,NULL,1);
