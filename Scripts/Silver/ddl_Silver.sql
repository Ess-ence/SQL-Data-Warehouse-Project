/* 
DDL Script for Creating the Silver Layer
===================================================================================================================
This Script creates tables in the Silver Layer, dropping existing tables if they already exists.
This script redefines the datatype of tables in the bronze layer due to data cleaning and transformations.
===================================================================================================================
*/
-----CREATING DDL FOR TABLES

--Transaction Table 
IF OBJECT_ID ('Silver.Fintech_transactions', 'U') IS NOT NULL
    DROP TABLE Silver.Fintech_transactions;
CREATE TABLE Silver.Fintech_transactions (
    transaction_id BIGINT,
    user_id INT,
    merchant_id INT,
    device_id INT,
    location_id INT,

    transaction_timestamp DATETIME,

    amount_inr DECIMAL(18, 2),

    currency CHAR(3),
    payment_method VARCHAR(50),
    payment_type CHAR(3),

    risk_score DECIMAL(5,3),
    is_fraud BIT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

----Users Table 
IF OBJECT_ID ('Silver.Fintech_users', 'U') IS NOT NULL
    DROP TABLE Silver.Fintech_users;
CREATE TABLE Silver.Fintech_users (
    user_id INT,
    age VARCHAR(50),
    account_age_days VARCHAR(50),
    kyc_status VARCHAR(50),
    risk_profile VARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

----Devices Tables
IF OBJECT_ID ('Silver.Fintech_devices', 'U') IS NOT NULL
    DROP TABLE Silver.Fintech_devices;
CREATE TABLE Silver.Fintech_devices (
    device_id INT,
    device_type VARCHAR(50),
    os VARCHAR(50),
    device_risk_score DECIMAL(5,4),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

----Merchants Tables
IF OBJECT_ID ('Silver.Fintech_merchants', 'U') IS NOT NULL
    DROP TABLE Silver.Fintech_merchants;
CREATE TABLE Silver.Fintech_merchants (
    merchant_id INT,
    category VARCHAR (50),
    merchant_risk_score DECIMAL (5,4),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

----Locations Table
IF OBJECT_ID ('Silver.Fintech_locations', 'U') IS NOT NULL
    DROP TABLE Silver.Fintech_locations;
CREATE TABLE Silver.Fintech_locations (
    location_id INT,
    city VARCHAR (150),
    state VARCHAR (150),
    country VARCHAR (50),
    geo_risk_score DECIMAL (5,4),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
