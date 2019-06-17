/****** Object:  StoredProcedure [dbo].[ssp_SCCreateInternalCollections]    Script Date: 08/10/2015 19:38:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateInternalCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCreateInternalCollections]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCreateInternalCollections]    Script Date: 08/10/2015 19:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCreateInternalCollections] (@UserCode VARCHAR(30),@ClientIds VARCHAR(MAX),@ChargeIds VARCHAR(MAX)='')
	/********************************************************************************                                                    
-- Stored Procedure: ssp_SCCreateInternalCollections  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: To Create InternalCollections  
--  
-- Author: Vamsi   
-- Date:   10-AUG-2015  

*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CollectionStatus INT
		SELECT @CollectionStatus = GlobalCodeId
		FROM GlobalCodes
		WHERE ISNULL(Category, '') = 'COLLECTIONSTATUS'
			AND ISNULL(Code, '') = 'EIIC'
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND ISNULL(Active, 'N') = 'Y'
		
		IF OBJECT_ID('tempdb..#CollectionClients') IS NOT NULL
			DROP TABLE #CollectionClients
		CREATE TABLE #CollectionClients (ClientId INT)
		
		IF OBJECT_ID('tempdb..#Collections') IS NOT NULL
			DROP TABLE #Collections
		CREATE TABLE #Collections (CollectionId INT,ClientId INT)

		INSERT INTO #CollectionClients(ClientId)
		SELECT DISTINCT(item) FROM [dbo].fnSplit(@ClientIds, ',')
		
		IF ISNULL(@ClientIds,'') = '' AND ISNULL(@ChargeIds,'') <> ''
		BEGIN
			INSERT INTO #CollectionClients (ClientId)
			SELECT DISTINCT (S.ClientId)
			FROM Charges C
			JOIN Services S ON C.ServiceId = S.ServiceId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND C.ServiceId IS NOT NULL
			WHERE EXISTS (SELECT item FROM dbo.fnSplit(@ChargeIds, ',') WHERE item = C.ChargeId)				
		END
		
		UPDATE C
		SET C.InternalCollections = 'Y'
		FROM Clients C
		JOIN #CollectionClients CC ON CC.ClientId = C.ClientId
		WHERE ISNULL(C.RecordDeleted, 'N') = 'N'

		
		INSERT INTO Collections (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ClientId
			,CollectionStatus
			,PaymentArrangementActive
			)
		OUTPUT inserted.CollectionId,inserted.ClientId
		INTO #Collections(CollectionId,ClientId)
		SELECT @UserCode
			,GETDATE()
			,@UserCode
			,GETDATE()
			,ClientId
			,@CollectionStatus
			,'Y'
		FROM #CollectionClients
		
		INSERT INTO CollectionStatusHistory (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,CollectionId
			,CollectionDate
			,CollectionStatus
			,Balance
			,IsDeletable
			)
		SELECT @UserCode
			,GETDATE()
			,@UserCode
			,GETDATE()
			,IC.CollectionId
			,GETDATE()
			,@CollectionStatus
			,(SELECT TOP 1 ISNULL(C.CurrentBalance,0.00) FROM Clients C WHERE C.ClientId = IC.ClientId AND ISNULL(RecordDeleted, 'N') = 'N')
			,'N'
		FROM #Collections IC
		
		
		IF ISNULL(@ChargeIds,'') <> ''
		BEGIN		
			IF OBJECT_ID('tempdb..#InternalCollectionCharges') IS NOT NULL
				DROP TABLE #InternalCollectionCharges
			CREATE TABLE #InternalCollectionCharges (ClientId INT,ChargeId INT)
			
			INSERT INTO #InternalCollectionCharges(ClientId,ChargeId)
			SELECT DISTINCT S.ClientId,C.ChargeId
			FROM Charges C
			JOIN Services S ON C.ServiceId = S.ServiceId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND C.ServiceId IS NOT NULL
			WHERE EXISTS (SELECT item FROM dbo.fnSplit(@ChargeIds, ',') WHERE item = C.ChargeId)
		
			INSERT INTO [InternalCollectionCharges] (
				[CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[CollectionId]
				,[ChargeId]
				)
			SELECT @UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,C.CollectionId
				,CH.ChargeId
			FROM #Collections C			
			JOIN #InternalCollectionCharges CH ON C.ClientId = CH.ClientId
			WHERE NOT EXISTS(SELECT 1 FROM InternalCollectionCharges CCH WHERE CCH.CollectionId = C.CollectionId AND CCH.ChargeId = CH.ChargeId AND ISNULL(CCH.RecordDeleted,'N') = 'N')
			ORDER BY C.CollectionId ASC,C.ClientId ASC,CH.ChargeId ASC
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateInternalCollections') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


