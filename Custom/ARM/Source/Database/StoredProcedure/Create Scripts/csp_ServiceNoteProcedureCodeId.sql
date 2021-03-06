/****** Object:  StoredProcedure [dbo].[csp_ServiceNoteProcedureCodeId]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteProcedureCodeId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ServiceNoteProcedureCodeId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ServiceNoteProcedureCodeId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- Stored Procedure

CREATE procedure [dbo].[csp_ServiceNoteProcedureCodeId]  
 @ClientId int,          
 @DateOfService datetime,          
 @ProgramId int,          
 @AttendingId int,          
 @ProcedureCodeId int,          
 @LocationId int,          
 @PlaceOfServiceId int,          
 @ClinicianId int          
/********************************************************************************                                                          
-- Stored Procedure: dbo.csp_ServiceNoteProcedureCodeId                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose:                                                           
--                                                          
-- Updates:                                                                                                                 
-- Date        Author            Purpose                                                          
-- 01.21.2013  SFarber           Fixed ''in last 6 months'' calculation logic for Care Plan   
-- 02.17.2013  Maninder Singh    when we create new Service in case  ClinicianID set as -1 parameter that pass into "csp_ServiceNoteProcedureCodeId" Sp (used to fill Procedure DropDown on change of Program DropDown)  ref task #2751 in Thresholds Bugs and 
Features      
-- 03.29.2013  Rakesh Garg       Changes made ref to task 2940  Service  Note, Procedure & 2894 in Thresholds Bugs/Features Change conditon @ProgramId = -1 to @ProgramId <= -0                                                          
*********************************************************************************/                                                           
AS        
BEGIN        

 DECLARE @DocumentVersionId int        
 DECLARE @EpisodeRegistrationDate datetime    
 DECLARE @HasCarePlan char(1)      

 SET @HasCarePlan = ''N''    

 declare @ProcedureCodes1 table (ProcedureCodeId int not null, ProcedureCodeName varchar(20))    

 IF @DateOfService IS NULL        
  SET @DateOfService = GETDATE()        

 -- Get open date of current episode        
 SELECT @EpisodeRegistrationDate = ce.RegistrationDate        
 FROM ClientEpisodes ce        
 WHERE ce.ClientId = @ClientId AND        
    ce.DischargeDate IS NULL AND        
    ISNULL(ce.RecordDeleted,''N'') = ''N''        

 -- Check if there was an initial/annual Care Plan in last 6 months  
 IF EXISTS ( SELECT 1  
             FROM Documents d  
             LEFT JOIN CustomDocumentCarePlans cp ON cp.DocumentVersionId = d.CurrentDocumentVersionId  
             WHERE d.ClientId = @ClientId AND  
                   d.DocumentCodeId IN (1501,10514) AND  
                   d.Status = 22 AND  
                   CAST(d.EffectiveDate as Date) >= @EpisodeRegistrationDate AND      
       CAST(d.EffectiveDate as Date) <= GETDATE() AND  
       cast(dateadd(month, 6, d.EffectiveDate) as date) >= cast(getdate() as date) AND  
                   ISNULL(cp.CarePlanType,''IN'') IN (''IN'',''AN'') AND  
                   ISNULL(d.RecordDeleted,''N'') = ''N'' AND  
                   ISNULL(cp.RecordDeleted,''N'') = ''N'' )  
BEGIN  
 SET @HasCarePlan = ''Y''  
END              

 -- Get DocumentVersionId of current Care Plan      
IF @HasCarePlan = ''Y''  
BEGIN  
 SELECT top 1 @DocumentVersionId = d.CurrentDocumentVersionId        
 FROM Documents d        
 WHERE d.DocumentCodeId in (1501,10514) AND          -- Care Plan or Converted Care Plan  
    d.ClientId = @ClientId AND        
    d.Status = 22 AND               -- Signed  
    cast (d.EffectiveDate as Date) >= @EpisodeRegistrationDate AND   -- Current Episode  
    cast (d.EffectiveDate as Date) <= @DateOfService AND      -- Before date of service  
    cast(dateadd(month, 6, d.EffectiveDate) as date) >= cast(getdate() as date) AND -- In last 6 months  
    ISNULL(d.RecordDeleted,''N'') = ''N''  
 ORDER BY d.EffectiveDate desc    
END               

 -- If no Care Plan exists and date of service is less than 45 days from episode open date, get most recent MHA        
 IF @DocumentVersionId IS NULL AND DATEDIFF(D,@EpisodeRegistrationDate,@DateOfService) < 45        
 BEGIN        
  SELECT TOP 1 @DocumentVersionId = d.CurrentDocumentVersionId        
  FROM Documents d        
  WHERE d.DocumentCodeId in (10001,10513) AND        
     d.ClientId = @ClientId AND        
     DATEDIFF(D,@EpisodeRegistrationDate,d.EffectiveDate) < 45 AND        
     d.Status = 22    AND    
     ISNULL(d.RecordDeleted,''N'') = ''N''     
  ORDER BY d.EffectiveDate DESC        
 END        

-- Get list of Procedure Codes that have been Prescribed or do not require prescription    
insert into @ProcedureCodes1    
(ProcedureCodeId, ProcedureCodeName)    
select pc.ProcedureCodeId, pc.DisplayAs    
from CustomDocumentCarePlanPrescribedServices ps    
JOIN AuthorizationCodeProcedureCodes acpc ON (ps.AuthorizationCodeId = acpc.AuthorizationCodeId)    
JOIN CustomProcedureCodes cpc ON (cpc.ProcedureCodeId = acpc.ProcedureCodeId)    
JOIN ProcedureCodes pc ON (cpc.ProcedureCodeId = pc.ProcedureCodeId)    
where ps.DocumentVersionId = @DocumentVersionId    
and cpc.RequiresPrescription = ''Y''    
and ISNULL(ps.RecordDeleted,''N'') = ''N''     
and ISNULL(acpc.RecordDeleted,''N'') = ''N''     
union    
select pc.ProcedureCodeId, pc.DisplayAs    
from ProcedureCodes pc     
JOIN CustomProcedureCodes cpc ON (cpc.ProcedureCodeId = pc.ProcedureCodeId)    
where ISNULL(pc.RecordDeleted,''N'') = ''N''     
and ISNULL(cpc.RequiresPrescription,''N'') = ''N''     

-- Only Show treatment plan procedure code if there is an Intake Date (ClientEpisodes.AssessmentDate)  
-- and date of service >= Intake Date  
 -- Get AssessmentDate date of current episode      
 declare @IntakeDate datetime  

 SELECT @IntakeDate = ce.AssessmentDate        
 FROM ClientEpisodes ce        
 WHERE ce.ClientId = @ClientId AND        
    ce.DischargeDate IS NULL AND        
    ISNULL(ce.RecordDeleted,''N'') = ''N''   

 if @IntakeDate is null or @IntakeDate > @DateOfService  
 begin  
 -- Remove Treatment Plan Procedure Code  
 delete from @ProcedureCodes1  
 where ProcedureCodeId = 50  
 end  

-- Filter procedure codes by     
-- (1) Clinician License/Degree on date of service    
-- (2) Associated with program    

select distinct p.ProcedureCodeId, p.ProcedureCodeName    
from @ProcedureCodes1 p    
JOIN ProgramProcedures pp ON (p.ProcedureCodeId = pp.ProcedureCodeId)    
where ISNULL(pp.RecordDeleted,''N'') = ''N'' and    
      (pp.ProgramId = @ProgramId OR    
       --@ProgramId = -1)    
        @ProgramId <= 0)  -- Changes made as it shows different behaviour when passing ProgramId -1 or 0  
and exists    
(select * from ProcedureCodeStaffCredentials pcsc    
JOIN StaffLicenseDegrees sld ON (pcsc.DegreeLicenseType = sld.LicenseTypeDegree)    
where (sld.StaffId = @ClinicianId OR  @ClinicianId <= 0)     
and pcsc.ProcedureCodeId = p.ProcedureCodeId    
and sld.StartDate <= @DateOfService    
and (sld.EndDate is null or sld.EndDate >= CAST(@DateOfService as Date))    
and ISNULL(sld.RecordDeleted,''N'') = ''N''     
and ISNULL(pcsc.RecordDeleted,''N'') = ''N'')    
order by p.ProcedureCodeName    


 -- Select procedure codes that meet the following criteria:        
 --     (1) Staff on the service can provide the procedure        
 --     (2) It is a valid procedure for the team selected        
 --     (3) Procedure has been prescribed in Care Plan or MHA        
 --     (4) If the procedure code is part of "Prescription Not Needed" then only conditions (1) and (2) must be met      

 /*    
 SELECT DISTINCT pc.ProcedureCodeId, pc.ProcedureCodeName        
 FROM ProcedureCodes pc        
 LEFT JOIN ProgramProcedures pcp ON pcp.ProcedureCodeId = pc.ProcedureCodeId AND ISNULL(pcp.RecordDeleted,''N'') = ''N''        
 LEFT JOIN ProcedureCodeStaffCredentials sc ON sc.ProcedureCodeId = pc.ProcedureCodeId AND ISNULL(sc.RecordDeleted,''N'') = ''N''        
 LEFT JOIN Staff s ON s.StaffId = @ClinicianId AND ISNULL(s.RecordDeleted,''N'') = ''N''        
 LEFT JOIN CustomProcedureCodes cpc ON cpc.ProcedureCodeId = pc.ProcedureCodeId AND ISNULL(cpc.RecordDeleted,''N'') = ''N''        
 WHERE ( pcp.ProgramId = @ProgramId /* OR        
         @ProgramId = -1 OR        
         @ProgramId = 329 */) AND        
    s.Degree = sc.DegreeLicenseType AND        
    ( pc.ProcedureCodeId IN ( SELECT pc.ProcedureCodeId        
            FROM CustomDocumentCarePlanPrescribedServices ps         
            LEFT JOIN AuthorizationCodeProcedureCodes acpc ON acpc.AuthorizationCodeId = ps.AuthorizationCodeId AND ISNULL(acpc.RecordDeleted,''N'') = ''N''        
            LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = acpc.ProcedureCodeId AND ISNULL(pc.RecordDeleted,''N'') = ''N''        
            WHERE ps.DocumentVersionId = @DocumentVersionId ) OR        
      ( cpc.RequiresPrescription = ''N'' OR cpc.RequiresPrescription IS NULL ) )        
      */    

END   

' 
END
GO
