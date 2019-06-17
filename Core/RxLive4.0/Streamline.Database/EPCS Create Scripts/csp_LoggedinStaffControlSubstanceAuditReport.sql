/****** Object:  StoredProcedure [dbo].[csp_LoggedinStaffControlSubstanceAuditReport]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_LoggedinStaffControlSubstanceAuditReport]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_LoggedinStaffControlSubstanceAuditReport];
GO

/****** Object:  StoredProcedure [dbo].[csp_LoggedinStaffControlSubstanceAuditReport]    ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[csp_LoggedinStaffControlSubstanceAuditReport] 

AS

/******************************************************************************
* Creation Date:  6/DEC/2016
*
* Purpose: Gather data for Control Substance Audit Report - EPCS #32
* 
* Customer: EPCS
*
* Called By: Control Substance Audit Report
*
* Calls:
*
* Dependent Upon:
*
* Depends upon this: Report Days to Service
*
* Modifications:
* Date			Author			Purpose
* 
*
*****************************************************************************/
SET NOCOUNT ON;

  SELECT TOP 1 re.StaffId , s.Lastname +  '  ' + s.Firstname as Staffname
  from ReportExecutionLog re
  join Reports r  on re.ReportId=r.ReportId
  join Staff s on s.StaffId = re.StaffId
  Where re.ReportId= (select top 1 ReportId
   from Reports
   where Name='Control Substance Audit Report')
  order by re.CreatedDate desc

