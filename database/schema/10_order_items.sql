/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 4

Module:
Database Infrastructure - Order Items Bridge Table

Author:
Sanjana

Description:
Creates the order_items junction table linking orders
to products, enforces positive quantity and subtotal
integrity, and indexes foreign key join columns.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- 1. Create Table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Constraints & References
ALTER TABLE order_items
    ADD CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_order_items_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT chk_order_items_quantity CHECK (quantity > 0),
    ADD CONSTRAINT chk_order_items_unit_price CHECK (unit_price >= 0),
    ADD CONSTRAINT chk_order_items_subtotal CHECK (subtotal = quantity * unit_price);

-- 3. Indexes
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items (order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items (product_id);

SELECT 'Order Items table created successfully.' AS info;
