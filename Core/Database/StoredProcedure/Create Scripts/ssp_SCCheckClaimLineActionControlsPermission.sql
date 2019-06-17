IF EXISTS (
		SELECT *
		FROM SYS.objects
		WHERE object_id = Object_id(N'[dbo].[ssp_SCCheckClaimLineActionControlsPermission]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCheckClaimLineActionControlsPermission]
GO

CREATE PROCEDURE [dbo].[ssp_SCCheckClaimLineActionControlsPermission] @LoginStaffId INT
AS
/************************************************************************/
-- Stored Procedure: dbo.ssp_SCCheckClaimLineActionControlsPermission   1222            
-- Copyright: 2005 ClaimLines               
-- Creation Date:  15/Nov/2018   
/*       Date              Author                   Purpose              */
/*       11/15/2018        K.Soujanya               Check Staff has permission for Claim Line Action controls.Ref #591 SWMBH - Enhancements.*/
/*       01/23/2018        K.Soujanya               Added condition if row not exists in screenpermissioncontrols for actions permission then by default user will have permission.Ref #591 SWMBH - Enhancements.*/

/************************************************************************/
BEGIN
	BEGIN TRY
		BEGIN
			DECLARE @ClaimLineUnderReview CHAR(1) = 'N'
			DECLARE @FinalStatus CHAR(1) = 'N'
			DECLARE @RemoveToBeWorked CHAR(1) = 'N'
			DECLARE @Deny CHAR(1) = 'N'
			DECLARE @Adjudicate CHAR(1) = 'N'
			DECLARE @ClaimLinePay CHAR(1) = 'N'
			DECLARE @DenialLetter CHAR(1) = 'N'
			DECLARE @Revert CHAR(1) = 'N'
			DECLARE @ReAdjudicate CHAR(1) = 'N'
			DECLARE @DoNotAdjudicate CHAR(1) = 'N'
			DECLARE @Void CHAR(1) = 'N'
			DECLARE @ManualPend CHAR(1) = 'N'
			DECLARE @ClaimLineDetailRevert CHAR(1) = 'N'
			DECLARE @ClaimLineDetailPay CHAR(1) = 'N'
			DECLARE @ClaimLineDetailDeny CHAR(1) = 'N'
			DECLARE @ClaimLineDetailApprove CHAR(1) = 'N'
			DECLARE @ClaimLineDetailAdjudicate CHAR(1) = 'N'
			DECLARE @ClaimLineDetailVoid CHAR(1) = 'N'
			DECLARE @ClaimLineDetailManualPend CHAR(1) = 'N'

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'CheckBox_ClaimLines_ClaimLineUnderReview'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					) OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'CheckBox_ClaimLines_ClaimLineUnderReview'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineUnderReview = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'CheckBox_ClaimLines_FinalStatus'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'CheckBox_ClaimLines_FinalStatus'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @FinalStatus = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineTBW'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					) OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineTBW'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @RemoveToBeWorked = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDeny'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)OR NOT EXISTS( SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDeny'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N' )
			BEGIN
				SET @Deny = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineAdjudicate'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineAdjudicate'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @Adjudicate = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLinePay'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					) OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLinePay'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLinePay = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDenialLetter'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					) OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDenialLetter'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @DenialLetter = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineRevert'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineRevert'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @Revert = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineReAdjudicate'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					) OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineReAdjudicate'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ReAdjudicate = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDoNotAdjudicate'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDoNotAdjudicate'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @DoNotAdjudicate = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineVoid'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineVoid'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @Void = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineManualPend'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineManualPend'
								AND screenid = 1001
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ManualPend = 'Y'
			END

			--Check permission for the ToolTips Controls in Claim Line Detail Page
			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonRevertClaims'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonRevertClaims'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineDetailRevert = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLinePay'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLinePay'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineDetailPay = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDeny'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineDeny'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineDetailDeny = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineApprove'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineApprove'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineDetailApprove = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineAdjudicate'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineAdjudicate'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineDetailAdjudicate = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineVoid'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineVoid'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineDetailVoid = 'Y'
			END

			IF EXISTS (
					SELECT *
					FROM viewstaffpermissions
					WHERE staffid = @LoginStaffId
						AND permissionitemid = (
							SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineManualPend'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N'
							)
						AND PermissionTemplateType IN (
							5701
							,5702
							)
					)  OR NOT EXISTS(SELECT screenpermissioncontrolId
							FROM screenpermissioncontrols
							WHERE controlname = 'ButtonClaimLineManualPend'
								AND screenid = 1010
								AND isnull(RecordDeleted, 'N') = 'N')
			BEGIN
				SET @ClaimLineDetailManualPend = 'Y'
			END

			SELECT  @ClaimLineUnderReview AS ClaimLineUnderReview
				,@FinalStatus AS FinalStatus
				,@RemoveToBeWorked AS RemoveToBeWorked
				,@Deny AS Denied
				,@Adjudicate AS Adjudicate
				,@ClaimLinePay AS ClaimLinePay
				,@DenialLetter AS DenialLetter
				,@Revert AS ClaimLineRevert
				,@ReAdjudicate AS ReAdjudicate
				,@DoNotAdjudicate AS DoNotAdjudicate
				,@Void AS Void
				,@ManualPend AS ManualPend
				,@ClaimLineDetailRevert AS ClaimLineDetailRevert
				,@ClaimLineDetailPay AS ClaimLineDetailPay
				,@ClaimLineDetailDeny AS ClaimLineDetailDeny
				,@ClaimLineDetailApprove AS ClaimLineDetailApprove
				,@ClaimLineDetailAdjudicate AS ClaimLineDetailAdjudicate
				,@ClaimLineDetailVoid AS ClaimLineDetailVoid
				,@ClaimLineDetailManualPend AS ClaimLineDetailManualPend
			
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCCheckClaimLineActionControlsPermission]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
