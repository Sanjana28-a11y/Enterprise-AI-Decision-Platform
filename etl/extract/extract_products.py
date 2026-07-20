"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Extract Products from Operational Database

Author:
Data Engineering Team

Description:
Extract product data including categories, suppliers,
pricing, and product attributes for transformation
and analytics loading.

======================================================
"""

import pandas as pd
import logging
from config.database import DatabaseConnection
from config.logger import setup_logger

logger = setup_logger(__name__)


class ProductExtractor:
    """Extract product data from operational database."""
    
    @staticmethod
    def extract() -> pd.DataFrame:
        """
        Extract all product records from operational database.
        
        Returns:
            DataFrame with product data
        """
        try:
            logger.info("=" * 60)
            logger.info("EXTRACTION STARTED: Products")
            logger.info("=" * 60)
            
            query = """
            SELECT 
                p.product_id,
                p.product_name,
                p.description,
                p.category_id,
                c.category_name,
                p.supplier_id,
                s.supplier_name,
                p.brand,
                p.sku,
                p.cost_price,
                p.selling_price,
                p.weight,
                p.dimensions,
                p.color,
                p.warranty_months,
                p.launch_date,
                p.status,
                p.created_at,
                p.updated_at
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
            ORDER BY p.product_id
            """
            
            session = DatabaseConnection.get_operational_session()
            df = pd.read_sql(query, session.bind)
            
            row_count = len(df)
            logger.info(f"✅ Extraction completed: {row_count} product records extracted")
            logger.info(f"   Columns: {', '.join(df.columns.tolist())}")
            logger.info(f"   Category count: {df['category_name'].nunique()}")
            logger.info(f"   Supplier count: {df['supplier_name'].nunique()}")
            logger.info(f"   Price range: ${df['selling_price'].min():.2f} - ${df['selling_price'].max():.2f}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Extraction failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def extract_incremental(last_updated: pd.Timestamp) -> pd.DataFrame:
        """
        Extract only products updated since last_updated timestamp.
        
        Args:
            last_updated: Timestamp of last extraction
        
        Returns:
            DataFrame with updated product records
        """
        try:
            logger.info(f"INCREMENTAL EXTRACTION: Products updated since {last_updated}")
            
            query = """
            SELECT 
                p.product_id,
                p.product_name,
                p.description,
                p.category_id,
                c.category_name,
                p.supplier_id,
                s.supplier_name,
                p.brand,
                p.sku,
                p.cost_price,
                p.selling_price,
                p.weight,
                p.dimensions,
                p.color,
                p.warranty_months,
                p.launch_date,
                p.status,
                p.created_at,
                p.updated_at
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
            WHERE p.updated_at > :last_updated
            ORDER BY p.product_id
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
    df = ProductExtractor.extract()
    print(f"\nExtracted {len(df)} product records:")
    print(df.head())
