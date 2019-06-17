--Manjunath M Kondikoppa
--06- November -2016
--Update Script to Correct AllowAllPrograms and AllowAllLicensesDegrees column data. 
-------------------ProgramProcedures-------------------
CREATE TABLE #TempTable
(
		ProcedureCodeId int
)
INSERT INTO #TempTable SELECT ProcedureCodeId  FROM ProcedureCodes WHERE Isnull(RecordDeleted,'N')<>'Y' AND Active='Y'

WHILE exists (select * from #TempTable)
BEGIN
    --START THE PROCESSING HERE 
			Declare @ProcedureCodeId int
			Set  @ProcedureCodeId=(select top 1 ProcedureCodeId
			from #TempTable order by ProcedureCodeId asc)
			
			DECLARE @ProgramsRowCount int 
			DECLARE @ProgramProceduresCount int 
			SET @ProgramsRowCount = (select Count(ProgramId) from Programs 
				WHERE Isnull(RecordDeleted,'N')<>'Y' AND Active='Y')
			SET @ProgramProceduresCount=(select Count(ProgramProcedureId) from ProgramProcedures 
				WHERE ISNULL(RecordDeleted,'N')<>'Y' AND ProcedureCodeId=@ProcedureCodeId)

			if(@ProgramsRowCount = @ProgramProceduresCount)
			 update ProcedureCodes set AllowAllPrograms = 'Y' where ProcedureCodeId=@ProcedureCodeId

			DELETE #TempTable where ProcedureCodeId = @ProcedureCodeId
     --END THE PROCESSING HERE 
END


IF (OBJECT_ID('tempdb..#TempTable') IS NOT NULL)
BEGIN
    DROP TABLE #TempTable
END


-------------------ProcedureCodeStaffCredentials---------
CREATE TABLE #TempTable2
(
		ProcedureCodeId int
)
INSERT INTO #TempTable2 SELECT ProcedureCodeId  FROM ProcedureCodes WHERE Isnull(RecordDeleted,'N')<>'Y' AND Active='Y'

WHILE exists (select * from #TempTable2)
BEGIN
    --START THE PROCESSING HERE 
			Declare @ProcedureCodesId int
			Set  @ProcedureCodesId=(select top 1 ProcedureCodeId
				 from #TempTable2 order by ProcedureCodeId asc)
			
			DECLARE @DegreesRowCount int 
			DECLARE @ProcedureCodeStaffCredentials int 

			SET @DegreesRowCount = (select Count(GlobalCodeId) from GlobalCodes 
				WHERE Category = 'Degree' AND Isnull(RecordDeleted,'N')<>'Y' AND Active='Y')
			SET @ProcedureCodeStaffCredentials=(select Count(ProcedureCodeStaffCredentialId) 
				from ProcedureCodeStaffCredentials WHERE ISNULL(RecordDeleted,'N')<>'Y' and 
				ProcedureCodeId=@ProcedureCodesId)

			if(@DegreesRowCount = @ProcedureCodeStaffCredentials)
			 update ProcedureCodes set AllowAllLicensesDegrees = 'Y' where ProcedureCodeId=@ProcedureCodesId
			
			DELETE #TempTable2 where ProcedureCodeId = @ProcedureCodesId
     --END THE PROCESSING HERE 
END

IF (OBJECT_ID('tempdb..#TempTable2') IS NOT NULL)
BEGIN
    DROP TABLE #TempTable2
END