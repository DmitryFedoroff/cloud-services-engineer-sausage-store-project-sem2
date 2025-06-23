-- Миграция: Создание индексов для оптимизации запросов

-- Индекс для ускорения операции JOIN между таблицами orders и order_product
CREATE INDEX idx_order_product_order_id 
    ON order_product(order_id);

-- Композитный индекс для оптимизации фильтрации по статусу и группировки по дате
CREATE INDEX idx_orders_status_date 
    ON orders(status, date_created);

-- Частичный индекс только для статуса shipped, что уменьшает размер индекса
-- и дополнительно ускоряет запросы отчетности по отправленным заказам
CREATE INDEX idx_orders_shipped_date 
    ON orders(date_created) 
    WHERE status = 'shipped';
