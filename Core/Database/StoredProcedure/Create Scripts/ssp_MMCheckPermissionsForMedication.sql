/****** Object:  StoredProcedure [dbo].[ssp_MMCheckPermissionsForMedication]    Script Date: 8/29/2013 4:06:59 PM ******/
if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_MMCheckPermissionsForMedication]')
                    and type in ( N'P', N'PC' ) ) 
    drop procedure [dbo].[ssp_MMCheckPermissionsForMedication]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMCheckPermissionsForMedication]    Script Date: 8/29/2013 4:06:59 PM ******/
set ANSI_NULLS on
GO

set QUOTED_IDENTIFIER on
GO

create  procedure [dbo].[ssp_MMCheckPermissionsForMedication] ( @varStaffID int )
as 
    begin                                          
/****************************************************************************************************/                                            
/* Stored Procedure: dbo.ssp_SCCheckPermissionsForMedication										*/                                            
/* Copyright: 2009 Medication Management															*/                                            
/* Creation Date:  23 April 2009																	*/                                            
/*																									*/                                            
/* Purpose: it will get permissions assigned to the user											*/                                           
/*																									*/                                          
/* Input Parameters: @varStaffID																	*/                                          
/*																									*/                                            
/* Output Parameters:																				*/                                            
/*																									*/                                            
/* Return:Permissions of the user																	*/                                            
/*																									*/                                            
/* Called By:   UserPrefernces in DataService														*/                                            
/*																									*/                                            
/* Calls:																							*/                                            
/*																									*/                                            
/* Data Modifications:																				*/                                            
/*																									*/                                            
/* Updates:																							*/                                            
/*  Date        Author        Purpose																*/                                            
/* 23/04/2009   Loveena       Created																*/                 
/* 25 Nov 2009  Pradeep       added DefaultPrescribingQuantity in select Statement					*/              
/*in select Statement from staff table as per task#2639												*/         
/* 8 June 2012  Kneale        Added HomePage to the staff select									*/     
/* 11 Oct 2012  Kneale        Added missing columns to the staff select								*/               
/* 27 Feb 2013  Chuck Blaine	Added column for RxAuthorizedPrescriber field in staff select		*/  
/* Aug 29, 2013 Kneale   Added missing columns to the staff select									*/               
/* Jan 3, 2014  Chuck Blaine    Added missing DisplayAs column to staff select						*/
/* June 2, 2015  Wasif Butt     Added new 4.0 staff columns to staff select							*/
/* Sep 1, 2015  Wasif Butt     Added new 4.0 staff column EnableRxPopupAcknowledgement toselect		*/
/* Aug 16, 2015  Vithobha     Added new 4.0 staff column NADEANumber toselect		*/
/* 22-Nov-2016		Pavani 		What: Added MobileSmartKey,AllowMobileAccess,MobileSmartKeyExpiresNextLogin Columnsin Staff table
                                Why :Mobile #2  */
/* Nov-28-2016 Lakshmi Kanth    Added coloumn 'AllowAccessToAllScannedDocuments' to staff table, Ionia - Support #370 
/* 19-Sep-2016		Anto 		Added IsEPCSEnabled column in Staff table, EPCS #3  
*/
/* EPCS: Task# 14
Implemented Device Registration Section in Rx "My Preference" screen for Two factor Authentication
*/*/
/****************************************************************************************************/                                             
                                        
        begin    
            select  StaffId
                  , CreatedBy
                  , CreatedDate
                  , ModifiedBy
                  , ModifiedDate
                  , RowIdentifier
                  , RecordDeleted
                  , DeletedBy
                  , DeletedDate
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
				  , EnableRxPopupAcknowledgement
				  , NADEANumber
				  --22-Nov-2016		Pavani
				  ,MobileSmartKey
                  ,AllowMobileAccess
                  ,MobileSmartKeyExpiresNextLogin
                  ,AllowAccessToAllScannedDocuments
                  --End
				  , IsEPCSEnabled
            from    dbo.Staff
            where   isnull(RecordDeleted, 'N') = 'N'
                    and StaffId = @varStaffID
            order by LastName
                  , FirstName   
                                                                       
                           
 /*Staff Permissions*/                          
            select  sa.ActionId
                  , sa.ScreenName
                  , sa.Action
                  , StaffPermissionId
                  , sp.StaffId
                  , sp.RowIdentifier
                  , sp.CreatedBy
                  , sp.CreatedDate
                  , sp.ModifiedBy
                  , sp.ModifiedDate
                  , sp.RecordDeleted
                  , sp.DeletedBy
                  , sp.DeletedDate
            from    SystemActions sa
                    inner join StaffPermissions sp on sa.ActionId = sp.ActionId
            where   sp.StaffId = @varStaffID
                    and isnull(sp.RecordDeleted, 'N') = 'N'
                    and isnull(sa.RecordDeleted, 'N') = 'N'
                    and ApplicationId = 5
            order by sa.ActionId                   
                  
/*Staff Security Questions*/                       
            select  StaffSecurityQuestionId
                  , StaffId
                  , SecurityQuestion
                  , SecurityAnswer
                  , RowIdentifier
                  , CreatedBy
                  , CreatedDate
                  , ModifiedBy
                  , ModifiedDate
                  , RecordDeleted
                  , DeletedDate
                  , DeletedBy
            from    StaffSecurityQuestions
            where   isnull(RecordDeleted, 'N') = 'N'
                    and StaffId = @varStaffID                               
            select  top 1 TwoFactorAuthenticationDeviceRegistrationId
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,RecordDeleted
					,DeletedBy
					,DeletedDate
					,StaffId
					,DeviceName
					,DeviceSerialNumber
					,DeviceEmail
					,DevicePassword
					,Authenticated
            from    TwoFactorAuthenticationDeviceRegistrations
            where   isnull(RecordDeleted, 'N') = 'N'
                    and StaffId = @varStaffID 
                     order by 1 desc                              
        end                                          
                                          
        if ( @@error != 0 ) 
            begin                                          
                    
                RAISERROR ('ssp_MMCheckPermissionsForMedication: An Error Occured',16,1);                                     
                return                                         
            end                                          
                                      
                                          
    end 



GO


