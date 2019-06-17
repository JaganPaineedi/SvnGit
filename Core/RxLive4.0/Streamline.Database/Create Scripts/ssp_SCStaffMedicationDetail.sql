/****** Object:  StoredProcedure [dbo].[ssp_SCStaffMedicationDetail]    Script Date: 8/29/2013 3:59:22 PM ******/
if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_SCStaffMedicationDetail]')
                    and type in ( N'P', N'PC' ) ) 
    drop procedure [dbo].[ssp_SCStaffMedicationDetail]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCStaffMedicationDetail]    Script Date: 8/29/2013 3:59:22 PM ******/
set ANSI_NULLS on
GO

set QUOTED_IDENTIFIER on
GO

create procedure [dbo].[ssp_SCStaffMedicationDetail]
as /*********************************************************************/                                  
/* Stored Procedure: dbo.ssp_SCStaffMedicationDetail					*/                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC			    */                                  
/* Creation Date:    03/30/2009											*/                                  
/*																		*/	                                  
/* Purpose:Used to fill the values in User Preferences					*/                                 
/*																		*/                                
/* Input Parameters:													*/                                
/*																		*/                                  
/* Output Parameters:   None											*/                                  
/*																		*/                                  
/* Return:  0=success, otherwise an error number						*/                                  
/*																		*/                                  
/* Called By: DownloadStaffMedicationDetail() in MSDE					*/                                  
/*																		*/                                  
/* Calls:																*/                                  
/*																		*/                                  
/* Data Modifications:													*/                                  
/*																		*/                                  
/* Updates:																*/                                  
/*    Date        Author       Purpose									*/                                  
/* 03/30/2009   Loveena    Created										*/  
/* Aug 29, 2013 Updated Column List from Staff Tables					*/                               
/* June 2, 2015 Wasif Butt 4.0 Updated Column List from Staff Tables	*/ 
/* 19-Sep-2016	Anto 		 Added IsEPCSEnabled column in Staff table, EPCS #3   */  
/* 22-Nov-2016	Pavani 		 Added IsEPCSEnabled column in Staff table, EPCS #3   */   
-- 20-Nov-2016 Lakshmi Kanth              Implemented Scanning Access logic to the loggedIn Staff, Ionia - Support #370
-- 13-Feb-2017 Nandita		Added checks to eliminate deleted records from StaffPermissions and   TwoFactorAuthenticationDeviceRegistrations tables.                    
/************************************************************************/                                   
                              
    begin                                
                      						 
						                         
        select  S.StaffId  
              , S.CreatedBy  
              , S.CreatedDate  
              , S.ModifiedBy  
              , S.ModifiedDate  
              , S.RowIdentifier  
              , S.RecordDeleted  
              , S.DeletedBy  
              , S.DeletedDate  
              , UserCode
              , LastName
              , FirstName
              , MiddleName
              , Active
              , SSN
              , Sex
              , DOB
              , EmploymentStart
              , EmploymentEnd
              , LicenseNumber
              , TaxonomyCode
              , Degree
              , SigningSuffix
              , CoSignerId
              , CosignRequired
              , Clinician
              , Attending
              , ProgramManager
              , IntakeStaff
              , AppointmentSearch
              , CoSigner
              , AdminStaff
              , Prescriber
              , LastSynchronizedId
              , UserPassword
              , AllowedPrinting
              , Email
              , PhoneNumber
              , OfficePhone1
              , OfficePhone2
              , CellPhone
              , HomePhone
              , PagerNumber
              , FaxNumber
              , Address
              , City
              , State
              , Zip
              , AddressDisplay
              , InLineSpellCheck
              , DisplayPrimaryClients
              , FontName
              , FontSize
              , SynchronizationOnStart
              , SynchronizationOnClose
              , EncryptionSwitch
              , PrimaryRoleId
              , PrimaryProgramId
              , LastVisit
              , PasswordExpires
              , PasswordExpiresNextLogin
              , PasswordExpirationDate
              , SendConnectionInformation
              , PasswordSendMethod
              , PasswordCallPhoneNumber
              , AccessCareManagement
              , AccessSmartCare
              , AccessPracticeManagement
              , Administrator
              , SystemAdministrator
              , CanViewStaffProductivity
              , CanCreateManageStaff
              , Comment
              , ProductivityDashboardUnit
              , ProductivityComment
              , TargetsComment
              , HomePage
              , DefaultReceptionViewId
              , DefaultCalenderViewType
              , DefaultCalendarStaffId
              , DefaultMultiStaffViewId
              , DefaultProgramViewId
              , DefaultCalendarIncrement
              , UsePrimaryProgramForCaseload
              , EHRUser
              , DefaultReceptionStatus
              , NationalProviderId
              , ClientPagePreferences
              , RetainMessagesDays
              , MedicationDaysDefault
              , ViewDocumentsBanner
              , ExternalReferenceId
              , DEANumber
              , Supervisor
              , DefaultPrescribingLocation
              , DefaultImageServerId
              , LastPrescriptionReviewTime
              , DefaultPrescribingQuantity
              , AllowRemoteAccess
              , CanSignUsingSignaturePad
              , SureScriptsPrescriberId
              , SureScriptsLocationId
              , SureScriptsActiveStartTime
              , SureScriptsActiveEndTime
              , SureScriptsLastUpdateTime
              , SureScriptsServiceLevel
              , AllowEmergencyAccess
              , EmergencyAccessRoleId
              , HomePageScreenId
              , ClientPagePreferenceScreenId
              , AuthenticationType
              , AccessProviderAccess
              , ProjectedTimeOffHours
              , Initial
              , RxAuthorizedProvider
              , DetermineCaseloadBy
              , Color
              , MaritalStatus
              , rtrim(ltrim(lastName)) + ', ' + rtrim(FirstName) as StaffName
              , DisplayAs
              , NonStaffUser
              , TempClientId
              , TempClientContactId
              , DirectEmailAddress
              , DirectEmailPassword
              , ScheduleWidgetStaff
              , DXSearchPreference
              , AllInsurers
              , PrimaryInsurerId
              , AllProviders
              , PrimaryProviderId
              , All837Senders
              , FinancialAssignmentId
               -- 23-11-2016       Pavani 
              ,EnableRxPopupAcknowledgement
              ,NADEANumber
              --End
              , IsEPCSEnabled as EPCS              
              , CASE WHEN SP.ActionId = 10023 AND S.Prescriber = 'Y' AND TFA.Authenticated = 'Y' THEN 'Y' ELSE 'N' END AS Permission    
               -- 22-11-2016       Pavani 
              ,MobileSmartKey 
              ,AllowMobileAccess
              ,MobileSmartKeyExpiresNextLogin
              ,AllowAccessToAllScannedDocuments
			   ,SP.StaffPermissionId
			  ,TFA.TwoFactorAuthenticationDeviceRegistrationId
			  --EPCSPermission Task#45 Added Pranay 
			  ,CASE WHEN S.Prescriber = 'Y' AND TFA.Authenticated = 'Y' THEN 'Y' ELSE 'N' END AS EPCSPermission    
              --End
        from    Staff S
        LEFT JOIN StaffPermissions SP 
					ON S.StaffId = SP.StaffId AND SP.ActionId = 10023 
        LEFT JOIN TwoFactorAuthenticationDeviceRegistrations TFA
                    ON S.StaffId = 	TFA.StaffId AND TFA.Authenticated = 'Y'	
        where   isnull(S.RecordDeleted, 'N') = 'N'
		and isnull(SP.RecordDeleted, 'N') = 'N'
		and isnull(TFA.RecordDeleted, 'N') = 'N'
        order by LastName
              , FirstName      
        if ( @@error != 0 ) 
            begin                                
                raiserror  20002 'Staff Detail: An Error Occured '                                
                return(1)                                
            end                                
        return(0)                                
    end

GO


