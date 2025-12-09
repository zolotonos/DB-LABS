lab5.md
# lab5.md

## 1. Аналіз початкової схеми
На основі ER-діаграми (див. файл `Crow foot.jpg`) було проаналізовано структуру бази даних.
Початкова схема перебуває в **2NF** (Другій нормальній формі), оскільки використовує сурогатні ключі (UUID), що усуває часткові залежності. Однак, вона не відповідає **3NF** через наявність транзитивних залежностей.

### Виявлені проблеми (Порушення 3NF):

1.  **Таблиця `ADDRESS`**:
    * **ФЗ:** `address_id` -> `postal_code` -> `city`, `country`.
    * **Пояснення:** Атрибути `city` та `country` фактично залежать від `postal_code`, а не тільки від первинного ключа. Це транзитивна залежність.
    * **Рішення:** Винести адресу в окремий довідник `city_directory`.

2.  **Таблиця `PAYMENT`**:
    * **ФЗ:** `payment_id` -> `method`.
    * **Пояснення:** Поле `method` містить текстові значення, що дублюються. Це не є суворим порушенням 3NF, але створює аномалії оновлення (Update Anomaly).
    * **Рішення:** Створити таблицю `payment_method` і замінити текстове поле на Foreign Key.

3.  **Таблиця `ORDER`**:
    * **Пояснення:** Поле `total_amount` є похідним (обчислюваним) від суми записів в `ORDER_ITEM`. Зберігання обчислюваних даних порушує принципи нормалізації (надлишковість).
    * **Рішення:** Видалити стовпець `total_amount`.

---

## 2. Кроки нормалізації (SQL реалізація)

Ми виконали поетапну нормалізацію схеми для усунення транзитивних залежностей та надлишковості.

### Крок 1: Нормалізація `PAYMENT`
**Проблема:** Поле `method` містило текстові значення, що дублювалися.
**Рішення:** Було створено таблицю-довідник `payment_method`. Дані з існуючої таблиці були мігровані в нову, після чого текстове поле було замінено на зовнішній ключ (UUID).

```sql
-- 1. Створення довідника
CREATE TABLE payment_method (
    method_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    method_name VARCHAR(50) UNIQUE NOT NULL
);

-- 2. Міграція існуючих методів
INSERT INTO payment_method (method_name)
SELECT DISTINCT method FROM payment;

-- 3. Додавання зовнішнього ключа
ALTER TABLE payment ADD COLUMN method_id UUID;

-- 4. Оновлення даних (проставлення посилань)
UPDATE payment
SET method_id = pm.method_id
FROM payment_method pm
WHERE payment.method = pm.method_name;

-- 5. Встановлення обмежень та видалення старої колонки
ALTER TABLE payment 
    ALTER COLUMN method_id SET NOT NULL,
    ADD CONSTRAINT fk_payment_method FOREIGN KEY (method_id) REFERENCES payment_method(method_id);

ALTER TABLE payment DROP COLUMN method;

```

### Крок 2: Нормалізація `ADDRESS`
**Проблема:** Виявлено транзитивну залежність postal_code → city, country.
**Рішення:** Створено таблицю `city_directory`. Поштовий індекс став первинним ключем для визначення міста та країни, що усунуло дублювання географічних назв.

Крок 2: Нормалізація ADDRESS
Проблема: Виявлено транзитивну залежність postal_code → city, country. Рішення: Створено таблицю city_directory. Поштовий індекс став первинним ключем для визначення міста та країни, що усунуло дублювання географічних назв.

```sql
-- 1. Створення довідника міст
CREATE TABLE city_directory (
    postal_code VARCHAR(20) PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

-- 2. Наповнення довідника унікальними даними з адрес
INSERT INTO city_directory (postal_code, city, country)
SELECT DISTINCT postal_code, city, country FROM address
ON CONFLICT (postal_code) DO NOTHING;

-- 3. Створення зв'язку (Foreign Key)
ALTER TABLE address 
    ADD CONSTRAINT fk_address_city 
    FOREIGN KEY (postal_code) REFERENCES city_directory(postal_code);

-- 4. Видалення надлишкових стовпців
ALTER TABLE address DROP COLUMN city;
ALTER TABLE address DROP COLUMN country;

```

### Повне рішення sql скриптом
```sql
-- 1. ВИПРАВЛЕННЯ PAYMENT 
CREATE TABLE payment_method (
    method_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    method_name VARCHAR(50) UNIQUE NOT NULL
);

-- Заповнюємо довідник  значеннями  які вже є в базі
INSERT INTO payment_method (method_name)
SELECT DISTINCT method FROM payment;

-- Додаємо колонку для зовнішнього ключа
ALTER TABLE payment ADD COLUMN method_id UUID;

-- Оновлюємо таблицю payment, проставляючи ID замість тексту
UPDATE payment
SET method_id = pm.method_id
FROM payment_method pm
WHERE payment.method = pm.method_name;

-- колонкa тепер обов'язкова та ставимо зв'язок
ALTER TABLE payment 
    ALTER COLUMN method_id SET NOT NULL,
    ADD CONSTRAINT fk_payment_method FOREIGN KEY (method_id) REFERENCES payment_method(method_id);

ALTER TABLE payment DROP COLUMN method;


-- 2. ВИПРАВЛЕННЯ ADDRESS (Виносимо міста/індекси)
-- довідник міст
CREATE TABLE city_directory (
    postal_code VARCHAR(20) PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

-- Заповнюємо довідник з існуючих адрес
INSERT INTO city_directory (postal_code, city, country)
SELECT DISTINCT postal_code, city, country FROM address
ON CONFLICT (postal_code) DO NOTHING;

-- Додаємо зовнішній ключ   postal_code 
ALTER TABLE address 
    ADD CONSTRAINT fk_address_city 
    FOREIGN KEY (postal_code) REFERENCES city_directory(postal_code);

-- Видаляємо надлишкові колонки (city та country тепер підтягуються через postal_code)
ALTER TABLE address DROP COLUMN city;
ALTER TABLE address DROP COLUMN country;


-- 3. ВИПРАВЛЕННЯ ORDER идаляємо обчислюване поле
ALTER TABLE "order" DROP COLUMN total_amount;

-- Перевірка результату
SELECT * FROM payment_method;
SELECT * FROM city_directory;
```

### Висновки 

У результаті виконання лабораторної роботи було проведено аналіз та рефакторинг схеми бази даних інтернет-магазину. Початкова схема, що базувалася на сурогатних ключах (`UUID`), задовольняла вимогам Другої нормальної форми (2NF), проте містила транзитивні залежності та надлишковість, що порушувало вимоги Третьої нормальної форми (3NF).

**Основні результати роботи:**

1.  **Досягнуто 3NF:** Шляхом декомпозиції таблиць було усунено транзитивні функціональні залежності. Зокрема, залежність `postal_code` → `city`, `country` була винесена в окрему сутність `city_directory`. Це дозволило уникнути аномалій оновлення (Update Anomalies) та дублювання текстової інформації.
2.  **Стандартизація даних:** Виділення методів оплати в окрему таблицю-довідник (`payment_method`) забезпечило посилальну цілісність даних та захист від помилок введення.
3.  **Усунення надлишковості:** Видалення обчислюваного поля `total_amount` з таблиці замовлень оптимізувало структуру зберігання даних, переклавши відповідальність за розрахунок підсумків на рівень запитів (Views) або логіку застосунку.

Розроблена нормалізована схема є більш стійкою до змін, забезпечує вищу цілісність даних та відповідає стандартам проектування реляційних баз даних.