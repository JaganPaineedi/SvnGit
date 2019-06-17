/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedboardBedCensusPrograms]    Script Date: 04/25/2014 14:36:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBedboardBedCensusPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBedboardBedCensusPrograms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedboardBedCensusPrograms]    Script Date: 04/25/2014 14:36:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetBedboardBedCensusPrograms] @ClientInpatientVisitId INT = - 1
	,@ClientId INT = -1
	,@Mode VARCHAR(20) = ''
	,@StaffId INT =0
	/********************************************************************************                                                                                
-- Stored Procedure:ssp_SCGetBedboardBedCensusPrograms                                                                                 
--                                                                                
-- Copyright: Streamline Healthcate Solutions                                                                                
--                                                                                
-- Purpose: To Get Programs List for Bedboard and Bed Census Details Page                                                                                
--                                                                                
-- Updates:                                                                                                                                       
-- Date				Author				Purpose
-- 19-JUNE-2015     Akwinass            Created. (Task #317 in Philhaven Development).
-- 24-JUNE-2015     Akwinass            Implemented Leave Status check to get On Leave program. (Task #317 in Philhaven Development).
-- 22-DEC-2015      Akwinass            Modified to Check Overlapping Programs (Task #50 in Woods - Customizations)
-- 24-July-2018	Deej				Added Logic to  bind the records only for the staff has access to Units and Programs. Bradford - Enhancements #400.2
********************************************************************************/
AS
BEGIN
	BEGIN TRY
	--Added by Deej
    DECLARE @ListDataBasedOnStaffsAccessToProgramsAndUnits varchar(3)  
    --SET @ListDataBasedOnStaffsAccessToProgramsAndUnits= CASE WHEN ssf_GetSystemConfigurationKeyValue( 'EnableStaffsAssociatedUnitAndProgramsFilteringInData') = 'Yes' THEN 'Y'
    SELECT @ListDataBasedOnStaffsAccessToProgramsAndUnits = CASE WHEN [Value]='Yes' THEN 'Y' ELSE 'N' END 
    FROM SystemConfigurationKeys WHERE [Key]= 'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'   

		IF OBJECT_ID('tempdb..#BedPrograms') IS NOT NULL
			DROP TABLE #BedPrograms			
		CREATE TABLE #BedPrograms(ProgramId INT,ProgramCode VARCHAR(100))	
		
		IF OBJECT_ID('tempdb..#AssignedPrograms') IS NOT NULL
			DROP TABLE #AssignedPrograms			
		CREATE TABLE #AssignedPrograms (ProgramId INT)
		
		INSERT INTO #AssignedPrograms(ProgramId)
		SELECT DISTINCT BA.ProgramId
		FROM BedAssignments BA
		JOIN Programs P ON BA.ProgramId = P.ProgramId 
		WHERE 
		 --Added by Deej 7/24/2018
            (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
		  exists(select 1 from StaffPrograms SP where SP.StaffId=@StaffId AND SP.ProgramId=P.ProgramId 
				AND ISNULL(SP.RecordDeleted,'N')='N' ))) AND
		ISNULL(BA.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.Active,'N') = 'Y'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND EXISTS (
				SELECT *
				FROM ClientInpatientVisits CIV
				WHERE CIV.[Status] = 4983
					AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
					AND CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
					AND CIV.ClientId = @ClientId
				)
				
		INSERT INTO #AssignedPrograms(ProgramId)		
		SELECT DISTINCT BA.ProgramId
		FROM BedAssignments BA
		JOIN Programs P ON BA.ProgramId = P.ProgramId
		WHERE 
		--Added by Deej 7/24/2018
            (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
		  exists(select 1 from StaffPrograms SP where SP.StaffId=@StaffId AND SP.ProgramId=P.ProgramId 
				AND ISNULL(SP.RecordDeleted,'N')='N' ))) AND
		ISNULL(BA.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.ResidentialProgram, 'N') = 'Y'
			AND ISNULL(P.Active, 'N') = 'Y'
			AND EXISTS (
				SELECT ClientInpatientVisitId
				FROM ClientInpatientVisits CIV
				INNER JOIN GlobalCodes GC ON CIV.[Status] = GC.GlobalCodeId
				WHERE CIV.ClientId = @ClientId
					AND [Status] NOT IN (4983,4984)
					AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
					AND CIV.DischargedDate IS NULL
					AND (CIV.AdmitDate IS NOT NULL OR CIV.ScheduledDate IS NOT NULL)
					AND CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId
				)
			AND BA.ClientInpatientVisitId <> @ClientInpatientVisitId
			AND NOT EXISTS(SELECT 1 FROM #AssignedPrograms WHERE ProgramId = BA.ProgramId)
						
		IF @Mode = 'InpatientProgram'
		BEGIN
			INSERT INTO #BedPrograms (ProgramId,ProgramCode)
			SELECT DISTINCT BA.ProgramId,P.ProgramCode
			FROM BedAssignments BA
			JOIN Programs P ON BA.ProgramId = P.ProgramId 
			WHERE BA.ClientInpatientVisitId = @ClientInpatientVisitId AND
			--Added by Deej 7/24/2018
            (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
		  exists(select 1 from StaffPrograms SP where SP.StaffId=@StaffId AND SP.ProgramId=P.ProgramId 
				AND ISNULL(SP.RecordDeleted,'N')='N' )))
				AND ISNULL(BA.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.InpatientProgram,'N') = 'Y'
				AND ISNULL(P.Active,'N') = 'Y'
			
			INSERT INTO #BedPrograms (ProgramId,ProgramCode)
			SELECT P.ProgramId,P.ProgramCode
			FROM Programs P
			WHERE 
			--Added by Deej 7/24/2018
            (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
		  exists(select 1 from StaffPrograms SP where SP.StaffId=@StaffId AND SP.ProgramId=P.ProgramId 
				AND ISNULL(SP.RecordDeleted,'N')='N' ))) AND
			ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.InpatientProgram, 'N') = 'Y'
				AND ISNULL(P.Active,'N') = 'Y'
				AND NOT EXISTS (SELECT 1 FROM #AssignedPrograms AP WHERE AP.ProgramId = P.ProgramId)
		END
		ELSE IF @Mode = 'ResidentialProgram'
		BEGIN
			INSERT INTO #BedPrograms (ProgramId,ProgramCode)
			SELECT DISTINCT BA.ProgramId,P.ProgramCode
			FROM BedAssignments BA
			JOIN Programs P ON BA.ProgramId = P.ProgramId
			WHERE 
				--Added by Deej 7/24/2018
            (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
		  exists(select 1 from StaffPrograms SP where SP.StaffId=@StaffId AND SP.ProgramId=P.ProgramId 
				AND ISNULL(SP.RecordDeleted,'N')='N' ))) AND
				BA.ClientInpatientVisitId = @ClientInpatientVisitId
				AND ISNULL(BA.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.ResidentialProgram,'N') = 'Y'
				AND ISNULL(P.Active,'N') = 'Y'
			
			INSERT INTO #BedPrograms (ProgramId,ProgramCode)
			SELECT P.ProgramId,P.ProgramCode
			FROM Programs P
			WHERE 
			 --Added by Deej 7/24/2018
            (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
		  exists(select 1 from StaffPrograms SP where SP.StaffId=@StaffId AND SP.ProgramId=P.ProgramId 
				AND ISNULL(SP.RecordDeleted,'N')='N' ))) AND			
				ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.ResidentialProgram, 'N') = 'Y'
				AND ISNULL(P.Active,'N') = 'Y'
				AND NOT EXISTS (SELECT 1 FROM #AssignedPrograms AP WHERE AP.ProgramId = P.ProgramId)
		END
		
		SELECT DISTINCT ProgramId,ProgramCode FROM #BedPrograms ORDER BY ProgramCode ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetBedboardBedCensusPrograms') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH

	RETURN
END
GO





