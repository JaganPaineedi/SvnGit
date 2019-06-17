----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentSUDischarges')
BEGIN
/*   
 * TABLE: CustomDocumentSUDischarges 
 */
 CREATE TABLE CustomDocumentSUDischarges( 
		DocumentVersionId							int					 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime             NULL,
		DateOfDischarge								datetime			 NULL,
		DischargeReason								type_GlobalCode		 NULL,
		SUAdmissionDrugNameOne						type_GlobalCode		 NULL,
		SUAdmissionFrequencyOne						type_GlobalCode		 NULL,
		SUDischargeFrequencyOne						type_GlobalCode		 NULL,
		SUAdmissionDrugNameTwo						type_GlobalCode		 NULL,
		SUAdmissionFrequencyTwo						type_GlobalCode		 NULL,
		SUDischargeFrequencyTwo						type_GlobalCode		 NULL,
		SUAdmissionDrugNameThree					type_GlobalCode		 NULL,
		SUAdmissionFrequencyThree					type_GlobalCode		 NULL,
		SUDischargeFrequencyThree					type_GlobalCode		 NULL,
		SUAdmissionsTobaccoUse						type_GlobalCode		 NULL,
		SUDischargeTobaccoUse						type_GlobalCode		 NULL,
		LivingArrangement							type_GlobalCode		 NULL,
		EmploymentStatus							type_GlobalCode		 NULL,
		Education									type_GlobalCode		 NULL,
		NumberOfArrests								int					 NULL,
		SocialSupport								type_GlobalCode		 NULL,
		NumberOfSelfHelpGroupsAttendedLast30Days	int					 NULL,
		LastFaceToFaceDate							datetime			 NULL,
		PreferredUsage1								type_GlobalCode		 NULL,
		DrugName1									type_GlobalCode		 NULL,
		Frequency1									type_GlobalCode		 NULL,
		Route1										type_GlobalCode		 NULL,
		AgeOfFirstUseText1							varchar(25)			 NULL,
		AgeOfFirstUse1								char(1)				 NULL
													CHECK (AgeOfFirstUse1 in ('U','N')),
		PreferredUsage2								type_GlobalCode		 NULL,
		DrugName2									type_GlobalCode		 NULL,
		Frequency2									type_GlobalCode		 NULL,
		Route2										type_GlobalCode		 NULL,
		AgeOfFirstUseText2							varchar(25)			 NULL,
		AgeOfFirstUse2								char(1)				 NULL
													CHECK (AgeOfFirstUse2 in ('U','N')),
		PreferredUsage3								type_GlobalCode		 NULL,
		DrugName3									type_GlobalCode		 NULL,
		Frequency3									type_GlobalCode		 NULL,
		Route3										type_GlobalCode		 NULL,
		AgeOfFirstUseText3							varchar(25)			 NULL,
		AgeOfFirstUse3								char(1)				 NULL
													CHECK (AgeOfFirstUse3 in ('U','N')),
		CONSTRAINT CustomDocumentSUDischarges_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentSUDischarges') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentSUDischarges >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentSUDischarges >>>', 16, 1)
/* 
 * TABLE: CustomDocumentSUDischarges 
 */   
 
ALTER TABLE CustomDocumentSUDischarges ADD CONSTRAINT DocumentVersions_CustomDocumentSUDischarges_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
       
     PRINT 'STEP 4 COMPLETED'
 END

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_SUDischarge')
BEGIN
	INSERT INTO [dbo].[SystemConfigurationKeys] (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_SUDischarge'
		,'1.0'
		)
END
PRINT 'STEP 7 COMPLETED'
GO


	
	
	