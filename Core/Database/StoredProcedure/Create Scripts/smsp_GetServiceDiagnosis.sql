/****** Object:  StoredProcedure [dbo].[smsp_GetServiceDiagnosis]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetServiceDiagnosis]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetServiceDiagnosis]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetServiceDiagnosis]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetServiceDiagnosis] @ServiceId INT
	,@JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Get Service Diagnosis information  
/*      
 Author			Modified Date			Reason      
 DECLARE @JSONResult VARCHAR(MAX)
 EXEC [smsp_GetServiceDiagnosis] 2960,@JsonResult OUTPUT
 SELECT @JsonResult
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT (
							SELECT ServiceDiagnosisId
								,CreatedBy
								,CreatedDate
								,ModifiedBy
								,ModifiedDate
								,RecordDeleted
								,DeletedDate
								,DeletedBy
								,ServiceId
								,DSMCode
								,DSMNumber
								,DSMVCodeId
								,ICD10Code
								,ICD9Code
								,[Order]
								,[Description]
							FROM (
								SELECT SD.ServiceDiagnosisId
									,SD.CreatedBy
									,SD.CreatedDate
									,SD.ModifiedBy
									,SD.ModifiedDate
									,SD.RecordDeleted
									,SD.DeletedDate
									,SD.DeletedBy
									,SD.ServiceId
									,SD.DSMCode
									,SD.DSMNumber
									,SD.DSMVCodeId
									,SD.ICD10Code
									,SD.ICD9Code
									,SD.[Order]
									,DD.ICDDescription AS 'Description'
								FROM ServiceDiagnosis SD
								JOIN Services AS s ON SD.ServiceId = s.ServiceId
								JOIN DiagnosisICD10Codes DD ON SD.DSMVCodeId = DD.ICD10CodeId
									AND SD.ICD10Code = DD.ICD10Code
								WHERE SD.DSMNumber IS NULL
									AND ISNULL(SD.RecordDeleted, 'N') = 'N'
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND SD.ServiceId = @ServiceId
								
								UNION
								
								SELECT SD.ServiceDiagnosisId
									,SD.CreatedBy
									,SD.CreatedDate
									,SD.ModifiedBy
									,SD.ModifiedDate
									,SD.RecordDeleted
									,SD.DeletedDate
									,SD.DeletedBy
									,SD.ServiceId
									,SD.DSMCode
									,SD.DSMNumber
									,SD.DSMVCodeId
									,SD.ICD10Code
									,SD.ICD9Code
									,SD.[Order]
									,DD.DSMDescription AS 'Description'
								FROM ServiceDiagnosis SD
								JOIN Services AS s ON SD.ServiceId = s.ServiceId
								JOIN DiagnosisDSMDescriptions DD ON SD.DSMCode = DD.DSMCode
									AND SD.DSMNumber = DD.DSMNumber
								WHERE SD.DSMVCodeId IS NULL
									AND ISNULL(SD.RecordDeleted, 'N') = 'N'
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND SD.ServiceId = @ServiceId
								
								UNION
								
								SELECT SD.ServiceDiagnosisId
									,SD.CreatedBy
									,SD.CreatedDate
									,SD.ModifiedBy
									,SD.ModifiedDate
									,SD.RecordDeleted
									,SD.DeletedDate
									,SD.DeletedBy
									,SD.ServiceId
									,SD.DSMCode
									,SD.DSMNumber
									,SD.DSMVCodeId
									,SD.ICD10Code
									,SD.ICD9Code
									,SD.[Order]
									,DD.ICDDescription AS 'Description'
								FROM ServiceDiagnosis SD
								JOIN Services AS s ON SD.ServiceId = s.ServiceId
								JOIN DiagnosisICDCodes DD ON SD.DSMCode = DD.ICDCode
								WHERE SD.DSMNumber IS NULL
									AND SD.DSMVCodeId IS NULL
									AND ISNULL(SD.RecordDeleted, 'N') = 'N'
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND SD.ServiceId = @ServiceId
								) A
							FOR XML path
								,root
							)
					))
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetServiceDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


