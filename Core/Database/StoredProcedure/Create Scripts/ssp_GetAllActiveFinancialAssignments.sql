
/****** Object:  StoredProcedure [dbo].[ssp_GetAllActiveFinancialAssignments]    Script Date: 05/07/2017 16:14:52 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetAllActiveFinancialAssignments]')
  AND TYPE IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_GetAllActiveFinancialAssignments]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAllActiveFinancialAssignments]    Script Date: 05/07/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetAllActiveFinancialAssignments]
AS
-- =============================================
-- Author:		Ajay 
-- Create date: 05/07/2017
-- Description:	To get all Active Financial Assignments.AHN-Customization: #44
--Modified By   Date          Reason 	
-- =============================================
BEGIN TRY
  ---------FinancialAssignments	           
  SELECT
    FinancialAssignmentId,
    AssignmentName,
    RevenueWorkQueueManagement
  FROM FinancialAssignments
  WHERE ISNULL(Active, 'N') <> 'N'
  AND ISNULL(RecordDeleted, 'N') = 'N'
  ORDER BY AssignmentName


END TRY
BEGIN CATCH
  DECLARE @Error varchar(8000)

  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetAllActiveFinancialAssignments') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

  RAISERROR (
  @Error
  ,-- Message text.                                    
  16
  ,-- Severity.                                    
  1 -- State.                                    
  );
END CATCH
GO