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
CREATE INDEX unique_index_products ON products(product_code);
CREATE INDEX composite_index_products ON products(product_name,product_price);
EXPLAIN SELECT * FROM products;
EXPLAIN SELECT * FROM products
WHERE id = 1;
-- Bước 4
CREATE VIEW view_products AS
    SELECT 
        product_code, product_name, product_price, product_status
    FROM
        products;
        
SELECT 
    *
FROM
    view_products;
UPDATE view_products 
SET 
    product_price = 15000
WHERE
    product_id = 3;
DROP VIEW view_products;
-- Bước 5
delimiter // 
CREATE PROCEDURE list_product()
BEGIN
SELECT * FROM products;
END 
// delimiter ;
CALL list_product;


delimiter // 
CREATE PROCEDURE add_product(
	IN p_id int, 
   IN p_product_code INT,
   IN p_product_name VARCHAR(50),
   IN p_product_price INT,
   IN p_product_amount INT,
   IN p_product_description VARCHAR(50),
   IN p_product_status VARCHAR(50)
)
BEGIN
INSERT INTO products (product_code, product_name, product_price, product_amount, product_description, product_status) VALUES  
(p_product_code, p_product_name, p_product_price, p_product_amount, p_product_description, p_product_status);
END
// delimiter ;
CALL edit_by_id (1,1,'thuốc cảm cúm',10000,15,'giải cảm','bảo hành');

delimiter // 
CREATE PROCEDURE edit_product(
	IN p_id INT,
	IN p_product_code INT,
   IN p_product_name VARCHAR(50),
   IN p_product_price INT,
   IN p_product_amount INT,
   IN p_product_description VARCHAR(50),
   IN p_product_status VARCHAR(50)
)
BEGIN
UPDATE products
SET 
products.product_code = p_product_code,
products.product_name = p_product_name,
products.product_price = p_product_price,
products.product_amount = p_product_amount,
products.product_description = p_product_description,
products.product_status = p_product_status
WHERE 
products.id = p_id;
END
// delimiter ;

delimiter // 
CREATE PROCEDURE delete_product(IN p_id INT) 
BEGIN
DELETE FROM products
WHERE products.id = p_id;
END
// delimiter ;
CALL delete_product(1);
