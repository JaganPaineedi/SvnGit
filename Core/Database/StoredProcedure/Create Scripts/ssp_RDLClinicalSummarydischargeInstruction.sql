/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummarydischargeInstruction]    Script Date: 06/09/2015 04:09:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummarydischargeInstruction]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummarydischargeInstruction] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
	/******************************************************************************                      
  **  File: ssp_RDLClinicalSummarydischargeInstruction.sql    
  **  Name: ssp_RDLClinicalSummarydischargeInstruction    
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
  **  Date:  Oct 28 2014    
  *******************************************************************************                      
  **  Change History                      
  *******************************************************************************                      
  **  Date:  Author:    Description:                      
  **  --------  --------    -------------------------------------------     
  **  Oct 28 2014    Veena S Mani      Created            
  *******************************************************************************/
	BEGIN TRY

		
Select Q.AnswerText from clientorderQnAnswers Q join clientorders CO
on Q.ClientOrderid=CO.ClientOrderid join Documents D on D.inprogressdocumentversionid = CO.documentversionid

where co.Clientid =@ClientId and orderid=(SELECT integercodeid
FROM dbo.Ssf_recodevaluescurrent(''SCDISCHARGEINSTRUCTION'')) and d.status=22


	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''csp_SCGetCurrentMedicationlist'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                      
				16
				,-- Severity.                                                                                                      
				1 -- State.                                                                                                      
				);
	END CATCH
END

' 
END
GO
