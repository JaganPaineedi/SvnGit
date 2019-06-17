/****** Object:  StoredProcedure [dbo].[ssp_SCGetMedicationUnits]    Script Date: 05/10/2017 12:23:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetMedicationUnits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetMedicationUnits]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetMedicationUnits]    Script Date: 05/10/2017 12:23:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetMedicationUnits] @MedicationNameId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetMedicationUnits]              */
/* Creation Date:  20/Jul/2015                                     */
/* Purpose: To get MedicationNames For orders            */
/* Output Parameters:   */
/* Returns The Table for Medication Units*/
/* Called By:                                                       */
/* Data Modifications:                                              */
/*   Updates:                                                       */
/*   Date			Author		Purpose								*/
/*   20/Jul/2015	Shankha		Created								*/		
/*	 17/Jan/2017	Chethan N	What: Retreiving Medication Id.
								Why:  Renaissance - Dev Items task #5	*/	
/********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @tMedicationIds TABLE (
			[MedicationId]INT
			)
		
		INSERT INTO @tMedicationIds
		SELECT MedicationId from MDMedications where MedicationNameId = @MedicationNameId
		
		DECLARE @tResults TABLE (
			[GlobalCodeId]INT
			,[CodeName]VARCHAR(250)
			,[MedicationId] INT
			)

		DECLARE @FinalResults TABLE (
		[GlobalCodeId]INT
		,[CodeName]VARCHAR(250)
		,[MedicationId] INT
		)
		
		DECLARE @MedicationId INT = 0	
		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT [MedicationId]
		FROM @tMedicationIds TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @MedicationId

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			INSERT INTO @tResults ([GlobalCodeId], [CodeName])
			select GlobalCodeId,CodeName from dbo.ssf_SCMedicationUnits(@MedicationId)

			INSERT INTO @FinalResults([GlobalCodeId],[CodeName],[MedicationId])
			SELECT [GlobalCodeId], [CodeName], @MedicationId FROM @tResults

			DELETE FROM @tResults
		
			FETCH NEXT
			FROM tCursor
			INTO @MedicationId
		END

		CLOSE tCursor
		DEALLOCATE tCursor	
		
		Select DISTINCT GlobalCodeId, [CodeName],  STUFF( (Select DISTINCT ',' +  CAST(FR.[MedicationId] AS VARCHAR(MAX)) 
			FROM @FinalResults FR
			Where FR.GlobalCodeId = F.GlobalCodeId
			FOR XML PATH('') ), 1,1,'') AS MedicationId
		FROM @FinalResults F
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCGetMedicationUnits') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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


