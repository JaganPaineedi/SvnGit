IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllNonStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAllNonStaff]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetAllNonStaff] 
(
	@TempClientId INT
)

AS
-- =============================================    

-- =============================================   
BEGIN
	BEGIN TRY
	 SELECT S.StaffId
	  ,CASE 
		 WHEN rtrim(ltrim(S.DisplayAs)) IS NULL
			THEN rtrim(ltrim(S.LastName)) + ',' + rtrim(S.FirstName)
		 ELSE rtrim(ltrim(s.DisplayAs))
	  END AS StaffName
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RowIdentifier]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[UserCode]
      ,[LastName]
      ,[FirstName]
      ,[MiddleName]
      ,[Active]
      ,[SSN]
      ,[Sex]
      ,[DOB]
      ,[EmploymentStart]
      ,[EmploymentEnd]
      ,[LicenseNumber]
      ,[TaxonomyCode]
      ,[Degree]
      ,[SigningSuffix]
      ,[CoSignerId]
      ,[CosignRequired]
      ,[Clinician]
      ,[Attending]
      ,[ProgramManager]
      ,[IntakeStaff]
      ,[AppointmentSearch]
      ,[CoSigner]
      ,[AdminStaff]
      ,[Prescriber]
      ,[LastSynchronizedId]
      ,[UserPassword]
      ,[AllowedPrinting]
      ,[Email]
      ,[PhoneNumber]
      ,[OfficePhone1]
      ,[OfficePhone2]
      ,[CellPhone]
      ,[HomePhone]
      ,[PagerNumber]
      ,[FaxNumber]
      ,[Address]
      ,[City]
      ,[State]
      ,[Zip]
      ,[AddressDisplay]
      ,[InLineSpellCheck]
      ,[DisplayPrimaryClients]
      ,[FontName]
      ,[FontSize]
      ,[SynchronizationOnStart]
      ,[SynchronizationOnClose]
      ,[EncryptionSwitch]
      ,[PrimaryRoleId]
      ,[PrimaryProgramId]
      ,[LastVisit]
      ,[PasswordExpires]
      ,[PasswordExpiresNextLogin]
      ,[PasswordExpirationDate]
      ,[SendConnectionInformation]
      ,[PasswordSendMethod]
      ,[PasswordCallPhoneNumber]
      ,[AccessCareManagement]
      ,[AccessSmartCare]
      ,[AccessPracticeManagement]
      ,[Administrator]
      ,[SystemAdministrator]
      ,[CanViewStaffProductivity]
      ,[CanCreateManageStaff]
      ,[Comment]
      ,[ProductivityDashboardUnit]
      ,[ProductivityComment]
      ,[TargetsComment]
      ,[HomePage]
      ,[DefaultReceptionViewId]
      ,[DefaultCalenderViewType]
      ,[DefaultCalendarStaffId]
      ,[DefaultMultiStaffViewId]
      ,[DefaultProgramViewId]
      ,[DefaultCalendarIncrement]
      ,[UsePrimaryProgramForCaseload]
      ,[EHRUser]
      ,[DefaultReceptionStatus]
      ,[NationalProviderId]
      ,[ClientPagePreferences]
      ,[RetainMessagesDays]
      ,[MedicationDaysDefault]
      ,[ViewDocumentsBanner]
      ,[ExternalReferenceId]
      ,[DEANumber]
      ,[Supervisor]
      ,[DefaultPrescribingLocation]
      ,[DefaultImageServerId]
      ,[LastPrescriptionReviewTime]
      ,[DefaultPrescribingQuantity]
      ,[AllowRemoteAccess]
      ,[CanSignUsingSignaturePad]
      ,[SureScriptsPrescriberId]
      ,[SureScriptsLocationId]
      ,[SureScriptsActiveStartTime]
      ,[SureScriptsActiveEndTime]
      ,[SureScriptsLastUpdateTime]
      ,[SureScriptsServiceLevel]
      ,[AllowEmergencyAccess]
      ,[EmergencyAccessRoleId]
      ,[HomePageScreenId]
      ,[ClientPagePreferenceScreenId]
      ,[AuthenticationType]
      ,[AccessProviderAccess]
      ,[ProjectedTimeOffHours]
      ,[Initial]
      ,[RxAuthorizedProvider]
      ,[DetermineCaseloadBy]
      ,[Color]
      ,[MaritalStatus]
      ,[DisplayAs]
      ,[NonStaffUser]
      ,[TempClientId]
      ,[TempClientContactId]
      ,[DirectEmailAddress]
      ,[DirectEmailPassword]
      ,[ScheduleWidgetStaff]
      ,[DXSearchPreference]
      ,[FinancialAssignmentId]
      ,[AllInsurers]
      ,[PrimaryInsurerId]
      ,[AllProviders]
      ,[PrimaryProviderId]
      ,[All837Senders]
      ,[EnableRxPopupAcknowledgement]
      ,[NADEANumber]
      ,[MobileSmartKey]
      ,[AllowMobileAccess]
      ,[MobileSmartKeyExpiresNextLogin]
      ,[AllowAccessToAllScannedDocuments]
  FROM Staff S
  WHERE Active='Y' AND ISNULL(S.RecordDeleted,'N')='N' AND NonStaffUser='Y' AND TempClientId=@TempClientId

END TRY

BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetAllNonStaff') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


