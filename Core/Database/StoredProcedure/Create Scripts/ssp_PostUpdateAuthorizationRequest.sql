IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateAuthorizationRequest]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PostUpdateAuthorizationRequest]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PostUpdateAuthorizationRequest] (
	@ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
	)
	/******************************************************************************/
	/* Stored Procedure: dbo.[ssp_GetBillingCodes]                                */
	/* Author: Arjun K R                                                          */
	/* Date  : 23- Feb-2016                                                       */
	/* Purpose : Task #604.6 Network180 Customization.                            */
	/*  Date		  Modified		 Purpose
    /*  9th Aug 2016  shivanand		 What :To pull Authorization request event and Image records */
								     why  : Task #342 Network 180 Environment Issues Tracking. */
	/*  14th Nov 2016 Manikanan		 What :Checking condition to status is required  */
	/*								 why  : Task #919 Network 180 Environment Issues Tracking. */
	/*  14th Nov 2016 Shivanand		 What :Updated ProviderAuthorizationDocumentId column of ImageRecords table. */
	/*								 why  : Task #926 and 928 Network 180 Environment Issues Tracking. 
	    22th Apr 2018 N180 Team      What: Inserted Comment column data from AuthorizationRequests to ProviderAuthorizations 
										table Comment column. why : Earlier NULL was saved in comments column of ProviderAuthorizations
										with reference of Tasks #517, Network180 Support Go Live >  > Authorization request change 
										
	/*  17th Oct 2018  Rajeshwari S	 What : Added logic to insert BillingCodeId and BillingCodeModifierId columns on ProviderAuthorizations table.
	                                        And also added logic to check modifiers and RecordDeleted for table 'BillingCodeModifiers'.
	                                  Why : KCMHSAS - Support #960.211  */
	/*******************************************************************************/*/
AS
BEGIN
	BEGIN TRY
		DECLARE @DocumentId INT
		DECLARE @PreviousDocumentVersionId INT
		DECLARE @ProviderAuthorizationDocumentId INT
		DECLARE @AuthorizationNumber VARCHAR(35)
		DECLARE @ProviderId INT
		DECLARE @MaxAuthorizationNumber INT
		DECLARE @CurrentDocumentVersionId INT

		SET @PreviousDocumentVersionId = 0

		SELECT @Documentid = @ScreenKeyId

		SELECT @PreviousDocumentVersionId = DocumentVersionId
		FROM (
			SELECT row_number() OVER (
					ORDER BY DocumentVersionId DESC
					) AS rownumber
				,DocumentVersionId
			FROM DocumentVersions
			WHERE DocumentId = @Documentid
				AND isnull(RecordDeleted, 'N') = 'N'
			) AS DocumentVersion
		WHERE rownumber = 2

		INSERT INTO dbo.ProviderAuthorizationDocuments (
			DocumentName
			,InsurerId
			,ClientId
			,EventId
			,RequestorProgram
			,RequestorDocumentId
			,RequestorName
			,RequestorId
			,RequestDate
			,ReviewerComment
			,AuthorizationDocumentId
			,LastReviewedBy
			,LastReviewedOn
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ImageRecordId
			)
		SELECT 'Authorization Request'
			,-- DocumentName                
			a.InsurerId
			,c.ClientId
			,c.EventId
			,NULL
			,-- RequestorProgram               
			NULL
			,-- RequestorDocumentId              
			substring(d.ProviderName, 1, 50)
			,-- RequestorName                
			NULL
			,-- RequestorId             
			c.EventDateTime
			,-- RequestDate              
			-- a.RequestorRationale, -- RequestorComment              
			NULL
			,-- ReviewerComment             
			NULL
			,-- AuthorizationDocumentId            
			NULL
			,-- LastReviewedBy           
			NULL
			,-- LastReviewedOn       
			b.ModifiedBy
			,-- CreatedBy              
			b.ModifiedDate
			,-- CreatedDate             
			b.ModifiedBy
			,b.ModifiedDate
			,ir.ImageRecordId
		FROM dbo.DocumentAuthorizationRequests a
		JOIN Documents b ON a.DocumentVersionId = b.CurrentDocumentVersionId
		JOIN events c ON c.EventId = b.EventId
		JOIN providers d ON d.providerId = a.ProviderId
		--9th Aug 2016  shivanand
		LEFT JOIN ImageRecords ir ON ir.DocumentVersionId = a.DocumentVersionId
		WHERE b.DocumentId = @DocumentId
			AND isnull(a.RecordDeleted, 'N') <> 'Y'
			AND isnull(b.RecordDeleted, 'N') <> 'Y'
			AND isnull(c.RecordDeleted, 'N') <> 'Y'
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND isnull(ir.RecordDeleted, 'N') <> 'Y'

		SELECT @ProviderAuthorizationDocumentId = @@Identity

		SELECT @Providerid = a.ProviderId
			,@CurrentDocumentVersionId = a.DocumentVersionId
		FROM dbo.DocumentAuthorizationRequests a
		JOIN Documents b ON a.DocumentVersionId = b.CurrentDocumentVersionId
		JOIN events c ON c.EventId = b.EventId
		WHERE b.DocumentId = @DocumentId

		UPDATE ImageRecords
		SET ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
		WHERE DocumentVersionId = @CurrentDocumentVersionId
			AND isnull(RecordDeleted, 'N') <> 'Y'

		DECLARE @InsurerId INT
		DECLARE @ClientId INT
		DECLARE @SiteId INT
		DECLARE @BillingCodeId INT
		DECLARE @Modifier1 VARCHAR(10)
		DECLARE @Modifier2 VARCHAR(10)
		DECLARE @Modifier3 VARCHAR(10)
		DECLARE @Modifier4 VARCHAR(10)
		DECLARE @StartDate DATETIME
		DECLARE @EndDate DATETIME
		DECLARE @Units INT
		DECLARE @Frequency type_GlobalCode
		DECLARE @TotalUnits DECIMAL
		DECLARE @ModifiedBy type_CurrentUser
		DECLARE @ModifiedDate type_CurrentDatetime
		DECLARE @SUAuthorizationDocumentAuthorizationId INT
		DECLARE @ProviderAuthorizationId INT
		DECLARE @PreviousSUAuthorizationDocumentAuthorizationId INT
		DECLARE @DocumentVersionId INT
		DECLARE @SUProviderAuthorizationId INT
		DECLARE @RequestedBillingCodeModifierId INT
		----------Declaring variables to check the count of events created to attach a document from which these events are created.-------
		DECLARE @ConcurrentReviewIPCreatedCount INT
		DECLARE @ConcurrentReviewSUDCreatedCount INT
		DECLARE @ConcurrentReviewOPCreatedCount INT
		DECLARE @CreateProspectiveECTCreatedCount INT
		DECLARE @ProspectiveSUDCreatedCount INT
		DECLARE @CreateRetrospectiveCreatedCount INT
		DECLARE @Status INT --14th Oct 2016 Manikanan
		DECLARE @comment VARCHAR(max)

		SET @ConcurrentReviewIPCreatedCount = 0
		SET @ConcurrentReviewSUDCreatedCount = 0
		SET @ConcurrentReviewOPCreatedCount = 0
		SET @CreateProspectiveECTCreatedCount = 0
		SET @ProspectiveSUDCreatedCount = 0
		SET @CreateRetrospectiveCreatedCount = 0
		SET @Status = 0 --14th Oct 2016 Manikanan

		--------BEGIN CURSOR ---                         
		DECLARE cur_CustomSUAuthorization CURSOR
		FOR
		SELECT b.AuthorizationRequestId
			,a.InsurerId
			,d.ClientId
			,a.ProviderId
			,b.SiteId
			,b.BillingCodeId
			,b.Modifier1
			,b.Modifier2
			,b.Modifier3
			,b.Modifier4
			,b.StartDate
			,b.EndDate
			,b.BillingCodeId
			,b.Units
			,b.Frequency
			,b.TotalUnits
			,b.ModifiedBy
			,b.ModifiedDate
			,b.DocumentVersionId
			,bc.BillingCodeModifierId
			,--9th Aug 2016  shivanand  
			isnull(b.ProviderAuthorizationId, 0)
			,b.[Status] --14th Oct 2016 Manikanan
			,b.Comment
		FROM DocumentAuthorizationRequests a
		JOIN AuthorizationRequests b ON b.DocumentVersionId = a.DocumentVersionId
		JOIN documents c ON c.CurrentDocumentVersionId = a.DocumentVersionId
		JOIN events d ON d.EventId = c.EventId
		LEFT JOIN BillingCodeModifiers bc ON bc.BillingCodeId = b.BillingCodeId 
		                                    -- Added by Rajeshwari on 10/17/2018
		                                    AND ISNULL(bc.RecordDeleted, 'N') = 'N'          
											AND((isnull(b.Modifier1,'')=isnull(bc.Modifier1,'')) 
											AND(isnull(b.Modifier2,'')=isnull(bc.Modifier2,''))
											AND(isnull(b.Modifier3,'')=isnull(bc.Modifier3,''))
											AND(isnull(b.Modifier4,'')=isnull(bc.Modifier4,'')))
		WHERE c.DocumentId = @DocumentId
			AND isnull(a.RecordDeleted, 'N') <> 'Y'
			AND isnull(b.RecordDeleted, 'N') <> 'Y'
			AND isnull(c.RecordDeleted, 'N') <> 'Y'
			AND isnull(d.RecordDeleted, 'N') <> 'Y'

		OPEN cur_CustomSUAuthorization

		FETCH NEXT
		FROM cur_CustomSUAuthorization
		INTO @SUAuthorizationDocumentAuthorizationId
			,@InsurerId
			,@ClientId
			,@ProviderId
			,@SiteId
			,@BillingCodeId
			,@Modifier1
			,@Modifier2
			,@Modifier3
			,@Modifier4
			,@StartDate
			,@EndDate
			,@BillingCodeId
			,@Units
			,@Frequency
			,@TotalUnits
			,@ModifiedBy
			,@ModifiedDate
			,@DocumentVersionId
			,@RequestedBillingCodeModifierId
			,--9th Aug 2016  shivanand
			@SUProviderAuthorizationId
			,@Status --14th Oct 2016 Manikanan 
			,@comment

		WHILE @@fetch_status = 0
		BEGIN
			IF @SUProviderAuthorizationId = 0
			BEGIN
				IF (@Status = 4242) --14th Oct 2016 Manikanan
				BEGIN
					INSERT INTO dbo.ProviderAuthorizations (
						ProviderAuthorizationDocumentId
						,InsurerId
						,ClientId
						,ProviderId
						,SiteId
						,BillingCodeId
						,Modifier1
						,Modifier2
						,Modifier3
						,Modifier4
						,AuthorizationNumber
						,Active
						,[Status]
						,Reason
						,StartDate
						,EndDate
						,StartDateRequested
						,EndDateRequested
						,RequestedBillingCodeId
						,UnitsRequested
						,FrequencyTypeRequested
						,TotalUnitsRequested
						,UnitsApproved
						,FrequencyTypeApproved
						,TotalUnitsApproved
						,UnitsUsed
						,Comment
						,DeniedDate
						,Modified
						,AuthorizationProviderBillingCodeId
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,RequestedBillingCodeModifierId--9th Aug 2016  shivanand
						,BillingCodeModifierId  -- Rajeshwari S
						)
					VALUES (
						@ProviderAuthorizationDocumentId
						,@InsurerId
						,@ClientId
						,@ProviderId
						,@SiteId
						,@BillingCodeId -- Rajeshwari S
						,@Modifier1
						,@Modifier2
						,@Modifier3
						,@Modifier4
						,NULL
						,-- AuthorizationNumber
						'Y'
						,-- Active                 
						2041
						,-- Status                           
						NULL
						,-- Reason                 
						NULL
						,-- StartDate            
						NULL
						,-- EndDate - datetime              
						@StartDate
						,-- StartDateRequested              
						@EndDate
						,-- EndDateRequested                
						@BillingCodeId
						,-- RequestedBillingCodeId                 
						@Units
						,-- UnitsRequested              
						@Frequency
						,-- FrequencyTypeRequested              
						@TotalUnits
						,-- TotalUnitsRequested     
						NULL
						,-- UnitsApproved                
						NULL
						,-- FrequencyTypeApproved                
						NULL
						,-- TotalUnitsApproved             
						0
						,-- UnitsUsed             
						@comment
						,-- Comment                
						NULL
						,-- DeniedDate               
						NULL
						,-- Modified              
						NULL
						,-- AuthorizationProviderBillingCodeId
						@ModifiedBy
						,-- CreatedBy                
						@ModifiedDate
						,-- CreatedDate               
						@ModifiedBy
						,@ModifiedDate
						,@RequestedBillingCodeModifierId  --9th Aug 2016  shivanand
						,@RequestedBillingCodeModifierId  -- Rajeshwari S
						)
				END
				ELSE
				BEGIN
					INSERT INTO dbo.ProviderAuthorizations (
						ProviderAuthorizationDocumentId
						,InsurerId
						,ClientId
						,ProviderId
						,SiteId
						,BillingCodeId
						,Modifier1
						,Modifier2
						,Modifier3
						,Modifier4
						,AuthorizationNumber
						,Active
						,[Status]
						,Reason
						,StartDate
						,EndDate
						,StartDateRequested
						,EndDateRequested
						,RequestedBillingCodeId
						,UnitsRequested
						,FrequencyTypeRequested
						,TotalUnitsRequested
						,UnitsApproved
						,FrequencyTypeApproved
						,TotalUnitsApproved
						,UnitsUsed
						,Comment
						,DeniedDate
						,Modified
						,AuthorizationProviderBillingCodeId
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,RequestedBillingCodeModifierId --9th Aug 2016  shivanand
						,BillingCodeModifierId -- Rajeshwari S
						)
					VALUES (
						@ProviderAuthorizationDocumentId
						,@InsurerId
						,@ClientId
						,@ProviderId
						,@SiteId
						,@BillingCodeId -- Rajeshwari S
						,@Modifier1
						,@Modifier2
						,@Modifier3
						,@Modifier4
						,NULL
						,-- AuthorizationNumber
						'Y'
						,-- Active                 
						2041
						,-- Status                           
						NULL
						,-- Reason                 
						@StartDate
						,-- StartDate             
						@EndDate
						,-- EndDate - datetime                
						@StartDate
						,-- StartDateRequested              
						@EndDate
						,-- EndDateRequested                
						@BillingCodeId
						,-- RequestedBillingCodeId                
						@Units
						,-- UnitsRequested              
						@Frequency
						,-- FrequencyTypeRequested              
						@TotalUnits
						,-- TotalUnitsRequested     
						@Units
						,-- UnitsApproved                
						NULL
						,-- FrequencyTypeApproved                
						@TotalUnits
						,-- TotalUnitsApproved             
						0
						,-- UnitsUsed             
						@comment
						,-- Comment                
						NULL
						,-- DeniedDate               
						NULL
						,-- Modified              
						NULL
						,-- AuthorizationProviderBillingCodeId
						@ModifiedBy
						,-- CreatedBy                
						@ModifiedDate
						,-- CreatedDate               
						@ModifiedBy
						,@ModifiedDate
						,@RequestedBillingCodeModifierId --9th Aug 2016  shivanand
						,@RequestedBillingCodeModifierId  -- Rajeshwari S
						)
				END

				SELECT @ProviderAuthorizationId = scope_identity()

				SET @AuthorizationNumber = convert(CHAR(8), getdate(), 112) + '-' + convert(VARCHAR, @ProviderAuthorizationId)
				SET @MaxAuthorizationNumber = 1

				WHILE EXISTS (
						SELECT '*'
						FROM ProviderAuthorizations pa
						WHERE AuthorizationNumber = @AuthorizationNumber
							AND isnull(pa.RecordDeleted, 'N') = 'N'
						)
				BEGIN
					SET @MaxAuthorizationNumber = @MaxAuthorizationNumber + 1
					SET @AuthorizationNumber = @AuthorizationNumber + '-' + convert(VARCHAR, @MaxAuthorizationNumber)
				END

				IF (@Status != 4242) --14th Oct 2016 Manikanan
				BEGIN
					UPDATE pa
					SET AuthorizationNumber = @AuthorizationNumber
					FROM ProviderAuthorizations pa
					WHERE pa.ProviderAuthorizationId = @ProviderAuthorizationId
				END

				IF object_id('tempdb..#tempAuth') IS NOT NULL
					DROP TABLE #tempAuth

				CREATE TABLE #tempAuth (
					ClientId INT
					,BillingCodeId INT
					)

				INSERT INTO #tempAuth
				SELECT ClientId
					,RequestedBillingCodeModifierId
				FROM ProviderAuthorizations
				WHERE ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
					AND isnull(RecordDeleted, 'N') = 'N'

				DECLARE @StatusCount INT

				SET @StatusCount = (
						SELECT count(*)
						FROM ProviderAuthorizations
						WHERE ClientId = @ClientId
							AND STATUS = 2041
						)

				IF object_id('tempdb..#tempapprovedauth') IS NOT NULL
					DROP TABLE #tempapprovedauth

				CREATE TABLE #tempapprovedauth (
					StatusCount INT
					,BillingCodeId INT
					,ClientId INT
					,ProviderId INT
					,[status] INT
					)

				INSERT INTO #tempapprovedauth
				SELECT count(RequestedBillingCodeId) AS statusCount
					,RequestedBillingCodeId
					,ClientId
					,ProviderId
					,[status]
				FROM ProviderAuthorizations
				WHERE ClientId = @ClientId
					AND [status] IN (
						2048
						,2042
						)
					AND isnull(RecordDeleted, 'N') = 'N'
					AND RequestedBillingCodeId IS NOT NULL
					AND ProviderId IS NOT NULL
				GROUP BY RequestedBillingCodeId
					,ClientId
					,ProviderId
					,[status]

				UPDATE P
				SET P.ReviewLevel = (
						CASE 
							WHEN cast(P.StartDateRequested AS DATE) < cast(getdate() AS DATE)
								AND cast(P.EndDateRequested AS DATE) <= cast(getdate() AS DATE)
								THEN 8726
							WHEN cast(P.StartDateRequested AS DATE) >= cast(getdate() AS DATE)
								AND cast(P.EndDateRequested AS DATE) >= cast(getdate() AS DATE)
								AND isnull(a.StatusCount, 0) < 1
								OR (
									a.StatusCount = 1
									AND EXISTS (
										SELECT 1
										FROM dbo.ssf_RecodeValuesCurrent('ProspectiveStatus') R
										WHERE R.IntegerCodeId = P.[status]
										)
									)
								THEN 8727
							WHEN cast(P.StartDateRequested AS DATE) >= cast(getdate() AS DATE)
								AND cast(P.EndDateRequested AS DATE) >= cast(getdate() AS DATE)
								AND (isnull(a.StatusCount, 0) > 1)
								OR (
									isnull(a.StatusCount, 0) = 1
									AND EXISTS (
										SELECT 1
										FROM dbo.ssf_RecodeValuesCurrent('ConcurrentStatus') C
										WHERE C.IntegerCodeId = P.[Status]
										)
									)
								THEN 8728
							END
						)
				FROM ProviderAuthorizations P
				LEFT JOIN #tempapprovedauth a ON a.clientid = P.clientid
					AND p.RequestedBillingCodeId = a.billingcodeid
					AND a.ProviderId = P.ProviderId
				WHERE isnull(P.RecordDeleted, 'N') = 'N'
					AND P.ClientId = @ClientId
					AND P.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId

				UPDATE AuthorizationRequests
				SET ProviderAuthorizationId = @ProviderAuthorizationId
				WHERE AuthorizationRequestId = @SUAuthorizationDocumentAuthorizationId

				DECLARE @formid INT

				SET @formid = (
						SELECT AuthorizationRequestFormId
						FROM billingCodes bc
						INNER JOIN AuthorizationRequests ar ON ar.BillingCodeId = bc.BillingCodeId
						WHERE isnull(bc.recordDeleted, 'N') = 'N'
							AND isnull(ar.recorddeleted, 'N') = 'N'
							AND ar.authorizationrequestid = @SUAuthorizationDocumentAuthorizationId
						)

				DECLARE @TableName VARCHAR(200)

				SET @TableName = (
						SELECT tablename
						FROM forms
						WHERE formid = @formid
							AND isnull(recorddeleted, 'N') = 'N'
						)

				DECLARE @str NVARCHAR(4000)

				SET @str = 'UPDATE ' + CAST(@TableName AS VARCHAR(max)) + ' SET ProviderAuthorizationId=' + CAST(@ProviderAuthorizationId AS VARCHAR) + ' WHERE AuthorizationRequestId=' + CAST(@SUAuthorizationDocumentAuthorizationId AS VARCHAR)

				EXECUTE SP_EXECUTESQL @str
			END

			FETCH NEXT
			FROM cur_CustomSUAuthorization
			INTO @SUAuthorizationDocumentAuthorizationId
				,@InsurerId
				,@ClientId
				,@ProviderId
				,@SiteId
				,@BillingCodeId
				,@Modifier1
				,@Modifier2
				,@Modifier3
				,@Modifier4
				,@StartDate
				,@EndDate
				,@BillingCodeId
				,@Units
				,@Frequency
				,@TotalUnits
				,@ModifiedBy
				,@ModifiedDate
				,@DocumentVersionId
				,@RequestedBillingCodeModifierId
				,--9th Aug 2016  shivanand
				@SUProviderAuthorizationId
				,@Status
				,@comment
		END

		CLOSE cur_CustomSUAuthorization

		DEALLOCATE cur_CustomSUAuthorization
			--declare @InsertedAuthDocId int
			--insert  into AuthorizationDocuments
			--        (StaffId,
			--         DocumentId,
			--         ProviderAuthorizationDocumentId,
			--         CreatedBy,
			--         CreatedDate,
			--         ModifiedBy,
			--         ModifiedDate)
			--values  (@StaffId,
			--         @Documentid,
			--         @ProviderAuthorizationDocumentId,
			--         @CurrentUser, 
			--         getdate(),
			--         @CurrentUser, 
			--         getdate() 
			--         )
			--set @InsertedAuthDocId = scope_identity() 
			--insert  into AuthorizationDocumentOtherDocuments
			--        (CreatedBy,
			--         CreatedDate,
			--         ModifiedBy,
			--         ModifiedDate,
			--         RecordDeleted,
			--         DocumentId,
			--         ProviderAuthorizationDocumentId,
			--         AuthorizationDocumentId)
			--values  (@CurrentUser, --current user
			--         getdate(),--Current date
			--         @CurrentUser, --current user
			--         getdate(),--Current date
			--         'N',
			--         @Documentid,
			--         @ProviderAuthorizationDocumentId,
			--         @InsertedAuthDocId)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateAuthorizationRequest') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
