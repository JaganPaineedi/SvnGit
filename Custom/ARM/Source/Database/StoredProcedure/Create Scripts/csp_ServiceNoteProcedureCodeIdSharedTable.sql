/****** Object:  StoredProcedure [dbo].[csp_ServiceNoteProcedureCodeIdSharedTable]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteProcedureCodeIdSharedTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ServiceNoteProcedureCodeIdSharedTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteProcedureCodeIdSharedTable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
  
CREATE proc [dbo].[csp_ServiceNoteProcedureCodeIdSharedTable]  
as  
  
  select -1 AS AttendingId, '''' AS AttendingName        
  ,-1 AS ProgramId,'''' AS ProgramName,        
  -1 AS LocationId,'''' AS LocationName         
  ,ProcedureCodeId AS ProcedureCodeId, ProcedureCodeName AS ProcedureCodeName        
  ,-1 AS ClinicianId, '''' AS ClinicianName         
from ProcedureCodes  
where isnull(RecordDeleted,''N'') = ''N''  
and Active = ''Y''  
  
' 
END
GO
