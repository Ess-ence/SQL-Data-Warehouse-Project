/*

Stored Procedure : Load Bronze Layer
-------------------------------------------------------------------------------
Script Purpose:
This stored proceure loads data into the Bronze Schema from external csv stored in local folders.
It does the following;
  - Truncate bronze tables before loading/ inserting data
  - Uses the BULK INSERT command to load data from csv files into the bronze tables

Parameters:
This stored procedure does not accept any parameters or returns any values

Use: 
EXEC Bronze.load_Bronze
----------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE Bronze.load_Bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE ();
        PRINT '===================================';
        PRINT 'Loading Bronze Layer';
        PRINT '===================================';

        ---Loading Transactions
        SET @start_time = GETDATE();
        PRINT'>> TRUNCATING TABLE: Bronze.Fintech_transactions';
        TRUNCATE TABLE Bronze.Fintech_transactions;

        PRINT '>> Inserting Data Into: Bronze.Fintech_transactions';
        BULK INSERT Bronze.Fintech_transactions
        FROM 'C:\Fintech\transactions.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>>> Load Duration: ' + CAST (DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

        ----Loading Users Table
        SET @start_time = GETDATE ();
        PRINT'>> TRUNCATING TABLE: Bronze.Fintech_users';
        TRUNCATE TABLE Bronze.Fintech_users;

        PRINT '>> Inserting Data Into: Bronze.Fintech_users';
        BULK INSERT Bronze.Fintech_users
        FROM 'C:\Fintech\users.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',
            TABLOCK
         );
        SET @end_time = GETDATE();
        PRINT '>>> Load Duration: ' + CAST (DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

        -----Loading Devices
        SET @start_time = GETDATE ();
        PRINT'>> TRUNCATING TABLE: Bronze.Fintech_devices';
        TRUNCATE TABLE Bronze.Fintech_devices;

        PRINT '>> Inserting Data Into: Bronze.Fintech_devices';
        BULK INSERT Bronze.Fintech_devices
        FROM 'C:\Fintech\devices.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',
            TABLOCK
         );
        SET @end_time = GETDATE();
        PRINT '>>> Load Duration: ' + CAST (DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

        -----Loading Merchants
        SET @start_time = GETDATE();
        PRINT'>> TRUNCATING TABLE: Bronze.Fintech_merchants';
        TRUNCATE TABLE Bronze.Fintech_merchants;

        PRINT '>> Inserting Data Into: Bronze.Fintech_merchants';
        BULK INSERT Bronze.Fintech_merchants
        FROM 'C:\Fintech\merchants.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',
            TABLOCK
         );
        SET @end_time = GETDATE();
        PRINT '>>> Load Duration: ' + CAST (DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

        ---loading locations table
        SET @start_time = GETDATE ();
        PRINT'>> TRUNCATING TABLE: Bronze.Fintech_locations';
        TRUNCATE TABLE Bronze.Fintech_locations;

        PRINT '>> Inserting Data Into: Bronze.Fintech_locations';
        BULK INSERT Bronze.Fintech_locations
        FROM 'C:\Fintech\locations.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',
            TABLOCK
         );
        SET @end_time = GETDATE();
        PRINT '>>> Load Duration: ' + CAST (DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
        PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

        SET @batch_end_time = GETDATE ();
        PRINT '===================================='
        PRINT 'Loading Bronze Layer is Complete'
        PRINT ' - Total Load Duration: '+ CAST(DATEDIFF(SECOND,@batch_start_time, @batch_end_time) AS NVARCHAR) + 'Seconds';
        PRINT '====================================='

     END TRY
     BEGIN CATCH
            PRINT '=======================================';
            PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
            PRINT 'Error Message'+ERROR_MESSAGE();
            PRINT 'Error Message'+ CAST (ERROR_NUMBER() AS NVARCHAR);
            PRINT 'Error Message'+ CAST (ERROR_STATE() AS NVARCHAR);
            PRINT '=======================================';
     END CATCH
END
