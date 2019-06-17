
/****** Object:  StoredProcedure [dbo].[csp_ServiceNoteClinicianIdSharedTable]    Script Date: 12/24/2013 10:32:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteClinicianIdSharedTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ServiceNoteClinicianIdSharedTable]
GO

/****** Object:  StoredProcedure [dbo].[csp_ServiceNoteClinicianIdSharedTable]    Script Date: 12/24/2013 10:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE proc [dbo].[csp_ServiceNoteClinicianIdSharedTable]  
as  
/********************************************************************/     
/*   Updates:                                                       */                                                                                    
/*   Date               Author    Purpose                           */                                                                                    
/*   24/Dec/2013        Manju P   Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes */                     
/*   27 Dec 2013        Manju P   Modified to add orderby clause as StaffName. What/Why: Task: Core Bugs #1315 Staff Detail Changes  */
/********************************************************************/     
    
  select -1 AS AttendingId, '' AS AttendingName        
  ,-1 AS ProgramId,'' AS ProgramName,        
  -1 AS LocationId,'' AS LocationName         
  ,-1 AS ProcedureCodeId, '' AS ProcedureCodeName        
  ,StaffId AS ClinicianId, DisplayAs AS ClinicianName         
from Staff  
where isnull(RecordDeleted,'N') = 'N'  
and Active = 'Y'  
order by DisplayAs, StaffId   