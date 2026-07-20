"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Extract Customers from Operational Database

Author:
Data Engineering Team

Description:
Extract customer data from operational database.
Retrieves all customer records with demographics,
contact info, and membership tiers for transformation.

======================================================
"""

import pandas as pd
import logging
from config.database import DatabaseConnection
from config.logger import setup_logger

logger = setup_logger(__name__)


class CustomerExtractor:
    """Extract customer data from operational database."""
    
    @staticmethod
    def extract() -> pd.DataFrame:
        """
        Extract all customer records from operational database.
        
        Returns:
            DataFrame with customer data
        """
        try:
            logger.info("=" * 60)
            logger.info("EXTRACTION STARTED: Customers")
            logger.info("=" * 60)
            
            query = """
            SELECT 
                customer_id,
                first_name,
                last_name,
                email,
                phone,
                date_of_birth,
                gender,
                customer_type,
                city,
                state,
                country,
                registration_date,
                status,
                created_at,
                updated_at
            FROM customers
            ORDER BY customer_id
            """
            
            session = DatabaseConnection.get_operational_session()
            df = pd.read_sql(query, session.bind)
            
            row_count = len(df)
            logger.info(f"✅ Extraction completed: {row_count} customer records extracted")
            logger.info(f"   Columns: {', '.join(df.columns.tolist())}")
            logger.info(f"   Date range: {df['registration_date'].min()} to {df['registration_date'].max()}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Extraction failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def extract_incremental(last_updated: pd.Timestamp) -> pd.DataFrame:
        """
        Extract only customers updated since last_updated timestamp.
        
        Args:
            last_updated: Timestamp of last extraction
        
        Returns:
            DataFrame with updated customer records
        """
        try:
            logger.info(f"INCREMENTAL EXTRACTION: Customers updated since {last_updated}")
            
            query = """
            SELECT 
                customer_id,
                first_name,
                last_name,
                email,
                phone,
                date_of_birth,
                gender,
                customer_type,
                city,
                state,
                country,
                registration_date,
                status,
                created_at,
                updated_at
            FROM customers
            WHERE updated_at > :last_updated
            ORDER BY customer_id
            """
            
            session = DatabaseConnection.get_operational_session()
            df = pd.read_sql(query, session.bind, params={'last_updated': last_updated})
            
            row_count = len(df)
            logger.info(f"✅ Incremental extraction completed: {row_count} updated records")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Incremental extraction failed: {str(e)}", exc_info=True)
            raise


if __name__ == '__main__':
    df = CustomerExtractor.extract()
    print(f"\nExtracted {len(df)} customer records:")
    print(df.head())
