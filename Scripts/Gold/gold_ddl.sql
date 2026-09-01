/*
------------------------------------------------------------------------------
This script creates tables in the Gold layer. 
Running this script first of all clears tables before creating them.
------------------------------------------------------------------------------
*/

USE FintechFraud;
GO

IF OBJECT_ID('Gold.fact_transactions', 'U') IS NOT NULL
    DROP TABLE Gold.fact_transactions;
GO

CREATE TABLE Gold.Fintech_transactions
(
    transaction_id BIGINT NOT NULL,
    user_id INT,
    merchant_id INT,
    device_id INT,
    location_id INT,

    transaction_timestamp DATETIME,
    amount_inr DECIMAL(18,2),
    currency CHAR(3),

    payment_method VARCHAR(50),
    payment_type CHAR(3),

    risk_score DECIMAL(5,3),
    is_fraud BIT,

    -- User attributes
    age INT,
    account_age_days INT,
    kyc_status VARCHAR(50),
    risk_profile VARCHAR(50),

    -- Merchant attributes
    category VARCHAR(100),
    merchant_risk_score DECIMAL(5,4),

    -- Device attributes
    device_type VARCHAR(50),
    os VARCHAR(50),
    device_risk_score DECIMAL(5,4),

    -- Location attributes
    city VARCHAR(150),
    state VARCHAR(150),
    country VARCHAR(50),
    geo_risk_score DECIMAL(5,4),

    dwh_create_date DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT PK_fact_transactions
        PRIMARY KEY (transaction_id)
);
GO


------Users_Risk Table 
IF OBJECT_ID('Gold.user_risk', 'U') IS NOT NULL
    DROP TABLE Gold.user_risk;
GO

CREATE TABLE Gold.user_risk
(
    user_id INT NOT NULL,

    age INT,
    account_age_days INT,
    kyc_status VARCHAR(50),
    risk_profile VARCHAR(50),

    total_transactions BIGINT,
    fraud_transactions BIGINT,

    fraud_rate DECIMAL(10,4),

    total_transaction_value DECIMAL(18,2),
    fraud_transaction_value DECIMAL(18,2),

    average_transaction_amount DECIMAL(18,2),

    dwh_create_date DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT PK_user_risk
        PRIMARY KEY (user_id)
);
GO


------Gold.Merchant_risk table 
IF OBJECT_ID('Gold.merchant_risk', 'U') IS NOT NULL
    DROP TABLE Gold.merchant_risk;
GO

CREATE TABLE Gold.merchant_risk
(
    merchant_id INT NOT NULL,

    category VARCHAR(100),

    merchant_risk_score DECIMAL(5,3),

    total_transactions BIGINT,
    fraud_transactions BIGINT,

    fraud_rate DECIMAL(10,4),

    total_transaction_value DECIMAL(18,2),
    fraud_transaction_value DECIMAL(18,2),

    average_transaction_amount DECIMAL(18,2),

    dwh_create_date DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT PK_merchant_risk
        PRIMARY KEY (merchant_id)
);
GO


-----Gold.risk_Score_analysis

IF OBJECT_ID('Gold.risk_score_analysis', 'U') IS NOT NULL
    DROP TABLE Gold.risk_score_analysis;
GO

CREATE TABLE Gold.risk_score_analysis
(
    risk_band VARCHAR(20) NOT NULL,

    minimum_risk_score DECIMAL(5,3),
    maximum_risk_score DECIMAL(5,3),

    transaction_count BIGINT,
    fraud_count BIGINT,

    fraud_rate DECIMAL(10,4),

    transaction_value DECIMAL(18,2),
    fraud_value DECIMAL(18,2),

    average_transaction_amount DECIMAL(18,2),

    dwh_create_date DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT PK_risk_score_analysis
        PRIMARY KEY (risk_band)
);
GO

--checking validity of the gold layer 

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Gold'
ORDER BY TABLE_NAME;
