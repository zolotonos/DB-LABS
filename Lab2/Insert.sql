-- CATEGORY
INSERT INTO category (category_id, name, description) VALUES
(gen_random_uuid(), 'Electronics', 'Devices and gadgets'),
(gen_random_uuid(), 'Books', 'Printed and digital reading materials'),
(gen_random_uuid(), 'Clothing', 'Men and women apparel');

-- SUPPLIER
INSERT INTO supplier (supplier_id, name, contact_email) VALUES
(gen_random_uuid(), 'TechCorp', 'sales@techcorp.com'),
(gen_random_uuid(), 'BookWorld', 'contact@bookworld.com'),
(gen_random_uuid(), 'FashionPro', 'support@fashionpro.com');

-- CUSTOMER
INSERT INTO customer (customer_id, first_name, last_name, email, phone) VALUES
(gen_random_uuid(), 'Alice', 'Johnson', 'alice.johnson@example.com', '+1234567890'),
(gen_random_uuid(), 'Bob', 'Smith', 'bob.smith@example.com', '+0987654321'),
(gen_random_uuid(), 'Carol', 'Miller', 'carol.miller@example.com', '+1122334455');

-- ADDRESS
INSERT INTO address (address_id, street, city, postal_code, country, customer_id)
SELECT gen_random_uuid(), '123 Main St', 'New York', '10001', 'USA', customer_id
FROM customer WHERE first_name = 'Alice'
UNION ALL
SELECT gen_random_uuid(), '45 Park Ave', 'Los Angeles', '90001', 'USA', customer_id
FROM customer WHERE first_name = 'Bob'
UNION ALL
SELECT gen_random_uuid(), '9 Baker St', 'London', 'NW1 6XE', 'UK', customer_id
FROM customer WHERE first_name = 'Carol';

-- PRODUCT
INSERT INTO product (product_id, name, description, price, stock_quantity, category_id, supplier_id)
SELECT gen_random_uuid(), 'Smartphone X', 'Latest generation smartphone', 799.99, 50, c.category_id, s.supplier_id
FROM category c, supplier s WHERE c.name = 'Electronics' AND s.name = 'TechCorp'
UNION ALL
SELECT gen_random_uuid(), 'Novel: The Lost City', 'Adventure fiction book', 19.99, 200, c.category_id, s.supplier_id
FROM category c, supplier s WHERE c.name = 'Books' AND s.name = 'BookWorld'
UNION ALL
SELECT gen_random_uuid(), 'Leather Jacket', 'Genuine leather jacket', 249.50, 30, c.category_id, s.supplier_id
FROM category c, supplier s WHERE c.name = 'Clothing' AND s.name = 'FashionPro';

-- ORDER
INSERT INTO "order" (order_id, order_date, status, total_amount, customer_id, address_id)
SELECT gen_random_uuid(), NOW(), 'Pending', 819.98, c.customer_id, a.address_id
FROM customer c
JOIN address a ON a.customer_id = c.customer_id
WHERE c.first_name = 'Alice'
UNION ALL
SELECT gen_random_uuid(), NOW(), 'Completed', 19.99, c.customer_id, a.address_id
FROM customer c
JOIN address a ON a.customer_id = c.customer_id
WHERE c.first_name = 'Bob';

-- ORDER_ITEM
INSERT INTO order_item (order_item_id, quantity, unit_price, order_id, product_id)
SELECT gen_random_uuid(), 1, 799.99, o.order_id, p.product_id
FROM "order" o, product p
WHERE p.name = 'Smartphone X' AND o.status = 'Pending'
UNION ALL
SELECT gen_random_uuid(), 1, 19.99, o.order_id, p.product_id
FROM "order" o, product p
WHERE p.name = 'Novel: The Lost City' AND o.status = 'Completed';

-- PAYMENT
INSERT INTO payment (payment_id, amount, method, paid_at, order_id)
SELECT gen_random_uuid(), 19.99, 'Credit Card', NOW(), o.order_id
FROM "order" o WHERE o.status = 'Completed';
