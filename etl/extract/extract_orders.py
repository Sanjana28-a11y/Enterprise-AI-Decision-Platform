"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Extract Orders from Operational Database

Author:
Data Engineering Team

Description:
Extract order and order items data including transaction
details, line items, and payment information for analytics.

======================================================
"""

import pandas as pd
import logging
from config.database import DatabaseConnection
from config.logger import setup_logger

logger = setup_logger(__name__)


class OrderExtractor:
    """Extract order data from operational database."""
    
    @staticmethod
    def extract_orders() -> pd.DataFrame:
        """
        Extract all order records from operational database.
        
        Returns:
            DataFrame with order data
        """
        try:
            logger.info("=" * 60)
            logger.info("EXTRACTION STARTED: Orders")
            logger.info("=" * 60)
            
            query = """
            SELECT 
                o.order_id,
                o.customer_id,
                o.order_number,
                o.order_date,
                o.order_status,
                o.total_amount,
                o.shipping_address,
                o.billing_address,
                o.created_at,
                o.updated_at
            FROM orders o
            ORDER BY o.order_date DESC
            """
            
            session = DatabaseConnection.get_operational_session()
            df = pd.read_sql(query, session.bind)
            
            row_count = len(df)
            logger.info(f"✅ Extraction completed: {row_count} order records extracted")
            logger.info(f"   Columns: {', '.join(df.columns.tolist())}")
            logger.info(f"   Date range: {df['order_date'].min()} to {df['order_date'].max()}")
            logger.info(f"   Status distribution: {df['order_status'].value_counts().to_dict()}")
            logger.info(f"   Total order value: ${df['total_amount'].sum():.2f}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Extraction failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def extract_order_items() -> pd.DataFrame:
        """
        Extract all order items from operational database.
        
        Returns:
            DataFrame with order items data
        """
        try:
            logger.info("=" * 60)
            logger.info("EXTRACTION STARTED: Order Items")
            logger.info("=" * 60)
            
            query = """
            SELECT 
                oi.order_item_id,
                oi.order_id,
                oi.product_id,
                oi.quantity,
                oi.unit_price,
                oi.subtotal,
                oi.created_at,
                p.product_name,
                p.sku
            FROM order_items oi
            JOIN products p ON oi.product_id = p.product_id
            ORDER BY oi.order_id
            """
            
            session = DatabaseConnection.get_operational_session()
            df = pd.read_sql(query, session.bind)
            
            row_count = len(df)
            logger.info(f"✅ Extraction completed: {row_count} order item records extracted")
            logger.info(f"   Average quantity per item: {df['quantity'].mean():.2f}")
            logger.info(f"   Total items value: ${df['subtotal'].sum():.2f}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Extraction failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def extract_payments() -> pd.DataFrame:
        """
        Extract all payment records from operational database.
        
        Returns:
            DataFrame with payment data
        """
        try:
            logger.info("=" * 60)
            logger.info("EXTRACTION STARTED: Payments")
            logger.info("=" * 60)
            
            query = """
            SELECT 
                p.payment_id,
                p.order_id,
                p.payment_method,
                p.payment_status,
                p.transaction_reference,
                p.payment_date,
                p.amount,
                p.created_at
            FROM payments p
            ORDER BY p.payment_date DESC
            """
            
            session = DatabaseConnection.get_operational_session()
            df = pd.read_sql(query, session.bind)
            
            row_count = len(df)
            logger.info(f"✅ Extraction completed: {row_count} payment records extracted")
            logger.info(f"   Payment methods: {df['payment_method'].value_counts().to_dict()}")
            logger.info(f"   Payment status: {df['payment_status'].value_counts().to_dict()}")
            logger.info(f"   Total payments: ${df['amount'].sum():.2f}")
            
            return df
        
        except Exception as e:
            logger.error(f"❌ Extraction failed: {str(e)}", exc_info=True)
            raise


if __name__ == '__main__':
    orders_df = OrderExtractor.extract_orders()
    items_df = OrderExtractor.extract_order_items()
    payments_df = OrderExtractor.extract_payments()
    
    print(f"\nExtracted orders: {len(orders_df)}")
    print(f"Extracted order items: {len(items_df)}")
    print(f"Extracted payments: {len(payments_df)}")
