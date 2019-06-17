----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.74)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.74 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('CQMSolution.StagingCQMData') IS NOT NULL
BEGIN
	IF COL_LENGTH('CQMSolution.StagingCQMData','D001') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D001 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D002') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D002 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D003') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D003 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D004') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D004 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D005') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D005 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D006') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D006 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D007') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D007 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D008') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D008 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D009') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D009 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D010') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D010 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D011') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D011 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D012') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D012 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D013') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D013 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D014') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D014 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D015') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D015 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D016') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D016 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D017') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D017 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D018') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D018 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D019') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D019 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D020') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D020 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D021') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D021 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D022') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D022 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D023') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D023 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D024') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D024 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D025') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D025 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D026') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D026 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D027') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D027 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D028') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D028 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D029') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D029 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D030') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D030 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D031') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D031 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D032') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D032 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D033') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D033 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D034') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D034 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D035') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D035 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D036') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D036 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D037') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D037 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D038') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D038 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D039') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D039 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D040') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D040 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D041') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D041 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D042') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D042 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D043') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D043 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D044') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D044 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D045') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D045 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D046') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D046 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D047') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D047 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D048') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D048 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D049') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D049 varchar(4096) NULL
	END
	
	IF COL_LENGTH('CQMSolution.StagingCQMData','D050') IS NOT NULL
	BEGIN
	 ALTER TABLE CQMSolution.StagingCQMData ALTER COLUMN  D050 varchar(4096) NULL
	END

	 PRINT 'STEP 3 COMPLETED'
END
------ END OF STEP 3 -----

------ STEP 4 ----------

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.74)
BEGIN
Update SystemConfigurations set DataModelVersion=19.75
PRINT 'STEP 7 COMPLETED'
END
Go