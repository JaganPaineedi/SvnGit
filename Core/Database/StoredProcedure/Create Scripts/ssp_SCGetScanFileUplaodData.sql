IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetScanFileUplaodData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetScanFileUplaodData]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetScanFileUplaodData] (
	@ClientId INT
	,@ImageRecordId INT
	)
AS
DECLARE @ImageServerId INT
DECLARE @DocumentVersionId INT
DECLARE @EventId INT

/*********************************************************************/
/* Stored Procedure: [ssp_SCGetScanFileUplaodData]             */
/* Copyright: 2005  SmartCare            */
/* Creation Date:  18/06/2010                                    */
/*                                                                   */
/* Purpose: Gets list of Scanned Records or Uploaded Images and Client Information                                          
             w.r.t client Id       */
/*                                                                   */
/* Input Parameters: @ClientId int                                   */
/* Input Parameters: @ImageRecordId int                                                                 */
/* Output Parameters:                                */
/*                                                                   */
/* Return: retuns Gets list of Scanned Records or Uploaded Images and Client Information                                          
             w.r.t client Id             */
/*                                                                         */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:       */
/*                             */
/*                                                                   */
/* Updates:                                                          */
/*  Date                 Author                     Purpose             */
/*   18 june 2010        Ashwani Kumar Angrish      created              
/*   26 August 2010      Ashwani Kumar Angrish      Added Events Table                  */       
/*   19 May 2011		 Karan Garg					Commented Rowidentifier for imagerecords                  */       
/*   09 May 2011         Karan Garg					Added Columns CoveragePlanID   */*/
/* 04/10/2014			 Vaibhav Khare                Added columns ProviderAuthorizationDocumentId */
-- 20 Oct 2015			Revathi						what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */
--													why:task #609, Network180 Customization 
--09-11-2016            vkhare						Adding column in Image recoreds
/*03-08-2018			Lakshmi						What: InsurerID is missing in GET stored procedure but the column present in dataset and													it was causing the issue so we added InsurerID filed as part of Image records select														statement.Why:   AspenPointe - Support Go Live #803?*/
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
			AND
			--EffectiveDate is not null  and        
			ISNULL(RecordDeleted, 'N') = 'N'
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
				AND isnull(RecordDeleted, 'N') = 'N'
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
		SELECT [DocumentId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[ClientId]
			,[ServiceId]
			,[GroupServiceId]
			,[EventId]
			,[ProviderId]
			,[DocumentCodeId]
			,[EffectiveDate]
			,[DueDate]
			,[Status]
			,[AuthorId]
			,[CurrentDocumentVersionId]
			,[DocumentShared]
			,[SignedByAuthor]
			,[SignedByAll]
			,[ToSign]
			,[ProxyId]
			,[UnderReview]
			,[UnderReviewBy]
			,[RequiresAuthorAttention]
			,[InitializedXML]
			,[BedAssignmentId]
			,ReviewerId
			,InProgressDocumentVersionId
			,CurrentVersionStatus
			,ClientLifeEventId
		FROM [dbo].[Documents]
		WHERE CurrentDocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N';

		-------------------II -DocumentVersions        
		SELECT [DocumentVersionId]
			,[DocumentId]
			,[Version]
			,[EffectiveDate]
			,[DocumentChanges]
			,[ReasonForChanges]
			--,[RowIdentifier]      
			--,[ExternalReferenceId]      
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
		FROM [DocumentVersions]
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N';

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
			,[InsurerId]
			,[TaskId]
			,[AuthorizationDocumentId]
			,[ScannedBy]
			--,[RowIdentifier]      
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[CoveragePlanID]
		FROM [dbo].[ImageRecords]
		WHERE ClientId = @ClientId
			AND ImageRecordId = @ImageRecordId
			AND ISNULL(RecordDeleted, 'N') = 'N';

		----------IV query    "ScannedMedicalRecordImages"                                      
		EXEC ssp_GetScannedUploadImages @ImageRecordId
			,@ImageServerId
	END
	ELSE
	BEGIN
		SELECT @ImageServerId = ImageServerId
		FROM ImageRecords
		WHERE ImageRecordId = @ImageRecordId
			AND
			--EffectiveDate is not null  and        
			ISNULL(RecordDeleted, 'N') = 'N'
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
		SELECT [DocumentId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[ClientId]
			,[ServiceId]
			,[GroupServiceId]
			,[EventId]
			,[ProviderId]
			,[DocumentCodeId]
			,[EffectiveDate]
			,[DueDate]
			,[Status]
			,[AuthorId]
			,[CurrentDocumentVersionId]
			,[DocumentShared]
			,[SignedByAuthor]
			,[SignedByAll]
			,[ToSign]
			,[ProxyId]
			,[UnderReview]
			,[UnderReviewBy]
			,[RequiresAuthorAttention]
			,[InitializedXML]
			,[BedAssignmentId]
			,ReviewerId
			,InProgressDocumentVersionId
			,CurrentVersionStatus
			,ClientLifeEventId
		FROM [dbo].[Documents]
		WHERE DocumentId = - 1
			AND ISNULL(RecordDeleted, 'N') = 'N';

		-------------------II -DocumentVersions                              
		SELECT [DocumentVersionId]
			,[DocumentId]
			,[Version]
			,[EffectiveDate]
			,[DocumentChanges]
			,[ReasonForChanges]
			--,[RowIdentifier]      
			--,[ExternalReferenceId]      
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
		FROM [DocumentVersions]
		WHERE DocumentVersionId = - 1
			AND ISNULL(RecordDeleted, 'N') = 'N';

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
			,[InsurerId]
			,[TaskId]
			,[AuthorizationDocumentId]
			,[ScannedBy]
			-- ,[RowIdentifier]      
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,ProviderAuthorizationDocumentId
		FROM [dbo].[ImageRecords]
		WHERE ImageRecordId = @ImageRecordId
			AND ISNULL(RecordDeleted, 'N') = 'N';

		----------IV query    "ScannedMedicalRecordImages"                                      
		EXEC ssp_GetScannedUploadImages @ImageRecordId
			,@ImageServerId
	END

	-------- V query  "Clients"                                         
	SELECT
		-- Modified by   Revathi   20 Oct 2015
		CASE 
			WHEN ISNULL(ClientType, 'I') = 'I'
				THEN ISNULL(LastName, '') + ',' + ISNULL(FirstName, '')
			ELSE ISNULL(OrganizationName, '')
			END AS ClientName
	FROM Clients
	WHERE ClientId = @ClientId
	 SELECT BatchId,  
 CreatedBy,  
CreatedDate,  
ModifiedBy,  
ModifiedDate,  
RecordDeleted,  
DeletedBy,  
DeletedDate  
FROM   
 MedicalRecordBatches WHERE BatchId=(  SELECT BatchId FROM [dbo].[ImageRecords]    
  WHERE ImageRecordId = @ImageRecordId    
   AND ISNULL(RecordDeleted, 'N') = 'N') 
	IF (@@error != 0)
	BEGIN
		RAISERROR 20002 'ssp_SCGetScanFileUplaodData'
	END
END