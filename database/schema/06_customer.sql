/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 3

Module:
Database Infrastructure - Customer Operational Table

Author:
Sanjana

Description:
Creates the customers table, applies unique constraints,
indexes for common queries, and populates 500 records.

======================================================
*/

-- Ensure we are connected to the correct database
-- \c enterprise_ai_platform;

-- 1. Create Table
CREATE TABLE IF NOT EXISTS customers (
    customer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    customer_type VARCHAR(50) NOT NULL DEFAULT 'Regular',
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'India',
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Constraints
ALTER TABLE customers
    ADD CONSTRAINT uq_customers_email UNIQUE (email),
    ADD CONSTRAINT chk_customers_type CHECK (customer_type IN ('Regular', 'Premium', 'Business')),
    ADD CONSTRAINT chk_customers_status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    ADD CONSTRAINT chk_customers_email_fmt CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

-- 3. Trigger for Auto-timestamps
CREATE TRIGGER tr_update_customers_timestamp
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION fn_update_timestamp_column();

-- 4. Indexes
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers (email);
CREATE INDEX IF NOT EXISTS idx_customers_city ON customers (city);
CREATE INDEX IF NOT EXISTS idx_customers_type ON customers (customer_type);

-- 5. Seed Data (500 Customers)
SELECT 'Seeding 500 customers...' AS info;

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Kavita', 'Mehta', 'kavita.mehta1@novamart.com', '+91-99765-80677', '1990-06-23', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2025-04-12', 'ACTIVE'),
('Rakesh', 'Kulkarni', 'rakesh.kulkarni2@novamart.com', '+91-80781-67407', '2003-05-30', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-07-06', 'ACTIVE'),
('Ajay', 'Patil', 'ajay.patil3@novamart.com', '+91-77825-93548', '1988-06-12', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-10-25', 'ACTIVE'),
('Aishwarya', 'Srinivasan', 'aishwarya.srinivasan4@novamart.com', '+91-92287-53061', '1976-09-29', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-03-28', 'ACTIVE'),
('Pooja', 'Kapoor', 'pooja.kapoor5@novamart.com', '+91-70213-70831', '1996-11-04', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-06-11', 'ACTIVE'),
('Aarav', 'Chatterjee', 'aarav.chatterjee6@novamart.com', '+91-88494-30102', '2005-01-05', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-04-03', 'ACTIVE'),
('Kiran', 'Gavade', 'kiran.gavade7@novamart.com', '+91-99373-95509', '1981-01-14', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-10-11', 'ACTIVE'),
('Kiara', 'Bose', 'kiara.bose8@novamart.com', '+91-92395-10779', '2002-10-17', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-01-17', 'ACTIVE'),
('Rohan', 'Srinivasan', 'rohan.srinivasan9@novamart.com', '+91-95378-89356', '1985-11-26', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-05-25', 'ACTIVE'),
('Lakshmi', 'Bhat', 'lakshmi.bhat10@novamart.com', '+91-99149-28272', '2002-12-03', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2024-06-02', 'ACTIVE'),
('Lakshmi', 'Grewal', 'lakshmi.grewal11@novamart.com', '+91-92583-55924', '1985-10-17', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-01-06', 'ACTIVE'),
('Diya', 'Chatterjee', 'diya.chatterjee12@novamart.com', '+91-85273-36796', '1987-07-03', 'Male', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2025-02-25', 'ACTIVE'),
('Aishwarya', 'Joshi', 'aishwarya.joshi13@novamart.com', '+91-70396-11853', '1978-03-03', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2026-04-10', 'ACTIVE'),
('Dev', 'Sen', 'dev.sen14@novamart.com', '+91-85442-96561', '1997-10-13', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-06-03', 'ACTIVE'),
('Priya', 'Shinde', 'priya.shinde15@novamart.com', '+91-92245-57754', '1988-06-23', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-08-18', 'ACTIVE'),
('Diya', 'Singh', 'diya.singh16@novamart.com', '+91-74779-54891', '2001-02-12', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-06-24', 'ACTIVE'),
('Abhishek', 'Grewal', 'abhishek.grewal17@novamart.com', '+91-76846-26714', '1986-01-01', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-02-02', 'ACTIVE'),
('Karan', 'Kulkarni', 'karan.kulkarni18@novamart.com', '+91-84906-48914', '1972-11-10', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-01-24', 'ACTIVE'),
('Vihaan', 'Sen', 'vihaan.sen19@novamart.com', '+91-88112-36799', '2005-01-20', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2026-03-13', 'ACTIVE'),
('Sanjay', 'Sen', 'sanjay.sen20@novamart.com', '+91-95232-90799', '2000-02-17', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2026-04-29', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Amit', 'Sidhu', 'amit.sidhu21@novamart.com', '+91-90914-25883', '1975-07-24', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-08-15', 'ACTIVE'),
('Arjun', 'Iyengar', 'arjun.iyengar22@novamart.com', '+91-85386-64676', '2001-09-09', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-07-18', 'ACTIVE'),
('Ishan', 'Mehta', 'ishan.mehta23@novamart.com', '+91-91339-30716', '1998-11-06', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-01-03', 'ACTIVE'),
('Aadya', 'Bose', 'aadya.bose24@novamart.com', '+91-93439-99575', '1983-08-20', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2026-06-15', 'ACTIVE'),
('Manish', 'Iyer', 'manish.iyer25@novamart.com', '+91-88903-96477', '1984-12-27', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-01-04', 'ACTIVE'),
('Jyoti', 'Srinivasan', 'jyoti.srinivasan26@novamart.com', '+91-89742-21967', '1994-03-19', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-11-14', 'ACTIVE'),
('Sunita', 'Gupta', 'sunita.gupta27@novamart.com', '+91-73155-48958', '1993-08-20', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-05-24', 'ACTIVE'),
('Jyoti', 'More', 'jyoti.more28@novamart.com', '+91-92841-14249', '1995-10-17', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-02-27', 'ACTIVE'),
('Diya', 'Sidhu', 'diya.sidhu29@novamart.com', '+91-75381-74946', '1986-11-14', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-05-16', 'ACTIVE'),
('Aadya', 'More', 'aadya.more30@novamart.com', '+91-95477-15043', '1996-07-07', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-10-20', 'ACTIVE'),
('Deepak', 'Srinivasan', 'deepak.srinivasan31@novamart.com', '+91-82101-70045', '1978-11-19', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-12-25', 'ACTIVE'),
('Sai', 'Joshi', 'sai.joshi32@novamart.com', '+91-91668-12758', '1989-11-28', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2026-04-12', 'ACTIVE'),
('Ishan', 'Sharma', 'ishan.sharma33@novamart.com', '+91-82448-26445', '1984-08-20', 'Other', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-03-01', 'ACTIVE'),
('Madhav', 'Bhat', 'madhav.bhat34@novamart.com', '+91-78835-58359', '1973-11-23', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-10-01', 'ACTIVE'),
('Sunita', 'Choudhury', 'sunita.choudhury35@novamart.com', '+91-79739-40303', '1987-09-14', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-07-20', 'ACTIVE'),
('Jyoti', 'Sharma', 'jyoti.sharma36@novamart.com', '+91-94647-74212', '1993-09-25', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-10-04', 'ACTIVE'),
('Ajay', 'Banerjee', 'ajay.banerjee37@novamart.com', '+91-95330-27884', '1972-01-07', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-10-28', 'ACTIVE'),
('Geeta', 'Gupta', 'geeta.gupta38@novamart.com', '+91-99014-98734', '1986-03-18', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-08-07', 'ACTIVE'),
('Lakshmi', 'Deshmukh', 'lakshmi.deshmukh39@novamart.com', '+91-98388-80619', '1983-09-10', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-07-21', 'ACTIVE'),
('Vihaan', 'Gavade', 'vihaan.gavade40@novamart.com', '+91-94287-86578', '2001-12-08', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-07-23', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Kiran', 'Dutta', 'kiran.dutta41@novamart.com', '+91-87338-84306', '1980-06-18', 'Female', 'Business', 'Delhi', 'Delhi', 'India', '2023-05-14', 'ACTIVE'),
('Sai', 'Mehta', 'sai.mehta42@novamart.com', '+91-74599-16698', '1981-06-21', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2025-09-12', 'ACTIVE'),
('Sneha', 'Joshi', 'sneha.joshi43@novamart.com', '+91-74604-34334', '1999-06-15', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-07-25', 'ACTIVE'),
('Arjun', 'Dhillon', 'arjun.dhillon44@novamart.com', '+91-78218-33483', '1976-07-27', 'Male', 'Business', 'Hyderabad', 'Telangana', 'India', '2025-08-28', 'ACTIVE'),
('Abhishek', 'Nair', 'abhishek.nair45@novamart.com', '+91-93592-63665', '1995-07-12', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-04-08', 'ACTIVE'),
('Ganesh', 'Saxena', 'ganesh.saxena46@novamart.com', '+91-80459-39624', '1980-11-05', 'Male', 'Business', 'Delhi', 'Delhi', 'India', '2024-02-27', 'INACTIVE'),
('Saanvi', 'Iyengar', 'saanvi.iyengar47@novamart.com', '+91-93391-11454', '1989-08-16', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-02-12', 'ACTIVE'),
('Rakesh', 'Dhillon', 'rakesh.dhillon48@novamart.com', '+91-76869-26427', '2001-11-14', 'Male', 'Business', 'Mumbai', 'Maharashtra', 'India', '2026-06-17', 'ACTIVE'),
('Sunil', 'Iyer', 'sunil.iyer49@novamart.com', '+91-86429-88093', '1973-01-13', 'Male', 'Business', 'Delhi', 'Delhi', 'India', '2024-07-15', 'ACTIVE'),
('Divya', 'Joshi', 'divya.joshi50@novamart.com', '+91-76713-82889', '1976-05-28', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2026-03-23', 'ACTIVE'),
('Jyoti', 'Roy', 'jyoti.roy51@novamart.com', '+91-76578-94041', '1975-04-25', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-06-28', 'ACTIVE'),
('Rakesh', 'Prasad', 'rakesh.prasad52@novamart.com', '+91-94851-93299', '1976-07-31', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2026-02-19', 'ACTIVE'),
('Sanjay', 'Shinde', 'sanjay.shinde53@novamart.com', '+91-92982-15090', '1975-05-10', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-06-21', 'ACTIVE'),
('Rajesh', 'Reddy', 'rajesh.reddy54@novamart.com', '+91-71910-20739', '1985-07-23', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-07-19', 'ACTIVE'),
('Aadya', 'Iyer', 'aadya.iyer55@novamart.com', '+91-86926-77463', '1993-10-09', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-09-18', 'ACTIVE'),
('Sunil', 'Patel', 'sunil.patel56@novamart.com', '+91-76015-90074', '1987-12-18', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-05-02', 'ACTIVE'),
('Diya', 'Kapoor', 'diya.kapoor57@novamart.com', '+91-92007-76665', '1983-05-02', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-05-23', 'ACTIVE'),
('Aadya', 'Banerjee', 'aadya.banerjee58@novamart.com', '+91-94945-53353', '1998-11-26', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2026-01-25', 'ACTIVE'),
('Amit', 'Iyengar', 'amit.iyengar59@novamart.com', '+91-81356-12369', '1973-09-04', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2026-06-28', 'ACTIVE'),
('Kavita', 'Malhotra', 'kavita.malhotra60@novamart.com', '+91-72703-70298', '1991-03-17', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-05-08', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Suresh', 'Kapoor', 'suresh.kapoor61@novamart.com', '+91-72284-85398', '2001-09-18', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-03-05', 'ACTIVE'),
('Vivaan', 'Deshmukh', 'vivaan.deshmukh62@novamart.com', '+91-86011-30905', '2001-08-16', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-12-10', 'ACTIVE'),
('Neha', 'Prasad', 'neha.prasad63@novamart.com', '+91-72482-31012', '1993-10-31', 'Male', 'Business', 'Bangalore', 'Karnataka', 'India', '2026-01-15', 'ACTIVE'),
('Divya', 'Srinivasan', 'divya.srinivasan64@novamart.com', '+91-94342-46470', '2004-09-23', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-07-25', 'INACTIVE'),
('Kiran', 'Gupta', 'kiran.gupta65@novamart.com', '+91-83284-14236', '1976-07-08', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2023-06-18', 'ACTIVE'),
('Aadya', 'Naidu', 'aadya.naidu66@novamart.com', '+91-72781-61120', '1999-10-20', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-09-01', 'ACTIVE'),
('Sai', 'Kumar', 'sai.kumar67@novamart.com', '+91-86835-13712', '1988-03-17', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2025-02-05', 'ACTIVE'),
('Lakshmi', 'Prasad', 'lakshmi.prasad68@novamart.com', '+91-93217-26123', '1998-05-28', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-04-07', 'ACTIVE'),
('Kiran', 'Sidhu', 'kiran.sidhu69@novamart.com', '+91-93427-10829', '2000-10-02', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-01-22', 'ACTIVE'),
('Abhishek', 'Kulkarni', 'abhishek.kulkarni70@novamart.com', '+91-90045-93965', '1995-06-01', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-07-04', 'ACTIVE'),
('Dev', 'Patil', 'dev.patil71@novamart.com', '+91-79631-33348', '2004-04-11', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-12-27', 'ACTIVE'),
('Aarav', 'Verma', 'aarav.verma72@novamart.com', '+91-73955-18959', '2003-04-14', 'Female', 'Business', 'Delhi', 'Delhi', 'India', '2024-04-20', 'ACTIVE'),
('Priya', 'Gupta', 'priya.gupta73@novamart.com', '+91-90542-18010', '1974-06-12', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-01-28', 'ACTIVE'),
('Pranav', 'Singh', 'pranav.singh74@novamart.com', '+91-95467-74073', '1991-10-19', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-04-14', 'ACTIVE'),
('Dev', 'Patil', 'dev.patil75@novamart.com', '+91-88611-29401', '1998-05-21', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-04-26', 'ACTIVE'),
('Ishan', 'Mehta', 'ishan.mehta76@novamart.com', '+91-96261-14968', '1998-05-17', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-11-25', 'ACTIVE'),
('Vijay', 'Sen', 'vijay.sen77@novamart.com', '+91-81621-46267', '1995-03-17', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-08-16', 'ACTIVE'),
('Sunita', 'Joshi', 'sunita.joshi78@novamart.com', '+91-80466-40387', '2001-12-07', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-09-17', 'ACTIVE'),
('Aishwarya', 'More', 'aishwarya.more79@novamart.com', '+91-78254-41084', '1972-02-24', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-04-20', 'ACTIVE'),
('Jyoti', 'Kumar', 'jyoti.kumar80@novamart.com', '+91-78208-33392', '1985-11-04', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-04-23', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Divya', 'Dutta', 'divya.dutta81@novamart.com', '+91-87540-18686', '1981-11-28', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-04-24', 'ACTIVE'),
('Kiran', 'Sharma', 'kiran.sharma82@novamart.com', '+91-75951-75054', '2003-01-03', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-01-13', 'ACTIVE'),
('Rakesh', 'Reddy', 'rakesh.reddy83@novamart.com', '+91-77395-74267', '1985-09-27', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-12-23', 'ACTIVE'),
('Meera', 'Grewal', 'meera.grewal84@novamart.com', '+91-90982-90966', '1978-02-11', 'Male', 'Business', 'Bangalore', 'Karnataka', 'India', '2024-03-22', 'ACTIVE'),
('Divya', 'Singh', 'divya.singh85@novamart.com', '+91-78016-58032', '1989-08-16', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2026-05-18', 'ACTIVE'),
('Ajay', 'Patil', 'ajay.patil86@novamart.com', '+91-98472-58426', '1975-03-31', 'Other', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-09-22', 'ACTIVE'),
('Deepak', 'Sandhu', 'deepak.sandhu87@novamart.com', '+91-95019-26019', '1992-10-19', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2023-05-23', 'ACTIVE'),
('Lakshmi', 'Gill', 'lakshmi.gill88@novamart.com', '+91-83723-72324', '1995-03-27', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-06-23', 'ACTIVE'),
('Vihaan', 'Deshmukh', 'vihaan.deshmukh89@novamart.com', '+91-82273-52514', '1978-11-13', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-02-03', 'ACTIVE'),
('Amit', 'Patil', 'amit.patil90@novamart.com', '+91-84822-59142', '1974-09-12', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2026-03-13', 'ACTIVE'),
('Geeta', 'Dhillon', 'geeta.dhillon91@novamart.com', '+91-82324-99544', '1999-09-05', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-08-25', 'ACTIVE'),
('Rakesh', 'Patil', 'rakesh.patil92@novamart.com', '+91-85862-76628', '1972-10-09', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2024-04-05', 'ACTIVE'),
('Jyoti', 'Singh', 'jyoti.singh93@novamart.com', '+91-70196-19463', '2002-03-27', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2026-03-12', 'ACTIVE'),
('Ishan', 'Gupta', 'ishan.gupta94@novamart.com', '+91-77937-92747', '1994-03-30', 'Other', 'Regular', 'Delhi', 'Delhi', 'India', '2025-02-05', 'ACTIVE'),
('Sanjay', 'Reddy', 'sanjay.reddy95@novamart.com', '+91-81795-14556', '2000-06-12', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-09-14', 'ACTIVE'),
('Arjun', 'Kapoor', 'arjun.kapoor96@novamart.com', '+91-85682-62976', '1975-07-23', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2026-04-06', 'ACTIVE'),
('Sunil', 'Nair', 'sunil.nair97@novamart.com', '+91-73782-30839', '1982-05-13', 'Other', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-11-10', 'ACTIVE'),
('Ishan', 'Joshi', 'ishan.joshi98@novamart.com', '+91-72177-63814', '1996-08-17', 'Female', 'Business', 'Bangalore', 'Karnataka', 'India', '2023-11-03', 'ACTIVE'),
('Vikram', 'Patil', 'vikram.patil99@novamart.com', '+91-98788-49114', '1981-12-02', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2024-08-02', 'ACTIVE'),
('Rakesh', 'Bose', 'rakesh.bose100@novamart.com', '+91-78543-75825', '1979-07-22', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-06-10', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Meera', 'Reddy', 'meera.reddy101@novamart.com', '+91-84638-20662', '2006-02-21', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-08-24', 'ACTIVE'),
('Ishan', 'Sen', 'ishan.sen102@novamart.com', '+91-70880-47520', '1996-05-12', 'Male', 'Business', 'Bangalore', 'Karnataka', 'India', '2025-05-01', 'INACTIVE'),
('Rakesh', 'Sidhu', 'rakesh.sidhu103@novamart.com', '+91-94261-85455', '1978-05-01', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-11-23', 'ACTIVE'),
('Ajay', 'Mehta', 'ajay.mehta104@novamart.com', '+91-91565-90811', '1999-05-19', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-09-17', 'ACTIVE'),
('Vikram', 'Singh', 'vikram.singh105@novamart.com', '+91-73159-28851', '1990-05-06', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2023-08-27', 'ACTIVE'),
('Meera', 'Khanna', 'meera.khanna106@novamart.com', '+91-70347-93911', '2001-08-04', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2024-07-17', 'ACTIVE'),
('Sunita', 'Bose', 'sunita.bose107@novamart.com', '+91-88534-90331', '1987-06-21', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-01-08', 'ACTIVE'),
('Krishna', 'Kumar', 'krishna.kumar108@novamart.com', '+91-88749-32669', '1986-07-08', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2026-04-17', 'ACTIVE'),
('Rajesh', 'Kumar', 'rajesh.kumar109@novamart.com', '+91-84620-60731', '1994-03-06', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2025-12-08', 'ACTIVE'),
('Aditya', 'Patel', 'aditya.patel110@novamart.com', '+91-93623-22131', '1973-03-24', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-04-20', 'ACTIVE'),
('Arjun', 'Deshmukh', 'arjun.deshmukh111@novamart.com', '+91-72604-25476', '1990-11-26', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-12-06', 'ACTIVE'),
('Jyoti', 'More', 'jyoti.more112@novamart.com', '+91-94189-64430', '1998-06-19', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2023-09-02', 'ACTIVE'),
('Manish', 'Joshi', 'manish.joshi113@novamart.com', '+91-94741-66338', '1977-07-01', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-11-28', 'ACTIVE'),
('Madhav', 'Kumar', 'madhav.kumar114@novamart.com', '+91-95464-91696', '1996-03-27', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2026-06-16', 'ACTIVE'),
('Dev', 'Iyer', 'dev.iyer115@novamart.com', '+91-76428-21723', '1982-01-12', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-05-21', 'ACTIVE'),
('Divya', 'Chatterjee', 'divya.chatterjee116@novamart.com', '+91-77346-93466', '1989-02-12', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-08-24', 'ACTIVE'),
('Sanjay', 'Chatterjee', 'sanjay.chatterjee117@novamart.com', '+91-89498-62078', '1975-08-12', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2023-10-25', 'ACTIVE'),
('Pranav', 'Rao', 'pranav.rao118@novamart.com', '+91-84220-28804', '1995-10-23', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2025-04-04', 'ACTIVE'),
('Aadya', 'Saxena', 'aadya.saxena119@novamart.com', '+91-87901-24728', '1992-05-20', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-07-21', 'ACTIVE'),
('Abhishek', 'Grewal', 'abhishek.grewal120@novamart.com', '+91-83883-96842', '1996-04-23', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-10-14', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Abhishek', 'Iyer', 'abhishek.iyer121@novamart.com', '+91-73944-51883', '1989-01-13', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-11-09', 'ACTIVE'),
('Aarav', 'Naidu', 'aarav.naidu122@novamart.com', '+91-73641-21449', '1982-10-08', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-02-16', 'ACTIVE'),
('Vivaan', 'Joshi', 'vivaan.joshi123@novamart.com', '+91-75078-78810', '1974-04-13', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-06-19', 'ACTIVE'),
('Tanya', 'Kumar', 'tanya.kumar124@novamart.com', '+91-92573-15780', '1995-01-31', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-02-22', 'ACTIVE'),
('Sneha', 'Srinivasan', 'sneha.srinivasan125@novamart.com', '+91-93450-42923', '1988-04-17', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2026-03-24', 'ACTIVE'),
('Lakshmi', 'More', 'lakshmi.more126@novamart.com', '+91-83303-16503', '1985-07-26', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2023-09-15', 'ACTIVE'),
('Amit', 'Roy', 'amit.roy127@novamart.com', '+91-89466-68602', '1983-08-26', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2025-09-16', 'ACTIVE'),
('Krishna', 'Deshmukh', 'krishna.deshmukh128@novamart.com', '+91-84407-47130', '1984-03-23', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2023-08-12', 'ACTIVE'),
('Ramesh', 'Sen', 'ramesh.sen129@novamart.com', '+91-86374-98518', '1995-08-09', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-11-02', 'ACTIVE'),
('Dev', 'Joshi', 'dev.joshi130@novamart.com', '+91-80619-79453', '1987-03-16', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-02-03', 'ACTIVE'),
('Saanvi', 'Patel', 'saanvi.patel131@novamart.com', '+91-88401-44479', '1975-04-14', 'Other', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2026-04-01', 'ACTIVE'),
('Sai', 'Sen', 'sai.sen132@novamart.com', '+91-74995-24992', '1998-01-10', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-10-02', 'ACTIVE'),
('Lakshmi', 'Reddy', 'lakshmi.reddy133@novamart.com', '+91-80953-15158', '1990-05-20', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-01-18', 'ACTIVE'),
('Geeta', 'Reddy', 'geeta.reddy134@novamart.com', '+91-86011-46407', '1976-03-09', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-07-01', 'ACTIVE'),
('Pooja', 'Patel', 'pooja.patel135@novamart.com', '+91-71654-88657', '1986-06-26', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2026-06-29', 'ACTIVE'),
('Kavita', 'Prasad', 'kavita.prasad136@novamart.com', '+91-98628-46325', '1976-10-15', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-03-12', 'ACTIVE'),
('Sanjay', 'Roy', 'sanjay.roy137@novamart.com', '+91-95052-22052', '1990-09-07', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2025-09-02', 'ACTIVE'),
('Manish', 'Bose', 'manish.bose138@novamart.com', '+91-93728-62203', '1981-12-08', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-07-21', 'ACTIVE'),
('Kiran', 'Singh', 'kiran.singh139@novamart.com', '+91-92921-55382', '2004-03-27', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2025-09-19', 'ACTIVE'),
('Ajay', 'Srinivasan', 'ajay.srinivasan140@novamart.com', '+91-73261-53452', '2004-11-20', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-06-01', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Saanvi', 'Dutta', 'saanvi.dutta141@novamart.com', '+91-73751-22151', '1989-02-15', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2025-12-05', 'ACTIVE'),
('Lakshmi', 'Iyengar', 'lakshmi.iyengar142@novamart.com', '+91-90906-84921', '1981-06-30', 'Male', 'Business', 'Mumbai', 'Maharashtra', 'India', '2026-05-19', 'ACTIVE'),
('Amit', 'Naidu', 'amit.naidu143@novamart.com', '+91-74254-41665', '1994-03-01', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2025-01-07', 'ACTIVE'),
('Preeti', 'Chatterjee', 'preeti.chatterjee144@novamart.com', '+91-94564-34840', '1997-09-03', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2026-04-22', 'ACTIVE'),
('Suresh', 'Kulkarni', 'suresh.kulkarni145@novamart.com', '+91-78845-22362', '1981-12-24', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2024-11-24', 'ACTIVE'),
('Vihaan', 'Joshi', 'vihaan.joshi146@novamart.com', '+91-92254-12188', '1989-05-19', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-01-05', 'ACTIVE'),
('Divya', 'Mehta', 'divya.mehta147@novamart.com', '+91-97905-41268', '2002-01-26', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2023-12-01', 'ACTIVE'),
('Priya', 'Banerjee', 'priya.banerjee148@novamart.com', '+91-97908-55764', '1986-04-26', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-04-12', 'ACTIVE'),
('Kiara', 'Malhotra', 'kiara.malhotra149@novamart.com', '+91-95364-25018', '1985-07-14', 'Other', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-09-11', 'INACTIVE'),
('Rahul', 'Kapoor', 'rahul.kapoor150@novamart.com', '+91-79011-36985', '1999-05-05', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-11-14', 'ACTIVE'),
('Priya', 'Kapoor', 'priya.kapoor151@novamart.com', '+91-96276-41412', '1975-11-12', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2026-01-01', 'INACTIVE'),
('Jyoti', 'Choudhury', 'jyoti.choudhury152@novamart.com', '+91-78914-52364', '1998-09-01', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-04-02', 'ACTIVE'),
('Vivaan', 'Das', 'vivaan.das153@novamart.com', '+91-77960-77878', '1990-04-16', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-04-17', 'ACTIVE'),
('Kavita', 'Sidhu', 'kavita.sidhu154@novamart.com', '+91-88772-52695', '1976-10-19', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-02-09', 'ACTIVE'),
('Ishan', 'Srinivasan', 'ishan.srinivasan155@novamart.com', '+91-89159-34194', '1978-07-18', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-08-06', 'ACTIVE'),
('Lakshmi', 'Dutta', 'lakshmi.dutta156@novamart.com', '+91-77789-22560', '2003-01-06', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-03-11', 'ACTIVE'),
('Aadya', 'Sharma', 'aadya.sharma157@novamart.com', '+91-92611-50442', '1991-02-01', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-09-25', 'ACTIVE'),
('Nisha', 'Sandhu', 'nisha.sandhu158@novamart.com', '+91-97894-95468', '1974-05-28', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-03-11', 'ACTIVE'),
('Ajay', 'Mehta', 'ajay.mehta159@novamart.com', '+91-86526-57909', '1987-01-19', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-05-27', 'ACTIVE'),
('Pooja', 'Choudhury', 'pooja.choudhury160@novamart.com', '+91-98723-29194', '1981-04-11', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-01-18', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Sai', 'Patil', 'sai.patil161@novamart.com', '+91-92264-83847', '2004-07-14', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2025-12-22', 'ACTIVE'),
('Kavita', 'Banerjee', 'kavita.banerjee162@novamart.com', '+91-99481-50060', '1989-05-03', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-05-28', 'ACTIVE'),
('Karan', 'Joshi', 'karan.joshi163@novamart.com', '+91-78894-74533', '1986-07-07', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-01-23', 'INACTIVE'),
('Vivaan', 'Chatterjee', 'vivaan.chatterjee164@novamart.com', '+91-98706-66437', '1986-07-01', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-07-16', 'ACTIVE'),
('Arjun', 'Srinivasan', 'arjun.srinivasan165@novamart.com', '+91-94042-23935', '2001-07-21', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-04-03', 'ACTIVE'),
('Sunita', 'Bose', 'sunita.bose166@novamart.com', '+91-70073-44541', '2000-08-15', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-03-29', 'ACTIVE'),
('Pranav', 'More', 'pranav.more167@novamart.com', '+91-77923-60734', '1993-04-01', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-04-04', 'ACTIVE'),
('Vihaan', 'Deshmukh', 'vihaan.deshmukh168@novamart.com', '+91-95973-78328', '1984-04-29', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-08-23', 'ACTIVE'),
('Aditya', 'Dhillon', 'aditya.dhillon169@novamart.com', '+91-82112-94397', '1975-12-27', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2026-02-19', 'ACTIVE'),
('Vikram', 'Rao', 'vikram.rao170@novamart.com', '+91-85836-14012', '1996-06-25', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-07-11', 'ACTIVE'),
('Aadya', 'Dutta', 'aadya.dutta171@novamart.com', '+91-84157-53871', '1977-03-04', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-05-18', 'ACTIVE'),
('Dev', 'Chatterjee', 'dev.chatterjee172@novamart.com', '+91-73345-55720', '1987-03-19', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-08-21', 'ACTIVE'),
('Pranav', 'Saxena', 'pranav.saxena173@novamart.com', '+91-72607-62230', '1994-10-06', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-09-10', 'ACTIVE'),
('Ananya', 'Iyengar', 'ananya.iyengar174@novamart.com', '+91-84591-85029', '1985-08-31', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-07-06', 'ACTIVE'),
('Ajay', 'Naidu', 'ajay.naidu175@novamart.com', '+91-93547-47033', '1989-09-27', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2026-02-18', 'ACTIVE'),
('Vivaan', 'Nair', 'vivaan.nair176@novamart.com', '+91-87884-24093', '1971-11-22', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-11-14', 'ACTIVE'),
('Vijay', 'Banerjee', 'vijay.banerjee177@novamart.com', '+91-73216-26467', '1973-06-27', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2024-04-27', 'ACTIVE'),
('Pranav', 'Iyengar', 'pranav.iyengar178@novamart.com', '+91-92758-98498', '1988-01-26', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-06-19', 'ACTIVE'),
('Ajay', 'Saxena', 'ajay.saxena179@novamart.com', '+91-81692-65671', '1976-07-11', 'Male', 'Business', 'Bangalore', 'Karnataka', 'India', '2025-03-24', 'ACTIVE'),
('Diya', 'Kapoor', 'diya.kapoor180@novamart.com', '+91-81688-20319', '2000-12-28', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-05-30', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Ramesh', 'Dhillon', 'ramesh.dhillon181@novamart.com', '+91-96292-29922', '2001-05-12', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-06-15', 'ACTIVE'),
('Abhishek', 'Malhotra', 'abhishek.malhotra182@novamart.com', '+91-92570-10018', '1982-02-26', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-10-10', 'ACTIVE'),
('Ananya', 'Kapoor', 'ananya.kapoor183@novamart.com', '+91-78760-85339', '1987-12-26', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2024-11-06', 'ACTIVE'),
('Saanvi', 'Bhat', 'saanvi.bhat184@novamart.com', '+91-96192-65484', '1987-04-06', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2023-10-04', 'ACTIVE'),
('Pooja', 'Gill', 'pooja.gill185@novamart.com', '+91-76469-57461', '1984-02-14', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2026-01-11', 'ACTIVE'),
('Preeti', 'Nair', 'preeti.nair186@novamart.com', '+91-73075-35060', '1991-01-10', 'Male', 'Business', 'Delhi', 'Delhi', 'India', '2025-05-19', 'ACTIVE'),
('Jyoti', 'Chatterjee', 'jyoti.chatterjee187@novamart.com', '+91-70538-23449', '1976-08-27', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-05-19', 'ACTIVE'),
('Dev', 'Rao', 'dev.rao188@novamart.com', '+91-81153-13846', '1974-07-11', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2025-09-24', 'ACTIVE'),
('Arjun', 'Gill', 'arjun.gill189@novamart.com', '+91-89255-86963', '1997-08-12', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2026-05-20', 'ACTIVE'),
('Dev', 'Rao', 'dev.rao190@novamart.com', '+91-78001-97399', '2003-07-21', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-05-28', 'ACTIVE'),
('Lakshmi', 'Joshi', 'lakshmi.joshi191@novamart.com', '+91-85551-37447', '2005-09-16', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-05-05', 'ACTIVE'),
('Tanya', 'Shinde', 'tanya.shinde192@novamart.com', '+91-81907-82335', '1975-01-12', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-02-19', 'ACTIVE'),
('Suresh', 'Banerjee', 'suresh.banerjee193@novamart.com', '+91-78273-48117', '2006-02-05', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2026-01-02', 'ACTIVE'),
('Deepak', 'Kulkarni', 'deepak.kulkarni194@novamart.com', '+91-98193-74966', '2004-02-24', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-05-07', 'INACTIVE'),
('Dev', 'Iyer', 'dev.iyer195@novamart.com', '+91-95110-41153', '2004-03-02', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-09-10', 'ACTIVE'),
('Rakesh', 'Bose', 'rakesh.bose196@novamart.com', '+91-80254-74704', '1972-08-08', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-04-22', 'ACTIVE'),
('Karan', 'Iyengar', 'karan.iyengar197@novamart.com', '+91-84258-15586', '1979-12-10', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-08-30', 'ACTIVE'),
('Aishwarya', 'Patil', 'aishwarya.patil198@novamart.com', '+91-96821-16883', '1974-07-05', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-06-26', 'ACTIVE'),
('Diya', 'Kulkarni', 'diya.kulkarni199@novamart.com', '+91-79531-38642', '1973-06-05', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-03-24', 'ACTIVE'),
('Kiran', 'Gavade', 'kiran.gavade200@novamart.com', '+91-96106-73856', '2000-04-24', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-11-29', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Sneha', 'Bhat', 'sneha.bhat201@novamart.com', '+91-79529-12710', '1999-11-21', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-11-27', 'ACTIVE'),
('Sanjay', 'More', 'sanjay.more202@novamart.com', '+91-78915-85602', '1971-11-10', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-12-20', 'ACTIVE'),
('Karan', 'Roy', 'karan.roy203@novamart.com', '+91-96140-40359', '1999-10-08', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2023-06-13', 'ACTIVE'),
('Pranav', 'Patel', 'pranav.patel204@novamart.com', '+91-99939-97160', '1991-07-26', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-05-02', 'ACTIVE'),
('Jyoti', 'Sen', 'jyoti.sen205@novamart.com', '+91-98520-71458', '1973-08-13', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-04-04', 'ACTIVE'),
('Rahul', 'Gill', 'rahul.gill206@novamart.com', '+91-71391-74410', '1985-09-26', 'Female', 'Business', 'Hyderabad', 'Telangana', 'India', '2025-06-15', 'ACTIVE'),
('Vikram', 'More', 'vikram.more207@novamart.com', '+91-70723-40574', '1995-02-26', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-03-13', 'ACTIVE'),
('Abhishek', 'Saxena', 'abhishek.saxena208@novamart.com', '+91-83109-49214', '1982-07-29', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-05-08', 'ACTIVE'),
('Vivaan', 'Deshmukh', 'vivaan.deshmukh209@novamart.com', '+91-93105-71845', '2004-12-11', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-05-03', 'ACTIVE'),
('Ishan', 'Banerjee', 'ishan.banerjee210@novamart.com', '+91-85566-63470', '1978-02-01', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-01-24', 'ACTIVE'),
('Divya', 'Kumar', 'divya.kumar211@novamart.com', '+91-77472-54404', '2005-02-09', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-08-05', 'ACTIVE'),
('Geeta', 'Naidu', 'geeta.naidu212@novamart.com', '+91-99321-50187', '1996-08-03', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-12-04', 'ACTIVE'),
('Rajesh', 'Rao', 'rajesh.rao213@novamart.com', '+91-71621-20035', '2001-07-31', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-05-06', 'ACTIVE'),
('Vijay', 'Kulkarni', 'vijay.kulkarni214@novamart.com', '+91-80812-62584', '1987-10-26', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-04-07', 'ACTIVE'),
('Ganesh', 'Kumar', 'ganesh.kumar215@novamart.com', '+91-93691-61383', '1984-01-05', 'Male', 'Business', 'Hyderabad', 'Telangana', 'India', '2025-01-02', 'ACTIVE'),
('Aarav', 'Deshmukh', 'aarav.deshmukh216@novamart.com', '+91-86085-83297', '1975-01-02', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-07-07', 'ACTIVE'),
('Karan', 'Kapoor', 'karan.kapoor217@novamart.com', '+91-74845-59589', '2001-06-23', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-09-28', 'ACTIVE'),
('Jyoti', 'Saxena', 'jyoti.saxena218@novamart.com', '+91-75192-49757', '1999-03-21', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-09-12', 'ACTIVE'),
('Aditya', 'Patel', 'aditya.patel219@novamart.com', '+91-93058-50966', '1995-06-30', 'Other', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2026-03-06', 'ACTIVE'),
('Karan', 'Verma', 'karan.verma220@novamart.com', '+91-87804-42497', '2003-03-30', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-06-02', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Pranav', 'Reddy', 'pranav.reddy221@novamart.com', '+91-84276-93580', '2005-01-29', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-08-04', 'ACTIVE'),
('Geeta', 'Sidhu', 'geeta.sidhu222@novamart.com', '+91-79850-45207', '1977-01-12', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-12-14', 'ACTIVE'),
('Priya', 'Mehta', 'priya.mehta223@novamart.com', '+91-95351-83047', '1975-06-24', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2026-01-03', 'ACTIVE'),
('Rakesh', 'Malhotra', 'rakesh.malhotra224@novamart.com', '+91-98825-99836', '1990-12-15', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-07-20', 'ACTIVE'),
('Dev', 'Deshmukh', 'dev.deshmukh225@novamart.com', '+91-96353-24715', '2001-03-25', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-04-22', 'ACTIVE'),
('Arjun', 'Gupta', 'arjun.gupta226@novamart.com', '+91-94051-13563', '1979-06-30', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2025-11-30', 'ACTIVE'),
('Neha', 'Banerjee', 'neha.banerjee227@novamart.com', '+91-80731-63537', '2004-07-23', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2026-05-18', 'ACTIVE'),
('Abhishek', 'Bhat', 'abhishek.bhat228@novamart.com', '+91-93048-63591', '1986-05-30', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-07-01', 'ACTIVE'),
('Vikram', 'Sharma', 'vikram.sharma229@novamart.com', '+91-84192-76360', '1977-09-02', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-12-14', 'ACTIVE'),
('Rohan', 'Saxena', 'rohan.saxena230@novamart.com', '+91-75900-83144', '1978-12-18', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2023-10-05', 'ACTIVE'),
('Preeti', 'Banerjee', 'preeti.banerjee231@novamart.com', '+91-97499-26239', '2001-02-20', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-03-22', 'ACTIVE'),
('Madhav', 'Rao', 'madhav.rao232@novamart.com', '+91-70586-40032', '1974-02-28', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-08-30', 'ACTIVE'),
('Nisha', 'Patel', 'nisha.patel233@novamart.com', '+91-73228-34401', '1977-04-03', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2026-02-07', 'ACTIVE'),
('Lakshmi', 'Verma', 'lakshmi.verma234@novamart.com', '+91-96164-33515', '1973-06-19', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2024-12-09', 'ACTIVE'),
('Ananya', 'Das', 'ananya.das235@novamart.com', '+91-90398-53490', '1997-10-05', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-12-26', 'ACTIVE'),
('Priya', 'Verma', 'priya.verma236@novamart.com', '+91-80859-67044', '1995-08-10', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2023-08-17', 'ACTIVE'),
('Rajesh', 'More', 'rajesh.more237@novamart.com', '+91-97076-35868', '1995-09-18', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-08-15', 'ACTIVE'),
('Meera', 'Sidhu', 'meera.sidhu238@novamart.com', '+91-75519-21303', '1991-08-23', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-01-08', 'ACTIVE'),
('Sneha', 'Patel', 'sneha.patel239@novamart.com', '+91-71545-23943', '1981-09-08', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-10-20', 'ACTIVE'),
('Aditya', 'Dhillon', 'aditya.dhillon240@novamart.com', '+91-77563-63896', '1991-11-27', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-01-28', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Divya', 'Saxena', 'divya.saxena241@novamart.com', '+91-94551-23349', '1993-05-31', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-08-27', 'ACTIVE'),
('Sanjay', 'Dutta', 'sanjay.dutta242@novamart.com', '+91-70610-56244', '1998-06-20', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-04-03', 'ACTIVE'),
('Sanjay', 'Naidu', 'sanjay.naidu243@novamart.com', '+91-95776-43019', '1995-11-06', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-12-14', 'ACTIVE'),
('Tanya', 'Kapoor', 'tanya.kapoor244@novamart.com', '+91-92569-74590', '2002-02-12', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-02-17', 'ACTIVE'),
('Anil', 'Joshi', 'anil.joshi245@novamart.com', '+91-94645-32596', '1993-06-29', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-04-05', 'INACTIVE'),
('Abhishek', 'Saxena', 'abhishek.saxena246@novamart.com', '+91-94966-39770', '1987-08-22', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-08-07', 'ACTIVE'),
('Vikram', 'Sharma', 'vikram.sharma247@novamart.com', '+91-96795-82193', '1996-05-21', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-11-15', 'ACTIVE'),
('Krishna', 'Gavade', 'krishna.gavade248@novamart.com', '+91-86299-15455', '2001-06-29', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-12-10', 'ACTIVE'),
('Pooja', 'Iyengar', 'pooja.iyengar249@novamart.com', '+91-72834-14727', '1997-10-02', 'Male', 'Business', 'Hyderabad', 'Telangana', 'India', '2025-07-10', 'ACTIVE'),
('Preeti', 'Sandhu', 'preeti.sandhu250@novamart.com', '+91-70130-58238', '1989-10-13', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-12-30', 'ACTIVE'),
('Priya', 'Shinde', 'priya.shinde251@novamart.com', '+91-94167-74572', '1986-10-26', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-08-30', 'ACTIVE'),
('Deepak', 'Roy', 'deepak.roy252@novamart.com', '+91-88974-26415', '1989-05-30', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2023-05-06', 'ACTIVE'),
('Nisha', 'Shinde', 'nisha.shinde253@novamart.com', '+91-94168-69944', '1982-11-17', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2026-03-27', 'ACTIVE'),
('Ananya', 'Sharma', 'ananya.sharma254@novamart.com', '+91-78394-21725', '1994-04-01', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-12-19', 'ACTIVE'),
('Geeta', 'Patel', 'geeta.patel255@novamart.com', '+91-80069-52614', '1979-04-11', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-06-01', 'ACTIVE'),
('Vihaan', 'Saxena', 'vihaan.saxena256@novamart.com', '+91-74421-67822', '1980-04-15', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-06-29', 'ACTIVE'),
('Ananya', 'Srinivasan', 'ananya.srinivasan257@novamart.com', '+91-93048-42416', '1980-12-20', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-06-03', 'ACTIVE'),
('Aditya', 'Mehta', 'aditya.mehta258@novamart.com', '+91-99430-47504', '1993-09-11', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2023-11-02', 'ACTIVE'),
('Karan', 'Dhillon', 'karan.dhillon259@novamart.com', '+91-91336-64517', '1975-11-22', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-12-13', 'ACTIVE'),
('Kiran', 'Shinde', 'kiran.shinde260@novamart.com', '+91-90007-33800', '2002-02-25', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-09-16', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Ananya', 'Verma', 'ananya.verma261@novamart.com', '+91-92208-61597', '1972-05-27', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2026-03-26', 'ACTIVE'),
('Priya', 'Khanna', 'priya.khanna262@novamart.com', '+91-78453-25890', '1977-05-02', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-04-09', 'ACTIVE'),
('Jyoti', 'Iyengar', 'jyoti.iyengar263@novamart.com', '+91-89825-90292', '1988-10-10', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-03-03', 'ACTIVE'),
('Kavita', 'Singh', 'kavita.singh264@novamart.com', '+91-86166-91701', '1997-01-27', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-08-22', 'ACTIVE'),
('Nisha', 'Chatterjee', 'nisha.chatterjee265@novamart.com', '+91-93066-63481', '2002-10-07', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-07-29', 'ACTIVE'),
('Sneha', 'More', 'sneha.more266@novamart.com', '+91-97223-60017', '1973-11-15', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-05-01', 'ACTIVE'),
('Jyoti', 'Patil', 'jyoti.patil267@novamart.com', '+91-78562-85565', '1980-09-09', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2025-07-13', 'ACTIVE'),
('Aarav', 'Das', 'aarav.das268@novamart.com', '+91-97828-69291', '1991-04-30', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-10-06', 'ACTIVE'),
('Tanya', 'Mehta', 'tanya.mehta269@novamart.com', '+91-78376-68125', '1976-04-17', 'Male', 'Business', 'Delhi', 'Delhi', 'India', '2024-04-18', 'ACTIVE'),
('Dev', 'Kumar', 'dev.kumar270@novamart.com', '+91-95360-51058', '2000-09-18', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2023-09-20', 'ACTIVE'),
('Aarav', 'Iyer', 'aarav.iyer271@novamart.com', '+91-74753-11953', '1974-11-20', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-12-10', 'ACTIVE'),
('Sai', 'Bhat', 'sai.bhat272@novamart.com', '+91-97026-22812', '1998-11-28', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-11-14', 'ACTIVE'),
('Vijay', 'Deshmukh', 'vijay.deshmukh273@novamart.com', '+91-90887-53148', '1998-03-21', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2026-06-15', 'ACTIVE'),
('Sneha', 'Saxena', 'sneha.saxena274@novamart.com', '+91-99644-17690', '1996-01-07', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-09-21', 'ACTIVE'),
('Pooja', 'Saxena', 'pooja.saxena275@novamart.com', '+91-94536-92755', '1982-04-21', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2023-04-20', 'ACTIVE'),
('Aishwarya', 'Saxena', 'aishwarya.saxena276@novamart.com', '+91-87123-47801', '1999-11-28', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2026-01-20', 'ACTIVE'),
('Vijay', 'Gupta', 'vijay.gupta277@novamart.com', '+91-96318-99420', '1978-01-14', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2024-01-23', 'ACTIVE'),
('Anil', 'Saxena', 'anil.saxena278@novamart.com', '+91-86447-55525', '1988-10-19', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-08-11', 'ACTIVE'),
('Vivaan', 'Kulkarni', 'vivaan.kulkarni279@novamart.com', '+91-86226-45691', '1984-01-29', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-11-22', 'ACTIVE'),
('Anil', 'Gill', 'anil.gill280@novamart.com', '+91-72608-85228', '1992-02-27', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-09-26', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Vivaan', 'Bose', 'vivaan.bose281@novamart.com', '+91-90230-48747', '1975-06-28', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-05-19', 'ACTIVE'),
('Vijay', 'Dhillon', 'vijay.dhillon282@novamart.com', '+91-80644-30495', '1988-03-20', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-07-13', 'ACTIVE'),
('Abhishek', 'Saxena', 'abhishek.saxena283@novamart.com', '+91-82477-42535', '1998-02-14', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2024-06-04', 'ACTIVE'),
('Sunita', 'Srinivasan', 'sunita.srinivasan284@novamart.com', '+91-89577-84611', '1976-11-13', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-06-21', 'ACTIVE'),
('Deepak', 'Das', 'deepak.das285@novamart.com', '+91-91373-94314', '1989-11-05', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-06-20', 'ACTIVE'),
('Jyoti', 'Grewal', 'jyoti.grewal286@novamart.com', '+91-86285-27638', '1972-05-20', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-03-17', 'ACTIVE'),
('Ananya', 'Rao', 'ananya.rao287@novamart.com', '+91-88309-86069', '1981-01-12', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2025-03-17', 'INACTIVE'),
('Arjun', 'Malhotra', 'arjun.malhotra288@novamart.com', '+91-76781-73119', '2001-07-22', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-06-26', 'ACTIVE'),
('Aadya', 'Choudhury', 'aadya.choudhury289@novamart.com', '+91-80465-37468', '1991-04-20', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-09-09', 'ACTIVE'),
('Sunil', 'Iyer', 'sunil.iyer290@novamart.com', '+91-85398-37837', '2003-06-03', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2026-07-10', 'ACTIVE'),
('Kiara', 'Iyer', 'kiara.iyer291@novamart.com', '+91-89508-88150', '1989-11-11', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-03-27', 'ACTIVE'),
('Amit', 'Kapoor', 'amit.kapoor292@novamart.com', '+91-98697-85012', '2002-09-13', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-06-06', 'ACTIVE'),
('Abhishek', 'Iyengar', 'abhishek.iyengar293@novamart.com', '+91-74968-90178', '1995-02-02', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-02-12', 'ACTIVE'),
('Diya', 'Naidu', 'diya.naidu294@novamart.com', '+91-94421-31566', '1996-04-03', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2024-10-02', 'ACTIVE'),
('Ishan', 'Grewal', 'ishan.grewal295@novamart.com', '+91-93097-87023', '1991-10-19', 'Female', 'Business', 'Delhi', 'Delhi', 'India', '2025-01-18', 'ACTIVE'),
('Meera', 'Singh', 'meera.singh296@novamart.com', '+91-93255-80758', '2005-04-21', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2026-01-13', 'ACTIVE'),
('Rakesh', 'Roy', 'rakesh.roy297@novamart.com', '+91-81406-82517', '1999-07-24', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-07-26', 'ACTIVE'),
('Sunita', 'Joshi', 'sunita.joshi298@novamart.com', '+91-95231-41501', '1996-03-27', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-06-27', 'ACTIVE'),
('Amit', 'Malhotra', 'amit.malhotra299@novamart.com', '+91-96051-26947', '2000-07-06', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-02-07', 'ACTIVE'),
('Divya', 'Iyer', 'divya.iyer300@novamart.com', '+91-97842-23101', '1992-12-01', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-05-21', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Kavita', 'Chatterjee', 'kavita.chatterjee301@novamart.com', '+91-70660-35158', '1985-12-13', 'Other', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-09-02', 'ACTIVE'),
('Kavita', 'Das', 'kavita.das302@novamart.com', '+91-94972-46564', '1998-10-25', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-08-14', 'ACTIVE'),
('Pranav', 'Malhotra', 'pranav.malhotra303@novamart.com', '+91-80462-62363', '1985-04-20', 'Male', 'Business', 'Hyderabad', 'Telangana', 'India', '2025-02-17', 'ACTIVE'),
('Aarav', 'Mehta', 'aarav.mehta304@novamart.com', '+91-80983-67303', '1983-03-22', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-08-26', 'ACTIVE'),
('Sanjay', 'Patel', 'sanjay.patel305@novamart.com', '+91-89859-77289', '1973-01-17', 'Female', 'Business', 'Bangalore', 'Karnataka', 'India', '2024-03-13', 'ACTIVE'),
('Rahul', 'More', 'rahul.more306@novamart.com', '+91-90188-14223', '1993-07-28', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-09-06', 'ACTIVE'),
('Dev', 'Patel', 'dev.patel307@novamart.com', '+91-98278-48274', '1994-06-18', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-01-06', 'ACTIVE'),
('Divya', 'Roy', 'divya.roy308@novamart.com', '+91-78716-69663', '1997-05-20', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-02-23', 'ACTIVE'),
('Ajay', 'Roy', 'ajay.roy309@novamart.com', '+91-75590-73727', '1993-06-27', 'Other', 'Premium', 'Delhi', 'Delhi', 'India', '2025-06-24', 'ACTIVE'),
('Ishan', 'Bhat', 'ishan.bhat310@novamart.com', '+91-97251-74067', '1993-07-18', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-06-27', 'ACTIVE'),
('Divya', 'Dhillon', 'divya.dhillon311@novamart.com', '+91-86296-76634', '1984-05-31', 'Other', 'Premium', 'Delhi', 'Delhi', 'India', '2026-04-10', 'ACTIVE'),
('Divya', 'Kapoor', 'divya.kapoor312@novamart.com', '+91-95903-92273', '1972-08-28', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-06-17', 'ACTIVE'),
('Pooja', 'Kumar', 'pooja.kumar313@novamart.com', '+91-85859-93010', '1987-11-13', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-04-24', 'ACTIVE'),
('Ananya', 'Singh', 'ananya.singh314@novamart.com', '+91-85807-20938', '2004-09-17', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-03-03', 'ACTIVE'),
('Kiran', 'Gupta', 'kiran.gupta315@novamart.com', '+91-77959-68730', '1986-09-28', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-01-21', 'ACTIVE'),
('Vikram', 'Sharma', 'vikram.sharma316@novamart.com', '+91-82199-90325', '1982-11-12', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2023-09-04', 'ACTIVE'),
('Divya', 'Malhotra', 'divya.malhotra317@novamart.com', '+91-97795-34630', '1978-06-10', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-04-12', 'ACTIVE'),
('Meera', 'Shinde', 'meera.shinde318@novamart.com', '+91-92959-65647', '1973-01-19', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-03-31', 'ACTIVE'),
('Ganesh', 'Shinde', 'ganesh.shinde319@novamart.com', '+91-75059-71881', '1974-01-16', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2025-12-12', 'ACTIVE'),
('Ananya', 'Saxena', 'ananya.saxena320@novamart.com', '+91-94584-49412', '1981-01-03', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-07-05', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Sneha', 'Patel', 'sneha.patel321@novamart.com', '+91-76217-82216', '1985-08-24', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-12-11', 'ACTIVE'),
('Sanjay', 'Bhat', 'sanjay.bhat322@novamart.com', '+91-86538-99779', '1987-02-19', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-05-26', 'ACTIVE'),
('Meera', 'Nair', 'meera.nair323@novamart.com', '+91-74314-85470', '1978-05-01', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-12-30', 'INACTIVE'),
('Rakesh', 'Dhillon', 'rakesh.dhillon324@novamart.com', '+91-75873-21690', '2001-11-23', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2023-10-26', 'ACTIVE'),
('Deepak', 'Prasad', 'deepak.prasad325@novamart.com', '+91-83958-98900', '1989-05-25', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-08-24', 'ACTIVE'),
('Arjun', 'Khanna', 'arjun.khanna326@novamart.com', '+91-96052-15492', '2001-01-21', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-04-23', 'ACTIVE'),
('Sanjay', 'Iyengar', 'sanjay.iyengar327@novamart.com', '+91-93875-68328', '1986-12-17', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2026-01-22', 'ACTIVE'),
('Rahul', 'Bhat', 'rahul.bhat328@novamart.com', '+91-81290-94752', '1971-09-20', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-05-13', 'ACTIVE'),
('Aditya', 'Naidu', 'aditya.naidu329@novamart.com', '+91-86705-29896', '1993-03-06', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2025-03-25', 'ACTIVE'),
('Ganesh', 'Saxena', 'ganesh.saxena330@novamart.com', '+91-96125-53232', '1980-04-06', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-08-29', 'ACTIVE'),
('Pranav', 'Kapoor', 'pranav.kapoor331@novamart.com', '+91-92466-12732', '1991-05-28', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2023-08-21', 'ACTIVE'),
('Ishan', 'Saxena', 'ishan.saxena332@novamart.com', '+91-74358-76945', '1993-09-09', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2024-05-04', 'ACTIVE'),
('Ganesh', 'Das', 'ganesh.das333@novamart.com', '+91-93094-60105', '1990-08-23', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-06-02', 'ACTIVE'),
('Lakshmi', 'Naidu', 'lakshmi.naidu334@novamart.com', '+91-94043-89454', '1994-12-01', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2023-05-25', 'ACTIVE'),
('Ajay', 'Bhat', 'ajay.bhat335@novamart.com', '+91-72787-40803', '2002-11-25', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-04-08', 'ACTIVE'),
('Sai', 'Mehta', 'sai.mehta336@novamart.com', '+91-96348-54494', '1978-02-03', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-01-03', 'ACTIVE'),
('Pranav', 'Iyengar', 'pranav.iyengar337@novamart.com', '+91-83092-69521', '1999-05-21', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-04-13', 'ACTIVE'),
('Diya', 'Mehta', 'diya.mehta338@novamart.com', '+91-86263-33307', '2005-11-14', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2024-04-08', 'ACTIVE'),
('Ganesh', 'Dutta', 'ganesh.dutta339@novamart.com', '+91-74185-32962', '1988-01-08', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-09-12', 'ACTIVE'),
('Vikram', 'Gavade', 'vikram.gavade340@novamart.com', '+91-76873-81852', '1973-01-11', 'Other', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-02-22', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Ishan', 'Iyengar', 'ishan.iyengar341@novamart.com', '+91-74725-70096', '1980-12-28', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-11-23', 'ACTIVE'),
('Kiara', 'Patel', 'kiara.patel342@novamart.com', '+91-81067-94004', '1996-08-31', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-11-26', 'ACTIVE'),
('Rakesh', 'Sen', 'rakesh.sen343@novamart.com', '+91-74954-98983', '2000-09-13', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-11-06', 'ACTIVE'),
('Dev', 'Patel', 'dev.patel344@novamart.com', '+91-77429-56787', '1998-12-16', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-10-06', 'ACTIVE'),
('Sanjay', 'Rao', 'sanjay.rao345@novamart.com', '+91-97181-14051', '1977-03-15', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-11-19', 'ACTIVE'),
('Sunita', 'Shinde', 'sunita.shinde346@novamart.com', '+91-78135-87372', '1990-11-10', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2026-01-26', 'ACTIVE'),
('Meera', 'Joshi', 'meera.joshi347@novamart.com', '+91-81511-90918', '1978-02-22', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2026-05-30', 'ACTIVE'),
('Diya', 'Verma', 'diya.verma348@novamart.com', '+91-82963-39237', '1982-11-20', 'Other', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-04-14', 'ACTIVE'),
('Ishan', 'More', 'ishan.more349@novamart.com', '+91-99909-60840', '2006-06-11', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-05-14', 'ACTIVE'),
('Ramesh', 'Dhillon', 'ramesh.dhillon350@novamart.com', '+91-87561-72274', '1975-05-01', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-10-24', 'ACTIVE'),
('Anil', 'Deshmukh', 'anil.deshmukh351@novamart.com', '+91-82731-40410', '1972-04-09', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-11-06', 'ACTIVE'),
('Suresh', 'Kumar', 'suresh.kumar352@novamart.com', '+91-93211-88888', '1972-09-26', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-02-29', 'ACTIVE'),
('Abhishek', 'Patel', 'abhishek.patel353@novamart.com', '+91-90451-66507', '1990-11-14', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-02-12', 'ACTIVE'),
('Ganesh', 'Gill', 'ganesh.gill354@novamart.com', '+91-79343-70717', '1986-11-10', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-06-24', 'ACTIVE'),
('Suresh', 'Choudhury', 'suresh.choudhury355@novamart.com', '+91-95188-77386', '1992-11-28', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-07-12', 'INACTIVE'),
('Geeta', 'Iyengar', 'geeta.iyengar356@novamart.com', '+91-96160-13645', '1989-09-11', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-11-17', 'ACTIVE'),
('Vijay', 'Sandhu', 'vijay.sandhu357@novamart.com', '+91-92806-51855', '1997-11-18', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2025-07-14', 'ACTIVE'),
('Priya', 'Iyengar', 'priya.iyengar358@novamart.com', '+91-89574-13663', '1987-02-24', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-05-19', 'ACTIVE'),
('Manish', 'More', 'manish.more359@novamart.com', '+91-92278-95270', '2006-05-22', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-04-24', 'ACTIVE'),
('Ishan', 'Gill', 'ishan.gill360@novamart.com', '+91-99893-67130', '1997-02-26', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-01-02', 'INACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Saanvi', 'Verma', 'saanvi.verma361@novamart.com', '+91-71336-86911', '1986-01-10', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-10-22', 'ACTIVE'),
('Sneha', 'Sen', 'sneha.sen362@novamart.com', '+91-76393-49670', '2001-10-31', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2026-06-30', 'ACTIVE'),
('Arjun', 'Shinde', 'arjun.shinde363@novamart.com', '+91-96126-85285', '1979-10-30', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-01-07', 'ACTIVE'),
('Deepak', 'Sidhu', 'deepak.sidhu364@novamart.com', '+91-74232-68283', '1992-01-03', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2025-02-25', 'ACTIVE'),
('Preeti', 'More', 'preeti.more365@novamart.com', '+91-86132-31745', '1991-04-09', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-06-21', 'ACTIVE'),
('Sunil', 'Srinivasan', 'sunil.srinivasan366@novamart.com', '+91-90999-21392', '1981-06-24', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-05-09', 'ACTIVE'),
('Aditya', 'Grewal', 'aditya.grewal367@novamart.com', '+91-97110-52927', '1995-08-17', 'Male', 'Business', 'Delhi', 'Delhi', 'India', '2024-06-07', 'ACTIVE'),
('Vijay', 'Kulkarni', 'vijay.kulkarni368@novamart.com', '+91-88941-72089', '1996-12-05', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2023-04-22', 'ACTIVE'),
('Tanya', 'Kapoor', 'tanya.kapoor369@novamart.com', '+91-99865-13638', '2000-04-15', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2023-10-24', 'ACTIVE'),
('Sneha', 'Roy', 'sneha.roy370@novamart.com', '+91-92533-10486', '1999-06-11', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-04-01', 'ACTIVE'),
('Aishwarya', 'Srinivasan', 'aishwarya.srinivasan371@novamart.com', '+91-83731-53331', '1997-01-04', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-07-08', 'ACTIVE'),
('Ishan', 'Dhillon', 'ishan.dhillon372@novamart.com', '+91-84831-29092', '1981-01-01', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-01-03', 'ACTIVE'),
('Saanvi', 'Das', 'saanvi.das373@novamart.com', '+91-78563-12844', '2005-01-29', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2025-04-10', 'ACTIVE'),
('Sneha', 'Joshi', 'sneha.joshi374@novamart.com', '+91-89106-62102', '1990-03-02', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-06-03', 'ACTIVE'),
('Sai', 'Dutta', 'sai.dutta375@novamart.com', '+91-79830-66088', '1978-10-19', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-02-02', 'ACTIVE'),
('Amit', 'Reddy', 'amit.reddy376@novamart.com', '+91-96129-51749', '1988-11-21', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-06-09', 'ACTIVE'),
('Vihaan', 'Sen', 'vihaan.sen377@novamart.com', '+91-75102-51467', '1997-12-26', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2025-03-24', 'ACTIVE'),
('Rohan', 'Gavade', 'rohan.gavade378@novamart.com', '+91-83126-96478', '1972-11-10', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-06-11', 'ACTIVE'),
('Geeta', 'Kapoor', 'geeta.kapoor379@novamart.com', '+91-84800-89590', '1972-05-07', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-10-03', 'ACTIVE'),
('Divya', 'More', 'divya.more380@novamart.com', '+91-79387-25590', '1983-01-19', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-03-07', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Rajesh', 'More', 'rajesh.more381@novamart.com', '+91-90334-63359', '1978-05-18', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-07-08', 'ACTIVE'),
('Sanjay', 'Grewal', 'sanjay.grewal382@novamart.com', '+91-90854-32277', '1994-06-22', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-03-27', 'ACTIVE'),
('Vihaan', 'Rao', 'vihaan.rao383@novamart.com', '+91-90244-68299', '1980-09-16', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-10-12', 'ACTIVE'),
('Pranav', 'Prasad', 'pranav.prasad384@novamart.com', '+91-90934-74295', '1990-10-01', 'Other', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-05-30', 'ACTIVE'),
('Divya', 'Iyengar', 'divya.iyengar385@novamart.com', '+91-89341-85999', '1988-05-31', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2026-01-22', 'ACTIVE'),
('Geeta', 'Dutta', 'geeta.dutta386@novamart.com', '+91-99497-58952', '1972-07-13', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-02-16', 'ACTIVE'),
('Amit', 'Gavade', 'amit.gavade387@novamart.com', '+91-77019-98004', '1973-02-08', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-09-25', 'ACTIVE'),
('Vikram', 'Das', 'vikram.das388@novamart.com', '+91-78203-57920', '2005-05-03', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-03-16', 'ACTIVE'),
('Rakesh', 'Banerjee', 'rakesh.banerjee389@novamart.com', '+91-96718-99119', '1994-02-04', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2025-09-17', 'ACTIVE'),
('Vivaan', 'Khanna', 'vivaan.khanna390@novamart.com', '+91-80493-35149', '2000-07-04', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2024-07-08', 'ACTIVE'),
('Vikram', 'Grewal', 'vikram.grewal391@novamart.com', '+91-97676-11708', '1984-03-24', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-05-06', 'ACTIVE'),
('Manish', 'Patil', 'manish.patil392@novamart.com', '+91-88879-84557', '1995-10-28', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-08-11', 'ACTIVE'),
('Pooja', 'Patel', 'pooja.patel393@novamart.com', '+91-81371-90430', '1977-12-18', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2025-03-25', 'ACTIVE'),
('Priya', 'Srinivasan', 'priya.srinivasan394@novamart.com', '+91-86145-64624', '2003-08-16', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-04-05', 'ACTIVE'),
('Pooja', 'Nair', 'pooja.nair395@novamart.com', '+91-94880-93275', '1979-11-17', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-06-10', 'ACTIVE'),
('Deepak', 'Dutta', 'deepak.dutta396@novamart.com', '+91-73692-34232', '2000-03-14', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-10-31', 'ACTIVE'),
('Sanjay', 'Choudhury', 'sanjay.choudhury397@novamart.com', '+91-74548-63442', '1973-02-09', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-04-27', 'ACTIVE'),
('Anil', 'Joshi', 'anil.joshi398@novamart.com', '+91-93509-49128', '2005-11-02', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-01-29', 'INACTIVE'),
('Divya', 'Patel', 'divya.patel399@novamart.com', '+91-90963-23702', '1996-04-14', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-06-21', 'ACTIVE'),
('Karan', 'Iyengar', 'karan.iyengar400@novamart.com', '+91-72573-46473', '1984-03-29', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-09-24', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Priya', 'Chatterjee', 'priya.chatterjee401@novamart.com', '+91-77268-74279', '2004-11-08', 'Female', 'Business', 'Hyderabad', 'Telangana', 'India', '2023-08-08', 'ACTIVE'),
('Suresh', 'Kapoor', 'suresh.kapoor402@novamart.com', '+91-90845-68835', '1990-07-27', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-10-28', 'ACTIVE'),
('Priya', 'More', 'priya.more403@novamart.com', '+91-89781-61638', '1980-07-08', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-03-21', 'ACTIVE'),
('Sunita', 'Singh', 'sunita.singh404@novamart.com', '+91-95043-51112', '1998-06-17', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2025-03-25', 'ACTIVE'),
('Ganesh', 'Chatterjee', 'ganesh.chatterjee405@novamart.com', '+91-93730-12192', '1986-09-22', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-12-29', 'INACTIVE'),
('Arjun', 'Malhotra', 'arjun.malhotra406@novamart.com', '+91-84246-15814', '2000-06-21', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-04-08', 'ACTIVE'),
('Tanya', 'Shinde', 'tanya.shinde407@novamart.com', '+91-91882-71575', '1974-06-21', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-12-14', 'ACTIVE'),
('Pranav', 'Grewal', 'pranav.grewal408@novamart.com', '+91-95644-16992', '1997-02-18', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2026-07-07', 'ACTIVE'),
('Saanvi', 'Saxena', 'saanvi.saxena409@novamart.com', '+91-88472-18547', '2002-09-15', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-02-15', 'ACTIVE'),
('Preeti', 'Reddy', 'preeti.reddy410@novamart.com', '+91-94064-46911', '2006-03-11', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-04-10', 'ACTIVE'),
('Meera', 'More', 'meera.more411@novamart.com', '+91-95852-80920', '1979-06-19', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-08-04', 'ACTIVE'),
('Rohan', 'Kumar', 'rohan.kumar412@novamart.com', '+91-75562-72868', '1998-02-20', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2025-04-11', 'ACTIVE'),
('Manish', 'Joshi', 'manish.joshi413@novamart.com', '+91-81198-46955', '1998-10-03', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-04-05', 'ACTIVE'),
('Divya', 'Naidu', 'divya.naidu414@novamart.com', '+91-81099-22737', '1982-02-09', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-10-21', 'ACTIVE'),
('Jyoti', 'Kulkarni', 'jyoti.kulkarni415@novamart.com', '+91-79371-59983', '2001-11-27', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-06-08', 'ACTIVE'),
('Suresh', 'Naidu', 'suresh.naidu416@novamart.com', '+91-95906-17457', '1987-10-16', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-06-28', 'INACTIVE'),
('Geeta', 'Shinde', 'geeta.shinde417@novamart.com', '+91-87109-69294', '2000-11-25', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-06-24', 'ACTIVE'),
('Jyoti', 'Patil', 'jyoti.patil418@novamart.com', '+91-94504-74564', '1992-01-29', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-11-10', 'ACTIVE'),
('Diya', 'Mehta', 'diya.mehta419@novamart.com', '+91-89736-79227', '2002-11-04', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-12-22', 'ACTIVE'),
('Ajay', 'Saxena', 'ajay.saxena420@novamart.com', '+91-84898-12768', '1986-07-30', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-03-18', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Aarav', 'Gill', 'aarav.gill421@novamart.com', '+91-94610-55824', '1988-02-03', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-04-11', 'ACTIVE'),
('Aadya', 'Singh', 'aadya.singh422@novamart.com', '+91-90243-86574', '1980-05-25', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-10-23', 'ACTIVE'),
('Amit', 'Shinde', 'amit.shinde423@novamart.com', '+91-98988-16324', '1994-08-19', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-04-09', 'ACTIVE'),
('Arjun', 'Choudhury', 'arjun.choudhury424@novamart.com', '+91-91343-78888', '1977-03-27', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2024-10-03', 'ACTIVE'),
('Rohan', 'Mehta', 'rohan.mehta425@novamart.com', '+91-80904-63828', '1981-11-07', 'Female', 'Business', 'Chennai', 'Tamil Nadu', 'India', '2023-12-08', 'ACTIVE'),
('Suresh', 'Mehta', 'suresh.mehta426@novamart.com', '+91-79037-77547', '2006-07-12', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-07-07', 'ACTIVE'),
('Sai', 'Shinde', 'sai.shinde427@novamart.com', '+91-86718-47657', '1990-08-06', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2025-12-20', 'ACTIVE'),
('Priya', 'Khanna', 'priya.khanna428@novamart.com', '+91-99034-93234', '1997-12-04', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2025-07-20', 'ACTIVE'),
('Ishan', 'Kumar', 'ishan.kumar429@novamart.com', '+91-99498-30354', '1987-07-25', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-03-30', 'ACTIVE'),
('Nisha', 'Mehta', 'nisha.mehta430@novamart.com', '+91-83399-60375', '2000-01-22', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-10-23', 'ACTIVE'),
('Rajesh', 'Singh', 'rajesh.singh431@novamart.com', '+91-83261-74628', '1997-05-24', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-03-21', 'ACTIVE'),
('Ajay', 'Reddy', 'ajay.reddy432@novamart.com', '+91-88976-83774', '2000-07-11', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-11-22', 'ACTIVE'),
('Pooja', 'Roy', 'pooja.roy433@novamart.com', '+91-72228-38124', '2002-10-01', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-04-05', 'ACTIVE'),
('Neha', 'Dutta', 'neha.dutta434@novamart.com', '+91-75007-51876', '1985-03-19', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-02-17', 'ACTIVE'),
('Krishna', 'Naidu', 'krishna.naidu435@novamart.com', '+91-89188-98976', '1980-01-23', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-08-07', 'ACTIVE'),
('Rakesh', 'Bose', 'rakesh.bose436@novamart.com', '+91-90827-40876', '1999-03-04', 'Male', 'Premium', 'Bangalore', 'Karnataka', 'India', '2025-11-08', 'ACTIVE'),
('Abhishek', 'Iyengar', 'abhishek.iyengar437@novamart.com', '+91-85082-79847', '1994-10-30', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-06-09', 'ACTIVE'),
('Tanya', 'Deshmukh', 'tanya.deshmukh438@novamart.com', '+91-74746-70103', '1980-10-23', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-07-31', 'ACTIVE'),
('Rohan', 'Saxena', 'rohan.saxena439@novamart.com', '+91-77872-96919', '1993-04-28', 'Other', 'Business', 'Hyderabad', 'Telangana', 'India', '2026-06-08', 'ACTIVE'),
('Divya', 'Singh', 'divya.singh440@novamart.com', '+91-73229-17366', '1999-03-16', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2024-07-01', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Rahul', 'Iyer', 'rahul.iyer441@novamart.com', '+91-98077-51288', '1976-01-26', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-07-07', 'ACTIVE'),
('Lakshmi', 'Khanna', 'lakshmi.khanna442@novamart.com', '+91-89037-76389', '1988-11-25', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-12-21', 'ACTIVE'),
('Pooja', 'Singh', 'pooja.singh443@novamart.com', '+91-72865-41774', '1999-10-21', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-01-04', 'ACTIVE'),
('Deepak', 'Dhillon', 'deepak.dhillon444@novamart.com', '+91-97287-36173', '1997-02-25', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-01-30', 'ACTIVE'),
('Karan', 'Verma', 'karan.verma445@novamart.com', '+91-98327-61569', '2002-03-29', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-05-22', 'ACTIVE'),
('Neha', 'Saxena', 'neha.saxena446@novamart.com', '+91-76139-88304', '1996-08-04', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2025-03-24', 'ACTIVE'),
('Manish', 'Dhillon', 'manish.dhillon447@novamart.com', '+91-84707-14676', '1978-05-20', 'Other', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-02-05', 'ACTIVE'),
('Diya', 'Mehta', 'diya.mehta448@novamart.com', '+91-75375-52801', '1993-10-26', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-09-14', 'ACTIVE'),
('Arjun', 'Dhillon', 'arjun.dhillon449@novamart.com', '+91-76377-30419', '1982-05-28', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-08-09', 'ACTIVE'),
('Ganesh', 'Kumar', 'ganesh.kumar450@novamart.com', '+91-73477-91304', '2003-05-15', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-12-26', 'ACTIVE'),
('Ajay', 'Reddy', 'ajay.reddy451@novamart.com', '+91-74418-44079', '1988-10-21', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-03-20', 'ACTIVE'),
('Karan', 'Deshmukh', 'karan.deshmukh452@novamart.com', '+91-97483-13374', '1979-10-28', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-05-30', 'ACTIVE'),
('Diya', 'Patil', 'diya.patil453@novamart.com', '+91-89682-92286', '2001-08-18', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-05-17', 'ACTIVE'),
('Divya', 'Das', 'divya.das454@novamart.com', '+91-87430-23283', '2001-09-26', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2025-05-31', 'ACTIVE'),
('Vihaan', 'Reddy', 'vihaan.reddy455@novamart.com', '+91-77698-34031', '1994-01-18', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-12-17', 'ACTIVE'),
('Tanya', 'More', 'tanya.more456@novamart.com', '+91-96553-98335', '1990-10-26', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-02-19', 'ACTIVE'),
('Ishan', 'Khanna', 'ishan.khanna457@novamart.com', '+91-81771-43351', '1978-04-14', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-09-13', 'ACTIVE'),
('Sanjay', 'Naidu', 'sanjay.naidu458@novamart.com', '+91-91601-69907', '1995-01-31', 'Female', 'Premium', 'Bangalore', 'Karnataka', 'India', '2024-03-27', 'ACTIVE'),
('Vikram', 'Bose', 'vikram.bose459@novamart.com', '+91-98362-95330', '2004-07-10', 'Male', 'Premium', 'Delhi', 'Delhi', 'India', '2024-02-07', 'ACTIVE'),
('Arjun', 'Dhillon', 'arjun.dhillon460@novamart.com', '+91-73760-73564', '1984-11-20', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2023-07-05', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Sneha', 'Nair', 'sneha.nair461@novamart.com', '+91-72377-67711', '1990-05-08', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-03-21', 'ACTIVE'),
('Ajay', 'Bhat', 'ajay.bhat462@novamart.com', '+91-85756-40612', '2004-12-28', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-12-09', 'ACTIVE'),
('Aditya', 'Kapoor', 'aditya.kapoor463@novamart.com', '+91-71529-59100', '1993-08-05', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2023-05-02', 'ACTIVE'),
('Preeti', 'Mehta', 'preeti.mehta464@novamart.com', '+91-76450-86426', '1979-02-16', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2026-01-16', 'ACTIVE'),
('Pooja', 'Grewal', 'pooja.grewal465@novamart.com', '+91-97658-33174', '1974-02-25', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2024-08-10', 'ACTIVE'),
('Ajay', 'Roy', 'ajay.roy466@novamart.com', '+91-84937-17809', '1976-10-09', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2024-02-02', 'ACTIVE'),
('Kiara', 'Sandhu', 'kiara.sandhu467@novamart.com', '+91-90120-18231', '1982-02-17', 'Female', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-04-18', 'ACTIVE'),
('Sanjay', 'Gill', 'sanjay.gill468@novamart.com', '+91-97291-55072', '1975-09-20', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-11-30', 'ACTIVE'),
('Saanvi', 'Chatterjee', 'saanvi.chatterjee469@novamart.com', '+91-80192-99422', '2000-01-07', 'Female', 'Premium', 'Delhi', 'Delhi', 'India', '2025-01-01', 'ACTIVE'),
('Kavita', 'Saxena', 'kavita.saxena470@novamart.com', '+91-74332-92717', '1989-04-14', 'Male', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2023-08-08', 'ACTIVE'),
('Arjun', 'Banerjee', 'arjun.banerjee471@novamart.com', '+91-70940-60098', '2005-06-01', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2026-06-26', 'ACTIVE'),
('Ishan', 'Shinde', 'ishan.shinde472@novamart.com', '+91-98916-84947', '1973-05-08', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-07-04', 'ACTIVE'),
('Sneha', 'Patil', 'sneha.patil473@novamart.com', '+91-97111-40148', '1988-11-18', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2025-07-27', 'ACTIVE'),
('Aadya', 'Sen', 'aadya.sen474@novamart.com', '+91-82976-11027', '1987-07-09', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2024-07-24', 'ACTIVE'),
('Pranav', 'Rao', 'pranav.rao475@novamart.com', '+91-81268-10645', '1990-12-10', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-08-26', 'ACTIVE'),
('Preeti', 'Banerjee', 'preeti.banerjee476@novamart.com', '+91-98142-68102', '1977-09-29', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-08-28', 'ACTIVE'),
('Pooja', 'More', 'pooja.more477@novamart.com', '+91-84613-62848', '1973-10-20', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-09-16', 'ACTIVE'),
('Pranav', 'Bose', 'pranav.bose478@novamart.com', '+91-98856-72226', '1984-09-05', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2023-11-14', 'ACTIVE'),
('Vivaan', 'More', 'vivaan.more479@novamart.com', '+91-95787-31828', '1992-12-12', 'Female', 'Regular', 'Bangalore', 'Karnataka', 'India', '2026-04-06', 'ACTIVE'),
('Rohan', 'Srinivasan', 'rohan.srinivasan480@novamart.com', '+91-83879-53605', '1977-09-25', 'Female', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2026-05-13', 'ACTIVE');

INSERT INTO customers (
    first_name, last_name, email, phone, date_of_birth, gender, 
    customer_type, city, state, country, registration_date, status
) VALUES
('Madhav', 'Deshmukh', 'madhav.deshmukh481@novamart.com', '+91-94756-86974', '2000-06-08', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2026-04-24', 'ACTIVE'),
('Ramesh', 'Sidhu', 'ramesh.sidhu482@novamart.com', '+91-88209-95273', '1994-06-24', 'Female', 'Business', 'Mumbai', 'Maharashtra', 'India', '2024-09-03', 'ACTIVE'),
('Sanjay', 'Gavade', 'sanjay.gavade483@novamart.com', '+91-90258-53096', '1993-05-06', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-06-17', 'ACTIVE'),
('Aadya', 'Srinivasan', 'aadya.srinivasan484@novamart.com', '+91-86748-36293', '1976-01-22', 'Female', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2023-08-16', 'ACTIVE'),
('Kavita', 'Rao', 'kavita.rao485@novamart.com', '+91-94629-50641', '1992-02-05', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-08-25', 'ACTIVE'),
('Karan', 'Bose', 'karan.bose486@novamart.com', '+91-93329-63593', '2000-05-17', 'Male', 'Premium', 'Chennai', 'Tamil Nadu', 'India', '2023-12-26', 'ACTIVE'),
('Vikram', 'Chatterjee', 'vikram.chatterjee487@novamart.com', '+91-70329-78562', '1978-06-23', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2025-08-28', 'ACTIVE'),
('Saanvi', 'Gavade', 'saanvi.gavade488@novamart.com', '+91-92446-37655', '1985-08-28', 'Female', 'Regular', 'Delhi', 'Delhi', 'India', '2025-01-31', 'ACTIVE'),
('Ajay', 'Bhat', 'ajay.bhat489@novamart.com', '+91-92222-59263', '1972-05-23', 'Female', 'Regular', 'Hyderabad', 'Telangana', 'India', '2023-11-21', 'ACTIVE'),
('Jyoti', 'Deshmukh', 'jyoti.deshmukh490@novamart.com', '+91-91266-79039', '1985-04-01', 'Female', 'Regular', 'Chennai', 'Tamil Nadu', 'India', '2024-12-07', 'ACTIVE'),
('Rahul', 'Srinivasan', 'rahul.srinivasan491@novamart.com', '+91-84999-56421', '1981-05-29', 'Female', 'Premium', 'Hyderabad', 'Telangana', 'India', '2024-09-25', 'ACTIVE'),
('Anil', 'Chatterjee', 'anil.chatterjee492@novamart.com', '+91-81400-31851', '1984-10-03', 'Male', 'Premium', 'Hyderabad', 'Telangana', 'India', '2025-01-24', 'ACTIVE'),
('Dev', 'Gill', 'dev.gill493@novamart.com', '+91-73573-78149', '1998-02-10', 'Male', 'Regular', 'Hyderabad', 'Telangana', 'India', '2024-06-01', 'ACTIVE'),
('Sai', 'Sen', 'sai.sen494@novamart.com', '+91-94101-40897', '1988-11-26', 'Male', 'Regular', 'Bangalore', 'Karnataka', 'India', '2025-12-12', 'ACTIVE'),
('Ganesh', 'Verma', 'ganesh.verma495@novamart.com', '+91-91794-40106', '1990-05-04', 'Other', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2025-08-30', 'INACTIVE'),
('Geeta', 'Kulkarni', 'geeta.kulkarni496@novamart.com', '+91-91504-17628', '1987-02-15', 'Other', 'Regular', 'Delhi', 'Delhi', 'India', '2023-08-26', 'ACTIVE'),
('Amit', 'Chatterjee', 'amit.chatterjee497@novamart.com', '+91-72931-40139', '1974-03-04', 'Female', 'Business', 'Hyderabad', 'Telangana', 'India', '2024-01-28', 'INACTIVE'),
('Karan', 'Gavade', 'karan.gavade498@novamart.com', '+91-95348-37005', '1986-09-17', 'Male', 'Regular', 'Mumbai', 'Maharashtra', 'India', '2023-09-18', 'ACTIVE'),
('Dev', 'Kumar', 'dev.kumar499@novamart.com', '+91-92351-87245', '1998-04-05', 'Male', 'Premium', 'Mumbai', 'Maharashtra', 'India', '2024-10-01', 'ACTIVE'),
('Vijay', 'Patil', 'vijay.patil500@novamart.com', '+91-70804-62938', '1982-08-06', 'Male', 'Regular', 'Delhi', 'Delhi', 'India', '2025-08-18', 'ACTIVE');

SELECT 'Customer seeding completed successfully with ' || (SELECT COUNT(*) FROM customers) || ' records.' AS info;
