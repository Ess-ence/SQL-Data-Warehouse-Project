# SQL-Data-Warehouse-Project
Building a Modern Data Warehouse with SQL Server including ETL Processes, Data Modelling and Analytics

The project uses a large digital payments dataset containing approximately 5.5 million transactions. The goal is to transform raw transactional data into a structured, clean, and business-ready data warehouse that can support fraud analysis, risk profiling, and BI reporting.
The project follows a layered data warehouse architecture:

<img width="1220" height="766" alt="Data Architecture Model" src="https://github.com/user-attachments/assets/dd13efd1-7036-4a26-aa05-2f79b25200f9" />

# 📌 Project Objectives
## The main objectives are to:
    1. Build an end-to-end data warehouse using Microsoft SQL Server.
    2. Import and preserve the original source data in a Bronze layer.
    3. Clean, standardize, validate, and transform data in the Silver layer.
    4. Create business-ready Gold-layer datasets for fraud and risk analysis.
    5. Establish relationships between transactions, users, merchants, devices, and locations.
    6. Calculate fraud and risk metrics at different analytical levels.
    7. Create a reliable foundation for SQL analysis and future Power BI reporting.
    8. Practice a repeatable data engineering workflow that can be extended into scheduled ETL/ELT processing.

# 🚀 Data Warehouse Architecture
The warehouse uses a Bronze → Silver → Gold architecture.

<img width="1036" height="792" alt="DataFlow" src="https://github.com/user-attachments/assets/639f743d-5e18-48ed-9f98-9403f4eb8eac" />

## 🥇 Bronze Layer — Raw Data
The Bronze layer contains the source data as closely as possible to its original structure. The Bronze table are defined in the accompanying [Bronze DDL Script](Scripts/Bronze/ddl_bronze.sql).
The Data is loaded to this layer using the following script [Bronze Stored Procedure](Scripts/Bronze/procedure_load_bronze.sql)
### Purpose
The Bronze layer is designed for:

    * Raw data ingestion
    * Source preservation
    * Data traceability
    * Initial validation
    * Reproducible loading
### Source
The source consists of CSV flat files representing:
| Table | Description |
| --- | --- |
| Fintech_transactions | Digital payment transactions |
| Fintech_users | User/customer information |
| Fintech_merchants | Merchant information |
| Fintech_devices | Device information |
| Fintech_locations | Geographic/location information |

### Bronze Processing
The source CSV files are loaded from a local SQL Server-accessible folder using SQL Server bulk-loading techniques.
The Bronze layer intentionally performs minimal transformation so that the original source can be retained for auditing and downstream processing.

## 🥈 Silver Layer — Cleaned & Standardized Data
The Silver layer contains cleaned and structured versions of the Bronze data.
### Purpose
The Silver layer is responsible for:

    * Data type conversion
    * Trimming and standardizing text
    * Handling invalid or malformed values
    * Data quality checks
    * Data normalization
    * Preparing data for analytical consumption

### Examples of transformations
1. Examples include:
    1. Converting transaction IDs and entity IDs to appropriate numeric types.
    2. Converting transaction timestamps into appropriate date/time types.
    3. Converting transaction amounts into numeric values.
    4. Converting risk scores into decimal values.
    5. Converting fraud indicators into appropriate data types.
    6. Trimming whitespace from categorical fields.
    7. Standardizing text fields.
    8. Validating primary-key uniqueness and null values.

The Silver layer acts as the controlled transition between raw source data and analytical data.

### Silver Tables

    Silver.Fintech_transactions
    Silver.Fintech_users
    Silver.Fintech_merchants
    Silver.Fintech_devices
    Silver.Fintech_locations

 ## 🎖️Gold Layer — Business-Ready Data

The Gold layer is designed for analytical and business use.
### Gold objects
The current Gold model includes:

    Gold.fact_transactions
    Gold.user_risk
    Gold.merchant_risk
    Gold.risk_score_analysis

#### Gold.fact_transactions
The fact table represents the integrated transaction-level dataset.
It combines transaction information with relevant attributes from:

    Users
    Merchants
    Devices
    Locations
    
The intended grain is:
One row per transaction
This table serves as the primary analytical foundation for downstream fraud and risk analysis.
#### Gold.user_risk
The user-level analytical table changes is designed to contain metrics such as:

    Total transactions
    Fraudulent transactions
    Fraud rate
    Total transaction value
    Fraud transaction value
    Average transaction amount
    User risk profile
    KYC status
    Account age
    
#### Gold.merchant_risk
The merchant-level analytical table is designed to evaluate merchant transaction activity and fraud behavior, including merchant risk scores and fraud-related metrics.
#### Gold.risk_score_analysis
This analytical object is designed to examine relationships between transaction risk scores and fraud outcomes.
It will support analysis such as:

    Risk score ranges
    Transaction volumes
    Fraud volumes
    Fraud rates
    Transaction values
    Risk segmentation

 ## 🔁Data Pipeline
 
    1. Source CSV Files
            ↓
    2. Bronze DDL
            ↓
    3. Bulk Load
            ↓
    4. Bronze Data Validation
            ↓
    5. Silver DDL
            ↓
    6. Data Cleaning & Type Conversion
            ↓
    7. Silver Data Validation
            ↓
    8. Gold DDL
            ↓
    9. Gold Transformations
            ↓
    10. Analytical Aggregations
            ↓
    11. SQL Analysis / BI Reporting

The project is being developed with repeatability in mind, with transformation and loading logic being organized into SQL scripts and, where appropriate, stored procedures for future scheduled execution.












