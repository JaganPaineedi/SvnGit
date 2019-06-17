/****** Object:  StoredProcedure [dbo].[ssp_getStaffInformation]    Script Date: 04/10/2012 16:02:57 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_getStaffInformation]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_getStaffInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_getStaffInformation]    Script Date: 04/10/2012 16:02:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_getStaffInformation] ( @LoggedInUserId INT )
AS
/*********************************************************************/                                                
/* Stored Procedure: dbo.ssp_getStaffInformation        */                                                
/* Creation Date:    22/March/2011                                   */                                                
/* Created By:                                         */                                                
/* Purpose:	Get Staff Information                                  */                                                
/*                                                                   */                                                 
/* Input Parameters:												 */                                                
/*                                                                   */                                                
/* Output Parameters:                                                */                                                
/*                                                                   */                                                
/* Return Status:                                                    */                                                
/*                                                                   */                                                
/* Called By:                                                        */                                                
/*                                                                   */                                                
/* Calls:                                                            */                                                
/*                                                                   */                                                
/* Data Modifications:                                               */                                                
/*                                                                   */                                                
/* Updates:                                                          */                                                
/*   Date                   Author				Purpose                      */  
/*	14-Jan-2013				Sanjayb				without changes, we are recommiting this SP for CentraWellness*/  
/*												w.r.t Task#430 in Project Centrawellness-Bugs/Features    */  
/*												My preferences:Home page field data is not updating */   
/*  21 Feb 2013				Saurav Pande		Add new column "RxAuthorizedProvider" w.r t task 518 in Centrawellness-Bugs/Features	*/                                             
/*  01 MAr 2013             Praveen Potnuru     Added new column 'DetermineCaseloadBy' w.r.t task 183 in 3.5x issues */
/*  13 Dec 2013             Manju P             Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes*/
/*  17 July2014             Shruthi.S           Added NonStafflist field.Since, it was added in 3.5x and pushed to 4.0x database.*/
/*  21/10/2014              Shruthi.S           Added column All837Senders which was needed for 837 import logic.Ref #124 CM to SC.  */
/* 04-02-2015		Vaibhav Khare   What added one more field "ScheduleWidgetStaff "for default Schedule widget .  */
-- 12 May 2015      Veena           What:Added FinancialAssignmentId in staff table.Valley Customization #950     
-- Aug 08 2015		Pradeep			Added  EnableRxPopupAcknowledgement column. Core Bugs #1886     
-- Oct 03 2016      Pavani          Added MobileSmartKey,AllowMobileAccess, 
--                                  MobileSmartKeyExpiresNextLogin columns Mobile Task#2 
-- Nov-28-2016      Arjun KR        Added  ReminderPreference dummy column in select for task #447 AspenPointe Customization  
/* Nov-28-2016 Lakshmi Kanth    Added coloumn 'AllowAccessToAllScannedDocuments' to staff table, Ionia - Support #370 
*/    
-- Jan-3-2016       Arjun K R       Added ClientEmail dummy column in select query for task #447 AspenPointe Customization     
-- 19-Sep-2016		Anto 		    Added IsEPCSEnabled column in Staff table, EPCS #3        
/*********************************************************************/                  
    BEGIN
        --Nov-28-2016      Arjun KR
		DECLARE @ReminderPreference INT
		DECLARE @TempClientId INT
		DECLARE @ClientEmail VARCHAR(100)
		
		SET @TempClientId=(SELECT TempClientId FROM Staff WHERE StaffId=@LoggedInUserId AND ISNULL(RecordDeleted,'N')='N')
		
	    SET @ReminderPreference=(SELECT ReminderPreference FROM Clients 
								 WHERE ISNULL(RecordDeleted,'N')='N' AND ClientId=@TempClientId)	
	    SET @ClientEmail=(SELECT Email FROM Clients  WHERE ISNULL(RecordDeleted,'N')='N' AND ClientId=@TempClientId)	
    
    
        SELECT  
                StaffId ,
                CreatedBy ,
                CreatedDate ,
                ModifiedBy ,
                ModifiedDate ,
                RowIdentifier ,
                RecordDeleted ,
                DeletedBy ,
                DeletedDate ,
                UserCode ,
                LastName ,
                FirstName ,
                MiddleName ,
                Active ,
                SSN ,
                Sex ,
                DOB ,
                EmploymentStart ,
                EmploymentEnd ,
                LicenseNumber ,
                TaxonomyCode ,
                Degree ,
                SigningSuffix ,
                CoSignerId ,
                CosignRequired ,
                Clinician ,
                Attending ,
                ProgramManager ,
                IntakeStaff ,
                AppointmentSearch ,
                CoSigner ,
                AdminStaff ,
                Prescriber ,
                LastSynchronizedId ,
                UserPassword ,
                AllowedPrinting ,
                Email ,
                PhoneNumber ,
                OfficePhone1 ,
                OfficePhone2 ,
                CellPhone ,
                HomePhone ,
                PagerNumber ,
                FaxNumber ,
                [Address] ,
                City ,
                [State] ,
                Zip ,
                AddressDisplay ,
                InLineSpellCheck ,
                DisplayPrimaryClients ,
                FontName ,
                FontSize ,
                SynchronizationOnStart ,
                SynchronizationOnClose ,
                EncryptionSwitch ,
                PrimaryRoleId ,
                PrimaryProgramId ,
                LastVisit ,
                PasswordExpires ,
                PasswordExpiresNextLogin ,
                PasswordExpirationDate ,
                SendConnectionInformation ,
                PasswordSendMethod ,
                PasswordCallPhoneNumber ,
                AccessCareManagement ,
                AccessSmartCare ,
                AccessPracticeManagement ,
                Administrator ,
                SystemAdministrator ,
                CanViewStaffProductivity ,
                CanCreateManageStaff ,
                Comment ,
                ProductivityDashboardUnit ,
                ProductivityComment ,
                TargetsComment ,
                HomePage ,
                DefaultReceptionViewId ,
                DefaultCalenderViewType ,
                DefaultCalendarStaffId ,
                DefaultMultiStaffViewId ,
                DefaultProgramViewId ,
                DefaultCalendarIncrement ,
                UsePrimaryProgramForCaseload ,
                EHRUser ,
                DefaultReceptionStatus ,
                NationalProviderId ,
                ClientPagePreferences ,
                RetainMessagesDays ,
                MedicationDaysDefault ,
                ViewDocumentsBanner ,
                ExternalReferenceId ,
                DEANumber ,
                Supervisor ,
                DefaultPrescribingLocation ,
                DefaultImageServerId ,
                LastPrescriptionReviewTime ,
                DefaultPrescribingQuantity ,
                AllowRemoteAccess ,
                CanSignUsingSignaturePad ,
                SureScriptsPrescriberId ,
                SureScriptsLocationId ,
                SureScriptsActiveStartTime ,
                SureScriptsActiveEndTime ,
                SureScriptsLastUpdateTime ,
                SureScriptsServiceLevel ,
                AllowEmergencyAccess ,
                EmergencyAccessRoleId ,
                HomePageScreenId ,
                ClientPagePreferenceScreenId ,
                AuthenticationType ,
                AccessProviderAccess,
                ProjectedTimeOffHours,
                Initial,
                RxAuthorizedProvider,
                DetermineCaseloadBy,
                Color,
                MaritalStatus,
                DisplayAs,
                AllInsurers,
				PrimaryInsurerId,
				AllProviders,
				PrimaryProviderId,
				NonStaffUser,
				TempClientId,
				All837Senders,
				TempClientContactId,
				DirectEmailAddress,
				DirectEmailPassword,
				ScheduleWidgetStaff,
				DXSearchPreference,
				--12 May 2015 Added FinancialAssignmentId in staff
				FinancialAssignmentId,
				EnableRxPopupAcknowledgement,
				--Oct 03 2016   Pavani
				 MobileSmartKey,  
                 AllowMobileAccess,
                 MobileSmartKeyExpiresNextLogin, 
                 @ReminderPreference AS ReminderPreference,  --Nov-28-2016      Arjun KR
                 AllowAccessToAllScannedDocuments,
                 @ClientEmail AS ClientEmail,    --Jan 3-2016 Arjun K R
				 IsEPCSEnabled
                 
				
        FROM    Staff
        WHERE   ( StaffId = @LoggedInUserId ) 
    END
GO


