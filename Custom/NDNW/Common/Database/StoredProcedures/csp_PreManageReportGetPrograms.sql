IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'csp_PreManageReportGetPrograms')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE csp_PreManageReportGetPrograms
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Mark Jensen  
-- Create date: 23 MAR 2018 
-- Description: Get active programs for PreManage Care Report  
-- NDNW Enahancements Task #2
--	
-- =============================================  
CREATE PROCEDURE csp_PreManageReportGetPrograms
AS
SELECT Programs.ProgramName
	,Programs.ProgramId
FROM Programs
WHERE Active = 'y'
	AND ISNULL(Programs.RecordDeleted, 'N') = 'N'
ORDER BY 1
GO

