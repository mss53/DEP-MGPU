
-- Проверка количества записей

-- Количество записей в основных таблицах
SELECT 'Основные таблицы - количество записей' as check_type;
SELECT 'orders' as table_name, COUNT(*) as record_count FROM orders
UNION ALL
SELECT 'people', COUNT(*) FROM people
UNION ALL
SELECT 'returns', COUNT(*) FROM returns;

-- Распределение данных по категориям
SELECT 'Распределение по категориям' as check_type;
SELECT category, COUNT(*) as product_count
FROM orders
GROUP BY category
ORDER BY product_count DESC;

-- Распределение по регионам
SELECT 'Распределение по регионам' as check_type;
SELECT region, COUNT(*) as order_count
FROM orders
GROUP BY region
ORDER BY order_count DESC;

-- Распределение по сегментам клиентов
SELECT 'Распределение по сегментам' as check_type;
SELECT segment, COUNT(*) as customer_count
FROM orders
GROUP BY segment
ORDER BY customer_count DESC;

-- Проверка целостности данных

-- Проверка отсутствия дубликатов в orders
SELECT 'Проверка дубликатов order_id' as check_type;
SELECT order_id, COUNT(*) as duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Проверка дубликатов в people
SELECT 'Проверка дубликатов people' as check_type;
SELECT person, region, COUNT(*) as duplicate_count
FROM people
GROUP BY person, region
HAVING COUNT(*) > 1;

-- Проверка ссылочной целостности между returns и orders
SELECT 'Проверка ссылочной целостности returns -> orders' as check_type;
SELECT COUNT(*) as orphaned_records
FROM returns r
LEFT JOIN orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Проверка ссылочной целостности между orders и people
SELECT 'Проверка ссылочной целостности orders -> people' as check_type;
SELECT COUNT(*) as unmatched_regions
FROM orders o
LEFT JOIN people p ON o.region = p.region
WHERE p.region IS NULL;

-- Проверка качества данных

-- Проверка отсутствующих значений в ключевых полях orders
SELECT 'Проверка отсутствующих значений в orders' as check_type;
SELECT 
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) as missing_order_id,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as missing_customer_id,
    COUNT(CASE WHEN order_date IS NULL THEN 1 END) as missing_order_date,
    COUNT(CASE WHEN product_id IS NULL THEN 1 END) as missing_product_id
FROM orders;

-- Проверка некорректных дат
SELECT 'Проверка корректности дат' as check_type;
SELECT COUNT(*) as invalid_dates
FROM orders
WHERE ship_date < order_date;

-- Проверка отрицательных значений
SELECT 'Проверка отрицательных значений' as check_type;
SELECT 
    COUNT(CASE WHEN sales < 0 THEN 1 END) as negative_sales,
    COUNT(CASE WHEN quantity < 0 THEN 1 END) as negative_quantity,
    COUNT(CASE WHEN profit < 0 THEN 1 END) as negative_profit
FROM orders;

-- Проверка корректности discount
SELECT 'Проверка корректности скидок' as check_type;
SELECT 
    COUNT(*) as invalid_discounts
FROM orders
WHERE discount NOT BETWEEN 0 AND 1;

-- Проверка бизнес-логики

-- Проверка возвратов (должны быть только 'Yes')
SELECT 'Проверка значений в returns' as check_type;
SELECT returned, COUNT(*) as count
FROM returns
GROUP BY returned;

-- Проверка уникальности customer_id + order_id
SELECT 'Проверка уникальности заказов по клиентам' as check_type;
SELECT customer_id, order_id, COUNT(*) as duplicate_count
FROM orders
GROUP BY customer_id, order_id
HAVING COUNT(*) > 1;

-- Проверка согласованности регионов
SELECT 'Проверка согласованности регионов' as check_type;
SELECT 
    o.region as orders_region,
    p.region as people_region,
    COUNT(*) as order_count
FROM orders o
LEFT JOIN people p ON o.region = p.region
GROUP BY o.region, p.region
ORDER BY order_count DESC;