/****** Object:  StoredProcedure [dbo].[csp_ReportTemplate]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportTemplate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportTemplate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create Procedure [dbo].[csp_ReportTemplate]

( @StartDate DATETIME, @EndDate DATETIME ) 


AS

/*
Modifed by	Modified Date	Reason
avoss						Created

declare @StartDate datetime, @EndDate datetime 
select @StartDate = ''10/1/2010'', @EndDate = ''9/30/2011''

exec dbo.csp_ReportTemplate @StartDate, @EndDate
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY


Declare @Title varchar(max)
Declare @SubTitle varchar(max)
declare @Comment varchar(max)

Set @Title = ''''
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
	ClientId int
	,ClientName varchar(150)
	)

Insert into #Report 
(ClientId, ClientName)
SELECT 1, ''Test Report''
		

-------------------------------------

If exists (select 1 from #Report)
	begin 
		select 
			 @Title as Title
			,@SubTitle as SubTitle
			,@Comment as Subcomment
			,@StoredProcedure as StoredProcedure
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
