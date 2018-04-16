-- ------------------------------------------
-- ------------------------------------------
-- VIEWS
-- ------------------------------------------
-- ------------------------------------------
USE `bitel_ecommerce` ;

CREATE OR REPLACE 
VIEW `vw_order_report` AS
    SELECT 
        `ord`.`order_id` AS `Nº Pedido`,
        `bch`.`branch_name` AS `Sucursal`,
        `dst`.`district_name` AS `Distrito de Envio`,
        `ord`.`created_at` AS `Fecha Creacion`,
        CONCAT(`ord`.`first_name`,
                ' ',
                `ord`.`last_name`) AS `Nombre Cliente`,
        `ord`.`id_number` AS `Numero Documento`,
        `ord`.`affiliation_type` AS `Tipo Linea`,
        `ord`.`porting_status_desc` AS `Porting Status`,
        `ord`.`service_type` AS `Servicio`,
        `pln`.`plan_name` AS `Plan`,
        (SELECT 
                `ors`.`order_status_name`
            FROM
                (`tbl_order_status_history` `osh`
                JOIN `tbl_order_status` `ors` ON ((`osh`.`order_status_id` = `ors`.`order_status_id`)))
            WHERE
                (`osh`.`order_id` = `ord`.`order_id`)
            ORDER BY `osh`.`created_at` DESC
            LIMIT 1) AS `Estado`,
        (SELECT 
                `osh`.`created_at`
            FROM
                (`tbl_order_status_history` `osh`
                JOIN `tbl_order_status` `ors` ON ((`osh`.`order_status_id` = `ors`.`order_status_id`)))
            WHERE
                (`osh`.`order_id` = `ord`.`order_id`)
            ORDER BY `osh`.`created_at` DESC
            LIMIT 1) AS `Fecha Estado`,
        `ord`.`total_igv` AS `Total`,
        `ord`.`credit_status` AS `Evaluacion`
    FROM
        (((`tbl_order` `ord`
        JOIN `tbl_branch` `bch` ON ((`ord`.`branch_id` = `bch`.`branch_id`)))
        JOIN `tbl_district` `dst` ON ((`ord`.`delivery_district` = `dst`.`district_id`)))
        JOIN (`tbl_order_item` `itm`
        LEFT JOIN (`tbl_product_variation` `var`
        JOIN `tbl_plan` `pln` ON ((`var`.`plan_id` = `pln`.`plan_id`))) ON ((`itm`.`product_variation_id` = `var`.`product_variation_id`))) ON ((`ord`.`order_id` = `itm`.`order_id`)))
    WHERE
        ((`ord`.`service_type` = 'Accesorios')
            OR ((`ord`.`service_type` <> 'Accesorios')
            AND (`pln`.`plan_name` IS NOT NULL)));
