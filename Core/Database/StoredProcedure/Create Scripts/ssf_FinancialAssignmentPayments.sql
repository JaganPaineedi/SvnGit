if object_id('dbo.ssf_FinancialAssignmentPayments') is not null
  drop function dbo.ssf_FinancialAssignmentPayments
go

create function dbo.ssf_FinancialAssignmentPayments (
  @FinancialAssignmentId int,
  @ClientId int,
  @CoveragePlanId int,
  @PayerId int,
  @LocationId int)
returns table
/*********************************************************************              
-- Function: dbo.ssf_FinancialAssignmentPayments    
--
-- Copyright: Streamline Healthcare Solutions    
--                                                     
-- Purpose: Determines if payment financial assignment matches criteria  
--                                                                                      
-- Modified Date    Modified By  Purpose    
-- 03.10.2017       SFarber      Created.
-- 03.16.2017       SFarber      Removed @AssignmentType argument. 
-- 05.03.2017       SFarber      Redesigned.
****************************************************************************/  
  as
return
  (select -1 as FinancialAssignmentId
   where  isnull(@FinancialAssignmentId, -1) = -1
   union all
   select fa.FinancialAssignmentId
   from   FinancialAssignments fa
   where  fa.FinancialAssignmentId = @FinancialAssignmentId
          and ((fa.AllPaymentPlan = 'Y'
                    or exists ( select  *
                                from    FinancialAssignmentPlans fapl
                                where   fapl.FinancialAssignmentId = fa.FinancialAssignmentId
                                        and fapl.AssignmentType = 8977
                                        and fapl.CoveragePlanId = @CoveragePlanId
                                        and isnull(fapL.RecordDeleted, 'N') = 'N' ))
               and (fa.AllPaymentPayer = 'Y'
                    or exists ( select  *
                                from    FinancialAssignmentPayers fap
								        left join CoveragePlans cp on cp.CoveragePlanId = @CoveragePlanId
                                where   fap.FinancialAssignmentId = fa.FinancialAssignmentId
                                        and fap.AssignmentType = 8977
                                        and fap.PayerId = isnull(@PayerId, cp.PayerId)
                                        and isnull(fap.RecordDeleted, 'N') = 'N' ))
               and (fa.AllPaymentPayerType = 'Y'
                    or exists ( select  *
                                from    FinancialAssignmentPayerTypes fapt
								        left join Payers p on p.PayerId = @PayerId
										left join CoveragePlans cp on cp.CoveragePlanId = @CoveragePlanId
										left join Payers pc on pc.PayerId = cp.PayerId
                                where   fapt.FinancialAssignmentId = fa.FinancialAssignmentId
                                        and fapt.AssignmentType = 8977
                                        and fapt.PayerTypeId = isnull(p.PayerType, pc.PayerType)
                                        and isnull(fapt.RecordDeleted, 'N') = 'N' ))
               and (fa.AllPaymentLocation = 'Y'
                    or exists ( select  *
                                from    FinancialAssignmentLocations fal
                                where   fal.FinancialAssignmentId = fa.FinancialAssignmentId
                                        and fal.AssignmentType = 8977
                                        and fal.LocationId = @LocationId
                                        and isnull(FAL.RecordDeleted, 'N') = 'N' ))
               and (fa.AllPaymentProgram = 'Y'
                    or exists ( select  *
                                from    FinancialAssignmentPrograms fap
                                        join ClientPrograms cp on cp.ClientId = @ClientId and cp.ProgramId = fap.ProgramId
                                where   fap.FinancialAssignmentId = fa.FinancialAssignmentId
                                        and fap.AssignmentType = 8977
                                        and cp.Status = 4  -- Enrolled
                                        and isnull(cp.RecordDeleted, 'N') = 'N'
                                        and isnull(fap.RecordDeleted, 'N') = 'N' ))
               and (fa.AllPaymentPrimaryClinician = 'Y'
                    or exists ( select  *
                                from    FinancialAssignmentPrimaryClinicians fap
								        join Clients c on c.ClientId = @ClientId 
                                where   fap.FinancialAssignmentId = fa.FinancialAssignmentId
                                        and fap.AssignmentType = 8977
                                        and fap.PrimaryClinicianId = c.PrimaryClinicianId
                                        and isnull(fap.RecordDeleted, 'N') = 'N' ))
               and (fa.AllPaymentServiceArea = 'Y'
                    or exists ( select  *
                                from    FinancialAssignmentServiceAreas fasa
                                        join CoveragePlanServiceAreas cps on fasa.ServiceAreaId = cps.ServiceAreaId
										left join CoveragePlans cp on cp.PayerId = @PayerId and isnull(cp.RecordDeleted, 'N') = 'N'
                                where   fasa.FinancialAssignmentId = fa.FinancialAssignmentId
                                        and fasa.AssignmentType = 8977
										and cps.CoveragePlanId = isnull(@CoveragePlanId, cp.CoveragePlanId)
                                        and isnull(fasa.RecordDeleted, 'N') = 'N'
                                        and isnull(cps.RecordDeleted, 'N') = 'N' ))))

go
