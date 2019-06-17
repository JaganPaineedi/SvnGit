/****** Object:  StoredProcedure [dbo].[smsp_GetMobileStaffPreference]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetMobileStaffPreference]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetMobileStaffPreference]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetMobileStaffPreference]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetMobileStaffPreference] @StaffId INT
	,@JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: 14-06-2016
-- Description: Get MobileStaffPreferences  
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT SP.staffPreferenceId
						,SP.createdBy
						,SP.createdDate
						,SP.modifiedBy
						,SP.modifiedDate
						,SP.recordDeleted
						,SP.deletedBy
						,SP.deletedDate
						,SP.staffId
						,SP.defaultMobileHomePageId
						,ISNULL(S.primaryProgramId, '') AS primaryProgramId
						,SP.mobileCalendarEventsDaysLookUpInPast
						,SP.mobileCalendarEventsDaysLookUpInFuture
						,ISNULL(p.ProgramCode, '') AS primaryProgramCode
						,(S.LastName + ', ' + S.FirstName) AS staffName
					FROM StaffPreferences SP
					INNER JOIN Staff S ON S.StaffId = SP.StaffId
					LEFT JOIN Programs P ON P.ProgramId = SP.DefaultMobileProgramId
						AND P.Active = 'Y'
						AND ISNULL(P.Mobile, 'N') = 'Y'
						AND ISNULL(P.RecordDeleted, 'N') = 'N'
					WHERE SP.StaffId = @StaffId
						AND ISNULL(SP.RecordDeleted, 'N') = 'N'
					FOR XML path
						,root
					))
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetMobileStaffPreference') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


