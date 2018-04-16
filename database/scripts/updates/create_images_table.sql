USE `bitel_ecommerce`;

DROP TABLE `tbl_image`;

CREATE TABLE `tbl_image` (
  `image_id` int(11) NOT NULL AUTO_INCREMENT,
  `image_name` varchar(200) DEFAULT NULL,
  `image_description` varchar(200) DEFAULT NULL,
  `image_url` varchar(150) DEFAULT NULL,
  `image_link` varchar(150) DEFAULT NULL,
  `image_type` enum('SLIDER','HOME','BANNERS') DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  UNIQUE KEY `image_id_UNIQUE` (`image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (1,'img-slider-1','1. Banner Principal','images//img-slider-1.png','https://www.facebook.com/','SLIDER',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (2,'img-slider-2','2. Segundo Banner','images//img-slider-2.png','https://www.facebook.com/','SLIDER',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (3,'img-slider-3','3. Tercer Banner','images/img-slider-3.png',NULL,'SLIDER',0);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (4,'img-slider-4','4. Cuarto Banner','images/img-slider-4.png',NULL,'SLIDER',0);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (5,'img-slider-5','5. Quinto Banner','images//img-slider-5.png','Link Actualizado','SLIDER',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (6,'img-slider-6','6. Sexto Banner','images/img-slider-6.png',NULL,'SLIDER',0);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (7,'img-home-7','1. Imágen de Equipos','images//img-home-7.jpeg','https://www.facebook.com/','HOME',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (8,'img-home-8','2. Equipo Promocionado 1','images//img-home-8.jpeg','https://www.google.com/','HOME',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (9,'img-home-9','3. Equipo Promocionado 2','images//img-home-9.jpeg','https://www.facebook.com/','HOME',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (10,'img-banner-10','1. Banner Postpago','images//img-banner-10.jpeg','https://www.google.com/','BANNERS',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (11,'img-banner-11','2. Banner Prepago','images//img-banner-11.jpeg','https://www.facebook.com/','BANNERS',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (12,'img-banner-12','3. Banner Accesorios','images//img-banner-12.jpeg','https://www.facebook.com/','BANNERS',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (13,'img-banner-13','4. Banner Promociones','images//img-banner-13.jpeg','https://www.google.com/','BANNERS',1);
