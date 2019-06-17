USE [40DemoSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLAccountingPeriodParameter]    Script Date: 1/30/2017 3:37:18 PM ******/
DROP PROCEDURE [dbo].[ssp_RDLAccountingPeriodParameter]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLAccountingPeriodParameter]    Script Date: 1/30/2017 3:37:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_RDLAccountingPeriodParameter]
AS
	--
	-- Use to get list of accounting periods.  Indicate whether accounting period is closed.
	--

	SELECT EndDate                                                           
	,      LTRIM(RTRIM(Description)) + CASE WHEN OpenPeriod = 'N' THEN ' (closed)'
	                                                              ELSE '' END AS AccountingPeriod
	FROM AccountingPeriods
	WHERE ISNULL(RecordDeleted, 'N') = 'N'
	ORDER BY 1;

GO


