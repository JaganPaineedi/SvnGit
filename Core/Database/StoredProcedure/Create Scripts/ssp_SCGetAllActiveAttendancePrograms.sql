/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllActiveAttendancePrograms]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAllActiveAttendancePrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAllActiveAttendancePrograms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllActiveAttendancePrograms]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAllActiveAttendancePrograms]
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetAllActiveAttendancePrograms                     */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Get All Active Attendance Programs                             */
/* Input Parameters:None                                                    */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-APRIL-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #Programs (ProgramId INT,ProgramCode VARCHAR(250))

		INSERT INTO #Programs (ProgramId,ProgramCode)
		SELECT 0,'Select Program'		
		
		INSERT INTO #Programs (ProgramId,ProgramCode)
		SELECT DISTINCT G.ProgramId,P.ProgramCode
		FROM Groups G JOIN Programs P ON G.ProgramId = P.ProgramId
		WHERE ISNULL(G.Active, 'N') = 'Y'
			AND ISNULL(G.UsesAttendanceFunctions, 'N') = 'Y'
			AND ISNULL(G.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
		ORDER BY ProgramCode ASC
		
		SELECT ProgramId,ProgramCode FROM #Programs
		
		DROP TABLE #Programs
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetAllActiveAttendancePrograms: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


