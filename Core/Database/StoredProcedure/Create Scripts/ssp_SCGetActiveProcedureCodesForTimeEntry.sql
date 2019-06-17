
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'SSP_SCGETACTIVEPROCEDURECODESFORTIMEENTRY')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE SSP_SCGETACTIVEPROCEDURECODESFORTIMEENTRY;
    END;
                    GO
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [DBO].[SSP_SCGETACTIVEPROCEDURECODESFORTIMEENTRY]
	@TeamId INT
AS
/**************************************************************
* Stored Procedure: [ssp_SCGetActiveProcedureCodesForTimeEntry]   
* Creation Date:  03 -18 -2015                              
* Purpose: To Get Services Data   for Time Entry Screen 
* Called By: Time Entry Screen screen     
* Updates:                                                   
*	Date		Author			Purpose         
*	03/18/2015  Dhanil Manuel	Created		To get Time Service Entry Data  For ARC Customization Task #1 
*	04/20/2017	jcarlson		Keystone Customizations 55 - Modified Logic to handle ProgramProcedure Updates
*	01/19/2018	jcarlson		Urgent ARC Task 320 - Removed unneeded union statement and duplicate record deleted check
*************************************************************/
BEGIN
BEGIN TRY
	SELECT 
	pc.ProcedureCodeId
	, pc.DisplayAs AS ProcedureCodeName
	FROM ProcedureCodes AS pc
	WHERE ISNULL(pc.RecordDeleted,'N')='N'
	AND pc.Active = 'Y'
	AND ISNULL(pc.GroupCode,'N')<>'Y' 
	AND EXISTS ( SELECT 1
				 FROM ProgramProcedures AS pp
				 WHERE ISNULL(pp.RecordDeleted,'N')='N'
				 AND pp.ProgramId = @TeamId
				 AND ( pp.StartDate <= CONVERT(DATE,GETDATE()) OR pp.StartDate IS NULL )
				 AND ( pp.EndDate >= CONVERT(DATE,GETDATE()) OR pp.EndDate IS NULL )
				 AND pp.ProcedureCodeId = pc.ProcedureCodeId
				)
	order by DisplayAs

	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetActiveProcedureCodesForTimeEntry') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.         
				16
				,-- Severity.         
				1 -- State.                                                           
				);
	END CATCH
END

GO

