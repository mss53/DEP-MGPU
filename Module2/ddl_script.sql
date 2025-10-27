-- Удаляем таблицы, если они уже существуют
DROP TABLE IF EXISTS returns CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS people CASCADE;

-- Таблица: people
CREATE TABLE people (
    region VARCHAR(50) PRIMARY KEY,
    person VARCHAR(100) NOT NULL
);

COMMENT ON TABLE people IS 'Список сотрудников, закреплённых за регионами';
COMMENT ON COLUMN people.region IS 'Название региона (уникальный ключ)';
COMMENT ON COLUMN people.person IS 'Имя сотрудника, ответственного за регион';

-- Таблица: orders
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(5,2),
    profit NUMERIC(10,2),
    CONSTRAINT fk_orders_region FOREIGN KEY (region)
        REFERENCES people(region)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

COMMENT ON TABLE orders IS 'Таблица заказов Superstore';
COMMENT ON COLUMN orders.order_id IS 'Уникальный идентификатор заказа';
COMMENT ON COLUMN orders.order_date IS 'Дата размещения заказа';
COMMENT ON COLUMN orders.ship_date IS 'Дата отгрузки заказа';
COMMENT ON COLUMN orders.ship_mode IS 'Режим доставки';
COMMENT ON COLUMN orders.customer_id IS 'Идентификатор клиента';
COMMENT ON COLUMN orders.customer_name IS 'Имя клиента';
COMMENT ON COLUMN orders.segment IS 'Сегмент рынка (Consumer, Corporate и т.д.)';
COMMENT ON COLUMN orders.region IS 'Регион, связанный с таблицей people';
COMMENT ON COLUMN orders.sales IS 'Объем продаж';
COMMENT ON COLUMN orders.discount IS 'Применённая скидка';
COMMENT ON COLUMN orders.profit IS 'Полученная прибыль';

-- Индекс для ускорения фильтрации по региону
CREATE INDEX idx_orders_region ON orders(region);

-- Таблица: returns
CREATE TABLE returns (
    order_id VARCHAR(20) PRIMARY KEY,
    returned VARCHAR(10) CHECK (returned IN ('Yes', 'No')),
    CONSTRAINT fk_returns_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE returns IS 'Информация о возвратах заказов';
COMMENT ON COLUMN returns.order_id IS 'Идентификатор заказа (FK → orders)';
COMMENT ON COLUMN returns.returned IS 'Статус возврата (Yes / No)';

COMMIT;
