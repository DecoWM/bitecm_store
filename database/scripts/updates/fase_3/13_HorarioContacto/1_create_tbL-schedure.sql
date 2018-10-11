USE `bitel_ecommerce`;

CREATE TABLE `tbl_schedule` (
  `idschedule_id` INT(11) NOT NULL AUTO_INCREMENT,
  `idschedule_name` VARCHAR(100) NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT NULL,
  `deleted_at` DATETIME DEFAULT NULL,
  `created_by` INT(11) DEFAULT '1',
  `updated_by` INT(11) DEFAULT NULL,
  `deleted_by` INT(11) DEFAULT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idschedule_id`)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8