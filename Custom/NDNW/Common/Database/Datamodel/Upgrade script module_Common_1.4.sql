------- STEP 1 ----------
IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  < 1.3 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.3 for CDM_Common update.Upgrade Script Failed.>>>', 16, 1)
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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDateTracking')
BEGIN
/* 
 TABLE: CustomDateTracking 
 */ 
 CREATE TABLE CustomDateTracking( 
		 DocumentVersionId									int					 NOT NULL,
		 CreatedBy											type_CurrentUser     NOT NULL,
		 CreatedDate										type_CurrentDatetime NOT NULL,
		 ModifiedBy											type_CurrentUser     NOT NULL,
		 ModifiedDate										type_CurrentDatetime NOT NULL,
		 RecordDeleted										type_YOrN			 NULL
															CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy											type_UserId         NULL,
		 DeletedDate										datetime			NULL,
		 DocumentationHealthHistoryDate						datetime			NULL,
		 DocumentationAnnualCustomerInformation				datetime			NULL,
		 DocumentationNext3803DueOn							datetime			NULL,
		 DocumentationPrivacyNoticeGivenOn					datetime			NULL,
		 DocumentationPcpLetter								datetime			NULL,
		 DocumentationPcpRelease							datetime			NULL,
		 DocumentationBasis32								datetime			NULL,
		 MedicationConsentMedication1						varchar(35)			NULL,
		 MedicationConsentMedicationDate1					datetime			NULL,
		 MedicationConsentMedication2						varchar(35)			NULL,
		 MedicationConsentMedicationDate2					datetime			NULL,
		 MedicationConsentMedication3						varchar(35)			NULL,
		 MedicationConsentMedicationDate3					datetime			NULL,
		 MedicationConsentMedication4						varchar(35)			NULL,
		 MedicationConsentMedicationDate4					datetime			NULL,
		 MedicationConsentMedication5						varchar(35)			NULL,
		 MedicationConsentMedicationDate5					datetime			NULL,
		 MedicationConsentMedication6						varchar(35)			NULL,
		 MedicationConsentMedicationDate6					datetime			NULL,
		 MedicationConsentMedication7						varchar(35)			NULL,
		 MedicationConsentMedicationDate7					datetime			NULL,
		 MedicationConsentMedication8						varchar(35)			NULL,
		 MedicationConsentMedicationDate8					datetime			NULL,
		 CustomerSatisfactionSurvey							type_YOrN			NULL
															CHECK (CustomerSatisfactionSurvey in ('Y','N')),
		CONSTRAINT CustomDateTracking_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDateTracking') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDateTracking >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDateTracking >>>', 16, 1)
/* 
 * TABLE: CustomDateTracking 
 */   
 
 ALTER TABLE CustomDateTracking ADD CONSTRAINT DocumentVersions_CustomDateTracking_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
	PRINT 'STEP 4 COMPLETED'
 END 
 --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  = 1.3)
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.4' WHERE [key] = 'CDM_Common'
	PRINT 'STEP 7 COMPLETED'
END
GO

