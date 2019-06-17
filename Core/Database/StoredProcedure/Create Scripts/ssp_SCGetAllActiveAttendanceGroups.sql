/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllActiveAttendanceGroups]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAllActiveAttendanceGroups]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAllActiveAttendanceGroups]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllActiveAttendanceGroups]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAllActiveAttendanceGroups]
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetAllActiveAttendanceGroups                     */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Get All Active Attendance Groups                             */
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
/*       13-APRIL-2016  Akwinass          Included HasTemplate Column(Task #167.1 in Valley - Support Go Live).*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #Groups (GroupId INT,GroupName VARCHAR(250),HasTemplate CHAR(1))

		INSERT INTO #Groups (GroupId,GroupName,HasTemplate)
		SELECT 0,'Select Group','N'

		INSERT INTO #Groups (GroupId,GroupName,HasTemplate)
		SELECT DISTINCT G.GroupId,G.GroupName,CASE WHEN GNDC.GroupNoteCodeId IS NULL THEN 'N' ELSE 'Y' END
		FROM Groups G
		LEFT JOIN GroupNoteDocumentCodes GNDC ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
			AND ISNULL(GNDC.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(G.Active, 'N') = 'Y'
			AND ISNULL(G.UsesAttendanceFunctions, 'N') = 'Y'
			AND ISNULL(G.RecordDeleted, 'N') = 'N'
		ORDER BY GroupName ASC
		
		SELECT GroupId,GroupName,HasTemplate FROM #Groups
		
		DROP TABLE #Groups
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetAllActiveAttendanceGroups: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


