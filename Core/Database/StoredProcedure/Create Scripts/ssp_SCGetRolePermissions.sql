/****** Object:  StoredProcedure [dbo].[ssp_SCGetRolePermissions]    Script Date: 11/18/2011 16:25:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRolePermissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetRolePermissions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRolePermissions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                            
CREATE procedure [dbo].[ssp_SCGetRolePermissions]                                      
@StaffId int         
/********************************************************************************                              
-- Stored Procedure: dbo.ssp_SCGetRolePermissions                                
--                              
-- Copyright: Streamline Healthcate Solutions                              
--                              
-- Purpose: gets data for Roles/Permissions screen        
--                              
-- Updates:                                                                                     
-- Date        Author      Purpose          
-- 06.15.2010  Sweety      Created.                    
-- 08.30.2010  SFarber     Modified to use ssp_GetPermissionTemplateParentItems.   
-- 04.20.2012  PSelvan     Added columns AccessProviderAccess and ProjectedTimeOffHours in Staff table   
-- 31.07.2013  PPotnuru    Added new column Color and Marital Status to the Staff Table
-- 12.13.2013  Manju P     Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes  
-- 06.16.2014  Pradeep.A   What : Added NonStaffUser and TempClientId
--21/10/2014   Shruthi.S   Added column All837Senders which was needed for 837 import logic.Ref #124 CM to SC.
-- 04-02-2015		Vaibhav Khare   What added one more field "ScheduleWidgetStaff "for default Schedule widget 
-- 10-03-2015  Bernardin  Added "DXSearchPreference" column in "Staff" table for cCertification 2014 task# 68
-- 16-03-2015       Veena           Added "FinancialAssignmentId" column in staff table Valley Customization #950  
-- 12-Aug-2015      Malathi Shiva   Added "EnableRxPopUpAcknowledgement" column in staff table Core Bugs: Task# 1861, To display acknowledgement pop up for Prescriber based on this column settings  
-- 09-Aug-2016		Vithobha		Added NADEANumber in Staff table, EPCS #4  
-- Oct 3 2016      Pavani           Added MobileSmartKey,AllowMobileAccess, 
                                    MobileSmartKeyExpiresNextLogin in staff table, Mobile Task#2
-- 20-Nov-2016 Lakshmi Kanth              Implemented Scanning Access logic to the loggedIn Staff, Ionia - Support #370            
*********************************************************************************/                              
as                
                                       
select StaffId,  ModifiedDate from Staff where StaffId = @StaffId            
 update Staff 
   set   AccessProviderAccess = ''N''
   where StaffId=@StaffId  and AccessProviderAccess is null 
      
--Added By Rohit Katoch for Emergency Access Permissions       
SELECT [StaffId]  
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
      ,[SureScriptsServiceLevel]  
      ,[SureScriptsLastUpdateTime]  
      ,[AllowEmergencyAccess]  
      ,[EmergencyAccessRoleId]
      ,[HomePageScreenId]
      ,[ClientPagePreferenceScreenId]
      ,[AuthenticationType]  
       ,[AccessProviderAccess]
       ,[ProjectedTimeOffHours]
       ,rtrim(ltrim([Initial])) as Initial
       ,[RxAuthorizedProvider]
       ,[DetermineCaseloadBy]
       ,[Color]
       ,[MaritalStatus]
       ,[DisplayAs]
       ,[NonStaffUser]
       ,[TempClientId]   
       ,[AllInsurers]
       ,[PrimaryInsurerId]
       ,[AllProviders]
       ,[PrimaryProviderId]
       ,[All837Senders]
		,[TempClientContactId]
		,[DirectEmailAddress]
       ,[DirectEmailPassword]
       ,[ScheduleWidgetStaff]  
       ,[DXSearchPreference]
	   ,[FinancialAssignmentId]
	   ,[EnableRxPopUpAcknowledgement]
	   -- Aug 9 2016	Vithobha
	   ,[NADEANumber] 
	   -- Oct 3 2016    Pavani
	   ,IsEPCSEnabled
	   ,MobileSmartKey  
       ,AllowMobileAccess
       ,MobileSmartKeyExpiresNextLogin
      --Nov 20 2016   Lakshmi kanth
	   ,AllowAccessToAllScannedDocuments
  FROM Staff  where StaffId=@StaffId
       
select spe.StaffPermissionExceptionId,        
       spe.StaffId,        
       spe.PermissionTemplateType,        
       spe.PermissionItemId,        
       spe.Allow,        
       spe.StartDate,                      
       spe.EndDate,                                     
       spe.RowIdentifier,        
       spe.CreatedBy,        
       spe.CreatedDate,        
       spe.ModifiedBy,        
       spe.ModifiedDate,        
       spe.RecordDeleted,        
       spe.DeletedDate,        
       spe.DeletedBy,        
       c.ClientId,        
       case when c.LastName IS NULL OR c.FirstName IS NULL  then      
       organizationName else     
       c.LastName end as LastName,        
       c.FirstName                                   
  from StaffPermissionExceptions spe        
       join Clients c on c.ClientId = spe.PermissionItemId                                     
 where spe.StaffId = @StaffId        
   and spe.PermissionTemplateType = 5741         
                                      
select case when sr.StaffRoleId is null then convert(int,0 - Row_Number() Over (order by sr.StaffRoleId desc))                       
            else sr.StaffRoleId        
       end as StaffRoleId,                              
       @StaffId as StaffId,        
       gc.GlobalCodeId as RoleId,                                  
       isnull(sr.RowIdentifier, newid()) as RowIdentifier,                             
       isnull(sr.CreatedBy, ''sa'') as CreatedBy,                             
       isnull(sr.CreatedDate, getdate()) as CreatedDate,        
       isnull(sr.ModifiedBy, ''sa'') as ModifiedBy,        
       isnull(sr.ModifiedDate, getdate()) as ModifiedDate,        
       case when sr.StaffRoleId is null then ''Y'' else sr.RecordDeleted end as RecordDeleted,               
        
       sr.DeletedDate,        
       sr.DeletedBy,                    
       gc.CodeName as Roles,        
       --s.LastName + '', '' + s.FirstName as StaffName                        
       s.DisplayAs as StaffName                         
  from GlobalCodes gc                                   
       join Staff s on s.StaffId = @StaffId                              
       left join StaffRoles sr on sr.RoleId = gc.GlobalCodeId and sr.StaffId = @StaffId and isnull(sr.RecordDeleted, ''N'') = ''N''        
 where gc.Category = ''STAFFROLE''        
   and gc.Active = ''Y''         
   and isnull(gc.RecordDeleted, ''N'') = ''N''         
 order by gc.CodeName                                
                              
-- Logic for Parent Drop down               
exec ssp_GetPermissionTemplateParentItems
' 
END
GO
