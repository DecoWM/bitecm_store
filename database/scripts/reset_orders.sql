use `bitel_ecommerce`;

delete from tbl_order_item;
alter table tbl_order_item auto_increment=1;

delete from tbl_order_status_history;
alter table tbl_order_status_history auto_increment=1;

delete from tbl_order;