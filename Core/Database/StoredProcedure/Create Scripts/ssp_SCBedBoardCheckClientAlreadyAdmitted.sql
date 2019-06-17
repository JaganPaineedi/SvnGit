/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardCheckClientAlreadyAdmitted]    Script Date: 04/01/2014 14:37:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedBoardCheckClientAlreadyAdmitted]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCBedBoardCheckClientAlreadyAdmitted]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardCheckClientAlreadyAdmitted]    Script Date: 04/01/2014 14:37:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCBedBoardCheckClientAlreadyAdmitted] (
	@ClientId INT,
	@ClientInpatientVisitId INT = -1
	)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCBedBoardCheckClientAlreadyAdmitted               */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  May 26, 2015                                             */
/* Purpose: To make sure that the current client is admitted or not         */
/* Input Parameters:  @ClientId int                                         */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date----Author-------Purpose---------------------------------------*/
/*  26-05-2015   Akwinass     Created(Task #1282 in Philhaven - Customization Issues Tracking )*/
/*  29-05-2015   Akwinass     Included @ClientInpatientVisitId(Task #1282 in Philhaven - Customization Issues Tracking )*/
/*  24-06-2015   Akwinass     Included Check 'NOT IN' for On Leave and Discharged Status. (Task #317 in Philhaven Development)*/
/*  21-01-2016   Akwinass     Implemented Overlapping Program Check. (Task #2227 in Core Bugs)*/
/****************************************************************************/
BEGIN
	BEGIN TRY
			IF OBJECT_ID('tempdb..#OccupiedPrograms') IS NOT NULL
				DROP TABLE #OccupiedPrograms
				
			IF OBJECT_ID('tempdb..#OverlappingPrograms') IS NOT NULL
				DROP TABLE #OverlappingPrograms
				
			IF OBJECT_ID('tempdb..#MappedPrograms') IS NOT NULL
				DROP TABLE #MappedPrograms

			CREATE TABLE #OccupiedPrograms (ProgramId INT)
			CREATE TABLE #OverlappingPrograms (ProgramId INT)
			CREATE TABLE #MappedPrograms (ProgramId INT)

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
						AND [Status] NOT IN (4984)
						AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
						AND CIV.DischargedDate IS NULL
						AND (CIV.AdmitDate IS NOT NULL OR CIV.ScheduledDate IS NOT NULL)
						AND CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
					)

			INSERT INTO #OverlappingPrograms (ProgramId)
			SELECT DISTINCT ProgramId
			FROM BedAssignmentOverlappingProgramMappings ORP
			WHERE ISNULL(ORP.RecordDeleted, 'N') = 'N'
				AND EXISTS (
					SELECT 1
					FROM #OccupiedPrograms OP
					WHERE OP.ProgramId = ORP.ProgramId
					)
					

			INSERT INTO #MappedPrograms (ProgramId)		
			SELECT DISTINCT OverlappingProgramId
			FROM BedAssignmentOverlappingProgramMappings ORP
			WHERE ISNULL(ORP.RecordDeleted, 'N') = 'N'
				AND EXISTS (
					SELECT 1
					FROM #OverlappingPrograms OP
					WHERE OP.ProgramId = ORP.ProgramId
					)

			INSERT INTO #OverlappingPrograms (ProgramId)
			SELECT DISTINCT ProgramId
			FROM #MappedPrograms
			
			IF EXISTS(SELECT 1 FROM #OccupiedPrograms OP WHERE NOT EXISTS (SELECT * FROM #OverlappingPrograms ORP WHERE OP.ProgramId = ORP.ProgramId))
			BEGIN
				SELECT TOP 1 ClientInpatientVisitId
					,CASE 
						WHEN GC.CodeName = 'Scheduled'
							THEN CIV.ScheduledDate
						ELSE CIV.AdmitDate
						END AdmitDate
					,CASE 
						WHEN GC.CodeName = 'Scheduled'
							THEN 'Scheduled'
						ELSE 'Admitted'
						END CodeName
				FROM ClientInpatientVisits CIV
				INNER JOIN GlobalCodes GC ON CIV.[Status] = GC.GlobalCodeId
				WHERE CIV.ClientId = @ClientId
					AND [Status] NOT IN (4983,4984)
					AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
					AND CIV.DischargedDate IS NULL
					AND (CIV.AdmitDate IS NOT NULL OR CIV.ScheduledDate IS NOT NULL)
					AND CIV.ClientInpatientVisitId <> @ClientInpatientVisitId
				ORDER BY CIV.AdmitDate ASC
			END
			ELSE
			BEGIN
				SELECT TOP 0 NULL AS ClientInpatientVisitId,NULL AS AdmitDate,NULL AS CodeName				
			END			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCBedBoardCheckClientAlreadyAdmitted') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


