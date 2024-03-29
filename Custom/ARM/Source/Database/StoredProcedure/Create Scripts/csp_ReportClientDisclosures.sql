/****** Object:  StoredProcedure [dbo].[csp_ReportClientDisclosures]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientDisclosures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientDisclosures]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientDisclosures]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_ReportClientDisclosures]
(@StartDate datetime, @EndDate datetime, @GlobalCode int)

as

Declare @Title varchar(max)
Declare @Subtitle varchar(max)
Declare @Message varchar(max)

Create Table #Report
(ClientId int, ClientName varchar(max), CreatedDate varchar(max), DisclosureStatus varchar(max), Title varchar(max), Subtitle varchar(max), Mes varchar(max))

Insert into #Report

select c.ClientId,
		c.LastName+'', ''+c.FirstName as ''ClientName'',
		convert(varchar(max),cd.CreatedDate,101) as ''CreatedDate'',
		gc.CodeName as ''DisclosureStatus'',
		@Title as ''Title'',
		@Subtitle as ''Subtitle'',
		@Message as ''Mes''
		
from ClientDisclosures cd
	Join clients c on cd.ClientId=c.ClientId
		and ISNULL(cd.recorddeleted, ''N'')<>''Y''
	Join GlobalCodes gc on gc.GlobalCodeId=cd.DisclosureStatus
		where (cd.CreatedDate>=@StartDate or @StartDate is null)
			and (cd.CreatedDate<=@EndDate or @EndDate is null)
			and ((gc.GlobalCodeId=@GlobalCode) or (@GlobalCode is null and gc.GlobalCodeId in 
				(21549,21550,21551,21552,21553,21554,21555,21556,21557,21558,21559,21560)))
			and gc.GlobalCodeId=cd.DisclosureStatus
			and ISNULL(gc.recorddeleted, ''N'')<>''Y''
			

	If (@StartDate<>null) and (@EndDate<>null) and (@GlobalCode<>null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''Between ''+CONVERT(varchar(max),@StartDate, 101)+'' and ''+CONVERT(varchar(max),@EndDate, 101)+
				'' and filtered by Disclosure Status:''+(select CodeName from GlobalCodes where @GlobalCode=GlobalCodes.GlobalCodeId)
			Update #Report
			Set @Message=''''
			Select * from #Report
		End
	If (@StartDate<>null) and (@EndDate<>null) and (@GlobalCode=null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''Between ''+CONVERT(varchar(max),@StartDate, 101)+'' and ''+CONVERT(varchar(max),@EndDate, 101)
			Update #Report
			Set @Message=''To narrow results, try filtering by "Disclosure Status".''
			Select * from #Report
		End
	If (@StartDate<>null) and (@EndDate=null) and (@GlobalCode=null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''Results Greater Than ''+CONVERT(varchar(max),@StartDate, 101)
			Update #Report
			Set @Message=''To narrow results, try filtering by "Disclosure Status" and by providing an End Date.''
			Select * from #Report
		End
	If (@StartDate=null) and (@EndDate=null) and (@GlobalCode=null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''All Client Disclosures''
			Update #Report
			Set @Message=''To narrow results, try filtering by "Disclosure Status" and by providing a Start Date and End Date.''
			Select * from #Report
		End
	If (@StartDate<>null) and (@EndDate=null) and (@GlobalCode<>null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''Results Greater Than ''+CONVERT(varchar(max),@StartDate, 101)+''and filtered by Disclosure Status:''
							+(select CodeName from GlobalCodes where @GlobalCode=GlobalCodes.GlobalCodeId)
			Update #Report
			Set @Message=''To narrow results, try filtering by "Disclosure Status" and by providing an End Date.''
			Select * from #Report
		End
	If (@StartDate=null) and (@EndDate=null) and (@GlobalCode<>null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''All Client Disclosures with a Disclosure Status of:''
							+(select CodeName from GlobalCodes where @GlobalCode=GlobalCodes.GlobalCodeId)
			Update #Report
			Set @Message=''To narrow results, try filtering by "Disclosure Status" and by providing an End Date.''
			Select * from #Report
		End
	If (@StartDate=null) and (@EndDate<>null) and (@GlobalCode<>null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''All Client Disclosures with a Disclosure Status of:''
							+(select CodeName from GlobalCodes where @GlobalCode=GlobalCodes.GlobalCodeId)+
							'' with a created date less than ''+CONVERT(varchar(max),@EndDate, 101)
			Update #Report
			Set @Message=''To narrow results, try filtering by "Disclosure Status" and by providing an End Date.''
			Select * from #Report
		End
	If (@StartDate=null) and (@EndDate<>null) and (@GlobalCode=null)
		Begin
			Update #Report
			Set @Title=''Client Disclosure Report''
			Update #Report
			Set @Subtitle=''All Client Disclosures with a created date less than ''+CONVERT(varchar(max),@EndDate, 101)
			Update #Report
			Set @Message=''To narrow results, try filtering by "Disclosure Status" and by providing an End Date.''
			Select * from #Report
		End
	
		
Drop table #Report
		
' 
END
GO
