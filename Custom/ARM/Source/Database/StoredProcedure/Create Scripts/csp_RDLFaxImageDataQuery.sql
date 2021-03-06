/****** Object:  StoredProcedure [dbo].[csp_RDLFaxImageDataQuery]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLFaxImageDataQuery]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLFaxImageDataQuery]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLFaxImageDataQuery]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_RDLFaxImageDataQuery]
@Startdate datetime, @EndDate datetime, @Id int

as

/*
ModifiedBy	ModifiedDate	Purpose
avoss		11/19/2009		View Faxed Data for scripts for troubleshooting
*/
SELECT c.ClientMedicationScriptId, ca.FaxImageData
from ClientMedicationScripts c
join ClientMedicationScriptActivities ca on ca.ClientMedicationScriptId = c.ClientMedicationScriptId
where c.CreatedDate > @StartDate
and c.CreatedDate < @EndDate
and ( c.ClientMedicationScriptId = @Id or @Id is null )
and ca.Method=''F''
' 
END
GO
