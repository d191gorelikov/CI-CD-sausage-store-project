--индекс для поля order_id

CREATE INDEX order_product_order_id_idx ON order_product(order_id);

-- индекс для полей status и date_created

CREATE INDEX orders_status_date_idx ON orders(status, date_created);