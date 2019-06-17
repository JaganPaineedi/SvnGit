/****** Object:  StoredProcedure [dbo].[csp_ReportClinicianCaseloadStaffSelect]    Script Date: 04/18/2013 11:59:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianCaseloadStaffSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClinicianCaseloadStaffSelect]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportClinicianCaseloadStaffSelect]    Script Date: 04/18/2013 11:59:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE   Procedure [dbo].[csp_ReportClinicianCaseloadStaffSelect]
AS

select null as 'dataValue','<All>' as 'displayValue'
union
select StaffId as 'dataValue',LastName+', '+FirstName as 'displayValue' from Staff a
where isnull(a.Active,'N') = 'Y' and isnull(a.Clinician,'N') = 'Y' and isnull(a.RecordDeleted,'N')= 'N'
and a.Staffid not in (123,12,16,30,52,53,54,56,57)
order by displayvalue
--Remove Non-Clinician Clinicians
--and staffId not in (92,93,94,131,135)



















GO

