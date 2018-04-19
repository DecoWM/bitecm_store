use `bitel_ecommerce`;

delete from tbl_order_item;
alter table tbl_order_item auto_increment=1;

delete from tbl_order_status_history;
alter table tbl_order_status_history auto_increment=1;

delete from tbl_order;

-- Selected orders
-- delete from tbl_order_item where order_id in (8,10,12);
-- alter table tbl_order_item auto_increment=1;

-- delete from tbl_order_status_history where order_id in (8,10,12);
-- alter table tbl_order_status_history auto_increment=1;

-- delete from tbl_order where order_id in (8,10,12);