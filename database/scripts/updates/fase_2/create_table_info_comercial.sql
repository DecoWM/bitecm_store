USE `bitel_ecommerce` ;

CREATE TABLE `tbl_plan_infocomercial` (
  `plan_infocomercial_id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` int(11) DEFAULT NULL,
  `plan_infocomercial_img_url` varchar(150) DEFAULT 'images/equipo.png',
  `plan_infocomercial_descripcion` varchar(150) DEFAULT NULL,
  `plan_infocomercial_informacion_adicional` varchar(150) DEFAULT NULL,
  `plan_infocomercial_flag_cantidad` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` datetime DEFAULT NULL,
  `updated_by` datetime DEFAULT NULL,
  `deleted_by` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`plan_infocomercial_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8