/****** Object:  StoredProcedure [dbo].[ssp_SCGetOverlappingProgramDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetOverlappingProgramDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetOverlappingProgramDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetOverlappingProgramDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetOverlappingProgramDetails] @BedAssignmentOverlappingProgramMappingId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetOverlappingProgramDetails   137           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    23/DEC/2015                                         */
/*                                                                   */
/* Purpose:  Used in Used in Bed Census Overlapping Program Detail Page  */
/*                                                                   */
/* Input Parameters: @BedAssignmentOverlappingProgramMappingId   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY		
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
		WHERE BAOPM.BedAssignmentOverlappingProgramMappingId = @BedAssignmentOverlappingProgramMappingId
			AND ISNULL(BAOPM.RecordDeleted, 'N') = 'N'
			
		SELECT TOP 0 BAOPM.BedAssignmentOverlappingProgramMappingId
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
		WHERE BAOPM.BedAssignmentOverlappingProgramMappingId = @BedAssignmentOverlappingProgramMappingId
			AND ISNULL(BAOPM.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetOverlappingProgramDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


