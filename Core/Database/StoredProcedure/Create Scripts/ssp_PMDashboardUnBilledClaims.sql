/****** Object:  StoredProcedure [dbo].[ssp_PMDashboardUnBilledClaims]    Script Date: 11/18/2011 16:25:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMDashboardUnBilledClaims]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMDashboardUnBilledClaims]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure dbo.ssp_PMDashboardUnBilledClaims (
  @StaffId int,
  @FinancialAssignmentId int)
as 
begin                                                                
  begin try     
      
/******************************************************************************      
**  File: dbo.ssp_PMDashboardUnBilledClaims.prc      
**  Name: dbo.ssp_PMDashboardUnBilledClaims      
**  Desc: This SP returns the data required by dashboard  for Incomplete Financial Activities    
**      
**  This template can be customized:      
**                    
**  Return values:      
**       
**  Called by:         
**                    
**  Parameters:      
**  Input       Output      
**     ----------       -----------      
**      
**  Auth: Mary Suma     
**  Date:  17/08/2011      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:     Author:     Description:      
**  --------  --------    -------------------------------------------      
 17.08.11		msuma			Created New SP for Dashboard (UnBilledClaims)  
 23.08.11		msuma			Removed the condition for AllStaff  
 29.08.11		msuma			Moved the filer to where clause from Join 
 24.11.11		msuma			Included additonal join as per Charges and Claims to match the amounts
 15.12.11		msuma			Moved the  filer on staffClients as Join
 22.05.12		msuma			Cleanup
 06.10.12		msuma			Handling NULL Amount 
 29.06.12		MSuma			Changed to Local Variable
 17.Apr.2015	Revathi			what:FinancialAssignment filter added 
								why:task #950 Valley - Customization
 06.16.2016     SFarber         Fixed @IncludeClientCharge logic,Bradford - Environment Issues Tracking: #113
*******************************************************************************/        
    declare @local_StaffId int
                
    set @local_StaffId = @StaffId
    --Added by Revathi	17.Apr.2015
    declare @ChargeResponsibleDays varchar(max)  
         
    declare @ClientFirstLastName varchar(25)  
    declare @ClientLastLastName varchar(25)  
    declare @ClientLastNameCount int= 0  
    declare @IncludeClientCharge char(1)
        
    create table #ClientLastNameSearch (
    LastNameSearch varchar(50))        
        
        
    if isnull(@FinancialAssignmentId, -1) <> -1 
      begin     
        select  @ClientFirstLastName = FinancialAssignmentChargeClientLastNameFrom,
                @ClientLastLastName = FinancialAssignmentChargeClientLastNameTo
        from    FinancialAssignments
        where   FinancialAssignmentId = @FinancialAssignmentId
                and isnull(RecordDeleted, 'N') = 'N'       
        insert  into #ClientLastNameSearch
                exec ssp_SCGetPatientSearchValues 
                  @ClientFirstLastName,
                  @ClientLastLastName  
        if exists ( select  1
                    from    #ClientLastNameSearch ) 
          begin  
            set @ClientLastNameCount = 1  
          end  
      end  
    if isnull(@FinancialAssignmentId, -1) <> -1 
      set @ChargeResponsibleDays = (select  ChargeResponsibleDays
                                    from    FinancialAssignments
                                    where   FinancialAssignmentId = @FinancialAssignmentId
                                            and isnull(RecordDeleted, 'N') = 'N')  
     
     
    if isnull(@FinancialAssignmentId, -1) <> -1 
      set @IncludeClientCharge = (select  ChargeIncludeClientCharge
                                  from    FinancialAssignments
                                  where   FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(RecordDeleted, 'N') = 'N')            
--UNBILLED CLAIMS---  
         
    select  '1' as SortOrder,
            gc.GlobalCodeId as PayerTypeId,
            gc.CodeName as PayerType,
            '$' + isnull(convert(varchar, sum(oc.Balance), 1), '0.00') as Amount    --'1' Added by Gayathri for currency  
    from    OpenCharges oc
            join Charges c on c.ChargeId = oc.ChargeId
            join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
                                            and isnull(ccp.RecordDeleted, 'N') = 'N'
            join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                                     and isnull(cp.RecordDeleted, 'N') = 'N'
            join Payers p on p.PayerId = cp.PayerId
                             and isnull(p.RecordDeleted, 'N') = 'N'
            join Services s on s.ServiceId = c.ServiceId
                               and isnull(S.RecordDeleted, 'N') = 'N'
            join Clients c1 on c1.ClientId = s.ClientId
                               and isnull(c1.RecordDeleted, 'N') = 'N' 
      --Added by Revathi	17.Apr.2015
                               and (exists ( select 1
                                             from   #ClientLastNameSearch f
                                             where  c1.LastName collate DATABASE_DEFAULT like F.LastNameSearch collate DATABASE_DEFAULT )
                                    or (isnull(@ClientLastNameCount, 0) = 0
                                        and c1.LastName = c1.LastName))
            join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
                                      and isnull(PC.RecordDeleted, 'N') = 'N' 
		--Moved this to join
            join StaffClients sc on sc.StaffId = @local_StaffId
                                    and sc.ClientId = ccp.ClientId
            left join GlobalCodes gc on gc.GlobalCodeId = p.PayerType
                                        and isnull(gc.RecordDeleted, 'N') = 'N'
    where   c.LastBilledDate is null
            and isnull(cp.Capitated, 'N') = 'N'
            and isnull(c.DoNotBill, 'N') <> 'Y'
	--Added by Revathi	17.Apr.2015
            and (isnull(@FinancialAssignmentId, -1) = -1
                 or ((exists ( select 1
                               from   FinancialAssignments
                               where  FinancialAssignmentId = @FinancialAssignmentId
                                      and isnull(AllChargeProgram, 'N') = 'Y'
                                      and isnull(RecordDeleted, 'N') = 'N' )
                      or exists ( select  1
                                  from    FinancialAssignmentPrograms FAP
                                  where   FAP.FinancialAssignmentId = @FinancialAssignmentId
                                          and FAP.AssignmentType = 8979
                                          and FAP.ProgramId = s.ProgramId
                                          and isnull(FAP.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargePlan, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentPlans FAPL
                                      where   FAPL.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPL.AssignmentType = 8979
                                              and FAPL.CoveragePlanId = cp.CoveragePlanId
                                              and isnull(FAPL.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargePayer, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentPayers FAPP
                                      where   FAPP.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPP.AssignmentType = 8979
                                              and FAPP.PayerId = p.PayerId
                                              and isnull(FAPP.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargePayerType, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentPayerTypes FAPT
                                      where   FAPT.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPT.PayerTypeId = p.PayerType
                                              and FAPT.AssignmentType = 8979
                                              and isnull(FAPT.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeProcedureCode, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentProcedureCodes FAPC
                                      where   FAPC.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPC.AssignmentType = 8979
                                              and FAPC.ProcedureCodeId = pc.ProcedureCodeId
                                              and isnull(FAPC.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeLocation, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentLocations FAL
                                      where   FAL.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAL.AssignmentType = 8979
                                              and FAL.LocationId = s.LocationId
                                              and isnull(FAL.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeServiceArea, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    Programs P
                                      where   isnull(P.RecordDeleted, 'N') = 'N'
                                              and exists ( select 1
                                                           from   FinancialAssignmentServiceAreas FAS
                                                           where  FAS.FinancialAssignmentId = @FinancialAssignmentId
                                                                  and P.ProgramId = S.ProgramId
                                                                  and P.ServiceAreaId = FAS.ServiceAreaId
                                                                  and FAS.AssignmentType = 8979
                                                                  and isnull(FAS.RecordDeleted, 'N') = 'N' ) ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeErrorReason, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    ChargeErrors che
                                      where   che.ChargeId = oc.ChargeId
                                              and exists ( select *
                                                           from   FinancialAssignmentErrorReasons FAE
                                                           where  FAE.ErrorReasonId = che.ErrorType
                                                                  and FAE.AssignmentType = 8979
                                                                  and isnull(FAE.RecordDeleted, 'N') = 'N' )
                                              and isnull(che.RecordDeleted, 'N') = 'N' ))
                     and (isnull(@ChargeResponsibleDays, -1) = -1
                          or (s.DateOfService < case when @ChargeResponsibleDays = 8980 then convert(varchar, dateadd(dd, -90, getdate()), 101)
                                                     when @ChargeResponsibleDays = 8981 then convert(varchar, dateadd(dd, -180, getdate()), 101)
                                                     when @ChargeResponsibleDays = 8982 then convert(varchar, dateadd(dd, -360, getdate()), 101)
                                                end))
                     and (@IncludeClientCharge = 'Y'
                          or (isnull(@IncludeClientCharge, 'N') = 'N'
                              and c.Priority > 0))))
    group by gc.GlobalCodeId,
            gc.CodeName
    union
    select  '3',
            -1,
            'Total',
            '$' + isnull(convert(varchar, sum(oc.Balance), 1), '0.00') as Amount     --'1' Added by Gayathri for currency   
    from    OpenCharges oc
            join Charges c on c.ChargeId = oc.ChargeId     
      --join Services s on s.ServiceId = ch.ServiceId     
            join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
                                            and isnull(ccp.RecordDeleted, 'N') = 'N'
            join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                                     and isnull(cp.RecordDeleted, 'N') = 'N'
            join Payers p on p.PayerId = cp.PayerId
                             and isnull(p.RecordDeleted, 'N') = 'N'
            join Services s on s.ServiceId = c.ServiceId
                               and isnull(S.RecordDeleted, 'N') = 'N'
            join Clients c1 on c1.ClientId = s.ClientId
                               and isnull(c1.RecordDeleted, 'N') = 'N' 
      --Added by Revathi	17.Apr.2015
                               and (exists ( select 1
                                             from   #ClientLastNameSearch f
                                             where  c1.LastName collate DATABASE_DEFAULT like F.LastNameSearch collate DATABASE_DEFAULT )
                                    or (isnull(@ClientLastNameCount, 0) = 0
                                        and c1.LastName = c1.LastName))
            join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
                                      and isnull(PC.RecordDeleted, 'N') = 'N' 
		--Moved this to join
            join StaffClients sc on sc.StaffId = @local_StaffId
                                    and sc.ClientId = ccp.ClientId
    where   c.LastBilledDate is null
            and isnull(cp.Capitated, 'N') = 'N'
            and isnull(c.DoNotBill, 'N') <> 'Y'
	--Added by Revathi	17.Apr.2015
            and (isnull(@FinancialAssignmentId, -1) = -1
                 or ((exists ( select 1
                               from   FinancialAssignments
                               where  FinancialAssignmentId = @FinancialAssignmentId
                                      and isnull(AllChargeProgram, 'N') = 'Y'
                                      and isnull(RecordDeleted, 'N') = 'N' )
                      or exists ( select  1
                                  from    FinancialAssignmentPrograms FAP
                                  where   FAP.FinancialAssignmentId = @FinancialAssignmentId
                                          and FAP.AssignmentType = 8979
                                          and FAP.ProgramId = s.ProgramId
                                          and isnull(FAP.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargePlan, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentPlans FAPL
                                      where   FAPL.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPL.AssignmentType = 8979
                                              and FAPL.CoveragePlanId = cp.CoveragePlanId
                                              and isnull(FAPL.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargePayer, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentPayers FAPP
                                      where   FAPP.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPP.AssignmentType = 8979
                                              and FAPP.PayerId = p.PayerId
                                              and isnull(FAPP.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargePayerType, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentPayerTypes FAPT
                                      where   FAPT.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPT.PayerTypeId = p.PayerType
                                              and FAPT.AssignmentType = 8979
                                              and isnull(FAPT.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeProcedureCode, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentProcedureCodes FAPC
                                      where   FAPC.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAPC.AssignmentType = 8979
                                              and FAPC.ProcedureCodeId = pc.ProcedureCodeId
                                              and isnull(FAPC.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeLocation, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    FinancialAssignmentLocations FAL
                                      where   FAL.FinancialAssignmentId = @FinancialAssignmentId
                                              and FAL.AssignmentType = 8979
                                              and FAL.LocationId = s.LocationId
                                              and isnull(FAL.RecordDeleted, 'N') = 'N' ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeServiceArea, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    Programs P
                                      where   isnull(P.RecordDeleted, 'N') = 'N'
                                              and exists ( select 1
                                                           from   FinancialAssignmentServiceAreas FAS
                                                           where  FAS.FinancialAssignmentId = @FinancialAssignmentId
                                                                  and P.ProgramId = S.ProgramId
                                                                  and P.ServiceAreaId = FAS.ServiceAreaId
                                                                  and FAS.AssignmentType = 8979
                                                                  and isnull(FAS.RecordDeleted, 'N') = 'N' ) ))
                     and (exists ( select 1
                                   from   FinancialAssignments
                                   where  FinancialAssignmentId = @FinancialAssignmentId
                                          and isnull(AllChargeErrorReason, 'N') = 'Y'
                                          and isnull(RecordDeleted, 'N') = 'N' )
                          or exists ( select  1
                                      from    ChargeErrors che
                                      where   che.ChargeId = oc.ChargeId
                                              and exists ( select *
                                                           from   FinancialAssignmentErrorReasons FAE
                                                           where  FAE.ErrorReasonId = che.ErrorType
                                                                  and FAE.AssignmentType = 8979
                                                                  and isnull(FAE.RecordDeleted, 'N') = 'N' )
                                              and isnull(che.RecordDeleted, 'N') = 'N' ))
                     and (isnull(@ChargeResponsibleDays, -1) = -1
                          or (s.DateOfService < case when @ChargeResponsibleDays = 8980 then convert(varchar, dateadd(dd, -90, getdate()), 101)
                                                     when @ChargeResponsibleDays = 8981 then convert(varchar, dateadd(dd, -180, getdate()), 101)
                                                     when @ChargeResponsibleDays = 8982 then convert(varchar, dateadd(dd, -360, getdate()), 101)
                                                end))
                     and (@IncludeClientCharge = 'Y'
                          or (isnull(@IncludeClientCharge, 'N') = 'N'
                              and c.Priority > 0))))
    order by 1,
            3      
   
  
  end try  
   
  begin catch  
    declare @Error varchar(8000)         
    set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PMDashboardUnBilledClaims') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())  
    raiserror  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
  end catch  
end  

go
