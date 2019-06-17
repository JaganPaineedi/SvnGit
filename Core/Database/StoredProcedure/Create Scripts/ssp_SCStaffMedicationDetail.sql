

/****** Object:  StoredProcedure [dbo].[ssp_SCStaffMedicationDetail]    Script Date: 01/06/2017 15:05:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCStaffMedicationDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCStaffMedicationDetail]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCStaffMedicationDetail]    Script Date: 01/06/2017 15:05:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
-- 22-11-2016       Pavani          Added MobileSmartKey,AllowMobileAccess,MobileSmartKeyExpiresNextLogin, Mobile Task#2
-- 23-11-2016       Pavani          Added EnableRxPopupAcknowledgement,NADEANumber
--                                  Why:Updated Column List from Staff Tables       
-- Nov-28-2016 Lakshmi Kanth         Added coloumn 'AllowAccessToAllScannedDocuments' to staff table, Ionia - Support #370 
/* Jan  6, 2017 Shankha B Added condition to fetch NonStaffUser = NULL/N */                               
-- 13-Feb-2017 Nandita		Added checks to eliminate deleted records from StaffPermissions and   TwoFactorAuthenticationDeviceRegistrations tables.                             
-- 10 Aug 2017		Vithobha	Modified the logic of StaffPermissions to avoid the duplicate records, MFS - Support Go Live: #173 
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
			 
               , CASE WHEN S.Prescriber = 'Y'
                          AND TFA.Authenticated = 'Y' THEN 'Y'
                     ELSE 'N'
                END AS EPCSPermission ,
                CASE WHEN ISNULL(TFA.Authenticated, 'N') = 'N' THEN 'N'
                     ELSE 'Y'
                END AS DeviceAuthenticated , --Pranay
                ISNULL(a.Enabled, 'N') AS EPCSEnabled   --Pranay Task#62 EPCS   
              --End
        from    Staff S
        -- 10 Aug 2017		Vithobha
        LEFT JOIN ( select max(StaffPermissionId) as StaffPermissionId,StaffId,ActionId
					FROM StaffPermissions 
					WHERE isnull(RecordDeleted, 'N') = 'N'
									AND ActionId = 10023
					Group by StaffId,ActionId)SP	
					ON S.StaffId = SP.StaffId 
        LEFT JOIN TwoFactorAuthenticationDeviceRegistrations TFA
                    ON S.StaffId = 	TFA.StaffId AND TFA.Authenticated = 'Y'	and isnull(TFA.RecordDeleted, 'N') = 'N'
		 LEFT JOIN ( SELECT  *
                            FROM    EPCSAssigment T1
                            WHERE   T1.CreatedDate = ( SELECT max(CreatedDate)
                                                       FROM   EPCSAssigment T2
                                                       WHERE  T1.PrescriberStaffId = T2.PrescriberStaffId
                                                     )) AS a ON a.PrescriberStaffId = s.StaffId   --Pranay Task#62 EPCS
        where   isnull(S.RecordDeleted, 'N') = 'N'
		And ISNULL(S.NonStaffUser,'N')='N' 
		 AND ISNULL(a.RecordDeleted, 'N') = 'N'
        order by LastName
              , FirstName      
        if ( @@error != 0 ) 
            begin                                
                raiserror ('Staff Detail: An Error Occured ' ,16,1)                               
                return(1)                                
            end                                
        return(0)                                
    end

GO


