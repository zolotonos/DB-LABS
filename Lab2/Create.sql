-- Таблиця: CUSTOMER
CREATE TABLE customer (
    customer_id UUID PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50)
);

-- Таблиця: ADDRESS
CREATE TABLE address (
    address_id UUID PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    customer_id UUID REFERENCES customer(customer_id)
);

-- Таблиця: CATEGORY
CREATE TABLE category (
    category_id UUID PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

-- Таблиця: SUPPLIER
CREATE TABLE supplier (
    supplier_id UUID PRIMARY KEY,
    name VARCHAR(150),
    contact_email VARCHAR(255)
);

-- Таблиця: PRODUCT
CREATE TABLE product (
    product_id UUID PRIMARY KEY,
    name VARCHAR(150),
    description TEXT,
    price DECIMAL(10,2),
    stock_quantity INT,
    category_id UUID REFERENCES category(category_id),
    supplier_id UUID REFERENCES supplier(supplier_id)
);

-- Таблиця: "ORDER"
CREATE TABLE "order" (
    order_id UUID PRIMARY KEY,
    order_date TIMESTAMP,
    status VARCHAR(50),
    total_amount DECIMAL(10,2),
    customer_id UUID REFERENCES customer(customer_id),
    address_id UUID REFERENCES address(address_id)
);

-- Таблиця: ORDER_ITEM
CREATE TABLE order_item (
    order_item_id UUID PRIMARY KEY,
    quantity INT,
    unit_price DECIMAL(10,2),
    order_id UUID REFERENCES "order"(order_id),
    product_id UUID REFERENCES product(product_id)
);

-- Таблиця: PAYMENT
CREATE TABLE payment (
    payment_id UUID PRIMARY KEY,
    amount DECIMAL(10,2),
    method VARCHAR(50),
    paid_at TIMESTAMP,
    order_id UUID REFERENCES "order"(order_id)
);
