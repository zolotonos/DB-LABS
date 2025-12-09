
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