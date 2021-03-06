/****** Object:  StoredProcedure [dbo].[ssp_CCRScheduledAppointments]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRScheduledAppointments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Proc [dbo].[ssp_CCRScheduledAppointments]
(
  @ServiceId INT  
)
as
/******************************************************************************                                                  
**  File: [ssp_CCRScheduledAppointments]                                              
**  Name: [ssp_CCRScheduledAppointments]                         
**  Desc:        
**  Return values:                                              
**  Called by:ssp_CCRMessageService                                                   
**  Parameters:                              
**  Auth:  Vikesh Bansal    
**  Date:  29/1/2013                                            
*******************************************************************************                                                  
**  Change History                                                  
*******************************************************************************                                                  
**  Date:       Author:       Description:                                
            
*******************************************************************************/   
declare @selectedDOS datetime
select @selectedDOS=DateOfService from services where ServiceId=@ServiceId

select top 3 convert(varchar(10),starttime,101) as AppointmentDate, LTRIM(RIGHT(CONVERT(VARCHAR(20), starttime, 100), 7)) as AppointmentTime, 
pc.DisplayAs as [Service],l.LocationName as Location, isnull(stf.signingsuffix+'' '','''') +isnull(stf.FirstName+'' '','''')+isnull(stf.LastName,'''') as ProviderName

from appointments apt
inner join Services s on s.Serviceid=apt.Serviceid inner join  ProcedureCodes pc on pc.procedurecodeid=s.procedurecodeid
left outer join locations l on l.locationid=apt.locationid
left outer join staff stf on stf.staffid=s.ClinicianId
 where apt.serviceid=@ServiceId and apt.starttime>=@selectedDOS
 and isnull(s.RecordDeleted,''N'')<>''Y''  and isnull(l.RecordDeleted,''N'')<>''Y'' and isnull(stf.RecordDeleted,''N'')<>''Y''
  and isnull(pc.RecordDeleted,''N'')<>''Y''

' 
END
GO
