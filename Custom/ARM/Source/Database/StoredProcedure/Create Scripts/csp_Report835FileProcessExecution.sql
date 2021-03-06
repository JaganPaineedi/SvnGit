/****** Object:  StoredProcedure [dbo].[csp_Report835FileProcessExecution]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report835FileProcessExecution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report835FileProcessExecution]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report835FileProcessExecution]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create Procedure [dbo].[csp_Report835FileProcessExecution]

(@ERFileId INT, @UserCode VARCHAR(30))

AS

/*
Modifed by	Modified Date	Reason
avoss		08.16.2012		Created

declare @StartDate datetime, @EndDate datetime 
select @StartDate = ''10/1/2010'', @EndDate = ''9/30/2011''

exec dbo.csp_Report @StartDate, @EndDate
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY


Declare @Title varchar(max)
Declare @SubTitle varchar(max)
declare @Comment varchar(max)

Set @Title = ''835 File Processing''
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

CREATE TABLE #Report
( ReportMessage VARCHAR(MAX))

DECLARE @UserId INT
SELECT ISNULL(s.StaffId,1575)
FROM Staff s 
WHERE s.UserCode = LTRIM(RTRIM(@UserCode))

IF EXISTS (
	SELECT 1
	FROM dbo.ERFiles er
	WHERE ISNULL(er.RecordDeleted,''N'') <> ''Y''
	AND ISNULL(er.Processed,''N'') <> ''Y''
	AND ISNULL(er.Processing,''N'') <> ''Y''
	AND er.ERFileId = @ERFileId
)
	BEGIN
		BEGIN TRAN
			EXEC dbo.ssp_PMElectronicProcessERFile @ERFileId, @UserId
		COMMIT TRAN
		
		INSERT INTO #Report
				( ReportMessage )
		VALUES  ( ''File successfully processed''  -- ReportMessage - varchar(max)
				  )
	END

IF NOT EXISTS (
	SELECT 1
	FROM dbo.ERFiles er
	WHERE ISNULL(er.RecordDeleted,''N'') <> ''Y''
	AND ISNULL(er.Processed,''N'') <> ''Y''
	AND ISNULL(er.Processing,''N'') <> ''Y''
	AND er.ERFileId = @ERFileId
)
	BEGIN
		INSERT INTO #Report
				( ReportMessage )
		VALUES  ( ''File not found, please re-run report''  -- ReportMessage - varchar(max)
				  )
	END	
------------------------------------
	begin 
		select 
			 @Title as Title
			,@SubTitle as SubTitle
			,@Comment as Comment
			,@StoredProcedure as StoredProcedure
			,r.*
		from #Report r 
	end

drop table #Report
END TRY 

BEGIN CATCH
    EXEC ssp_SQLErrorHandler 
END CATCH



SET TRANSACTION ISOLATION LEVEL READ COMMITTED' 
END
GO
