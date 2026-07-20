"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Transform Order Data for Analytics

Author:
Data Engineering Team

Description:
Clean, validate, and transform order data including
order items and payments into analytics-ready fact table.

======================================================
"""

import pandas as pd
import numpy as np
import logging
from config.logger import setup_logger

logger = setup_logger(__name__)


class OrderTransformer:
    """Transform and validate order data."""
    
    @staticmethod
    def transform_orders(df: pd.DataFrame) -> pd.DataFrame:
        """
        Transform order data for analytics.
        
        Args:
            df: Raw orders DataFrame
        
        Returns:
            Transformed orders DataFrame
        """
        try:
            logger.info("=" * 60)
            logger.info("TRANSFORMATION STARTED: Orders")
            logger.info("=" * 60)
            
            original_rows = len(df)
            logger.info(f"Input rows: {original_rows}")
            
            df = df.copy()
            
            # Remove duplicates
            df = df.drop_duplicates(subset=['order_id'], keep='last')
            logger.info(f"Duplicates removed: {original_rows - len(df)}")
            
            # Handle missing values
            df['shipping_address'] = df['shipping_address'].fillna('')
            df['billing_address'] = df['billing_address'].fillna('')
            
            # Convert timestamps
            df['order_date'] = pd.to_datetime(df['order_date'], errors='coerce')
            df['created_at'] = pd.to_datetime(df['created_at'], errors='coerce')
            df['updated_at'] = pd.to_datetime(df['updated_at'], errors='coerce')
            
            # Standardize order status
            df['order_status'] = df['order_status'].str.strip().str.title()
            valid_statuses = ['Pending', 'Confirmed', 'Packed', 'Shipped', 'Delivered', 'Cancelled', 'Returned']
            df['order_status'] = df['order_status'].apply(
                lambda x: x if x in valid_statuses else 'Pending'
            )
            
            # Validate and clean amounts
            df['total_amount'] = pd.to_numeric(df['total_amount'], errors='coerce').fillna(0)
            df = df[df['total_amount'] >= 0].copy()
            
            # Calculate order days
            df['days_since_order'] = (pd.Timestamp.now() - df['order_date']).dt.days
            
            # Create order status category
            df['order_phase'] = df['order_status'].apply(
                lambda x: 'In Progress' if x in ['Pending', 'Confirmed', 'Packed', 'Shipped']
                         else 'Completed' if x == 'Delivered'
                         else 'Failed'
            )
            
            logger.info(f"✅ Transformation completed: {len(df)} rows")
            logger.info(f"   Status distribution: {df['order_status'].value_counts().to_dict()}")
            logger.info(f"   Total value: ${df['total_amount'].sum():.2f}")
            logger.info(f"   Avg order value: ${df['total_amount'].mean():.2f}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Transformation failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def transform_order_items(df: pd.DataFrame) -> pd.DataFrame:
        """
        Transform order items data for analytics.
        
        Args:
            df: Raw order items DataFrame
        
        Returns:
            Transformed order items DataFrame
        """
        try:
            logger.info("=" * 60)
            logger.info("TRANSFORMATION STARTED: Order Items")
            logger.info("=" * 60)
            
            original_rows = len(df)
            df = df.copy()
            
            # Remove duplicates
            df = df.drop_duplicates(subset=['order_item_id'], keep='last')
            logger.info(f"Duplicates removed: {original_rows - len(df)}")
            
            # Validate quantities
            df['quantity'] = pd.to_numeric(df['quantity'], errors='coerce').fillna(1)
            df['quantity'] = df['quantity'].apply(lambda x: max(1, int(x)))
            
            # Validate pricing
            df['unit_price'] = pd.to_numeric(df['unit_price'], errors='coerce').fillna(0)
            df['subtotal'] = pd.to_numeric(df['subtotal'], errors='coerce').fillna(0)
            
            # Recalculate subtotal for consistency
            df['subtotal_recalc'] = df['quantity'] * df['unit_price']
            df['price_difference'] = abs(df['subtotal'] - df['subtotal_recalc'])
            
            # Use recalculated subtotal if large difference
            df['subtotal'] = np.where(
                df['price_difference'] > 0.01,
                df['subtotal_recalc'],
                df['subtotal']
            )
            
            # Convert timestamps
            df['created_at'] = pd.to_datetime(df['created_at'], errors='coerce')
            
            logger.info(f"✅ Transformation completed: {len(df)} rows")
            logger.info(f"   Avg quantity: {df['quantity'].mean():.2f}")
            logger.info(f"   Price discrepancies fixed: {(df['price_difference'] > 0.01).sum()}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Transformation failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def validate_quality(orders_df: pd.DataFrame, items_df: pd.DataFrame) -> dict:
        """
        Validate data quality metrics.
        
        Args:
            orders_df: Transformed orders DataFrame
            items_df: Transformed order items DataFrame
        
        Returns:
            Dictionary with quality metrics
        """
        metrics = {
            'total_orders': len(orders_df),
            'total_order_items': len(items_df),
            'avg_items_per_order': len(items_df) / len(orders_df),
            'orders_null_percentage': (orders_df.isnull().sum().sum() / (len(orders_df) * len(orders_df.columns))) * 100,
            'invalid_statuses': (~orders_df['order_status'].isin(['Pending', 'Confirmed', 'Packed', 'Shipped', 'Delivered', 'Cancelled', 'Returned'])).sum(),
        }
        
        logger.info("Quality Metrics:")
        for key, value in metrics.items():
            logger.info(f"  {key}: {value}")
        
        return metrics


if __name__ == '__main__':
    from extract.extract_orders import OrderExtractor
    
    raw_orders = OrderExtractor.extract_orders()
    raw_items = OrderExtractor.extract_order_items()
    
    transformed_orders = OrderTransformer.transform_orders(raw_orders)
    transformed_items = OrderTransformer.transform_order_items(raw_items)
    metrics = OrderTransformer.validate_quality(transformed_orders, transformed_items)
    
    print(f"\nTransformed {len(transformed_orders)} orders and {len(transformed_items)} items")
