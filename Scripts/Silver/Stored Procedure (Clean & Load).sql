/*
-------------------------------------------------------------------------------------------------------------
This script cleans data in the bronze layer and loads it to tables in the silver layer after truncating them.
-------------------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE Silver.load_Silver AS 
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE ();
        PRINT'==========================================================';
        PRINT'START LOADING THE SILVER LAYER';
        PRINT'==========================================================';

--------------------------Cleaning and Loading Users 
        SET @start_time = GETDATE ();

        PRINT '>>> Truncating Table: Users';
        TRUNCATE TABLE Silver.Fintech_users;

        PRINT '>>> Inserting Data To Table: Users';
        INSERT INTO Silver.Fintech_users
        (
	        user_id, 
	        age,
	        account_age_days,
	        kyc_status,
	        risk_profile
        )
        SELECT
	        TRY_CONVERT(INT, user_id) AS user_id, 
	        TRY_CONVERT (INT, age) AS age,
	        TRY_CONVERT (INT, account_age_days) AS account_age_days, 
	        TRIM(kyc_status) AS kyc_status,
	        TRIM(risk_profile) AS risk_profile
        FROM Bronze.Fintech_users;
        SET @end_time = GETDATE ();
        PRINT '>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

---------------------Cleaning & Loading Devices 

        SET @start_time = GETDATE ();

        PRINT '>>> Truncating Table: Devices';
        TRUNCATE TABLE Silver.Fintech_devices;

        PRINT '>>> Inserting Data in Table: Devices';
        INSERT INTO Silver.Fintech_devices (
            device_id,
            device_type,
            os,
            device_risk_score
        )
        SELECT 
            TRY_CONVERT(INT, device_id) AS device_id,
            TRIM(device_type) AS device_type,
            TRIM(os) AS os,
            TRY_CONVERT(DECIMAL(5,3), REPLACE( REPLACE(device_risk_score, CHAR(13), ''), CHAR(10), '')) AS device_risk_score
        FROM Bronze.Fintech_devices;
        SET @end_time = GETDATE ();
        PRINT '>>>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
    
------------------------------Loading Locations Table

        SET @start_time = GETDATE ();

        PRINT '>>> Truncate Table : Locations';
        TRUNCATE TABLE Silver.Fintech_locations;

        PRINT '>>> Inserting Data Into : Locations Table';
        INSERT INTO Silver.Fintech_locations
        (
            location_id, 
            city,
            state,
            country,
            geo_risk_score
        )

        SELECT location_id, 
            city,
            state,
            country,
            TRY_CONVERT(DECIMAL(5,4), REPLACE (REPLACE(geo_risk_score, CHAR(13), ''), CHAR(10), '')) AS geo_risk_score
        FROM Bronze.Fintech_locations;
        PRINT '>>> Loading Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
   
------------------------Loading Merchants Table

        SET @start_time = GETDATE ();
        PRINT '>>>Truncating Table : Merchants'
        TRUNCATE TABLE Silver.Fintech_merchants
        PRINT '>>>Inserting Data Into : Merchants Table'
        INSERT INTO Silver.Fintech_merchants 
        (
            merchant_id, 
            category,
            merchant_risk_score
        )

        SELECT merchant_id,
            TRIM(category) AS category,
            TRY_CONVERT(DECIMAL (5,4), REPLACE(REPLACE( merchant_risk_score, CHAR (13), ''), CHAR(10), '')) AS merchant_risk_score
        FROM Bronze.Fintech_merchants
        SET @end_time = GETDATE();
        PRINT '>>> Load Duration: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

--------------------------Loading The Transactions Table 

        SET @start_time = GETDATE();

        PRINT '>>>Truncating Table : Transactions';
        TRUNCATE TABLE Silver.Fintech_transactions;

        PRINT '>>>Inserting Data Into : Transactions Table';
        INSERT INTO Silver.Fintech_transactions (
            transaction_id,
            user_id,
            merchant_id,
            device_id,
            location_id,

            transaction_timestamp,

            amount_inr,

            currency,
            payment_method,
            payment_type,

            risk_score,
            is_fraud
        )

        SELECT 
            TRY_CONVERT(BIGINT, transaction_id) AS transaction_id,
            TRY_CONVERT(INT, user_id) AS user_id,
            TRY_CONVERT(INT, merchant_id) AS merchant_id,
            TRY_CONVERT(INT, device_id) AS device_id,
            TRY_CONVERT(INT, location_id) AS location_id,

            TRY_CONVERT(DATETIME, transaction_timestamp),

            TRY_CONVERT(DECIMAL(18, 2), amount_inr) as amount_inr,
            TRY_CONVERT(CHAR(3), currency) AS currency,

            TRIM(payment_method) AS payment_method,

            TRY_CONVERT(CHAR(3),payment_type) AS payment_type,
            TRY_CONVERT(DECIMAL(5,3), risk_score) AS converted_score,
            TRY_CONVERT(BIT, REPLACE(REPLACE(is_fraud, CHAR(13), ''), CHAR(10), '')) AS is_fraud
        FROM Bronze.Fintech_transactions;
        SET @end_time = GETDATE ();
        PRINT '>>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

        SET @batch_end_time = GETDATE ();
        PRINT '==================================================================================';
        PRINT 'Loading Silver Layer is Complete';
        PRINT ' - Total Load Duration: '+ CAST(DATEDIFF(SECOND,@batch_start_time, @batch_end_time) AS NVARCHAR) + 'Seconds';
        PRINT '===================================================================================';
     
     END TRY
     BEGIN CATCH
            PRINT '=======================================';
            PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
            PRINT 'Error Message'+ERROR_MESSAGE();
            PRINT 'Error Message'+ CAST (ERROR_NUMBER() AS NVARCHAR);
            PRINT 'Error Message'+ CAST (ERROR_STATE() AS NVARCHAR);
            PRINT '=======================================';
     END CATCH
END

----EXECUTE THIS STORED PROCEDURE
EXEC Silver.load_Silver





