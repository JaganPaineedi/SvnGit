/****** Object:  StoredProcedure [dbo].[csp_ReportGet835FilesToProcess]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGet835FilesToProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGet835FilesToProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGet835FilesToProcess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[csp_ReportGet835FilesToProcess]


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

Set @Title = ''835 Files to Process''
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


CREATE Table #Report (
	ERFileId INT,
	FILENAME VARCHAR(100),
	ImportDate DATETIME
	)

Insert into #Report 

SELECT er.ERFileId, er.FileName, er.ImportDate
FROM dbo.ERFiles er
WHERE ISNULL(er.RecordDeleted,''N'') <> ''Y''
AND ISNULL(er.Processed,''N'') <> ''Y''
AND ISNULL(er.Processing,''N'') <> ''Y''
		

-------------------------------------

If exists (select 1 from #Report)
	begin 
		select 
			 @Title as Title
			,@SubTitle as SubTitle
			,@Comment as Comment
			,@StoredProcedure as StoredProcedure
			,r.*
		from #Report r 
	end
else 
		select @Title AS Title, @SubTitle AS SubTitle, ''No files to process'' AS Comment

drop table #Report
END TRY 

BEGIN CATCH
    EXEC ssp_SQLErrorHandler 
END CATCH



SET TRANSACTION ISOLATION LEVEL READ COMMITTED' 
END
GO
