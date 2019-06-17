IF EXISTS (
		SELECT *
		FROM SYS.objects
		WHERE object_id = Object_id(N'[dbo].[ssp_SCCheckOverridePendedReasonControlPermission]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCheckOverridePendedReasonControlPermission]
GO

CREATE PROCEDURE [dbo].[ssp_SCCheckOverridePendedReasonControlPermission] @LoginStaffId INT
AS
/************************************************************************/
-- Stored Procedure: dbo.ssp_SCCheckOverridePendedReasonControlPermission   1222            
-- Copyright: 2005 ClaimLines               
-- Creation Date:  10/Sep/2018   
/*       Date              Author                   Purpose              */
/*       07/09/2018        K.Soujanya               Check Staff has permission for Override Pended Reason check box control.Ref #13 Partner Solutions - Enhancements.*/
/************************************************************************/
BEGIN
	BEGIN TRY
		BEGIN
			DECLARE @OverridePermission VARCHAR(10)

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'CheckBox_ClaimLines_OverridePendedReason'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)
			BEGIN
				SET @OverridePermission = 'Y'
			END

			SELECT TOP 1 @OverridePermission AS OverridePermission
			FROM Staff
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCCheckOverridePendedReasonControlPermission]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
