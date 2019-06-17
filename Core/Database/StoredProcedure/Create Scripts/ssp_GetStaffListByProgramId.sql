/****** Object:  StoredProcedure [dbo].[ssp_GetStaffListByProgramId]    Script Date: 01/06/2015 12:30:03 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffListByProgramId]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetStaffListByProgramId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetStaffListByProgramId]    Script Date: 01/06/2015 12:30:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetStaffListByProgramId] (@Programid INT)
AS
-- =============================================
-- Author:		Pradeep.A
-- Create date: 01/19/2015
-- Description:	StaffList based on the ProgramId
/* ---------------------------------------------------------------------*/
/* 10-27-2017     Bibhu           Added Active check for Staff(Journey - Environment Issues Tracking #551) */
/* 18- July- 2018 Swatika         Added logic for Care Plan document - Supports/Treatment Program Tab - Treatment Program' the section, 
                                  when the user clicks 'Add', the staff drop down will be only staff in the clietn's treatment team instead of all staff.CCC-Customizations: #13 */
-- =============================================
BEGIN
	BEGIN TRY
		DECLARE @Value VARCHAR(50)

		SELECT @Value = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'INTIALIZETREATMENTEAMCP'

		IF UPPER(@Value) = 'YES'
		BEGIN
			SELECT DISTINCT S.StaffId
				,SP.Programid
				,CASE 
					WHEN isnull(S.LastName, '') <> ''
						THEN isnull(S.LastName, '') + ', ' + isnull(S.FirstName, '')
					ELSE isnull(S.FirstName, '')
					END AS 'StaffName'
			FROM staffPrograms SP
			INNER JOIN staff S ON SP.staffid = S.staffid AND ISNULL(S.RecordDeleted, 'N') = 'N'
			INNER JOIN ClientTreatmentTeamMembers CTTM ON SP.staffid = CTTM.staffid
				AND ISNULL(CTTM.RecordDeleted, 'N') = 'N'
				AND ISNULL(CTTM.Active,'Y')='Y'
				AND CAST(CTTM.EndDate AS DATE) >= CAST(GETDATE() AS DATE) 
				AND CTTM.MemberType='S' --Only Staff
			Where ISNULL(SP.RecordDeleted, 'N') = 'N'
				AND SP.Programid = @Programid
				AND S.Active = 'Y'
			ORDER BY StaffName
		END
		ELSE
		BEGIN
			SELECT DISTINCT S.StaffId
				,SP.Programid
				,CASE 
					WHEN isnull(S.LastName, '') <> ''
						THEN isnull(S.LastName, '') + ', ' + isnull(S.FirstName, '')
					ELSE isnull(S.FirstName, '')
					END AS 'StaffName'
			FROM staffPrograms SP
			INNER JOIN staff S ON SP.staffid = S.staffid
				AND ISNULL(SP.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND SP.Programid = @Programid
				AND S.Active = 'Y' -----10-27-2017     Bibhu 
			ORDER BY StaffName
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetStaffListByProgramId') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


