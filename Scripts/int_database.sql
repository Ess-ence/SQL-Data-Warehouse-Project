/*
===============================================
Creates Database and Schemas
===============================================
Script Purpose & Warning:
  This script creates a new database called 'FintechFraud' after checking and dropping it if exists. 
  The scripts also creates new schemas in the database; 'Bronze', 'Silver' and 'Gold'.

  Proceed with caution using this script. Ensure data is properly backed up
  before running the script as it will result in dropping data if the DB Exists. 
*/

USE master;
GO 

---Create the Databse & Schema
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'FintechFraud')
BEGIN
	ALTER DATABASE FintechFraud SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE FintechFraud
END;
GO

---Create Database :FintechFraud 
CREATE DATABASE FintechFraud;
Go

USE FintechFraud;
GO

---create schemas 

CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver; 
GO

CREATE SCHEMA Gold; 
GO

