"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Load Fact Tables into Analytics Warehouse

Author:
Data Engineering Team

Description:
Load transformed fact tables (fact_sales) into
analytics schema. Handles aggregations from orders
and order items into facts.

======================================================
"""

import pandas as pd
import logging
from config.database import DatabaseConnection
from config.settings import PipelineConfig
from config.logger import setup_logger

logger = setup_logger(__name__)


class FactLoader:
    """Load fact tables into analytics warehouse."""
    
    @staticmethod
    def prepare_fact_sales(orders_df: pd.DataFrame, items_df: pd.DataFrame, 
                          payments_df: pd.DataFrame) -> pd.DataFrame:
        """
        Prepare fact_sales table from orders, items, and payments.
        
        Args:
            orders_df: Transformed orders DataFrame
            items_df: Transformed order items DataFrame
            payments_df: Transformed payments DataFrame (if available)
        
        Returns:
            Prepared fact_sales DataFrame
        """
        try:
            logger.info("=" * 60)
            logger.info("PREPARATION STARTED: fact_sales")
            logger.info("=" * 60)
            
            # Aggregate items by order
            items_agg = items_df.groupby('order_id').agg({
                'quantity': 'sum',
                'subtotal': 'sum',
                'product_id': 'count'  # number of line items
            }).rename(columns={'product_id': 'line_item_count'}).reset_index()
            
            # Merge orders with aggregated items
            fact = orders_df.merge(items_agg, on='order_id', how='left')
            
            # Merge with payments if available
            if payments_df is not None and not payments_df.empty:
                payments_subset = payments_df[['order_id', 'payment_method', 'payment_status']].copy()
                fact = fact.merge(payments_subset, on='order_id', how='left')
            else:
                fact['payment_method'] = 'Unknown'
                fact['payment_status'] = 'Unknown'
            
            # Fill missing values
            fact['quantity'] = fact['quantity'].fillna(0)
            fact['line_item_count'] = fact['line_item_count'].fillna(0)
            
            # Add calculated fields
            fact['revenue'] = fact['total_amount']
            fact['is_completed'] = fact['order_phase'] == 'Completed'
            fact['is_cancelled'] = fact['order_phase'] == 'Failed'
            
            logger.info(f"✅ Preparation completed: {len(fact)} fact records prepared")
            logger.info(f"   Avg revenue per order: ${fact['revenue'].mean():.2f}")
            logger.info(f"   Completed orders: {fact['is_completed'].sum()}")
            
            return fact
        
        except Exception as e:
            logger.error(f"❌ Preparation failed: {str(e)}", exc_info=True)
            raise
    
    @staticmethod
    def load_fact_sales(fact_df: pd.DataFrame, recreate: bool = False) -> int:
        """
        Load fact_sales table.
        
        Args:
            fact_df: Prepared fact_sales DataFrame
            recreate: Whether to drop and recreate table
        
        Returns:
            Number of rows loaded
        """
        try:
            logger.info("=" * 60)
            logger.info("LOADING STARTED: fact_sales")
            logger.info("=" * 60)
            
            session = DatabaseConnection.get_analytics_session()
            table_name = 'fact_sales'
            
            # Create table if not exists or recreate if requested
            if recreate or PipelineConfig.RECREATE_TABLES:
                logger.info(f"Dropping and recreating {table_name}...")
                session.execute(f"DROP TABLE IF EXISTS {table_name}")
                session.commit()
            
            # Insert data
            fact_df.to_sql(
                table_name,
                session.bind,
                schema='analytics',
                if_exists='append' if not recreate else 'fail',
                index=False,
                method='multi',
                chunksize=PipelineConfig.BATCH_SIZE
            )
            
            row_count = len(fact_df)
            logger.info(f"✅ Loading completed: {row_count} fact_sales records")
            logger.info(f"   Total revenue: ${fact_df['revenue'].sum():.2f}")
            logger.info(f"   Avg order value: ${fact_df['revenue'].mean():.2f}")
            logger.info(f"   Order statuses: {fact_df['order_status'].value_counts().to_dict()}")
            
            return row_count
        
        except Exception as e:
            logger.error(f"❌ Loading failed: {str(e)}", exc_info=True)
            session.rollback()
            raise
    
    @staticmethod
    def verify_fact_counts() -> dict:
        """
        Verify row counts and aggregate values in fact tables.
        
        Returns:
            Dictionary with verification results
        """
        try:
            session = DatabaseConnection.get_analytics_session()
            
            results = {}
            
            # Count records
            count_result = session.execute(
                "SELECT COUNT(*) FROM fact_sales"
            ).fetchone()
            results['total_records'] = count_result[0] if count_result else 0
            
            # Total revenue
            revenue_result = session.execute(
                "SELECT SUM(revenue) FROM fact_sales"
            ).fetchone()
            results['total_revenue'] = float(revenue_result[0]) if revenue_result[0] else 0
            
            # Avg revenue
            avg_result = session.execute(
                "SELECT AVG(revenue) FROM fact_sales"
            ).fetchone()
            results['avg_revenue'] = float(avg_result[0]) if avg_result[0] else 0
            
            # Status distribution
            status_result = session.execute(
                "SELECT order_status, COUNT(*) FROM fact_sales GROUP BY order_status"
            ).fetchall()
            results['status_distribution'] = {row[0]: row[1] for row in status_result}
            
            logger.info("Fact Table Verification:")
            for key, value in results.items():
                logger.info(f"  {key}: {value}")
            
            return results
        
        except Exception as e:
            logger.error(f"❌ Verification failed: {str(e)}", exc_info=True)
            raise


if __name__ == '__main__':
    from extract.extract_orders import OrderExtractor
    from extract.extract_customers import CustomerExtractor
    from transform.transform_orders import OrderTransformer
    
    # Extract and transform
    raw_orders = OrderExtractor.extract_orders()
    raw_items = OrderExtractor.extract_order_items()
    raw_payments = OrderExtractor.extract_payments()
    
    transformed_orders = OrderTransformer.transform_orders(raw_orders)
    transformed_items = OrderTransformer.transform_order_items(raw_items)
    
    # Prepare and load
    fact_sales = FactLoader.prepare_fact_sales(transformed_orders, transformed_items, raw_payments)
    FactLoader.load_fact_sales(fact_sales)
    
    # Verify
    FactLoader.verify_fact_counts()
