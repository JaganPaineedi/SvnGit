IF OBJECT_ID('csp_ReportGetStaffList', 'P') IS NOT NULL
	DROP PROC csp_ReportGetStaffList
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*	Get Selection List of Staff for Reports		*/
/*	ARM Enhancements #21						*/
/*	10/27/2017	MJensen		Created				*/
CREATE PROCEDURE [dbo].[csp_ReportGetStaffList]
AS
SELECT DISTINCT s.StaffId
	,ISNULL(s.lastname, '') + ', ' + s.firstname AS StaffName
FROM Staff s
WHERE ISNULL(s.RecordDeleted, 'N') = 'N'

UNION

SELECT NULL
	,' All Staff'
ORDER BY ISNULL(s.lastname, '') + ', ' + s.firstname
GO

