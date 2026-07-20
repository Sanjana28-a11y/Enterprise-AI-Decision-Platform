# Technology Stack & Selection Rationale

This document details the software development kits (SDKs), frameworks, databases, and DevOps utilities selected to build the **Enterprise AI Decision Intelligence Platform**. 

---

## Tech Stack Overview

| Layer | Component | Selection | Rationale |
| :--- | :--- | :--- | :--- |
| **Frontend** | Framework | **React** (v18+) | Core library for dynamic component structures, virtual DOM updates, and robust state management. |
| | Language | **TypeScript** | Static typing prevents runtime crashes, guarantees prop interfaces, and facilitates autocomplete in code editors. |
| | Styling | **Tailwind CSS** | Utility-first CSS framework for rapid responsive design, fluid transitions, and standardized spacing scales. |
| **Backend** | Platform | **Node.js** | Event-driven, asynchronous runtime capable of handling large volumes of concurrent client connections. |
| | Framework | **Express.js** | Minimalist web framework offering clean routing, middleware integration, and standard API development. |
| **Database** | RDBMS | **PostgreSQL** | Industry standard open-source relational database. Supports transactional integrity (ACID), window functions, JSONB storage, and complex indexing. |
| **Data Engineering**| Language | **Python** (v3.10+) | Standard language for data tasks, providing extensive library support and readability. |
| | ETL Engine | **Pandas** | High-performance memory structures (DataFrames) for cleaning, reshaping, and validating tabular dataset sources. |
| | ORM / Driver | **SQLAlchemy** | Abstracted database connection layer facilitating bulk inserts, safe connection pooling, and cross-platform query generation. |
| **Machine Learning**| Algorithms | **Scikit-learn** | Reliable machine learning toolkit for customer segmentation (clustering) and baseline regression forecasts. |
| | Gradient Boosting| **XGBoost** | High-performance gradient boosted decision trees optimized for structured/tabular demand forecasting. |
| **Artificial Intelligence**| Framework | **LangGraph** | Advanced orchestration framework by LangChain, allowing for cyclic agent loops, structured state management, and multi-step SQL querying. |
| | Foundation Models| **OpenAI / Gemini API**| State-of-the-art Large Language Models (LLMs) used for interpreting natural language, formatting JSON, and composing human-readable reports. |
| **DevOps & CI/CD** | Containerization| **Docker** | Packs all processes into isolated containers, resolving the "works on my machine" problem in localized and staging environments. |
| | Orchestration | **Docker Compose** | Multi-container run definition for local developers to boot the API, UI, Database, and ETL tasks with a single command. |
| | Version Control | **GitHub Actions** | Automated CI/CD workflows for executing tests, linting, running security scans, and initiating production pushes. |

---

## Architectural Alignment

```text
[ React & TypeScript Front-End ]
               │
               ▼ (REST Requests / JSON)
[ Node.js & Express.js Back-End ]
        │                       │
        ▼ (Analytical Queries)  ▼ (Inference Trigger)
┌─────────────────────────────────────────────────────┐
│              PostgreSQL Data Warehouse              │
│                                                     │
│  - Fact/Dimension Tables                            │
│  - ML Forecast Outputs                              │
│  - Aggregated Sales & Log Records                   │
└─────────────────────────────────────────────────────┘
        ▲                       ▲
        │ (Bulk Insert SQL)     │ (Query & Write)
[ Python ETL (Pandas) ]  [ Python ML & AI Agents ]
        ▲                       - Scikit-learn & XGBoost
        │                       - LangGraph AI Agent
[ Raw Data Files (CSV/JSON) ]
```
