/****** Object:  StoredProcedure [dbo].[csp_ReportShowServicesCharges]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportShowServicesCharges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportShowServicesCharges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportShowServicesCharges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[csp_ReportShowServicesCharges]

( @StartDate DATETIME, @EndDate DATETIME )

AS

/*
Modifed by	Modified Date	Reason
avoss						Created

declare @StartDate datetime, @EndDate datetime 
select @StartDate = ''10/1/2000'', @EndDate = ''9/30/2012''

exec dbo.csp_ReportShowServicesCharges @StartDate, @EndDate
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY


Declare @Title varchar(max)
Declare @SubTitle varchar(max)
declare @Comment varchar(max)

Set @Title = ''Charges for Show Services''
Set @SubTitle = '''' 
set @Comment = ''''


DECLARE @StoredProcedure varchar(300)
SET @StoredProcedure = object_name(@@procid)

IF @StoredProcedure is not NULL
and not exists (Select 1 From CustomReportParts 
				Where StoredProcedure = @StoredProcedure
				)
	BEGIN
		INSERT into CustomReportParts (StoredProcedure, ReportName, Title, SubTitle, Comment)
		Select @StoredProcedure, @Title, @Title, @SubTitle, @Comment
	END
Else
	BEGIN
		UPDATE CustomReportParts
		SET ReportName = @Title
			, Title = @Title
			, SubTitle = @SubTitle
			, Comment = @Comment
		WHERE StoredProcedure = @StoredProcedure
	END


SELECT 
s.DateOfService, 
p.ProgramName,
pc.DisplayAs AS ProcedureCode,
s.Unit AS Duration,
gc2.CodeName AS DurationType,
gc.CodeName AS Status,
Charge AS ChargeAmount
INTO #Report
FROM Services s 
JOIN dbo.ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
JOIN dbo.Programs p ON p.ProgramId = s.ProgramId
JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = s.Status
JOIN dbo.GlobalCodes gc2 ON gc2.GlobalCodeId = s.UnitType
WHERE ISNULL(s.RecordDeleted,''N'') <> ''Y''
AND s.Status = 71 --Show
AND s.DateOfService > @StartDate
AND s.DateOfService < @EndDate
ORDER BY s.DateOfService ASC, p.ProgramName

		
DECLARE @TotalServiceCount INT, @TotalCharges MONEY

SELECT @TotalServiceCount =  COUNT(1) FROM #Report r 
SELECT @TotalCharges = SUM(r.ChargeAmount) FROM #Report r 
-------------------------------------

If exists (select 1 from #Report)
	begin 
		select 
			 @Title as Title
			,@SubTitle as SubTitle
			,@Comment as Subcomment
			,@StoredProcedure as StoredProcedure
			,@TotalServiceCount AS TotalServiceCount
			,@TotalCharges AS TotalCharges
			,r.*
		from #Report r 
	end
else 
		select @Title, @SubTitle, @Comment

drop table #Report
END TRY 

BEGIN CATCH
    EXEC ssp_SQLErrorHandler 
END CATCH



SET TRANSACTION ISOLATION LEVEL READ COMMITTED' 
END
GO
