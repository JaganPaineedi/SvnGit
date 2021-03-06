/****** Object:  StoredProcedure [dbo].[csp_ReportStaffSupervisorChanges_View]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportStaffSupervisorChanges_View]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportStaffSupervisorChanges_View]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportStaffSupervisorChanges_View]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_ReportStaffSupervisorChanges_View]
(
	 @StaffId int
)

/********************************************************************************
-- Stored Procedure: csp_ReportStaffSupervisorChanges_View  
--
-- Copyright: 2013 Harbor 
--
-- Purpose: Modified from csp_ReportStaffSupervisorChanges by avoss. Allows staff to view staff under a supervisor and supervisors assigned to staff.
--
-- Updates:                     		                                
-- Date			Author		Purpose
-- 01.25.2013	Ryan Mapes  Created per WO 26937
-- 01.30.2013               Updated Order By to List GroupName desc
*********************************************************************************/

as


declare @Message varchar(max)

--Report Datasets
select
	 sup.LastName + '', '' + sup.FirstName as Supervisor 
	,s.LastName + '', '' + s.FirstName as Staff
	,1 as GroupId
	,''Supervisor''''s Staff'' as GroupName
	,@Message as Message
from staffSupervisors ss
join staff s on s.StaffId = ss.StaffId
join staff sup on sup.StaffId = ss.SupervisorId
where ss.SupervisorId = @StaffId
and isnull(ss.RecordDeleted,''N'')<>''Y''
--and s.StaffId = @StaffId
Union All
select 
	 sup.LastName + '', '' + sup.FirstName as Supervisor
	,s.LastName + '', '' + s.FirstName as Staff
	,2 as GroupId
	,''Supervisors assigned to Staff'' as GroupName
	,@Message as Message
from staffSupervisors ss
join staff sup on sup.StaffId = ss.SupervisorId
cross join staff s 
where ss.StaffId = @StaffId
and isnull(ss.RecordDeleted,''N'')<>''Y''
and s.StaffId = @StaffId
order by GroupName desc, Supervisor,Staff

' 
END
GO
