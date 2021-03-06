/****** Object:  StoredProcedure [dbo].[csp_ReportPrintNoShow]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintNoShow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintNoShow]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintNoShow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'   
CREATE procedure [dbo].[csp_ReportPrintNoShow]  
@ApptDate smalldatetime,  
@ReceptionView int  
As  
Begin  
/********************************************************************************  
-- Stored Procedure: dbo.[csp_ReportPrintCallReminder]   
--  
-- Copyright: 2006 Streamline Healthcate Solutions  
--  
-- Purpose: Generates data for Call Reminder Report  
--   
--   
--  
-- Updates:                                                         
-- Date        Author      Purpose  
-- 06.04.2012  JJN        Created  
  
*********************************************************************************/  
declare @statusNoShow int = 72  
--select * from dbo.GlobalCodes where Category = ''servicestatus''  
  
--Client ID, Name, Appt date and time, phone numbers,clinician, procedure code, location, and sorted by clinician/date  
  
Create Table #ClientPhones (  
 ClientId int,  
 Phones varchar(500),  
)  
  
INSERT INTO #ClientPhones   
  (Clientid  
  ,Phones)  
SELECT DISTINCT   
     s.ClientId, ''''  
 From Services s  
 Where DATEDIFF(dd, @ApptDate, s.DateofService)=0  
 And s.Status = @statusNoShow  
   
--Concatenate Phone Numbers  
Update a  
Set a.Phones = b.Phones  
From #ClientPhones a  
Join (  
 Select b1.ClientId, (  
  Select Coalesce(PhoneNumber+Case When DoNotContact=''Y'' Then '' (DNC)'' Else '''' End,'''') + ''~''  
  From ClientPhones b2  
  Where b2.ClientId = b1.ClientId  
  And IsNull(b2.RecordDeleted,''N'') = ''N''  
  Order By PhoneNumber  
  For Xml Path('''')  
  ) as Phones  
 From ClientPhones b1  
 Where IsNull(b1.RecordDeleted,''N'') = ''N''  
 Group By ClientId  
 ) b on b.ClientId = a.ClientId  
  
Update #ClientPhones  
Set Phones = NULL  
Where Len(Phones)=0  
  
Select c.ClientId  
  ,c.LastName+'', ''+c.FirstName+Coalesce('' ''+Left(c.MiddleName,1)+''.'','''')       AS ClientName  
  , Convert(varchar(50),s.DateofService,100)              AS StartTime  
  ,Replace(Left(cp.Phones,Coalesce(Len(cp.Phones)-1,0)),''~'',Char(13)+Char(10))     AS Phones   
  ,pc.ProcedureCodeName  
  ,l.LocationName                     AS LocationName  
  ,clin.LastName+'', ''+clin.FirstName+Coalesce('' ''+Upper(Left(ltrim(clin.MiddleName),1))+''.'','''') AS ClinicianName  
  ,prim.LastName+'', ''+prim.FirstName+ Coalesce('' ''+Upper(Left(ltrim(prim.MiddleName),1))+''.'','''') AS PrimaryName  
  ,S.Status, s.DateOfService 
 -- ,CodeName          AS Status  
From ReceptionViews r  
Left Join ReceptionViewLocations rvl on rvl.ReceptionViewId = r.ReceptionViewId  
 And r.AllLocations <> ''Y''  
Left Join ReceptionViewStaff rvs on rvs.ReceptionViewId = r.ReceptionViewId  
 And r.AllStaff <> ''Y''  
Left Join ReceptionViewPrograms rvp on rvp.ReceptionViewId = r.ReceptionViewId  
 And r.AllPrograms <> ''Y''  
Join Services s on (s.LocationId = rvl.LocationId Or r.AllLocations = ''Y'')   
 And (s.ProgramId = rvp.ProgramId Or r.AllPrograms = ''Y'')  
 And (s.ClinicianId = rvs.Staffid Or r.AllStaff = ''Y'')  
 And DATEDIFF(dd, @ApptDate, s.DateofService)=0  
 And s.Status = @statusNoShow  
Join Clients c on c.ClientId = s.ClientId  
join dbo.Locations as l on l.LocationId = s.LocationId  
Left Join Staff clin on clin.StaffId = s.ClinicianId  
/*
Left Join Staff prim on prim.StaffId =  c.PrimaryClinicianId
*/
Left Join Staff prim on prim.StaffId = isnull((select top 1 ClinicianId
from Services x
JOIN ProcedureCodes pc ON x.ProcedureCodeId = pc.ProcedureCodeId
where x.ClientId = c.ClientId
and isnull(x.RecordDeleted,''N'')  = ''N''
and x.status in (71, 75) 
and pc.DisplayAs like ''CSP%''
order by x.DateOfService desc), c.PrimaryClinicianId)
Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId  
Left Join #ClientPhones cp on cp.ClientId = s.ClientId  
--Inner Join GlobalCOdes on S.Status=GlobalCodeID  
Where DATEDIFF(dd, @ApptDate, s.DateofService)=0  
And r.ReceptionViewId = @ReceptionView  
And IsNull(r.RecordDeleted,''N'') = ''N''  
And IsNull(s.RecordDeleted,''N'') = ''N''  
And IsNull(c.RecordDeleted,''N'') = ''N''  
And IsNull(clin.RecordDeleted,''N'') = ''N''  
And IsNull(prim.RecordDeleted,''N'') = ''N''  
And IsNull(pc.RecordDeleted,''N'') = ''N''  
And IsNull(rvl.RecordDeleted,''N'') = ''N''  
And IsNull(rvs.RecordDeleted,''N'') = ''N''  
And IsNull(rvp.RecordDeleted,''N'') = ''N''  
Order By clin.LastName, clin.FirstName, s.DateofService  
  
End  ' 
END
GO
