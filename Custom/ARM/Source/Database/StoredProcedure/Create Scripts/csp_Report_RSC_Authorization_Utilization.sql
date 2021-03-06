/****** Object:  StoredProcedure [dbo].[csp_Report_RSC_Authorization_Utilization]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_RSC_Authorization_Utilization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_RSC_Authorization_Utilization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_RSC_Authorization_Utilization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_RSC_Authorization_Utilization]
		@staffId		Int,
		@staff_super_vp	varchar(10)
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_RSC_Authorization_Utilization         	*/
/* Creation Date: 03/14/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Input Parameters: @staffId, @staff_super_vp     			     		*/
/*								     									*/
/* Description: Generate a report to show Utilization of RSC			*/
/*	Authorizations.		      											*/		      			
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	03/13/2013	MSR			Modified Original from Pysch Consult		*/	
/************************************************************************/
/*
DECLARE	@staffId		Int,
		@staff_super_vp	varchar(10)

SELECT	@staffId		= 0,
		@staff_super_vp	= ''su''
--*/

DECLARE @staff_id	varchar(10),
	@input_name	varchar(50),
	@loop		int

--***************************************************************************
	declare @TempStaff table
	(
		StaffId		Int,
		Staffname	Varchar(100)
	)
	
	if @StaffId = 0 begin
	insert @TempStaff 
	SELECT s.StaffId, s.LastName + '', '' + s.FirstName 
	FROM Staff s 
	WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'')
	AND s.Active = ''Y''
	end
	
	if @StaffId <> 0 and @staff_super_vp = ''su'' begin
		INSERT INTO @TempStaff
		SELECT * FROM dbo.fn_Supervisor_List(1, @StaffId)
	end
	
	if @StaffId <> 0 and @staff_super_vp = ''vp'' begin
		INSERT INTO @TempStaff
		SELECT * FROM dbo.fn_Supervisor_List(10, @StaffId)
	end
	
	if @StaffId <> 0 and @staff_super_vp = ''St'' begin
	insert into @TempStaff 
	select s.StaffId, s.LastName + '', '' + s.FirstName from Staff s 
	where s.StaffId = @StaffId 
	and (ISNULL(s.RecordDeleted, ''N'')<>''Y'')
	end
	
/*
select * from @TempStaff 
*/
--***************************************************************************

SELECT	DISTINCT
rtrim(c.ClientId) as ''ClientId'',
a.AuthorizationNumber as ''Auth #'',
convert(varchar, a.EndDate, 101) as ''Auth Expiration'',
ISNULL(a.Units, 0) as ''Mintues Authorized'',
ISNULL(SUM(srv.Unit), 0) as ''Minutes Used'',
CASE WHEN	(a.Units is NULL OR	a.Units = 0)
	 THEN	0
	 ELSE	ISNULL((SUM(srv.Unit) / a.Units) * 100, 0)
END	AS	''Used %'',
t.Staffname as ''Primary Clinician'',
c.LastName + '', '' + c.FirstName as ''Client''
FROM	Clients c
join ClientCoveragePlans ccp 
	on c.ClientId = ccp.ClientId 
	and (ISNULL(ccp.RecordDeleted, ''N'')<>''Y'')
join AuthorizationDocuments ad 
	on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId 
	and (ISNULL(ad.RecordDeleted, ''N'')<>''Y'')
JOIN	Authorizations a
	ON	ad.AuthorizationDocumentId = a.AuthorizationDocumentId
	and (ISNULL(a.RecordDeleted, ''N'')<>''Y'')	
join CoveragePlans cp
	on ccp.CoveragePlanId = cp.CoveragePlanId 
	and (ISNULL(cp.RecordDeleted, ''N'')<>''Y'')	
	AND	cp.DisplayAs like ''RSC%''
join AuthorizationCodeProcedureCodes acpc
	on a.AuthorizationCodeId = acpc.AuthorizationCodeId 
	and (ISNULL(acpc.RecordDeleted, ''N'')<>''Y'')
left join ServiceAuthorizations SA
	on a.AuthorizationId = sa.AuthorizationId 	
	and (ISNULL(SA.RecordDeleted, ''N'')<>''Y'')		
LEFT JOIN services srv
	ON	sa.ServiceId = srv.ServiceId 	
	AND	srv.DateOfService <= dateadd(dd, 1, a.EndDate)
	AND	srv.DateOfService >= a.StartDate
	AND	srv.status in (71, 75)
	and (ISNULL(srv.RecordDeleted, ''N'')<>''Y'')
JOIN @TempStaff t
	ON	c.PrimaryClinicianId = t.StaffId
WHERE (a.EndDate is null OR getdate() <= dateadd(dd, 1, a.EndDate))
GROUP BY
	c.ClientId,
	a.AuthorizationNumber,
	a.EndDate,
	a.Units,
	t.Staffname,
	c.LastName + '', '' + c.FirstName
ORDER BY
	''Client'',
	a.AuthorizationNumber


' 
END
GO
