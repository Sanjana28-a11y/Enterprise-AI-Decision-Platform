# ETL Pipeline Documentation

## Overview

The ETL (Extract, Transform, Load) pipeline automates the process of moving data from the operational database to an analytics warehouse. The pipeline follows a modular architecture with clear separation of concerns and production-ready error handling.

## Architecture

### Pipeline Flow

```
EXTRACTION STAGE
├── Extract Customers from operational DB
├── Extract Products from operational DB
└── Extract Orders, Order Items, Payments from operational DB

TRANSFORMATION STAGE
├── Clean Customer data (standardize, validate, deduplicate)
├── Clean Product data (calculate margins, validate pricing)
└── Transform Orders data (standardize statuses, calculate metrics)

LOADING STAGE
├── Load dim_customer to analytics schema
├── Load dim_product to analytics schema
└── Load fact_sales to analytics schema
```

### Directory Structure

```
etl/
├── config/
│   ├── __init__.py              # Package initialization
│   ├── settings.py              # Configuration management
│   ├── database.py              # Database connections & pooling
│   └── logger.py                # Logging setup
│
├── extract/
│   ├── __init__.py
│   ├── extract_customers.py     # Customer extraction
│   ├── extract_products.py      # Product extraction
│   └── extract_orders.py        # Order/item/payment extraction
│
├── transform/
│   ├── __init__.py
│   ├── clean_customers.py       # Customer transformation
│   ├── clean_products.py        # Product transformation
│   └── transform_orders.py      # Order transformation
│
├── load/
│   ├── __init__.py
│   ├── load_dimension_tables.py # Load customer/product dimensions
│   └── load_fact_tables.py      # Load sales facts
│
├── tests/
│   ├── test_extractors.py       # Extractor tests
│   ├── test_transformers.py     # Transformer tests
│   └── test_loaders.py          # Loader tests
│
├── logs/                        # Generated log files
├── run_pipeline.py              # Main orchestrator
├── requirements.txt             # Python dependencies
├── .env.example                 # Configuration template
└── README.md                    # This file
```

## Setup Instructions

### Prerequisites

- Python 3.8+
- PostgreSQL 12+
- Access to both operational and analytics databases

### Installation

1. **Clone the repository**
```bash
cd Enterprise-AI-Decision-Platform
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
cd etl
pip install -r requirements.txt
```

4. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your database credentials
```

5. **Initialize analytics schema** (one-time setup)
```bash
psql -U postgres -d enterprise_ai_platform -f ../database/schema/12_analytics_warehouse.sql
```

## Running the Pipeline

### Basic Execution

```bash
cd etl
python run_pipeline.py
```

### Configuration Options

Edit `.env` to customize:

- **BATCH_SIZE**: Number of records to process in each batch (default: 1000)
- **MAX_RETRIES**: Number of retries on failure (default: 3)
- **RETRY_DELAY**: Seconds between retries (default: 5)
- **VALIDATE_DATA**: Enable data quality checks (default: True)
- **RECREATE_TABLES**: Drop and recreate tables (default: False for safety)
- **LOG_LEVEL**: Logging verbosity - DEBUG, INFO, WARNING, ERROR (default: INFO)

### Output

Pipeline execution generates:

1. **Log files**: `etl/logs/etl_YYYYMMDD_HHMMSS.log`
2. **Console output**: Real-time pipeline progress
3. **Database records**: Loaded to analytics schema

### Example Log Output

```
╔══════════════════════════════════════════════════════════╗
║  ETL PIPELINE STARTED                                    ║
║  Timestamp: 2024-01-15 14:30:45                          ║
╚══════════════════════════════════════════════════════════╝

============================================================
STAGE 1: EXTRACTION
============================================================
EXTRACTION STARTED: Customers
✅ Extraction completed: 5000 customer records extracted
...

============================================================
STAGE 2: TRANSFORMATION
============================================================
TRANSFORMATION STARTED: Customers
✅ Transformation completed: 4998 rows
   Customer types: {'Regular': 3200, 'Premium': 1200, 'Business': 598}
...

============================================================
STAGE 3: LOADING
============================================================
LOADING STARTED: dim_customer
✅ Loading completed: 4998 customer dimension records
...

╔══════════════════════════════════════════════════════════╗
║  PIPELINE SUMMARY                                        ║
╠══════════════════════════════════════════════════════════╣
║ Extracted      │ Customers: 5000 Products: 1200          ║
║ Loaded         │ Dim_Customer: 4998 Fact_Sales: 15000    ║
║ Status         │ ✅ SUCCESS                              ║
║ Duration       │ 45.23 seconds                           ║
╚══════════════════════════════════════════════════════════╝
```

## Module Documentation

### Extraction Modules

#### CustomerExtractor
- **Purpose**: Extract customer dimension data
- **Method**: `extract()` → DataFrame with all customers
- **Incremental**: `extract_incremental(last_updated)` for delta loads
- **Output**: Pandas DataFrame with 15+ columns

#### ProductExtractor
- **Purpose**: Extract product data with category/supplier joins
- **Method**: `extract()` → DataFrame with products and attributes
- **Joins**: LEFT JOIN to categories and suppliers
- **Output**: Pandas DataFrame with 18+ columns

#### OrderExtractor
- **Purpose**: Extract transactional data
- **Methods**:
  - `extract_orders()` → Order master records
  - `extract_order_items()` → Order line items
  - `extract_payments()` → Payment records
- **Output**: Multiple Pandas DataFrames

### Transformation Modules

#### CustomerTransformer
- **Input**: Raw customer DataFrame
- **Processing**:
  - Remove duplicates on customer_id
  - Fill nulls (first_name → 'Unknown', email → 'no-email@unknown.com')
  - Standardize formats (title case names, lowercase email)
  - Validate customer_type (Regular/Premium/Business)
  - Calculate age from DOB
  - Create customer_segment
- **Quality**: Returns metrics on nulls, duplicates, invalid emails

#### ProductTransformer
- **Input**: Raw product DataFrame
- **Processing**:
  - Remove duplicates on product_id
  - Fill nulls (category → 'Uncategorized', supplier → 'Unknown Supplier')
  - Standardize formats (title case names)
  - Validate pricing (remove zero prices)
  - Calculate margin_amount and margin_percentage
  - Create price_range bins (Budget/Mid-Range/Premium/Luxury)
- **Quality**: Returns metrics on zero prices, missing categories, avg margin

#### OrderTransformer
- **Input**: Raw order/item DataFrames
- **Processing**:
  - Standardize order statuses (7 valid states)
  - Validate amounts (non-negative)
  - Calculate days_since_order
  - Create order_phase (In Progress/Completed/Failed)
  - Validate quantities (minimum 1)
  - Recalculate subtotals for consistency
- **Quality**: Returns metrics on invalid statuses, pricing discrepancies

### Loading Modules

#### DimensionLoader
- **load_dim_customer(df)**: Load customer dimension (upsert strategy)
- **load_dim_product(df)**: Load product dimension
- **verify_dimension_counts()**: Validate loaded row counts
- **Features**: Batch processing, transaction rollback on error

#### FactLoader
- **prepare_fact_sales(orders, items, payments)**: Aggregate orders + items into facts
- **load_fact_sales(df)**: Load sales facts with foreign keys
- **verify_fact_counts()**: Validate totals and distributions
- **Features**: JOIN customer/product keys, calculate revenue metrics

## Data Quality Framework

### Validation Rules

#### Customers
- NULL Percentage < 10% (configurable)
- No duplicate customer_id
- Valid email format (contains @)
- customer_type in ['Regular', 'Premium', 'Business']
- status in ['ACTIVE', 'INACTIVE']

#### Products
- No duplicate product_id
- selling_price > 0
- margin_percentage calculated correctly
- status in ['ACTIVE', 'INACTIVE', 'DISCONTINUED']
- Category name standardized

#### Orders
- quantity >= 1 per line item
- total_amount >= 0
- order_status in [7 valid states]
- subtotal = quantity × unit_price (allow ±0.01 variance)

### Quality Metrics

Pipeline logs quality metrics at each stage:

```
Quality Metrics:
  total_rows: 4998
  null_percentage: 0.23
  duplicate_count: 0
  invalid_emails: 2
  missing_names: 12
```

## Database Connection Pooling

The pipeline uses SQLAlchemy with QueuePool for production-ready connections:

```
Pool Configuration:
- pool_size: 5 (concurrent connections)
- max_overflow: 10 (additional connections when needed)
- pool_timeout: 30 seconds (wait time for available connection)
- pool_recycle: 3600 seconds (recycle connections every hour)
```

This ensures:
- Efficient resource utilization
- Thread-safe multi-threaded execution
- Automatic connection recovery
- Protection against long-held connections

## Error Handling

### Retry Logic

Failed operations are retried based on configuration:
- **MAX_RETRIES**: Number of retry attempts
- **RETRY_DELAY**: Seconds to wait between retries

### Logging

All errors are logged with:
- Error message and traceback
- Affected stage (EXTRACTION/TRANSFORMATION/LOADING)
- Row count and context information
- Timestamp for correlation

### Graceful Degradation

Pipeline stops immediately on critical errors but attempts to:
1. Log detailed error information
2. Rollback database transactions
3. Close connections gracefully
4. Report failure with context

## Performance Optimization

### Batch Processing
- **BATCH_SIZE**: 1000 records per batch (configurable)
- Reduces memory footprint for large datasets
- Allows progress reporting

### Database Indexes
Analytics schema includes strategic indexes on:
- Dimension foreign keys
- Date ranges for time-series queries
- Common filter columns (status, customer_type, etc.)

### Connection Pooling
- Reuses connections instead of creating new ones
- Reduces connection overhead by ~90%
- Scales from 5 concurrent to 15 peak connections

## Future Enhancements

### Phase 2
- **Incremental Loading**: ETL_INCREMENTAL_LOAD flag for delta extracts
- **Slowly Changing Dimensions (SCD Type 2)**: Track history of dimension changes
- **Time Dimension**: Add dim_date for calendar-based analysis
- **Geography Dimension**: Add dim_location for geographic analysis

### Phase 3
- **Real-time CDC**: Change Data Capture for near-real-time updates
- **Scheduling**: Airflow/cron for automated daily runs
- **Monitoring**: Metrics and alerting for pipeline health
- **Data Lineage**: Track data flow through transformations

### Phase 4
- **Fact: Returns**: Load return/refund transactions
- **Aggregations**: Pre-aggregated fact tables for performance
- **Materialized Views**: Pre-calculated metrics
- **Data Lake**: Archival of raw extracted data

## Troubleshooting

### Issue: "Cannot connect to database"
- **Check**: Verify database server is running
- **Check**: Verify credentials in .env file
- **Check**: Verify network connectivity
- **Solution**: Test with `psql -h HOST -U USER -d DATABASE`

### Issue: "Table already exists"
- **Cause**: Recycled table names or previous failed run
- **Solution**: Set `ETL_RECREATE_TABLES=True` in .env for clean slate
- **Or**: Manually drop tables: `DROP TABLE IF EXISTS analytics.dim_customer`

### Issue: "Memory error during transformation"
- **Cause**: BATCH_SIZE too large for available memory
- **Solution**: Reduce BATCH_SIZE in .env (try 500 or 250)
- **Check**: Monitor system memory during run

### Issue: "Quality validation failed"
- **Check**: Review null_percentage metric
- **Solution**: Adjust DQ_NULL_THRESHOLD in .env if threshold too strict
- **Check**: Review invalid value counts in log

## Support

For issues or questions:
1. Check logs in `etl/logs/`
2. Review error messages and tracebacks
3. Verify configuration in `.env`
4. Check database connectivity
5. Contact data engineering team

## References

- [Analytics Schema Design](../docs/etl-design.md)
- [Database Schema](../database/schema/)
- [Project Architecture](../docs/architecture.md)
