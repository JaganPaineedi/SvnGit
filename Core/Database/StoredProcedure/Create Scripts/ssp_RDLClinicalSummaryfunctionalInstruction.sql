/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryfunctionalInstruction]    Script Date: 06/19/2015 10:15:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryfunctionalInstruction]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryfunctionalInstruction]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryfunctionalInstruction]    Script Date: 06/19/2015 10:15:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryfunctionalInstruction] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
	/******************************************************************************                      
  **  File: ssp_RDLClinicalSummaryfunctionalInstruction.sql    
  **  Name: ssp_RDLClinicalSummaryfunctionalInstruction    
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
		/*
		
Select co.clientid,orderid, Q.AnswerText + ' - ' + convert(varchar(23),CO.OrderStartDateTime, 110)+ ' (Active)' As FunctionalStatus from clientorderQnAnswers Q join clientorders CO  
on Q.ClientOrderid=CO.ClientOrderid join Documents D on D.inprogressdocumentversionid = CO.documentversionid  
  
where co.Clientid =@ClientId and orderid=(SELECT integercodeid
FROM dbo.Ssf_recodevaluescurrent('SCFUNCTIONALINSTRUCTION')) and d.status=22 and CO.OrderStatus<>6508
DocumentDiagnosis
*/
		DECLARE @LatestDiagnosesDocumentVersionID INT
		DECLARE @EffectiveDate DATETIME
		DECLARE @DiagnosisDocumentVersionId INT

		SET @DiagnosisDocumentVersionId = (
				SELECT TOP 1 InProgressDocumentVersionId
				FROM Documents
				WHERE DocumentCodeId = 1601
					AND ClientId = @ClientId
					AND ISNULL(RecordDeleted, 'N') = 'N' AND STATUS = 22
				ORDER BY EffectiveDate DESC
				)

		SELECT - 1 AS clientid
			,- 1 AS orderid
			,'GAF Score: ' + ISNULL(cast(GAFScore AS VARCHAR),'') +
			 ', WHODAS Score: ' + ISNULL(cast(WHODASScore AS VARCHAR),'') +
			 ', CAFAS Score: ' + ISNULL(cast(CAFASScore AS VARCHAR),'') AS FunctionalStatus
		FROM DocumentDiagnosis
		WHERE DocumentVersionId = @DiagnosisDocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCurrentMedicationlist') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

