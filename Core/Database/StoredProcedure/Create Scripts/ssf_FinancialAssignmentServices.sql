if object_id('dbo.ssf_FinancialAssignmentServices') is not null 
  drop function dbo.ssf_FinancialAssignmentServices
go

create function dbo.ssf_FinancialAssignmentServices (
  @FinancialAssignmentId int,
  @ClientId int,
  @ProgramId int,
  @ProcedureCodeId int,
  @LocationId int,
  @ClinicianId int)
returns table
/*********************************************************************              
-- Function: dbo.ssf_FinancialAssignmentServices    
--
-- Copyright: Streamline Healthcare Solutions    
--                                                     
-- Purpose: Determines if service financial assignment matches criteria  
--                                                                                      
-- Modified Date    Modified By  Purpose    
-- 03.10.2017       SFarber      Created.
-- 03.16.2017       SFarber      Removed @AssignmentType argument. 
-- 05.03.2017       SFarber      Redesigned.
-- 02.Aug.2017      Ajay         Added filter for Financial Assignment Clinicians.
                                 Why: AHN Customization #Task:44
****************************************************************************/      
  as
return
  (select -1 as FinancialAssignmentId
   where  isnull(@FinancialAssignmentId, -1) = -1
   union all
   select fa.FinancialAssignmentId
   from   FinancialAssignments fa
   where  fa.FinancialAssignmentId = @FinancialAssignmentId
          and (fa.AllServiceProgram = 'Y'
                or exists ( select *
                           from   FinancialAssignmentPrograms fap
                           where  fap.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fap.AssignmentType = 8978
                                  and fap.ProgramId = @ProgramId
                                  and isnull(fap.RecordDeleted, 'N') = 'N' ))
          and (fa.AllServiceLocation = 'Y'
               or exists ( select *
                           from   FinancialAssignmentLocations fal
                           where  fal.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fal.AssignmentType = 8978
                                  and fal.LocationId = @LocationId
                                  and isnull(FAL.RecordDeleted, 'N') = 'N' ))
          and (fa.AllServiceServiceArea = 'Y'
               or exists ( select *
                           from   FinancialAssignmentServiceAreas fasa
                                  inner join Programs p on p.ProgramId = @ProgramId
                                                           and p.ServiceAreaId = fasa.ServiceAreaId
                           where  fasa.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fasa.AssignmentType = 8978
                                  and isnull(fasa.RecordDeleted, 'N') = 'N' ))
          and (fa.AllServiceProcedureCode = 'Y'
               or exists ( select *
                           from   FinancialAssignmentProcedureCodes fapc
                           where  fapc.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fapc.AssignmentType = 8978
                                  and fapc.ProcedureCodeId = @ProcedureCodeId
                                  and isnull(fapC.RecordDeleted, 'N') = 'N' ))

          and (fa.AllServicePrimaryClinician = 'Y'
               or exists ( select *
                           from   FinancialAssignmentPrimaryClinicians fap
						          join Clients c on c.ClientId = @ClientId
                          where  fap.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fap.AssignmentType = 8978
                                  and fap.PrimaryClinicianId = c.PrimaryClinicianId
                                  and isnull(fap.RecordDeleted, 'N') = 'N' ))
              
           and (fa.AllServiceClinicians = 'Y'   --Added by Ajay on 02-08-2017
               or exists ( select *
                           from   FinancialAssignmentClinicians fac
                           where  fac.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fac.AssignmentType = 8978
                                  and fac.ClinicianId = @ClinicianId
                                  and isnull(fac.RecordDeleted, 'N') = 'N')))

go
