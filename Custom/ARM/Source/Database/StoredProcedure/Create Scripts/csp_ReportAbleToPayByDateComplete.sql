/****** Object:  StoredProcedure [dbo].[csp_ReportAbleToPayByDateComplete]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAbleToPayByDateComplete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportAbleToPayByDateComplete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAbleToPayByDateComplete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportAbleToPayByDateComplete]
@StartDate datetime,
@EndDate datetime,
@ClinicianId int
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportAbleToPayByDateComplete  
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: Able To Pay report 
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 01.29.2007  SFarber     Created.      
--
*********************************************************************************/
as

select c.ClientId, 
       c.LastName + '', '' + c.FirstName as ClientName,
       st.StaffId as ClinicianId,
       st.LastName + '', '' + st.FirstName as ClinicianName,
       s.ServiceId,
       p.ProgramCode,
       s.DateOfService,
       pc.ProcedureCodeName,       
       s.Unit,
       gcut.CodeName as UnitType,
       ch.CreatedDate as CompletedDate
  from Services s
       join Clients c on c.ClientId = s.ClientId
       join Staff st on st.StaffId = s.ClinicianId
       join Charges ch on ch.ServiceId = s.ServiceId
       join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
       join Programs p on p.ProgramId = s.ProgramId
       join GlobalCodes gcut on gcut.GlobalCodeId = s.UnitType
 where s.Status = 75 -- Complete
   and s.DateOfService >= ''11/1/2004''
   and ch.CreatedDate >= @StartDate
   and ch.CreatedDate < dateadd(dd, 1, @EndDate)
   and s.Billable = ''Y''
   and isnull(s.RecordDeleted, ''N'') = ''N''
   and isnull(ch.RecordDeleted, ''N'') = ''N''
   and s.ClinicianId = @ClinicianId
   and not exists(select *
                    from Charges ch2
                   where ch2.ServiceId = s.ServiceId
                     and isnull(ch2.RecordDeleted, ''N'') = ''N''
                     and ch2.ChargeId < ch.ChargeId)
 order by pc.ProcedureCodeName,       
          ClientName,
          c.ClientId,
          s.DateOfService

return
' 
END
GO
