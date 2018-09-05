USE `bitel_ecommerce`;

INSERT INTO tbl_order_status_flux (order_status_origin_id, order_status_destination_id, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES(2,6,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_order_status_flux (order_status_origin_id, order_status_destination_id, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES(6,3,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_order_status_flux (order_status_origin_id, order_status_destination_id, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES(1,7,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_order_status_flux (order_status_origin_id, order_status_destination_id, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES(7,4,NOW(),NULL,NULL,1,NULL,NULL,1);

INSERT INTO tbl_order_status_flux (order_status_origin_id, order_status_destination_id, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES(7,2,NOW(),NULL,NULL,1,NULL,NULL,1);
