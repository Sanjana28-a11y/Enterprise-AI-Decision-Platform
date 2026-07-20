/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 4

Module:
Database Infrastructure - Orders Transactional Table

Author:
Sanjana

Description:
Creates the orders table capturing order lifecycle,
applies status validation constraints, indexes for
common queries, and triggers for timestamp automation.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- 1. Create Table
CREATE TABLE IF NOT EXISTS orders (
    order_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    order_number VARCHAR(100) NOT NULL,
    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    shipping_address TEXT NOT NULL,
    billing_address TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Constraints & References
ALTER TABLE orders
    ADD CONSTRAINT uq_orders_number UNIQUE (order_number),
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT chk_orders_status CHECK (order_status IN ('Pending', 'Confirmed', 'Packed', 'Shipped', 'Delivered', 'Cancelled', 'Returned')),
    ADD CONSTRAINT chk_orders_total CHECK (total_amount >= 0);

-- 3. Trigger for Auto-timestamps
CREATE TRIGGER tr_update_orders_timestamp
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION fn_update_timestamp_column();

-- 4. Indexes
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders (customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_number ON orders (order_number);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders (order_status);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders (order_date);

SELECT 'Orders table created successfully.' AS info;
