# Development Roadmap

This roadmap outlines the engineering stages for the **Enterprise AI Decision Intelligence Platform**. Development is structured in 10 sequential phases, transitioning from foundation and data pipes to machine learning models, generative AI, and final cloud deployment.

---

## Roadmap at a Glance

| Phase | Title | Focus | Target Milestone |
| :--- | :--- | :--- | :--- |
| **Phase 1** | Project Setup | Scaffolding, repository initialization, and workspace setup | Complete workspace |
| **Phase 2** | Database Design | Relational schema modeling and constraints definition | Entity-Relationship Diagram (ERD) |
| **Phase 3** | PostgreSQL Implementation | Database build, indexing strategies, and sample data load | Clean SQL schemas & seed scripts |
| **Phase 4** | ETL Pipeline | Python pipelines for data cleaning and loading | Working scheduler & raw-to-warehouse pipeline |
| **Phase 5** | Backend APIs | Node.js/Express server scaffold with middleware | Route scaffolding & database pool |
| **Phase 6** | Analytics Engine | Analytical endpoints, sales, and warehouse reporting | Aggregated analytics routes |
| **Phase 7** | React Dashboard | Frontend layout, metrics widgets, charts, and chatbot UI | Visual dashboard client |
| **Phase 8** | Machine Learning | Demand forecasting and customer segmentation models | Predictive pipeline |
| **Phase 9** | AI Business Assistant | LangGraph integration for conversational querying | Conversational SQL assistant |
| **Phase 10**| Deployment | Docker containerization, CI/CD, and server setup | Live cloud production build |

---

## Detailed Phases

### Phase 1 - Project Setup
- **Objective:** Establish the foundational codebase structure, setup standard linting/formatting rules, configure environment variables, and create basic setup scripts.
- **Milestone:** Project structure initialized with `.gitignore`, initial directory layout, and configurations.
- **Deliverables:**
  - Standard directory structure (`backend/`, `frontend/`, `etl/`, etc.).
  - Configured workspace linting and environment templates (`.env.example`).
  - Readme.md and developer documentation.

### Phase 2 - Database Design
- **Objective:** Design the logical and physical schema for NovaMart's transactional and analytical data, building the Star Schema.
- **Milestone:** Finalized Entity-Relationship Diagram (ERD) and data dictionary.
- **Deliverables:**
  - Database schema diagrams detailing primary/foreign keys.
  - Complete data dictionary mapping all 14 core entities (Company, Customer, Product, etc.).

### Phase 3 - PostgreSQL Implementation
- **Objective:** Set up the PostgreSQL server, execute DDL scripts to create schemas, and write database seeding scripts to populate it with realistic mock data.
- **Milestone:** Local PostgreSQL instance running with schemas and base operational values.
- **Deliverables:**
  - Create table scripts (`schema.sql`) including indexes, triggers, and foreign keys.
  - Data seeding scripts (`seed.sql`) containing mock values for customer tiers, products, and historic order sequences.

### Phase 4 - ETL Pipeline
- **Objective:** Build Python scripts that pull raw JSON and CSV files from datasets, run standard pandas validation checks, clean values, and update database tables.
- **Milestone:** Automated ETL command execution resulting in a clean and up-to-date data warehouse.
- **Deliverables:**
  - Clean Python ETL framework (`etl/src/main.py`) using Pandas and SQLAlchemy.
  - Automated validation suite checks for bad dates, negative quantities, or invalid customer types.
  - Scheduled run script (Cron or workflow file).

### Phase 5 - Backend APIs
- **Objective:** Scaffold the Express.js application, configure database pooling via `pg-pool`, and structure standard middleware (logging, error handling, rate limiting).
- **Milestone:** Running backend server responding to health checks.
- **Deliverables:**
  - Structured Node.js API server (`backend/src/server.ts`).
  - Standardized error handlers and response formatters.
  - Environment-based configuration module.

### Phase 6 - Analytics Engine
- **Objective:** Implement analytical REST endpoints that compute business-critical metrics using highly optimized PostgreSQL SQL.
- **Milestone:** API routes providing real-time data for dashboard visualizer widgets.
- **Deliverables:**
  - Sales routes (revenue, average order value, category breakdowns).
  - Inventory routes (warehouse capacities, stock level alerts).
  - Support & Shipment metrics.

### Phase 7 - React Dashboard
- **Objective:** Build the user-facing web app using React and Tailwind CSS, integrating charts (via Recharts or Chart.js) and embedding the chat panel.
- **Milestone:** High-fidelity, fully responsive executive dashboard.
- **Deliverables:**
  - UI pages: Home/KPIs, Sales Analytics, Inventory Health, and AI Assistant Drawer.
  - Integration of REST API fetches.
  - Micro-animations and professional dark-mode UI elements.

### Phase 8 - Machine Learning
- **Objective:** Build predictive workflows using Python. Train demand-forecasting models for products and classification models for customer churn.
- **Milestone:** ML training and inference pipeline saving outputs to the database.
- **Deliverables:**
  - Jupyter Notebooks for model exploration.
  - Production-ready Python scripts to train and save models (Scikit-learn / XGBoost).
  - Daily pipeline that generates predictions and inserts them into the analytical tables.

### Phase 9 - AI Business Assistant
- **Objective:** Integrate LLMs using LangGraph to build a secure SQL-agent that answers questions about the warehouse data.
- **Milestone:** Secure, conversational chat interface executing verified queries.
- **Deliverables:**
  - LangGraph schema agent with strict system prompts restricting destructive operations (no DELETE/DROP).
  - Semantic routing to direct queries to either standard FAQs or direct SQL.
  - API endpoint to handle chat history and streaming responses.

### Phase 10 - Deployment
- **Objective:** Containerize backend, frontend, database, and pipeline services. Deploy the orchestrations to staging and production environments.
- **Milestone:** Production-grade release running on host services.
- **Deliverables:**
  - Individual `Dockerfile` configurations and a root `docker-compose.yml`.
  - GitHub Actions workflows for automated linting, test execution, and deployment.
  - Environmental configurations for secure secrets management.