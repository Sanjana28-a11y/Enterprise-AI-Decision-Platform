# Enterprise AI Decision Intelligence Platform

An enterprise-grade, end-to-end data platform that collects business data from multiple sources, processes it through ETL pipelines, stores it in a PostgreSQL data warehouse, performs business analytics, supports machine learning forecasting, and provides a generative AI-powered business assistant for executive decision-making.

---

## Project Overview
In modern corporate environments, transactional data, customer interactions, inventory levels, and logistics data are locked in isolated database siloes. The **Enterprise AI Decision Intelligence Platform** is built to bridge this gap. Using NovaMart—a multi-city, multi-category fictional e-commerce leader—as the core business blueprint, the platform establishes a structured, modular pipeline to clean raw records, construct a robust SQL warehouse, analyze operations, project future demand, and offer a conversational AI interface for decision support.

## Problem Statement
Enterprises suffer from:
- **Fragmented Data Ecosystems:** Siloed structures across warehouses, retail frontends, and marketing tools.
- **Retrospective Analysis:** Traditional dashboards show what *happened*, not what *will happen*.
- **High Analytical Barriers:** Executive leaders must rely on data engineers or write complex SQL queries to retrieve basic metrics.
- **Supply Chain Inefficiencies:** Lack of predictive alerts leads to product stockouts or high inventory storage costs.

## Planned Features
1. **Multi-Source Ingestion:** Automated loaders for orders, inventory logs, support tickets, and campaign performance.
2. **Modern Data Pipeline (ETL):** Robust Python-based cleaning pipelines verifying data integrity before warehousing.
3. **Optimized Data Warehouse:** A clean PostgreSQL schema separating facts and dimensions (Star Schema) for rapid analytical processing.
4. **Predictive ML Engines:** Integrated machine learning models (XGBoost/Scikit-learn) forecasting product demand and identifying customer churn risk.
5. **AI Business Assistant:** A LangGraph-orchestrated AI agent converting natural language into secure, parameterized SQL to answer business-related queries.
6. **Executive Dashboard:** A React, TypeScript, and Tailwind CSS web panel featuring visual charts and an interactive AI chatbot drawer.

---

## Folder Structure
```text
enterprise-ai-decision-platform/
│
├── .github/             # GitHub actions workflows for CI/CD pipelines
├── backend/             # Node.js and Express.js REST API server
├── frontend/            # React, TypeScript, and Tailwind CSS executive client dashboard
├── etl/                 # Python and Pandas Extract-Transform-Load code
├── ml/                  # Python machine learning models (XGBoost, Scikit-learn)
├── database/            # DDL, seeding scripts, and migration files
├── datasets/            # Raw landing zone for CSV/JSON files
├── docs/                # Comprehensive architecture and database design docs
├── docker/              # Container files, Dockerfiles, and environment configs
└── scripts/             # Admin orchestration and maintenance scripts
```

---

## Architecture Overview
The platform processes data sequentially across several processing modules to deliver insights:

```text
Business Systems (Sales, Inventory, CRM, Marketing)
                   │
                   ▼
       Data Ingestion (Datasets)
                   │
                   ▼
      ETL Pipeline (Python & Pandas)
                   │
                   ▼
    PostgreSQL Data Warehouse (SQL DB)
         │                   │
         ▼                   ▼
  Analytics Engine     Machine Learning
  (Express REST API)   (Predictive Models)
         │                   │
         ▼                   ▼
    AI Business Assistant (LangGraph SQL Agent)
                   │
                   ▼
   Executive Dashboard (React UI Client)
```
*For a detailed module breakdown and system diagrams, refer to [Architecture Documentation](docs/architecture.md).*

---

## Technology Stack

- **Frontend:** React (v18+), TypeScript, Tailwind CSS
- **Backend:** Node.js, Express.js, PostgreSQL Driver (`pg-pool`)
- **Database:** PostgreSQL (v15+)
- **Data Engineering:** Python, Pandas, SQLAlchemy
- **Machine Learning:** Scikit-learn, XGBoost
- **Artificial Intelligence:** LangGraph, OpenAI / Gemini API
- **DevOps & CI/CD:** Docker, Docker Compose, GitHub Actions

*For component selections and design rationales, refer to [Technology Stack Documentation](docs/tech-stack.md).*

---

## Development Roadmap

The development of the platform is partitioned into 10 structured phases:
1. **Phase 1: Project Setup** - Repository scaffolding, configs, and workflow guidelines.
2. **Phase 2: Database Design** - Star Schema relational schema modeling.
3. **Phase 3: PostgreSQL Implementation** - Creating DDL schemas and database mock seeding scripts.
4. **Phase 4: ETL Pipeline** - Writing Python cleaning and database loading scripts.
5. **Phase 5: Backend APIs** - Node.js Express server configuration and routing folders.
6. **Phase 6: Analytics Engine** - Aggregated SQL routes for tracking business KPIs.
7. **Phase 7: React Dashboard** - Interactive panels, analytics charts, and conversational drawer.
8. **Phase 8: Machine Learning** - Training models to predict product demand and customer status.
9. **Phase 9: AI Business Assistant** - Crafting LangGraph agents to run natural language SQL requests.
10. **Phase 10: Deployment** - Creating multi-container Docker structures and automated cloud deployment.

*For target milestones and deliverables per phase, refer to [Development Roadmap Documentation](docs/roadmap.md).*

---

## Core Documentation Files

For in-depth details on individual areas of the system, consult the markdown resources in the `/docs` directory:
- 📑 **[Project Overview](docs/project-overview.md):** Context, goals, and problem definition.
- 🏢 **[Business Model](docs/business-model.md):** NovaMart operational context and customer segments.
- 📐 **[Architecture Design](docs/architecture.md):** Data-flow routes, Mermaid charts, and components.
- 📊 **[Database Design](docs/database-design.md):** 14 core data entities and relation layouts.
- 💻 **[Tech Stack](docs/tech-stack.md):** Software choices and engineering rationale.
- 🗺️ **[Development Roadmap](docs/roadmap.md):** 10-phase milestone path and deliverables.
