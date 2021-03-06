/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryFutureOrdersTests]    Script Date: 06/09/2015 04:09:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryFutureOrdersTests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryFutureOrdersTests] 
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
AS
/******************************************************************************                    
**  File: ssp_RDLClinicalSummaryFutureOrdersTests.sql  
**  Name: ssp_RDLClinicalSummaryFutureOrdersTests  
**  Desc:   
**                    
**  Return values: <Return Values>                   
**                     
**  Called by: <Code file that calls>                      
**                                  
**  Parameters:                    
**  Input   Output                    
**  ServiceId      -----------                    
**                    
**  Created By: Veena S Mani
**  Date:  Feb 25 2014  
*******************************************************************************                    
**  Change History                    
*******************************************************************************                    
**  Date:		Author:				Description:                    
**  --------	--------			-------------------------------------------   
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18    
**  21/05/2014   Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.        
**  02/09/2014   Revathi			 What:Get Order Physician Name Instead of ID and Check RecordDeleted
									 Why: #36 MeaningfulUse    
                 
*******************************************************************************/

BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @DOS DATETIME = NULL

		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
		END
		ELSE IF (@ServiceId IS NULL	AND @DocumentVersionId IS NOT NULL)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''n''
		END

		SELECT CONVERT(VARCHAR(10),d.EffectiveDate, 101) AS OrderDate
			,OS.OrderName
			,S.LastName + '', '' + S.FirstName AS OrderingPhysician
			,PR.BillingCode AS CPT
			,HD.LoincCode AS LOINC
		FROM ClientOrders CO
		INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
		INNER JOIN documents d ON CO.DocumentId = d.DocumentId
		LEFT JOIN HealthDataTemplates HD ON HD.HealthDataTemplateId = OS.LabId
		LEFT JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = OS.ProcedureCodeId
		LEFT JOIN ProcedureRates PR ON pr.ProcedureCodeId = pc.ProcedureCodeId
		LEFT JOIN Staff S ON S.StaffId=CO.OrderingPhysician AND ISNULL(S.RecordDeleted,''N'')=''N''
		WHERE CO.ClientId = @ClientId
			AND ISNULL(CO.ReviewedFlag, ''N'') <> ''Y''
			AND OS.OrderType IN (
				6481
				,6482
				)
			AND d.STATUS = 22
			AND CAST(d.EffectiveDate AS DATE) = CAST(@DOS AS DATE)
			AND ISNULL(CO.RecordDeleted,''N'')=''N''
			AND ISNULL(CO.OrderStartOther,''N'')=''Y'' AND CAST(CO.OrderStartDateTime AS DATE) > CAST(@DOS AS DATE)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_RDLClinicalSummaryFutureOrdersTests'') + ''*****'' 
		+ CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' 
		+ CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' 
		+ CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                  
				16
				,-- Severity.                                                        
				1 -- State.                                                     
				);
	END CATCH
END' 
END
GO
