/****** Object:  StoredProcedure [dbo].[ssp_SCGetScanDataByClientId]    Script Date: 11/18/2011 16:25:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetScanDataByClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetScanDataByClientId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetScanDataByClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_SCGetScanDataByClientId] (
	@ClientId INT
	,@ImageRecordId INT
	)
AS
DECLARE @ImageServerId INT
DECLARE @DocumentVersionId INT
DECLARE @DocumentId INT
DECLARE @EventId INT

/*********************************************************************/
/* Stored Procedure: [ssp_SCGetScanDataByClientId]             */
/* Copyright: 2005  SmartCare            */
/* Creation Date:  29/01/2010                                    */
/*                                                                   */
/* Purpose: Gets list of Scanned Records and Client Information                                        
             w.r.t client Id       */
/*                                                                   */
/* Input Parameters: @ClientId int                                   */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return: retuns list of Scanned Records and Client Information                                        
             w.r.t client Id            */
/*                                                                         */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:       */
/*                             */
/*                                                                   */
/* Updates:                                                          */
/*  Date               Author      Purpose             */
/*    26 August 2010    Ashwani Kumar Angrish  Added Events Table   */
/*    26.7.2011   Maninder		Modifed                       */
/*  20 Oct 2015  Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */
/*								why:task #609, Network180 Customization  */
/*********************************************************************/
BEGIN
	IF (@ClientId > 0)
	BEGIN
		SELECT @ImageServerId = ImageServerId
			,@DocumentVersionId = DocumentVersionId
			,@EventId = EventId
		FROM ImageRecords
		WHERE ClientId = @ClientId
			AND ImageRecordId = @ImageRecordId
			AND EffectiveDate IS NOT NULL
			AND ISNULL(RecordDeleted, ''N'') = ''N''
		ORDER BY CreatedDate DESC

		IF (@EventId IS NOT NULL)
		BEGIN
			SELECT [EventId]
				,[StaffId]
				,[ClientId]
				,[EventTypeId]
				,[EventDateTime]
				,[Status]
				,[FollowUpEventId]
				,[ProviderId]
				,[InsurerId]
				,[RowIdentifier]
				,[CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[RecordDeleted]
				,[DeletedDate]
				,[DeletedBy]
			FROM Events
			WHERE [EventId] = @EventId
				AND isnull(RecordDeleted, ''N'') = ''N''
		END
		ELSE
		BEGIN
			SELECT [EventId]
				,[StaffId]
				,[ClientId]
				,[EventTypeId]
				,[EventDateTime]
				,[Status]
				,[FollowUpEventId]
				,[ProviderId]
				,[InsurerId]
				,[RowIdentifier]
				,[CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[RecordDeleted]
				,[DeletedDate]
				,[DeletedBy]
			FROM Events
			WHERE [EventId] = - 1
		END

		------------------I --Documents                                 
		SELECT DocumentId
			,ClientId
			,ServiceId
			,GroupServiceId
			,EventId
			,ProviderId
			,DocumentCodeId
			,EffectiveDate
			,DueDate
			,STATUS
			,AuthorId
			,CurrentDocumentVersionId
			,DocumentShared
			,SignedByAuthor
			,SignedByAll
			,ToSign
			,ProxyId
			,UnderReview
			,UnderReviewBy
			,RequiresAuthorAttention
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM Documents
		WHERE CurrentDocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, ''N'') = ''N'';

		-------------------II -DocumentVersions                            
		SELECT DocumentVersionId
			,DocumentId
			,Version
			,EffectiveDate
			,DocumentChanges
			,ReasonForChanges
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM DocumentVersions
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, ''N'') = ''N'';

		----------------III query "ImageRecords"                                       
		SELECT [ImageRecordId]
			,[ScannedOrUploaded]
			,[DocumentVersionId]
			,[ImageServerId]
			,[ClientId]
			,[AssociatedId]
			,[AssociatedWith]
			,[RecordDescription]
			,[EffectiveDate]
			,[NumberOfItems]
			,[AssociatedWithDocumentId]
			,[AppealId]
			,[StaffId]
			,[EventId]
			,[ProviderId]
			,[ScannedBy]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
		FROM ImageRecords
		WHERE ClientId = @ClientId
			AND ImageRecordId = @ImageRecordId
			AND ISNULL(RecordDeleted, ''N'') = ''N'';

		----------IV query    "ImageRecordItems"                                    
		EXEC ssp_PMScanGetScannedImages @ImageRecordId
			,@ImageServerId
	END
	ELSE
	BEGIN
		SELECT @ImageServerId = ImageServerId
		FROM ImageRecords
		WHERE ImageRecordId = @ImageRecordId
			AND EffectiveDate IS NOT NULL
			AND ISNULL(RecordDeleted, ''N'') = ''N''
		ORDER BY CreatedDate DESC

		SELECT [EventId]
			,[StaffId]
			,[ClientId]
			,[EventTypeId]
			,[EventDateTime]
			,[Status]
			,[FollowUpEventId]
			,[ProviderId]
			,[InsurerId]
			,[RowIdentifier]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
		FROM Events
		WHERE [EventId] = - 1

		------------------I --Documents                                 
		SELECT DocumentId
			,ClientId
			,ServiceId
			,GroupServiceId
			,EventId
			,ProviderId
			,DocumentCodeId
			,EffectiveDate
			,DueDate
			,STATUS
			,AuthorId
			,CurrentDocumentVersionId
			,DocumentShared
			,SignedByAuthor
			,SignedByAll
			,ToSign
			,ProxyId
			,UnderReview
			,UnderReviewBy
			,RequiresAuthorAttention
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM Documents
		WHERE DocumentId = - 1
			AND ISNULL(RecordDeleted, ''N'') = ''N'';

		-------------------II -DocumentVersions                            
		SELECT DocumentVersionId
			,DocumentId
			,Version
			,EffectiveDate
			,DocumentChanges
			,ReasonForChanges
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM DocumentVersions
		WHERE DocumentVersionId = - 1
			AND ISNULL(RecordDeleted, ''N'') = ''N'';

		----------------III query "ImageRecords"                                       
		SELECT [ImageRecordId]
			,[ScannedOrUploaded]
			,[DocumentVersionId]
			,[ImageServerId]
			,[ClientId]
			,[AssociatedId]
			,[AssociatedWith]
			,[RecordDescription]
			,[EffectiveDate]
			,[NumberOfItems]
			,[AssociatedWithDocumentId]
			,[AppealId]
			,[StaffId]
			,[EventId]
			,[ProviderId]
			,[ScannedBy]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
		FROM ImageRecords
		WHERE ImageRecordId = @ImageRecordId
			AND ISNULL(RecordDeleted, ''N'') = ''N'';

		----------IV query    "ScannedMedicalRecordImages"                                    
		EXEC ssp_PMScanGetScannedImages @ImageRecordId
			,@ImageServerId
	END

	-------- V query  "Clients"                                       
	SELECT
		--Modified by   Revathi   20 Oct 2015  
		CASE 
			WHEN ISNULL(ClientType, ''I'') = ''I''
				THEN ISNULL(LastName, '''') + '','' + ISNULL(FirstName, '''')
			ELSE ISNULL(OrganizationName, '''')
			END AS ClientName
	FROM Clients
	WHERE ClientId = @ClientId

	IF (@@error != 0)
	BEGIN
		RAISERROR 20002 ''ssp_SCGetScanDataByClientId''
	END
END' 
END
GO
