DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_orderReport`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_orderReport`(IN start_date DATE, IN end_date DATE)
BEGIN
     -- Prepara reporte de ordenes
    SELECT `Nº Pedido`, `Sucursal`, `Distrito de Envio`, `Fecha Creacion`, `Nombre Cliente`, `Numero Documento`, `Tipo Linea`,
    `Porting Status`, `Servicio`, `Plan`, CASE `Equipo` WHEN 1 THEN 'SIN EQUIPO, SOLO PLAN' ELSE `Modelo` END AS 'Equipo', `Estado`, `Total`, `Evaluacion`
    FROM vw_order_report WHERE  `Fecha Creacion` BETWEEN start_date AND end_date
    ORDER BY `Fecha Creacion` DESC;
END$$

DELIMITER ;