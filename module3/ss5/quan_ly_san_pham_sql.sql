CREATE SCHEMA view_index_store_procedure;
USE view_index_store_procedure;
-- Bước 2
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_code INT,
    product_name VARCHAR(50),
    product_price INT,
    product_amount INT,
    product_description VARCHAR(50),
    product_status VARCHAR(50)
);
INSERT INTO products VALUES (1, 1 , 'thuốc cảm', 5000 , 10 , 'trị bệnh cảm', 'bảo hành' ),(2, 2 , 'thuốc sốt', 10000 , 20 , 'giảm đau, hạ sốt', 'bảo hành' ),
(3, 3 , 'thuốc ho', 15000 , 25 , 'trị bệnh ho', 'bảo hành' ),(4, 4 , 'thuốc trĩ', 25000 , 15 , 'trị bệnh trĩ', 'bảo hành' );
SELECT 
    *
FROM
    products;
-- Bước 3
create index unique_index_products ON products(product_code);
create index composite_index_products ON products(product_name,product_price);
EXPLAIN SELECT * FROM products;
EXPLAIN SELECT * FROM products
WHERE id = 1;
-- Bước 4
CREATE VIEW view_products (codee , namess , price , statuss) AS
    SELECT 
        product_code, product_name, product_price, product_status
    FROM
        products;
UPDATE view_products 
SET 
    namess = 'Thuốc cảm cúm'
WHERE
    codee = 1;
DROP VIEW view_products;
-- Bước 5
delimiter //
CREATE PROCEDURE display_products()
BEGIN
SELECT * FROM products;
END;
// delimiter ;
CALL display_products;
delimiter //
CREATE PROCEDURE add_products(id INT, product_code INT, product_name VARCHAR(45), product_price INT, product_amount INT, product_description VARCHAR(45)
, product_status VARCHAR(45))
BEGIN
INSERT INTO products VALUES 
    (id , product_code, product_name, product_price, product_amount, product_description, product_status);
    END;
// delimiter ;
CALL add_products(5,5,'Thuốc tránh thai', 10000, 5 , 'tránh thai', 'bảo hành');	
delimiter // 
CREATE PROCEDURE edit_by_id(
	id INT, 
    product_code INT,
	product_name VARCHAR(45),
	product_price INT,
	product_amount INT,
	product_description VARCHAR(45),
	product_status VARCHAR(45))
BEGIN
	UPDATE products
    SET 
    products.product_code = product_code,
    products.product_name = product_name,
    products.product_price = product_price,
    products.product_amount= product_amount,
    products.product_description = product_description,
    products.product_status = product_status
    WHERE products.id = id;
END //
delimiter ;
CALL edit_by_id (1,1,'thuốc cảm cúm',10000,15,'giải cảm','bảo hành');

delimiter //
CREATE PROCEDURE delete_by_id (id INT) 
BEGIN
	DELETE FROM products
    WHERE products.id = id;
END //
delimiter ;
CALL delete_by_id(1);