IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ssp_RDLClinicalSummaryProceduresDuringVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Ssp_RDLClinicalSummaryProceduresDuringVisit]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Ssp_RDLClinicalSummaryProceduresDuringVisit] 
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
AS
/******************************************************************************                      
**  File: ssp_RDLClinicalSummaryProceduresDuringVisit.sql     
**  Name: ssp_RDLClinicalSummaryProceduresDuringVisit     
**  Desc:      
**                       
**  Return values:                       
**                        
**  Called by:                          
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
**  Date:  Author:    Description:                       
**  --------  --------    -------------------------------------------     
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18   
**  019/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.         
**  16/07/2014   Veena S Mani        Added Distinct 
                 
*******************************************************************************/

BEGIN
	BEGIN TRY
		--IF (@DocumentVersionId IS NOT NULL)
		--BEGIN
			DECLARE @EffectiveDate DATETIME

		IF (@ServiceId IS NOT NULL)
				BEGIN
					SELECT @EffectiveDate = DateOfService
					FROM Services
					WHERE ServiceId = @ServiceId
				END
				ELSE IF (@ServiceId IS NULL	AND @DocumentVersionId IS NOT NULL)
				BEGIN
			SET @EffectiveDate = (
					SELECT TOP 1 EffectiveDate
					FROM Documents
					WHERE CurrentDocumentVersionId = @DocumentVersionId 
					AND ISNULL(RecordDeleted,'N')='N'
					)
		END
		
			

			--SELECT DISTINCT PC.ProcedureCode AS Code
			--	,CONVERT(VARCHAR(12), CP.OrderDate, 107) AS OrderDate
			--	,PC.DisplayAs AS ProcedureCodeName
			--FROM ClientProcedures CP
			--LEFT JOIN PCProcedureCodes PC ON PC.PCProcedureCodeId = CP.ProcedureId
			--	AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			--	AND PC.Active = 'Y'
			--WHERE ISNULL(CP.RecordDeleted, 'N') = 'N'
			--	AND CP.ClientId = @ClientId
			--	AND (CAST(CP.OrderDate AS DATE) = CAST(@EffectiveDate AS DATE))
			--ORDER BY PC.ProcedureCode DESC
			
			SELECT DISTINCT  PC.ProcedureCodeName AS Code
				,CONVERT(VARCHAR(12), CO.OrderStartDateTime, 101) AS OrderDate
				,O.OrderName AS ProcedureCodeName
			FROM ClientOrders CO
			JOIN Orders O ON O.OrderId=CO.OrderId
			LEFT JOIN ProcedureCodes PC on O.ProcedureCodeId = PC.ProcedureCodeId		
			WHERE ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
				AND O.OrderType=8741
				AND Co.ClientId = @ClientId				
				AND (CAST(CO.OrderStartDateTime AS DATE) = CAST(@EffectiveDate AS DATE))
		--ORDER BY PC.ProcedureCode DESC
		--END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
		+ CONVERT(VARCHAR(4000), Error_message()) + '*****' 
		+ Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_RDLClinicalSummaryProceduresDuringVisit') + '*****' 
		+ CONVERT(VARCHAR, Error_line()) + '*****' 
		+ CONVERT(VARCHAR, Error_severity()) + '*****' 
		+ CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                    
				16
				,
				-- Severity.                                                           
				1
				-- State.                                                        
				);
	END CATCH
END