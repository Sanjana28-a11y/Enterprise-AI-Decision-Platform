# Database Design & Business Entities

This document outlines the core business entities for the **Enterprise AI Decision Intelligence Platform**. These entities form the relational database model of the data warehouse, allowing for transactional integrity and analytical modeling.

---

## Star Schema Overview
The database operates under a hybrid transactional-analytical model. The central transactions are recorded in **Fact tables** (Orders, Shipments, Returns, Support Tickets), which reference surrounding **Dimension tables** (Customers, Products, Warehouses, Suppliers, Marketing Campaigns, and Calendar dates).

---

## Core Entities & Roles

### 1. Company
- **Purpose:** Represents the top-level parent enterprise.
- **Role:** Serves as the organizational root for accounting, high-level business settings, multi-tenant segmentation, or global corporate reporting.

### 2. Customer
- **Purpose:** Stores information about customers who purchase items on NovaMart.
- **Role:** Maps demographic details (operating city, email, contact details) and categorization metrics (Customer Type: `Regular`, `Premium`, `Business`) to enable customer lifetime value (CLV) analysis and segment-specific pricing.

### 3. Product
- **Purpose:** Represents items listed for sale on NovaMart.
- **Role:** Serves as the core catalog lookup table containing SKU, name, unit price, weight, dimension, description, and foreign key references to categories and suppliers.

### 4. Category
- **Purpose:** Represents the hierarchical taxonomy of products.
- **Role:** Organizes products into broad segments (Electronics, Fashion, Furniture, Home Appliances) and optional subcategories for aggregated category-level sales reporting and navigation.

### 5. Supplier
- **Purpose:** Details the manufacturers or distributors that supply products to NovaMart warehouses.
- **Role:** Tracks vendor profiles, lead times, contact details, and locations to analyze supplier performance and replenishment delays.

### 6. Warehouse
- **Purpose:** Represents the physical fulfillment centers operated by NovaMart.
- **Role:** Details the operational boundaries of the logistics network (Hyderabad, Bangalore, Mumbai), storing warehouse address, physical capacity, and operating costs.

### 7. Inventory
- **Purpose:** Details the current stock level and safety thresholds for products within warehouses.
- **Role:** Acts as a join table between **Product** and **Warehouse**, keeping real-time counts of `quantity_on_hand`, `quantity_reserved` (for packed orders), and `reorder_point` triggers.

### 8. Order
- **Purpose:** Captures the header-level details of a customer's purchase transaction.
- **Role:** Contains order date, total price, discounts applied, taxes, order status (Pending, Packed, Shipped, etc.), customer ID, and payment ID.

### 9. Order Item
- **Purpose:** Records line-level details of products within a specific order.
- **Role:** Resolves the many-to-many relationship between **Order** and **Product**, storing actual unit price, discount applied, quantity purchased, and total line cost.

### 10. Payment
- **Purpose:** Details the financial transactions settling orders.
- **Role:** Records transaction ID, payment method (UPI, Credit Card, etc.), payment status (Authorized, Settled, Refunded, Failed), timestamp, and amount paid.

### 11. Shipment
- **Purpose:** Tracks the physical fulfillment and logistics pathway of packed orders.
- **Role:** Connects an **Order** to a shipping partner, storing carrier name, tracking number, departure warehouse ID, shipping destination address, and dispatch/delivery timestamps.

### 12. Return
- **Purpose:** Tracks customer-returned products and reasons for returns.
- **Role:** Links back to **Order Item** and **Warehouse**, capturing the quantity returned, reason code (e.g., damaged, wrong size), refund amount, and inspection status (e.g., restocked, defective).

### 13. Marketing Campaign
- **Purpose:** Tracks outbound promotional initiatives.
- **Role:** Details campaign name, channel (email, social media, SMS), start/end dates, budget, and generated clicks/registrations. Allows analytical joins to track order conversions.

### 14. Support Ticket
- **Purpose:** Logs customer assistance and complaint issues.
- **Role:** Maps customer queries to standard categories (shipment delayed, wrong item, refund issue), tracks ticket status (Open, Assigned, Resolved), customer ID, priority, and resolution duration.
