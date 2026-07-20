/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 2

Module:
Database Maintenance - Drop All Tables

Author:
Sanjana

Description:
Drops all tables, schemas, and extensions to clean
the database. Reserved for testing and clean teardown.

======================================================
*/

-- Teardown operations
SELECT 'Dropping all database structures...' AS info;

DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

DROP FUNCTION IF EXISTS fn_update_timestamp_column CASCADE;

SELECT 'Teardown completed.' AS info;
