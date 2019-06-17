------- STEP 1 ----------

IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_Assessment')  < 1.0 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_Assessment'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_Assessment update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------


IF COL_LENGTH('CustomSafetyCrisisPlanReviews','CrisisResolved')IS NULL
BEGIN
 	ALTER TABLE CustomSafetyCrisisPlanReviews ADD CrisisResolved type_YOrN NULL
 												  CHECK(CrisisResolved in ('Y','N'))	
END
IF COL_LENGTH('CustomSafetyCrisisPlanReviews','NextSafetyPlanReviewDate')IS NULL
BEGIN
	ALTER TABLE CustomSafetyCrisisPlanReviews ADD NextSafetyPlanReviewDate datetime NULL	     
  
END
IF COL_LENGTH('CustomSafetyCrisisPlanReviews','CrisisDisposition')IS NULL
BEGIN
	ALTER TABLE CustomSafetyCrisisPlanReviews ADD CrisisDisposition type_Comment2 NULL	     
  
END
PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------
  IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='Cstm_Conv_Map_DocumentInitializationLog')
BEGIN
/* 
 * TABLE: Cstm_Conv_Map_DocumentInitializationLog 
 */
 CREATE TABLE Cstm_Conv_Map_DocumentInitializationLog( 
		MapDocumentInitializationLogId	int IDENTITY(1,1)		NOT NULL,
		CreatedBy						type_CurrentUser		NOT NULL,
		CreatedDate						type_CurrentDatetime	NOT NULL,
		ModifiedBy						type_CurrentUser		NOT NULL,
		ModifiedDate					type_CurrentDatetime	NOT NULL,
		RecordDeleted					type_YOrN				NULL
										CHECK(RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,
		TableName						varchar(50)				NULL,
		TabName							varchar(50)				NULL,
		ColumnName						varchar(50)				NULL,
		Diagnosis						varchar(10)				NULL,
		FieldName						varchar(max)			NULL,
		GroupName						varchar(max)			NULL,
		CONSTRAINT Cstm_Conv_Map_DocumentInitializationLog_PK PRIMARY KEY CLUSTERED (MapDocumentInitializationLogId)
)
/* 
 * TABLE: Cstm_Conv_Map_DocumentInitializationLog 
 */
END
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_Assessment')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_Assessment'
	PRINT 'STEP 7 COMPLETED'
END
GO

