"""
======================================================
Enterprise AI Decision Intelligence Platform

Sprint 5

Module:
ETL Database Connection Management

Author:
Data Engineering Team

Description:
SQLAlchemy connection pooling and session management
for operational and analytics databases. Provides
thread-safe database access and connection reuse.

======================================================
"""

from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy.pool import QueuePool
import logging
from typing import Optional
from config.settings import DatabaseConfig, LoggingConfig

logger = logging.getLogger(__name__)


class DatabaseConnection:
    """Manages database connections and session pooling."""
    
    _operational_engine = None
    _analytics_engine = None
    _operational_session = None
    _analytics_session = None
    
    @classmethod
    def get_operational_engine(cls):
        """Get or create operational database engine."""
        if cls._operational_engine is None:
            cls._operational_engine = cls._create_engine(
                host=DatabaseConfig.OPERATIONAL_DB_HOST,
                port=DatabaseConfig.OPERATIONAL_DB_PORT,
                database=DatabaseConfig.OPERATIONAL_DB_NAME,
                user=DatabaseConfig.OPERATIONAL_DB_USER,
                password=DatabaseConfig.OPERATIONAL_DB_PASSWORD,
                pool_name='operational'
            )
            logger.info(f"Operational database engine created: {DatabaseConfig.OPERATIONAL_DB_NAME}")
        return cls._operational_engine
    
    @classmethod
    def get_analytics_engine(cls):
        """Get or create analytics database engine."""
        if cls._analytics_engine is None:
            cls._analytics_engine = cls._create_engine(
                host=DatabaseConfig.OPERATIONAL_DB_HOST,
                port=DatabaseConfig.OPERATIONAL_DB_PORT,
                database=DatabaseConfig.OPERATIONAL_DB_NAME,
                user=DatabaseConfig.OPERATIONAL_DB_USER,
                password=DatabaseConfig.OPERATIONAL_DB_PASSWORD,
                pool_name='analytics'
            )
            logger.info(f"Analytics database engine created (same server, {DatabaseConfig.ANALYTICS_SCHEMA} schema)")
        return cls._analytics_engine
    
    @classmethod
    def _create_engine(cls, host: str, port: int, database: str, user: str, 
                       password: str, pool_name: str):
        """Create SQLAlchemy engine with connection pooling."""
        connection_string = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
        
        engine = create_engine(
            connection_string,
            poolclass=QueuePool,
            pool_size=DatabaseConfig.POOL_SIZE,
            max_overflow=DatabaseConfig.MAX_OVERFLOW,
            pool_timeout=DatabaseConfig.POOL_TIMEOUT,
            pool_recycle=DatabaseConfig.POOL_RECYCLE,
            echo=False,
            connect_args={
                'connect_timeout': 10,
                'application_name': f'etl_{pool_name}'
            }
        )
        
        # Set up connection pool event listeners
        @event.listens_for(engine, "connect")
        def set_connection_parameters(dbapi_conn, connection_record):
            """Set connection parameters on new connections."""
            cursor = dbapi_conn.cursor()
            cursor.execute(f"SET search_path TO public, {DatabaseConfig.ANALYTICS_SCHEMA}")
            cursor.close()
        
        return engine
    
    @classmethod
    def get_operational_session(cls):
        """Get operational database session (scoped)."""
        if cls._operational_session is None:
            engine = cls.get_operational_engine()
            session_factory = sessionmaker(bind=engine)
            cls._operational_session = scoped_session(session_factory)
        return cls._operational_session()
    
    @classmethod
    def get_analytics_session(cls):
        """Get analytics database session (scoped)."""
        if cls._analytics_session is None:
            engine = cls.get_analytics_engine()
            session_factory = sessionmaker(bind=engine)
            cls._analytics_session = scoped_session(session_factory)
        return cls._analytics_session()
    
    @classmethod
    def close_all(cls):
        """Close all sessions and engines."""
        if cls._operational_session:
            cls._operational_session.remove()
            cls._operational_session = None
        
        if cls._analytics_session:
            cls._analytics_session.remove()
            cls._analytics_session = None
        
        if cls._operational_engine:
            cls._operational_engine.dispose()
            cls._operational_engine = None
        
        if cls._analytics_engine:
            cls._analytics_engine.dispose()
            cls._analytics_engine = None
        
        logger.info("All database connections closed")
    
    @classmethod
    def test_connection(cls, connection_type: str = 'operational') -> bool:
        """Test database connection."""
        try:
            if connection_type == 'operational':
                engine = cls.get_operational_engine()
                db_name = DatabaseConfig.OPERATIONAL_DB_NAME
            else:
                engine = cls.get_analytics_engine()
                db_name = DatabaseConfig.OPERATIONAL_DB_NAME
            
            with engine.connect() as conn:
                result = conn.execute("SELECT 1")
                logger.info(f"✅ {connection_type.upper()} database connection successful")
            return True
        except Exception as e:
            logger.error(f"❌ {connection_type.upper()} database connection failed: {str(e)}")
            return False


class DatabaseExecutor:
    """Execute queries against operational and analytics databases."""
    
    @staticmethod
    def execute_query(query: str, connection_type: str = 'operational', 
                      params: Optional[dict] = None):
        """Execute SELECT query and return results."""
        try:
            if connection_type == 'operational':
                session = DatabaseConnection.get_operational_session()
            else:
                session = DatabaseConnection.get_analytics_session()
            
            result = session.execute(query, params or {})
            return result.fetchall()
        except Exception as e:
            logger.error(f"Query execution failed: {str(e)}")
            raise
    
    @staticmethod
    def execute_update(query: str, connection_type: str = 'analytics', 
                       params: Optional[dict] = None) -> int:
        """Execute INSERT/UPDATE/DELETE query."""
        try:
            if connection_type == 'operational':
                session = DatabaseConnection.get_operational_session()
            else:
                session = DatabaseConnection.get_analytics_session()
            
            result = session.execute(query, params or {})
            session.commit()
            logger.debug(f"Query executed successfully. Rows affected: {result.rowcount}")
            return result.rowcount
        except Exception as e:
            session.rollback()
            logger.error(f"Update query failed: {str(e)}")
            raise
    
    @staticmethod
    def execute_script(script: str, connection_type: str = 'analytics'):
        """Execute multi-line SQL script."""
        try:
            if connection_type == 'operational':
                session = DatabaseConnection.get_operational_session()
            else:
                session = DatabaseConnection.get_analytics_session()
            
            # Split script into individual statements
            statements = [s.strip() for s in script.split(';') if s.strip()]
            
            for statement in statements:
                session.execute(statement)
            
            session.commit()
            logger.info(f"SQL script executed successfully ({len(statements)} statements)")
        except Exception as e:
            session.rollback()
            logger.error(f"Script execution failed: {str(e)}")
            raise


if __name__ == '__main__':
    logging.basicConfig(
        level=LoggingConfig.LOG_LEVEL,
        format=LoggingConfig.LOG_FORMAT
    )
    
    print("Testing database connections...")
    
    if DatabaseConnection.test_connection('operational'):
        print("✅ Operational database: OK")
    else:
        print("❌ Operational database: FAILED")
    
    if DatabaseConnection.test_connection('analytics'):
        print("✅ Analytics database: OK")
    else:
        print("❌ Analytics database: FAILED")
    
    DatabaseConnection.close_all()
