----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.84)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.84 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
	
	/* Drop Constraint */

	/* Drop Constraint */
declare @Cstname nvarchar(max), 
    @sql nvarchar(1000)

-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='DocumentSignatures'
        AND TC.name='VerificationMode'
       order by SCO.name 
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [DocumentSignatures] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end
IF COL_LENGTH('DocumentSignatures','VerificationMode')IS NOT NULL
BEGIN
 ALTER TABLE DocumentSignatures WITH CHECK ADD CHECK  (VerificationMode in ('S','P','V'))									  

/* 
 * TABLE: DocumentSignatures 
 */
 
IF EXISTS (SELECT *	FROM::fn_listextendedproperty('DocumentSignatures_Description', 'schema', 'dbo', 'table', 'DocumentSignatures', 'column', 'VerificationMode'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'DocumentSignatures_Description'
		,'schema'
		,'dbo'
		,'table'
		,'DocumentSignatures'
		,'column'
		,'VerificationMode'
END

EXEC sys.sp_addextendedproperty 'DocumentSignatures_Description'
	,'VerificationMode column stores S,P,V. S-Signature Pad or Mouse/Touchpad,P-Password,V-Verbally Agreed Over Phone'
	,'schema'
	,'dbo'
	,'table'
	,'DocumentSignatures'
	,'column'
	,'VerificationMode' 
	 
	PRINT 'STEP 3 COMPLETED'
END
	
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.84)
BEGIN
Update SystemConfigurations set DataModelVersion=19.85
PRINT 'STEP 7 COMPLETED'
END

Go
