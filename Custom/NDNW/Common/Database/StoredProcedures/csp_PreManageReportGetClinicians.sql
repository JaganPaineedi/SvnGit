IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'csp_PreManageReportGetClinicians')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE csp_PreManageReportGetClinicians
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Mark Jensen  
-- Create date: 23 MAR 2018 
-- Description: Get active clinicians for PreManage Care Report  
-- NDNW Enahancements Task #2
--	
-- =============================================  
CREATE PROCEDURE csp_PreManageReportGetClinicians
AS
SELECT ISNULL(s.LastName,'') + ', ' + ISNULL(s.FirstName,'') + ' ' + ISNULL(S.MiddleName,'') AS ClinicianName
	,s.StaffId
FROM Staff s
WHERE Active = 'y'
	AND ISNULL(s.RecordDeleted, 'N') = 'N'
ORDER BY 1
GO

