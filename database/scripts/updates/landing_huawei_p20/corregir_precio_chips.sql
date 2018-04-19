USE bitel_ecommerce;

UPDATE tbl_product_variation A JOIN tbl_product B ON A.product_id = B.product_id 
JOIN tbl_category C ON B.category_id = C.category_id 
SET A.product_variation_price = 5.00 WHERE C.category_id = 4;