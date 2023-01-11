create schema quan_li_ban_hang;
use quan_li_ban_hang;
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(45),
    customer_age VARCHAR(45)
);
CREATE TABLE `order` (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_total_price INT,
    CONSTRAINT fk_customer_order FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
);
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(45),
    product_price INT
);
CREATE TABLE order_detail (
    order_id INT,
    product_id INT,
    oder_detail_QTY INT,
    PRIMARY KEY (order_id , product_id),
    CONSTRAINT fk_oder_order_detail FOREIGN KEY (order_id)
        REFERENCES `order` (order_id),
    CONSTRAINT fk_product_order_detail FOREIGN KEY (product_id)
        REFERENCES product (product_id)
);