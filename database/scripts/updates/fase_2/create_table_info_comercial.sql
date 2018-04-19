USE `bitel_ecommerce` ;

DROP TABLE IF EXISTS `tbl_plan_infocomercial`;

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
  PRIMARY KEY (`plan_infocomercial_id`),
  KEY `fk_tbl_plan_infocomercial_tbl_plan1_idx` (`plan_id`),
  CONSTRAINT `fk_tbl_plan_infocomercial_tbl_plan1` 
    FOREIGN KEY (`plan_id`) REFERENCES `tbl_plan` (`plan_id`) 
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8