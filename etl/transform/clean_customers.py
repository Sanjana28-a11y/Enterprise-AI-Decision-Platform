"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Transform Customer Data for Analytics

Author:
Data Engineering Team

Description:
Clean, validate, and transform customer data for
analytics warehouse. Handles missing values, formatting,
and dimension table preparation.

======================================================
"""

import pandas as pd
import numpy as np
import logging
from datetime import datetime
from config.logger import setup_logger

logger = setup_logger(__name__)


class CustomerTransformer:
    """Transform and validate customer data."""
    
    @staticmethod
    def transform(df: pd.DataFrame) -> pd.DataFrame:
        """
        Transform customer data for analytics.
        
        Args:
            df: Raw customer DataFrame
        
        Returns:
            Transformed customer DataFrame
        """
        try:
            logger.info("=" * 60)
            logger.info("TRANSFORMATION STARTED: Customers")
            logger.info("=" * 60)
            
            original_rows = len(df)
            logger.info(f"Input rows: {original_rows}")
            
            df = df.copy()
            
            # Remove duplicates
            df = df.drop_duplicates(subset=['customer_id'], keep='last')
            logger.info(f"Duplicates removed: {original_rows - len(df)}")
            
            # Handle missing values
            df['first_name'] = df['first_name'].fillna('Unknown')
            df['last_name'] = df['last_name'].fillna('Unknown')
            df['email'] = df['email'].fillna('no-email@unknown.com')
            df['phone'] = df['phone'].fillna('N/A')
            df['gender'] = df['gender'].fillna('Unknown')
            df['date_of_birth'] = pd.to_datetime(df['date_of_birth'], errors='coerce')
            
            # Standardize formats
            df['first_name'] = df['first_name'].str.strip().str.title()
            df['last_name'] = df['last_name'].str.strip().str.title()
            df['email'] = df['email'].str.lower().str.strip()
            df['phone'] = df['phone'].str.strip()
            df['city'] = df['city'].str.strip().str.title()
            df['state'] = df['state'].str.strip().str.title()
            df['country'] = df['country'].fillna('India').str.strip().str.title()
            
            # Standardize customer type
            df['customer_type'] = df['customer_type'].fillna('Regular').str.title()
            valid_types = ['Regular', 'Premium', 'Business']
            df['customer_type'] = df['customer_type'].apply(
                lambda x: x if x in valid_types else 'Regular'
            )
            
            # Standardize status
            df['status'] = df['status'].fillna('ACTIVE').str.upper()
            valid_statuses = ['ACTIVE', 'INACTIVE']
            df['status'] = df['status'].apply(
                lambda x: x if x in valid_statuses else 'ACTIVE'
            )
            
            # Convert timestamps
            df['registration_date'] = pd.to_datetime(df['registration_date'], errors='coerce')
            df['created_at'] = pd.to_datetime(df['created_at'], errors='coerce')
            df['updated_at'] = pd.to_datetime(df['updated_at'], errors='coerce')
            
            # Calculate age (for analytics)
            df['age'] = df['date_of_birth'].apply(
                lambda x: (datetime.now() - x).days // 365 if pd.notna(x) else None
            )
            
            # Create customer segment based on type and activity
            df['customer_segment'] = df.apply(
                lambda row: f"{row['customer_type']}_{row['city']}", axis=1
            )
            
            # Validate key fields
            null_counts = df.isnull().sum()
            logger.info(f"Null values after cleaning:")
            for col, count in null_counts[null_counts > 0].items():
                logger.info(f"  {col}: {count}")
            
            logger.info(f"✅ Transformation completed: {len(df)} rows")
            logger.info(f"   Customer types: {df['customer_type'].value_counts().to_dict()}")
            logger.info(f"   Cities: {df['city'].nunique()}")
            logger.info(f"   Active customers: {(df['status'] == 'ACTIVE').sum()}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Transformation failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def validate_quality(df: pd.DataFrame) -> dict:
        """
        Validate data quality metrics.
        
        Args:
            df: Transformed customer DataFrame
        
        Returns:
            Dictionary with quality metrics
        """
        metrics = {
            'total_rows': len(df),
            'null_percentage': (df.isnull().sum().sum() / (len(df) * len(df.columns))) * 100,
            'duplicate_count': df.duplicated(subset=['customer_id']).sum(),
            'invalid_emails': (~df['email'].str.contains('@', na=False)).sum(),
            'missing_names': (df['first_name'] == 'Unknown').sum(),
        }
        
        logger.info("Quality Metrics:")
        for key, value in metrics.items():
            logger.info(f"  {key}: {value}")
        
        return metrics


if __name__ == '__main__':
    from extract.extract_customers import CustomerExtractor
    
    raw_df = CustomerExtractor.extract()
    transformed_df = CustomerTransformer.transform(raw_df)
    metrics = CustomerTransformer.validate_quality(transformed_df)
    
    print(f"\nTransformed {len(transformed_df)} customer records")
    print(transformed_df.head())
