/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentPostSignatureServiceDiagnosisUpdate]    Script Date: 12/15/2015 10:04:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentPostSignatureServiceDiagnosisUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentPostSignatureServiceDiagnosisUpdate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentPostSignatureServiceDiagnosisUpdate]    Script Date: 12/15/2015 10:04:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCDocumentPostSignatureServiceDiagnosisUpdate] @CurrentUserId INT
	,@DocumentId INT
AS
/******************************************************************************                                              
**  Name: ssp_SCDocumentPostSignatureServiceDiagnosisUpdate
**  Desc:  Update ServiceDiagnosis on sign of Services
**  Return values:                                              
**  Called by: ssp_SCDocumentPostSignatureUpdates                                               
**  Parameters:                                              
**  Input @CurrentUserId,@DocumentId                           
**                                                            
**  Auth:  Akwinass                      
                                     
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:     Description:  
**  15-DEC-2015 Akwinass    Update ServiceDiagnosis Table on sign of Services (Task #272 in Engineering Improvement Initiatives- NBL(I)) 
**  16-DEC-2015 Akwinass	Included RuleOut Condition based on System Configuration Key 'INCLUDEBILLINGDIAGNOSISRULEOUT' (Task #384 in A Renewed Mind - Support)
**  17-DEC-2015 Akwinass    Included Billable Condition (Task #272 in Engineering Improvement Initiatives- NBL(I)) 
**  11-JUL-2017 Chris Love  Corrected a typo when marking ServiceDiagnosis as RecordDeleted (Task #395 in Texas Go Live Build Issues)
*******************************************************************************/
BEGIN
	BEGIN TRY
		IF (SELECT COUNT(SignatureId) FROM DocumentSignatures a WHERE a.DocumentId = @DocumentId AND a.SignatureDate IS NOT NULL AND ISNULL(RecordDeleted, 'N') = 'N') <= 1
		BEGIN
			DECLARE @DocumentCodeId INT
			DECLARE @DocumentVersionId INT
			DECLARE @ServiceId INT

			SELECT TOP 1 @DocumentCodeId = DocumentCodeId
				,@DocumentVersionId = CurrentDocumentVersionId
				,@ServiceId = ServiceId
			FROM Documents
			WHERE DocumentId = @DocumentId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF EXISTS (SELECT 1 FROM DocumentCodes WHERE DocumentCodeId = @DocumentCodeId AND ISNULL(RecordDeleted, 'N') = 'N' AND ISNULL(ServiceNote, 'N') = 'Y' AND ISNULL(DiagnosisDocument, 'N') = 'Y')
				AND EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'DISABLEBILLINGDXIFSERVICENOTEISDX' AND ISNULL(RecordDeleted, 'N') = 'N' AND ISNULL(Value, 'N') = 'Y')
				AND ISNULL(@ServiceId, 0) > 0
			BEGIN
				DECLARE @TableList VARCHAR(MAX)

				SELECT @TableList = TableList
				FROM DocumentCodes
				WHERE DocumentCodeId = @DocumentCodeId
					AND ISNULL(RecordDeleted, 'N') = 'N'

				IF EXISTS (SELECT * FROM dbo.fnSplit(@TableList, ',') WHERE item = 'DocumentDiagnosisCodes')
					OR EXISTS (SELECT * FROM dbo.fnSplit(@TableList, ',') WHERE item = 'DiagnosesIAndII')
				BEGIN
					DECLARE @UserCode VARCHAR(30)

					SELECT TOP 1 @UserCode = UserCode
					FROM Staff
					WHERE StaffId = @CurrentUserId
						AND ISNULL(RecordDeleted, 'N') = 'N'

					UPDATE ServiceDiagnosis
					SET RecordDeleted = 'Y' -- 11-JUL-2017 Chris Love
						,DeletedBy = @UserCode
						,DeletedDate = GETDATE()
					WHERE ISNULL(RecordDeleted, 'N') = 'N'
						AND ServiceId = @ServiceId
					
					DECLARE @RuleOut CHAR(1)	
					SELECT TOP 1 @RuleOut = CASE WHEN ISNULL(Value, 'N') = 'N' THEN 'N' ELSE 'Y' END
					FROM SystemConfigurationKeys
					WHERE [key] = 'INCLUDEBILLINGDIAGNOSISRULEOUT'
						AND ISNULL(RecordDeleted, 'N') = 'N'

					IF EXISTS (SELECT * FROM dbo.fnSplit(@TableList, ',') WHERE item = 'DocumentDiagnosisCodes')
					BEGIN
						INSERT INTO ServiceDiagnosis (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DSMVCodeId
							,ICD10Code
							,ICD9Code
							,[Order]
							,ServiceId
							)
						SELECT @UserCode
							,GETDATE()
							,@UserCode
							,GETDATE()
							,D.ICD10CodeId
							,D.ICD10Code
							,D.ICD9Code
							,D.DiagnosisOrder
							,@ServiceId
						FROM DocumentDiagnosisCodes D
						JOIN DiagnosisICD10Codes DD ON D.ICD10CodeId = DD.ICD10CodeId
							AND D.ICD10Code = DD.ICD10Code
						WHERE DocumentVersionId = @DocumentVersionId
							AND ISNULL(D.RecordDeleted, 'N') = 'N'
							AND ISNULL(D.Billable,'N') = 'Y'
							AND ISNULL(D.DiagnosisOrder, 0) <= 8
							AND (ISNULL(D.RuleOut, 'N') = @RuleOut OR @RuleOut = 'Y')
						ORDER BY D.DiagnosisOrder DESC
					END
					ELSE IF EXISTS (SELECT * FROM dbo.fnSplit(@TableList, ',') WHERE item = 'DiagnosesIAndII')
					BEGIN
						INSERT INTO ServiceDiagnosis (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,DSMCode
							,DSMNumber
							,[Order]
							,ServiceId
							)
						SELECT @UserCode
							,GETDATE()
							,@UserCode
							,GETDATE()
							,D.DSMCode
							,D.DSMNumber
							,D.DiagnosisOrder
							,@ServiceId
						FROM DiagnosesIAndII D
						JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode
							AND DD.DSMNumber = D.DSMNumber
						WHERE DocumentVersionId = @DocumentVersionId
							AND ISNULL(D.RecordDeleted, 'N') = 'N'
							AND ISNULL(D.Billable,'N') = 'Y'
							AND ISNULL(D.DiagnosisOrder, 0) <= 8
							AND (ISNULL(D.RuleOut, 'N') = @RuleOut OR @RuleOut = 'Y')
						ORDER BY D.DiagnosisOrder DESC
					END
				END
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCDocumentPostSignatureServiceDiagnosisUpdate]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (@Error,-- Message text.                                            
				16,-- Severity.                                            
				1 -- State.                                            
				);
	END CATCH
END
GO