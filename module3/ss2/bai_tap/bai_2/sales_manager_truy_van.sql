use quan_li_ban_hang;
-- Hiển thị các thông tin  gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order
SELECT 
    order_id, order_date, order_total_price
FROM
    `order`;
-- Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách 
SELECT 
    customer_name AS 'khách hàng',
    product_name AS 'sản phẩm'
FROM
    order_detail
        INNER JOIN
    `order` ON order_detail.order_id = `order`.order_id
        INNER JOIN
    product ON order_detail.product_id = product.product_id
        INNER JOIN
    customer ON customer.customer_id = `order`.customer_id;
-- Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào 
SELECT 
    customer.customer_name
FROM
    customer
        LEFT JOIN
    `order` ON customer.customer_id = `order`.customer_id
WHERE
    `order`.customer_id IS NULL;
-- Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice)
SELECT 
    `order`.order_id,
    `order`.order_date,
    order_detail.order_quantity * product.product_price AS order_total_price
FROM
    order_detail
        INNER JOIN
    `order` ON order_detail.order_id = `order`.order_id
        INNER JOIN
    product ON order_detail.product_id = product.product_id;