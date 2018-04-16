USE `bitel_ecommerce`;

-- Usar https://bcrypt-generator.com/ para generar las contraseñas
INSERT INTO `tbl_user` (`user_name`, `user_email`, `password`, `user_rol`) VALUES
-- password: admin
('Admin 1', 'admin1@prueba.pe', '$2y$10$SWJ4D0graYnmMJs4Yfnd/ub5XcK22D0wekZecPKsrbl2pG5Hx4nxm', 1),
-- password: editor
('Editor 1', 'editor1@prueba.pe', '$2y$10$PkguKN39jmoICXhPgZXqZO/nO/wHjROBla5VZkoouxwHLGmyw6Woe', 2),
-- password: operador
('Operador 1', 'operador1@prueba.pe', '$2y$10$nbXbilm1oaoftlZ6OzxiduGC62yQgba6vXUkNRbMeiHy6Zc0cMSRW', 3);

UPDATE tbl_user SET 
-- No es necesario actualizar todos los campos, puede ser solo 1
user_name = 'nuevo_nombre', 
user_email = 'nuevo_email', 
password = 'nuevo_password',
user_rol = 1|2|3,
-- para desactivar un usuario
active = 1|0
-- IMPORTANTE colocar el email actual del usuario a modificar
WHERE user_email = 'actual_email';
