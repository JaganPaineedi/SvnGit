/****** Object:  StoredProcedure [dbo].[csp_GetClinicianStaffIds]    Script Date: 04/18/2013 09:52:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetClinicianStaffIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetClinicianStaffIds]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetClinicianStaffIds]    Script Date: 04/18/2013 09:52:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE PROCEDURE [dbo].[csp_GetClinicianStaffIds]
as

Select LastName+', '+FirstName,StaffId from staff where
active = 'Y' and isnull(recordDeleted,'N') <> 'Y'
and clinician = 'Y'
Union
select 'All Staff'as LastName,null
order by 1












GO

