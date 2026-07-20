"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
Main ETL Pipeline Runner

Author:
Data Engineering Team

Description:
Orchestrates the complete ETL pipeline: extract,
transform, and load. Manages logging, error handling,
and pipeline state.

======================================================
"""

import sys
import time
import logging
from datetime import datetime
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from config.settings import PipelineConfig, validate_config
from config.database import DatabaseConnection
from config.logger import setup_logger, pipeline_logger

from extract import CustomerExtractor, ProductExtractor, OrderExtractor
from transform import CustomerTransformer, ProductTransformer, OrderTransformer
from load import DimensionLoader, FactLoader


class ETLPipeline:
    """Main ETL pipeline orchestrator."""
    
    def __init__(self):
        """Initialize pipeline."""
        self.logger = setup_logger('ETL_PIPELINE')
        self.start_time = None
        self.end_time = None
        self.stats = {
            'customers_extracted': 0,
            'products_extracted': 0,
            'orders_extracted': 0,
            'order_items_extracted': 0,
            'payments_extracted': 0,
            'customers_loaded': 0,
            'products_loaded': 0,
            'sales_loaded': 0,
            'errors': []
        }
    
    def run(self) -> bool:
        """
        Execute complete ETL pipeline.
        
        Returns:
            True if successful, False otherwise
        """
        self.start_time = datetime.now()
        self.logger.info("╔" + "=" * 58 + "╗")
        self.logger.info("║  ETL PIPELINE STARTED                                    ║")
        self.logger.info(f"║  Timestamp: {self.start_time.strftime('%Y-%m-%d %H:%M:%S')}                              ║")
        self.logger.info("╚" + "=" * 58 + "╝")
        
        try:
            # Validate configuration
            errors = validate_config()
            if errors:
                self.logger.error("❌ Configuration validation failed:")
                for error in errors:
                    self.logger.error(f"   {error}")
                return False
            
            # Test database connections
            if not DatabaseConnection.test_connection('operational'):
                self.logger.error("❌ Cannot connect to operational database")
                return False
            
            if not DatabaseConnection.test_connection('analytics'):
                self.logger.error("❌ Cannot connect to analytics database")
                return False
            
            # Execute pipeline stages
            if not self._extract_stage():
                return False
            
            if not self._transform_stage():
                return False
            
            if not self._load_stage():
                return False
            
            self._finalize()
            return True
        
        except Exception as e:
            self.logger.error(f"❌ PIPELINE FAILED: {str(e)}", exc_info=True)
            self.stats['errors'].append(str(e))
            self._finalize()
            return False
        
        finally:
            DatabaseConnection.close_all()
    
    def _extract_stage(self) -> bool:
        """Execute extraction stage."""
        self.logger.info("\n" + "=" * 60)
        self.logger.info("STAGE 1: EXTRACTION")
        self.logger.info("=" * 60)
        
        try:
            # Extract customers
            self.customers_raw = CustomerExtractor.extract()
            self.stats['customers_extracted'] = len(self.customers_raw)
            
            # Extract products
            self.products_raw = ProductExtractor.extract()
            self.stats['products_extracted'] = len(self.products_raw)
            
            # Extract orders
            self.orders_raw = OrderExtractor.extract_orders()
            self.stats['orders_extracted'] = len(self.orders_raw)
            
            self.order_items_raw = OrderExtractor.extract_order_items()
            self.stats['order_items_extracted'] = len(self.order_items_raw)
            
            self.payments_raw = OrderExtractor.extract_payments()
            self.stats['payments_extracted'] = len(self.payments_raw)
            
            self.logger.info("\n✅ EXTRACTION STAGE COMPLETED")
            return True
        
        except Exception as e:
            self.logger.error(f"❌ EXTRACTION FAILED: {str(e)}", exc_info=True)
            self.stats['errors'].append(f"Extraction: {str(e)}")
            return False
    
    def _transform_stage(self) -> bool:
        """Execute transformation stage."""
        self.logger.info("\n" + "=" * 60)
        self.logger.info("STAGE 2: TRANSFORMATION")
        self.logger.info("=" * 60)
        
        try:
            # Transform customers
            self.customers_transformed = CustomerTransformer.transform(self.customers_raw)
            CustomerTransformer.validate_quality(self.customers_transformed)
            
            # Transform products
            self.products_transformed = ProductTransformer.transform(self.products_raw)
            ProductTransformer.validate_quality(self.products_transformed)
            
            # Transform orders
            self.orders_transformed = OrderTransformer.transform_orders(self.orders_raw)
            self.order_items_transformed = OrderTransformer.transform_order_items(self.order_items_raw)
            OrderTransformer.validate_quality(self.orders_transformed, self.order_items_transformed)
            
            self.logger.info("\n✅ TRANSFORMATION STAGE COMPLETED")
            return True
        
        except Exception as e:
            self.logger.error(f"❌ TRANSFORMATION FAILED: {str(e)}", exc_info=True)
            self.stats['errors'].append(f"Transformation: {str(e)}")
            return False
    
    def _load_stage(self) -> bool:
        """Execute loading stage."""
        self.logger.info("\n" + "=" * 60)
        self.logger.info("STAGE 3: LOADING")
        self.logger.info("=" * 60)
        
        try:
            # Load dimensions
            self.stats['customers_loaded'] = DimensionLoader.load_dim_customer(
                self.customers_transformed,
                recreate=PipelineConfig.RECREATE_TABLES
            )
            
            self.stats['products_loaded'] = DimensionLoader.load_dim_product(
                self.products_transformed,
                recreate=PipelineConfig.RECREATE_TABLES
            )
            
            # Prepare and load facts
            fact_sales = FactLoader.prepare_fact_sales(
                self.orders_transformed,
                self.order_items_transformed,
                self.payments_raw
            )
            
            self.stats['sales_loaded'] = FactLoader.load_fact_sales(
                fact_sales,
                recreate=PipelineConfig.RECREATE_TABLES
            )
            
            # Verify loads
            DimensionLoader.verify_dimension_counts()
            FactLoader.verify_fact_counts()
            
            self.logger.info("\n✅ LOADING STAGE COMPLETED")
            return True
        
        except Exception as e:
            self.logger.error(f"❌ LOADING FAILED: {str(e)}", exc_info=True)
            self.stats['errors'].append(f"Loading: {str(e)}")
            return False
    
    def _finalize(self):
        """Finalize and report results."""
        self.end_time = datetime.now()
        duration = (self.end_time - self.start_time).total_seconds()
        
        self.logger.info("\n" + "╔" + "=" * 58 + "╗")
        self.logger.info("║  PIPELINE SUMMARY                                        ║")
        self.logger.info("╠" + "=" * 58 + "╣")
        self.logger.info(f"║ Extracted      │ Customers: {self.stats['customers_extracted']:>6} Products: {self.stats['products_extracted']:>6}          ║")
        self.logger.info(f"║                │ Orders: {self.stats['orders_extracted']:>8} Items: {self.stats['order_items_extracted']:>9}     ║")
        self.logger.info(f"║ Loaded         │ Dim_Customer: {self.stats['customers_loaded']:>6} Dim_Product: {self.stats['products_loaded']:>6}      ║")
        self.logger.info(f"║                │ Fact_Sales: {self.stats['sales_loaded']:>9}                           ║")
        
        if self.stats['errors']:
            self.logger.info(f"║ Errors         │ {len(self.stats['errors']):>2} error(s) occurred                            ║")
        else:
            self.logger.info("║ Status         │ ✅ SUCCESS                                        ║")
        
        self.logger.info(f"║ Duration       │ {duration:.2f} seconds                                 ║")
        self.logger.info("╚" + "=" * 58 + "╝")
        
        if self.stats['errors']:
            self.logger.info("\nErrors encountered:")
            for error in self.stats['errors']:
                self.logger.error(f"  • {error}")


def main():
    """Main entry point."""
    pipeline = ETLPipeline()
    success = pipeline.run()
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
