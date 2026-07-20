/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 3

Module:
Database Infrastructure - Warehouse Sourcing Table

Author:
Sanjana

Description:
Creates the warehouses table, applies check constraints,
indexes for common queries, and populates 5 records.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- 1. Create Table
CREATE TABLE IF NOT EXISTS warehouses (
    warehouse_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    warehouse_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'India',
    capacity INTEGER NOT NULL,
    manager_name VARCHAR(150),
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Constraints
ALTER TABLE warehouses
    ADD CONSTRAINT uq_warehouses_name UNIQUE (warehouse_name),
    ADD CONSTRAINT chk_warehouses_capacity CHECK (capacity > 0),
    ADD CONSTRAINT chk_warehouses_status CHECK (status IN ('ACTIVE', 'INACTIVE'));

-- 3. Trigger for Auto-timestamps
CREATE TRIGGER tr_update_warehouses_timestamp
BEFORE UPDATE ON warehouses
FOR EACH ROW
EXECUTE FUNCTION fn_update_timestamp_column();

-- 4. Indexes
CREATE INDEX IF NOT EXISTS idx_warehouses_name ON warehouses (warehouse_name);
CREATE INDEX IF NOT EXISTS idx_warehouses_city ON warehouses (city);

-- 5. Seed Data (5 Warehouses)
SELECT 'Seeding warehouses...' AS info;

INSERT INTO warehouses (warehouse_name, city, state, country, capacity, manager_name, status) VALUES
('Hyderabad Warehouse', 'Hyderabad', 'Telangana', 'India', 500000, 'Rajesh Kumar', 'ACTIVE'),
('Bangalore Warehouse', 'Bangalore', 'Karnataka', 'India', 600000, 'Sneha Reddy', 'ACTIVE'),
('Mumbai Warehouse', 'Mumbai', 'Maharashtra', 'India', 750000, 'Vikram Shinde', 'ACTIVE'),
('Chennai Warehouse', 'Chennai', 'Tamil Nadu', 'India', 400000, 'Anand Iyer', 'ACTIVE'),
('Delhi Warehouse', 'Delhi', 'Delhi', 'India', 800000, 'Amit Sharma', 'ACTIVE');

SELECT 'Warehouse seeding completed successfully.' AS info;
