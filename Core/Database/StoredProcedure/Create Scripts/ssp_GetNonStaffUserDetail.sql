/****** Object:  StoredProcedure [dbo].[ssp_GetNonStaffUserDetail]    Script Date: 05/15/2014 15:31:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetNonStaffUserDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetNonStaffUserDetail]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetNonStaffUserDetail]    Script Date: 05/15/2014 15:31:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE  PROCEDURE [dbo].[ssp_GetNonStaffUserDetail]
 @StaffId INT     
AS  
  
/********************************************************************************                                                    
-- Stored Procedure: ssp_GetNonStaffUserDetail  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Procedure to return data for the staff details page.  
--  
-- Author:  Pradeep.A 
-- Date:    13 May 2014  
--  
-- *****History****   
-- 16 Jun 2014		Pradeep A		What : Changed ClientId to TempClientId for releasing PPA.
-- 16 Apr 2015      Veena           What:Added FinancialAssignmentId in staff table.Valley Customization #950           
-- 12 Aug 2015      Malathi Shiva   Added "EnableRxPopUpAcknowledgement" column in staff table Core Bugs: Task# 1861, To display acknowledgement pop up for Prescriber based on this column settings  
-- 09 Aug 2016		Vithobha		Added NADEANumber in Staff table, EPCS #4  
-- 03-10-2016       Pavani          Added MobileSmartKey,AllowMobileAccess,MobileSmartKeyExpiresNextLogin, Mobile Task#2
-- Nov-28-2016 Lakshmi Kanth         Added coloumn 'AllowAccessToAllScannedDocuments' to staff table, Ionia - Support #370 
-- 19 Sep 2016		Anto 			Added IsEPCSEnabled in Staff table, EPCS #3  

*********************************************************************************/  
  
BEGIN  
  
 BEGIN TRY  
                                                
select StaffId,  ModifiedDate from Staff where StaffId = @StaffId                    
 update Staff         
   set   AccessProviderAccess = 'N'        
   where StaffId=@StaffId  and AccessProviderAccess is null         
              
--Added By Rohit Katoch for Emergency Access Permissions               
SELECT S.[StaffId]          
      ,S.[CreatedBy]          
      ,S.[CreatedDate]          
      ,S.[ModifiedBy]          
      ,S.[ModifiedDate]          
      ,S.[RowIdentifier]          
      ,S.[RecordDeleted]          
      ,S.[DeletedBy]          
      ,S.[DeletedDate]          
      ,S.[UserCode]          
      ,S.[LastName]          
      ,S.[FirstName]          
      ,S.[MiddleName]          
      ,S.[Active]          
      ,S.[SSN]          
      ,S.[Sex]          
      ,S.[DOB]          
      ,S.[EmploymentStart]          
      ,S.[EmploymentEnd]          
      ,S.[LicenseNumber]          
      ,S.[TaxonomyCode]          
      ,S.[Degree]          
      ,S.[SigningSuffix]          
      ,S.[CoSignerId]          
      ,S.[CosignRequired]          
      ,S.[Clinician]          
      ,S.[Attending]          
      ,S.[ProgramManager]          
      ,S.[IntakeStaff]          
      ,S.[AppointmentSearch]          
      ,S.[CoSigner]          
      ,S.[AdminStaff]          
      ,S.[Prescriber]          
      ,S.[LastSynchronizedId]          
      ,S.[UserPassword]          
      ,S.[AllowedPrinting]          
      ,S.[Email]          
      ,S.[PhoneNumber]          
      ,S.[OfficePhone1]          
      ,S.[OfficePhone2]          
      ,S.[CellPhone]          
      ,S.[HomePhone]          
      ,S.[PagerNumber]          
      ,S.[FaxNumber]          
      ,S.[Address]          
      ,S.[City]          
      ,S.[State]          
      ,S.[Zip]          
      ,S.[AddressDisplay]          
      ,S.[InLineSpellCheck]          
      ,S.[DisplayPrimaryClients]          
      ,S.[FontName]          
      ,S.[FontSize]          
      ,S.[SynchronizationOnStart]          
      ,S.[SynchronizationOnClose]          
      ,S.[EncryptionSwitch]          
      ,S.[PrimaryRoleId]          
      ,S.[PrimaryProgramId]          
      ,S.[LastVisit]          
      ,S.[PasswordExpires]          
      ,S.[PasswordExpiresNextLogin]          
      ,S.[PasswordExpirationDate]          
      ,S.[SendConnectionInformation]          
      ,S.[PasswordSendMethod]          
      ,S.[PasswordCallPhoneNumber]          
      ,S.[AccessCareManagement]          
      ,S.[AccessSmartCare]          
      ,S.[AccessPracticeManagement]          
      ,S.[Administrator]          
      ,S.[SystemAdministrator]          
      ,S.[CanViewStaffProductivity]          
      ,S.[CanCreateManageStaff]          
      ,S.[Comment]          
      ,S.[ProductivityDashboardUnit]          
      ,S.[ProductivityComment]          
      ,S.[TargetsComment]          
      ,S.[HomePage]          
      ,S.[DefaultReceptionViewId]          
      ,S.[DefaultCalenderViewType]          
      ,S.[DefaultCalendarStaffId]          
      ,S.[DefaultMultiStaffViewId]          
      ,S.[DefaultProgramViewId]          
      ,S.[DefaultCalendarIncrement]          
      ,S.[UsePrimaryProgramForCaseload]          
      ,S.[EHRUser]          
      ,S.[DefaultReceptionStatus]        
      ,S.[NationalProviderId]          
      ,S.[ClientPagePreferences]          
      ,S.[RetainMessagesDays]          
      ,S.[MedicationDaysDefault]          
      ,S.[ViewDocumentsBanner]          
      ,S.[ExternalReferenceId]          
      ,S.[DEANumber]          
	  ,S.[Supervisor]          
      ,S.[DefaultPrescribingLocation]          
      ,S.[DefaultImageServerId]          
      ,S.[LastPrescriptionReviewTime]          
      ,S.[DefaultPrescribingQuantity]          
      ,S.[AllowRemoteAccess]          
      ,S.[CanSignUsingSignaturePad]          
      ,S.[SureScriptsPrescriberId]          
      ,S.[SureScriptsLocationId]          
      ,S.[SureScriptsActiveStartTime]          
      ,S.[SureScriptsActiveEndTime]          
      ,S.[SureScriptsServiceLevel]          
      ,S.[SureScriptsLastUpdateTime]          
      ,S.[AllowEmergencyAccess]          
      ,S.[EmergencyAccessRoleId]        
      ,S.[HomePageScreenId]        
      ,S.[ClientPagePreferenceScreenId]        
      ,S.[AuthenticationType]          
      ,S.[AccessProviderAccess]        
      ,S.[ProjectedTimeOffHours]        
      ,rtrim(ltrim(S.[Initial])) as Initial        
      ,S.[RxAuthorizedProvider]        
      ,S.[DetermineCaseloadBy]        
      ,S.[Color]        
      ,S.[MaritalStatus]      
      ,S.[DisplayAs]     
      ,S.[NonStaffUser]    
      ,S.[TempClientId] 
      ,S.[TempClientContactId] 
      ,S.[FinancialAssignmentId]  
      ,s.[EnableRxPopUpAcknowledgement]  
      -- Aug 9 2016	Vithobha
      ,S.[NADEANumber]
	   -- 03-10-2016       Pavani 
       ,s.MobileSmartKey 
       ,s.AllowMobileAccess
       ,s.MobileSmartKeyExpiresNextLogin
       --End
	  ,s.AllowAccessToAllScannedDocuments
	  ,S.[IsEPCSEnabled]
  FROM Staff S  where S.StaffId=@StaffId        
               
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
       c.LastName,                
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
       isnull(sr.CreatedBy, 'sa') as CreatedBy,                                     
       isnull(sr.CreatedDate, getdate()) as CreatedDate,                
       isnull(sr.ModifiedBy, 'sa') as ModifiedBy,                
       isnull(sr.ModifiedDate, getdate()) as ModifiedDate,                
       case when sr.StaffRoleId is null then 'Y' else sr.RecordDeleted end as RecordDeleted,                       
                
       sr.DeletedDate,                
       sr.DeletedBy,                            
       gc.CodeName as Roles,                
       s.LastName + ', ' + s.FirstName as StaffName                                
  from GlobalCodes gc                                           
       join Staff s on s.StaffId = @StaffId                                      
       left join StaffRoles sr on sr.RoleId = gc.GlobalCodeId and sr.StaffId = @StaffId and isnull(sr.RecordDeleted, 'N') = 'N'                
 where gc.Category = 'STAFFROLE'   
   and gc.ExternalCode1='CLIENTSTAFF'               
   and gc.Active = 'Y'                 
   and isnull(gc.RecordDeleted, 'N') = 'N'                 
 order by gc.CodeName                                        
                                      
-- Logic for Parent Drop down                       
 exec ssp_GetPermissionTemplateParentItems 
 
 DECLARE @ScreenIds   TABLE (ScreenId INT, ScreenName VARCHAR(100))                                                      
  
  insert into @ScreenIds (ScreenId, ScreenName)  
  select distinct s.ScreenId, s.ScreenName  
  from Screens s   
  WHERE isnull(s.RecordDeleted, 'N') = 'N'    
  EXCEPT     
  (select s.ScreenId, s.ScreenName    
    from Screens s    
      join DocumentCodes dc on dc.DocumentCodeId = s.DocumentCodeId    
   where isnull(dc.RecordDeleted, 'N') = 'N'    
     and isnull(s.RecordDeleted, 'N') = 'N'    
     and not exists(select *    
       from ViewStaffPermissions p    
         where p.StaffId = @StaffId    
        and p.PermissionItemId = dc.DocumentCodeId    
        and p.PermissionTemplateType = 5702)    
  union    
  select s.ScreenId, s.ScreenName    
    from Screens s    
      join Banners b on b.ScreenId = s.ScreenId    
   where isnull(b.RecordDeleted, 'N') = 'N'    
     and isnull(s.RecordDeleted, 'N') = 'N'    
     and ((@StaffId = @StaffId and     
     not exists(select *    
        from ViewStaffPermissions p    
       where p.StaffId = @StaffId    
         and p.PermissionItemId = b.BannerId    
         and p.PermissionTemplateType = 5703)) or    
    (@StaffId <> @StaffId and -- Supervisor view    
     not exists(select *    
        from ViewStaffRoleSupervisorPermissions p    
       where p.StaffId = @StaffId    
         and p.PermissionItemId = b.BannerId    
         and p.PermissionTemplateType = 5703))) )   
 
 
 SELECT distinct A.ScreenId, A.ScreenName  
 FROM @ScreenIds A  
 INNER JOIN Banners B ON A.ScreenId = B.ScreenId  
 JOIN ViewStaffPermissions p ON p.StaffId = @StaffId and p.PermissionItemId = b.BannerId and p.PermissionTemplateType = 5703  
 WHERE B.TabId = 2 --Client  
 AND ISNULL(B.RecordDeleted,'N')='N'  
 AND B.Active = 'Y'  
 order by A.ScreenName  
         
 END TRY  
                
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetNonStaffUserDetail')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH   
 RETURN  
END  
  
GO


