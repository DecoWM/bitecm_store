use `bitel_ecommerce`;

alter table tbl_image add column imagem_url varchar(150) default null after image_url;

update tbl_image set imagem_url = image_url;