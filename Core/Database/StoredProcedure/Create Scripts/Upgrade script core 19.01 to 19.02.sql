----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.01)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.01 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
-- added new column(s) in  Services table 

IF OBJECT_ID('Services')  IS NOT NULL
BEGIN

	IF COL_LENGTH('Services','NoteReplacement') IS NULL
	BEGIN
		ALTER TABLE Services ADD NoteReplacement  type_YOrN	NULL
							 CHECK (NoteReplacement in ('Y','N'))
							 
	EXEC sys.sp_addextendedproperty 'Services_Description'
		,'NoteReplacement column indicates scanned/uploaded document(s) as replacement for Note" under attachments tab in service note.'
		,'schema'
		,'dbo'
		,'table'
		,'Services'
		,'column'
		,'NoteReplacement'      
	END
	
	IF COL_LENGTH('Services','AttachmentComments') IS NULL
	BEGIN
		ALTER TABLE Services ADD AttachmentComments  varchar(500)	NULL     
	END
		
	PRINT 'STEP 3 COMPLETED'

END

----END Of STEP 3 ------------

------ STEP 4 ---------------
 
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 19.01)
BEGIN
Update SystemConfigurations set DataModelVersion=19.02
PRINT 'STEP 7 COMPLETED'
END
Go

