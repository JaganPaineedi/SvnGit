/****** Object:  StoredProcedure [dbo].[csp_ReportStaffClientAccess]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportStaffClientAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportStaffClientAccess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportStaffClientAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_ReportStaffClientAccess]
@StaffId int,
@ClientId int,
@StartDate datetime,
@EndDate datetime
As


Create table #StaffClientAccess
(ApplicationName varchar(100),
 StaffId int,
 StaffName varchar(300),
 ClientId int,
 ClientName varchar(300),
 ScreenName varchar(300),
 ViewedDate datetime,
 ScreenDetail varchar(300),
 EffectiveDate datetime
)


Insert into #StaffClientAccess
(ApplicationName ,
 StaffId ,
 StaffName,
 ClientId ,
 ClientName ,
 ScreenName ,
 ViewedDate ,
 ScreenDetail ,
 EffectiveDate 
)
select case when sc2.ScreenName is not Null then ''SmartCare Web'' else a.ApplicationName end as ApplicationName, 
s.StaffId, s.LastName +'', '' + s.FirstName, c.ClientId, c.LastName +'', '' + c.FirstName,
case when sc.ScreenName is not null then sc.ScreenName
when sc2.ScreenName is not null then sc2.ScreenName end as ScreenName,
  sca.CreatedDate, 
case when sca.SystemScreenId in (3, 19) then pc.DisplayAs 
else dc.DocumentName end, 
case when sca.SystemScreenId in (3, 19) then se.DateOfService else d.EffectiveDate end
from StaffClientAccess sca
Join Clients c on c.ClientId = sca.ClientId
Join Staff s on s.StaffId = sca.StaffId
left Join SystemScreens sc on sc.SystemScreenId = sca.SystemScreenId
left Join Screens sc2 on sc2.ScreenId = sca.ScreenId
left Join Applications a on a.ApplicationId = sc.ApplicationId
Left Join Documents d on d.DocumentId = sca.ObjectId
Left Join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
Left Join Services se on se.ServiceId = sca.ObjectId and sca.SystemScreenID in (3, 19)--Service
Left Join ProcedureCodes pc on pc.ProcedureCodeId = se.ProcedureCodeId
where (@ClientId is null or @ClientId = c.ClientId)
and (@StaffId is null or @StaffId = sca.StaffId)
and convert(varchar(20), sca.CreatedDate, 101) >= @StartDate
and convert(varchar(20), sca.CreatedDate, 101) <= @EndDate
and isnull(sca.RecordDeleted, ''N'')= ''N''
and isnull(s.RecordDeleted, ''N'')= ''N''
and isnull(sc.RecordDeleted, ''N'')= ''N''
and isnull(a.RecordDeleted, ''N'')= ''N''
and isnull(d.RecordDeleted, ''N'')= ''N''
and isnull(dc.RecordDeleted, ''N'')= ''N''
and isnull(se.RecordDeleted, ''N'')= ''N''
and isnull(pc.RecordDeleted, ''N'')= ''N''
order by 3,  7


Select 
 ApplicationName ,
 StaffId ,
 StaffName,
 ClientId ,
 ClientName ,
 ScreenName ,
 ViewedDate ,
 ScreenDetail ,
 EffectiveDate 
From #StaffClientAccess


drop table #StaffClientAccess
' 
END
GO
