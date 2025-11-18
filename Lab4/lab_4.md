## 1. Базова агрегація та групування
У цьому розділі наведено запити, що використовують функції `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, а також конструкції `GROUP BY` та `HAVING`.

### 1.1. Середня ціна товарів
**Опис:** Обчислює середню арифметичну ціну (`AVG`) всіх товарів, що є у таблиці `product`. Це допомагає оцінити загальну цінову політику магазину.

```sql
SELECT AVG(price) AS average_product_price
FROM product;
````

### 1.2. Загальна кількість товарів на складі

**Опис:** Використовує функцію `SUM` для підрахунку загальної кількості одиниць товару (`stock_quantity`) на складі.

```sql
SELECT SUM(stock_quantity) AS total_items_in_stock
FROM product;
```

### 1.3. Кількість товарів у кожній категорії

**Опис:** Запит групує товари за назвою категорії та використовує `COUNT(*)` для підрахунку асортименту в кожній групі.

```sql
SELECT c.name AS category_name, COUNT(*) AS product_count
FROM product p
JOIN category c ON p.category_id = c.category_id
GROUP BY c.name;
```

### 1.4. Діапазон цін по постачальниках

**Опис:** Для кожного постачальника визначається найнижча (`MIN`) та найвища (`MAX`) ціна товару, який він постачає. Це дозволяє зрозуміти ціновий розкид кожного партнера.

```sql
SELECT s.name AS supplier_name, 
       MIN(p.price) AS min_price, 
       MAX(p.price) AS max_price
FROM product p
JOIN supplier s ON p.supplier_id = s.supplier_id
GROUP BY s.name;
```

### 1.5. Фільтрація категорій (HAVING)

**Опис:** Запит групує товари по категоріях і обчислює середню ціну. Конструкція `HAVING` відфільтровує результати, залишаючи лише ті категорії, де середня ціна товару перевищує 50.

```sql
SELECT c.name AS category_name, AVG(p.price) AS avg_category_price
FROM product p
JOIN category c ON p.category_id = c.category_id
GROUP BY c.name
HAVING AVG(p.price) > 50;
```

-----

## 2\. Запити з об'єднанням таблиць (JOIN)

Демонстрація різних типів `JOIN` для отримання зведених даних з кількох таблиць.

### 2.1. Деталі замовлення (INNER JOIN)

**Опис:** Об'єднує таблиці `"order"` та `customer`, щоб показати дату замовлення, статус, суму та ім'я клієнта. `INNER JOIN` гарантує, що виводяться лише існуючі замовлення з прив'язаними клієнтами.

```sql
SELECT o.order_date, o.status, o.total_amount, c.first_name, c.last_name
FROM "order" o
INNER JOIN customer c ON o.customer_id = c.customer_id;
```

### 2.2. Всі клієнти та їх замовлення (LEFT JOIN)

**Опис:** Використовується `LEFT JOIN`, щоб вивести всіх клієнтів. Якщо клієнт робив замовлення, будуть показані дані про замовлення; якщо ні — у відповідних полях буде `NULL`. Це дозволяє побачити навіть тих користувачів, які ще нічого не купили.

```sql
SELECT c.first_name, c.last_name, o.order_id, o.total_amount
FROM customer c
LEFT JOIN "order" o ON c.customer_id = o.customer_id;
```

### 2.3. Категорії товарів (RIGHT JOIN)

**Опис:** Використовується `RIGHT JOIN` відносно таблиці `product` до `category`. Це гарантує, що в результуючому списку будуть перелічені всі категорії, навіть якщо до якоїсь категорії не прив'язано жодного товару (хоча в поточних даних всі категорії заповнені).

```sql
SELECT p.name AS product_name, c.name AS category_name
FROM product p
RIGHT JOIN category c ON p.category_id = c.category_id;
```

### 2.4. Повна інформація про чек (Багатотабличний JOIN)

**Опис:** Об'єднання трьох таблиць (`order_item`, `"order"`, `product`) для отримання детальної інформації про кожну позицію в чеку: дата, назва товару, кількість та ціна за одиницю.

```sql
SELECT o.order_date, p.name AS product_name, oi.quantity, oi.unit_price
FROM order_item oi
JOIN "order" o ON oi.order_id = o.order_id
JOIN product p ON oi.product_id = p.product_id;
```

-----

## 3\. Запити з підзапитами (Subqueries)

Використання вкладених запитів у різних частинах SQL-інструкції.

### 3.1. Товари дорожчі за середнє (WHERE Subquery)

**Опис:** Спочатку підзапит обчислює середню ціну всіх товарів, а потім основний запит вибирає товари, ціна яких вища за це значення.

```sql
SELECT name, price
FROM product
WHERE price > (SELECT AVG(price) FROM product);
```

### 3.2. Кількість замовлень для кожного клієнта (SELECT Subquery)

**Опис:** Підзапит виконується для кожного рядка таблиці `customer`, підраховуючи кількість записів у таблиці `"order"` для конкретного клієнта. Це альтернатива використанню `GROUP BY`.

```sql
SELECT first_name, last_name,
       (SELECT COUNT(*) FROM "order" o WHERE o.customer_id = c.customer_id) AS orders_count
FROM customer c;
```

### 3.3. Клієнти з великими замовленнями (IN Subquery)

**Опис:** Підзапит знаходить `customer_id` тих замовлень, де сума перевищує 500. Основний запит використовує цей список ID для виведення контактних даних відповідних клієнтів.

```sql
SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN (
    SELECT customer_id 
    FROM "order" 
    WHERE total_amount > 500
);