# Database Infrastructure & Schemas

This directory manages the database schema design, migrations, relational modeling diagrams, and seed data scripts for the **Enterprise AI Decision Intelligence Platform**.

---

## Database Overview
The platform utilizes **PostgreSQL** as its core operational data warehouse. The database is optimized to handle high-throughput transactional writes from business systems alongside complex analytical reads triggered by the Machine Learning Engine and the AI Business Assistant.

Key features of this layer include:
- **UUID Keys:** All primary keys utilize globally unique identifier strings (v4 UUIDs generated via `pgcrypto`'s `gen_random_uuid()`) to ensure horizontal scale capability.
- **Star Schema Design:** Relational schemas partition transaction records into Fact tables and dimension attributes into surrounding Dimension tables.
- **Relational Constraints:** Cascading cascades, strict checks, and unique limits enforce data sanitization directly at the database engine level.
- **Automated Timestamp Triggers:** Automated PL/pgSQL triggers handle `updated_at` timestamps on row modifications.
- **Monetary Formats:** All monetary fields utilize the high-precision `NUMERIC(12,2)` type to prevent rounding discrepancies in financial transactions.

---

## Implemented Entities (Sprint 2, 3 & 4 Milestones)

This database foundation implements the core operational dimensions, inventory mappings, and order management lifecycle:

### 1. Categories (Dimension)
- **Purpose:** Organizes the catalog into structural tax groups. This enables regional performance metrics, targeted discounts, and simple navigation queries.
- **Implemented Fields:** `category_id`, `category_name`, `description`, timestamps.

### 2. Suppliers (Dimension)
- **Purpose:** Stores details of verified manufacturers and distributors supplying the inventory. Tracks supplier statuses and contact profiles.
- **Implemented Fields:** `supplier_id`, `supplier_name`, `email`, `phone`, `city`, `state`, `country`, `status`, timestamps.

### 3. Products (Dimension)
- **Purpose:** The central product repository detailing descriptions, brands, unit costs, retail prices, dimensions, warranty periods, and launch schedules.
- **Implemented Fields:** `product_id`, `product_name`, `description`, `category_id`, `supplier_id`, `brand`, `sku`, pricing (`cost_price`, `selling_price`), measurements (`weight`, `dimensions`, `color`), `warranty_months`, `launch_date`, `status`, timestamps.

### 4. Customers (Dimension)
- **Purpose:** Stores customer demographics, contact information, and membership tiers (`Regular`, `Premium`, `Business`) to power marketing analytics, cohort mapping, and purchase behavior models.
- **Implemented Fields:** `customer_id`, `first_name`, `last_name`, `email`, `phone`, `date_of_birth`, `gender`, `customer_type`, `city`, `state`, `country`, `registration_date`, `status`, timestamps.

### 5. Warehouses (Dimension)
- **Purpose:** Tracks physical storage hubs, distribution capacities, and locations. Provides geographical contexts for regional logistics optimization and load balancing.
- **Implemented Fields:** `warehouse_id`, `warehouse_name`, `city`, `state`, `country`, `capacity`, `manager_name`, `status`, timestamps.

### 6. Inventory (Fact/Bridge)
- **Purpose:** Maps product stock balances across individual warehouse hubs. Tracks real-time counts, reorder thresholds, and reservations to prevent stockouts and support replenishment modeling.
- **Implemented Fields:** `inventory_id`, `product_id`, `warehouse_id`, `quantity_available`, `quantity_reserved`, `reorder_level`, `last_restock_date`, timestamps.

### 7. Orders (Fact)
- **Purpose:** Captures the complete purchase lifecycle from placement through delivery or return. Links customers to their transaction history with status tracking, monetary totals, and address management.
- **Implemented Fields:** `order_id`, `customer_id`, `order_number`, `order_date`, `order_status`, `total_amount`, `shipping_address`, `billing_address`, timestamps.

### 8. Order Items (Fact/Bridge)
- **Purpose:** The line-item junction table connecting individual orders to purchased products. Records quantity, pricing, and computed subtotals for each product within an order.
- **Implemented Fields:** `order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`, `subtotal`, `created_at`.

### 9. Payments (Fact)
- **Purpose:** Tracks the financial settlement of each order with method, status, and reference identifiers. Maintains a one-to-one relationship with orders to model the payment lifecycle.
- **Implemented Fields:** `payment_id`, `order_id`, `payment_method`, `payment_status`, `transaction_reference`, `payment_date`, `amount`, `created_at`.

---

## Entity Relationships

The schema models core product, warehousing, customer, and order lifecycle relationships:

- **Categories → Products:** A `Category` has many `Products`. A `Product` belongs to exactly one `Category` (`category_id` FK).
- **Suppliers → Products:** A `Supplier` distributes many `Products`. A `Product` is supplied by exactly one `Supplier` (`supplier_id` FK).
- **Warehouse → Inventory:** A `Warehouse` houses inventory balances for multiple products. An `Inventory` record references exactly one `Warehouse` (`warehouse_id` FK).
- **Product → Inventory:** A `Product` can have inventory stock stored across multiple warehouses. An `Inventory` record references exactly one `Product` (`product_id` FK).
- **Customer → Orders:** A `Customer` can place many `Orders`. An `Order` belongs to exactly one `Customer` (`customer_id` FK).
- **Order → Order Items:** An `Order` contains many `Order Items`. An `Order Item` belongs to exactly one `Order` (`order_id` FK, cascading delete).
- **Product → Order Items:** A `Product` can appear across many `Order Items`. An `Order Item` references exactly one `Product` (`product_id` FK).
- **Order → Payment:** An `Order` has exactly one `Payment`. A `Payment` belongs to exactly one `Order` (`order_id` FK, unique).

```text
Category (1) ───► (N) Product (1) ◄─── (N) Inventory (N) ◄─── (1) Warehouse
                         ▲
                         │
                    Supplier (1)
                         
                  Product (1) ◄─── (N) Order Items (N) ───► (1) Order (1) ───► (1) Payment
                                                              ▲
                                                              │
                                                         Customer (1)
```

### Order Lifecycle

The order entity follows a 7-state lifecycle:

```text
Pending ──► Confirmed ──► Packed ──► Shipped ──► Delivered
                                                      │
                   Cancelled ◄──────────────────────────
                                                      │
                   Returned  ◄──────────────────────────
```

| Status | Description |
|---|---|
| `Pending` | Order placed, awaiting confirmation |
| `Confirmed` | Payment verified, order accepted |
| `Packed` | Items assembled for shipment |
| `Shipped` | Order dispatched to customer |
| `Delivered` | Order received by customer |
| `Cancelled` | Order cancelled before delivery |
| `Returned` | Order returned after delivery |

ER Diagrams are located in the `/diagrams` folder:
- 🖼️ **[erd.png](file:///c:/Enterprise-AI-Decision-Platform/database/diagrams/erd.png):** Visual high-resolution schematic rendering.
- 📐 **[erd.drawio](file:///c:/Enterprise-AI-Decision-Platform/database/diagrams/erd.drawio):** Editable XML file for layout modification using Draw.io.

---

## Verification & Validation

To verify the database installation, run the SQL scripts sequentially as detailed in [database/schema/README.md](file:///c:/Enterprise-AI-Decision-Platform/database/schema/README.md).

Once the tables are created and seeded, run these validation queries to inspect records and verify correct foreign key bindings:

```sql
-- 1. Verify Category table load
SELECT * FROM categories;

-- 2. Verify Supplier table load
SELECT * FROM suppliers;

-- 3. Verify Product table load (retrieving base fields)
SELECT product_id, product_name, brand, sku, selling_price, status FROM products LIMIT 5;

-- 4. Verify Customer table load (retrieving base demographic fields)
SELECT customer_id, first_name, last_name, email, customer_type, city FROM customers LIMIT 5;

-- 5. Verify Warehouse locations
SELECT * FROM warehouses;

-- 6. Verify Inventory mappings
SELECT inventory_id, product_id, warehouse_id, quantity_available, quantity_reserved FROM inventory LIMIT 5;

-- 7. Verify Orders table load
SELECT order_id, customer_id, order_number, order_date, order_status, total_amount FROM orders LIMIT 5;

-- 8. Verify Order Items
SELECT order_item_id, order_id, product_id, quantity, unit_price, subtotal FROM order_items LIMIT 5;

-- 9. Verify Payments
SELECT payment_id, order_id, payment_method, payment_status, amount FROM payments LIMIT 5;

-- 10. Count loaded records across all entities
SELECT 
  (SELECT COUNT(*) FROM categories) AS total_categories,
  (SELECT COUNT(*) FROM suppliers) AS total_suppliers,
  (SELECT COUNT(*) FROM products) AS total_products,
  (SELECT COUNT(*) FROM customers) AS total_customers,
  (SELECT COUNT(*) FROM warehouses) AS total_warehouses,
  (SELECT COUNT(*) FROM inventory) AS total_inventory,
  (SELECT COUNT(*) FROM orders) AS total_orders,
  (SELECT COUNT(*) FROM order_items) AS total_order_items,
  (SELECT COUNT(*) FROM payments) AS total_payments;

-- 11. Order status distribution
SELECT order_status, COUNT(*) AS count
FROM orders GROUP BY order_status ORDER BY count DESC;

-- 12. Payment method distribution
SELECT payment_method, COUNT(*) AS count
FROM payments GROUP BY payment_method ORDER BY count DESC;

-- 13. Top 5 customers by order value
SELECT c.first_name || ' ' || c.last_name AS customer_name, c.customer_type,
       COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.customer_type
ORDER BY total_spent DESC
LIMIT 5;

-- 14. Inventory stock check showing available stock per warehouse
SELECT w.warehouse_name, c.category_name, SUM(i.quantity_available) AS total_stock_qty, AVG(i.reorder_level) AS avg_reorder_level
FROM inventory i
JOIN warehouses w ON i.warehouse_id = w.warehouse_id
JOIN products p ON i.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY w.warehouse_name, c.category_name
ORDER BY w.warehouse_name, total_stock_qty DESC;
```

---

## Next Implementation Phase

The upcoming sprints will establish fulfillment operations and customer engagement systems:

1. **Fulfillment Operations:**
   - Implement `shipments` and `returns` to track delivery logistics, carrier assignments, and return processing workflows.
2. **Customer Engagement:**
   - Integrate `support_tickets` and `marketing_campaigns` to close the loop on customer satisfaction, promotional campaigns, and AI feedback loops.
