/****** Object:  StoredProcedure [dbo].[ssp_SCManageAuthorizationChangeLog]    Script Date: 05/09/2017 14:45:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCManageAuthorizationChangeLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCManageAuthorizationChangeLog]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCManageAuthorizationChangeLog]    Script Date: 05/09/2017 14:45:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCManageAuthorizationChangeLog] 
	@AuthorizationDocumentId INT,
	@StaffId INT,
	@AuthorizationIds VARCHAR(MAX),
	@DeletedAuthorizationIds VARCHAR(MAX)
/********************************************************************************                                                        
-- Stored Procedure: ssp_SCManageAuthorizationChangeLog      
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Query to Manage Authorization Change Log.      
--      
-- Author:  Akwinass      
-- Date:    04 Feb 2015     
--      
-- *****History**** 
-- Date			Author    Purpose
-- 09/MAY/2017  Akwinass  Included "ssp_SCAuthorizationAssociateServices".(Task #980 in Key Point - Support Go Live)
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @UserCode VARCHAR(30)
		SELECT TOP 1 @UserCode = UserCode FROM Staff WHERE StaffId = @StaffId

		DECLARE @ClientCoveragePlanId INT
		CREATE TABLE #Authorizations(AuthorizationId INT,ClientCoveragePlanId INT,CreatedBy VARCHAR(30),CreatedDate DATETIME,ModifiedBy VARCHAR(30),ModifiedDate DATETIME,RecordDeleted CHAR(1),DeletedDate DATETIME,DeletedBy VARCHAR(30),AuthorizationDocumentId INT,AuthorizationNumber VARCHAR(35),AuthorizationCodeId INT,[Status] INT,TPProcedureId INT,Units DECIMAL(18, 2),Frequency INT,StartDate DATETIME,EndDate DATETIME,TotalUnits DECIMAL(18, 2),StaffId INT,UnitsRequested DECIMAL(18, 2),FrequencyRequested INT,StartDateRequested DATETIME,EndDateRequested DATETIME,TotalUnitsRequested DECIMAL(18, 2),StaffIdRequested INT,ProviderId INT,SiteId INT,DateRequested DATETIME,DateReceived DATETIME,UnitsUsed DECIMAL(18, 2),StartDateUsed DATETIME,EndDateUsed DATETIME,UnitsScheduled DECIMAL(18, 2),ProviderAuthorizationId INT,Urgent CHAR(1),ReviewLevel INT,ReviewerId INT,ReviewerOther VARCHAR(100),ReviewedOn DATETIME,Rationale VARCHAR(max))
		CREATE TABLE #DeletedAuthorizations(AuthorizationId INT,ClientCoveragePlanId INT,CreatedBy VARCHAR(30),CreatedDate DATETIME,ModifiedBy VARCHAR(30),ModifiedDate DATETIME,RecordDeleted CHAR(1),DeletedDate DATETIME,DeletedBy VARCHAR(30),AuthorizationDocumentId INT,AuthorizationNumber VARCHAR(35),AuthorizationCodeId INT,[Status] INT,TPProcedureId INT,Units DECIMAL(18, 2),Frequency INT,StartDate DATETIME,EndDate DATETIME,TotalUnits DECIMAL(18, 2),StaffId INT,UnitsRequested DECIMAL(18, 2),FrequencyRequested INT,StartDateRequested DATETIME,EndDateRequested DATETIME,TotalUnitsRequested DECIMAL(18, 2),StaffIdRequested INT,ProviderId INT,SiteId INT,DateRequested DATETIME,DateReceived DATETIME,UnitsUsed DECIMAL(18, 2),StartDateUsed DATETIME,EndDateUsed DATETIME,UnitsScheduled DECIMAL(18, 2),ProviderAuthorizationId INT,Urgent CHAR(1),ReviewLevel INT,ReviewerId INT,ReviewerOther VARCHAR(100),ReviewedOn DATETIME,Rationale VARCHAR(max))
		CREATE TABLE #AuthorizationChangeLog(AuthorizationId INT,ClientCoveragePlanId INT,AuthorizationDocumentId INT,AuthorizationCodeId INT,UnitsRequested DECIMAL(18, 2),StartDateRequested DATETIME,EndDateRequested DATETIME,FrequencyRequested INT,TotalUnitsRequested DECIMAL(18, 2),Units DECIMAL(18, 2),StartDate DATETIME,EndDate DATETIME,Frequency INT,TotalUnits DECIMAL(18, 2),AuthorizationNumber VARCHAR(35),[Status] INT,Rationale VARCHAR(max),CreatedStaffId INT,ModifiedStaffId INT,DeletedStaffId INT)
		CREATE TABLE #DeletedAuthorizationChangeLog(AuthorizationId INT,ClientCoveragePlanId INT,AuthorizationDocumentId INT,AuthorizationCodeId INT,UnitsRequested DECIMAL(18, 2),StartDateRequested DATETIME,EndDateRequested DATETIME,FrequencyRequested INT,TotalUnitsRequested DECIMAL(18, 2),Units DECIMAL(18, 2),StartDate DATETIME,EndDate DATETIME,Frequency INT,TotalUnits DECIMAL(18, 2),AuthorizationNumber VARCHAR(35),[Status] INT,Rationale VARCHAR(max),CreatedStaffId INT,ModifiedStaffId INT,DeletedStaffId INT)
		
		SELECT TOP 1 @ClientCoveragePlanId = ClientCoveragePlanId
		FROM AuthorizationDocuments
		WHERE AuthorizationDocumentId = @AuthorizationDocumentId

		INSERT INTO #Authorizations(AuthorizationId,ClientCoveragePlanId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,AuthorizationDocumentId,AuthorizationNumber,AuthorizationCodeId,[Status],TPProcedureId,Units,Frequency,StartDate,EndDate,TotalUnits,StaffId,UnitsRequested,FrequencyRequested,StartDateRequested,EndDateRequested,TotalUnitsRequested,StaffIdRequested,ProviderId,SiteId,DateRequested,DateReceived,UnitsUsed,StartDateUsed,EndDateUsed,UnitsScheduled,ProviderAuthorizationId,Urgent,ReviewLevel,ReviewerId,ReviewerOther,ReviewedOn,Rationale)
		SELECT AuthorizationId,@ClientCoveragePlanId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,AuthorizationDocumentId,AuthorizationNumber,AuthorizationCodeId,[Status],TPProcedureId,Units,Frequency,StartDate,EndDate,TotalUnits,StaffId,UnitsRequested,FrequencyRequested,StartDateRequested,EndDateRequested,TotalUnitsRequested,StaffIdRequested,ProviderId,SiteId,DateRequested,DateReceived,UnitsUsed,StartDateUsed,EndDateUsed,UnitsScheduled,ProviderAuthorizationId,Urgent,ReviewLevel,ReviewerId,ReviewerOther,ReviewedOn,Rationale
		FROM Authorizations
		WHERE AuthorizationId IN (SELECT Value FROM [dbo].[fn_CommaSeparatedStringToTable](@AuthorizationIds,'N'))
		ORDER BY AuthorizationId ASC
		
		INSERT INTO #DeletedAuthorizations(AuthorizationId,ClientCoveragePlanId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,AuthorizationDocumentId,AuthorizationNumber,AuthorizationCodeId,[Status],TPProcedureId,Units,Frequency,StartDate,EndDate,TotalUnits,StaffId,UnitsRequested,FrequencyRequested,StartDateRequested,EndDateRequested,TotalUnitsRequested,StaffIdRequested,ProviderId,SiteId,DateRequested,DateReceived,UnitsUsed,StartDateUsed,EndDateUsed,UnitsScheduled,ProviderAuthorizationId,Urgent,ReviewLevel,ReviewerId,ReviewerOther,ReviewedOn,Rationale)
		SELECT AuthorizationId,@ClientCoveragePlanId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,AuthorizationDocumentId,AuthorizationNumber,AuthorizationCodeId,[Status],TPProcedureId,Units,Frequency,StartDate,EndDate,TotalUnits,StaffId,UnitsRequested,FrequencyRequested,StartDateRequested,EndDateRequested,TotalUnitsRequested,StaffIdRequested,ProviderId,SiteId,DateRequested,DateReceived,UnitsUsed,StartDateUsed,EndDateUsed,UnitsScheduled,ProviderAuthorizationId,Urgent,ReviewLevel,ReviewerId,ReviewerOther,ReviewedOn,Rationale
		FROM Authorizations
		WHERE AuthorizationId IN (SELECT Value FROM [dbo].[fn_CommaSeparatedStringToTable](@DeletedAuthorizationIds,'N'))
		ORDER BY AuthorizationId ASC

		INSERT INTO #AuthorizationChangeLog (AuthorizationId,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,UnitsRequested,StartDateRequested,EndDateRequested,FrequencyRequested,TotalUnitsRequested,Units,StartDate,EndDate,Frequency,TotalUnits,AuthorizationNumber,[Status],Rationale,CreatedStaffId,ModifiedStaffId,DeletedStaffId)
		SELECT AuthorizationId,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,UnitsRequested,StartDateRequested,EndDateRequested,FrequencyRequested,TotalUnitsRequested,Units,StartDate,EndDate,Frequency,TotalUnits,AuthorizationNumber,[Status],Rationale,CreatedStaffId,ModifiedStaffId,DeletedStaffId
		FROM AuthorizationChangeLog
		WHERE AuthorizationId IN (SELECT Value FROM [dbo].[fn_CommaSeparatedStringToTable](@AuthorizationIds,'N'))
		ORDER BY AuthorizationId ASC
		
		INSERT INTO #DeletedAuthorizationChangeLog (AuthorizationId,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,UnitsRequested,StartDateRequested,EndDateRequested,FrequencyRequested,TotalUnitsRequested,Units,StartDate,EndDate,Frequency,TotalUnits,AuthorizationNumber,[Status],Rationale,CreatedStaffId,ModifiedStaffId,DeletedStaffId)
		SELECT AuthorizationId,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,UnitsRequested,StartDateRequested,EndDateRequested,FrequencyRequested,TotalUnitsRequested,Units,StartDate,EndDate,Frequency,TotalUnits,AuthorizationNumber,[Status],Rationale,CreatedStaffId,ModifiedStaffId,DeletedStaffId
		FROM AuthorizationChangeLog
		WHERE AuthorizationId IN (SELECT Value FROM [dbo].[fn_CommaSeparatedStringToTable](@DeletedAuthorizationIds,'N'))
		ORDER BY AuthorizationId ASC

		CREATE TABLE #AssociateAuthorization(AuthorizationId INT)
		
		INSERT INTO AuthorizationChangeLog(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,StaffId,StaffIdRequested,ProviderId,SiteId,ReviewerId,AuthorizationId,CreatedStaffId,ModifiedStaffId,DeletedStaffId,TPProcedureId,ProviderAuthorizationId,AuthorizationNumber,[Status],Units,Frequency,StartDate,EndDate,TotalUnits,UnitsRequested,FrequencyRequested,StartDateRequested,EndDateRequested,TotalUnitsRequested,DateRequested,DateReceived,UnitsUsed,StartDateUsed,EndDateUsed,UnitsScheduled,Urgent,ReviewLevel,ReviewerOther,ReviewedOn,Rationale)
		SELECT ISNULL(S1.UserCode,@UserCode),AU.CreatedDate,ISNULL(S2.UserCode,@UserCode),AU.ModifiedDate,AU.RecordDeleted,ISNULL(S3.UserCode,@UserCode),AU.DeletedDate,AU.ClientCoveragePlanId,AU.AuthorizationDocumentId,AU.AuthorizationCodeId,AU.StaffId,AU.StaffIdRequested,AU.ProviderId,AU.SiteId,AU.ReviewerId,AU.AuthorizationId,ISNULL(S1.StaffId,@StaffId),NULL,NULL,AU.TPProcedureId,AU.ProviderAuthorizationId,AU.AuthorizationNumber,AU.[Status],AU.Units,AU.Frequency,AU.StartDate,AU.EndDate,AU.TotalUnits,AU.UnitsRequested,AU.FrequencyRequested,AU.StartDateRequested,AU.EndDateRequested,AU.TotalUnitsRequested,AU.DateRequested,AU.DateReceived,AU.UnitsUsed,AU.StartDateUsed,AU.EndDateUsed,AU.UnitsScheduled,AU.Urgent,AU.ReviewLevel,AU.ReviewerOther,AU.ReviewedOn,AU.Rationale
		FROM #Authorizations AU
		LEFT JOIN #AuthorizationChangeLog ACH ON AU.AuthorizationId = ACH.AuthorizationId
		LEFT JOIN Staff S1 ON AU.CreatedBy = S1.UserCode AND ISNULL(S1.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S2 ON AU.ModifiedBy = S2.UserCode AND ISNULL(S2.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S3 ON AU.DeletedBy = S3.UserCode AND ISNULL(S3.RecordDeleted,'N') = 'N'
		WHERE ACH.AuthorizationId IS NULL
		
		INSERT INTO #AssociateAuthorization(AuthorizationId) -- 09/MAY/2017  Akwinass
		SELECT DISTINCT AU.AuthorizationId
		FROM #Authorizations AU
		LEFT JOIN #AuthorizationChangeLog ACH ON AU.AuthorizationId = ACH.AuthorizationId
		LEFT JOIN Staff S1 ON AU.CreatedBy = S1.UserCode AND ISNULL(S1.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S2 ON AU.ModifiedBy = S2.UserCode AND ISNULL(S2.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S3 ON AU.DeletedBy = S3.UserCode AND ISNULL(S3.RecordDeleted,'N') = 'N'
		WHERE ACH.AuthorizationId IS NULL
		  AND EXISTS(SELECT 1 FROM Authorizations AAU WHERE AAU.AuthorizationId = AU.AuthorizationId AND ISNULL(AAU.RecordDeleted,'N') = 'N')
		
		INSERT INTO AuthorizationChangeLog(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,StaffId,StaffIdRequested,ProviderId,SiteId,ReviewerId,AuthorizationId,CreatedStaffId,ModifiedStaffId,DeletedStaffId,TPProcedureId,ProviderAuthorizationId,AuthorizationNumber,[Status],Units,Frequency,StartDate,EndDate,TotalUnits,UnitsRequested,FrequencyRequested,StartDateRequested,EndDateRequested,TotalUnitsRequested,DateRequested,DateReceived,UnitsUsed,StartDateUsed,EndDateUsed,UnitsScheduled,Urgent,ReviewLevel,ReviewerOther,ReviewedOn,Rationale)
		SELECT DISTINCT ISNULL(S1.UserCode,@UserCode),AU.CreatedDate,ISNULL(S2.UserCode,@UserCode),AU.ModifiedDate,AU.RecordDeleted,ISNULL(S3.UserCode,@UserCode),AU.DeletedDate,AU.ClientCoveragePlanId,AU.AuthorizationDocumentId,AU.AuthorizationCodeId,AU.StaffId,AU.StaffIdRequested,AU.ProviderId,AU.SiteId,AU.ReviewerId,AU.AuthorizationId,NULL,NULL,ISNULL(S3.StaffId,@StaffId),AU.TPProcedureId,AU.ProviderAuthorizationId,AU.AuthorizationNumber,AU.[Status],AU.Units,AU.Frequency,AU.StartDate,AU.EndDate,AU.TotalUnits,AU.UnitsRequested,AU.FrequencyRequested,AU.StartDateRequested,AU.EndDateRequested,AU.TotalUnitsRequested,AU.DateRequested,AU.DateReceived,AU.UnitsUsed,AU.StartDateUsed,AU.EndDateUsed,AU.UnitsScheduled,AU.Urgent,AU.ReviewLevel,AU.ReviewerOther,AU.ReviewedOn,AU.Rationale	
		FROM #DeletedAuthorizations AU
		LEFT JOIN #DeletedAuthorizationChangeLog ACH ON AU.AuthorizationId = ACH.AuthorizationId
		LEFT JOIN Staff S1 ON AU.CreatedBy = S1.UserCode AND ISNULL(S1.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S2 ON AU.ModifiedBy = S2.UserCode AND ISNULL(S2.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S3 ON AU.DeletedBy = S3.UserCode AND ISNULL(S3.RecordDeleted,'N') = 'N'
		WHERE (ACH.AuthorizationId IS NULL) OR (ACH.AuthorizationId IS NOT NULL AND ACH.DeletedStaffId IS NULL)
				
		DELETE FROM #AuthorizationChangeLog
		
		INSERT INTO #AuthorizationChangeLog (AuthorizationId,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,UnitsRequested,StartDateRequested,EndDateRequested,FrequencyRequested,TotalUnitsRequested,Units,StartDate,EndDate,Frequency,TotalUnits,AuthorizationNumber,[Status],Rationale,CreatedStaffId,ModifiedStaffId,DeletedStaffId)
		SELECT AuthorizationId,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,UnitsRequested,StartDateRequested,EndDateRequested,FrequencyRequested,TotalUnitsRequested,Units,StartDate,EndDate,Frequency,TotalUnits,AuthorizationNumber,[Status],Rationale,CreatedStaffId,ModifiedStaffId,DeletedStaffId
		FROM AuthorizationChangeLog 
		WHERE AuthorizationChangeLogId IN (
				SELECT t.AuthorizationChangeLogId
				FROM (
					SELECT AuthorizationChangeLogId
						,rowid = ROW_NUMBER() OVER (PARTITION BY AuthorizationId ORDER BY ModifiedDate DESC,CreatedDate DESC)
					FROM AuthorizationChangeLog
					WHERE AuthorizationId NOT IN (SELECT AuthorizationId FROM AuthorizationChangeLog WHERE ISNULL(RecordDeleted, 'N') = 'Y' AND AuthorizationDocumentId = @AuthorizationDocumentId)
						AND AuthorizationId IN (SELECT Value FROM [dbo].[fn_CommaSeparatedStringToTable](@AuthorizationIds, 'N'))
					) t
				WHERE rowid < 2
			  )
		
		INSERT INTO AuthorizationChangeLog(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate,ClientCoveragePlanId,AuthorizationDocumentId,AuthorizationCodeId,StaffId,StaffIdRequested,ProviderId,SiteId,ReviewerId,AuthorizationId,CreatedStaffId,ModifiedStaffId,DeletedStaffId,TPProcedureId,ProviderAuthorizationId,AuthorizationNumber,[Status],Units,Frequency,StartDate,EndDate,TotalUnits,UnitsRequested,FrequencyRequested,StartDateRequested,EndDateRequested,TotalUnitsRequested,DateRequested,DateReceived,UnitsUsed,StartDateUsed,EndDateUsed,UnitsScheduled,Urgent,ReviewLevel,ReviewerOther,ReviewedOn,Rationale)
		SELECT ISNULL(S1.UserCode,@UserCode),AU.CreatedDate,ISNULL(S2.UserCode,@UserCode),AU.ModifiedDate,AU.RecordDeleted,ISNULL(S3.UserCode,@UserCode),AU.DeletedDate,AU.ClientCoveragePlanId,AU.AuthorizationDocumentId,AU.AuthorizationCodeId,AU.StaffId,AU.StaffIdRequested,AU.ProviderId,AU.SiteId,AU.ReviewerId,AU.AuthorizationId,NULL,ISNULL(S1.StaffId,@StaffId),NULL,AU.TPProcedureId,AU.ProviderAuthorizationId,AU.AuthorizationNumber,AU.[Status],AU.Units,AU.Frequency,AU.StartDate,AU.EndDate,AU.TotalUnits,AU.UnitsRequested,AU.FrequencyRequested,AU.StartDateRequested,AU.EndDateRequested,AU.TotalUnitsRequested,AU.DateRequested,AU.DateReceived,AU.UnitsUsed,AU.StartDateUsed,AU.EndDateUsed,AU.UnitsScheduled,AU.Urgent,AU.ReviewLevel,AU.ReviewerOther,AU.ReviewedOn,AU.Rationale
		FROM #Authorizations AU
		LEFT JOIN #AuthorizationChangeLog ACH ON AU.AuthorizationId = ACH.AuthorizationId
		LEFT JOIN Staff S1 ON AU.CreatedBy = S1.UserCode AND ISNULL(S1.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S2 ON AU.ModifiedBy = S2.UserCode AND ISNULL(S2.RecordDeleted,'N') = 'N'
		LEFT JOIN Staff S3 ON AU.DeletedBy = S3.UserCode AND ISNULL(S3.RecordDeleted,'N') = 'N'
		WHERE ACH.AuthorizationId IS NOT NULL
			AND (
				AU.ClientCoveragePlanId <> ACH.ClientCoveragePlanId
				OR AU.AuthorizationCodeId <> ACH.AuthorizationCodeId
				OR AU.UnitsRequested <> ACH.UnitsRequested
				OR AU.StartDateRequested <> ACH.StartDateRequested
				OR AU.EndDateRequested <> ACH.EndDateRequested
				OR AU.FrequencyRequested <> ACH.FrequencyRequested
				OR AU.TotalUnitsRequested <> ACH.TotalUnitsRequested
				OR AU.Units <> ACH.Units
				OR AU.StartDate <> ACH.StartDate
				OR AU.EndDate <> ACH.EndDate
				OR AU.Frequency <> ACH.Frequency
				OR AU.TotalUnits <> ACH.TotalUnits
				OR AU.AuthorizationNumber <> ACH.AuthorizationNumber
				OR AU.[Status] <> ACH.[Status]
				OR AU.Rationale <> ACH.Rationale
				)
		
		-- 09/MAY/2017  Akwinass		
		INSERT INTO #AssociateAuthorization(AuthorizationId)
		SELECT DISTINCT AU.AuthorizationId
		FROM #Authorizations AU
		LEFT JOIN #AuthorizationChangeLog ACH ON AU.AuthorizationId = ACH.AuthorizationId
		LEFT JOIN Staff S1 ON AU.CreatedBy = S1.UserCode
			AND ISNULL(S1.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S2 ON AU.ModifiedBy = S2.UserCode
			AND ISNULL(S2.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S3 ON AU.DeletedBy = S3.UserCode
			AND ISNULL(S3.RecordDeleted, 'N') = 'N'
		WHERE ACH.AuthorizationId IS NOT NULL
			AND (AU.StartDate <> ACH.StartDate OR AU.EndDate <> ACH.EndDate)
			AND EXISTS(SELECT 1 FROM Authorizations AAU WHERE AAU.AuthorizationId = AU.AuthorizationId AND ISNULL(AAU.RecordDeleted,'N') = 'N')
	
		DECLARE @AuthorizationId INT		
		DECLARE AssociateServices_cursor CURSOR FAST_FORWARD
		FOR
		SELECT DISTINCT AuthorizationId
		FROM #AssociateAuthorization

		OPEN AssociateServices_cursor
		FETCH NEXT FROM AssociateServices_cursor INTO @AuthorizationId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
				EXEC ssp_SCAuthorizationAssociateServices @UserCode,@AuthorizationId
			END TRY
			BEGIN CATCH
				PRINT 'ERROR'
			END CATCH
			FETCH NEXT FROM AssociateServices_cursor INTO @AuthorizationId
		END
		CLOSE AssociateServices_cursor
		DEALLOCATE AssociateServices_cursor

		IF OBJECT_ID('tempdb..#Authorizations') IS NOT NULL
			DROP TABLE #Authorizations
		IF OBJECT_ID('tempdb..#DeletedAuthorizations') IS NOT NULL
			DROP TABLE #DeletedAuthorizations
		IF OBJECT_ID('tempdb..#AuthorizationChangeLog') IS NOT NULL
			DROP TABLE #AuthorizationChangeLog
		IF OBJECT_ID('tempdb..#DeletedAuthorizationChangeLog') IS NOT NULL
			DROP TABLE #DeletedAuthorizationChangeLog
		IF OBJECT_ID('tempdb..#AssociateAuthorization') IS NOT NULL
			DROP TABLE #AssociateAuthorization	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCManageAuthorizationChangeLog') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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