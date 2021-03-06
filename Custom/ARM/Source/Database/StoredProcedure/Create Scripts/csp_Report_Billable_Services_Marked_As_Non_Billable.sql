/****** Object:  StoredProcedure [dbo].[csp_Report_Billable_Services_Marked_As_Non_Billable]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Billable_Services_Marked_As_Non_Billable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Billable_Services_Marked_As_Non_Billable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Billable_Services_Marked_As_Non_Billable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE [dbo].[csp_Report_Billable_Services_Marked_As_Non_Billable] 
	-- Add the parameters for the stored procedure here
	@start_date datetime,
    @end_date datetime
AS
--*/

/*
DECLARE @start_date datetime,
	    @end_date datetime

SELECT	@start_date = ''04/17/12'',
		@end_date = ''04/17/12''
--*/	

SET NOCOUNT ON;	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/********************************************************************************************/
/* Stored Procedure: csp_non_billable														*/
/* Creation Date:    12/12/2001																*/
/* Copyright: Harbor Behavioral Healthcare													*/
/*																							*/
/* Updates:																					*/
/*   Date       Author      Purpose															*/
/* 12/18/2001 li Qin     Created															*/
/* 6/13/2003  li replace clinical_transaction with patient_clin_tran and group_clin_tran	*/
/* 6/14/2012  Brian M    Coverted from Psychconsult											*/
/********************************************************************************************/

SELECT SS.ClientId, 
       S.LastName + '', '' + S.FirstName AS STAFF,
       C.LastName + '', '' + C.FirstName AS Client,
       PC.DisplayAs AS ''Procedure Code'', 
       PC.ProcedureCodeName AS ''Procedure Name'',
	   DATEDIFF(MI,SS.DateOfService,SS.EndDateOfService) AS ''Proc_Duration'', 
       SS.DateOfService,
       SS.ClinicianId, 
       SS.Billable	  AS ''CT_billable'', 
       PC.NotBillable AS ''Proc_NOTbillable''
FROM  Services SS 
	JOIN ProcedureCodes PC 
		ON (PC.ProcedureCodeId = SS.ProcedureCodeId 
		AND (PC.DisplayAs NOT LIKE ''EAP%'' 
		AND PC.DisplayAs  NOT LIKE ''PUBLIC%'')
	 	AND PC.NotBillable = ''N''
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')
	JOIN Clients C
		ON (C.ClientId = SS.ClientId
		AND ISNULL(C.RecordDeleted,''N'')<>''Y'') 
	JOIN Staff S 
		ON (S.StaffId = SS.ClinicianId
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
WHERE SS.Billable = ''N'' 
	  AND SS.DateOfService >= @start_date
      AND SS.DateOfService < DATEADD(day,1,@end_date)
--      AND SS.Status = ''75''  --''CO''      
      AND ISNULL(SS.RecordDeleted,''N'')<>''Y''
' 
END
GO
