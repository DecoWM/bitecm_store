DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_orderCompletedReport`$$

CREATE PROCEDURE `PA_orderCompletedReport`(IN start_date DATE, IN end_date DATE)
BEGIN
    -- Prepara reporte de ventas (ordenes completadas)
    DECLARE nombre_estado VARCHAR(50);
    
    SELECT order_status_name INTO nombre_estado FROM tbl_order_status WHERE order_status_id = 5;
    
    SELECT `Nº Pedido`, `Sucursal`, `Distrito de Envio`, `Fecha Creacion`, `Nombre Cliente`, `Numero Documento`, `Tipo Linea`,
    `Servicio`, `Plan`, CASE `Equipo` WHEN 1 THEN 'SIN EQUIPO, SOLO PLAN' ELSE `Modelo` END AS 'Equipo', `Estado`, `Fecha Estado` AS `Fecha Completado`, `Total`
    FROM vw_order_report WHERE Estado = nombre_estado AND `Fecha Creacion` BETWEEN start_date AND end_date
    ORDER BY `Fecha Estado` DESC;
END$$

DELIMITER ;