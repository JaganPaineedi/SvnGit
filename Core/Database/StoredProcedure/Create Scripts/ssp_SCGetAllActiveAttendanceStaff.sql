IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAllActiveAttendanceStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAllActiveAttendanceStaff]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetAllActiveAttendanceStaff]
@GroupId INT
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetAllActiveAttendanceStaff                     */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  10 Jun 2015	                                            */
/* Purpose: To Get All Active Attendance Staff	                            */
/* Input Parameters:None                                                    */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       10 Jun 2015	Avi Goyal		 Created(Task #829 in Woods - Customizations).*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #Staff (StaffId INT,StaffName VARCHAR(250))

		INSERT INTO #Staff (StaffId,StaffName)
		SELECT 0,'Select Staff'

		INSERT INTO #Staff (StaffId,StaffName)
		
		SELECT 
			GS.StaffId
			,ISNULL(S.Initial,'') AS StaffName
		FROM GroupStaff GS
		INNER JOIN Staff S ON S.StaffId=GS.StaffId
		
		UNION

		SELECT 
			SP.StaffId
			,ISNULL(S.Initial,'') AS StaffName
		FROM StaffPrograms SP
		INNER JOIN Groups G ON SP.ProgramId=G.ProgramId
		INNER JOIN Staff S ON S.StaffId=SP.StaffId
		WHERE (G.GroupId=@GroupId OR ISNULL(@GroupId,0)=0)
		
		
		SELECT DISTINCT StaffId,StaffName FROM #Staff ORDER BY StaffName
		
		DROP TABLE #Staff
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetAllActiveAttendanceStaff: An Error Occured'

			RETURN
		END
	END CATCH
END
GO