/****** Object:  StoredProcedure [dbo].[csp_ReportAuthorizationsExpiring]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationsExpiring]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportAuthorizationsExpiring]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationsExpiring]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[csp_ReportAuthorizationsExpiring]

( @Days int )


AS

/*
Modifed by	Modified Date	Reason
avoss						Created

declare @StartDate datetime, @EndDate datetime , @Days int
select @StartDate = ''10/1/2010'', @EndDate = ''9/30/2011'', @Days = 30

exec dbo.csp_ReportAuthorizationsExpiring @Days 
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY


Declare @Title varchar(max)
Declare @SubTitle varchar(max)
declare @Comment varchar(max)

Set @Title = ''Authorizations expiring within '' + CONVERT(VARCHAR(10),@Days) + '' days.''
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
 ISNULL(c1.ClientId,c2.ClientId) AS ClientId
,ISNULL(c1.LastName + '', '' + c1.FirstName, c2.LastName + '', '' + c2.FirstName) AS ClientName
,ad.AuthorizationDocumentId
,a.AuthorizationId
,cp.DisplayAs AS CoveragePlan
,ac.DisplayAs AS AuthorizationCode
,gc.CodeName AS STATUS
,gc2.CodeName AS Frequency
,gc3.CodeName AS FrequencyRequested
,a.Units
,a.StartDate
,a.EndDate
,a.TotalUnits
,a.StaffId
,a.UnitsRequested
,a.StartDateRequested
,a.EndDateRequested
,a.TotalUnitsRequested
,a.StaffIdRequested
,a.DateRequested
,a.DateReceived
,a.UnitsUsed
,a.StartDateUsed
,a.EndDateUsed
,a.UnitsScheduled
,a.ProviderAuthorizationId
,a.Urgent
,a.ReviewLevel
,a.ReviewerId
,a.ReviewerOther
,a.ReviewedOn
,a.Rationale
,DATEDIFF(dd,GETDATE(),a.EndDate) AS DaysUntilExpired
INTO #Report
FROM  dbo.AuthorizationDocuments ad 
JOIN dbo.Authorizations a ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId AND ISNULL(a.RecordDeleted,''N'') <> ''Y''
JOIN dbo.AuthorizationCodes ac ON ac.AuthorizationCodeId = a.AuthorizationCodeId AND ISNULL(ac.RecordDeleted,''N'')<>''Y''
JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = a.Status
LEFT JOIN dbo.GlobalCodes gc2 ON gc2.GlobalCodeId = a.Frequency
LEFT JOIN dbo.GlobalCodes gc3 ON gc3.GlobalCodeId = a.FrequencyRequested
LEFT JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId AND ISNULL(ccp.RecordDeleted,''N'') <> ''Y''
LEFT JOIN dbo.CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId AND ISNULL(cp.RecordDeleted,''N'') <> ''Y''
LEFT JOIN Documents d ON d.DocumentId = ad.DocumentId AND ISNULL(d.RecordDeleted,''N'') <> ''Y''
LEFT JOIN clients c1 ON c1.ClientId = d.ClientId AND ISNULL(c1.RecordDeleted,''N'') <> ''Y''
LEFT JOIN clients c2 ON c2.ClientId = ccp.ClientId AND ISNULL(c2.RecordDeleted,''N'') <> ''Y''
WHERE ISNULL(ad.RecordDeleted,''N'') <> ''Y''
AND DATEDIFF(dd,GETDATE(),a.EndDate) <= @Days
AND DATEDIFF(dd,GETDATE(),a.EndDate) >=0

		
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
