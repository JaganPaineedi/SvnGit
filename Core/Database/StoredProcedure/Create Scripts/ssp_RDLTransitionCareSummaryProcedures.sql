
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryProcedures]    Script Date: 06/09/2015 05:24:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLTransitionCareSummaryProcedures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryProcedures]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryProcedures]    Script Date: 06/09/2015 05:24:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************                      
**  File: ssp_RDLTransitionCareSummaryProcedures.sql    
**  Name: ssp_RDLTransitionCareSummaryProcedures    
**  Desc:     
**                      
**  Return values: <Return Values>                     
**                       
**  Called by: <Code file that calls>                        
**                                    
**  Parameters:                      
**  Input   Output                      
**  ClientId      -----------                      
**                      
**  Created By: Veena S Mani   
**  Date:  Apr 23 2014    
*******************************************************************************                      
**  Change History                      
*******************************************************************************                      
**  Date:  Author:    Description:                      
**  --------  --------    -------------------------------------------    
    19/05/14  Veena S Mani   Created                  
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryProcedures] @ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT S.Procedurecodeid
			,pc.ProcedureCodeName AS Description
			,max(S.DateofService) AS DOS
			,count(S.Procedurecodeid) AS count
		FROM dbo.Services AS s
		INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId
		WHERE s.Clientid = @ClientId
			AND CAST(S.DateofService AS DATE) <= CAST(Getdate() AS DATE)
			AND CAST(S.DateofService AS DATE) >= DATEADD(mm, - 12, CAST(Getdate() AS DATE)) and Isnull(S.RecordDeleted,'N')<>'Y' AND Isnull(pc.RecordDeleted,'N')<>'Y'
		GROUP BY S.Procedurecodeid
			,pc.ProcedureCodeName
	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLTransitionCareSummaryProcedures') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

