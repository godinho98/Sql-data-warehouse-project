# Sql-data-warehouse-project

This repository showcases the design and implementation of a complete data warehouse solution, built from raw data ingestion to analytical reporting.

The goal of this project is to structure data in a way that supports reliable, scalable decision-making, following real world data engineering practices.

This project is focused on building a solid foundation in:
- Data warehouse architecture design
- ETL pipeline development
- Data cleaning and transformation
- Dimensional modeling (star schema)
- Data quality validation

## 🏗️ Architecture Overview

The warehouse is structured using a layered approach inspired by the Medallion Architecture, separating concerns and improving data reliability across stages.

🔸 Bronze Layer — Raw Data
Stores data exactly as received from source systems
No transformations applied
Serves as a historical and traceable data source
Data is ingested from CSV files into SQL Server

🔹 Silver Layer — Cleaned & Standardized
Handles data cleansing, formatting, and consistency fixes
Resolves missing values, duplicates, and structural issues
Prepares data for downstream modeling

⭐ Gold Layer — Business-Ready Data
Data is modeled into a star schema
Includes fact and dimension tables
Optimized for analytical queries and reporting use cases

## Data Pipeline
The project follows a structured ETL process:

1. Extract
Data is collected from multiple source files (ERP and CRM datasets)

2. Transform
Cleaning, normalization, and validation applied in the Silver layer
Business logic and aggregations applied in the Gold layer

3. Load
Data is incrementally loaded across layers to ensure consistency and traceability


## 📊 Data Modeling

The final model is designed using dimensional modeling principles, including:
- Fact tables for measurable business events
- Dimension tables for descriptive context
- Clear relationships to support efficient querying

This structure enables:
- Faster analytics
- Simpler queries
- Better scalability for reporting


## ✅ Data Quality & Validation
To ensure reliability, the project includes validation checks such as:
- Uniqueness of primary/surrogate keys
- Referential integrity between fact and dimension tables
- Consistency checks across transformations
These checks help guarantee that the data in the Gold layer is trustworthy for decision-making.

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                 # Raw input data (ERP and CRM sources)
│
├── docs/                     # Project documentation and architecture details
├── scripts/
│   ├── bronze/               # Data ingestion scripts
│   ├── silver/               # Data cleaning and transformation logic
│   ├── gold/                 # Dimensional modeling and final tables
│
├── tests/                    # Data validation and quality checks
│
├── LICENSE                   # License details
└── README.md                 # Project documentation
```
