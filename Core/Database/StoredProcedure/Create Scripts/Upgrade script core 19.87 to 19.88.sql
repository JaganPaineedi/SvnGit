----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.87)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.87 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
	
----Add New Column in TreatmentEpisodes Table 	
IF OBJECT_ID('TreatmentEpisodes') IS NOT NULL
BEGIN
		IF COL_LENGTH('TreatmentEpisodes','ReferralDate')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralDate  datetime	NULL						  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralType')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralType  type_GlobalCode	NULL						  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralSubtype')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralSubtype  type_GlobalSubCode	NULL							  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralName')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralName  varchar(100)	NULL					  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralDetails')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralDetails  type_Comment2	NULL						  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralAdditionalInformation')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralAdditionalInformation  type_Comment2	NULL							  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralReason1')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralReason1  type_GlobalCode	NULL						  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralReason2')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralReason2  type_GlobalCode	NULL							  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralReason3')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralReason3  type_GlobalCode	NULL						  
		END
		
		IF COL_LENGTH('TreatmentEpisodes','ReferralComment')IS NULL
		BEGIN
		 ALTER TABLE TreatmentEpisodes ADD  ReferralComment  type_Comment2	NULL						  
		END
		
 PRINT 'STEP 3 COMPLETED'
END

	
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.87)
BEGIN
Update SystemConfigurations set DataModelVersion=19.88
PRINT 'STEP 7 COMPLETED'
END

Go
