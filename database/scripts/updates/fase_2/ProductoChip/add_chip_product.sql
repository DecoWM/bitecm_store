USE `bitel_ecommerce`;

-- insertar producto chip
INSERT INTO `tbl_product`(`product_id`,`category_id`,`brand_id`,`product_model`,`product_image_url`,`product_keywords`,`product_price`,`product_description`,`product_general_specifications`,`product_data_sheet`,`product_external_memory`,`product_internal_memory`,`product_screen_size`,`product_camera_1`,`product_camera_2`,`product_camera_3`,`product_camera_4`,`product_processor_name`,`product_processor_power`,`product_processor_cores`,`product_band`,`product_radio`,`product_wlan`,`product_bluetooth`,`product_os`,`product_gps`,`product_battery`,`product_slug`,`product_tag`,`product_priority`,`created_at`,`updated_at`,`deleted_at`,`publish_at`,`created_by`,`updated_by`,`deleted_by`,`publish_by`,`active`) values 
(NULL,4,8,'iChip','productos/chipbitel.jpg',NULL,1.00,NULL,NULL,'data_sheets/Ficha_tecnica_SAMSUNG_GALAXY_J7 PRIME.pdf','128','4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chip-bitel',NULL,1,'2018-04-04 15:08:01',NULL,NULL,'2018-04-04 15:08:01',1,NULL,NULL,1,1);