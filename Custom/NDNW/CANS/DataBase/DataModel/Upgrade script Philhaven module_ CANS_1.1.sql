----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
/* Add Column(s) */
IF COL_LENGTH('CustomDocumentCANSGenerals','LDFLegal')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFLegal char(1) NULL CHECK (LDFLegal in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFRecreation')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFRecreation char(1) NULL CHECK (LDFRecreation in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFFamily')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFFamily char(1) NULL CHECK (LDFFamily in('N','U','0','1','2','3'))
END
GO
IF COL_LENGTH('CustomDocumentCANSGenerals','LDFSchoolBehavior')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFSchoolBehavior char(1) NULL CHECK (LDFSchoolBehavior in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFSleep')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFSleep char(1) NULL CHECK (LDFSleep in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFDevelopment')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFDevelopment char(1) NULL CHECK (LDFDevelopment in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFMedical')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFMedical char(1) NULL CHECK (LDFMedical in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFLivingSituation')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFLivingSituation char(1) NULL CHECK (LDFLivingSituation in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFPhysical')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFPhysical char(1) NULL CHECK (LDFPhysical in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFSchoolAttendance')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFSchoolAttendance char(1) NULL CHECK (LDFSchoolAttendance in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFSexuality')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFSexuality char(1) NULL CHECK (LDFSexuality in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFJobFunctioning')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFJobFunctioning char(1) NULL CHECK (LDFJobFunctioning in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFSchoolAchievement')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFSchoolAchievement char(1) NULL CHECK (LDFSchoolAchievement in('N','U','0','1','2','3'))
END
GO

PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------

--PRINT 'STEP 4 COMPLETED'
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_CANS')
	begin
	INSERT INTO [dbo].[SystemConfigurationKeys]
			   (CreatedBy
			   ,CreateDate 
			   ,ModifiedBy
			   ,ModifiedDate
			   ,[Key]
			   ,Value
			   )
		 VALUES    
			   ('SHSDBA'
			   ,GETDATE()
			   ,'SHSDBA'
			   ,GETDATE()
			   ,'CDM_CANS'
			   ,'1.1'
			   )
        
	End
Else
	Begin
		Update SystemConfigurationKeys set value ='1.1' Where [key] = 'CDM_CANS'
	End
Go

PRINT 'STEP 7 COMPLETED'