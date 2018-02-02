USE `bitel_ecommerce`;

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
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (5,'img-slider-5','5. Quinto Banner','images//img-slider-5.png','https://www.facebook.com/','SLIDER',1);
INSERT INTO `tbl_image` (`image_id`,`image_name`,`image_description`,`image_url`,`image_link`,`image_type`,`active`) VALUES (6,'img-slider-6','6. Sexto Banner','images/img-slider-6.png',NULL,'SLIDER',0);
