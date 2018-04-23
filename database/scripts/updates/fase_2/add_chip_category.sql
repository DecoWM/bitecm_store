USE `bitel_ecommerce`;

-- insertar la categoria del producto chip
INSERT INTO tbl_category (category_name, category_slug, allow_variation, weight, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, active)
VALUES ('Chips', 'chips', 1, 1, NOW(), NULL, NULL, 1, NULL, NULL, 1);