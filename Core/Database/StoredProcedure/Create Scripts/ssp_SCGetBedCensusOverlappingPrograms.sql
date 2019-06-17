/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedCensusOverlappingPrograms]    Script Date: 04/01/2014 14:37:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBedCensusOverlappingPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBedCensusOverlappingPrograms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedCensusOverlappingPrograms]    Script Date: 04/01/2014 14:37:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCGetBedCensusOverlappingPrograms] (
	@ClientId INT
	)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetBedCensusOverlappingPrograms                      */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  Dec 18 2015                                              */
/* Purpose: To Get Bed Census Overlapping Programs                           */
/* Input Parameters:  @ClientId                     */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-------Author---------Purpose------------------------------------------------------------------------------------------*/
/*--15-JULY-2016----Akwinass-------Only 4982 status check implemented for overlapping program (Task #166 in Woods - Support Go Live)*/
/************************************************************************************************************************************/
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#AvailablePrograms') IS NOT NULL
				DROP TABLE #AvailablePrograms
		CREATE TABLE #AvailablePrograms(ProgramId INT,ProgramCode VARCHAR(100))	
			
		IF EXISTS(SELECT 1 FROM ClientInpatientVisits CIV
				  INNER JOIN GlobalCodes GC ON CIV.[Status] = GC.GlobalCodeId
				  WHERE CIV.ClientId = @ClientId
					AND [Status] = 4982
					AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
					AND CIV.DischargedDate IS NULL
					AND (CIV.AdmitDate IS NOT NULL OR CIV.ScheduledDate IS NOT NULL))
		BEGIN			
			IF OBJECT_ID('tempdb..#OccupiedPrograms') IS NOT NULL
				DROP TABLE #OccupiedPrograms
			CREATE TABLE #OccupiedPrograms(ProgramId INT)			
			
			INSERT INTO #OccupiedPrograms (ProgramId)
			SELECT DISTINCT BA.ProgramId
			FROM BedAssignments BA
			JOIN Programs P ON BA.ProgramId = P.ProgramId
			WHERE ISNULL(BA.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.ResidentialProgram, 'N') = 'Y'
				AND ISNULL(P.Active, 'N') = 'Y'
				AND EXISTS (
					SELECT ClientInpatientVisitId
					FROM ClientInpatientVisits CIV
					INNER JOIN GlobalCodes GC ON CIV.[Status] = GC.GlobalCodeId
					WHERE CIV.ClientId = @ClientId
						AND [Status] = 4982
						AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
						AND CIV.DischargedDate IS NULL
						AND (CIV.AdmitDate IS NOT NULL OR CIV.ScheduledDate IS NOT NULL)
						AND CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
					)
			
			INSERT INTO #AvailablePrograms(ProgramId,P.ProgramCode)			
			SELECT P2.ProgramId,P2.ProgramCode
			FROM (
				SELECT DISTINCT PM.OverlappingProgramId
				FROM BedAssignmentOverlappingProgramMappings PM
				JOIN #OccupiedPrograms OP ON PM.ProgramId = OP.ProgramId
				JOIN Programs P ON PM.ProgramId = P.ProgramId
				WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
					AND ISNULL(P.ResidentialProgram, 'N') = 'Y'
					AND ISNULL(P.Active, 'N') = 'Y'
					AND ISNULL(PM.RecordDeleted, 'N') = 'N'
					AND NOT EXISTS (SELECT 1 FROM #OccupiedPrograms CP WHERE CP.ProgramId = PM.OverlappingProgramId)
				) AS T
			JOIN Programs P2 ON T.OverlappingProgramId = P2.ProgramId
			WHERE ISNULL(P2.RecordDeleted, 'N') = 'N'
				AND ISNULL(P2.ResidentialProgram, 'N') = 'Y'
				AND ISNULL(P2.Active, 'N') = 'Y'

			SELECT 'Yes'
		END
		ELSE
		BEGIN
			SELECT 'No'
		END
		
		SELECT DISTINCT ProgramId,ProgramCode FROM #AvailablePrograms ORDER BY ProgramCode ASC
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetBedCensusOverlappingPrograms: An Error Occured'

			RETURN
		END
	END CATCH
END


GO


