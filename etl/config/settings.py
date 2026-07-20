"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
ETL Configuration Settings

Author:
Data Engineering Team

Description:
Centralized configuration management for ETL pipeline,
including environment variables, database settings,
logging configuration, and pipeline parameters.

======================================================
"""

import os
from dotenv import load_dotenv
from pathlib import Path

# Load environment variables from .env file
load_dotenv()

# =====================================================
# DATABASE CONFIGURATION
# =====================================================

class DatabaseConfig:
    """PostgreSQL database connection configuration."""
    
    # Operational Database (Source)
    OPERATIONAL_DB_HOST = os.getenv('DB_OPERATIONAL_HOST', 'localhost')
    OPERATIONAL_DB_PORT = int(os.getenv('DB_OPERATIONAL_PORT', 5432))
    OPERATIONAL_DB_NAME = os.getenv('DB_OPERATIONAL_NAME', 'enterprise_ai_platform')
    OPERATIONAL_DB_USER = os.getenv('DB_OPERATIONAL_USER', 'postgres')
    OPERATIONAL_DB_PASSWORD = os.getenv('DB_OPERATIONAL_PASSWORD', '')
    
    # Analytics Database (Destination - same server, different schema)
    ANALYTICS_SCHEMA = os.getenv('DB_ANALYTICS_SCHEMA', 'analytics')
    
    # Connection Pool Settings
    POOL_SIZE = int(os.getenv('DB_POOL_SIZE', 5))
    MAX_OVERFLOW = int(os.getenv('DB_MAX_OVERFLOW', 10))
    POOL_TIMEOUT = int(os.getenv('DB_POOL_TIMEOUT', 30))
    POOL_RECYCLE = int(os.getenv('DB_POOL_RECYCLE', 3600))


# =====================================================
# LOGGING CONFIGURATION
# =====================================================

class LoggingConfig:
    """Logging settings for ETL pipeline."""
    
    LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
    LOG_DIR = os.getenv('LOG_DIR', str(Path(__file__).parent.parent / 'logs'))
    LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    LOG_FILE_FORMAT = '[%(asctime)s] %(levelname)-8s [%(name)s:%(lineno)d] %(message)s'
    
    # Ensure log directory exists
    Path(LOG_DIR).mkdir(parents=True, exist_ok=True)


# =====================================================
# PIPELINE CONFIGURATION
# =====================================================

class PipelineConfig:
    """ETL pipeline execution settings."""
    
    # Batch size for processing
    BATCH_SIZE = int(os.getenv('ETL_BATCH_SIZE', 1000))
    
    # Number of retries on failure
    MAX_RETRIES = int(os.getenv('ETL_MAX_RETRIES', 3))
    
    # Retry delay in seconds
    RETRY_DELAY = int(os.getenv('ETL_RETRY_DELAY', 5))
    
    # Data validation settings
    VALIDATE_DATA = os.getenv('ETL_VALIDATE_DATA', 'True').lower() == 'true'
    
    # Incremental loading flag
    INCREMENTAL_LOAD = os.getenv('ETL_INCREMENTAL_LOAD', 'False').lower() == 'true'
    
    # Drop existing tables (for dev/test)
    RECREATE_TABLES = os.getenv('ETL_RECREATE_TABLES', 'False').lower() == 'true'


# =====================================================
# DATA QUALITY CONFIGURATION
# =====================================================

class DataQualityConfig:
    """Data quality thresholds and rules."""
    
    # Maximum allowed null percentage per column
    NULL_THRESHOLD = float(os.getenv('DQ_NULL_THRESHOLD', 0.1))
    
    # Duplicate row percentage threshold
    DUPLICATE_THRESHOLD = float(os.getenv('DQ_DUPLICATE_THRESHOLD', 0.01))
    
    # Enable data profiling
    ENABLE_PROFILING = os.getenv('DQ_ENABLE_PROFILING', 'False').lower() == 'true'


# =====================================================
# UTILITY FUNCTIONS
# =====================================================

def get_config(config_class):
    """Get configuration class as dictionary."""
    return {
        key: getattr(config_class, key)
        for key in dir(config_class)
        if not key.startswith('_')
    }


def validate_config():
    """Validate critical configuration parameters."""
    errors = []
    
    if not DatabaseConfig.OPERATIONAL_DB_PASSWORD:
        errors.append("DB_OPERATIONAL_PASSWORD is not set")
    
    if not os.path.exists(LoggingConfig.LOG_DIR):
        try:
            Path(LoggingConfig.LOG_DIR).mkdir(parents=True, exist_ok=True)
        except Exception as e:
            errors.append(f"Cannot create log directory: {e}")
    
    return errors


if __name__ == '__main__':
    print("Database Configuration:")
    print(f"  Host: {DatabaseConfig.OPERATIONAL_DB_HOST}")
    print(f"  Port: {DatabaseConfig.OPERATIONAL_DB_PORT}")
    print(f"  Database: {DatabaseConfig.OPERATIONAL_DB_NAME}")
    print(f"  Analytics Schema: {DatabaseConfig.ANALYTICS_SCHEMA}")
    print("\nLogging Configuration:")
    print(f"  Log Level: {LoggingConfig.LOG_LEVEL}")
    print(f"  Log Directory: {LoggingConfig.LOG_DIR}")
    print("\nValidation Errors:")
    errors = validate_config()
    if errors:
        for error in errors:
            print(f"  ⚠️  {error}")
    else:
        print("  ✅ All configurations valid")
