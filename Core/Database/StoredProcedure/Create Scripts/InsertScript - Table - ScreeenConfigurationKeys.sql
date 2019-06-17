/****** Object:  Table [dbo].[ScreenConfigurationKeys]    Script Date: 08/05/2016 14:51:51 ******/

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')  AND [ScreenId] = 29) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')
		,29)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')  AND [ScreenId] = 207) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')
		,207)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')  AND [ScreenId] = 210) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')
		,210)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')  AND [ScreenId] = 46) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'INITIALIZEDIAGNOSISORDER')
		,46)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BILLINGDIAGNOSISDEFAULTBUTTON')  AND [ScreenId] = 29) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BILLINGDIAGNOSISDEFAULTBUTTON')
		,29)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BILLINGDIAGNOSISDEFAULTBUTTON')  AND [ScreenId] = 207) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BILLINGDIAGNOSISDEFAULTBUTTON')
		,207)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BILLINGDIAGNOSISDEFAULTBUTTON')  AND [ScreenId] = 210) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BILLINGDIAGNOSISDEFAULTBUTTON')
		,210)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DiagnosisPageSize')  AND [ScreenId] = 979) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DiagnosisPageSize')
		,979)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAR_ShowAdministeredName')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAR_ShowAdministeredName')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDADMISSIONORDERREQUIRED')  AND [ScreenId] = 910) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDADMISSIONORDERREQUIRED')
		,910)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDADMISSIONORDERREQUIRED')  AND [ScreenId] = 911) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDADMISSIONORDERREQUIRED')
		,911)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDDISCHARGEORDERREQUIRED')  AND [ScreenId] = 910) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDDISCHARGEORDERREQUIRED')
		,910)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDDISCHARGEORDERREQUIRED')  AND [ScreenId] = 911) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDBOARDDISCHARGEORDERREQUIRED')
		,911)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSADMISSIONORDERREQUIRED')  AND [ScreenId] = 910) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSADMISSIONORDERREQUIRED')
		,910)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSADMISSIONORDERREQUIRED')  AND [ScreenId] = 911) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSADMISSIONORDERREQUIRED')
		,911)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSDISCHARGEORDERREQUIRED')  AND [ScreenId] = 910) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSDISCHARGEORDERREQUIRED')
		,910)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSDISCHARGEORDERREQUIRED')  AND [ScreenId] = 911) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDCENSUSDISCHARGEORDERREQUIRED')
		,911)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDPROGRAMENROLLMENT')  AND [ScreenId] = 910) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDPROGRAMENROLLMENT')
		,910)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDPROGRAMENROLLMENT')  AND [ScreenId] = 911) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'BEDPROGRAMENROLLMENT')
		,911)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableCMClientInfoTab')  AND [ScreenId] = 969) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableCMClientInfoTab')
		,969)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnablePlanCMTab')  AND [ScreenId] = 309) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnablePlanCMTab')
		,309)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'StaffProviderInsurerFilter')  AND [ScreenId] = 84) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'StaffProviderInsurerFilter')
		,84)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DISPLAYCAREMANAGEMENTTAB')  AND [ScreenId] = 329) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DISPLAYCAREMANAGEMENTTAB')
		,329)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableSADemographicTab')  AND [ScreenId] = 370) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableSADemographicTab')
		,370)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisplayProviderDropDown')  AND [ScreenId] = 27) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisplayProviderDropDown')
		,27)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DefaultClinicianFromClaimToServiceCreation')  AND [ScreenId] = 1116) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DefaultClinicianFromClaimToServiceCreation')
		,1116)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalInstruction')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalInstruction')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryFutureOrders')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryFutureOrders')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'CSUpComingAppointmentRangeInMonths')  AND [ScreenId] = 362) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'CSUpComingAppointmentRangeInMonths')
		,362)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisclosureWaterMarkText')  AND [ScreenId] = 26) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisclosureWaterMarkText')
		,26)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARDefaultAdministrationWindow')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARDefaultAdministrationWindow')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'CollectionsBalanceAmount')  AND [ScreenId] = 1153) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'CollectionsBalanceAmount')
		,1153)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'Collections#OfDaysOld')  AND [ScreenId] = 1153) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'Collections#OfDaysOld')
		,1153)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'Payment#OfDaysOld')  AND [ScreenId] = 1155) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'Payment#OfDaysOld')
		,1155)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LetterSaveAndClose')  AND [ScreenId] = 1156) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LetterSaveAndClose')
		,1156)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ATTENDINGREFERRING')  AND [ScreenId] = 29) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ATTENDINGREFERRING')
		,29)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowCMAuthorizationReasonforchange')  AND [ScreenId] = 1043) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowCMAuthorizationReasonforchange')
		,1043)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DISABLEBILLINGDXIFSERVICENOTEISDX')  AND [ScreenId] = 29) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DISABLEBILLINGDXIFSERVICENOTEISDX')
		,29)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LABSOFTORGANIZATIONID')  AND [ScreenId] = 772) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LABSOFTORGANIZATIONID')
		,772)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LABSOFTWEBSERVICEURL')  AND [ScreenId] = 772) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LABSOFTWEBSERVICEURL')
		,772)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LABSOFTENABLED')  AND [ScreenId] = 772) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'LABSOFTENABLED')
		,772)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowNPIProviderValidation')  AND [ScreenId] = 950) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowNPIProviderValidation')
		,950)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'CLEARMEDICAID')  AND [ScreenId] = 381) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'CLEARMEDICAID')
		,381)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'WB_RefreshRate')  AND [ScreenId] = 907) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'WB_RefreshRate')
		,907)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowMoveGroupMessage')  AND [ScreenId] = 758) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowMoveGroupMessage')
		,758)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'Autosecondarycopayment')  AND [ScreenId] = 323) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'Autosecondarycopayment')
		,323)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnablePaymentActivityType')  AND [ScreenId] = 323) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnablePaymentActivityType')
		,323)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARMinutesBeforeOverdue')  AND [ScreenId] = 1133) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARMinutesBeforeOverdue')
		,1133)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')  AND [ScreenId] = 147) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')
		,147)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')  AND [ScreenId] = 10206) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')
		,909)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')  AND [ScreenId] = 910) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')
		,910)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')  AND [ScreenId] = 912) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableClientEntrollValidation')
		,912)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARMinutes2XBeforeOverdue')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARMinutes2XBeforeOverdue')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAR_RefreshRate')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAR_RefreshRate')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'AppointmentMessage')  AND [ScreenId] = 324) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'AppointmentMessage')
		,324)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ScreenIdToRedirectOnClientCreation')  AND [ScreenId] = 27) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ScreenIdToRedirectOnClientCreation')
		,27)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ScreenIdToRedirectOnClientCreation')  AND [ScreenId] = 1070) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ScreenIdToRedirectOnClientCreation')
		,1070)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'PlaceOfService')  AND [ScreenId] = 46) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'PlaceOfService')
		,46)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'NeverDisplayTimelyAppointmentPopupAtAll')  AND [ScreenId] = 362) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'NeverDisplayTimelyAppointmentPopupAtAll')
		,362)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'NeverDisplayTimelyAppointmentPopupAtAll')  AND [ScreenId] = 382) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'NeverDisplayTimelyAppointmentPopupAtAll')
		,382)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisplayTimelyAppointmentPopupAllTheTime')  AND [ScreenId] = 362) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisplayTimelyAppointmentPopupAllTheTime')
		,362)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisplayTimelyAppointmentPopupAllTheTime')  AND [ScreenId] = 382) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DisplayTimelyAppointmentPopupAllTheTime')
		,382)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment')  AND [ScreenId] = 362) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment')
		,362)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment')  AND [ScreenId] = 382) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment')
		,382)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ScreenFilterDisabledListPages')  AND [ScreenId] = 368) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ScreenFilterDisabledListPages')
		,368)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'PaymentAdjustmentPostingRequireLocation')  AND [ScreenId] = 323) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'PaymentAdjustmentPostingRequireLocation')
		,323)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableToolSSNTop')  AND [ScreenId] = 977) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableToolSSNTop')
		,977)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableToolSSNTop')  AND [ScreenId] = 994) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableToolSSNTop')
		,994)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableToolSSNTop')  AND [ScreenId] = 969) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'EnableToolSSNTop')
		,969)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'SetDefaultFilterOnPaymentServiceSearch')  AND [ScreenId] = 354) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'SetDefaultFilterOnPaymentServiceSearch')
		,354)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAROverdueLookbackHours')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAROverdueLookbackHours')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAROverdueLookbackHours')  AND [ScreenId] = 907) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAROverdueLookbackHours')
		,907)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAROverdueLookbackHours')  AND [ScreenId] = 1133) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAROverdueLookbackHours')
		,1133)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARNumberofShifts')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARNumberofShifts')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARShiftStartTime')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MARShiftStartTime')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAREnableStaffDropDown')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MAREnableStaffDropDown')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'UseHTML5Signature')  AND [ScreenId] = 61) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'UseHTML5Signature')
		,61)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowRXMedInMAR')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowRXMedInMAR')
		,908)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'FQHCTab')  AND [ScreenId] = 370) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'FQHCTab')
		,370)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryGeneralInfo')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryGeneralInfo')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryClientInfo')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryClientInfo')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryVisitReason')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryVisitReason')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryDiagnosis')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryDiagnosis')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryProcedureIntervention')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryProcedureIntervention')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryVitals')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryVitals')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryAllergies')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryAllergies')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummarySmokingStatus')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummarySmokingStatus')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryCurrentMedication')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryCurrentMedication')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryMedicationAdministrated')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryMedicationAdministrated')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryImmunizations')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryImmunizations')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryResultReviewed')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryResultReviewed')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryEducation')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryEducation')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryReferralToOther')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryReferralToOther')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryAppointments')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryAppointments')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryGoalsObjectives')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryGoalsObjectives')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryProcedureDuringVisit')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryProcedureDuringVisit')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryOrderPending')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryOrderPending')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryCareTeam')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowClinicalSummaryCareTeam')
		,939)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowProgramInOtherDropdown')  AND [ScreenId] = 70) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowProgramInOtherDropdown')
		,70)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowProgramInOtherDropdown')  AND [ScreenId] = 72) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowProgramInOtherDropdown')
		,72)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'RefreshReceptionGridInterval')  AND [ScreenId] = 324) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'RefreshReceptionGridInterval')
		,324)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ApplyCustomCaseLoadLogic')  AND [ScreenId] = 18) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ApplyCustomCaseLoadLogic')
		,18)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'HideorShowAuthorizationCodes')  AND [ScreenId] = 1149) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'HideorShowAuthorizationCodes')
		,1149)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ValidateRefundType')  AND [ScreenId] = 323) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ValidateRefundType')
		,323)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'PREVENTBILLEDSERVICESOVERRIDE')  AND [ScreenId] = 207) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'PREVENTBILLEDSERVICESOVERRIDE')
		,207)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'AdminDisableTimeSheetAfterNumberOfDay')  AND [ScreenId] = 1172) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'AdminDisableTimeSheetAfterNumberOfDay')
		,1172)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'UserDisableTimeSheetAfterNumberOfDay')  AND [ScreenId] = 1172) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'UserDisableTimeSheetAfterNumberOfDay')
		,1172)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'SetDefaultAttending')  AND [ScreenId] = 210) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'SetDefaultAttending')
		,210)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'InstallSigPadDriverPrompt')  AND [ScreenId] = 61) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'InstallSigPadDriverPrompt')
		,61)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MakeDisclosedToAsTypeableSearch')  AND [ScreenId] = 26) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MakeDisclosedToAsTypeableSearch')
		,26)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'AuthorizationscreenId')  AND [ScreenId] = 924) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'AuthorizationscreenId')
		,924)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ENABLEBATCHSCANNING')  AND [ScreenId] = 83) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ENABLEBATCHSCANNING')
		,83)
	END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MakeLocationOnReceptionScreenAsRequired')  AND [ScreenId] = 365) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'MakeLocationOnReceptionScreenAsRequired')
		,365)
	END
