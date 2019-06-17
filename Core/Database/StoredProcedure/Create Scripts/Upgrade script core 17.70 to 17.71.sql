----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 17.70)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 17.70 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ End of STEP 3 ------------
------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CommandLog')
BEGIN
/*  
 * TABLE: CommandLog 
 */
 CREATE TABLE CommandLog( 
			CommandLogId							int	identity(1,1)		NOT NULL,
			CreatedBy								type_CurrentUser		NOT NULL,
			CreatedDate								type_CurrentDatetime	NOT NULL,
			ModifiedBy								type_CurrentUser		NOT NULL,
			ModifiedDate							type_CurrentDatetime	NOT NULL,
			RecordDeleted							type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
			DeletedBy								type_UserId				NULL,
			DeletedDate								datetime				NULL,
			DatabaseName							sysname					NULL,
			SchemaName								sysname					NULL,
			ObjectName								sysname					NULL,
			ObjectType								char(2)					NULL,
			IndexName								sysname					NULL,
			IndexType								tinyint					NULL,
			StatisticsName							sysname					NULL,
			PartitionNumber							int						NULL,
			ExtendedInfo							xml						NULL,
			Command									nvarchar(max)			NOT NULL,
			CommandType								nvarchar(60)			NOT NULL,
			StartTime								datetime				NOT NULL,
			EndTime									datetime				NULL,
			ErrorNumber								int						NULL,
			ErrorMessage							nvarchar(max)			NULL,
			CONSTRAINT CommandLog_PK PRIMARY KEY CLUSTERED (CommandLogId)

 )
  IF OBJECT_ID('CommandLog') IS NOT NULL
    PRINT '<<< CREATED TABLE CommandLog >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CommandLog >>>', 16, 1)
   			     
/* 
 * TABLE: CommandLog 
 */ 
      
    PRINT 'STEP 4(A) COMPLETED'
END


----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 17.70)
BEGIN
Update SystemConfigurations set DataModelVersion=17.71
PRINT 'STEP 7 COMPLETED'
END
Go

