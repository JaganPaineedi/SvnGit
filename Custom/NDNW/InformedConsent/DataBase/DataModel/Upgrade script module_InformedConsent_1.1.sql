----- STEP 1 ----------

PRINT 'STEP 1 COMPLETED'
Go

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

GO

--Part2 Begins


--Part2 Ends
PRINT 'STEP 2 COMPLETED'
Go

-----End of Step 2 -------

------ STEP 3 ------------
IF COL_LENGTH('CustomDocumentInformedConsents','MemberRefusedExplaination') IS NULL
BEGIN
ALTER TABLE CustomDocumentInformedConsents ADD MemberRefusedExplaination type_Comment2 NULL
END
GO
------ END OF STEP 3 -----

------ STEP 4 ----------


PRINT 'STEP 4 COMPLETED'
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

PRINT 'STEP 6 COMPLETED'
GO

------ STEP 7 -----------

PRINT 'STEP 7 COMPLETED'
Update SystemConfigurations set CustomDataBaseVersion=1.28

Go

