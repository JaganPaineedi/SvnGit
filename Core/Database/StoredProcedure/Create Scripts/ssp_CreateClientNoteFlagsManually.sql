/****** Object:  StoredProcedure [dbo].[ssp_CreateClientNoteFlagsManually]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreateClientNoteFlagsManually]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CreateClientNoteFlagsManually]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CreateClientNoteFlagsManually]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CreateClientNoteFlagsManually]
(@ClientId INT,
@TrackingProtocolId INT,
@OpenDate DATETIME,
@UserCode VARCHAR(100)
 )  
AS
/************************************************************************************************                                            
  -- Stored Procedure: dbo.ssp_ListPageGetClientTracking                    
  -- Copyright: Streamline Healthcate Solutions                    
  -- Purpose: Client Tracking List Page                  
  -- Updates:                    
  -- Date           Author            Purpose       
  -- July 10 2018   Vijay			  Why:This ssp is for creating flags(manually)
									  What:Engineering Improvement Initiatives- NBL(I) - Task#590
  *************************************************************************************************/  
BEGIN
	BEGIN TRY
		CREATE TABLE #TrackingProtocolList (
			TrackingProtocolId INT
			,TrackingProtocolFlagId INT
			,CreateProtocol VARCHAR(250)
			,FlagTypeId INT
			,Note VARCHAR(500)
			,StartDate DATETIME
			--,EndDate DATETIME
			,DocumentCodeId INT
			,DueDateUnits INT
			,DueDateUnitType VARCHAR(250)
			,FirstDueDate VARCHAR(250)
			,FirstDueDateDays INT
			,DueDateStartDays INT
			,DueDateStartDate VARCHAR(250)
			,ProgramId INT
			)

INSERT INTO #TrackingProtocolList
			(TrackingProtocolId 
			,TrackingProtocolFlagId 
			,CreateProtocol 
			,FlagTypeId 
			,Note 
			,StartDate 
			--,EndDate 
			,DocumentCodeId 
			,DueDateUnits 
			,DueDateUnitType 
			,FirstDueDate 
			,FirstDueDateDays 
			,DueDateStartDays 
			,DueDateStartDate 
			,ProgramId 
			)

		SELECT TP.TrackingProtocolId
			,TPF.TrackingProtocolFlagId
			,Tp.CreateProtocol
			,TPF.FlagTypeId
			,FT.FlagType AS Note
			,TP.StartDate
			--,TP.EndDate
			,FT.DocumentCodeId
			,TPF.DueDateUnits
			,GC.Code AS DueDateUnitType
			,GC1.Code AS FirstDueDate
			,TPF.FirstDueDateDays
			,TPF.DueDateStartDays
			,GC2.Code AS DueDateStartDate
			,TPP.ProgramId
		FROM TrackingProtocols TP
		JOIN TrackingProtocolFlags TPF ON TPF.TrackingProtocolId = TP.TrackingProtocolId
		JOIN FlagTypes FT ON FT.FlagTypeId = TPF.FlagTypeId
		LEFT JOIN TrackingProtocolPrograms TPP ON TPP.TrackingProtocolId = TP.TrackingProtocolId
			AND ISNULL(TPP.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = TPF.DueDateUnitType
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = TPF.FirstDueDate
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = TPF.DueDateStartDate
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE  --Cast(StartDate AS DATE)  >= CAST(GETDATE() AS DATE)
			TP.TrackingProtocolId = @TrackingProtocolId
			AND CAST(EndDate AS DATE) >= CAST(GETDATE() AS DATE)
			AND ISNULL(TP.RecordDeleted, 'N') = 'N'
			AND ISNULL(TPF.RecordDeleted, 'N') = 'N'
			AND ISNULL(TP.Active, 'N') = 'Y'
			AND ISNULL(TPF.Active, 'N') = 'Y'
			--AND ISNULL(TPF.DueDateType, 'N') = 'M'

		-- Manually	
		DECLARE @TrackingProtocolFlagId INT
		
		DECLARE @OutPut INT
		SET @OutPut = 0
		select @OutPut = Count(*)
		FROM #TrackingProtocolList T
			WHERE NOT EXISTS (
					SELECT 1
					FROM ClientNotes CN
					WHERE CN.ClientId = @ClientId
						AND CN.TrackingProtocolId = T.TrackingProtocolId
						AND CN.TrackingProtocolFlagId = T.TrackingProtocolFlagId
						AND ISNULL(CN.RecordDeleted, 'N') = 'N'
					)
					
		
		DECLARE OnEpisodeStart_cursor CURSOR
		FOR
		SELECT  DISTINCT TPF.TrackingProtocolFlagId
		FROM TrackingProtocolFlags TPF
		JOIN TrackingProtocols TP ON TP.TrackingProtocolId = TPF.TrackingProtocolId
		WHERE TP.TrackingProtocolId =@TrackingProtocolId
			AND TPF.Active = 'Y'  
			AND TP.Active = 'Y'
			AND ISNULL(TPF.RecordDeleted,'N')='N'
			AND ISNULL(TP.RecordDeleted,'N')='N'

		OPEN OnEpisodeStart_cursor

		FETCH NEXT
		FROM OnEpisodeStart_cursor
		INTO @TrackingProtocolFlagId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO ClientNotes (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,ClientId
				,NoteType
				,Note
				,Active
				,StartDate
				--,EndDate
				,OpenDate
				,DueDate
				,TrackingProtocolId
				,TrackingProtocolFlagId
				,DocumentCodeId
				)
			SELECT @UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,@ClientId
				,FlagTypeId
				,Note
				,'Y'
				,DATEADD(DD, - CASE 
						WHEN DueDateStartDate = '# of Days Before Due Date'
							THEN DueDateStartDays
						WHEN DueDateStartDate = 'Open Date'
							THEN 0
						ELSE 0
						END, CASE 
						WHEN DueDateUnitType = 'Month(s)'
							THEN DATEADD(MM, DueDateUnits, GETDATE())
						WHEN DueDateUnitType = 'Year(s)'
							THEN DATEADD(YY, DueDateUnits, GETDATE())
						ELSE StartDate
						END) AS StartDate
				--,EndDate
				--,GETDATE() AS OpenDate
				,@OpenDate
				,CASE 
					WHEN DueDateUnitType = 'Month(s)'
						THEN DATEADD(MM, DueDateUnits, GETDATE())
					WHEN DueDateUnitType = 'Year(s)'
						THEN DATEADD(YY, DueDateUnits, GETDATE())
					ELSE StartDate
					END AS DueDate
				,TrackingProtocolId
				,TrackingProtocolFlagId
				,DocumentCodeId
			FROM #TrackingProtocolList T
			--LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = T.CreateProtocol
			WHERE --GC.Code = 'Manually'
				--AND GC.Category = 'CREATEPROTOCOL'
				--AND T.TrackingProtocolId = @TrackingProtocolId
				 NOT EXISTS (
					SELECT 1
					FROM ClientNotes CN
					WHERE CN.ClientId = @ClientId
						AND CN.TrackingProtocolId = T.TrackingProtocolId
						AND CN.TrackingProtocolFlagId = T.TrackingProtocolFlagId
						AND ISNULL(CN.RecordDeleted, 'N') = 'N'
					)

			FETCH NEXT
			FROM OnEpisodeStart_cursor
			INTO @ClientId
		END

		CLOSE OnEpisodeStart_cursor

		DEALLOCATE OnEpisodeStart_cursor
		
		Select @OutPut
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CreateClientNoteFlagsManually') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
