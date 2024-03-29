/****** Object:  StoredProcedure [dbo].[csp_PMClaimsSwitchRenderingStaff]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsSwitchRenderingStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaimsSwitchRenderingStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsSwitchRenderingStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_PMClaimsSwitchRenderingStaff]
AS
BEGIN TRAN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE a SET
	  ClinicianId = ISNULL(b.BillingStaffId,a.ClinicianId)
	, ClinicianLastName = ISNULL(c.LastName,a.ClinicianLastName)
	, ClinicianFirstName = ISNULL(c.FirstName,a.ClinicianFirstName)
FROM #Charges a
JOIN CustomBillingStaffRenderingStaff b ON b.RenderingStaffId = a.ClinicianId
	AND ISNULL(b.RecordDeleted,''N'') <> ''Y''
LEFT JOIN Staff c ON c.StaffId = b.BillingStaffId
	AND ISNULL(c.RecordDeleted,''N'') <> ''Y''
WHERE a.DateofService > b.FromDate
	AND (b.ToDate IS NULL OR a.DateofService < b.Todate)

IF @@error = 0 COMMIT TRAN
ELSE ROLLBACK

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

' 
END
GO
