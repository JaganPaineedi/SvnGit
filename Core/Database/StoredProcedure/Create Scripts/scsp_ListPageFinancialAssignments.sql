IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageFinancialAssignments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[scsp_ListPageFinancialAssignments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_ListPageFinancialAssignments]
     @StaffId INT
	,@Status INT
	,@PayerType INT
	,@PayerId INT
	,@ProcedureCodeId INT	
	,@AssignmentType INT
	,@CoveragePlanId INT
	,@ErrorReason INT
	,@ProgramId INT
	,@ServiceAreaId INT
	,@LocationId INT
	,@DenialReason INT
	,@AssignmentName Varchar(250)
	,@OtherFilter INT
/********************************************************************************      
-- Stored Procedure: dbo.scsp_ListPageFinancialAssignments        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date			Author		Purpose      
-- 25-mar-2015  Veena		What:called in csp_ListPageFinancialAssignments
--							Why:task #950 Valley - Customization  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY

  SELECT NULL as FinancialAssignmentId
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'csp_ListPageSCPRPRRPOutreach')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
GO