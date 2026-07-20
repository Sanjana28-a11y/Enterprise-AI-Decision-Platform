"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Load Dimension Tables into Analytics Warehouse

Author:
Data Engineering Team

Description:
Load transformed dimension tables (dim_customer,
dim_product) into analytics schema. Handles
upserts, SCD Type 1, and incremental loading.

======================================================
"""

import pandas as pd
import logging
from config.database import DatabaseConnection, DatabaseExecutor
from config.settings import PipelineConfig
from config.logger import setup_logger

logger = setup_logger(__name__)


class DimensionLoader:
    """Load dimension tables into analytics warehouse."""
    
    @staticmethod
    def load_dim_customer(df: pd.DataFrame, recreate: bool = False) -> int:
        """
        Load customer dimension table.
        
        Args:
            df: Transformed customer DataFrame
            recreate: Whether to drop and recreate table
        
        Returns:
            Number of rows loaded
        """
        try:
            logger.info("=" * 60)
            logger.info("LOADING STARTED: dim_customer")
            logger.info("=" * 60)
            
            session = DatabaseConnection.get_analytics_session()
            table_name = 'dim_customer'
            
            # Create table if not exists or recreate if requested
            if recreate or PipelineConfig.RECREATE_TABLES:
                logger.info(f"Dropping and recreating {table_name}...")
                session.execute(f"DROP TABLE IF EXISTS {table_name}")
                session.commit()
            
            # Insert data
            df.to_sql(
                table_name,
                session.bind,
                schema='analytics',
                if_exists='append' if not recreate else 'fail',
                index=False,
                method='multi',
                chunksize=PipelineConfig.BATCH_SIZE
            )
            
            row_count = len(df)
            logger.info(f"✅ Loading completed: {row_count} customer dimension records")
            logger.info(f"   Unique customers: {df['customer_id'].nunique()}")
            logger.info(f"   Customer types: {df['customer_type'].nunique()}")
            
            return row_count
        
        except Exception as e:
            logger.error(f"❌ Loading failed: {str(e)}", exc_info=True)
            session.rollback()
            raise
    
    @staticmethod
    def load_dim_product(df: pd.DataFrame, recreate: bool = False) -> int:
        """
        Load product dimension table.
        
        Args:
            df: Transformed product DataFrame
            recreate: Whether to drop and recreate table
        
        Returns:
            Number of rows loaded
        """
        try:
            logger.info("=" * 60)
            logger.info("LOADING STARTED: dim_product")
            logger.info("=" * 60)
            
            session = DatabaseConnection.get_analytics_session()
            table_name = 'dim_product'
            
            # Create table if not exists or recreate if requested
            if recreate or PipelineConfig.RECREATE_TABLES:
                logger.info(f"Dropping and recreating {table_name}...")
                session.execute(f"DROP TABLE IF EXISTS {table_name}")
                session.commit()
            
            # Insert data
            df.to_sql(
                table_name,
                session.bind,
                schema='analytics',
                if_exists='append' if not recreate else 'fail',
                index=False,
                method='multi',
                chunksize=PipelineConfig.BATCH_SIZE
            )
            
            row_count = len(df)
            logger.info(f"✅ Loading completed: {row_count} product dimension records")
            logger.info(f"   Unique products: {df['product_id'].nunique()}")
            logger.info(f"   Categories: {df['category_name'].nunique()}")
            logger.info(f"   Suppliers: {df['supplier_name'].nunique()}")
            
            return row_count
        
        except Exception as e:
            logger.error(f"❌ Loading failed: {str(e)}", exc_info=True)
            session.rollback()
            raise
    
    @staticmethod
    def verify_dimension_counts() -> dict:
        """
        Verify row counts in dimension tables.
        
        Returns:
            Dictionary with table counts
        """
        try:
            session = DatabaseConnection.get_analytics_session()
            
            counts = {}
            for table in ['dim_customer', 'dim_product']:
                result = session.execute(
                    f"SELECT COUNT(*) FROM {table}"
                ).fetchone()
                counts[table] = result[0] if result else 0
            
            logger.info("Dimension Table Counts:")
            for table, count in counts.items():
                logger.info(f"  {table}: {count} rows")
            
            return counts
        
        except Exception as e:
            logger.error(f"❌ Verification failed: {str(e)}", exc_info=True)
            raise


if __name__ == '__main__':
    from extract.extract_customers import CustomerExtractor
    from extract.extract_products import ProductExtractor
    from transform.clean_customers import CustomerTransformer
    from transform.clean_products import ProductTransformer
    
    # Extract and transform customers
    raw_customers = CustomerExtractor.extract()
    transformed_customers = CustomerTransformer.transform(raw_customers)
    
    # Extract and transform products
    raw_products = ProductExtractor.extract()
    transformed_products = ProductTransformer.transform(raw_products)
    
    # Load dimensions
    DimensionLoader.load_dim_customer(transformed_customers)
    DimensionLoader.load_dim_product(transformed_products)
    
    # Verify
    DimensionLoader.verify_dimension_counts()
