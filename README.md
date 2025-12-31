# Brazilian Ecommerce Analytics (Olist)

This repository contains a structured analytics engineering pipeline built on the Olist Brazilian Ecommerce dataset.

The project focuses on transforming raw CSV data into analytics-ready fact and dimension tables using a layered SQL modeling approach.

---

## Dataset

Source: Olist Brazilian Ecommerce Dataset  
Format: CSV files loaded into a relational database  
Scope:
- Customers
- Orders
- Order Items
- Products
- Sellers
- Payments
- Reviews
- Geolocation

Raw data is preserved without transformation.

---

## Project Goal

The goal of this project is to:
- Build a clean, deterministic analytics layer
- Apply proper data modeling principles (facts & dimensions)
- Ensure idempotent and reproducible transformations
- Document modeling decisions explicitly

This project is **not** focused on dashboards or BI tools.  
It is focused on **data correctness and modeling discipline**.

---

## Data Modeling Approach

The pipeline follows a layered structure:

- Raw (layer_0/raw):
  - CSV files ingested unchanged. Acts as the single source of truth.
  - Files mirror the original Olist dataset file names.

- Staging (layer_1/staging):
  - Lightweight, column-level cleanses and type casts.
  - Timestamp normalization, simple deduplication, and single-step transformations that make downstream joins reliable.
  - No business logic — only technical cleaning.

- Core / Modeled (layer_2/core):
  - Idempotent SQL models that produce canonical dimension and fact tables.
  - Dimensions (dim_customers, dim_products, dim_sellers, dim_date, dim_location) capture slowly changing attributes with explicit keys and natural keys preserved for traceability.
  - Facts (fact_orders, fact_order_items, fact_payments, fact_reviews) store measured, denormalized, and join-ready facts.
  - Clear primary keys, surrogate keys, and foreign key relationships documented in SQL headers.

- Marts (layer_3/marts):
  - Consumption-focused, aggregated tables tailored for analytics use-cases (e.g., sales by region, customer lifetime value, seller performance).
  - Materialized views or tables depending on the execution environment and size of data.

- Tests & Observability (layer_4/tests):
  - Row-count checks, nullability assertions, uniqueness constraints on keys, referential integrity checks, and example value checks.
  - Lineage and data freshness documentation.

---

## Conventions

- All transformations are written as idempotent SQL statements stored in the `sql/` directory, organized by layer.
- File and model names are lowercase with underscores, e.g. `dim_customers.sql`.
- Each model contains a short header describing inputs, outputs, assumptions, and a sample of tests to run.
- All timestamps are stored in UTC.

---

## Repository layout (recommended)

- data/raw/         -> original CSVs (committed or referenced via data catalog)
- sql/layer_1/       -> staging SQL
- sql/layer_2/       -> core models (dims & facts)
- sql/layer_3/       -> marts and aggregated tables
- sql/tests/         -> SQL-based assertions and tests
- docs/              -> modeling decisions, data dictionary, lineage diagrams

---

## How to run

This repository does not prescribe a specific orchestration tool. Typical workflow:

1. Load CSVs to a database/schema (layer_0/raw).
2. Execute staging SQL scripts in `sql/layer_1` to populate staging tables.
3. Run core models in `sql/layer_2` to produce dimensions and facts.
4. Build marts in `sql/layer_3` as needed for analytics.
5. Execute tests in `sql/tests` and review results.

Automation recommendations: use an orchestration tool (Airflow/Prefect), or a SQL transformation framework (dbt) to manage dependencies and testing.

---

## Modeling decisions and notes

- Preserve raw files to enable full traceability.
- Prefer explicit joins and documented keys over wide `SELECT *` patterns.
- Use deterministic surrogate key assignments where needed, and keep natural keys for reconciliation.

---

## Contribution

Contributions are welcome. Please open an issue describing the proposed change, include expected SQL outputs, and add tests that validate behavior.

---

## License

MIT
