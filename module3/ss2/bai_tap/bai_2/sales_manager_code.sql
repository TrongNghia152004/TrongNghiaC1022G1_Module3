CREATE SCHEMA quan_li_ban_hang;
USE quan_li_ban_hang;
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(45),
    customer_age VARCHAR(45)
);
insert into customer values (1,'Minh Quan', 10),(2,'Ngoc Oanh', 20),(3,'Hong Ha', 50);
CREATE TABLE `order` (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_total_price INT,
    CONSTRAINT fk_customer_order FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
);
insert into `order` (order_id, customer_id , order_date, order_total_price) values (1,1,'2006/3/21', null),(2,2,'2006/3/23', null),(3,3,'2006/3/16/', null);
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(45),
    product_price INT
);
insert into product (product_id,product_name, product_price) values (1,'May Giat', 3),(2,'Tu Lanh', 5),(3,'Dieu Hoa', 7),(4,'Quat', 1),(5,'Bep Dien', 2);
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
insert into order_detail (order_id, product_id, oder_detail_QTY) values (1, 1, 3),(1, 3, 7),(1, 4, 2),(2, 1, 1),(3, 1, 8),(2, 5, 4),(2, 3, 3);