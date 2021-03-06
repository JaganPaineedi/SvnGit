if object_id('dbo.ssf_FinancialAssignmentCharges') is not null
  drop function dbo.ssf_FinancialAssignmentCharges
go

create function dbo.ssf_FinancialAssignmentCharges (@FinancialAssignmentId int,
                                                    @ClientId int,
                                                    @ProgramId int,
                                                    @CoveragePlanId int,
                                                    @PayerId int,
                                                    @PayerType int,
                                                    @ProcedureCodeId int,
                                                    @LocationId int,
                                                    @ChargeId int)
returns table
/*********************************************************************              
-- Function: dbo.ssf_FinancialAssignmentCharges    
--
-- Copyright: Streamline Healthcare Solutions    
--                                                     
-- Purpose: Determines if charge financial assignment matches criteria  
--                                                                                      
-- Modified Date    Modified By  Purpose    
-- 03.10.2017       SFarber      Created.
-- 03.16.2017       SFarber      Removed @AssignmentType argument. 
-- 05.05.2017       SFarber      Redesigned.
****************************************************************************/
  as
return
  (select -1 as FinancialAssignmentId
   where  isnull(@FinancialAssignmentId, -1) = -1
   union all
   select fa.FinancialAssignmentId
   from   FinancialAssignments fa
   where  fa.FinancialAssignmentId = @FinancialAssignmentId
          and (fa.AllChargeProgram = 'Y'
               or exists ( select *
                           from   FinancialAssignmentPrograms fap
                           where  fap.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fap.AssignmentType = 8979
                                  and fap.ProgramId = @ProgramId
                                  and isnull(fap.RecordDeleted, 'N') = 'N' ))
          and (fa.AllChargePlan = 'Y'
               or exists ( select *
                           from   FinancialAssignmentPlans fapl
                           where  fapl.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fapl.AssignmentType = 8979
                                  and fapl.CoveragePlanId = @CoveragePlanId
                                  and isnull(fapl.RecordDeleted, 'N') = 'N' ))
          and (fa.AllChargePayer = 'Y'
               or exists ( select *
                           from   FinancialAssignmentPayers fap
                           where  fap.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fap.AssignmentType = 8979
                                  and fap.PayerId = @PayerId
                                  and isnull(fap.RecordDeleted, 'N') = 'N' ))
          and (fa.AllChargePayerType = 'Y'
               or exists ( select *
                           from   FinancialAssignmentPayerTypes fapt
                           where  fapt.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fapt.AssignmentType = 8979
                                  and fapt.PayerTypeId = @PayerType
                                  and isnull(fapt.RecordDeleted, 'N') = 'N' ))
          and (fa.AllChargeProcedureCode = 'Y'
               or exists ( select *
                           from   FinancialAssignmentProcedureCodes fapc
                           where  fapc.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fapc.AssignmentType = 8979
                                  and fapc.ProcedureCodeId = @ProcedureCodeId
                                  and isnull(fapc.RecordDeleted, 'N') = 'N' ))
          and (fa.AllChargeLocation = 'Y'
               or exists ( select *
                           from   FinancialAssignmentLocations fal
                           where  fal.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fal.AssignmentType = 8979
                                  and fal.LocationId = @LocationId
                                  and isnull(fal.RecordDeleted, 'N') = 'N' ))
          and (fa.AllChargeServiceArea = 'Y'
               or exists ( select *
                           from   FinancialAssignmentServiceAreas fas
                                  join Programs p on p.ProgramId = @ProgramId
                                                     and p.ServiceAreaId = fas.ServiceAreaId
                           where  fas.FinancialAssignmentId = fa.FinancialAssignmentId
                                  and fas.AssignmentType = 8979
                                  and isnull(fas.RecordDeleted, 'N') = 'N' ))
          and (fa.AllChargeErrorReason = 'Y'
               or exists ( select *
                           from   ChargeErrors ce
                                  join FinancialAssignmentErrorReasons faer on faer.FinancialAssignmentId = fa.FinancialAssignmentId
                                                                               and faer.ErrorReasonId = ce.ErrorType
                           where  ce.ChargeId = @ChargeId
                                  and faer.AssignmentType = 8979
                                  and isnull(faer.RecordDeleted, 'N') = 'N'
                                  and isnull(ce.RecordDeleted, 'N') = 'N' )))