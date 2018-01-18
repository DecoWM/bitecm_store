ALTER TABLE tbl_plan MODIFY plan_unlimited_calls INT(11) NOT NULL DEFAULT '1';
ALTER TABLE tbl_plan MODIFY plan_unlimited_sms INT(11) NOT NULL DEFAULT '1';
ALTER TABLE tbl_plan MODIFY plan_data_cap VARCHAR(255) NOT NULL;

UPDATE tbl_plan SET plan_unlimited_calls = 70, plan_unlimited_sms = 50, plan_data_cap = 'Internet 1.5 GB + Internet Ilimitado (*)<br/>1.5 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 1;
UPDATE tbl_plan SET plan_name = 'Voz Max 29.90', plan_unlimited_calls = 200, plan_unlimited_sms = 50, plan_data_cap = 'Internet 1.5 GB<br/>1.5 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 2;
UPDATE tbl_plan SET plan_name = 'iChip Voz 29.90', plan_unlimited_calls = 70, plan_unlimited_sms = 50, plan_data_cap = 'Internet 1.5 GB + Internet Ilimitado (*)<br/>1.5 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 3;
UPDATE tbl_plan SET plan_unlimited_calls = 400, plan_unlimited_sms = 100, plan_data_cap = 'Internet 3 GB + Internet Ilimitado (*)<br/>3 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 4;
UPDATE tbl_plan SET plan_data_cap = 'Internet 5 GB + Internet Ilimitado (*)<br/>5 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 5;
UPDATE tbl_plan SET plan_data_cap = 'Internet 10 GB + Internet Ilimitado (*)<br/>10 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 7;
UPDATE tbl_plan SET plan_data_cap = 'Internet 20 GB + Internet Ilimitado (*)<br/>20 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 8;
UPDATE tbl_plan SET plan_data_cap = 'Internet 40 GB + Internet Ilimitado (*)<br/>40 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 9;
UPDATE tbl_plan SET plan_data_cap = 'Internet 45 GB + Internet Ilimitado (*)<br/>45 GB de Bono de 4G', plan_unlimited_rpb = 0 WHERE plan_id = 10;
UPDATE tbl_plan SET plan_unlimited_calls = 0, plan_unlimited_sms = 0, plan_data_cap = 'Internet 2 GB', plan_unlimited_rpb = 0 WHERE plan_id = 11;
UPDATE tbl_plan SET plan_unlimited_calls = 0, plan_unlimited_sms = 0, plan_data_cap = 'Internet 5 GB' WHERE plan_id = 12;
UPDATE tbl_plan SET plan_unlimited_calls = 0, plan_unlimited_sms = 0, plan_data_cap = 'Internet 10 GB' WHERE plan_id = 13;
