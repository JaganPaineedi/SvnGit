/****** Object:  StoredProcedure [dbo].[csp_ServiceNoteLocationIdSharedTable]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteLocationIdSharedTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ServiceNoteLocationIdSharedTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteLocationIdSharedTable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[csp_ServiceNoteLocationIdSharedTable]
as

  select -1 AS AttendingId, '''' AS AttendingName      
  ,-1 AS ProgramId,'''' AS ProgramName,      
  LocationId AS LocationId,LocationName AS LocationName       
  ,-1 AS ProcedureCodeId, '''' AS ProcedureCodeName      
  ,-1 AS ClinicianId, '''' AS ClinicianName       
from Locations
where isnull(RecordDeleted,''N'') = ''N''
and Active = ''Y''

' 
END
GO
