# ETL Pipeline Design & Architecture

## Document Purpose

This document describes the design, architecture, and implementation details of the Enterprise AI Decision Intelligence Platform ETL pipeline. It serves as a reference for developers, data engineers, and operations teams maintaining and extending the system.

## 1. Executive Summary

The ETL pipeline is a modular, production-ready system that:
- **Extracts** data from the operational database (PostgreSQL)
- **Transforms** data with validation, standardization, and enrichment
- **Loads** data into an analytics warehouse (star schema)
- Provides comprehensive logging, error handling, and data quality assurance
- Supports incremental loading for scalability to large datasets

### Key Features
- **Modular Architecture**: Separate extraction, transformation, and loading stages
- **Production Quality**: Connection pooling, error handling, transaction management
- **Data Quality**: Validation rules and quality metrics at each stage
- **Comprehensive Logging**: Detailed logs for troubleshooting and monitoring
- **Scalable Design**: Batch processing and connection pooling for large datasets

## 2. Architecture Overview

### 2.1 High-Level Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────┐
│ EXTRACTION STAGE                                                │
│ ├─ CustomerExtractor → extract_customers.py                   │
│ ├─ ProductExtractor → extract_products.py                     │
│ └─ OrderExtractor → extract_orders.py                         │
└─────────────────────┬───────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────────┐
│ TRANSFORMATION STAGE                                            │
│ ├─ CustomerTransformer (clean_customers.py)                   │
│ │  ├─ Remove duplicates                                       │
│ │  ├─ Fill nulls                                              │
│ │  ├─ Standardize formats                                     │
│ │  └─ Validate data quality                                   │
│ ├─ ProductTransformer (clean_products.py)                     │
│ │  ├─ Calculate pricing metrics                               │
│ │  ├─ Categorize products                                     │
│ │  └─ Validate inventory data                                 │
│ └─ OrderTransformer (transform_orders.py)                      │
│    ├─ Standardize statuses                                     │
│    ├─ Calculate order metrics                                  │
│    └─ Validate line items                                      │
└─────────────────────┬───────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────────┐
│ LOADING STAGE                                                   │
│ ├─ DimensionLoader                                             │
│ │  ├─ load_dim_customer()                                      │
│ │  └─ load_dim_product()                                       │
│ └─ FactLoader                                                  │
│    └─ load_fact_sales()                                        │
└─────────────────────┬───────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────────┐
│ ANALYTICS WAREHOUSE (Star Schema)                              │
│ ├─ dim_customer (dimensions)                                   │
│ ├─ dim_product (dimensions)                                    │
│ └─ fact_sales (facts)                                          │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Component Architecture

```
etl/
├── config/              → Configuration & Database connections
│   ├── settings.py     → Configuration management (env vars)
│   ├── database.py     → Connection pooling, SQLAlchemy setup
│   └── logger.py       → Centralized logging
│
├── extract/            → Data extraction layer
│   ├── extract_customers.py
│   ├── extract_products.py
│   └── extract_orders.py
│
├── transform/          → Data transformation layer
│   ├── clean_customers.py
│   ├── clean_products.py
│   └── transform_orders.py
│
├── load/               → Data loading layer
│   ├── load_dimension_tables.py
│   └── load_fact_tables.py
│
├── run_pipeline.py     → Pipeline orchestrator
└── tests/              → Unit tests
```

## 3. Detailed Design

### 3.1 Extraction Layer

#### Purpose
Extract raw data from the operational database and return as Pandas DataFrames.

#### Classes & Methods

**CustomerExtractor**
```python
# Extract all customers
@staticmethod
def extract() → pd.DataFrame

# Extract only changed customers since last run
@staticmethod
def extract_incremental(last_updated: datetime) → pd.DataFrame
```

**ProductExtractor**
```python
# Extract products with category and supplier information
@staticmethod
def extract() → pd.DataFrame

# Extract only changed products since last run
@staticmethod
def extract_incremental(last_updated: datetime) → pd.DataFrame
```

**OrderExtractor**
```python
# Extract order master records
@staticmethod
def extract_orders() → pd.DataFrame

# Extract order line items
@staticmethod
def extract_order_items() → pd.DataFrame

# Extract payment records
@staticmethod
def extract_payments() → pd.DataFrame
```

#### Design Decisions
- **Static Methods**: Allow calling without instantiation
- **DataFrame Returns**: Standard Python data structure for compatibility
- **Incremental Support**: `*_incremental()` methods for scalability
- **JOIN Operations**: Performed in SQL (not Python) for efficiency
- **Logging**: Each extraction logs row counts and data distributions

### 3.2 Transformation Layer

#### Purpose
Clean, validate, and enrich data for analytics while maintaining data quality.

#### Classes & Methods

**CustomerTransformer**
```python
# Transform raw customer data
@staticmethod
def transform(df: pd.DataFrame) → pd.DataFrame

# Validate quality metrics
@staticmethod
def validate_quality(df: pd.DataFrame) → dict
```

**ProductTransformer**
```python
# Transform raw product data
@staticmethod
def transform(df: pd.DataFrame) → pd.DataFrame

# Validate quality metrics
@staticmethod
def validate_quality(df: pd.DataFrame) → dict
```

**OrderTransformer**
```python
# Transform orders
@staticmethod
def transform_orders(df: pd.DataFrame) → pd.DataFrame

# Transform order items
@staticmethod
def transform_order_items(df: pd.DataFrame) → pd.DataFrame

# Validate quality
@staticmethod
def validate_quality(orders_df, items_df) → dict
```

#### Transformation Rules

**Customers**
| Rule | Implementation | Example |
|------|---|---|
| Deduplicate | `drop_duplicates(subset=['customer_id'])` | 5000 → 4998 records |
| Fill nulls | first_name→'Unknown', email→'no-email@unknown.com' | 15 nulls handled |
| Standardize | title case names, lowercase email, title city | 'john DOE' → 'John Doe' |
| Validate | customer_type in ['Regular','Premium','Business'] | Invalid → 'Regular' |
| Calculate | age = (today - dob) / 365 | '1990-01-01' → 34 |
| Segment | segment = customer_type + '_' + city | 'Regular_New York' |

**Products**
| Rule | Implementation | Example |
|------|---|---|
| Deduplicate | `drop_duplicates(subset=['product_id'])` | 1200 → 1200 records |
| Fill nulls | category→'Uncategorized', brand→'Generic' | 5 nulls handled |
| Validate pricing | selling_price > 0, cost_price ≥ 0 | Remove 0-priced items |
| Calculate | margin = (selling - cost) / cost × 100 | $100-$80 = 20% |
| Categorize | price_range: Budget/Mid/Premium/Luxury | $150 → Mid-Range |
| Standardize | status in ['ACTIVE','INACTIVE','DISCONTINUED'] | Invalid → 'ACTIVE' |

**Orders**
| Rule | Implementation | Example |
|------|---|---|
| Validate amounts | total_amount ≥ 0 | Remove negative orders |
| Standardize status | 7 valid states + title case | 'pending' → 'Pending' |
| Calculate phase | map status → In Progress/Completed/Failed | 'Shipped' → 'In Progress' |
| Validate items | quantity ≥ 1 | Set minimum to 1 |
| Recalculate | subtotal = qty × price (fix discrepancies) | Fix pricing mismatches |

#### Design Decisions
- **Immutable Inputs**: Copy DataFrame before modifying
- **Pandas Operations**: Vectorized for performance
- **Validation After Transform**: Quality checks on cleaned data
- **Metrics Logging**: Detailed metrics for monitoring
- **Error Handling**: Full tracebacks on exceptions

### 3.3 Loading Layer

#### Purpose
Load transformed data into analytics warehouse with proper relationships.

#### Classes & Methods

**DimensionLoader**
```python
# Load customer dimension with upsert
@staticmethod
def load_dim_customer(df, recreate=False) → int

# Load product dimension with upsert
@staticmethod
def load_dim_product(df, recreate=False) → int

# Verify loaded records
@staticmethod
def verify_dimension_counts() → dict
```

**FactLoader**
```python
# Prepare fact_sales from orders + items
@staticmethod
def prepare_fact_sales(orders_df, items_df, payments_df) → pd.DataFrame

# Load fact_sales table
@staticmethod
def load_fact_sales(df, recreate=False) → int

# Verify loaded records and aggregates
@staticmethod
def verify_fact_counts() → dict
```

#### Star Schema Design

```
dim_customer (25 columns)
├─ customer_key (PK)
├─ customer_id (UK)
├─ Basic: first_name, last_name, email, phone
├─ Demographics: dob, age, gender
├─ Business: customer_type, customer_segment
├─ Location: city, state, country
├─ Status: status
└─ Metadata: created_at, updated_at, dw_inserted_at

dim_product (23 columns)
├─ product_key (PK)
├─ product_id (UK)
├─ Basic: product_name, sku, description
├─ Category: category_name, supplier_name
├─ Attributes: brand, color, weight, warranty
├─ Pricing: cost_price, selling_price, margin_percentage, price_range
├─ Status: status
└─ Metadata: created_at, updated_at, dw_inserted_at

fact_sales (18 columns)
├─ sales_key (PK)
├─ Dimensions: customer_id (FK), product_id (FK)
├─ Order: order_id, order_date, order_status, order_phase
├─ Metrics: quantity, unit_price, subtotal, total_amount, revenue
├─ Payment: payment_method, payment_status
├─ Flags: is_completed, is_cancelled
└─ Metadata: dw_inserted_at, dw_updated_at
```

#### Design Decisions
- **UPSERT Strategy**: Use `if_exists='append'` with unique constraints
- **Batch Loading**: Process in BATCH_SIZE chunks
- **Foreign Keys**: Enforce referential integrity
- **Indexes**: Support analytical query patterns
- **Surrogate Keys**: Auto-increment for dimensional tables

### 3.4 Configuration Management

#### Settings Module (config/settings.py)

```python
class DatabaseConfig:
    - OPERATIONAL_DB_HOST
    - OPERATIONAL_DB_PORT (5432)
    - OPERATIONAL_DB_NAME
    - OPERATIONAL_DB_USER
    - OPERATIONAL_DB_PASSWORD
    - ANALYTICS_SCHEMA ('analytics')
    
class LoggingConfig:
    - LOG_LEVEL ('INFO')
    - LOG_DIR (etl/logs)
    
class PipelineConfig:
    - BATCH_SIZE (1000)
    - MAX_RETRIES (3)
    - RETRY_DELAY (5s)
    - VALIDATE_DATA (True)
    - INCREMENTAL_LOAD (False)
    - RECREATE_TABLES (False)
    
class DataQualityConfig:
    - NULL_THRESHOLD (0.1 = 10%)
    - DUPLICATE_THRESHOLD (0.01 = 1%)
```

#### Environment Variables

All configuration from `.env` file or environment:
```
DB_OPERATIONAL_HOST=localhost
DB_OPERATIONAL_PORT=5432
...
ETL_BATCH_SIZE=1000
...
DQ_NULL_THRESHOLD=0.1
```

### 3.5 Database Connection Management

#### Connection Pooling Architecture

```
┌─ DatabaseConnection (Singleton Pattern)
│
├─ get_operational_engine()
│  └─ Creates/returns SQLAlchemy engine with QueuePool
│     ├─ pool_size=5
│     ├─ max_overflow=10
│     ├─ pool_timeout=30s
│     ├─ pool_recycle=3600s
│     └─ Uses psycopg2 driver
│
├─ get_analytics_engine()
│  └─ Same configuration, separate analytics schema
│
├─ get_operational_session()
│  └─ Scoped session (thread-safe)
│
└─ get_analytics_session()
   └─ Scoped session (thread-safe)
```

#### Benefits of QueuePool
- **Connection Reuse**: Reduces overhead by ~90%
- **Thread-Safe**: Scoped sessions per thread
- **Resource Management**: Max 5 concurrent + 10 overflow
- **Timeout Protection**: 30s max wait for connection
- **Auto-Recycle**: Recycle every 3600s to refresh connections

### 3.6 Logging Architecture

#### Logging Setup (config/logger.py)

```python
setup_logger(name, level='INFO')
├─ Creates logger instance
├─ File handler (DEBUG level)
│  ├─ RotatingFileHandler (10MB max, 5 backups)
│  ├─ Format: {timestamp} - {level} - {message}
│  └─ File: etl/logs/etl_YYYYMMDD_HHMMSS.log
└─ Console handler (INFO level)
   ├─ Format: {timestamp} - {level} - {message}
   └─ Output: stdout
```

#### Log Levels Used
- **DEBUG**: Detailed diagnostic info (database operations, data samples)
- **INFO**: General pipeline progress (row counts, completion messages)
- **WARNING**: Warnings about data quality (high null%, duplicates)
- **ERROR**: Failures requiring attention (database errors, missing data)

#### Example Log Output

```
2024-01-15 14:30:45 - INFO - ============================================================
2024-01-15 14:30:45 - INFO - EXTRACTION STARTED: Customers
2024-01-15 14:30:45 - INFO - Input rows: 5000
2024-01-15 14:30:46 - INFO - ✅ Extraction completed: 5000 customer records extracted
2024-01-15 14:30:46 - INFO -    Columns: customer_id, first_name, last_name, ...
2024-01-15 14:30:46 - INFO - 
2024-01-15 14:30:46 - INFO - ============================================================
2024-01-15 14:30:46 - INFO - TRANSFORMATION STARTED: Customers
2024-01-15 14:30:46 - INFO - Input rows: 5000
2024-01-15 14:30:46 - INFO - Duplicates removed: 2
2024-01-15 14:30:47 - INFO - ✅ Transformation completed: 4998 rows
2024-01-15 14:30:47 - INFO -    Customer types: {'Regular': 3200, 'Premium': 1200, 'Business': 598}
```

## 4. Error Handling Strategy

### Error Categories

#### Extraction Errors
- **Database Connection**: Host unreachable, authentication failed
- **Query Errors**: Invalid SQL, table not found
- **Memory**: DataFrame too large for available RAM

#### Transformation Errors
- **Data Type**: Cannot convert string to numeric
- **Logic**: Division by zero in calculations
- **Null Handling**: Unexpected null in required field

#### Loading Errors
- **Foreign Key**: Child record without parent
- **Unique Constraint**: Duplicate key value
- **Schema**: Table does not exist

### Error Handling Pattern

```python
try:
    # Perform operation
    df = extract_customers()
    logger.info(f"Extracted {len(df)} records")
    
except Exception as e:
    # Log with context
    logger.error(
        f"❌ Operation failed: {str(e)}", 
        exc_info=True  # Includes full traceback
    )
    
    # Rollback if needed
    session.rollback()
    
    # Re-raise or handle
    raise
```

### Retry Logic

Failed operations automatically retry (configurable):

```python
for attempt in range(MAX_RETRIES):
    try:
        result = risky_operation()
        return result
    except Exception as e:
        if attempt < MAX_RETRIES - 1:
            logger.warning(f"Retry {attempt+1}/{MAX_RETRIES}: {str(e)}")
            time.sleep(RETRY_DELAY)
        else:
            raise
```

## 5. Data Quality Framework

### Quality Metrics

Captured at each transformation stage:

#### Customers
```python
{
    'total_rows': 4998,
    'null_percentage': 0.23,
    'duplicate_count': 0,
    'invalid_emails': 2,
    'missing_names': 12
}
```

#### Products
```python
{
    'total_rows': 1200,
    'null_percentage': 0.15,
    'duplicate_count': 0,
    'zero_price_count': 0,
    'missing_category': 5,
    'avg_margin_percent': 34.5
}
```

#### Orders
```python
{
    'total_orders': 15000,
    'total_order_items': 45000,
    'avg_items_per_order': 3.0,
    'orders_null_percentage': 0.10,
    'invalid_statuses': 0
}
```

### Quality Gates

Thresholds configured in `config/settings.py`:

| Metric | Threshold | Action |
|--------|-----------|--------|
| null_percentage | < 10% | Warn if exceeded |
| duplicate_percentage | < 1% | Warn if exceeded |
| invalid_emails | 0 | Log count |
| missing_names | < 2% | Log count |
| zero_price_count | 0 | Remove rows |

## 6. Performance Considerations

### Batch Processing
- Process data in BATCH_SIZE (default 1000) chunks
- Reduces memory footprint
- Allows progress tracking and error recovery

### Connection Pooling
- Connection establishment time: ~50ms
- Pool overhead amortized over many queries
- Peak throughput: 5 concurrent + 10 overflow

### Pandas Operations
- Use vectorized operations (not .apply() with loops)
- Sort and merge operations optimized for sorted data
- Memory efficient with chunked I/O

### SQL Optimization
- Aggregations performed in SQL (not Python)
- Indexes on JOIN and WHERE columns
- Batch inserts with method='multi'

### Example Performance Profile
```
Customers:    5,000 records    ~2s    (extraction + transform + load)
Products:     1,200 records    ~1s    (with joins)
Orders:      15,000 records    ~3s    (complex logic)
Order Items: 45,000 records    ~4s    (aggregations)
Total:       66,200 records    ~45s   (end-to-end)
```

## 7. Scalability Roadmap

### Current Capacity
- **Per Run**: 100K records comfortably
- **Daily Cadence**: One run per day
- **Cumulative**: ~30M records per year (dimension tables are slowly growing)

### Phase 2: Incremental Loading
- Only process changed records since last run
- 90% reduction in processing time
- Prerequisite: timestamp tracking on operational tables

### Phase 3: Real-Time CDC
- Change Data Capture using PostgreSQL logical decoding
- Stream changes continuously
- Near-real-time analytics updates

### Phase 4: Partitioning
- Partition fact_sales by date (monthly)
- Reduces query times for recent data
- Faster historical analysis

## 8. Security Considerations

### Credentials Management
- Database passwords stored in `.env` (not committed to git)
- Use environment variables for production
- Consider rotating credentials periodically

### Data Access
- Operational database: SELECT only (via ETL user)
- Analytics database: INSERT/UPDATE (via ETL user)
- Future: Row-level security (RLS) on sensitive dimensions

### Audit Trail
- All operations logged to `etl/logs/`
- ETL execution log table tracks pipeline runs
- Future: User attribution for manual triggers

## 9. Testing Strategy

### Unit Tests
```python
test_extractors.py
├─ test_extract_customers_count()
├─ test_extract_customers_columns()
└─ test_extract_incremental()

test_transformers.py
├─ test_transform_removes_duplicates()
├─ test_transform_fills_nulls()
├─ test_transform_validates_data()
└─ test_quality_metrics()

test_loaders.py
├─ test_load_dimension_succeeds()
├─ test_load_fact_succeeds()
└─ test_verify_counts()
```

### Integration Tests
- End-to-end pipeline execution
- Verify data matches expectations
- Compare before/after counts

### Performance Tests
- Benchmark extraction time
- Monitor memory usage
- Profile slow operations

## 10. Monitoring & Alerting (Future)

### Pipeline Health Metrics
- Execution duration (baseline: 45s)
- Row counts extracted/loaded (should match)
- Quality metrics (nulls, duplicates, invalid)
- Error count (should be 0)

### Alerting Thresholds
- Duration > 2× baseline → Investigate
- Row count mismatch > 5% → Check transformations
- Quality metrics exceeded → Review data
- Error count > 0 → Critical alert

### Dashboard Queries
```sql
-- Last 7 days performance
SELECT * FROM analytics.etl_execution_log 
WHERE execution_timestamp >= NOW() - INTERVAL '7 days'
ORDER BY execution_timestamp DESC;

-- Current data volumes
SELECT COUNT(*) FROM analytics.dim_customer;
SELECT COUNT(*) FROM analytics.dim_product;
SELECT COUNT(*) FROM analytics.fact_sales;

-- Recent customer orders
SELECT c.first_name, COUNT(f.order_id) as orders
FROM analytics.dim_customer c
LEFT JOIN analytics.fact_sales f ON c.customer_id = f.customer_id
GROUP BY c.customer_id, c.first_name
ORDER BY orders DESC
LIMIT 10;
```

## 11. Deployment

### Prerequisites
- Python 3.8+
- PostgreSQL 12+
- Network access to both databases

### Deployment Steps
1. Clone repository
2. Create virtual environment
3. Install dependencies (`pip install -r requirements.txt`)
4. Configure `.env` with database credentials
5. Initialize analytics schema: `psql ... -f 12_analytics_warehouse.sql`
6. Test connection: `python -m etl.config.database`
7. Run pipeline: `python etl/run_pipeline.py`

### Scheduling (Future)
- **Daily at 2 AM**: `0 2 * * * /path/to/etl/run_pipeline.py`
- **Weekly at Sunday 1 AM**: `0 1 * * 0 /path/to/etl/run_pipeline.py`
- Monitor via systemd journal or cron logs

## 12. Glossary

| Term | Definition |
|------|-----------|
| ETL | Extract, Transform, Load |
| Operational DB | Source database with transaction data |
| Analytics Warehouse | Destination database optimized for analysis |
| Star Schema | Fact table surrounded by dimensional tables |
| Dimension | Reference data (customers, products) |
| Fact | Transactional data (orders, sales) |
| SCD | Slowly Changing Dimension (track history) |
| Surrogate Key | Auto-generated primary key |
| Upsert | Update if exists, Insert if not |

## 13. References

- [ETL README](./README.md) - Setup & operation guide
- [Analytics Schema](../database/schema/12_analytics_warehouse.sql) - DDL
- [Configuration](./config/settings.py) - Settings reference
- Project Architecture: [docs/architecture.md](../docs/architecture.md)
