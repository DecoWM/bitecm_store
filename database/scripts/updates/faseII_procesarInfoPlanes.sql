DELIMITER $$

USE `bitel_ecommerce`$$

DROP PROCEDURE IF EXISTS `PA_procesarInfoComercial`$$

CREATE PROCEDURE `PA_procesarInfoComercial`()
BEGIN
DECLARE done INT DEFAULT 0;
DECLARE _plan_id INT(11);
DECLARE _plan_data_cap VARCHAR(255);
DECLARE _plan_unlimited_calls INT(11);
DECLARE _plan_unlimited_rpb TINYINT(1);
DECLARE _plan_unlimited_sms INT(11);
DECLARE _plan_unlimited_whatsapp TINYINT(1);
DECLARE _plan_free_facebook TINYINT(1);

DECLARE _descripcion_calls VARCHAR(150);
DECLARE _descripcion_sms VARCHAR(150);
DECLARE _descripcion_internet VARCHAR(150);
DECLARE _descripcion_bitel VARCHAR(150);
DECLARE _descripcion_facebook VARCHAR(150);
DECLARE _descripcion_whatsapp VARCHAR(150);

DECLARE _img_plan_data_cap VARCHAR(150);
DECLARE _img_plan_unlimited_calls VARCHAR(150);
DECLARE _img_plan_unlimited_rpb VARCHAR(150);
DECLARE _img_plan_unlimited_sms VARCHAR(150);
DECLARE _img_plan_unlimited_whatsapp VARCHAR(150);
DECLARE _img_plan_free_facebook VARCHAR(150);

DECLARE cur1 CURSOR FOR SELECT plan_id, plan_data_cap, plan_unlimited_calls, plan_unlimited_rpb, plan_unlimited_sms, plan_unlimited_whatsapp, plan_free_facebook 
	FROM tbl_plan;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
OPEN cur1;
read_loop: LOOP
FETCH cur1 INTO _plan_id, _plan_data_cap, _plan_unlimited_calls, _plan_unlimited_rpb, _plan_unlimited_sms, _plan_unlimited_whatsapp, _plan_free_facebook;
	IF done = 1 THEN
            LEAVE read_loop;
        END IF;
	
	-- en el caso de llamadas
	SET _img_plan_unlimited_calls = '/images/llamadas.svg';
	IF (_plan_unlimited_calls = 1) THEN
		SET _descripcion_calls = 'Llamadas ilimitadas (**)';
	ELSE
		IF (_plan_unlimited_calls > 1) THEN
			SET _descripcion_calls = 'min de Llamadas';
		END IF;
	END IF;
	
	-- en el caso de SMS
	SET _img_plan_unlimited_sms = '/images/sms.svg';
	IF (_plan_unlimited_sms = 1) THEN
		SET _descripcion_sms = 'SMS ilimitado (**)';
	ELSE
		IF (_plan_unlimited_sms > 1) THEN
			SET _descripcion_sms = 'SMS todo operador';
		END IF;
	END IF;
	
	-- internet
	SET _img_plan_data_cap = '/images/internet.svg';
	IF (_plan_data_cap != "") THEN
		SET _descripcion_internet = _plan_data_cap;
	ELSE
		SET _descripcion_internet = '';
	END IF;
	
	-- Llamadas todo Bitel
	SET _img_plan_unlimited_rpb = '/images/rpb.svg';
	IF (_plan_unlimited_rpb = 1) THEN
		SET _descripcion_bitel = 'Llamada todo Bitel Gratis';
	ELSE
		SET _descripcion_bitel = 'Llamada todo Bitel Gratis';
	END IF;
	
	-- Facebook
	SET _img_plan_free_facebook = '/images/facebook.svg';
	IF (_plan_free_facebook = 1) THEN
		SET _descripcion_facebook = 'Facebook Flex Gratis';
	ELSE
		SET _descripcion_facebook = 'Facebook Flex Gratis';
	END IF;
	
	-- Whatsapp
	SET _img_plan_unlimited_whatsapp = '/images/whatsapp.svg';
	IF (_plan_unlimited_whatsapp = 1) THEN
		SET _descripcion_whatsapp = 'WhatsApp Ilimitado';
	ELSE
		SET _descripcion_whatsapp = 'WhatsApp Ilimitado';
	END IF;
	
	-- en el caso de llamadas
	INSERT INTO tbl_plan_infocomercial (plan_id, plan_infocomercial_img_url, plan_infocomercial_descripcion, plan_infocomercial_informacion_adicional, plan_infocomercial_flag_cantidad, created_at, active)
	VALUES(_plan_id, _img_plan_unlimited_calls, _descripcion_calls, _descripcion_calls, _plan_unlimited_calls, NOW(), 1);

	-- en el caso de SMS
	INSERT INTO tbl_plan_infocomercial (plan_id, plan_infocomercial_img_url, plan_infocomercial_descripcion, plan_infocomercial_informacion_adicional, plan_infocomercial_flag_cantidad, created_at, active)
	VALUES(_plan_id, _img_plan_unlimited_sms, _descripcion_sms, _descripcion_sms, _img_plan_unlimited_sms, NOW(), 1);
	
	-- internet
	INSERT INTO tbl_plan_infocomercial (plan_id, plan_infocomercial_img_url, plan_infocomercial_descripcion, plan_infocomercial_informacion_adicional, plan_infocomercial_flag_cantidad, created_at, active)
	VALUES(_plan_id, _img_plan_data_cap, _descripcion_internet, _descripcion_internet, 1, NOW(), 1);
	
	-- Llamadas todo Bitel
	INSERT INTO tbl_plan_infocomercial (plan_id, plan_infocomercial_img_url, plan_infocomercial_descripcion, plan_infocomercial_informacion_adicional, plan_infocomercial_flag_cantidad, created_at, active)
	VALUES(_plan_id, _img_plan_unlimited_rpb, _descripcion_bitel, _descripcion_bitel, _plan_unlimited_rpb, NOW(), 1);
	
	-- Facebook
	INSERT INTO tbl_plan_infocomercial (plan_id, plan_infocomercial_img_url, plan_infocomercial_descripcion, plan_infocomercial_informacion_adicional, plan_infocomercial_flag_cantidad, created_at, active)
	VALUES(_plan_id, _img_plan_free_facebook, _descripcion_facebook, _descripcion_facebook, _plan_free_facebook, NOW(), 1);
	
	-- Whatsapp
	INSERT INTO tbl_plan_infocomercial (plan_id, plan_infocomercial_img_url, plan_infocomercial_descripcion, plan_infocomercial_informacion_adicional, plan_infocomercial_flag_cantidad, created_at, active)
	VALUES(_plan_id, _img_plan_unlimited_whatsapp, _descripcion_whatsapp, _descripcion_whatsapp, _plan_unlimited_whatsapp, NOW(), 1);
	
END LOOP;
CLOSE cur1;
	END$$

DELIMITER ;