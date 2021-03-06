IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebBedBoardCheckBed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebBedBoardCheckBed]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebBedBoardCheckBed] (
	@ClientInpatientVisitId INT
	,@BedAssignmentId INT
	,@BedId INT
	,@StartDate DATETIME = NULL
	,@EndDate DATETIME = NULL
	,@Status INT
	,@Disposition INT
	)
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: [ssp_SCWebBedBoardCheckBed]                     */
	/* Creation Date:  Aug 2013                                          */
	/* Creation By : Akwinass                                            */
	/* Purpose: Validate Bed for Census Management                       */
	/*                                                                   */
	/* Input Parameters: @ClientInpatientVisitId, @BedAssignmentId       */
	/* @BedId, @EndDate, @Status, @Disposition                           */
	/* Output Parameters:                                                */
	/*                                                                   */
	/* Return:                                                           */
	/*                                                                   */
	/* Called By: DataService Bedboard Class                             */
	/* Calls:                                                            */
	/* Data Modifications:                                               */
	/*   Date           Author                 Purpose                   */
	-- Septemper 2013   Akwinass            Modified for bedboard            
	/*   24/01/2014     Akwinass            Implemented CAST for date Conversion*/
	-- 03 JUNE 2015     Akwinass            Included Status column (Task#1282 - Philhaven - Customization Issues Tracking)
	-- 17 Nov 2015      Bernardin           Checking Completed Services available for this BedAttendances. If presents the avoid deleting this Bad Assignment. Core Bugs Task# 1943
	/*********************************************************************/
	BEGIN TRY
		DECLARE @checkbedid INT
			,@checkStatus INT
			,@checkDisposition INT
			,@validbed varchar(7)

		IF @ClientInpatientVisitId = - 1
			AND @BedAssignmentId = - 1
			AND @Status = 0
			AND @Disposition = 0
		BEGIN
			SELECT TOP 1 @checkbedid = BedId
			FROM BedAssignments
			WHERE (EndDate IS NULL OR CAST(EndDate AS DATE) > CAST(@StartDate AS DATE) OR (CAST(EndDate AS DATE) <= CAST(@StartDate AS DATE) AND Disposition IS NULL))
				AND Disposition IS NULL
				AND BedId = @BedId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND [Status] NOT IN (5006)
				AND CAST(StartDate AS DATE) <= CAST(@StartDate AS DATE)
				
			SELECT BA.[Status],BA.StartDate, C.LastName, C.FirstName,DATEADD(day,-1,BA.StartDate) AS EndDate
			FROM BedAssignments BA JOIN ClientInpatientVisits CIV on BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
			JOIN Clients C ON CIV.ClientId = C.ClientId
			WHERE (EndDate IS NULL OR CAST(EndDate AS DATE) > CAST(@StartDate AS DATE))
				AND BA.Disposition IS NULL
				AND BedId = @BedId
				AND ISNULL(BA.RecordDeleted, 'N') = 'N'
				AND BA.[Status] NOT IN (5006)
				AND CAST(StartDate AS DATE) > CAST(@StartDate AS DATE)
				Order by StartDate ASC
				
			SELECT BA.[Status],BA.StartDate, C.LastName, C.FirstName, Case when ba.EndDate is null then DATEADD(day,-1,BA.StartDate) else BA.EndDate end EndDate
			FROM BedAssignments BA JOIN ClientInpatientVisits CIV on BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
			JOIN Clients C ON CIV.ClientId = C.ClientId
			WHERE (EndDate IS NULL OR CAST(EndDate AS DATE) < CAST(@StartDate AS DATE))
				AND BA.Disposition IS NULL
				AND BedId = @BedId
				AND ISNULL(BA.RecordDeleted, 'N') = 'N'
				AND BA.[Status] NOT IN (5006)
				AND CAST(StartDate AS DATE) < CAST(@StartDate AS DATE)
				Order by StartDate ASC

			IF @checkbedid > 0
				AND @BedId > 0
				AND @checkbedid = @BedId
			BEGIN
				SET @validbed = 'FALSE'
			END
			ELSE
			BEGIN
				SET @validbed = 'TRUE'
			END
		END
		ELSE
		BEGIN
			SELECT TOP 1 @checkbedid = BedId
			FROM BedAssignments
			WHERE (EndDate IS NULL OR CAST(EndDate AS DATE) > CAST(@StartDate AS DATE) OR (CAST(EndDate AS DATE) <= CAST(@StartDate AS DATE) AND Disposition IS NULL))
			    AND BedAssignmentId <> @BedAssignmentId
				AND ClientInpatientVisitId <> @ClientInpatientVisitId
				AND Disposition IS NULL
				AND BedId = @BedId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND [Status] NOT IN (5006)
				AND CAST(StartDate AS DATE) <= CAST(@StartDate AS DATE)
				
			SELECT BA.[Status],BA.StartDate, C.LastName, C.FirstName,Case when ba.EndDate is null then DATEADD(day,-1,BA.StartDate) else BA.EndDate end EndDate
			FROM BedAssignments BA JOIN ClientInpatientVisits CIV on BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
			JOIN Clients C ON CIV.ClientId = C.ClientId
			WHERE (EndDate IS NULL OR CAST(EndDate AS DATE) > CAST(@StartDate AS DATE))
			    AND BA.BedAssignmentId <> @BedAssignmentId
				AND BA.ClientInpatientVisitId <> @ClientInpatientVisitId
				AND BA.Disposition IS NULL
				AND BedId = @BedId
				AND ISNULL(BA.RecordDeleted, 'N') = 'N'
				AND BA.[Status] NOT IN (5006)
				AND CAST(StartDate AS DATE) > CAST(@StartDate AS DATE)
				Order by StartDate ASC
				
			SELECT BA.[Status],BA.StartDate, C.LastName, C.FirstName, Case when ba.EndDate is null then DATEADD(day,-1,BA.StartDate) else BA.EndDate end EndDate
			FROM BedAssignments BA JOIN ClientInpatientVisits CIV on BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
			JOIN Clients C ON CIV.ClientId = C.ClientId
			WHERE (EndDate IS NULL OR CAST(EndDate AS DATE) < CAST(@StartDate AS DATE))
			    AND BA.BedAssignmentId <> @BedAssignmentId
				AND BA.ClientInpatientVisitId <> @ClientInpatientVisitId
				AND BA.Disposition IS NULL
				AND BedId = @BedId
				AND ISNULL(BA.RecordDeleted, 'N') = 'N'
				AND BA.[Status] NOT IN (5006)
				AND CAST(StartDate AS DATE) < CAST(@StartDate AS DATE)
				Order by StartDate ASC

			IF @checkbedid > 0
				AND @BedId > 0
				AND @checkbedid = @BedId
			BEGIN
				SET @validbed = 'FALSE'
			END
			ELSE
			BEGIN
				SET @validbed = 'TRUE'
			END
		END
		
		-- Added by Bernardin for Core Bugs Task# 1943
		IF @validbed = 'TRUE'
		BEGIN
		 IF EXISTS (SELECT 1 FROM BedAttendances BA INNER JOIN
                      Services S ON BA.ServiceId = S.ServiceId 
                      WHERE ISNULL(BA.RecordDeleted,'N') = 'N' AND ISNULL(S.RecordDeleted,'N') = 'N' 
                      AND S.[Status] = 75 AND BA.BedAssignmentId = @BedAssignmentId) 
			BEGIN
				SET @validbed =  'PRESENT'
			END
		END
				
		SELECT @validbed
        -- Changes Ends Here
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebBedBoardCheckBed') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,1
				);
	END CATCH
END
