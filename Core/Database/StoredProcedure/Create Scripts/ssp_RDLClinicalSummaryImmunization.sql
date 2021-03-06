
/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryImmunization]    Script Date: 06/11/2015 17:37:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryImmunization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryImmunization]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryImmunization]    Script Date: 06/11/2015 17:37:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_RDLClinicalSummaryImmunization] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
	/******************************************************************************                        
  **  File: ssp_RDLClinicalSummaryImmunization.sql      
  **  Name: ssp_RDLClinicalSummaryImmunization      
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
  **  Date:   Author:    Description:                        
  **  --------  --------   -------------------------------------------           
  **  02/05/2014 Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18   
  **  019/05/2014 Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.             
  **  16/07/2014 Veena S Mani        Added Distinct   
  **  03/09/2014 Revathi    what:call ssf_GetGlobalCodeNameById instead of csf_GetGlobalCodeNameById  
          why:task#36 MeaningfulUse 
   **  03/09/2015  Revathi			what: Get  CVXCode
									why:	task#18 Post Certification                        
  *******************************************************************************/
	BEGIN TRY
		DECLARE @DOS DATETIME = NULL
		DECLARE @DocumentCodeId INT

		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
		END
		ELSE IF (
				@ServiceId IS NULL
				AND @DocumentVersionId IS NOT NULL
				)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
				,@DocumentCodeId = DocumentCodeId
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END

		IF (@DocumentCodeId = 1611)
			SET @DOS = NULL

		SELECT DISTINCT dbo.ssf_GetGlobalCodeNameById(CI.VaccineNameId) AS Vaccine
			,CONVERT(VARCHAR(10), CI.AdministeredDateTime, 101) AS AdministratedDateTime
			,CONVERT(VARCHAR(100), CI.AdministeredAmount) + ' ' + dbo.ssf_GetGlobalCodeNameById(CI.AdministedAmountType) AS AdministeredAmount
			,dbo.ssf_GetGlobalCodeNameById(CI.ManufacturerId) AS Manufacture
			,dbo.ssf_GetGlobalCodeNameById(CI.VaccineStatus) AS STATUS
			,comment
			--,dbo.csf_GetGlobalCodeExternalCode1ById(VaccineNameId) AS CVXCode
			,GC.ExternalCode1 as CVXCode
		FROM ClientImmunizations CI
		LEFT  JOIN GlobalCodes GC ON GC.GlobalCodeId=CI.VaccineNameId 	AND ISNULL(GC.RecordDeleted, 'N') = 'N'  
		WHERE CI.ClientId = @ClientId
			AND ISNULL(CI.RecordDeleted, 'N') = 'N'
			--AND (@DOS IS NULL OR (CAST(AdministeredDateTime AS DATE) = CAST(@DOS AS DATE)))  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryImmunization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


