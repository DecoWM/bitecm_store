USE bitel_ecommerce;

ALTER TABLE tbl_order_item DROP FOREIGN KEY fk_tbl_order_item_tbl_order1;
ALTER TABLE tbl_order_status_history DROP FOREIGN KEY fk_tbl_order_status_history_tbl_order1;
ALTER TABLE tbl_order CHANGE order_id order_id INT(10) NOT NULL;
ALTER TABLE tbl_order_item ADD CONSTRAINT fk_tbl_order_item_tbl_order1 FOREIGN KEY (order_id) REFERENCES tbl_order(order_id);
ALTER TABLE tbl_order_status_history ADD CONSTRAINT fk_tbl_order_status_history_tbl_order1 FOREIGN KEY (order_id) REFERENCES tbl_order(order_id);
