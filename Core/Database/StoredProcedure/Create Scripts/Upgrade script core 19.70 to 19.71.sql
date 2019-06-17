----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.70)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.70 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
-------Add Column in DocumentCodes Table 

IF OBJECT_ID('DocumentCodes') IS NOT NULL
BEGIN
		IF COL_LENGTH('DocumentCodes','DefaultStaffCoSigner') IS NULL
		BEGIN
			ALTER TABLE DocumentCodes ADD DefaultStaffCoSigner   type_YOrN	NULL
									  CHECK (DefaultStaffCoSigner in ('Y','N'))		
		EXEC sys.sp_addextendedproperty 'DocumentCodes_Description'
		,'DefaultStaffCoSigner is checked(Y) add the Add person as a co-signer selected in Staff detail to documents.DefaultStaffCoSigner is unchecked(N) no need to add Default co-signer for the documents'
		,'schema'
		,'dbo'
		,'table'
		,'DocumentCodes'
		,'column'
		,'DefaultStaffCoSigner'						  
									  						
		END
END		

-------Add Column in StaffPreferences Table 

IF OBJECT_ID('StaffPreferences') IS NOT NULL
BEGIN
		IF COL_LENGTH('StaffPreferences','AlwaysDefaultCoSigner') IS NULL
		BEGIN
			ALTER TABLE StaffPreferences ADD AlwaysDefaultCoSigner   type_YOrN	NULL
										 CHECK (AlwaysDefaultCoSigner in ('Y','N'))
							  
		 EXEC sys.sp_addextendedproperty 'StaffPreferences_Description'
		,'When checkbox = checked – we will always use the co-signer in that field to add that user as a co-signer for ALL documents.
		 When checkbox = unchecked and a value is selected in drop down.
		 This should look at the document codes Add Default Staff Co-Signer = yes and add that person as a co-signer. If equals No do not add the person as a co-signer'
		,'schema'
		,'dbo'
		,'table'
		,'StaffPreferences'
		,'column'
		,'AlwaysDefaultCoSigner'
											
		END
END		
	
PRINT 'STEP 3 COMPLETED'


------ END OF STEP 3 -----

------ STEP 4 ----------

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.70)
BEGIN
Update SystemConfigurations set DataModelVersion=19.71
PRINT 'STEP 7 COMPLETED'
END
Go