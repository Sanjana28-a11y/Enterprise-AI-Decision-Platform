/*
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 2

Module:
Database Infrastructure - Database & Extension Setup

Author:
Sanjana

Description:
Creates the core enterprise database and enables the
pgcrypto extension to support v4 UUIDs dynamically.

======================================================
*/

-- 1. Create the target enterprise database if it does not exist
-- NOTE: In a standard psql client, this script should be run by a superuser (e.g., postgres).
SELECT 'Creating database enterprise_ai_platform...' AS info;

CREATE DATABASE enterprise_ai_platform;

-- 2. Connect to the newly created database
\c enterprise_ai_platform;

-- 3. Enable the pgcrypto extension for secure random UUID generation
SELECT 'Enabling pgcrypto extension...' AS info;
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

SELECT 'Database and extensions successfully initialized.' AS info;
