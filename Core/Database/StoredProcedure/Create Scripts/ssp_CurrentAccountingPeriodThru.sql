USE [40DemoSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CurrentAccountingPeriod_thru]    Script Date: 1/30/2017 3:38:27 PM ******/
DROP PROCEDURE [dbo].[ssp_CurrentAccountingPeriod_thru]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CurrentAccountingPeriod_thru]    Script Date: 1/30/2017 3:38:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_CurrentAccountingPeriod_thru]
AS
	--
	-- Use to get the current accounting period thru date
	--

	SELECT MIN(EndDate) AS thruCurrentAccountingPeriod
	FROM AccountingPeriods 
	WHERE ISNULL(RecordDeleted, 'N') = 'N'
		AND DATEDIFF(DAY, GETDATE(), EndDate) >= 0;




GO


