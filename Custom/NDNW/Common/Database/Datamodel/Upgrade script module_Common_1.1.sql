------- STEP 1 ----------
IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  < 1.0 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_Common update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins 

--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ----------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomBugTracking')
BEGIN
/*  
 * TABLE: CustomBugTracking 
 */
CREATE TABLE CustomBugTracking(
			 BugTrackingId			int identity(1,1)		NOT NULL,
			 ClientId				int						NULL,
			 DocumentId				int						NULL,
			 ServiceId				int						NULL,
			 [Description]			varchar(max)			NULL,
			 CreatedDate			datetime				NULL,
			 DocumentVersionId		int						NULL,
			 CONSTRAINT CustomBugTracking_PK PRIMARY KEY CLUSTERED (BugTrackingId)
	)
IF OBJECT_ID('CustomBugTracking') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomBugTracking >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomBugTracking >>>', 16, 1)
/* 
 * TABLE: CustomBugTracking 
 */
	
	PRINT 'STEP 4 COMPLETED'  

END

 --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_Common'
	PRINT 'STEP 7 COMPLETED'
END
GO

