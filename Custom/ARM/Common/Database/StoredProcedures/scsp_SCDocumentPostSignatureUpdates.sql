IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCDocumentPostSignatureUpdates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCDocumentPostSignatureUpdates]
GO

Create PROCEDURE [dbo].[scsp_SCDocumentPostSignatureUpdates] (
	@CurrentUserId INT
	,@DocumentId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: scsp_SCDocumentPostSignatureUpdates                */
/* Copyright: 2006 Streamlin Healthcare Solutions           */
/* Creation Date:  4/11/2006                                    */
/*                                                                   */
/* Purpose: To Post Signature Update*/
/*                                                                   */
/* Input Parameters: None*/
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return:   */
/*                                                                   */
/* Called By:          */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/*   Updates:                                                          */
/*       Date              Author                  Purpose                                    */
/*  4/11/2006      Nelam Prasad              Created       
/* Commented the csp_AutoCreateDDAssessmentOffOfHRMDDAssessment in lieu of #2891- added DocumentVersionId   
 06/07/2010   dharvey    added updates for null provider id on Tx plan*/                              */
--Changes made by Mamta Gupta - Ref Task 407- 29/Dec/2011 - To stop call csp_AutoPopulateTxPlanDelivery storeprocedure if ClientDeclinedPlanCopy='Y'                      
/*********************************************************************/
DECLARE @DocumentCodeId INT
	,@ClientId INT
	,@AuthorID INT
	,@CreatedBy VARCHAR(30)
	,@DocumentVersionId INT

SELECT @DocumentCodeId = d.DocumentCodeId
	,@ClientId = d.CLientId
	,@AuthorID = d.AuthorId
	,@CreatedBy = d.CreatedBy
	,@DocumentVersionId = d.CurrentDocumentVersionId
FROM Documents d
WHERE d.DocumentId = @DocumentId

-- Run Cosignature Creation Script    
EXEC csp_DocumentCosignatures @CurrentUserId
	,@DocumentId

IF @@error <> 0
	GOTO error

IF @DocumentCodeId IN (1469)
BEGIN
	IF EXISTS (
			SELECT 1
			FROM CustomHRMAssessments ca
			WHERE ca.DocumentVersionId = @DocumentVersionId
				AND isnull(ca.ClientIsAppropriateForTreatment, 'Y') <> 'Y'
				AND ISNULL(ca.RecordDeleted, 'N') <> 'Y'
				AND NOT EXISTS (
					SELECT 1
					FROM documents d
					WHERE d.ClientId = @ClientId
						AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
						AND d.DocumentCodeId = 100 --adv/adq  
						AND d.CreatedBy = 'AutoAdvAdq'
					)
			)
		--and d.ExternalReferenceId = rtrim(convert(varchar(12),@DocumentVersionId))  
	BEGIN
		EXEC csp_CreateAdvAdqNoticeFromAssessment @DocumentVersionId
			,@ClientId
			,@AuthorId
			,@CreatedBy
	END
END

--  
-- Create disclosure record from service note  
--  
DECLARE @DisclosureType INT

SET @DisclosureType = (
		SELECT TOP 1 GlobalCodeId
		FROM GlobalCodes gc
		WHERE Category = 'DISCLOSURETYPE'
			AND CodeName = 'Part Of Intervention'
			AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		)

IF EXISTS (
		SELECT 1
		FROM Documents d
		INNER JOIN CustomFieldsData cfd ON cfd.PrimaryKey1 = d.ServiceId
			AND cfd.DocumentType = 4943
		WHERE d.CurrentDocumentVersionId = @DocumentVersionId
			AND isnull(ColumnVarchar2, 'X') = 'Y'
			AND isnull(d.RecordDeleted, 'N') = 'N'
			AND isnull(cfd.RecordDeleted, 'N') = 'N'
		)
	AND NOT EXISTS (
		SELECT 1
		FROM ClientDisclosures cd
		INNER JOIN ClientDisclosedRecords cdr ON cdr.ClientDisclosureId = cd.ClientDisclosureId
		WHERE cdr.DocumentId = @DocumentId
			AND cd.DisclosureType = @DisclosureType
			AND isnull(cd.RecordDeleted, 'N') = 'N'
			AND isnull(cdr.RecordDeleted, 'N') = 'N'
		)
BEGIN
	EXEC [csp_AutoCreateDisclosureRecordOffOfServiceNote] @DocumentVersionId
END

--  
-- Update Provider names on the Tx Plan if null - DJH 6/7/2010   
-- add IF statement to only update on Signed Tx Plan   
IF (
		@DocumentCodeId IN (
			350
			,503
			)
		)
	AND NOT EXISTS (
		SELECT 1
		FROM documentsignatures ds
		WHERE ds.signaturedate IS NOT NULL
			AND ds.signatureorder > 1
			AND ds.Documentid = @DocumentId
			AND isnull(ds.recorddeleted, 'N') = 'N'
		)
	AND EXISTS (
		SELECT 1
		FROM TPProcedures
		WHERE DocumentVersionId = @DocumentVersionId
			AND ProviderId IS NULL
			AND SiteId IS NOT NULL
		)
BEGIN
	UPDATE a
	SET a.ProviderId = s.ProviderId
	FROM Authorizations a
	INNER JOIN Sites s ON s.SiteId = a.SiteId
	INNER JOIN TPProcedures tp ON tp.TPProcedureId = a.TPProcedureId
	WHERE tp.DocumentVersionId = @DocumentVersionId
		AND a.ProviderId IS NULL
		AND s.SiteId IS NOT NULL

	UPDATE tp
	SET tp.ProviderId = s.ProviderId
	FROM TPProcedures tp
	INNER JOIN Sites s ON s.SiteId = tp.SiteId
	WHERE tp.DocumentVersionId = @DocumentVersionId
		AND tp.ProviderId IS NULL
		AND s.SiteId IS NOT NULL
END

-- Automatically Create diagnosis document off of signed PsychEval or Med Review  or MD Note  
IF @DocumentCodeId IN (
		--117
		--,121
		--,306
		1489
        ,1490
		)
	--Do not create diagnosis documents when Renee or Ty are the author  
	AND @CurrentUserId NOT IN (
		65
		,85
		) --Renee, Ty  
	AND NOT EXISTS (
		SELECT *
		FROM documentsignatures ds
		WHERE ds.signaturedate IS NOT NULL
			AND ds.signatureorder > 1
			AND ds.Documentid = @DocumentId
			AND isnull(ds.recorddeleted, 'N') = 'N'
		)
BEGIN
	EXEC csp_CreateDiagnosisDoc @CurrentUserId
		,@DocumentId
		,NULL
	EXEC csp_CreateICD10DiagnosisDoc @CurrentUserId, @DocumentId, NULL  
END

IF @@error <> 0
	GOTO error

-- Automatically Create diagnosis document off of signed HRM Assessment    
IF (
		@DocumentCodeId IN (
			--349
			--,1469
			1486
			)
		AND EXISTS (
			SELECT *
			FROM SystemConfigurations
			WHERE isnull(AutoCreateDiagnosisFromAssessment, 'N') = 'Y'
			)
		)
	AND NOT EXISTS (
		SELECT *
		FROM documentsignatures ds
		WHERE ds.signaturedate IS NOT NULL
			AND ds.signatureorder > 1
			AND ds.Documentid = @DocumentId
			AND isnull(ds.recorddeleted, 'N') = 'N'
		)
BEGIN
	EXEC csp_CreateDiagnosisDoc @CurrentUserId
		,@DocumentId
		,NULL
	EXEC csp_CreateICD10DiagnosisDoc @CurrentUserId, @DocumentId, NULL  
END

IF @@error <> 0
	GOTO error

IF @DocumentCodeId = 352 -- periodic review    
	AND NOT EXISTS (
		SELECT *
		FROM documentsignatures ds
		WHERE ds.signaturedate IS NOT NULL
			AND ds.signatureorder > 1
			AND ds.Documentid = @DocumentId
			AND isnull(ds.recorddeleted, 'N') = 'N'
		)
BEGIN
	EXEC csp_CheckPeriodicReviewForTxPlanChanges @DocumentVersionID
END

-- Automatically Create DCH DD Assessment document off of signed HRM DD Assessment    
IF (
		@DocumentCodeId IN (
			349
			,1469
			)
		AND EXISTS (
			SELECT 1
			FROM CustomHRMAssessments a
			WHERE isnull(a.ClientInDDPopulation, 'N') = 'Y'
				AND isnull(a.RecordDeleted, 'N') = 'N'
				AND a.AssessmentType IN (
					'A'
					,'I'
					)
				AND a.DocumentVersionId = @DocumentVersionId
			)
		)
	AND NOT EXISTS (
		SELECT 1
		FROM documentsignatures ds
		WHERE ds.signaturedate IS NOT NULL
			AND ds.signatureorder > 1
			AND ds.Documentid = @DocumentId
			AND isnull(ds.recorddeleted, 'N') = 'N'
		)
BEGIN
	EXEC csp_AutoCreateDDAssessmentOffOfHRMDDAssessment @DocumentId
		,NULL
END

IF @@error <> 0
	GOTO error

-- Automatically populate client living arrangement off of signed HRM Assessment    
IF (
		@DocumentCodeId IN (
			349
			,1469
			)
		)
	AND NOT EXISTS (
		SELECT *
		FROM documentsignatures ds
		WHERE ds.signaturedate IS NOT NULL
			AND ds.signatureorder > 1
			AND ds.Documentid = @DocumentId
			AND isnull(ds.recorddeleted, 'N') = 'N'
		)
BEGIN
	EXEC csp_AutoPopulateClientInformationOffOfHRMAssessment @DocumentId
		,NULL
END

IF @@error <> 0
	GOTO error

-- Automatically populate tx plan delivery misc note off of signed Treatment plan    
IF (
		@DocumentCodeId IN (
			350
			,503
			)
		)
	AND NOT EXISTS (
		SELECT *
		FROM documentsignatures ds
		WHERE ds.signaturedate IS NOT NULL
			AND ds.signatureorder > 1
			AND ds.Documentid = @DocumentId
			AND isnull(ds.recorddeleted, 'N') = 'N'
		)
BEGIN
	--Changes made by Mamta Gupta - Ref Task 407- 29/Dec/2011 - To stop call csp_AutoPopulateTxPlanDelivery storeprocedure if ClientDeclinedPlanCopy='Y'
	IF EXISTS (
			SELECT documentversionid
			FROM tpgeneral
			WHERE isnull(CAST(FLOOR(CAST(PlanDeliveredDate AS FLOAT)) AS DATETIME), '') <> isnull(CAST(FLOOR(CAST(MeetingDate AS FLOAT)) AS DATETIME), '')
				AND isnull(ClientDeclinedPlanCopy, 'N') <> 'Y'
				AND documentversionid = @DocumentVersionId
			)
	BEGIN
		EXEC csp_AutoPopulateTxPlanDelivery @DocumentId
			,NULL
	END
END

IF @@error <> 0
	GOTO error

RETURN

Error:

RAISERROR 20006 'scsp_SCDocumentPostSignatureUpdates: An Error Occured'

RETURN
