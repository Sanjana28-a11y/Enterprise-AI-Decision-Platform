/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 4

Module:
Database Infrastructure - Payments Processing Table

Author:
Sanjana

Description:
Creates the payments table, applies method and status
validations, indexes for lookups, and appends the
PL/pgSQL seed block to populate 5,000 orders,
~15,000 order items, and 5,000 payments dynamically.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- 1. Create Table
CREATE TABLE IF NOT EXISTS payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    transaction_reference VARCHAR(150) NOT NULL,
    payment_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Constraints & References
ALTER TABLE payments
    ADD CONSTRAINT uq_payments_order UNIQUE (order_id),
    ADD CONSTRAINT uq_payments_txn_ref UNIQUE (transaction_reference),
    ADD CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT chk_payments_method CHECK (payment_method IN ('UPI', 'Credit Card', 'Debit Card', 'Net Banking', 'Cash on Delivery')),
    ADD CONSTRAINT chk_payments_status CHECK (payment_status IN ('Pending', 'Success', 'Failed', 'Refunded')),
    ADD CONSTRAINT chk_payments_amount CHECK (amount > 0);

-- 3. Indexes
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments (order_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments (payment_status);
CREATE INDEX IF NOT EXISTS idx_payments_date ON payments (payment_date);

SELECT 'Payments table created successfully.' AS info;

-- ============================================================
-- 4. SEED DATA BLOCK
-- Dynamically populates 5,000 orders, ~15,000 order items,
-- and 5,000 payments using PL/pgSQL.
-- ============================================================

SELECT 'Beginning order management seed data generation...' AS info;
SELECT setseed(0.314159);

DO $$
DECLARE
    v_customer_ids UUID[];
    v_product_data RECORD;
    v_customer_id UUID;
    v_order_id UUID;
    v_order_number VARCHAR(100);
    v_order_date TIMESTAMPTZ;
    v_order_status VARCHAR(50);
    v_total_amount NUMERIC(12,2);
    v_num_items INTEGER;
    v_product_id UUID;
    v_unit_price NUMERIC(12,2);
    v_quantity INTEGER;
    v_subtotal NUMERIC(12,2);
    v_payment_method VARCHAR(50);
    v_payment_status VARCHAR(50);
    v_txn_ref VARCHAR(150);
    v_payment_date TIMESTAMPTZ;
    v_statuses TEXT[] := ARRAY['Pending', 'Confirmed', 'Packed', 'Shipped', 'Delivered', 'Cancelled', 'Returned'];
    v_status_weights NUMERIC[] := ARRAY[0.08, 0.10, 0.07, 0.12, 0.50, 0.08, 0.05];
    v_methods TEXT[] := ARRAY['UPI', 'Credit Card', 'Debit Card', 'Net Banking', 'Cash on Delivery'];
    v_method_weights NUMERIC[] := ARRAY[0.35, 0.20, 0.15, 0.10, 0.20];
    v_pay_statuses TEXT[] := ARRAY['Pending', 'Success', 'Failed', 'Refunded'];
    v_rand NUMERIC;
    v_cum NUMERIC;
    v_cities TEXT[] := ARRAY['Hyderabad', 'Bangalore', 'Mumbai', 'Chennai', 'Delhi'];
    v_states TEXT[] := ARRAY['Telangana', 'Karnataka', 'Maharashtra', 'Tamil Nadu', 'Delhi'];
    v_streets TEXT[] := ARRAY['MG Road', 'Park Street', 'Jubilee Hills', 'Anna Nagar', 'Connaught Place', 'Banjara Hills', 'Koramangala', 'Andheri West', 'T Nagar', 'Lajpat Nagar', 'Hitech City', 'Indiranagar', 'Bandra East', 'Adyar', 'Karol Bagh'];
    v_city_idx INTEGER;
    v_ship_addr TEXT;
    v_bill_addr TEXT;
    i INTEGER;
    j INTEGER;
BEGIN
    -- Pre-load all ACTIVE customer IDs into an array
    SELECT array_agg(customer_id) INTO v_customer_ids
    FROM customers
    WHERE status = 'ACTIVE';

    -- Loop to create 5,000 orders
    FOR i IN 1..5000 LOOP
        -- Pick a random customer
        v_customer_id := v_customer_ids[1 + floor(random() * array_length(v_customer_ids, 1))::integer];

        -- Generate unique order number: ORD-YYYYMMDD-NNNNN
        v_order_date := CURRENT_TIMESTAMP - (random() * 730 || ' days')::interval;
        v_order_number := 'ORD-' || to_char(v_order_date, 'YYYYMMDD') || '-' || lpad(i::text, 5, '0');

        -- Weighted random status selection
        v_rand := random();
        v_cum := 0;
        v_order_status := 'Delivered';
        FOR j IN 1..array_length(v_statuses, 1) LOOP
            v_cum := v_cum + v_status_weights[j];
            IF v_rand <= v_cum THEN
                v_order_status := v_statuses[j];
                EXIT;
            END IF;
        END LOOP;

        -- Generate addresses
        v_city_idx := 1 + floor(random() * 5)::integer;
        v_ship_addr := floor(random() * 500 + 1)::text || ', ' || v_streets[1 + floor(random() * array_length(v_streets, 1))::integer] || ', ' || v_cities[v_city_idx] || ', ' || v_states[v_city_idx] || ' - ' || (500000 + floor(random() * 100000))::text;
        v_bill_addr := v_ship_addr;

        -- Insert the order with placeholder total
        INSERT INTO orders (order_id, customer_id, order_number, order_date, order_status, total_amount, shipping_address, billing_address, created_at, updated_at)
        VALUES (gen_random_uuid(), v_customer_id, v_order_number, v_order_date, v_order_status, 0.00, v_ship_addr, v_bill_addr, v_order_date, v_order_date)
        RETURNING order_id INTO v_order_id;

        -- Determine number of items per order (1 to 5, weighted towards 2-3)
        v_rand := random();
        IF v_rand < 0.15 THEN v_num_items := 1;
        ELSIF v_rand < 0.40 THEN v_num_items := 2;
        ELSIF v_rand < 0.70 THEN v_num_items := 3;
        ELSIF v_rand < 0.90 THEN v_num_items := 4;
        ELSE v_num_items := 5;
        END IF;

        v_total_amount := 0;

        -- Insert order items
        FOR j IN 1..v_num_items LOOP
            -- Pick a random product and its selling_price
            SELECT product_id, selling_price INTO v_product_id, v_unit_price
            FROM products
            ORDER BY random()
            LIMIT 1;

            v_quantity := 1 + floor(random() * 4)::integer;
            v_subtotal := v_quantity * v_unit_price;
            v_total_amount := v_total_amount + v_subtotal;

            INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, created_at)
            VALUES (v_order_id, v_product_id, v_quantity, v_unit_price, v_subtotal, v_order_date);
        END LOOP;

        -- Update order total_amount
        UPDATE orders SET total_amount = v_total_amount WHERE order_id = v_order_id;

        -- Weighted random payment method
        v_rand := random();
        v_cum := 0;
        v_payment_method := 'UPI';
        FOR j IN 1..array_length(v_methods, 1) LOOP
            v_cum := v_cum + v_method_weights[j];
            IF v_rand <= v_cum THEN
                v_payment_method := v_methods[j];
                EXIT;
            END IF;
        END LOOP;

        -- Payment status derived from order status
        IF v_order_status IN ('Delivered', 'Shipped', 'Packed', 'Confirmed') THEN
            v_payment_status := 'Success';
        ELSIF v_order_status = 'Cancelled' THEN
            v_rand := random();
            IF v_rand < 0.6 THEN v_payment_status := 'Refunded';
            ELSE v_payment_status := 'Failed';
            END IF;
        ELSIF v_order_status = 'Returned' THEN
            v_payment_status := 'Refunded';
        ELSE
            v_payment_status := 'Pending';
        END IF;

        -- Generate unique transaction reference
        v_txn_ref := 'TXN-' || to_char(v_order_date, 'YYYYMMDD') || '-' || lpad(i::text, 6, '0');
        v_payment_date := v_order_date + (random() * 2 || ' hours')::interval;

        INSERT INTO payments (order_id, payment_method, payment_status, transaction_reference, payment_date, amount, created_at)
        VALUES (v_order_id, v_payment_method, v_payment_status, v_txn_ref, v_payment_date, v_total_amount, v_payment_date);

    END LOOP;

    RAISE NOTICE 'Order management seed data generation complete.';
END $$;

SELECT 'Seed summary:' AS info;
SELECT
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM order_items) AS total_order_items,
    (SELECT COUNT(*) FROM payments) AS total_payments;
