
-- Задание 1 Создать представление по времени доставки

SET search_path TO 123;

CREATE VIEW delivery_time AS
SELECT 
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    (ship_date - order_date) AS delivery_days
FROM orders;

--Задание 2 Рассчитать скидки по сегментам

CREATE VIEW discounts_by_segment AS
SELECT 
    segment,
    ROUND(AVG(discount), 2) AS avg_discount,
    SUM(sales) AS total_sales,
    COUNT(*) AS total_orders
FROM orders
GROUP BY segment
ORDER BY avg_discount DESC;


--Задание 3 Определить продажи по подкатегориям

CREATE VIEW sales_by_subcategory AS
SELECT 
    category,
    subcategory,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(*) AS num_orders
FROM orders
GROUP BY category, subcategory
ORDER BY total_sales DESC;

