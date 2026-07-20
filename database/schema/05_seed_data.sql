/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 2

Module:
Database Infrastructure - Seed Data Generation

Author:
Sanjana

Description:
Populates Categories, Suppliers, and 200 Products with
realistic enterprise dataset values.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- Clear any existing data in reverse dependency order (safe for re-runs)
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE suppliers CASCADE;
TRUNCATE TABLE categories CASCADE;

-- ============================================================================
-- 1. Seed Categories
-- ============================================================================
SELECT 'Seeding categories...' AS info;

INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Laptops, mobile devices, monitors, and consumer electronics.'),
('Fashion', 'Apparel, travel backpacks, bags, and wearable merchandise.'),
('Furniture', 'Home and office desks, seating, bookcases, and storage solutions.'),
('Home Appliances', 'Refrigerators, washing machines, microwaves, and climate systems.');

-- ============================================================================
-- 2. Seed Suppliers
-- ============================================================================
SELECT 'Seeding suppliers...' AS info;

INSERT INTO suppliers (supplier_name, email, phone, city, state, country, status) VALUES
('Samsung India', 'support.india@samsung.com', '+91-80-4000-1111', 'Bangalore', 'Karnataka', 'India', 'ACTIVE'),
('LG Electronics', 'service.india@lge.com', '+91-22-6000-2222', 'Mumbai', 'Maharashtra', 'India', 'ACTIVE'),
('IKEA India', 'customercare.india@ikea.com', '+91-40-5000-3333', 'Hyderabad', 'Telangana', 'India', 'ACTIVE'),
('Dell India', 'enterprise.sales@dell.com', '+91-80-3500-4444', 'Bangalore', 'Karnataka', 'India', 'ACTIVE'),
('HP India', 'corporate.support@hp.com', '+91-11-2000-5555', 'Delhi', 'NCR', 'India', 'ACTIVE');

-- ============================================================================
-- 3. Seed Products (200 items)
-- ============================================================================
SELECT 'Seeding products...' AS info;

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Galaxy S1 Ultra',
    'Flagship smartphone with 200MP camera and embedded S Pen.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-754', 60111.33, 80271.93, 0.23, '163 x 78 x 9 mm', 'Black', 12, '2025-04-09', 'ACTIVE'
),
(
    'Galaxy S1 Plus',
    'Premium smartphone with dynamic AMOLED display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-242', 50736.47, 66930.28, 0.20, '157 x 75 x 7.6 mm', 'Black', 12, '2026-01-13', 'ACTIVE'
),
(
    'Galaxy Watch 1 Pro',
    'Advanced smartwatch with body composition analysis.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-704', 15421.92, 17850.09, 0.05, '45 x 45 x 10.5 mm', 'Black', 12, '2025-03-21', 'ACTIVE'
),
(
    'Galaxy Tab S1',
    'High performance productivity tablet with S Pen included.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-617', 35602.02, 45937.69, 0.58, '285 x 185 x 5.7 mm', 'Graphite', 12, '2025-04-15', 'ACTIVE'
),
(
    'Galaxy Buds 1 Pro',
    'Hi-Fi wireless earbuds with active noise cancellation.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-559', 6589.27, 8911.05, 0.01, '21 x 19 x 18 mm', 'White', 12, '2022-04-08', 'ACTIVE'
),
(
    'QLED 4K Smart TV Q10',
    'Quantum dot LED smart television with voice control.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-925', 35159.66, 44148.35, 16.20, '1230 x 700 x 25 mm', 'Titan Gray', 24, '2025-08-26', 'ACTIVE'
),
(
    'Neo QLED 8K TV QN100',
    'State-of-the-art Neo QLED 8K display with neural processor.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-320', 120957.21, 149279.18, 22.40, '1440 x 820 x 17 mm', 'Carbon Silver', 36, '2024-05-23', 'ACTIVE'
),
(
    'Galaxy Book1 Pro',
    'Ultra-thin laptop with Intel Core i7 and AMOLED display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-199', 70358.98, 86962.92, 1.17, '355 x 225 x 11.7 mm', 'Graphite', 12, '2021-12-31', 'ACTIVE'
),
(
    'Smart Monitor M1',
    '32-inch 4K smart monitor with embedded streaming apps.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-001-144', 18729.73, 24050.04, 6.50, '713 x 420 x 220 mm', 'Sunset Pink', 24, '2026-01-30', 'ACTIVE'
),
(
    'UltraWide IPS Monitor 1WN',
    'Ultra-wide screen monitor with sRGB 99% color calibration.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-001-665', 15293.18, 19990.63, 5.20, '698 x 411 x 209 mm', 'Black', 36, '2023-04-15', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'UltraGear Gaming Monitor 1GN',
    'Nano IPS gaming monitor with 1ms response and 144Hz refresh.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-001-296', 24704.57, 28693.27, 7.20, '614 x 575 x 291 mm', 'Black/Red', 36, '2022-03-10', 'ACTIVE'
),
(
    'Gram 1-inch Laptop',
    'Ultra-lightweight laptop with large capacity battery.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-001-396', 55985.22, 76354.29, 0.99, '312 x 214 x 16.8 mm', 'Obsidian Black', 12, '2024-05-23', 'ACTIVE'
),
(
    'OLED evo C1 Smart TV',
    'Self-lit OLED pixels providing infinite contrast and webOS.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-001-384', 80453.41, 109298.18, 18.90, '1228 x 708 x 45 mm', 'Metallic Silver', 24, '2024-06-12', 'ACTIVE'
),
(
    'CineBeam 4K Projector HU1',
    'Smart home theater laser projector with HDR10.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-001-463', 95209.51, 115845.64, 6.50, '337 x 276 x 110 mm', 'White', 24, '2023-02-09', 'ACTIVE'
),
(
    'Tone Free T1 Earbuds',
    'Wireless earbuds with Meridian Sound and UVnano charging case.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-001-750', 5171.14, 6889.42, 0.01, '21 x 16 x 25 mm', 'Charcoal Black', 12, '2023-12-07', 'ACTIVE'
),
(
    'Latitude 1',
    'Enterprise business laptop designed for high durability.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-488', 50269.95, 69440.28, 1.37, '321 x 212 x 19.3 mm', 'Carbon Gray', 36, '2022-09-07', 'ACTIVE'
),
(
    'Inspiron 1',
    'Everyday consumer laptop with responsive performance.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-432', 35842.85, 48172.79, 1.65, '358 x 235 x 18.9 mm', 'Platinum Silver', 12, '2021-11-30', 'ACTIVE'
),
(
    'XPS 1 Developer Edition',
    'Premium ultra-portable laptop with infinity-edge display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-132', 85805.05, 107281.30, 1.24, '295 x 199 x 13.9 mm', 'Platinum', 24, '2025-05-04', 'ACTIVE'
),
(
    'Vostro 1',
    'Essential business laptop with hardware-based security.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-680', 32876.37, 40394.19, 1.70, '356 x 230 x 19.0 mm', 'Accent Black', 12, '2024-04-21', 'ACTIVE'
),
(
    'Precision 1 Workstation',
    'Professional ISV-certified workstation for heavy rendering.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-758', 95458.85, 116098.97, 2.10, '375 x 250 x 22.0 mm', 'Titanium Gray', 36, '2022-05-07', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Alienware m1 Gaming Laptop',
    'High-end gaming laptop with cryo-tech cooling system.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-674', 110538.98, 147763.36, 2.69, '399 x 294 x 23.0 mm', 'Dark Side of the Moon', 24, '2023-04-02', 'ACTIVE'
),
(
    'UltraSharp U1QE Monitor',
    '4K hub monitor with IPS Black technology and RJ45.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-508', 22362.00, 31291.85, 6.60, '611 x 385 x 185 mm', 'Platinum Silver', 36, '2023-09-01', 'ACTIVE'
),
(
    'Dell Pro Wireless Keyboard KM1',
    'Multi-device wireless keyboard and mouse combo.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-605', 2590.91, 3010.07, 0.65, '433 x 123 x 34 mm', 'Titan Gray', 36, '2025-08-31', 'ACTIVE'
),
(
    'Dell Thunderbolt Dock WD1',
    'High power delivery docking station with multiple display outputs.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-001-742', 12159.98, 16052.64, 0.58, '205 x 90 x 29 mm', 'Black', 36, '2024-05-13', 'ACTIVE'
),
(
    'Pavilion Aero 1',
    'Featherweight magnesium alloy laptop with AMD Ryzen processor.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-490', 42595.89, 53969.52, 0.96, '297 x 209 x 16.9 mm', 'Warm Gold', 12, '2023-06-03', 'ACTIVE'
),
(
    'Envy x360 1',
    'Convertible 2-in-1 laptop with touchscreen and stylus support.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-981', 60942.43, 80448.33, 1.34, '306 x 214 x 16.1 mm', 'Nightfall Black', 12, '2022-09-13', 'ACTIVE'
),
(
    'Spectre x360 1',
    'Premium gem-cut convertible laptop with OLED touch display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-649', 90750.88, 121801.26, 1.36, '298 x 220 x 16.9 mm', 'Nightfall Black', 24, '2025-11-24', 'ACTIVE'
),
(
    'LaserJet Pro MFP 1',
    'Monochrome multifunction laser printer for offices.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-400', 15434.77, 19500.77, 9.50, '390 x 360 x 255 mm', 'White/Slate', 12, '2023-09-19', 'ACTIVE'
),
(
    'Smart Tank 1 Wireless',
    'High capacity refillable ink tank printer.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-880', 9178.65, 12649.62, 5.10, '447 x 373 x 158 mm', 'Dark Basalt', 12, '2021-10-21', 'ACTIVE'
),
(
    'Omen 1 Gaming Laptop',
    'High-performance gaming laptop with advanced Omen Tempest cooling.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-754', 75507.66, 90588.64, 2.35, '369 x 248 x 23.0 mm', 'Shadow Black', 12, '2022-04-01', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'HP EliteBook 1 G9',
    'Elite business laptop with enterprise manageability.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-265', 65539.38, 88127.96, 1.35, '315 x 224 x 19.2 mm', 'Pike Silver', 36, '2023-03-02', 'ACTIVE'
),
(
    'HP Bluetooth Travel Mouse 1',
    'Compact five-button customizable wireless mouse.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-001-431', 1688.61, 1989.13, 0.08, '101 x 65 x 32 mm', 'Silver', 12, '2021-11-10', 'ACTIVE'
),
(
    'Bespoke Refrigerator RT1B',
    'Customizable double-door refrigerator with Digital Inverter.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-001-926', 30307.51, 35292.53, 68.00, '600 x 672 x 1715 mm', 'Clean White', 12, '2026-01-16', 'ACTIVE'
),
(
    'WindFree Split AC AR1',
    'Split air conditioner with 23000 micro-holes for draft-free cooling.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-001-849', 28485.99, 33251.79, 41.00, '889 x 299 x 215 mm', 'White', 12, '2025-10-21', 'ACTIVE'
),
(
    'Bespoke Front Load Washer WW1',
    'Smart washer with AI Ecobubble and hygiene steam.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-001-775', 25475.28, 32798.17, 65.00, '600 x 850 x 550 mm', 'Clean Charcoal', 24, '2023-07-26', 'ACTIVE'
),
(
    'Convection Microwave MC1',
    'Convection microwave oven with Slim Fry and HotBlast tech.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-001-993', 9606.59, 13363.64, 19.00, '517 x 310 x 463 mm', 'Black Glass', 12, '2022-07-11', 'ACTIVE'
),
(
    'Samsung Air Purifier AX1',
    'Multi-layered purification system with HEPA filter.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-001-419', 7898.99, 10410.25, 6.20, '361 x 481 x 263 mm', 'Clay Beige', 12, '2024-01-25', 'ACTIVE'
),
(
    'InstaView Door-in-Door Fridge GL-X1',
    'Knock twice on glass panel to view contents without opening.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-001-629', 75451.49, 91445.43, 120.00, '912 x 1790 x 738 mm', 'Matte Black', 24, '2024-08-17', 'ACTIVE'
),
(
    'AI DD Front Load Washer F1',
    'Intelligent washing machine with Direct Drive motor.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-001-121', 24588.31, 29691.09, 70.00, '600 x 850 x 565 mm', 'Middle Black', 36, '2026-06-26', 'ACTIVE'
),
(
    'Dual Inverter AC TS-Q1',
    'Super convertible split air conditioner with dual rotary compressor.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-001-172', 26707.84, 31107.11, 42.50, '837 x 308 x 189 mm', 'White', 12, '2026-05-07', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'NeoChef Convection Microwave MH1',
    'Smart inverter microwave oven with uniform heating.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-001-980', 8830.43, 11290.05, 13.00, '476 x 272 x 388 mm', 'Noble Silver', 12, '2022-10-09', 'ACTIVE'
),
(
    'PuriCare Air Purifier AS1',
    '360-degree air purifier with clean booster fan.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-001-597', 22214.24, 26281.18, 11.50, '343 x 343 x 587 mm', 'White', 24, '2025-02-28', 'ACTIVE'
),
(
    'CordZero A1 Cordless Vacuum',
    'Handstick vacuum cleaner with dual power pack batteries.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-001-903', 18472.97, 23123.82, 2.70, '260 x 270 x 1120 mm', 'Iron Gray', 12, '2025-12-24', 'ACTIVE'
),
(
    'Poäng Armchair PA-1',
    'Classic layer-bent birch frame armchair with high back support.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-774', 3931.05, 4936.98, 8.50, '68 x 82 x 100 cm', 'Knisa Black', 120, '2021-09-05', 'ACTIVE'
),
(
    'Kallax Shelf Unit KX-1',
    'Cube structure shelving unit, can be oriented vertically or horizontally.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-846', 2854.17, 3748.56, 18.00, '77 x 147 cm', 'White', 24, '2026-03-08', 'ACTIVE'
),
(
    'Malm Desk MD-1',
    'Sleek desk with clean lines and pull-out panel for keyboard.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-512', 7228.21, 9759.15, 27.50, '151 x 65 x 73 cm', 'White', 60, '2025-02-16', 'ACTIVE'
),
(
    'Billy Bookcase BY-1',
    'Highly adjustable shelves bookcase, the benchmark in utility design.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-296', 2390.21, 3016.81, 14.50, '80 x 28 x 202 cm', 'Oak Veneer', 12, '2025-06-30', 'ACTIVE'
),
(
    'Ektorp 1-Seat Sofa',
    'Durable sofa with comfortable back cushions and machine washable covers.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-385', 18462.63, 25268.35, 65.00, '218 x 88 x 88 cm', 'Hallarp Beige', 120, '2024-01-15', 'ACTIVE'
),
(
    'Lack Side Table LK-1',
    'Lightweight, easy to assemble side table for living room spaces.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-927', 1461.35, 1881.61, 3.80, '55 x 55 x 45 cm', 'Black', 12, '2022-11-13', 'ACTIVE'
),
(
    'Ingatorp Table IT-1',
    'Extendable dining table with 1 extra leaf, seats 4-6.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-653', 12836.03, 17870.95, 44.00, '155 x 87 x 74 cm', 'Black', 60, '2025-08-04', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Renberget Office Chair RC-1',
    'Adjustable office swivel chair with tilt tension control.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-516', 2985.64, 3593.03, 12.00, '59 x 65 x 108 cm', 'Bomstad Black', 24, '2026-03-12', 'ACTIVE'
),
(
    'Pax Wardrobe System PX-1',
    'Modular wardrobe frame with soft closing hinge doors.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-268', 15378.97, 21474.07, 85.00, '150 x 60 x 236 cm', 'White', 120, '2022-02-16', 'ACTIVE'
),
(
    'Hemnes Coffee Table HC-1',
    'Solid pine coffee table with a separate shelf for magazines.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-903', 5455.01, 6850.14, 17.00, '90 x 90 x 46 cm', 'Black-Brown', 60, '2025-08-27', 'ACTIVE'
),
(
    'Bekant Standing Desk BS-1',
    'Motorized height adjustable sit/stand desk for ergonomic workspace.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-294', 20296.71, 28256.62, 32.00, '160 x 80 cm', 'White/Black Frame', 120, '2022-05-01', 'ACTIVE'
),
(
    'Fjällbo TV Unit FJ-1',
    'Industrial rustic metal and solid wood TV console.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-421', 6057.17, 7850.36, 21.00, '150 x 36 x 54 cm', 'Black/Pine', 24, '2026-03-16', 'ACTIVE'
),
(
    'Linnmon Table Top LM-1',
    'Pre-drilled table top for easy leg mounting.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-001-620', 880.11, 1053.01, 5.50, '120 x 60 cm', 'White', 12, '2022-09-27', 'ACTIVE'
),
(
    'Starttid Backpack BP-1',
    'Water-resistant commuter backpack with secure side pockets.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-001-982', 935.20, 1103.51, 0.55, '48 x 30 x 15 cm', 'Navy Blue', 12, '2023-04-12', 'ACTIVE'
),
(
    'Förenkla Shoulder Bag FS-1',
    'Compact messenger bag with multiple organizational dividers.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-001-708', 589.74, 690.29, 0.38, '35 x 25 x 10 cm', 'Olive Green', 12, '2025-01-22', 'ACTIVE'
),
(
    'Världens Weekend Bag VW-1',
    'Large capacity duffel bag with separate shoe compartment.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-001-309', 1769.73, 2174.19, 0.72, '50 x 32 x 22 cm', 'Dark Gray', 24, '2024-04-21', 'ACTIVE'
),
(
    'Knycklan Umbrella KU-1',
    'Windproof automatic folding umbrella with high UV protection.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-001-234', 971.69, 1190.32, 0.28, 'Folded: 28 cm', 'Black', 12, '2022-04-23', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Pärkla Storage Case PK-1',
    'Foldable textile organizer for clothes and accessories.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-001-174', 159.32, 207.96, 0.12, '55 x 49 x 19 cm', 'Transparent/Orange', 0, '2026-02-10', 'ACTIVE'
),
(
    'Canvas Tote Bag CT-1',
    'Heavy-duty reusable cotton canvas shopping bag.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-001-650', 413.15, 502.51, 0.15, '40 x 38 cm', 'Off-White', 0, '2026-02-20', 'ACTIVE'
),
(
    'Gear Performance Cap GC-1',
    'Sweat-wicking athletic cap with reflective branding.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-001-350', 769.53, 915.31, 0.08, 'Adjustable', 'White', 0, '2023-02-04', 'ACTIVE'
),
(
    'Galaxy SmartTag1',
    'Bluetooth tracking tag for luggage and keys.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-001-926', 1853.98, 2135.70, 0.02, '39 x 39 x 10 mm', 'White', 12, '2022-10-21', 'ACTIVE'
),
(
    'Active Leather Band AL-1',
    'Genuine leather watch strap compatible with standard watches.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-001-206', 2438.93, 2886.65, 0.03, '20mm Width', 'Tan Leather', 12, '2025-12-03', 'ACTIVE'
),
(
    'Galaxy Smart Ring R1',
    'Titanium smart wellness tracker with health sensor monitoring.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-001-860', 12553.22, 15290.91, 0.00, 'Size 9', 'Sleek Silver', 12, '2022-07-02', 'ACTIVE'
),
(
    'Prelude Backpack 1',
    'Padded, lightweight commuter backpack for 15.6 inch laptops.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-001-451', 1003.60, 1313.27, 0.45, '41 x 28 x 12 cm', 'Slate Black', 12, '2023-09-09', 'ACTIVE'
),
(
    'Executive Messenger Bag XM-1',
    'Professional business briefcase with RFID blocking pocket.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-001-600', 2251.12, 3099.88, 0.95, '43 x 30 x 9 cm', 'Mocha Brown', 24, '2026-01-02', 'ACTIVE'
),
(
    'Renew Business Case BC-1',
    'Eco-friendly laptop shoulder sleeve made from ocean-bound plastics.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-001-749', 1423.58, 1735.59, 0.55, '38 x 27 x 5 cm', 'Navy Blue', 12, '2024-08-26', 'ACTIVE'
),
(
    'Odyssey Backpack OD-1',
    'Sporty outdoor backpack with dedicated tech storage compartments.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-001-889', 1630.82, 2274.91, 0.90, '46 x 33 x 15 cm', 'Black/Red', 12, '2022-05-14', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Galaxy S2 Ultra',
    'Flagship smartphone with 200MP camera and embedded S Pen.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-552', 60551.68, 76108.72, 0.23, '163 x 78 x 9 mm', 'Black', 12, '2025-11-23', 'ACTIVE'
),
(
    'Galaxy S2 Plus',
    'Premium smartphone with dynamic AMOLED display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-177', 50945.05, 67387.81, 0.20, '157 x 75 x 7.6 mm', 'Lavender', 12, '2023-06-19', 'ACTIVE'
),
(
    'Galaxy Watch 2 Pro',
    'Advanced smartwatch with body composition analysis.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-136', 15834.60, 20515.74, 0.05, '45 x 45 x 10.5 mm', 'Black', 12, '2024-02-11', 'ACTIVE'
),
(
    'Galaxy Tab S2',
    'High performance productivity tablet with S Pen included.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-230', 35041.83, 43492.62, 0.58, '285 x 185 x 5.7 mm', 'Silver', 12, '2024-07-08', 'ACTIVE'
),
(
    'Galaxy Buds 2 Pro',
    'Hi-Fi wireless earbuds with active noise cancellation.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-315', 6682.07, 8798.50, 0.01, '21 x 19 x 18 mm', 'Purple', 12, '2022-02-24', 'ACTIVE'
),
(
    'QLED 4K Smart TV Q20',
    'Quantum dot LED smart television with voice control.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-673', 35884.13, 44912.37, 16.20, '1230 x 700 x 25 mm', 'Titan Gray', 24, '2025-03-13', 'ACTIVE'
),
(
    'Neo QLED 8K TV QN200',
    'State-of-the-art Neo QLED 8K display with neural processor.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-985', 120162.50, 162215.98, 22.40, '1440 x 820 x 17 mm', 'Carbon Silver', 36, '2024-03-18', 'ACTIVE'
),
(
    'Galaxy Book2 Pro',
    'Ultra-thin laptop with Intel Core i7 and AMOLED display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-125', 70179.36, 96926.25, 1.17, '355 x 225 x 11.7 mm', 'Graphite', 12, '2022-01-10', 'ACTIVE'
),
(
    'Smart Monitor M2',
    '32-inch 4K smart monitor with embedded streaming apps.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-002-785', 18864.06, 25517.17, 6.50, '713 x 420 x 220 mm', 'Sunset Pink', 24, '2025-08-18', 'ACTIVE'
),
(
    'UltraWide IPS Monitor 2WN',
    'Ultra-wide screen monitor with sRGB 99% color calibration.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-002-906', 15701.28, 19558.07, 5.20, '698 x 411 x 209 mm', 'Black', 36, '2021-09-16', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'UltraGear Gaming Monitor 2GN',
    'Nano IPS gaming monitor with 1ms response and 144Hz refresh.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-002-581', 24222.43, 32800.72, 7.20, '614 x 575 x 291 mm', 'Black/Red', 36, '2024-07-24', 'ACTIVE'
),
(
    'Gram 2-inch Laptop',
    'Ultra-lightweight laptop with large capacity battery.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-002-412', 55820.54, 76353.05, 0.99, '312 x 214 x 16.8 mm', 'Obsidian Black', 12, '2026-05-23', 'ACTIVE'
),
(
    'OLED evo C2 Smart TV',
    'Self-lit OLED pixels providing infinite contrast and webOS.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-002-775', 80193.13, 98803.19, 18.90, '1228 x 708 x 45 mm', 'Metallic Silver', 24, '2022-03-10', 'ACTIVE'
),
(
    'CineBeam 4K Projector HU2',
    'Smart home theater laser projector with HDR10.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-002-385', 95351.15, 121796.93, 6.50, '337 x 276 x 110 mm', 'White', 24, '2026-05-15', 'ACTIVE'
),
(
    'Tone Free T2 Earbuds',
    'Wireless earbuds with Meridian Sound and UVnano charging case.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-002-218', 5877.04, 7142.39, 0.01, '21 x 16 x 25 mm', 'Glossy White', 12, '2026-04-23', 'ACTIVE'
),
(
    'Latitude 2',
    'Enterprise business laptop designed for high durability.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-211', 50596.57, 62558.70, 1.37, '321 x 212 x 19.3 mm', 'Carbon Gray', 36, '2024-01-29', 'ACTIVE'
),
(
    'Inspiron 2',
    'Everyday consumer laptop with responsive performance.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-720', 35984.24, 42422.23, 1.65, '358 x 235 x 18.9 mm', 'Platinum Silver', 12, '2025-02-04', 'ACTIVE'
),
(
    'XPS 2 Developer Edition',
    'Premium ultra-portable laptop with infinity-edge display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-145', 85708.79, 98601.35, 1.24, '295 x 199 x 13.9 mm', 'Platinum', 24, '2024-06-25', 'ACTIVE'
),
(
    'Vostro 2',
    'Essential business laptop with hardware-based security.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-541', 32069.97, 42205.99, 1.70, '356 x 230 x 19.0 mm', 'Accent Black', 12, '2023-01-11', 'ACTIVE'
),
(
    'Precision 2 Workstation',
    'Professional ISV-certified workstation for heavy rendering.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-421', 95663.39, 112993.42, 2.10, '375 x 250 x 22.0 mm', 'Titanium Gray', 36, '2023-09-06', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Alienware m2 Gaming Laptop',
    'High-end gaming laptop with cryo-tech cooling system.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-416', 110666.89, 136291.34, 2.69, '399 x 294 x 23.0 mm', 'Dark Side of the Moon', 24, '2023-06-01', 'ACTIVE'
),
(
    'UltraSharp U2QE Monitor',
    '4K hub monitor with IPS Black technology and RJ45.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-230', 22191.84, 29209.62, 6.60, '611 x 385 x 185 mm', 'Platinum Silver', 36, '2022-09-22', 'ACTIVE'
),
(
    'Dell Pro Wireless Keyboard KM2',
    'Multi-device wireless keyboard and mouse combo.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-866', 3402.81, 4436.85, 0.65, '433 x 123 x 34 mm', 'Titan Gray', 36, '2024-03-31', 'ACTIVE'
),
(
    'Dell Thunderbolt Dock WD2',
    'High power delivery docking station with multiple display outputs.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-002-661', 12833.73, 15733.75, 0.58, '205 x 90 x 29 mm', 'Black', 36, '2024-02-11', 'ACTIVE'
),
(
    'Pavilion Aero 2',
    'Featherweight magnesium alloy laptop with AMD Ryzen processor.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-904', 42579.98, 55936.32, 0.96, '297 x 209 x 16.9 mm', 'Warm Gold', 12, '2024-01-18', 'ACTIVE'
),
(
    'Envy x360 2',
    'Convertible 2-in-1 laptop with touchscreen and stylus support.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-552', 60675.63, 77530.93, 1.34, '306 x 214 x 16.1 mm', 'Nightfall Black', 12, '2022-10-30', 'ACTIVE'
),
(
    'Spectre x360 2',
    'Premium gem-cut convertible laptop with OLED touch display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-186', 90283.79, 118810.17, 1.36, '298 x 220 x 16.9 mm', 'Nightfall Black', 24, '2025-12-31', 'ACTIVE'
),
(
    'LaserJet Pro MFP 2',
    'Monochrome multifunction laser printer for offices.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-938', 15952.00, 19281.46, 9.50, '390 x 360 x 255 mm', 'White/Slate', 12, '2025-04-06', 'ACTIVE'
),
(
    'Smart Tank 2 Wireless',
    'High capacity refillable ink tank printer.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-925', 9199.13, 10635.17, 5.10, '447 x 373 x 158 mm', 'Dark Basalt', 12, '2023-11-10', 'ACTIVE'
),
(
    'Omen 2 Gaming Laptop',
    'High-performance gaming laptop with advanced Omen Tempest cooling.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-725', 75849.74, 88608.20, 2.35, '369 x 248 x 23.0 mm', 'Shadow Black', 12, '2022-12-29', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'HP EliteBook 2 G9',
    'Elite business laptop with enterprise manageability.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-689', 65194.44, 86323.21, 1.35, '315 x 224 x 19.2 mm', 'Pike Silver', 36, '2024-04-13', 'ACTIVE'
),
(
    'HP Bluetooth Travel Mouse 2',
    'Compact five-button customizable wireless mouse.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-002-349', 1347.57, 1781.36, 0.08, '101 x 65 x 32 mm', 'Black', 12, '2022-02-27', 'ACTIVE'
),
(
    'Bespoke Refrigerator RT2B',
    'Customizable double-door refrigerator with Digital Inverter.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-002-535', 30218.84, 40826.48, 68.00, '600 x 672 x 1715 mm', 'Cotta Navy', 12, '2026-03-30', 'ACTIVE'
),
(
    'WindFree Split AC AR2',
    'Split air conditioner with 23000 micro-holes for draft-free cooling.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-002-670', 28249.20, 38477.79, 41.00, '889 x 299 x 215 mm', 'White', 12, '2025-10-10', 'ACTIVE'
),
(
    'Bespoke Front Load Washer WW2',
    'Smart washer with AI Ecobubble and hygiene steam.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-002-920', 25464.64, 32665.61, 65.00, '600 x 850 x 550 mm', 'Clean Charcoal', 24, '2022-04-16', 'ACTIVE'
),
(
    'Convection Microwave MC2',
    'Convection microwave oven with Slim Fry and HotBlast tech.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-002-553', 9612.65, 12783.08, 19.00, '517 x 310 x 463 mm', 'Black Glass', 12, '2021-11-12', 'ACTIVE'
),
(
    'Samsung Air Purifier AX2',
    'Multi-layered purification system with HEPA filter.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-002-661', 7945.91, 9453.96, 6.20, '361 x 481 x 263 mm', 'Clay Beige', 12, '2024-01-01', 'ACTIVE'
),
(
    'InstaView Door-in-Door Fridge GL-X2',
    'Knock twice on glass panel to view contents without opening.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-002-365', 75751.78, 103019.82, 120.00, '912 x 1790 x 738 mm', 'Matte Black', 24, '2022-03-25', 'ACTIVE'
),
(
    'AI DD Front Load Washer F2',
    'Intelligent washing machine with Direct Drive motor.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-002-896', 24521.30, 32041.67, 70.00, '600 x 850 x 565 mm', 'Platinum Silver', 36, '2024-01-22', 'ACTIVE'
),
(
    'Dual Inverter AC TS-Q2',
    'Super convertible split air conditioner with dual rotary compressor.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-002-179', 26713.54, 32286.61, 42.50, '837 x 308 x 189 mm', 'White', 12, '2024-09-24', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'NeoChef Convection Microwave MH2',
    'Smart inverter microwave oven with uniform heating.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-002-653', 8580.58, 10191.22, 13.00, '476 x 272 x 388 mm', 'Noble Silver', 12, '2022-08-19', 'ACTIVE'
),
(
    'PuriCare Air Purifier AS2',
    '360-degree air purifier with clean booster fan.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-002-256', 22706.42, 26476.98, 11.50, '343 x 343 x 587 mm', 'White', 24, '2024-09-01', 'ACTIVE'
),
(
    'CordZero A2 Cordless Vacuum',
    'Handstick vacuum cleaner with dual power pack batteries.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-002-655', 18465.92, 21523.26, 2.70, '260 x 270 x 1120 mm', 'Iron Gray', 12, '2024-05-04', 'ACTIVE'
),
(
    'Poäng Armchair PA-2',
    'Classic layer-bent birch frame armchair with high back support.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-888', 4084.08, 5406.83, 8.50, '68 x 82 x 100 cm', 'Knisa Black', 120, '2023-11-07', 'ACTIVE'
),
(
    'Kallax Shelf Unit KX-2',
    'Cube structure shelving unit, can be oriented vertically or horizontally.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-106', 3742.74, 4583.56, 18.00, '77 x 147 cm', 'Black-Brown', 24, '2021-09-27', 'ACTIVE'
),
(
    'Malm Desk MD-2',
    'Sleek desk with clean lines and pull-out panel for keyboard.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-955', 6919.02, 9249.89, 27.50, '151 x 65 x 73 cm', 'White', 60, '2023-10-15', 'ACTIVE'
),
(
    'Billy Bookcase BY-2',
    'Highly adjustable shelves bookcase, the benchmark in utility design.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-324', 2472.94, 3144.12, 14.50, '80 x 28 x 202 cm', 'Oak Veneer', 12, '2024-08-21', 'ACTIVE'
),
(
    'Ektorp 2-Seat Sofa',
    'Durable sofa with comfortable back cushions and machine washable covers.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-784', 18679.14, 23369.08, 65.00, '218 x 88 x 88 cm', 'Hallarp Beige', 120, '2021-10-23', 'ACTIVE'
),
(
    'Lack Side Table LK-2',
    'Lightweight, easy to assemble side table for living room spaces.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-578', 1519.54, 2120.03, 3.80, '55 x 55 x 45 cm', 'Oak', 12, '2026-05-16', 'ACTIVE'
),
(
    'Ingatorp Table IT-2',
    'Extendable dining table with 1 extra leaf, seats 4-6.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-503', 12591.89, 16567.78, 44.00, '155 x 87 x 74 cm', 'Black', 60, '2022-12-02', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Renberget Office Chair RC-2',
    'Adjustable office swivel chair with tilt tension control.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-538', 2635.70, 3335.28, 12.00, '59 x 65 x 108 cm', 'Bomstad Black', 24, '2025-01-24', 'ACTIVE'
),
(
    'Pax Wardrobe System PX-2',
    'Modular wardrobe frame with soft closing hinge doors.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-488', 15327.35, 19368.79, 85.00, '150 x 60 x 236 cm', 'White', 120, '2022-04-04', 'ACTIVE'
),
(
    'Hemnes Coffee Table HC-2',
    'Solid pine coffee table with a separate shelf for magazines.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-384', 5752.01, 7811.12, 17.00, '90 x 90 x 46 cm', 'Black-Brown', 60, '2021-11-04', 'ACTIVE'
),
(
    'Bekant Standing Desk BS-2',
    'Motorized height adjustable sit/stand desk for ergonomic workspace.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-183', 20470.31, 27374.05, 32.00, '160 x 80 cm', 'White/Black Frame', 120, '2024-07-24', 'ACTIVE'
),
(
    'Fjällbo TV Unit FJ-2',
    'Industrial rustic metal and solid wood TV console.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-329', 6650.14, 8946.49, 21.00, '150 x 36 x 54 cm', 'Black/Pine', 24, '2022-04-18', 'ACTIVE'
),
(
    'Linnmon Table Top LM-2',
    'Pre-drilled table top for easy leg mounting.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-002-131', 1749.61, 2099.25, 5.50, '120 x 60 cm', 'White', 12, '2023-01-15', 'ACTIVE'
),
(
    'Starttid Backpack BP-2',
    'Water-resistant commuter backpack with secure side pockets.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-002-256', 938.54, 1190.43, 0.55, '48 x 30 x 15 cm', 'Navy Blue', 12, '2023-05-12', 'ACTIVE'
),
(
    'Förenkla Shoulder Bag FS-2',
    'Compact messenger bag with multiple organizational dividers.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-002-323', 1015.03, 1232.31, 0.38, '35 x 25 x 10 cm', 'Olive Green', 12, '2025-08-01', 'ACTIVE'
),
(
    'Världens Weekend Bag VW-2',
    'Large capacity duffel bag with separate shoe compartment.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-002-720', 1707.25, 2282.56, 0.72, '50 x 32 x 22 cm', 'Dark Gray', 24, '2022-03-01', 'ACTIVE'
),
(
    'Knycklan Umbrella KU-2',
    'Windproof automatic folding umbrella with high UV protection.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-002-938', 463.77, 569.40, 0.28, 'Folded: 28 cm', 'Yellow', 12, '2024-10-10', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Pärkla Storage Case PK-2',
    'Foldable textile organizer for clothes and accessories.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-002-689', 827.35, 1149.64, 0.12, '55 x 49 x 19 cm', 'Transparent/Orange', 0, '2022-07-07', 'ACTIVE'
),
(
    'Canvas Tote Bag CT-2',
    'Heavy-duty reusable cotton canvas shopping bag.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-002-303', 276.00, 365.05, 0.15, '40 x 38 cm', 'Off-White', 0, '2025-12-14', 'ACTIVE'
),
(
    'Gear Performance Cap GC-2',
    'Sweat-wicking athletic cap with reflective branding.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-002-813', 1172.48, 1597.59, 0.08, 'Adjustable', 'Black', 0, '2022-01-22', 'ACTIVE'
),
(
    'Galaxy SmartTag2',
    'Bluetooth tracking tag for luggage and keys.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-002-679', 1982.64, 2452.13, 0.02, '39 x 39 x 10 mm', 'White', 12, '2022-10-25', 'ACTIVE'
),
(
    'Active Leather Band AL-2',
    'Genuine leather watch strap compatible with standard watches.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-002-479', 1568.96, 2058.30, 0.03, '20mm Width', 'Tan Leather', 12, '2021-10-05', 'ACTIVE'
),
(
    'Galaxy Smart Ring R2',
    'Titanium smart wellness tracker with health sensor monitoring.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-FA-002-530', 12822.33, 15083.99, 0.00, 'Size 9', 'Matte Black', 12, '2022-12-17', 'ACTIVE'
),
(
    'Prelude Backpack 2',
    'Padded, lightweight commuter backpack for 15.6 inch laptops.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-002-948', 1259.74, 1496.88, 0.45, '41 x 28 x 12 cm', 'Slate Black', 12, '2022-05-30', 'ACTIVE'
),
(
    'Executive Messenger Bag XM-2',
    'Professional business briefcase with RFID blocking pocket.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-002-634', 2965.47, 3610.52, 0.95, '43 x 30 x 9 cm', 'Black', 24, '2023-12-01', 'ACTIVE'
),
(
    'Renew Business Case BC-2',
    'Eco-friendly laptop shoulder sleeve made from ocean-bound plastics.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-002-546', 1825.73, 2370.01, 0.55, '38 x 27 x 5 cm', 'Navy Blue', 12, '2021-09-30', 'ACTIVE'
),
(
    'Odyssey Backpack OD-2',
    'Sporty outdoor backpack with dedicated tech storage compartments.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-FA-002-351', 2330.73, 2730.84, 0.90, '46 x 33 x 15 cm', 'Gray/Green', 12, '2025-02-26', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Galaxy S3 Ultra',
    'Flagship smartphone with 200MP camera and embedded S Pen.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-868', 60464.71, 78760.30, 0.23, '163 x 78 x 9 mm', 'Green', 12, '2024-08-21', 'ACTIVE'
),
(
    'Galaxy S3 Plus',
    'Premium smartphone with dynamic AMOLED display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-129', 50494.31, 62171.30, 0.20, '157 x 75 x 7.6 mm', 'Gray', 12, '2025-05-02', 'ACTIVE'
),
(
    'Galaxy Watch 3 Pro',
    'Advanced smartwatch with body composition analysis.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-463', 15797.83, 19511.66, 0.05, '45 x 45 x 10.5 mm', 'Titanium', 12, '2023-05-29', 'ACTIVE'
),
(
    'Galaxy Tab S3',
    'High performance productivity tablet with S Pen included.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-110', 35516.63, 42540.54, 0.58, '285 x 185 x 5.7 mm', 'Silver', 12, '2022-06-27', 'ACTIVE'
),
(
    'Galaxy Buds 3 Pro',
    'Hi-Fi wireless earbuds with active noise cancellation.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-516', 6488.58, 8691.72, 0.01, '21 x 19 x 18 mm', 'Graphite', 12, '2023-11-08', 'ACTIVE'
),
(
    'QLED 4K Smart TV Q30',
    'Quantum dot LED smart television with voice control.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-761', 35711.84, 45069.90, 16.20, '1230 x 700 x 25 mm', 'Titan Gray', 24, '2026-01-01', 'ACTIVE'
),
(
    'Neo QLED 8K TV QN300',
    'State-of-the-art Neo QLED 8K display with neural processor.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-401', 120221.60, 159046.78, 22.40, '1440 x 820 x 17 mm', 'Carbon Silver', 36, '2022-10-20', 'ACTIVE'
),
(
    'Galaxy Book3 Pro',
    'Ultra-thin laptop with Intel Core i7 and AMOLED display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-695', 70369.02, 90661.21, 1.17, '355 x 225 x 11.7 mm', 'Graphite', 12, '2024-02-20', 'ACTIVE'
),
(
    'Smart Monitor M3',
    '32-inch 4K smart monitor with embedded streaming apps.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-EL-003-863', 18550.39, 22964.50, 6.50, '713 x 420 x 220 mm', 'Sunset Pink', 24, '2025-01-02', 'ACTIVE'
),
(
    'UltraWide IPS Monitor 3WN',
    'Ultra-wide screen monitor with sRGB 99% color calibration.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-003-413', 15251.40, 17999.15, 5.20, '698 x 411 x 209 mm', 'Black', 36, '2024-10-02', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'UltraGear Gaming Monitor 3GN',
    'Nano IPS gaming monitor with 1ms response and 144Hz refresh.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-003-222', 24742.88, 34336.17, 7.20, '614 x 575 x 291 mm', 'Black/Red', 36, '2025-06-13', 'ACTIVE'
),
(
    'Gram 3-inch Laptop',
    'Ultra-lightweight laptop with large capacity battery.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-003-321', 55738.60, 67952.32, 0.99, '312 x 214 x 16.8 mm', 'Snow White', 12, '2025-12-17', 'ACTIVE'
),
(
    'OLED evo C3 Smart TV',
    'Self-lit OLED pixels providing infinite contrast and webOS.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-003-952', 80194.12, 96783.94, 18.90, '1228 x 708 x 45 mm', 'Metallic Silver', 24, '2024-10-29', 'ACTIVE'
),
(
    'CineBeam 4K Projector HU3',
    'Smart home theater laser projector with HDR10.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-003-114', 95708.02, 113092.97, 6.50, '337 x 276 x 110 mm', 'White', 24, '2026-03-21', 'ACTIVE'
),
(
    'Tone Free T3 Earbuds',
    'Wireless earbuds with Meridian Sound and UVnano charging case.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-EL-003-666', 5292.14, 7335.02, 0.01, '21 x 16 x 25 mm', 'Glossy White', 12, '2025-12-12', 'ACTIVE'
),
(
    'Latitude 3',
    'Enterprise business laptop designed for high durability.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-993', 50012.27, 61069.22, 1.37, '321 x 212 x 19.3 mm', 'Carbon Gray', 36, '2024-01-20', 'ACTIVE'
),
(
    'Inspiron 3',
    'Everyday consumer laptop with responsive performance.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-448', 35184.36, 40913.93, 1.65, '358 x 235 x 18.9 mm', 'Carbon Black', 12, '2025-11-19', 'ACTIVE'
),
(
    'XPS 3 Developer Edition',
    'Premium ultra-portable laptop with infinity-edge display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-941', 85065.34, 108282.79, 1.24, '295 x 199 x 13.9 mm', 'Platinum', 24, '2025-09-03', 'ACTIVE'
),
(
    'Vostro 3',
    'Essential business laptop with hardware-based security.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-252', 32811.14, 45518.28, 1.70, '356 x 230 x 19.0 mm', 'Accent Black', 12, '2025-02-17', 'ACTIVE'
),
(
    'Precision 3 Workstation',
    'Professional ISV-certified workstation for heavy rendering.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-221', 95558.07, 119833.98, 2.10, '375 x 250 x 22.0 mm', 'Titanium Gray', 36, '2022-03-05', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Alienware m3 Gaming Laptop',
    'High-end gaming laptop with cryo-tech cooling system.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-635', 110380.38, 152007.70, 2.69, '399 x 294 x 23.0 mm', 'Dark Side of the Moon', 24, '2021-09-13', 'ACTIVE'
),
(
    'UltraSharp U3QE Monitor',
    '4K hub monitor with IPS Black technology and RJ45.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-702', 22990.03, 28193.71, 6.60, '611 x 385 x 185 mm', 'Platinum Silver', 36, '2023-02-08', 'ACTIVE'
),
(
    'Dell Pro Wireless Keyboard KM3',
    'Multi-device wireless keyboard and mouse combo.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-857', 2599.23, 3484.75, 0.65, '433 x 123 x 34 mm', 'Titan Gray', 36, '2025-01-15', 'ACTIVE'
),
(
    'Dell Thunderbolt Dock WD3',
    'High power delivery docking station with multiple display outputs.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Dell India'),
    'Dell', 'DEL-EL-003-776', 12081.19, 14617.83, 0.58, '205 x 90 x 29 mm', 'Black', 36, '2025-08-24', 'ACTIVE'
),
(
    'Pavilion Aero 3',
    'Featherweight magnesium alloy laptop with AMD Ryzen processor.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-102', 42408.52, 56078.60, 0.96, '297 x 209 x 16.9 mm', 'Warm Gold', 12, '2024-11-21', 'ACTIVE'
),
(
    'Envy x360 3',
    'Convertible 2-in-1 laptop with touchscreen and stylus support.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-133', 60231.48, 79911.45, 1.34, '306 x 214 x 16.1 mm', 'Nightfall Black', 12, '2026-02-15', 'ACTIVE'
),
(
    'Spectre x360 3',
    'Premium gem-cut convertible laptop with OLED touch display.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-803', 90233.42, 109736.35, 1.36, '298 x 220 x 16.9 mm', 'Poseidon Blue', 24, '2024-02-21', 'ACTIVE'
),
(
    'LaserJet Pro MFP 3',
    'Monochrome multifunction laser printer for offices.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-217', 15544.56, 20393.04, 9.50, '390 x 360 x 255 mm', 'White/Slate', 12, '2021-11-21', 'ACTIVE'
),
(
    'Smart Tank 3 Wireless',
    'High capacity refillable ink tank printer.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-245', 9071.41, 10808.41, 5.10, '447 x 373 x 158 mm', 'Dark Basalt', 12, '2023-03-10', 'ACTIVE'
),
(
    'Omen 3 Gaming Laptop',
    'High-performance gaming laptop with advanced Omen Tempest cooling.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-866', 75824.24, 104660.06, 2.35, '369 x 248 x 23.0 mm', 'Shadow Black', 12, '2025-10-29', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'HP EliteBook 3 G9',
    'Elite business laptop with enterprise manageability.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-579', 65688.68, 87033.13, 1.35, '315 x 224 x 19.2 mm', 'Pike Silver', 36, '2023-09-20', 'ACTIVE'
),
(
    'HP Bluetooth Travel Mouse 3',
    'Compact five-button customizable wireless mouse.',
    (SELECT category_id FROM categories WHERE category_name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'HP India'),
    'HP', 'HP-EL-003-652', 1693.80, 1981.93, 0.08, '101 x 65 x 32 mm', 'Black', 12, '2024-02-07', 'ACTIVE'
),
(
    'Bespoke Refrigerator RT3B',
    'Customizable double-door refrigerator with Digital Inverter.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-003-852', 30322.32, 36768.60, 68.00, '600 x 672 x 1715 mm', 'Clean White', 12, '2025-03-29', 'ACTIVE'
),
(
    'WindFree Split AC AR3',
    'Split air conditioner with 23000 micro-holes for draft-free cooling.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-003-790', 28835.96, 37307.96, 41.00, '889 x 299 x 215 mm', 'White', 12, '2022-03-27', 'ACTIVE'
),
(
    'Bespoke Front Load Washer WW3',
    'Smart washer with AI Ecobubble and hygiene steam.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-003-788', 25821.42, 33414.51, 65.00, '600 x 850 x 550 mm', 'Clean Charcoal', 24, '2023-11-20', 'ACTIVE'
),
(
    'Convection Microwave MC3',
    'Convection microwave oven with Slim Fry and HotBlast tech.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-003-631', 9651.51, 13309.61, 19.00, '517 x 310 x 463 mm', 'Black Glass', 12, '2023-03-30', 'ACTIVE'
),
(
    'Samsung Air Purifier AX3',
    'Multi-layered purification system with HEPA filter.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'Samsung India'),
    'Samsung', 'SAM-HO-003-546', 8134.78, 10355.02, 6.20, '361 x 481 x 263 mm', 'Clay Beige', 12, '2023-11-21', 'ACTIVE'
),
(
    'InstaView Door-in-Door Fridge GL-X3',
    'Knock twice on glass panel to view contents without opening.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-003-456', 75408.35, 92772.22, 120.00, '912 x 1790 x 738 mm', 'Matte Black', 24, '2021-09-18', 'ACTIVE'
),
(
    'AI DD Front Load Washer F3',
    'Intelligent washing machine with Direct Drive motor.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-003-264', 24329.80, 32198.51, 70.00, '600 x 850 x 565 mm', 'Platinum Silver', 36, '2022-10-23', 'ACTIVE'
),
(
    'Dual Inverter AC TS-Q3',
    'Super convertible split air conditioner with dual rotary compressor.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-003-510', 26813.57, 34523.12, 42.50, '837 x 308 x 189 mm', 'White', 12, '2026-01-11', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'NeoChef Convection Microwave MH3',
    'Smart inverter microwave oven with uniform heating.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-003-422', 8752.40, 10318.91, 13.00, '476 x 272 x 388 mm', 'Noble Silver', 12, '2021-09-03', 'ACTIVE'
),
(
    'PuriCare Air Purifier AS3',
    '360-degree air purifier with clean booster fan.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-003-626', 22824.93, 26255.24, 11.50, '343 x 343 x 587 mm', 'White', 24, '2024-03-16', 'ACTIVE'
),
(
    'CordZero A3 Cordless Vacuum',
    'Handstick vacuum cleaner with dual power pack batteries.',
    (SELECT category_id FROM categories WHERE category_name = 'Home Appliances'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'LG Electronics'),
    'LG', 'LG-HO-003-155', 18187.58, 22560.69, 2.70, '260 x 270 x 1120 mm', 'Iron Gray', 12, '2023-01-07', 'ACTIVE'
),
(
    'Poäng Armchair PA-3',
    'Classic layer-bent birch frame armchair with high back support.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-552', 4259.99, 5115.78, 8.50, '68 x 82 x 100 cm', 'Hillared Beige', 120, '2024-11-28', 'ACTIVE'
),
(
    'Kallax Shelf Unit KX-3',
    'Cube structure shelving unit, can be oriented vertically or horizontally.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-548', 3680.85, 4679.02, 18.00, '77 x 147 cm', 'White', 24, '2022-12-28', 'ACTIVE'
),
(
    'Malm Desk MD-3',
    'Sleek desk with clean lines and pull-out panel for keyboard.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-723', 7299.31, 9689.44, 27.50, '151 x 65 x 73 cm', 'Brown Veneer', 60, '2023-06-08', 'ACTIVE'
),
(
    'Billy Bookcase BY-3',
    'Highly adjustable shelves bookcase, the benchmark in utility design.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-114', 2752.25, 3229.22, 14.50, '80 x 28 x 202 cm', 'White', 12, '2023-12-08', 'ACTIVE'
),
(
    'Ektorp 3-Seat Sofa',
    'Durable sofa with comfortable back cushions and machine washable covers.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-220', 18647.71, 22162.67, 65.00, '218 x 88 x 88 cm', 'Virestad Red', 120, '2023-09-02', 'ACTIVE'
),
(
    'Lack Side Table LK-3',
    'Lightweight, easy to assemble side table for living room spaces.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-822', 873.42, 1186.70, 3.80, '55 x 55 x 45 cm', 'White', 12, '2025-02-26', 'ACTIVE'
),
(
    'Ingatorp Table IT-3',
    'Extendable dining table with 1 extra leaf, seats 4-6.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-567', 12551.27, 15637.58, 44.00, '155 x 87 x 74 cm', 'Black', 60, '2021-09-05', 'ACTIVE'
);

INSERT INTO products (
    product_name, description, category_id, supplier_id, brand, sku, 
    cost_price, selling_price, weight, dimensions, color, warranty_months, launch_date, status
) VALUES
(
    'Renberget Office Chair RC-3',
    'Adjustable office swivel chair with tilt tension control.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-171', 2776.25, 3741.00, 12.00, '59 x 65 x 108 cm', 'Bomstad Black', 24, '2024-08-13', 'ACTIVE'
),
(
    'Pax Wardrobe System PX-3',
    'Modular wardrobe frame with soft closing hinge doors.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-906', 15507.74, 21015.12, 85.00, '150 x 60 x 236 cm', 'White', 120, '2022-06-15', 'ACTIVE'
),
(
    'Hemnes Coffee Table HC-3',
    'Solid pine coffee table with a separate shelf for magazines.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-405', 5837.48, 7559.42, 17.00, '90 x 90 x 46 cm', 'Black-Brown', 60, '2021-09-02', 'ACTIVE'
),
(
    'Bekant Standing Desk BS-3',
    'Motorized height adjustable sit/stand desk for ergonomic workspace.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-252', 20446.55, 25989.31, 32.00, '160 x 80 cm', 'White/Black Frame', 120, '2023-06-06', 'ACTIVE'
),
(
    'Fjällbo TV Unit FJ-3',
    'Industrial rustic metal and solid wood TV console.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-881', 6543.43, 8269.82, 21.00, '150 x 36 x 54 cm', 'Black/Pine', 24, '2021-08-25', 'ACTIVE'
),
(
    'Linnmon Table Top LM-3',
    'Pre-drilled table top for easy leg mounting.',
    (SELECT category_id FROM categories WHERE category_name = 'Furniture'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FU-003-293', 1780.77, 2154.20, 5.50, '120 x 60 cm', 'Light Gray', 12, '2025-03-19', 'ACTIVE'
),
(
    'Starttid Backpack BP-3',
    'Water-resistant commuter backpack with secure side pockets.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-003-976', 1475.54, 1712.97, 0.55, '48 x 30 x 15 cm', 'Dull Gray', 12, '2022-07-27', 'ACTIVE'
),
(
    'Förenkla Shoulder Bag FS-3',
    'Compact messenger bag with multiple organizational dividers.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-003-930', 931.23, 1301.02, 0.38, '35 x 25 x 10 cm', 'Black', 12, '2023-09-30', 'ACTIVE'
),
(
    'Världens Weekend Bag VW-3',
    'Large capacity duffel bag with separate shoe compartment.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-003-137', 1226.25, 1706.13, 0.72, '50 x 32 x 22 cm', 'Dark Gray', 24, '2021-08-24', 'ACTIVE'
),
(
    'Knycklan Umbrella KU-3',
    'Windproof automatic folding umbrella with high UV protection.',
    (SELECT category_id FROM categories WHERE category_name = 'Fashion'),
    (SELECT supplier_id FROM suppliers WHERE supplier_name = 'IKEA India'),
    'IKEA', 'IKE-FA-003-202', 1174.19, 1479.57, 0.28, 'Folded: 28 cm', 'Black', 12, '2026-06-09', 'ACTIVE'
);

SELECT 'Data seeding completed successfully with ' || (SELECT COUNT(*) FROM products) || ' products.' AS info;
