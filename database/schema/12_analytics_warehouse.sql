/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Analytics Warehouse Schema - Star Schema

Author:
Data Engineering Team

Description:
Creates the analytics schema with star schema tables:
- Dimension tables (dim_customer, dim_product)
- Fact table (fact_sales)
Indexes and constraints for analytical queries.

======================================================
*/

-- Create analytics schema
CREATE SCHEMA IF NOT EXISTS analytics;

-- =====================================================
-- DIMENSION TABLES
-- =====================================================

-- Dimension: Customer
DROP TABLE IF EXISTS analytics.dim_customer CASCADE;

CREATE TABLE analytics.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id UUID NOT NULL UNIQUE,
    
    -- Basic Info
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    
    -- Demographics
    date_of_birth DATE,
    age INTEGER,
    gender VARCHAR(20),
    
    -- Business
    customer_type VARCHAR(50),
    customer_segment VARCHAR(100),
    registration_date DATE,
    
    -- Location
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    
    -- Status
    status VARCHAR(50),
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    dw_inserted_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    dw_updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_dim_customer_customer_id ON analytics.dim_customer(customer_id);
CREATE INDEX idx_dim_customer_city ON analytics.dim_customer(city);
CREATE INDEX idx_dim_customer_customer_type ON analytics.dim_customer(customer_type);
CREATE INDEX idx_dim_customer_status ON analytics.dim_customer(status);

-- Dimension: Product
DROP TABLE IF EXISTS analytics.dim_product CASCADE;

CREATE TABLE analytics.dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id UUID NOT NULL UNIQUE,
    
    -- Basic Info
    product_name VARCHAR(200),
    description TEXT,
    sku VARCHAR(100) UNIQUE,
    
    -- Category
    category_id UUID,
    category_name VARCHAR(100),
    
    -- Supplier
    supplier_id UUID,
    supplier_name VARCHAR(150),
    
    -- Attributes
    brand VARCHAR(100),
    color VARCHAR(50),
    dimensions VARCHAR(100),
    weight DECIMAL(8,2),
    warranty_months INTEGER,
    
    -- Pricing
    cost_price NUMERIC(12,2),
    selling_price NUMERIC(12,2),
    margin_amount NUMERIC(12,2),
    margin_percentage DECIMAL(10,2),
    price_range VARCHAR(50),
    
    -- Dates
    launch_date DATE,
    
    -- Status
    status VARCHAR(50),
    
    -- Metadata
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    dw_inserted_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    dw_updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_dim_product_product_id ON analytics.dim_product(product_id);
CREATE INDEX idx_dim_product_category ON analytics.dim_product(category_name);
CREATE INDEX idx_dim_product_supplier ON analytics.dim_product(supplier_name);
CREATE INDEX idx_dim_product_brand ON analytics.dim_product(brand);
CREATE INDEX idx_dim_product_status ON analytics.dim_product(status);
CREATE INDEX idx_dim_product_sku ON analytics.dim_product(sku);

-- =====================================================
-- FACT TABLES
-- =====================================================

-- Fact: Sales (Orders and Order Items)
DROP TABLE IF EXISTS analytics.fact_sales CASCADE;

CREATE TABLE analytics.fact_sales (
    sales_key SERIAL PRIMARY KEY,
    order_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    product_id UUID,
    
    -- Order Information
    order_number VARCHAR(100),
    order_date DATE,
    order_status VARCHAR(50),
    order_phase VARCHAR(50),
    
    -- Line Items
    quantity INTEGER,
    unit_price NUMERIC(12,2),
    subtotal NUMERIC(12,2),
    
    -- Order Totals
    total_amount NUMERIC(12,2),
    revenue NUMERIC(12,2),
    
    -- Payment Information
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    
    -- Flags
    is_completed BOOLEAN,
    is_cancelled BOOLEAN,
    
    -- Dates
    order_created_at TIMESTAMPTZ,
    order_updated_at TIMESTAMPTZ,
    days_since_order INTEGER,
    
    -- Address
    shipping_address TEXT,
    billing_address TEXT,
    
    -- Metadata
    dw_inserted_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    dw_updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_fact_sales_customer FOREIGN KEY (customer_id)
        REFERENCES analytics.dim_customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_fact_sales_product FOREIGN KEY (product_id)
        REFERENCES analytics.dim_product(product_id) ON DELETE CASCADE
);

-- Indexes on fact table
CREATE INDEX idx_fact_sales_order_id ON analytics.fact_sales(order_id);
CREATE INDEX idx_fact_sales_customer_id ON analytics.fact_sales(customer_id);
CREATE INDEX idx_fact_sales_product_id ON analytics.fact_sales(product_id);
CREATE INDEX idx_fact_sales_order_date ON analytics.fact_sales(order_date);
CREATE INDEX idx_fact_sales_order_status ON analytics.fact_sales(order_status);
CREATE INDEX idx_fact_sales_payment_method ON analytics.fact_sales(payment_method);
CREATE INDEX idx_fact_sales_payment_status ON analytics.fact_sales(payment_status);

-- =====================================================
-- VIEWS FOR ANALYTICS
-- =====================================================

-- Summary view: Orders by Customer
DROP VIEW IF EXISTS analytics.v_orders_by_customer CASCADE;

CREATE VIEW analytics.v_orders_by_customer AS
SELECT 
    dc.customer_key,
    dc.customer_id,
    dc.first_name,
    dc.last_name,
    dc.email,
    dc.customer_type,
    dc.city,
    COUNT(DISTINCT fs.order_id) as total_orders,
    SUM(fs.revenue) as total_spent,
    AVG(fs.revenue) as avg_order_value,
    MAX(fs.order_date) as last_order_date,
    SUM(CASE WHEN fs.is_completed THEN 1 ELSE 0 END) as completed_orders,
    SUM(CASE WHEN fs.is_cancelled THEN 1 ELSE 0 END) as cancelled_orders
FROM analytics.dim_customer dc
LEFT JOIN analytics.fact_sales fs ON dc.customer_id = fs.customer_id
GROUP BY dc.customer_key, dc.customer_id, dc.first_name, dc.last_name, 
         dc.email, dc.customer_type, dc.city;

-- Summary view: Product Performance
DROP VIEW IF EXISTS analytics.v_product_performance CASCADE;

CREATE VIEW analytics.v_product_performance AS
SELECT 
    dp.product_key,
    dp.product_id,
    dp.product_name,
    dp.category_name,
    dp.brand,
    dp.selling_price,
    COUNT(DISTINCT fs.order_id) as total_orders,
    SUM(fs.quantity) as total_quantity_sold,
    SUM(fs.revenue) as total_revenue,
    AVG(fs.revenue) as avg_order_value,
    SUM(CASE WHEN fs.is_completed THEN 1 ELSE 0 END) as successful_sales
FROM analytics.dim_product dp
LEFT JOIN analytics.fact_sales fs ON dp.product_id = fs.product_id
GROUP BY dp.product_key, dp.product_id, dp.product_name, dp.category_name, 
         dp.brand, dp.selling_price;

-- Summary view: Sales by Status
DROP VIEW IF EXISTS analytics.v_sales_by_status CASCADE;

CREATE VIEW analytics.v_sales_by_status AS
SELECT 
    order_status,
    COUNT(DISTINCT order_id) as order_count,
    SUM(revenue) as total_revenue,
    COUNT(DISTINCT customer_id) as unique_customers,
    AVG(revenue) as avg_revenue,
    MIN(order_date) as earliest_order,
    MAX(order_date) as latest_order
FROM analytics.fact_sales
GROUP BY order_status;

-- =====================================================
-- LOGGING TABLE (Future Feature)
-- =====================================================

DROP TABLE IF EXISTS analytics.etl_execution_log CASCADE;

CREATE TABLE analytics.etl_execution_log (
    execution_id SERIAL PRIMARY KEY,
    execution_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    pipeline_stage VARCHAR(100),
    status VARCHAR(50),
    records_processed INTEGER,
    records_loaded INTEGER,
    duration_seconds DECIMAL(10,2),
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- PERMISSIONS
-- =====================================================

-- GRANT permissions as needed
-- GRANT SELECT ON ALL TABLES IN SCHEMA analytics TO analytics_reader;
-- GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA analytics TO analytics_writer;

-- =====================================================
-- SUMMARY
-- =====================================================

/*
Analytics Schema Structure:

DIMENSIONS:
  - dim_customer: 25 attributes covering demographics, business type, location, status
  - dim_product: 23 attributes covering product info, pricing, categorization

FACTS:
  - fact_sales: Fact table for order-level analytics with line item detail

VIEWS:
  - v_orders_by_customer: Customer aggregations
  - v_product_performance: Product KPIs
  - v_sales_by_status: Order status analytics

INDEXES:
  - Covering key analysis dimensions and date ranges
  - Support common filter and join operations

NEXT STEPS:
  - Dimension: Time (for time-based queries)
  - Dimension: Geography (for location-based analytics)
  - Fact: Returns / Refunds
  - Slowly Changing Dimensions (SCD Type 2)
  - Incremental loading framework
*/

COMMENT ON SCHEMA analytics IS 'Analytics Warehouse - Star Schema for BI and Analytics';
COMMENT ON TABLE analytics.dim_customer IS 'Customer dimension table';
COMMENT ON TABLE analytics.dim_product IS 'Product dimension table';
COMMENT ON TABLE analytics.fact_sales IS 'Sales fact table - Order level detail';
