/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffDetailsEHR]    Script Date: 11/18/2011 16:25:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetStaffDetailsEHR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetStaffDetailsEHR] 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetStaffDetailsEHR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
create procedure [dbo].[ssp_SCGetStaffDetailsEHR]      
@LoggedInStaffId int = null
/********************************************************************************      
-- Stored Procedure: dbo.ssp_SCGetStaffDetailsEHR        
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: gets staff details from Staff table      
--      
-- Updates:                                                             
-- Date				Author			Purpose      
-- 10.27.2006		P Gajrani		Created.            
-- 12.04.2007		Vikas Vyas		Modified In ref to task 2082      
-- 05.05.2010		SFarber			Modified to use permission view      
-- 07.06.2010		Pradeep			Addedd RecordDeleted,ViewDocumentsBanner,LastPrescriptionReviewTime to made PM compatible with sc Web   
-- 02.11.2011		SFarber			Modified to support ''Staff Access Rules'' permissions
-- 20.Jan.2012		Shifali			Modifed to add column CanSignUsingSignaturePad of Staff
-- March 2, 2010	Pralyankar		Added new field AccessProviderAccess in the result set.
-- 12.Mar.2012		Rakesh-II		Add the new column to the staff select Query #443
-- 15.Mar.2012		Rakesh-II		AccessProviderAccess fields is added which was missing 
-- 10 April 2012	Sudhir Singh	Modified to add column ProjectedTimeOffHours of staff
-- 12 Sep 2012		Mamta Gupta		Added to add new column Initial- Ref Task No. 40 (Primary Care- SummitPointe)
-- 18.Oct.2012		Sanjayb			Merged from 3.xMerge wrt Task#106 in Project 3.x Issues Provider Staff: Records are not displayed on List Page
-- 05-Nov-2012      Jagdeep Hundal  What: Commented col s.Clinician
--                                  Why: Duplicate col in the final result set. Modification done as per task #2210-Registration document - Primary Clinician- 	Thresholds - Bugs/Features (Offshore)
-- 13 Dec 2013  Manju P   Modified to get DisplayAs as StaffName from staff table  
--                        What/Why: Task: Core Bugs #1315 Staff Detail Changes; 
-- 08 May 2014  PPOTNURU  Modified to get DisplayAs as StaffName from staff table  
--                        What/Why: Task: Core Bugs #1513 Staff Detail Changes;      
-- 12 May 2014		Chethan N		What : Added condition in where clause to check for regular staff. And added NonStaffUser,ClientId Column in the Select Statement.  
-- 16 Jun 2014		Pradeep A		What : Changed ClientId to TempClientId for releasing PPA.
-- 04-02-2015		Vaibhav Khare   What added one more field "ScheduleWidgetStaff "for default Schedule widget 
-- 10-03-2015       Bernardin       Added "DXSearchPreference" column in Staff table for Certification 2014 task# 68
-- 16-03-2015       Veena           Added "FinancialAssignmentId" column in staff table Valley Customization #950  
-- 12-Aug-2015      Malathi Shiva   Added "EnableRxPopUpAcknowledgement" column in staff table Core Bugs: Task# 1861, To display acknowledgement pop up for Prescriber based on this column settings  
-- 15-Sep-2015      Vaibhav Khare   Checking DispalyAs is Null and returning Last name and first name  
-- 25-May-2016      Shruthi.S       Pulled logic from SC.Added EHR and Active condition.Ref : #671 Network180-Customizations.
-- 24-Mar-2017      Veena S Mani    Modified StaffId in the last selection as the result set gives as Staffid and in Application it is case sensitive - MHP-Customizations #100 
*********************************************************************************/      
as      
      
declare @StaffLists table (      
StaffId           int,       
Clinician         char(1),      
Attending         char(1),      
ProgramManager    char(1),      
IntakeStaff       char(1),      
AppointmentSearch char(1),      
CoSigner          char(1),      
AdminStaff        char(1),      
Prescriber        char(1))      

declare @StaffFilters table (StaffId int)   
declare @AllStaff char(1)

if @LoggedInStaffId is not null
begin
  if exists(select * from ViewStaffPermissions where StaffId = @LoggedInStaffId and PermissionTemplateType = 5909 and PermissionItemId = 6241)  
  begin
    set @AllStaff = ''Y''
  end
  else if exists(select * from ViewStaffPermissions where StaffId = @LoggedInStaffId and PermissionTemplateType = 5909 and PermissionItemId = 6242) 
  begin
    set @AllStaff = ''N''
    
    -- Only staff who are assigned to the same program(s) as logged in staff
    insert into @StaffFilters (StaffId)
    select s.StaffId
      from Staff s
     where isnull(s.RecordDeleted, ''N'') = ''N''
       and exists(select *
                    from StaffPrograms sp
                         join StaffPrograms sp2 on sp2.ProgramId = sp.ProgramId
                   where sp.StaffId = @LoggedInStaffId 
                     and sp2.StaffId = s.StaffId
                     and isnull(sp.RecordDeleted, ''N'') = ''N''
                     and isnull(sp2.RecordDeleted, ''N'') = ''N'')
                     
                    
  end 
end    

if @AllStaff is null
  set @AllStaff = ''Y''
      
insert into @StaffLists (      
       StaffId,      
       Clinician,      
       Attending,      
       ProgramManager,      
       IntakeStaff,      
       AppointmentSearch,      
       CoSigner,      
       AdminStaff,      
       Prescriber)      
select vsp.StaffId,      
       max(case when PermissionItemId = 5721 then ''Y'' else ''N'' end), -- Clinician      
       max(case when PermissionItemId = 5722 then ''Y'' else ''N'' end), -- Attending      
       max(case when PermissionItemId = 5723 then ''Y'' else ''N'' end), -- Program Manager      
       max(case when PermissionItemId = 5724 then ''Y'' else ''N'' end), -- Intake Staff      
       max(case when PermissionItemId = 5725 then ''Y'' else ''N'' end), -- Appointment Search      
       max(case when PermissionItemId = 5726 then ''Y'' else ''N'' end), -- CoSigner      
       max(case when PermissionItemId = 5727 then ''Y'' else ''N'' end), -- Admin Staff      
       max(case when PermissionItemId = 5728 then ''Y'' else ''N'' end)  -- Prescriber      
  from ViewStaffPermissions vsp      
       left join @StaffFilters sf on sf.StaffId = vsp.StaffId 
 where vsp.PermissionTemplateType = 5704 
   and PermissionItemId IN (5721,5722,5723,5724,5725,5726,5727,5728)
   and ((@AllStaff = ''Y'' and @LoggedInStaffId is null) or sf.StaffId is not null)
 group by vsp.StaffId OPTION(RECOMPILE);     
      --Code modified by Veena on 03/24 for MHP-Customizations #100
      --Modified StaffId as it was giving the result as Staffid and not binding in the signer drop down                              
select s.StaffId,       
       --rtrim(ltrim(s.LastName)) + '', '' + rtrim(s.FirstName) as StaffName,      
	   CASE 
		 WHEN rtrim(ltrim(s.DisplayAs)) IS NULL
			THEN rtrim(ltrim(s.LastName)) + '', '' + rtrim(s.FirstName)
		ELSE rtrim(ltrim(s.DisplayAs))
		END AS StaffName,          
       rtrim(ltrim(s.LastName)) as LastName,      
       rtrim(s.FirstName) as FirstName,                                    
       s.Active,      
       isnull(sl.AdminStaff, ''N'') as AdminStaff,      
       s.SSN,       
       s.Sex,      
       s.Degree,      
       isnull(sl.Prescriber, ''N'') as Prescriber,       
       isnull(sl.Clinician, ''N'') as Clinician,       
       isnull(sl.Attending, ''N'') as Attending,       
       s.UserCode,      
       isnull(sl.ProgramManager, ''N'') as ProgramManager,    
       S.RecordDeleted,        
       s.InLineSpellCheck,                                    
       s.AccessSmartCare,      
       s.SigningSuffix,    
       s.ViewDocumentsBanner,    
       s.LastPrescriptionReviewTime,       
       --rtrim(ltrim(s.LastName)) + '', '' + rtrim(s.FirstName) + '' '' + isnull(gcd.CodeName,'''') as StaffNameWithDegree,      
       rtrim(ltrim(s.DisplayAs)) + '' ''  + isnull(gcd.CodeName,'''') as StaffNameWithDegree,    
       s.EHRUser,      
       isnull(sl.IntakeStaff, ''N'') as IntakeStaff,       
       isnull(sl.AppointmentSearch, ''N'') as AppointmentSearch,    
       s.RowIdentifier,
       s.CanSignUsingSignaturePad,
       AccessProviderAccess,
        -- ********** New lines by Rakesh-II*************
        s.StaffId,
		s.CreatedBy,
		s.CreatedDate,
		s.ModifiedBy,
		s.ModifiedDate,
		--s.RowIdentifier,
		--s.Active,
		s.CosignRequired,
		--s.Clinician,
		s.Attending,
		s.ProgramManager,
		--s.IntakeStaff,
		--s.AppointmentSearch,
		s.CoSigner,
		s.AdminStaff,
		s.Prescriber,
		s.AllowedPrinting,
		--s.InLineSpellCheck,
		s.DisplayPrimaryClients,
		s.EncryptionSwitch,
		s.Administrator,
		s.CanViewStaffProductivity,
		s.CanCreateManageStaff,
      --********* End of my line *************** 
       
       s.ProjectedTimeOffHours, -- added by sudhir singh on date 19 April 2012      
       rtrim(ltrim(s.Initial)) as Initial -- added by Mamta Gupta - Ref Task No. 40 (Primary Care- SummitPointe)
       ,PrimaryProgramId --Add by sanjayb wrt task#106 3x.issues. it causes error that PrimaryProgramId missing in shared table staff        
       ,rtrim(ltrim(ISNULL(s.DisplayAs,rtrim(ltrim(s.LastName)) + '','' + rtrim(s.FirstName)))) as DisplayAs
       ,s.NonStaffUser
       ,s.TempClientId
       ,AllInsurers
       ,PrimaryInsurerId
       ,AllProviders
       ,PrimaryProviderId
	   ,s.[TempClientContactId]
	   ,s.DirectEmailAddress
       ,s.DirectEmailPassword
       ,s.[ScheduleWidgetStaff]  
	   ,s.DXSearchPreference 
	   ,s.FinancialAssignmentId
	   ,s.EnableRxPopUpAcknowledgement
  from Staff s      
       left join @StaffFilters sf on sf.StaffId =s.StaffId 
       left join GlobalCodes gcd on s.Degree = gcd.GlobalCodeId                     
       left join @StaffLists sl on sl.StaffId = s.StaffId      
 where isnull(s.RecordDeleted,''N'')=''N''
   and ((@AllStaff = ''Y'' and @LoggedInStaffId is null) or sf.StaffId is not null)
   and ISNULL(s.NonStaffUser,''N'')=''N''
   and ISNULL(s.EHRUser,''N'')=''Y''
    and ISNULL(s.Active,''N'')=''Y''
 order by StaffName, s.StaffId  
 
' 
END
GO
