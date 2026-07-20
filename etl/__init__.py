"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5 - ETL Pipeline

Project: Analytics Warehouse ETL Pipeline

This module contains the complete Extract-Transform-Load
(ETL) pipeline for moving data from operational database
to analytics warehouse.

Modules:
--------

config/
  - settings.py: Configuration management
  - database.py: Database connections & pooling
  - logger.py: Centralized logging setup

extract/
  - extract_customers.py: Customer dimension extraction
  - extract_products.py: Product dimension extraction
  - extract_orders.py: Order transactional extraction

transform/
  - clean_customers.py: Customer transformation
  - clean_products.py: Product transformation
  - transform_orders.py: Order transformation

load/
  - load_dimension_tables.py: Load customer/product dims
  - load_fact_tables.py: Load sales facts

run_pipeline.py
  - Main ETL orchestrator

Getting Started:
----------------

1. Configure environment:
   cp .env.example .env
   # Edit .env with database credentials

2. Initialize analytics schema:
   psql -U postgres -d enterprise_ai_platform \\
     -f ../database/schema/12_analytics_warehouse.sql

3. Run the pipeline:
   python run_pipeline.py

4. Check results:
   - Logs: etl/logs/etl_YYYYMMDD_HHMMSS.log
   - Database: analytics schema

Documentation:
---------------

- README.md: Setup and operation guide
- ../docs/etl-design.md: Architecture and design details

Author: Data Engineering Team
======================================================
"""

from etl.config import (
    DatabaseConfig, LoggingConfig, PipelineConfig, 
    DataQualityConfig, DatabaseConnection, setup_logger
)
from etl.extract import (
    CustomerExtractor, ProductExtractor, OrderExtractor
)
from etl.transform import (
    CustomerTransformer, ProductTransformer, OrderTransformer
)
from etl.load import (
    DimensionLoader, FactLoader
)

__version__ = '1.0.0'
__all__ = [
    'DatabaseConfig', 'LoggingConfig', 'PipelineConfig', 'DataQualityConfig',
    'DatabaseConnection', 'setup_logger',
    'CustomerExtractor', 'ProductExtractor', 'OrderExtractor',
    'CustomerTransformer', 'ProductTransformer', 'OrderTransformer',
    'DimensionLoader', 'FactLoader'
]
