/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 3

Module:
Database Infrastructure - Product Inventory Mapping

Author:
Sanjana

Description:
Creates the inventory bridge table, links products to
warehouses, and seeds stock distributions dynamically.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- 1. Create Table
CREATE TABLE IF NOT EXISTS inventory (
    inventory_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL,
    warehouse_id UUID NOT NULL,
    quantity_available INTEGER NOT NULL DEFAULT 0,
    quantity_reserved INTEGER NOT NULL DEFAULT 0,
    reorder_level INTEGER NOT NULL DEFAULT 10,
    last_restock_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Constraints & References
ALTER TABLE inventory
    ADD CONSTRAINT uq_inventory_product_warehouse UNIQUE (product_id, warehouse_id),
    ADD CONSTRAINT fk_inventory_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_inventory_warehouses FOREIGN KEY (warehouse_id) REFERENCES warehouses (warehouse_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT chk_inventory_qty_avail CHECK (quantity_available >= 0),
    ADD CONSTRAINT chk_inventory_qty_res CHECK (quantity_reserved >= 0),
    ADD CONSTRAINT chk_inventory_reorder CHECK (reorder_level >= 0),
    ADD CONSTRAINT chk_inventory_reservation CHECK (quantity_reserved <= quantity_available);

-- 3. Trigger for Auto-timestamps
CREATE TRIGGER tr_update_inventory_timestamp
BEFORE UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION fn_update_timestamp_column();

-- 4. Indexes for Sourcing & Joins
CREATE INDEX IF NOT EXISTS idx_inventory_product_id ON inventory (product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_warehouse_id ON inventory (warehouse_id);
CREATE INDEX IF NOT EXISTS idx_inventory_qty_avail ON inventory (quantity_available);

-- 5. Seed Data (Cross-Join all 200 Products across 5 Warehouses = 1,000 Inventory Records)
SELECT 'Seeding inventory mappings dynamically via cross join...' AS info;

-- Use a reproducible seed for random generation
SELECT setseed(0.42);

INSERT INTO inventory (product_id, warehouse_id, quantity_available, quantity_reserved, reorder_level, last_restock_date)
SELECT 
    p.product_id, 
    w.warehouse_id,
    qty.q_avail as quantity_available,
    floor(random() * (qty.q_avail * 0.12))::integer as quantity_reserved,
    qty.reorder as reorder_level,
    CURRENT_TIMESTAMP - (random() * 45 || ' days')::interval as last_restock_date
FROM products p
CROSS JOIN warehouses w
CROSS JOIN LATERAL (
    SELECT 
        floor(random() * (480 - 15 + 1) + 15)::integer as q_avail,
        floor(random() * (25 - 5 + 1) + 5)::integer as reorder
) qty;

SELECT 'Inventory seeding completed successfully with ' || (SELECT COUNT(*) FROM inventory) || ' records.' AS info;
