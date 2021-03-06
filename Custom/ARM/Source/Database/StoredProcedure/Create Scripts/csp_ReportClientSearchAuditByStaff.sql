/****** Object:  StoredProcedure [dbo].[csp_ReportClientSearchAuditByStaff]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientSearchAuditByStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientSearchAuditByStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientSearchAuditByStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReportClientSearchAuditByStaff]
(@StaffId	int, @SearchStartDate	datetime, 	@SearchEndDate		datetime )

as
/*
Declare @StaffId	int,
		@SearchStartDate	datetime,
		@SearchEndDate		datetime

Select	@StaffID = 31,
		@SearchStartDate = ''10/1/2007'',
		@SearchEndDate = Getdate()
*/
Begin	--Search Info--	
Select	s.LastName+'', ''+s.FirstName as Staff, 
		c.LastName+'', ''+c.FirstName as Client, 
		-- Search Date formating -- 
		convert(varchar(10),csa.SearchDate,101) +'' ''+
		case when datepart(hour,csa.SearchDate) > 12 
				then convert(varchar(2),(datepart(hour,csa.SearchDate)-12)) 
			when datepart(hour,csa.SearchDate) < 1 
				then ''12'' 
		else convert(varchar(2),(datepart(hour,csa.SearchDate))) end 
		+ '':''+ 
		case when datepart(minute,csa.SearchDate) < 10 
				then ''0'' 
		else '''' end 
		+ convert(char(2),datepart(minute, csa.SearchDate)) +'' ''+ 
		case when datepart(hour,csa.SearchDate) > 12 
			then ''PM''
		else ''AM'' end as SearchDate,
		csa.LastName,
		csa.FirstName,	
		csa.ClientID,csa.DOB,csa.SSN,csa.MedicaidID,
		cva.ClientSelected --, csa.*,cva.*
From ClientSearchAudits csa
	Join ClientViewAudits cva on cva.SearchId = csa.SearchId
	Join Staff s on s.StaffId = csa.Staffid
	Join Clients c on c.ClientId = cva.ClientId
where isnull(cva.ClientSelected,''N'') = ''Y''
and @Staffid = csa.StaffId
and (dbo.RemoveTimestamp(csa.SearchDate) >= @SearchStartDate 
	and dbo.RemoveTimestamp(csa.SearchDate) <= @SearchEndDate)


end
' 
END
GO
