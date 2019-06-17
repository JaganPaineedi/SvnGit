----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  <  15.35)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.35 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

 

------ STEP 3 ------------

IF OBJECT_ID('SuicideRiskAssessmentDocuments') IS NOT NULL
BEGIN
	IF COL_LENGTH('SuicideRiskAssessmentDocuments','SuicideRiskAssessmentNotDone')IS NULL
	BEGIN 
		ALTER TABLE SuicideRiskAssessmentDocuments ADD SuicideRiskAssessmentNotDone type_YOrN	NULL
										           CHECK (SuicideRiskAssessmentNotDone in ('Y','N'))									
	END
END
GO

IF OBJECT_ID('PHQ9Documents') IS NOT NULL
BEGIN
	IF COL_LENGTH('PHQ9Documents','AdditionalEvalForDepressionPerformed')IS NULL
	BEGIN 
		ALTER TABLE PHQ9Documents ADD AdditionalEvalForDepressionPerformed type_YOrN	NULL
								   CHECK (AdditionalEvalForDepressionPerformed in ('Y','N'))									
	END
	
	IF COL_LENGTH('PHQ9Documents','ReferralForDepressionOrdered')IS NULL
	BEGIN 
		ALTER TABLE PHQ9Documents ADD ReferralForDepressionOrdered type_YOrN	NULL
								   CHECK (ReferralForDepressionOrdered in ('Y','N'))									
	END
	
	IF COL_LENGTH('PHQ9Documents','DepressionMedicationOrdered')IS NULL
	BEGIN 
		ALTER TABLE PHQ9Documents ADD DepressionMedicationOrdered type_YOrN	NULL
								   CHECK (DepressionMedicationOrdered in ('Y','N'))									
	END
	
	IF COL_LENGTH('PHQ9Documents','SuicideRiskAssessmentPerformed')IS NULL
	BEGIN 
		ALTER TABLE PHQ9Documents ADD SuicideRiskAssessmentPerformed type_YOrN	NULL
								   CHECK (SuicideRiskAssessmentPerformed in ('Y','N'))									
	END
	IF COL_LENGTH('PHQ9Documents','ClientRefusedOrContraIndicated')IS NULL
	BEGIN 
		ALTER TABLE PHQ9Documents ADD ClientRefusedOrContraIndicated type_YOrN	NULL
								   CHECK (ClientRefusedOrContraIndicated in ('Y','N'))									
	END
	
END
GO

IF OBJECT_ID('PHQ9ADocuments') IS NOT NULL
BEGIN
	IF COL_LENGTH('PHQ9ADocuments','TotalScore')IS NULL
	BEGIN 
		ALTER TABLE PHQ9ADocuments ADD TotalScore int	NULL						
	END
	
	IF COL_LENGTH('PHQ9ADocuments','AdditionalEvalForDepressionPerformed')IS NULL
	BEGIN 
		ALTER TABLE PHQ9ADocuments ADD AdditionalEvalForDepressionPerformed type_YOrN	NULL
								   CHECK (AdditionalEvalForDepressionPerformed in ('Y','N'))									
	END
	
	IF COL_LENGTH('PHQ9ADocuments','ReferralForDepressionOrdered')IS NULL
	BEGIN 
		ALTER TABLE PHQ9ADocuments ADD ReferralForDepressionOrdered type_YOrN	NULL
								   CHECK (ReferralForDepressionOrdered in ('Y','N'))									
	END
	
	IF COL_LENGTH('PHQ9ADocuments','DepressionMedicationOrdered')IS NULL
	BEGIN 
		ALTER TABLE PHQ9ADocuments ADD DepressionMedicationOrdered type_YOrN	NULL
								   CHECK (DepressionMedicationOrdered in ('Y','N'))									
	END
	
	IF COL_LENGTH('PHQ9ADocuments','SuicideRiskAssessmentPerformed')IS NULL
	BEGIN 
		ALTER TABLE PHQ9ADocuments ADD SuicideRiskAssessmentPerformed type_YOrN	NULL
								   CHECK (SuicideRiskAssessmentPerformed in ('Y','N'))									
	END
	
	IF COL_LENGTH('PHQ9ADocuments','ClientRefusedOrContraIndicated')IS NULL
	BEGIN 
		ALTER TABLE PHQ9ADocuments ADD ClientRefusedOrContraIndicated type_YOrN	NULL
								   CHECK (ClientRefusedOrContraIndicated in ('Y','N'))									
	END
	
END
GO

PRINT 'STEP 3 COMPLETED'


-----END Of STEP 3--------------------

------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.35)
BEGIN
Update SystemConfigurations set DataModelVersion=15.36
PRINT 'STEP 7 COMPLETED'
END
Go