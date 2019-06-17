/****** Object:  StoredProcedure [dbo].[smsp_GetStaffListForTeamScheduling]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetStaffListForTeamScheduling]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetStaffListForTeamScheduling]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetStaffListForTeamScheduling]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetStaffListForTeamScheduling] @StaffId BIGINT
	,@JsonResult VARCHAR(max) OUTPUT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves staff list who all have the specified ProgramId is used
/*      
 DECLARE @JsonResult VARCHAR(MAX)
 EXEC smsp_GetStaffListForTeamScheduling 550,@JsonResult OUTPUT
 SELECT @JsonResult
 Author			Modified Date			Reason      

1/18/2017	Pradeep			Returns records only Service detail information is Not Null      
2/20/2017	Pradeep 		Column Name changed from NAME to Name and the same mapping done in view.
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @ProgramId INT

		SELECT @ProgramId = DefaultMobileProgramId
		FROM StaffPreferences
		WHERE StaffId = @StaffId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		CREATE TABLE #TeamCalender (
			staffId INT
			,Name VARCHAR(100)
			,programId INT
			,ServiceDetail VARCHAR(MAX)
			)

		INSERT INTO #TeamCalender
		SELECT S.staffId
			,(ST.LastName + ', ' + ST.FirstName) AS Name
			,SP.programId
			,dbo.smsf_IntializeServiceDetails(S.staffId, SP.ProgramId) AS ServiceDetail
		FROM StaffPreferences S
		INNER JOIN Staff ST ON ST.StaffId = S.StaffId
		INNER JOIN StaffPrograms SP ON S.StaffId = SP.StaffId
		INNER JOIN Programs P ON P.ProgramId = SP.ProgramId
		WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ST.Active = 'Y'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND ISNULL(SP.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.Mobile,'N') = 'Y'
		GROUP BY S.StaffId
			,ST.LastName
			,ST.FirstName
			,SP.ProgramId
		ORDER BY ST.LastName
			,ST.FirstName

		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT *
					FROM #TeamCalender
					WHERE ServiceDetail Is NOT NULL
					FOR XML path
						,root
					))
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetStaffListForTeamScheduling') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


