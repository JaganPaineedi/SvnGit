IF  EXISTS (SELECT * 
			FROM sys.objects 
			WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateCMAuthorizationFlags]') 
					AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_UpdateCMAuthorizationFlags]
GO

CREATE PROCEDURE [dbo].[ssp_UpdateCMAuthorizationFlags]
AS
BEGIN
	BEGIN TRY
		DECLARE @TimeOfLastRun		DATETIME

		IF EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [Key] = 'UrgentFlagsTimeOfLastRun')
		BEGIN
			SELECT @TimeOfLastRun = CONVERT(VARCHAR(20), ISNULL(Value, '2000-01-01'), 100) 
			FROM SystemConfigurationKeys 
			WHERE [Key] = 'UrgentFlagsTimeOfLastRun'
		END
		ELSE
		BEGIN
			SELECT @TimeOfLastRun = '2000-01-01'
		END



		--------------------------------- BEGIN Urgent Flags ---------------------------------
		-- Temp table for flags that already exist in ObjectFlags
		CREATE TABLE #UrgentFlagExists
		(
			AuthorizationSetId			INT IDENTITY NOT NULL
			,ProviderAuthorizationId	INT
			,Status		INT
			,Urgent		VARCHAR(1)
		)
		INSERT INTO #UrgentFlagExists
		SELECT	ProviderAuthorizationId
				,Status
				,Urgent
		FROM	ProviderAuthorizations PA
		WHERE 	EXISTS(SELECT 1 FROM ObjectFlags O where PA.ProviderAuthorizationId = O.IdentityId AND O.FlagTypeId = 10647)
				AND ISNULL(PA.RecordDeleted, 'N') = 'N'
				AND PA.ModifiedDate > @TimeOfLastRun --records modified since last run 


		-- Temp table for flags that need to be created
		CREATE TABLE #UrgentAndFlagDoesNotExist
		(
			AuthorizationSetId			INT IDENTITY NOT NULL
			,ProviderAuthorizationId	INT
			,Status		INT
			,Urgent		VARCHAR(1)
		)
		INSERT INTO #UrgentAndFlagDoesNotExist
		SELECT	ProviderAuthorizationId
				,Status
				,Urgent
		FROM	ProviderAuthorizations PA
		WHERE	ISNULL(PA.Urgent, 'N')='Y'
				AND NOT EXISTS(SELECT 1 FROM ObjectFlags O where PA.ProviderAuthorizationId = O.IdentityId AND O.FlagTypeId = 10647)
				AND ISNULL(PA.RecordDeleted, 'N') = 'N'
				AND PA.ModifiedDate > @TimeOfLastRun


		-- Update existing urgent flags
		UPDATE O
		SET O.Active = UFE.Urgent
		FROM	ObjectFlags O
				INNER JOIN #UrgentFlagExists UFE ON UFE.ProviderAuthorizationId = O.IdentityId
		WHERE O.FlagTypeId = 10647


		-- Insert new flags
		INSERT INTO ObjectFlags
		(
			TableNameOfObject
			,IdentityId
			,FlagTypeId
			,Note
			,Active
			,StartDate
			,EndDate
			,Comment
		)
		SELECT	'ProviderAuthorizations'
				,UFDNE.ProviderAuthorizationId
				,10647
				,'Urgent'
				,'Y'
				,GETDATE()
				,NULL
				,'Urgent Flag'
		FROM #UrgentAndFlagDoesNotExist UFDNE

		drop table #UrgentFlagExists, #UrgentAndFlagDoesNotExist
		--------------------------------- END Urgent Flags ---------------------------------



		--------------------------------- BEGIN Pended Flags ---------------------------------
		----- BEGIN ACTIVE BUT NOT PENDED -----
		UPDATE O
		SET O.Active = 'N'
		FROM	ObjectFlags O
				INNER JOIN ProviderAuthorizations PA ON PA.ProviderAuthorizationId = O.IdentityId
		WHERE	ISNULL(PA.RecordDeleted, 'N') = 'N'
				AND PA.Status <> 2045
				AND (
					O.FlagTypeId = 46862
					OR O.FlagTypeId = 46861
				)
				AND O.Active = 'Y'
				AND PA.ModifiedDate > @TimeOfLastRun
		----- END ACTIVE BUT NOT PENDED -----
		----- BEGIN PENDED AND FLAG EXISTS -----
		-- Get Authorizations that are pended, and an object flag already exists for them
		CREATE TABLE #PendedAndFlagExists
		(
			#PendedAndFlagExistsId	INT IDENTITY NOT NULL
			,ProviderAuthorizationId	INT
			,ModifiedDate	DATETIME NULL
		)

		INSERT INTO #PendedAndFlagExists
		SELECT	PA.ProviderAuthorizationId
				,NULL AS ModifiedDate
		FROM	ProviderAuthorizations PA
				INNER JOIN ObjectFlags O ON O.IdentityId = PA.ProviderAuthorizationId
		WHERE	ISNULL(PA.RecordDeleted, 'N') = 'N'
				AND PA.Status = 2045
				AND (
					O.FlagTypeId = 46862
					OR O.FlagTypeId = 46861
				)
		
		-- Get histories for each authorization
		CREATE TABLE #PendedAndFlagExistsHistories
		(
			RowNum	INT	IDENTITY NOT NULL
			,ProviderAuthorizationHistoryId	INT
			,ProviderAuthorizationId	INT
			,Status	INT
			,ModifiedDate DATETIME -- Date Pended
		)
		INSERT INTO #PendedAndFlagExistsHistories
		SELECT 
				PAH.ProviderAuthorizationHistoryId
				,PAH.ProviderAuthorizationId
				,PAH.Status
				,PAH.CreatedDate
		FROM ProviderAuthorizationsHistory PAH
				INNER JOIN #PendedAndFlagExists P ON P.ProviderAuthorizationId = PAH.ProviderAuthorizationId
		ORDER BY PAH.ProviderAuthorizationId


		-- Get the pended date for each authorization
		CREATE TABLE #PendedAndFlagExistsDates
		(
			PendedAuthorizationHistoryId		INT
			,ProviderAuthorizationId			INT
			,PendedDate							DATETIME
			,DaysSincePended					INT
		)
		INSERT INTO #PendedAndFlagExistsDates
		SELECT	MAX(PH.ProviderAuthorizationHistoryId) AS PAHistoryId
				,PH.ProviderAuthorizationId
				,MAX(PH.ModifiedDate) AS PendedDate
				,DATEDIFF(dd, MAX(PH.ModifiedDate), GETDATE()) AS DaysSincePended
		FROM #PendedAndFlagExistsHistories PH
		LEFT JOIN #PendedAndFlagExistsHistories prev ON prev.RowNum = PH.RowNum - 1 AND prev.ProviderAuthorizationId = PH.ProviderAuthorizationId   -- The history row BEFORE
		LEFT JOIN #PendedAndFlagExistsHistories nxt ON nxt.RowNum = PH.RowNum + 1 AND nxt.ProviderAuthorizationId = PH.ProviderAuthorizationId      -- The history row AFTER
		WHERE	PH.Status = 2045
				AND ISNULL(nxt.Status, 2045) = 2045 -- It will either be the final row in history (nxt is NULL) or the first in a series where status is pended
				AND ISNULL(prev.Status, -1) != 2045 -- The status before this must be something other than pended
		GROUP BY PH.ProviderAuthorizationId

		--update existing flags
		update O
		SET O.Active = CASE WHEN PAFED.DaysSincePended >= 10 THEN 'Y'
							ELSE 'N' 
							END
			,O.FlagTypeId =	CASE WHEN PAFED.DaysSincePended >= 10 AND PAFED.DaysSincePended <= 12 THEN  46862
								 WHEN PAFED.DaysSincePended > 12 THEN 46861
								 ELSE O.FlagTypeId
								 END
            ,O.Note = CONVERT(VARCHAR, PAFED.PendedDate, 101)
			,O.Comment = CASE WHEN PAFED.DaysSincePended >= 10 AND PAFED.DaysSincePended <= 12 THEN  'Orange Pended Flag'
								 WHEN PAFED.DaysSincePended > 12 THEN 'Red Pended Flag'
								 ELSE O.Comment
								 END
		FROM ObjectFlags O
				INNER JOIN #PendedAndFlagExistsDates PAFED ON PAFED.ProviderAuthorizationId = O.IdentityId
				LEFT JOIN ProviderAuthorizations PA ON PA.ProviderAuthorizationId = O.IdentityId
		WHERE O.FlagTypeId = 46862
				OR O.FlagTypeId = 46861

		drop table #PendedAndFlagExists, #PendedAndFlagExistsHistories, #PendedAndFlagExistsDates
		----- END PENDED AND FLAG EXISTS -----

		----- BEGIN PENDED AND FLAG DOES NOT EXIST -----
		CREATE TABLE #PendedNoFlag
		(
			#PendedAndFlagExistsId	INT IDENTITY NOT NULL
			,ProviderAuthorizationId	INT
		)

		INSERT INTO #PendedNoFlag
		SELECT PA.ProviderAuthorizationId
		FROM ProviderAuthorizations PA
		WHERE	ISNULL(PA.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS(SELECT 1 FROM ObjectFlags O WHERE O.IdentityId = PA.ProviderAuthorizationId AND (O.FlagTypeId = 46862 OR O.FlagTypeId = 46861))
				AND PA.Status = 2045
		

		CREATE TABLE #PendedHistories
		(
			RowNum	INT	IDENTITY NOT NULL
			,ProviderAuthorizationHistoryId	INT
			,ProviderAuthorizationId	INT
			,Status	INT
			,ModifiedDate DATETIME -- Date Pended
		)
		INSERT INTO #PendedHistories
		SELECT PAH.ProviderAuthorizationHistoryId
				,PAH.ProviderAuthorizationId
				,PAH.Status
				,PAH.CreatedDate
		FROM ProviderAuthorizationsHistory PAH
				INNER JOIN #PendedNoFlag PNF ON PNF.ProviderAuthorizationId = PAH.ProviderAuthorizationId
		ORDER BY PAH.ProviderAuthorizationId

		CREATE TABLE #PendedDates
		(
			PendedAuthorizationHistoryId		INT
			,ProviderAuthorizationId			INT
			,PendedDate							DATETIME
			,DaysSincePended					INT
		)
		INSERT INTO #PendedDates
		SELECT	MAX(PH.ProviderAuthorizationHistoryId) AS PAHistoryId
				,PH.ProviderAuthorizationId
				,MAX(PH.ModifiedDate) AS PendedDate
				,DATEDIFF(dd, MAX(PH.ModifiedDate), GETDATE()) AS DaysSincePended
		FROM #PendedHistories PH
		LEFT JOIN #PendedHistories prev ON prev.RowNum = PH.RowNum - 1 AND prev.ProviderAuthorizationId = PH.ProviderAuthorizationId -- The history row BEFORE
		LEFT JOIN #PendedHistories nxt ON nxt.RowNum = PH.RowNum + 1 AND nxt.ProviderAuthorizationId = PH.ProviderAuthorizationId    -- The history row AFTER
		WHERE	PH.Status = 2045
				AND ISNULL(nxt.Status, 2045) = 2045 -- It must either be the final row in history (nxt is NULL) or the first in a series where status is pended
				AND ISNULL(prev.Status, -1) != 2045 -- The status before this must be something other than pended
		GROUP BY PH.ProviderAuthorizationId

		-- Create flags
		INSERT INTO ObjectFlags
		(
			TableNameOfObject
			,IdentityId
			,FlagTypeId
			,Note
			,Active
			,StartDate
			,EndDate
			,Comment
		)
		Select	'ProviderAuthorizations' AS TableNameOfObject
				,PD.ProviderAuthorizationId AS IdentityId
				,CASE WHEN PD.DaysSincePended >= 10 AND PD.DaysSincePended <= 12 THEN  46862
					ELSE 46861 END AS FlagTypeId
                ,CONVERT(VARCHAR, PD.PendedDate, 101) AS Note
				,'Y' AS Active
				,GETDATE() AS StartDate
				,NULL AS EndDate
				,CASE WHEN PD.DaysSincePended >= 10 AND PD.DaysSincePended <= 12 THEN  'Orange Pended Flag'
					ELSE 'Red Pended Flag' END AS Comment
		FROM #PendedDates PD
				LEFT JOIN ProviderAuthorizations PA ON PA.ProviderAuthorizationId = PD.ProviderAuthorizationId
		WHERE PD.DaysSincePended >= 10




		--SELECT * FROM #PendedNoFlag
		--SELECT * FROM #PendedHistories
		--SELECT * FROM #PendedDates

		DROP TABLE #PendedNoFlag, #PendedHistories, #PendedDates

		----- END PENDED AND FLAG DOES NOT EXIST -----
		--------------------------------- END Pended Flags ---------------------------------


		UPDATE SystemConfigurationKeys
		SET Value = CONVERT(VARCHAR, GETDATE(), 120)
		WHERE [Key] = 'UrgentFlagsTimeOfLastRun'

	END TRY
	BEGIN CATCH
        DECLARE @Error VARCHAR(8000)

        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_UpdateCMAuthorizationFlags') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

        RAISERROR (
			@Error
			,-- Message text.        
			16
			,-- Severity.        
			1 -- State.        
			);
    END CATCH
END