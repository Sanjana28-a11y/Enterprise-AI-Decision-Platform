"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
ETL Logger Configuration

Author:
Data Engineering Team

Description:
Centralized logging setup for the ETL pipeline with
file and console handlers, custom formatting, and
per-module logger configuration.

======================================================
"""

import logging
import logging.handlers
from pathlib import Path
from config.settings import LoggingConfig
from datetime import datetime


def setup_logger(name: str, level: str = None) -> logging.Logger:
    """
    Configure and return a logger instance.
    
    Args:
        name: Logger name (typically __name__)
        level: Log level (overrides default)
    
    Returns:
        Configured logger instance
    """
    logger = logging.getLogger(name)
    
    # Avoid duplicate handlers
    if logger.hasHandlers():
        return logger
    
    log_level = level or LoggingConfig.LOG_LEVEL
    logger.setLevel(getattr(logging, log_level))
    
    # Console handler (INFO and above)
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_formatter = logging.Formatter(LoggingConfig.LOG_FORMAT)
    console_handler.setFormatter(console_formatter)
    logger.addHandler(console_handler)
    
    # File handler (DEBUG and above)
    log_file = Path(LoggingConfig.LOG_DIR) / f"etl_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
    file_handler = logging.handlers.RotatingFileHandler(
        log_file,
        maxBytes=10 * 1024 * 1024,  # 10MB
        backupCount=5
    )
    file_handler.setLevel(logging.DEBUG)
    file_formatter = logging.Formatter(LoggingConfig.LOG_FILE_FORMAT)
    file_handler.setFormatter(file_formatter)
    logger.addHandler(file_handler)
    
    return logger


# Pipeline-level logger
pipeline_logger = setup_logger('ETL_PIPELINE')


if __name__ == '__main__':
    test_logger = setup_logger('TEST')
    test_logger.debug("Debug message")
    test_logger.info("Info message")
    test_logger.warning("Warning message")
    test_logger.error("Error message")
    print(f"Logs written to: {LoggingConfig.LOG_DIR}")
