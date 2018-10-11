USE `bitel_ecommerce`;

CREATE TABLE `tbl_sentinel_check` (
  `sentinel_check_id` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`sentinel_check_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
