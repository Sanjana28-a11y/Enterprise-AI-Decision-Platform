"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Transform Product Data for Analytics

Author:
Data Engineering Team

Description:
Clean, validate, and transform product data including
pricing, categorization, and product hierarchy
for analytics warehouse.

======================================================
"""

import pandas as pd
import numpy as np
import logging
from config.logger import setup_logger

logger = setup_logger(__name__)


class ProductTransformer:
    """Transform and validate product data."""
    
    @staticmethod
    def transform(df: pd.DataFrame) -> pd.DataFrame:
        """
        Transform product data for analytics.
        
        Args:
            df: Raw product DataFrame
        
        Returns:
            Transformed product DataFrame
        """
        try:
            logger.info("=" * 60)
            logger.info("TRANSFORMATION STARTED: Products")
            logger.info("=" * 60)
            
            original_rows = len(df)
            logger.info(f"Input rows: {original_rows}")
            
            df = df.copy()
            
            # Remove duplicates
            df = df.drop_duplicates(subset=['product_id'], keep='last')
            logger.info(f"Duplicates removed: {original_rows - len(df)}")
            
            # Handle missing values
            df['category_name'] = df['category_name'].fillna('Uncategorized')
            df['supplier_name'] = df['supplier_name'].fillna('Unknown Supplier')
            df['brand'] = df['brand'].fillna('Generic')
            df['description'] = df['description'].fillna('')
            df['dimensions'] = df['dimensions'].fillna('N/A')
            df['color'] = df['color'].fillna('N/A')
            df['warranty_months'] = df['warranty_months'].fillna(0)
            
            # Standardize formats
            df['product_name'] = df['product_name'].str.strip()
            df['category_name'] = df['category_name'].str.strip().str.title()
            df['supplier_name'] = df['supplier_name'].str.strip().str.title()
            df['brand'] = df['brand'].str.strip().str.title()
            df['color'] = df['color'].str.strip().str.title()
            df['sku'] = df['sku'].str.strip().str.upper()
            
            # Validate and clean pricing
            df['cost_price'] = pd.to_numeric(df['cost_price'], errors='coerce').fillna(0)
            df['selling_price'] = pd.to_numeric(df['selling_price'], errors='coerce').fillna(0)
            
            # Remove rows with invalid pricing
            df = df[(df['selling_price'] > 0) | (df['cost_price'] > 0)].copy()
            
            # Calculate margin
            df['margin_amount'] = df['selling_price'] - df['cost_price']
            df['margin_percentage'] = np.where(
                df['cost_price'] > 0,
                ((df['selling_price'] - df['cost_price']) / df['cost_price'] * 100),
                0
            )
            
            # Standardize weight
            df['weight'] = pd.to_numeric(df['weight'], errors='coerce').fillna(0)
            
            # Convert timestamps
            df['launch_date'] = pd.to_datetime(df['launch_date'], errors='coerce')
            df['created_at'] = pd.to_datetime(df['created_at'], errors='coerce')
            df['updated_at'] = pd.to_datetime(df['updated_at'], errors='coerce')
            
            # Standardize status
            df['status'] = df['status'].fillna('ACTIVE').str.upper()
            valid_statuses = ['ACTIVE', 'INACTIVE', 'DISCONTINUED']
            df['status'] = df['status'].apply(
                lambda x: x if x in valid_statuses else 'ACTIVE'
            )
            
            # Create product category hierarchy
            df['price_range'] = pd.cut(
                df['selling_price'],
                bins=[0, 100, 500, 1000, float('inf')],
                labels=['Budget', 'Mid-Range', 'Premium', 'Luxury']
            )
            
            logger.info(f"✅ Transformation completed: {len(df)} rows")
            logger.info(f"   Categories: {df['category_name'].nunique()}")
            logger.info(f"   Suppliers: {df['supplier_name'].nunique()}")
            logger.info(f"   Avg margin: {df['margin_percentage'].mean():.2f}%")
            logger.info(f"   Price range: ${df['selling_price'].min():.2f} - ${df['selling_price'].max():.2f}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Transformation failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def validate_quality(df: pd.DataFrame) -> dict:
        """
        Validate data quality metrics.
        
        Args:
            df: Transformed product DataFrame
        
        Returns:
            Dictionary with quality metrics
        """
        metrics = {
            'total_rows': len(df),
            'null_percentage': (df.isnull().sum().sum() / (len(df) * len(df.columns))) * 100,
            'duplicate_count': df.duplicated(subset=['product_id']).sum(),
            'zero_price_count': (df['selling_price'] == 0).sum(),
            'missing_category': (df['category_name'] == 'Uncategorized').sum(),
            'avg_margin_percent': df['margin_percentage'].mean(),
        }
        
        logger.info("Quality Metrics:")
        for key, value in metrics.items():
            logger.info(f"  {key}: {value}")
        
        return metrics


if __name__ == '__main__':
    from extract.extract_products import ProductExtractor
    
    raw_df = ProductExtractor.extract()
    transformed_df = ProductTransformer.transform(raw_df)
    metrics = ProductTransformer.validate_quality(transformed_df)
    
    print(f"\nTransformed {len(transformed_df)} product records")
    print(transformed_df.head())
