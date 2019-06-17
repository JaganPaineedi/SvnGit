/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardCheckClientInpatientStatus]    Script Date: 04/01/2014 14:37:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedBoardCheckClientInpatientStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCBedBoardCheckClientInpatientStatus]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardCheckClientInpatientStatus]    Script Date: 04/01/2014 14:37:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCBedBoardCheckClientInpatientStatus] (
	@ClientId INT
	,@admitdate VARCHAR(20)
	,@calledfrom VARCHAR(30)
	,@ProgramId INT
	)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCBedBoardCheckClientInpatientStatus               */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: anil gautam                                                      */
/* Creation Date:  Dec 28 2010                                              */
/* Purpose: To make sure that the current InpatientStatus of the client is other that Scheduled, Admitted, On Leave */
/* Input Parameters:  @ClientId int                                         */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date----Author-------Purpose---------------------------------------*/
/*  Aug 2013     Akwinass     Reused the script from Bed Census to  bedboard*/
/*  19-09-2013   Akwinass     Modified for Get Date and Codename*/
/*  22-09-2013   Akwinass     Modified for Cast Date validation*/
/*  22-05-2015   Akwinass     Included condition to get BedAssignmentId(Task #1277 in Philhaven - Customization Issues Tracking )*/
/*  25-05-2015   Akwinass     Included Configuration Key(Task #1277 in Philhaven - Customization Issues Tracking )*/
/*  24-06-2015   Akwinass     Included Check 'NOT IN' for On Leave and Discharged Status. (Task #317 in Philhaven Development)*/
/*  22-12-2015   Akwinass     Modified to Check Overlapping Programs (Task #50 in Woods - Customizations)*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @Configuration VARCHAR(MAX)
		
		SELECT @Configuration = Value 
		FROM SystemConfigurationKeys
		WHERE [Key] = 'EnableClientEntrollValidation'

		IF ISNULL(@Configuration,'') = 'true'
		BEGIN
			IF ISNULL(@calledfrom,'') = 'BedCensus'
			BEGIN
				IF EXISTS(SELECT ClientInpatientVisitId FROM ClientInpatientVisits CIV INNER JOIN GlobalCodes GC ON CIV.[Status] = GC.GlobalCodeId WHERE ClientId = @ClientId AND [Status] NOT IN(4983,4984) AND ISNULL(CIV.RecordDeleted, 'N') = 'N' AND (CAST(AdmitDate as Date) <= CAST(@admitdate as Date)  OR AdmitDate IS NULL) AND (CAST(DischargedDate as Date) > CAST(@admitdate as Date) OR DischargedDate IS NULL))
				BEGIN
					IF OBJECT_ID('tempdb..#OccupiedPrograms') IS NOT NULL
						DROP TABLE #OccupiedPrograms
					CREATE TABLE #OccupiedPrograms(ProgramId INT)
					
					IF OBJECT_ID('tempdb..#AvailablePrograms') IS NOT NULL
						DROP TABLE #AvailablePrograms
					CREATE TABLE #AvailablePrograms(ProgramId INT)	
					
					INSERT INTO #OccupiedPrograms(ProgramId)
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
							WHERE ClientId = @ClientId
								AND [Status] NOT IN (4983,4984)
								AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
								AND (CAST(AdmitDate AS DATE) <= CAST(@admitdate AS DATE) OR AdmitDate IS NULL)
								AND (CAST(DischargedDate AS DATE) > CAST(@admitdate AS DATE) OR DischargedDate IS NULL)
								AND CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
							)
					
					INSERT INTO #AvailablePrograms(ProgramId)						
					SELECT P2.ProgramId
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
						
					IF EXISTS(SELECT * FROM #AvailablePrograms WHERE ProgramId = @ProgramId) AND ISNULL(@ProgramId,0) > 0
					BEGIN
						SELECT TOP 0 0 AS ClientInpatientVisitId
					END	
					ELSE IF EXISTS(SELECT * FROM #AvailablePrograms) AND ISNULL(@ProgramId,0) <= 0
					BEGIN
						SELECT TOP 0 0 AS ClientInpatientVisitId
					END
					ELSE
					BEGIN
						SELECT TOP 1 ClientInpatientVisitId
							,CASE 
								WHEN GC.CodeName = 'Scheduled'
									THEN ScheduledDate
								ELSE AdmitDate
								END AdmitDate
							,CASE 
								WHEN GC.CodeName = 'Scheduled'
									THEN 'Scheduled'
								ELSE 'Admitted'
								END CodeName			
							,(SELECT TOP 1 BA.BedAssignmentId
								FROM BedAssignments BA
								WHERE ISNULL(CIV.RecordDeleted, 'N') = 'N'
									AND BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
									AND BA.[Status] = 5002
									AND BA.Disposition IS NULL
								) AS BedAssignmentId
						FROM ClientInpatientVisits CIV
						INNER JOIN GlobalCodes GC ON CIV.[Status] = GC.GlobalCodeId
						WHERE ClientId = @ClientId
							AND [Status] NOT IN(4983,4984)
							AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
							AND (CAST(AdmitDate as Date) <= CAST(@admitdate as Date)  OR AdmitDate IS NULL)
							AND (CAST(DischargedDate as Date) > CAST(@admitdate as Date) OR DischargedDate IS NULL)
						ORDER BY CIV.ClientInpatientVisitId DESC
					END
				END
				ELSE
				BEGIN
					SELECT TOP 0 0 AS ClientInpatientVisitId
				END
			END
			ELSE
			BEGIN
				SELECT ClientInpatientVisitId
					,CASE 
						WHEN GC.CodeName = 'Scheduled'
							THEN ScheduledDate
						ELSE AdmitDate
						END AdmitDate
					,CASE 
						WHEN GC.CodeName = 'Scheduled'
							THEN 'Scheduled'
						ELSE 'Admitted'
						END CodeName			
					,(SELECT TOP 1 BA.BedAssignmentId
						FROM BedAssignments BA
						WHERE ISNULL(CIV.RecordDeleted, 'N') = 'N'
							AND BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
							AND BA.[Status] = 5002
							AND BA.Disposition IS NULL
						) AS BedAssignmentId
				FROM ClientInpatientVisits CIV
				INNER JOIN GlobalCodes GC ON CIV.[Status] = GC.GlobalCodeId
				WHERE ClientId = @ClientId
					AND [Status] NOT IN(4983,4984)
					AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
					AND (CAST(AdmitDate as Date) <= CAST(@admitdate as Date)  OR AdmitDate IS NULL)
					AND (CAST(DischargedDate as Date) > CAST(@admitdate as Date) OR DischargedDate IS NULL)
			END
		END
		ELSE
		BEGIN
			SELECT TOP 0 0 AS ClientInpatientVisitId			
		END
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCBedBoardCheckClientInpatientStatus: An Error Occured'

			RETURN
		END
	END CATCH
END


GO


