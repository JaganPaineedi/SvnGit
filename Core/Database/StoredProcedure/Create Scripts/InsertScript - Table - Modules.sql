/****** Object:  Table [dbo].[Modules]    Script Date: 08/05/2016 14:51:51 ******/

IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Service Note') 
	BEGIN 
		INSERT [dbo].[Modules] ([ModuleName])
		VALUES ('Service Note')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Service Detail') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Service Detail')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Group Service Detail') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Group Service Detail')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'BedBoard/Census Management') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('BedBoard/Census Management')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'ICD10Diagnosis') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('ICD10Diagnosis')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'MAR') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('MAR')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'BedBoard/Bed Activity Details') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('BedBoard/Bed Activity Details')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Provider dropdown in Application') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Provider dropdown in Application')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Insurer dropdown in CM Widgets') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Insurer dropdown in CM Widgets')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Client Information (Admin)') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Client Information (Admin)')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Plan Details') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Plan Details')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Staff List Page') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Staff List Page')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Staff Details') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Staff Details')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Client Information') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Client Information')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Client Search pop up') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Client Search pop up')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Service From Claims') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Service From Claims')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Clinical Summary') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Clinical Summary')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Appointment Search') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Appointment Search')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Client Tab') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Client Tab')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Disclosure/Request Details') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Disclosure/Request Details')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Login Page') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Login Page')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Collections') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Collections')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Letter') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Letter')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Care Management') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Care Management')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Client Orders') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Client Orders')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Insurance Eligibility Verification') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Insurance Eligibility Verification')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Whiteboard') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Whiteboard')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Team Scheduling') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Team Scheduling')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Payment Adjustment') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Payment Adjustment')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Reception') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Reception')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Providers') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Providers')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'UnableToOfferTimelyAppointment/Appointment Search') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('UnableToOfferTimelyAppointment/Appointment Search')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Refusal Reason') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Refusal Reason')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'EM code Documents') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('EM code Documents')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Documents') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Documents')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Claims Processing') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Claims Processing')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Time Sheet Entry') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Time Sheet Entry')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Authorization Detail Page-Intervention Date') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Authorization Detail Page-Intervention Date')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Authorization Defaults List Page') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Authorization Defaults List Page')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Widgets') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Widgets')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Client Summary') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Client Summary')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Office Detail') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Office Detail')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Signature Page') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Signature Page')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Rx- Patient Consent Signature Pop up') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Rx- Patient Consent Signature Pop up')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Login Page, Staff Preferencses, Staff Details') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Login Page, Staff Preferencses, Staff Details')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Grievances') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Grievances')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Inquiries') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Inquiries')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Rx - Patient Summary') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Rx - Patient Summary')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'PrimaryCare') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('PrimaryCare')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Contact Note Detail') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Contact Note Detail')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Scanning list page') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Scanning list page')
	END
	
IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'Reception List Page-Balance Entry-Payment Details Popup') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('Reception List Page-Balance Entry-Payment Details Popup')
	END