-- ЧАСТИНА 1: АГРЕГАЦІЯ 

-- 1. Базова агрегація Середня ціна всіх товарів у магазині (AVG)
SELECT AVG(price) AS average_product_price
FROM product;

-- 2. Базова агрегація Загальна кількість товарів на складі (SUM)
SELECT SUM(stock_quantity) AS total_items_in_stock
FROM product;

-- 3. Групування Кількість товарів у кожній категорії (COUNT + GROUP BY)
SELECT c.name AS category_name, COUNT(*) AS product_count
FROM product p
JOIN category c ON p.category_id = c.category_id
GROUP BY c.name;

-- 4. Групування + Min/Max. Найдешевший та найдорожчий товар для кожного постачальника
SELECT s.name AS supplier_name, 
       MIN(p.price) AS min_price, 
       MAX(p.price) AS max_price
FROM product p
JOIN supplier s ON p.supplier_id = s.supplier_id
GROUP BY s.name;

-- 5. Фільтрація груп (HAVING) Показати категорії, де середня ціна товарів перевищує 50
SELECT c.name AS category_name, AVG(p.price) AS avg_category_price
FROM product p
JOIN category c ON p.category_id = c.category_id
GROUP BY c.name
HAVING AVG(p.price) > 50;

-- ЧАСТИНА 2 JOIN ЗАПИТИ 

-- 6. INNER JOIN Отримання повної інформації про замовлення 
SELECT o.order_date, o.status, o.total_amount, c.first_name, c.last_name
FROM "order" o
INNER JOIN customer c ON o.customer_id = c.customer_id;

-- 7. LEFT JOIN Список усіх клієнтів та їхніх замовлень
-- Якщо клієнт нічого не замовляв, він все одно буде в списку
SELECT c.first_name, c.last_name, o.order_id, o.total_amount
FROM customer c
LEFT JOIN "order" o ON c.customer_id = o.customer_id;

-- 8. RIGHT JOIN Перевірка категорій
-- Показує всі категорії, навіть якщо в них немає товарів
SELECT p.name AS product_name, c.name AS category_name
FROM product p
RIGHT JOIN category c ON p.category_id = c.category_id;

-- 9. Багатотаблична агрегація Сума продажів по кожній категорії
-- Об'єднує Category, Product та Order_item, щоб порахувати виручку
SELECT c.name AS category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM category c
JOIN product p ON c.category_id = p.category_id
JOIN order_item oi ON p.product_id = oi.product_id
GROUP BY c.name
ORDER BY total_sales DESC;


-- ЧАСТИНА 3: ПІДЗАПИТИ (SUBQUERIES)

-- 10 Підзапит у WHERE Знайти товари, які дорожчі за середню ціну всіх товарів
SELECT name, price
FROM product
WHERE price > (SELECT AVG(price) FROM product);

-- 11 Підзапит у SELECT Вивести список клієнтів з кількістю їхніх замовлень
SELECT first_name, last_name,
       (SELECT COUNT(*) FROM "order" o WHERE o.customer_id = c.customer_id) AS orders_count
FROM customer c;

-- 12 Підзапит з IN Знайти клієнтів, які зробили замовлення на суму більше 500
SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN (
    SELECT customer_id 
    FROM "order" 
    WHERE total_amount > 500
);