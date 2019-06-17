/****** Object:  Table [dbo].[ModuleScreens]    Script Date: 08/05/2016 14:51:51 ******/

IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Service Note')  AND [ScreenId] = 29) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Service Note')
		,29)
	END
	
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Service Detail')  AND [ScreenId] = 207) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Service Detail')
		,207)
	END
	
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Service Detail')  AND [ScreenId] = 210) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Service Detail')
		,210)
	END
	
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Group Service Detail')  AND [ScreenId] = 46) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Group Service Detail')
		,46)
	END
	
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')  AND [ScreenId] = 910) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')
		,910)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')  AND [ScreenId] = 147) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')
		,147)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')  AND [ScreenId] = 10206) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')
		,909)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')  AND [ScreenId] = 912) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'BedBoard/Census Management')
		,912)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'ICD10Diagnosis')  AND [ScreenId] = 979) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'ICD10Diagnosis')
		,979)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'MAR')  AND [ScreenId] = 908) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'MAR')
		,908)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'MAR')  AND [ScreenId] = 1133) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'MAR')
		,1133)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'BedBoard/Bed Activity Details')  AND [ScreenId] = 911) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'BedBoard/Bed Activity Details')
		,911)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Client Information (Admin)')  AND [ScreenId] = 969) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Client Information (Admin)')
		,969)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Client Information (Admin)')  AND [ScreenId] = 370) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Client Information (Admin)')
		,370)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Plan Details')  AND [ScreenId] = 309) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Plan Details')
		,309)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Staff List Page')  AND [ScreenId] = 84) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Staff List Page')
		,84)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Staff Details')  AND [ScreenId] = 329) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Staff Details')
		,329)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Client Information')  AND [ScreenId] = 370) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Client Information')
		,370)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Client Information')  AND [ScreenId] = 969) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Client Information')
		,969)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Client Search pop up')  AND [ScreenId] = 27) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Client Search pop up')
		,27)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Service From Claims')  AND [ScreenId] = 1116) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Service From Claims')
		,1116)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Clinical Summary')  AND [ScreenId] = 939) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Clinical Summary')
		,939)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Appointment Search')  AND [ScreenId] = 362) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Appointment Search')
		,362)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Disclosure/Request Details')  AND [ScreenId] = 26) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Disclosure/Request Details')
		,26)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Collections')  AND [ScreenId] = 1153) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Collections')
		,1153)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Collections')  AND [ScreenId] = 1155) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Collections')
		,1155)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Letter')  AND [ScreenId] = 1156) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Letter')
		,1156)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Care Management')  AND [ScreenId] = 1043) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Care Management')
		,1043)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Care Management')  AND [ScreenId] = 950) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Care Management')
		,950)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Care Management')  AND [ScreenId] = 994) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Care Management')
		,994)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Client Orders')  AND [ScreenId] = 772) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Client Orders')
		,772)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Insurance Eligibility Verification')  AND [ScreenId] = 381) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Insurance Eligibility Verification')
		,381)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Whiteboard')  AND [ScreenId] = 907) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Whiteboard')
		,907)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Team Scheduling')  AND [ScreenId] = 758) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Team Scheduling')
		,758)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Payment Adjustment')  AND [ScreenId] = 323) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Payment Adjustment')
		,323)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Reception')  AND [ScreenId] = 324) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Reception')
		,324)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Providers')  AND [ScreenId] = 1070) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Providers')
		,1070)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'UnableToOfferTimelyAppointment/Appointment Search')  AND [ScreenId] = 362) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'UnableToOfferTimelyAppointment/Appointment Search')
		,362)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Refusal Reason')  AND [ScreenId] = 382) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Refusal Reason')
		,382)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Refusal Reason')  AND [ScreenId] = 368) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Refusal Reason')
		,368)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Time Sheet Entry')  AND [ScreenId] = 1172) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Time Sheet Entry')
		,1172)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Authorization Defaults List Page')  AND [ScreenId] = 1149) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Authorization Defaults List Page')
		,1149)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Client Summary')  AND [ScreenId] = 977) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Client Summary')
		,977)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Office Detail')  AND [ScreenId] = 354) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Office Detail')
		,354)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Signature Page')  AND [ScreenId] = 61) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Signature Page')
		,61)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Grievances')  AND [ScreenId] = 70) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Grievances')
		,70)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Inquiries')  AND [ScreenId] = 72) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Inquiries')
		,72)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Contact Note Detail')  AND [ScreenId] = 924) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Contact Note Detail')
		,924)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Scanning list page')  AND [ScreenId] = 83) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Scanning list page')
		,83)
	END
			
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'Reception List Page-Balance Entry-Payment Details Popup')  AND [ScreenId] = 365) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'Reception List Page-Balance Entry-Payment Details Popup')
		,365)
	END
