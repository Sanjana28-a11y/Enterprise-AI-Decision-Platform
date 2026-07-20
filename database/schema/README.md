# Database Schema Scripts

This directory houses the modular SQL scripts used to configure and seed the **Enterprise AI Decision Intelligence Platform** database foundation.

---

## Script Files Overview & Purpose

### 📑 [01_create_database.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/01_create_database.sql)
- **Purpose:** Initializes the database container named `enterprise_ai_platform` and activates the PostgreSQL cryptographic extension `pgcrypto`.
- **Key Highlight:** Enables standard UUID generators (`gen_random_uuid()`) to prevent predictable ID scanning or collision risks on distributed databases.

### 📑 [02_create_tables.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/02_create_tables.sql)
- **Purpose:** Scaffolds the base tabular structure (schema fields, data types, and primary keys) for **Categories**, **Suppliers**, and **Products**.
- **Key Highlight:** Excludes cross-table foreign keys to ensure the script executes clean table creations without reference order failures.

### 📑 [03_constraints.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/03_constraints.sql)
- **Purpose:** Applies relational constraints, check validations, and automates tracking columns.
- **Key Highlight:** Separating this allows adding foreign keys, data ranges (e.g., selling price validation), and `updated_at` trigger updates cleanly without cluttering base table structures.

### 📑 [04_indexes.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/04_indexes.sql)
- **Purpose:** Sets up B-Tree indexes on fields commonly targeted by lookup filters or search terms (category name, supplier name, product name, brand).
- **Key Highlight:** Configures index access points on foreign key fields to optimize structural table joins during analytical queries.

### 📑 [05_seed_data.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/05_seed_data.sql)
- **Purpose:** Populates the tables with realistic initial data (4 categories, 5 suppliers, and 200 products).
- **Key Highlight:** Utilizes SELECT subqueries to map relationships dynamically, preventing the need to hardcode specific UUID strings.

### 📑 [06_customer.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/06_customer.sql)
- **Purpose:** Sets up the `customers` table with checks (e.g., membership type constraints, email format validation), indexes on query lookup columns (email, city, customer type), an update trigger, and seeds 500 realistic customer profiles.
- **Key Highlight:** Completely encapsulates the customer entity profile structure and seed data in a single operational script.

### 📑 [07_warehouse.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/07_warehouse.sql)
- **Purpose:** Configures the physical locations (`warehouses` table) detailing capacities and managers, indexes search fields, and populates 5 major distribution hubs (Hyderabad, Bangalore, Mumbai, Chennai, Delhi).
- **Key Highlight:** Standardizes capacity checks and ensures location coordinates are uniquely tracked.

### 📑 [08_inventory.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/08_inventory.sql)
- **Purpose:** Creates the `inventory` mapping bridge table linking products and warehouses, enforces quantity relationships (`quantity_reserved <= quantity_available`), configures performance indexes, and seeds 1,000 mapping records dynamically via a cross-join.
- **Key Highlight:** Relies on a dynamic cross-join query to automatically assign stock quantities, reorder points, and restock timelines for all 200 products across all 5 warehouses.

### 📑 [09_orders.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/09_orders.sql)
- **Purpose:** Creates the `orders` table capturing order lifecycle data including customer references, order numbers, status tracking, and address information. Applies status validation constraints (`Pending`, `Confirmed`, `Packed`, `Shipped`, `Delivered`, `Cancelled`, `Returned`), indexes on join and filter columns, and automates `updated_at` timestamps.
- **Key Highlight:** Enforces a strict 7-state lifecycle model for order status transitions and guarantees non-negative order totals.

### 📑 [10_order_items.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/10_order_items.sql)
- **Purpose:** Creates the `order_items` junction table bridging orders to products with quantity, unit price, and computed subtotal fields. Enforces subtotal integrity (`subtotal = quantity * unit_price`) at the database level.
- **Key Highlight:** Uses a cascading delete on `order_id` to automatically remove line items when an order is purged, while restricting product deletion to prevent orphaned references.

### 📑 [11_payments.sql](file:///c:/Enterprise-AI-Decision-Platform/database/schema/11_payments.sql)
- **Purpose:** Creates the `payments` table with one-to-one order mapping, validates payment methods (`UPI`, `Credit Card`, `Debit Card`, `Net Banking`, `Cash on Delivery`) and statuses (`Pending`, `Success`, `Failed`, `Refunded`). Includes the PL/pgSQL seed block that dynamically generates 5,000 orders, ~15,000 order items, and 5,000 payments.
- **Key Highlight:** Contains a self-contained anonymous `DO $$` block that uses weighted random distributions for order statuses and payment methods, and derives payment statuses from order lifecycle states (e.g., `Delivered` → `Success`, `Cancelled` → `Refunded`/`Failed`).

---

## Script Execution Order

To set up the database foundation, execute these files sequentially. Using the standard command-line interface `psql`, execute the following:

```bash
# 1. Spin up database and enable extensions (Run as postgres superuser)
psql -U postgres -d postgres -f 01_create_database.sql

# 2. Scaffold table columns and types
psql -U postgres -d enterprise_ai_platform -f 02_create_tables.sql

# 3. Apply constraints, key bindings, and automated triggers
psql -U postgres -d enterprise_ai_platform -f 03_constraints.sql

# 4. Configure query-optimization indexes
psql -U postgres -d enterprise_ai_platform -f 04_indexes.sql

# 5. Populate tables with realistic operational seed data (200 products)
psql -U postgres -d enterprise_ai_platform -f 05_seed_data.sql

# 6. Setup and seed the Customer directory
psql -U postgres -d enterprise_ai_platform -f 06_customer.sql

# 7. Setup and seed Warehouse centers
psql -U postgres -d enterprise_ai_platform -f 07_warehouse.sql

# 8. Scaffold and map Inventory balances
psql -U postgres -d enterprise_ai_platform -f 08_inventory.sql

# 9. Create the Orders transactional table
psql -U postgres -d enterprise_ai_platform -f 09_orders.sql

# 10. Create the Order Items junction table
psql -U postgres -d enterprise_ai_platform -f 10_order_items.sql

# 11. Create the Payments table and seed all order management data
psql -U postgres -d enterprise_ai_platform -f 11_payments.sql
```

---

## Architectural Rationale for Script Separation

Separating the database deployment into discrete, numbered SQL scripts mirrors modern enterprise schema management best practices:
1. **Dependency Resolution:** Scaffolding tables first and applying foreign keys later prevents issues where tables reference each other in a cyclic dependency, allowing scripts to execute smoothly.
2. **Simplified Schema Migrations:** During updates, altering constraints or rebuilding indexes can be managed by running specific sub-scripts instead of rewriting the entire database structure.
3. **Environment Segregation:** High-load environments might require different index strategies or completely omit test seed data while sharing identical structures.
