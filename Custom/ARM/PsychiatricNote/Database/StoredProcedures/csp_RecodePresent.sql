IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RecodePresent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RecodePresent] --949
GO

CREATE PROCEDURE [dbo].[csp_RecodePresent] 
@ProcedureCodeId INT 
AS
/*********************************************************************/
/* Stored Procedure: [csp_RecodePresent]   */
/*       Date              Author                  Purpose          */
/*       14/07/2015        Vijay              What:SubReport for Psychiatric Note AIMS tab   */
/* 												  Why:task #329 Woods-Customizations    */
/*********************************************************************/
BEGIN
	BEGIN TRY

	Select * From ProcedureCodes as pc inner join Recodes as re
  on pc.ProcedureCodeId=re.IntegerCodeId
  inner join recodecategories as rec on rec.RecodeCategoryId=re.RecodeCategoryId
  where rec.CategoryCode='XPSYCHIATRICNOTEPRESENTINGPROBLEM' and ProcedureCodeId=@ProcedureCodeId
		
		
	END TRY
	BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RecodePresent') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	
	END CATCH
END
	
	