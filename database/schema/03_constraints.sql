/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 2

Module:
Database Infrastructure - Constraints & Triggers

Author:
Sanjana

Description:
Applies relational foreign keys, check validations,
and timestamp triggers for automatic column updates.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- ============================================================================
-- 1. Unique Constraints
-- ============================================================================

ALTER TABLE categories
    ADD CONSTRAINT uq_categories_name UNIQUE (category_name);

ALTER TABLE products
    ADD CONSTRAINT uq_products_sku UNIQUE (sku);


-- ============================================================================
-- 2. Foreign Key Constraints
-- ============================================================================

ALTER TABLE products
    ADD CONSTRAINT fk_products_categories
    FOREIGN KEY (category_id)
    REFERENCES categories (category_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE products
    ADD CONSTRAINT fk_products_suppliers
    FOREIGN KEY (supplier_id)
    REFERENCES suppliers (supplier_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;


-- ============================================================================
-- 3. Value Validation Check Constraints
-- ============================================================================

-- Products: cost_price and selling_price must be positive, and selling_price must be >= cost_price
ALTER TABLE products
    ADD CONSTRAINT chk_products_cost_price CHECK (cost_price >= 0),
    ADD CONSTRAINT chk_products_selling_price CHECK (selling_price >= 0),
    ADD CONSTRAINT chk_products_margins CHECK (selling_price >= cost_price);

-- Products: warranty_months must be non-negative
ALTER TABLE products
    ADD CONSTRAINT chk_products_warranty_months CHECK (warranty_months >= 0);

-- Products & Suppliers: Limit statuses to business-defined lists
ALTER TABLE suppliers
    ADD CONSTRAINT chk_suppliers_status CHECK (status IN ('ACTIVE', 'INACTIVE'));

ALTER TABLE products
    ADD CONSTRAINT chk_products_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'DISCONTINUED'));

-- Suppliers: Standard structural email check
ALTER TABLE suppliers
    ADD CONSTRAINT chk_suppliers_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');


-- ============================================================================
-- 4. Automatic Timestamp Function and Triggers
-- ============================================================================

-- Create database function to automate updated_at changes
CREATE OR REPLACE FUNCTION fn_update_timestamp_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply triggers to Categories, Suppliers, and Products
CREATE TRIGGER tr_update_categories_timestamp
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION fn_update_timestamp_column();

CREATE TRIGGER tr_update_suppliers_timestamp
BEFORE UPDATE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION fn_update_timestamp_column();

CREATE TRIGGER tr_update_products_timestamp
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION fn_update_timestamp_column();
