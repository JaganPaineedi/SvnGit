/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedCensusAdminOverlappingPrograms]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBedCensusAdminOverlappingPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBedCensusAdminOverlappingPrograms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedCensusAdminOverlappingPrograms]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetBedCensusAdminOverlappingPrograms] @ProgramId INT,@BedAssignmentOverlappingProgramMappingId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetBedCensusAdminOverlappingPrograms   137           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    23/DEC/2015                                         */
/*                                                                   */
/* Purpose:  Used in Bed Census Overlapping Program Detail Page  */
/*                                                                   */
/* Input Parameters: @ProgramId,@BedAssignmentOverlappingProgramMappingId   */
/*                                                                   */
/* Output Parameters:   None                */
/** Updates:                                                                                                         
** Date            Author              Purpose   
** 12-JAN-2016	   Akwinass			   What:Implemented Residential Program Filter (Task #50 in Woods - Customizations)*/
/*********************************************************************/
BEGIN
	BEGIN TRY	
		DECLARE @OverlappedProgramId INT

		SELECT @OverlappedProgramId = OverlappingProgramId
		FROM BedAssignmentOverlappingProgramMappings
		WHERE BedAssignmentOverlappingProgramMappingId = @BedAssignmentOverlappingProgramMappingId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT BAOPM.BedAssignmentOverlappingProgramMappingId
			,BAOPM.CreatedBy
			,BAOPM.CreatedDate
			,BAOPM.ModifiedBy
			,BAOPM.ModifiedDate
			,BAOPM.RecordDeleted
			,BAOPM.DeletedBy
			,BAOPM.DeletedDate
			,BAOPM.ProgramId
			,BAOPM.OverlappingProgramId
			,P1.ProgramName
			,P2.ProgramName AS OverlappingProgramName
		FROM BedAssignmentOverlappingProgramMappings BAOPM
		LEFT JOIN Programs P1 ON BAOPM.ProgramId = P1.ProgramId
		LEFT JOIN Programs P2 ON BAOPM.OverlappingProgramId = P2.ProgramId
		WHERE ISNULL(BAOPM.RecordDeleted, 'N') = 'N'
			AND BAOPM.ProgramId = @ProgramId
			AND BAOPM.OverlappingProgramId <> ISNULL(@OverlappedProgramId,0)
			
		SELECT P.ProgramId
			,P.ProgramName
		FROM Programs P
		WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.Active, 'N') = 'Y'
			AND ISNULL(P.ProgramName,'') <> ''
			AND P.ProgramId <> @ProgramId
			AND ISNULL(P.ResidentialProgram,'N') = 'Y'
			AND NOT EXISTS (
				SELECT 1
				FROM BedAssignmentOverlappingProgramMappings BAOPM				
				WHERE ISNULL(BAOPM.RecordDeleted, 'N') = 'N'
					AND BAOPM.ProgramId = @ProgramId
					AND BAOPM.OverlappingProgramId <> ISNULL(@OverlappedProgramId, 0)
					AND BAOPM.OverlappingProgramId = P.ProgramId
				)
		ORDER BY P.ProgramName ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetBedCensusAdminOverlappingPrograms]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


