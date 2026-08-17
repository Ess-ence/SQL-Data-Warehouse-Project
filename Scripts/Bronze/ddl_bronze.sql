/*
------------------------------------------------------------------------------------------
This script creates tables in the bronze schema, dropping existing tables if they exist.
run this script to redefine the ddl structure of the bronze layer.
------------------------------------------------------------------------------------------
*/

-----CREATING DDL FOR TABLES

--Transaction Table 
IF OBJECT_ID ('Bronze.Fintech_transactions', 'U') IS NOT NULL
    DROP TABLE Bronze.Fintech_transactions;
CREATE TABLE Bronze.Fintech_transactions (
    transaction_id BIGINT,
    user_id VARCHAR(50),
    merchant_id VARCHAR(50),
    device_id VARCHAR(50),
    location_id VARCHAR(50),

    transaction_timestamp VARCHAR(150),

    amount_inr VARCHAR(50),

    currency VARCHAR(20),
    payment_method VARCHAR(50),
    payment_type VARCHAR(50),

    risk_score VARCHAR(50),
    is_fraud VARCHAR(50)
);
GO

----Users Table 
IF OBJECT_ID ('Bronze.Fintech_users', 'U') IS NOT NULL
    DROP TABLE Bronze.Fintech_users;
CREATE TABLE Bronze.Fintech_users (
    user_id INT,
    age VARCHAR(50),
    account_age_days VARCHAR(50),
    kyc_status VARCHAR(50),
    risk_profile VARCHAR(50)
);
GO

----Devices Tables
IF OBJECT_ID ('Bronze.Fintech_devices', 'U') IS NOT NULL
    DROP TABLE Bronze.Fintech_devices;
CREATE TABLE Bronze.Fintech_devices (
    device_id INT,
    device_type VARCHAR(50),
    os VARCHAR(50),
    device_risk_score VARCHAR(50)
);
GO

----Merchants Tables
IF OBJECT_ID ('Bronze.Fintech_merchants', 'U') IS NOT NULL
    DROP TABLE Bronze.Fintech_merchants;
CREATE TABLE Bronze.Fintech_merchants (
    merchant_id INT,
    category VARCHAR (50),
    merchant_risk_score VARCHAR (50)
);
GO

----Locations Table
IF OBJECT_ID ('Bronze.Fintech_locations', 'U') IS NOT NULL
    DROP TABLE Bronze.Fintech_locations;
CREATE TABLE Bronze.Fintech_locations (
    location_id INT,
    city VARCHAR (150),
    state VARCHAR (150),
    country VARCHAR (50),
    geo_risk_score VARCHAR (50)
);
GO


