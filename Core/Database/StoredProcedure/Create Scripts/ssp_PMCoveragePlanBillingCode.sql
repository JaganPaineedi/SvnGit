IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanBillingCode]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMCoveragePlanBillingCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure dbo.ssp_PMCoveragePlanBillingCode
  @SessionId varchar(30),
  @InstanceId int,
  @PageNumber int,
  @PageSize int,
  @SortExpression varchar(100),
  @ActiveProcedure int,
  @Degrees int,
  @Programs int,
  @Staff int,
  @Client int,
  @CodeRates int,
  @CoveragePlanId int,
  @BillingCode int,
  @EffectiveFlag char(1),
  @BillingCodeType char(1),
  @SpecCoveragePlanId int,
  @OtherFilter int,
  @ServiceArea int,
  @ProcedureCodeId int,
  @ShowBillableProcedureCodesOnly int
/****************************************************************************** 
** File: ssp_PMCoveragePlanBillingCode.sql
** Name: ssp_PMCoveragePlanBillingCode
** desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - BillingCodes Tab
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** N/A   Dropdown values
** Auth: Mary Suma
** Date: 12/05/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			description: 
** 12/05/2011		MSuma				Query to Procedures for the Billing Codes
-------- 			-------- 			--------------- 
** 24/08/2011		MSuma				Included Additional columns from ProcedureRates
										to handle  to Add BillingCodes Modification
** 12/09/2011		MSuma				Included ForcePlan for Tuning
** 16/09/2011		MSuma				Included Fix for @CodeRates
** 20/09/2011		MSuma				Fixed Duplicate Issues and Paging
** 21/09/2011		MSuma				Fixed Duplicate Issues by including DISTINCT
** 28/09/2011		MSuma				Renamed the temp Table with prefix ListPage and Included DisplayAs
** 29/09/2011		MSuma			    Included ProcedureCodeName to handle Add Billing Code
** 30/09/2011		MSuma			    Included BillingCodeAs to handle Add Billing Code(If Advanced=='Y' then BillingCodeAs='Varies' ELSE BillingCode)
** 04/09/2011		MSuma			    DataModel Change for ChargeType
** 02/28/2012		MSuma			    Included Javed's Changes for Tuning
** 29/02/2012		Deej				New implementation to selected the records
** 11/04/2012		MSuma				Included Javed's Changes for Tuning
** 12/04/2012		MSuma				Removed Temp table
** 15/05/2012		PSelvan				For the ace task PMWeb New #1521
** 18/05/2012		MSUma				Included RecordDeleted Check in ProcedureRAtes
** 16/06/2012		MSUma				Included Condition for AppliesToAllProcedureCodes
** 18-Feb-2014      SuryaBalan          wrf Task #1392 Corebugs Program,Degree, Staff, ServiceArea filters are not working, So I added Condition for that
                                        and while verifying checklist I fixed someother bugs like Record Deleted Sorting
** 04-Apr-2014    John Sudhakar M		Added new parameters @ProcedureCodeId and @ShowBillableProcedureCodesOnly(Engineering Improvement Initiatives #1430)
** 05/26/2015       SFarber             Modified to improve performance.
** 11/26/2015		Seema				Added Effective date condition in where Clause Why:Filter was not working(Core Bugs #1965)
** 11/02/2017       Vandana				Corrected column spelling 'RevenueCodeDescription' as a fix for task #84 Renaissance - Environment Issues Tracking

*******************************************************************************/
as 
begin

  begin try

    create table #CustomFilters (ProcedureRateId int not null) 

    declare @CustomFiltersApplied char(1)
    declare @BillingRulesCoveragePlanId int             

    if @ShowBillableProcedureCodesOnly = 1
    begin
      select @BillingRulesCoveragePlanId = UseBillingRulesTemplateId
        from CoveragePlans
       where CoveragePlanId = @CoveragePlanId
         and BillingRulesTemplate = 'O'

      if @BillingRulesCoveragePlanId is null
	    set @BillingRulesCoveragePlanId = @CoveragePlanId
	end
		
    set @SortExpression = rtrim(ltrim(@SortExpression))
    
    if isnull(@SortExpression, '') = '' 
      set @SortExpression = 'ClientName'
		
    set @CustomFiltersApplied = 'N'                                                 
		
    if @OtherFilter > 10000 
      begin
        set @CustomFiltersApplied = 'Y'
			
        insert  into #CustomFilters (ProcedureRateId)
                exec scsp_PMCoveragePlanBillingCode 
                  @ActiveProcedure = @ActiveProcedure,
                  @Degrees = @Degrees,
                  @Programs = @Programs,
                  @Staff = @Staff,
                  @Client = @Client,
                  @CodeRates = @CodeRates,
                  @EffectiveFlag = @EffectiveFlag,
                  @CoveragePlanId = @CoveragePlanId,
                  @BillingCode = @BillingCode,
                  @OtherFilter = @OtherFilter,
                  @ServiceArea = @ServiceArea
      end	
		
    declare @EffectiveDate datetime
			 
    if @EffectiveFlag = 'N' 
      set @EffectiveDate = null	
    else 
      set @EffectiveDate = getdate()


	;
    with  PlanBilingCode
            as (select  pc.ProcedureCodeId,
                        pr.ProcedureRateId,
                        pc.DisplayAs as ProcedureCode,
                        Priority,
                        '$' + convert(varchar, PR.Amount, 1) + ' '
                        + case pr.Chargetype
                            when 6761 -- 'P' 
                                 then 'Per ' + cast(pr.FromUnit as varchar(20))  --Per        
                            when 6763 --'R' 
                                 then cast(pr.FromUnit as varchar(20)) + ' to ' + cast(pr.ToUnit as varchar(20)) --Range        
                            when 6762 --'E'  
                                 then 'for ' + cast(cast(pr.FromUnit as integer) as varchar(20))
                            else ct.CodeName
                          end + ' ' + gc.CodeName as Charge, --Unit
                        pr.BillingCode,
                        pr.ProgramGroupName,
                        pr.LocationGroupName,
                        pr.DegreeGroupName,
                        pr.StaffGroupName,
                        pr.ServiceAreaGroupName,
                        pr.PlaceOfServiceGroupName,
                        cl.LastName + ', ' + cl.FirstName as ClientName,
                        pr.RevenueCode,
                        cast(convert(varchar(10), pr.FromDate, 101) as datetime) as FromDate,
                        cast(convert(varchar(10), pr.ToDate, 101) as datetime) as ToDate,
                        pc.NotBillable,
                        pr.BillingCodeUnitType,
                        pr.RecordDeleted,
                        pr.ClientWasPresent,
                        pr.BillingCodeClaimUnits,
                        pr.RevenueCodeDescription,   --Corrected Spelling for #84 Renaissance - Environment Issues Tracking by Vandana

                        convert(varchar(max), pr.Comment) as Comment,
                        pr.CoveragePlanId,
                        pr.CreatedBy,
                        pr.CreatedDate,
                        pr.ModifiedBy,
                        pr.ModifiedDate,
                        pr.DeletedDate,
                        pr.DeletedBy,
                        pr.Amount,
                        pr.ChargeType,
                        pr.FromUnit,
                        pr.ToUnit,
                        pr.ClientId,
                        pr.BillingCodeUnits,
                        pr.Modifier1,
                        pr.Modifier2,
                        pr.Modifier3,
                        pr.Modifier4,
                        pr.Advanced,
                        pr.StandardRateId,
                        pr.BillingCodeModified,
                        pr.NationalDrugCode,
                        pr.ModifierId1,
                        pr.ModifierId2,
                        pr.ModifierId3,
                        pr.ModifierId4,
                        pr.AddModifiersFromService,
                        pc.DisplayAs,
                        pc.ProcedureCodeName,
                        case pr.Advanced
                          when 'Y' then 'Varies' 
					      --1/9/2013		JHB		Added Modifiers to show in BillingCodeAs field       
                          else pr.BillingCode + isnull('-' + nullif(pr.Modifier1, ''), '') + 
                                                isnull('-' + nullif(pr.Modifier2, ''), '') + 
                                                isnull('-' + nullif(pr.Modifier3, ''), '') + 
                                                isnull('-' + nullif(pr.Modifier4, ''), '')
                        end as BillingCodeAs, 
                        pr.ModifierGroupName
                from    ProcedureRates pr
                        join ProcedureCodes pc on pc.ProcedureCodeId = pr.ProcedureCodeId and isnull(pc.RecordDeleted, 'N') = 'N'
                        left join Clients cl on pr.ClientID = cl.ClientID
                        left join GlobalCodes gc on gc.GlobalCodeId = pc.EnteredAs
                        left join GlobalCodes ct on ct.GlobalCodeId = pr.ChargeType 
                where  isnull(pr.RecordDeleted, 'N') = 'N' and 
                       ((@CustomFiltersApplied = 'Y'
                         and exists ( select  *
                                      from    #CustomFilters cf
                                      where   cf.ProcedureRateId = pr.ProcedureRateId))
                        or (@CustomFiltersApplied = 'N'
                            and (@ActiveProcedure = -1 -- All Status 
                                 or	(@ActiveProcedure = 1 and pc.Active = 'Y') -- Active 
                                 or (@ActiveProcedure = 2 and isnull(pc.Active, 'N') = 'N')) -- Inactive    
                            and (@BillingCode = -1 -- Standard and Unique
                                 or	(@BillingCode = 1 and pr.BillingCodeModified = 'Y') -- Standard 
                                 or	(@BillingCode = 2 and isnull(pr.BillingCodeModified, 'N') = 'N')) -- Unique 
                            and (@Programs = -1
                                 or (isnull(pr.ProgramGroupName, '') <> ''
                                     and exists ( select  *
                                                  from    ProcedureRatePrograms prp
                                                  where   prp.ProcedureRateId = pr.ProcedureRateId
                                                          and prp.ProgramId = @Programs
                                                          and isnull(prp.RecordDeleted, 'N') = 'N' )))
                            and (@Degrees = -1
                                 or (isnull(pr.DegreeGroupName, '') <> ''
                                     and exists ( select  *
                                                  from    ProcedureRateDegrees prd
                                                  where   prd.ProcedureRateId = pr.ProcedureRateId
                                                          and prd.Degree = @Degrees
                                                          and isnull(prd.RecordDeleted, 'N') = 'N' )))
                            and (@Staff = -1
                                 or (isnull(pr.StaffGroupName, '') <> ''
                                     and exists ( select  *
                                                  from    ProcedureRateStaff prs
                                                  where   prs.ProcedureRateId = pr.ProcedureRateId
                                                          and prs.StaffId = @Staff
                                                          and isnull(prs.RecordDeleted, 'N') = 'N' )))
                            and (@ServiceArea = -1
                                 or (isnull(pr.ServiceAreaGroupName, '') <> ''
                                     and exists ( select  *
                                                  from    ProcedureRateServiceAreas prsa
                                                  where   prsa.ProcedureRateId = pr.ProcedureRateId
                                                          and prsa.ServiceAreaId = @ServiceArea
                                                          and isnull(prsa.RecordDeleted, 'N') = 'N' )))
                            and (@Client = -1 or pr.ClientId = @Client)
                            and ((@CodeRates = -1)
                                 or (@CodeRates = 3 and isnull(pr.ProgramGroupName, '') <> '')
                                 or (@CodeRates = 2 and isnull(pr.LocationGroupName, '') <> '')
                                 or (@CodeRates = 1 and isnull(pr.DegreeGroupName, '') <> '')
                                 or (@CodeRates = 4 and isnull(pr.StaffGroupName, '') <> '')
                                 or (@CodeRates = 5 and pr.ClientId is not null)
                                 or (@CodeRates = 6
                                     and isnull(pr.ProgramGroupName, '') <> ''
                                     and isnull(pr.LocationGroupName, '') <> ''
                                     and isnull(pr.DegreeGroupName, '') <> ''
                                     and isnull(pr.StaffGroupName, '') <> ''
                                     and pr.ClientId is null))
                            and (@ShowBillableProcedureCodesOnly = 0 or
                                 (@ShowBillableProcedureCodesOnly = 1 and
                                  not exists ( select *
                                               from   CoveragePlanRules cpr
                                               where  cpr.RuleTypeId = 4267
                                                      and cpr.CoveragePlanId = @BillingRulesCoveragePlanId
                                                      and isnull(cpr.RecordDeleted, 'N') = 'N'
                                                      and (cpr.AppliesToAllProcedureCodes = 'Y'
                                                           or exists ( select *
                                                                       from   CoveragePlanRuleVariables cprv
                                                                       where  cpr.CoveragePlanRuleId = cprv.CoveragePlanRuleId
                                                                              and cprv.ProcedureCodeId = pc.ProcedureCodeId
                                                                              and isnull(cprv.RecordDeleted, 'N') = 'N' )))
                                 ))
                            and isnull(pr.CoveragePlanId, 0) = case when @BillingCodeType = 'S' then 0
                                                                    when @BillingCodeType = 'T' then @CoveragePlanId
                                                                    when @BillingCodeType = 'O' then @SpecCoveragePlanId
                                                                    else 0
                                                               end
                             and (@ProcedureCodeId = -1 or pc.ProcedureCodeId = @ProcedureCodeId) 
                             --Seema 11/26/2015
                             and (@EffectiveDate is null or  @EffectiveDate between  pr.FromDate  and  ISNULL(pr.ToDate,GETDATE()))))),  
          counts
            as (select  count(*) as totalrows
                from    PlanBilingCode),
          RankResultSet
            as (select  ProcedureCodeId,
                        ProcedureRateId,
                        ProcedureCode,
                        Priority,
                        Charge,
                        BillingCode,
                        ProgramGroupName,
                        LocationGroupName,
                        DegreeGroupName,
                        StaffGroupName,
                        ServiceAreaGroupName,
                        PlaceOfServiceGroupName,
                        ClientName,
                        RevenueCode,
                        FromDate,
                        ToDate,
                        RecordDeleted,
                        ClientWasPresent,
                        BillingCodeClaimUnits,
                        BillingCodeUnitType,
                        RevenueCodeDescription,
                        Comment,
                        CoveragePlanId,
                        CreatedBy,
                        CreatedDate,
                        ModifiedBy,
                        ModifiedDate,
                        DeletedDate,
                        DeletedBy,
                        Amount,
                        ChargeType,
                        FromUnit,
                        ToUnit,
                        ClientId,
                        BillingCodeUnits,
                        Modifier1,
                        Modifier2,
                        Modifier3,
                        Modifier4,
                        Advanced,
                        StandardRateId,
                        BillingCodeModified,
                        NationalDrugCode,
                        ModifierId1,
                        ModifierId2,
                        ModifierId3,
                        ModifierId4,
                        AddModifiersFromService,
                        DisplayAs,
                        ProcedureCodeName,
                        BillingCodeAs,
                        count(*) over () as TotalCount,
                        rank() over (order by 
										case when @SortExpression= 'ProcedureCodeId'			then ProcedureCodeId end,                                  
										case when @SortExpression= 'ProcedureCodeId desc'		then ProcedureCodeId end desc, 
										case when @SortExpression= 'ProcedureCode'				then ProcedureCode end,                                  
										case when @SortExpression= 'ProcedureCode desc'			then ProcedureCode end desc,                       
										case when @SortExpression= 'Priority'					then Priority end,                                            
										case when @SortExpression= 'Priority desc'				then Priority end desc,
										case when @SortExpression= 'Charge'						then Charge end,                                  
										case when @SortExpression= 'Charge desc'				then Charge end desc, 
										case when @SortExpression= 'BillingCode'				then BillingCode end,                                  
										case when @SortExpression= 'BillingCode desc'			then BillingCode end desc, 
										case when @SortExpression= 'ProgramGroupName'			then ProgramGroupName end,                                  
										case when @SortExpression= 'ProgramGroupName desc'		then ProgramGroupName end desc,
										case when @SortExpression= 'LocationGroupName'			then LocationGroupName end,                                  
										case when @SortExpression= 'LocationGroupName desc'		then LocationGroupName end desc, 
										case when @SortExpression= 'DegreeGroupName'			then DegreeGroupName end,                                  
										case when @SortExpression= 'DegreeGroupName desc'		then DegreeGroupName end desc,
										case when @SortExpression= 'StaffGroupName'				then StaffGroupName end,                                  
										case when @SortExpression= 'StaffGroupName desc'		then StaffGroupName end desc,
										case when @SortExpression= 'ServiceAreaGroupName'		then ServiceAreaGroupName end,                                  
										case when @SortExpression= 'ServiceAreaGroupName desc'	then ServiceAreaGroupName end desc, 
										case when @SortExpression= 'PlaceOfServiceGroupName'	then PlaceOfServiceGroupName end,
										case when @SortExpression= 'PlaceOfServiceGroupName desc' then PlaceOfServiceGroupName end desc,
										case when @SortExpression= 'ClientName'					then ClientName end,                                  
										case when @SortExpression= 'ClientName desc'			then ClientName end desc,
										case when @SortExpression= 'RevenueCode'				then RevenueCode end,                                  
										case when @SortExpression= 'RevenueCode desc'			then RevenueCode end desc,
										case when @SortExpression= 'FromDate'					then FromDate end,                                  
										case when @SortExpression= 'FromDate desc'				then FromDate end desc,
										case when @SortExpression= 'ToDate'						then ToDate end,                                  
										case when @SortExpression= 'ToDate desc'				then ToDate end desc,
										ProcedureRateId)  as RowNumber,
						 ModifierGroupName
			from PlanBilingCode)
      select top (case when (@PageNumber = -1) then (select isnull(totalrows, 0)
                                                     from   counts)
                       else (@PageSize)
                  end)
              ProcedureCodeId,
              ProcedureRateId,
              ProcedureCode,
              Priority,
              Charge,
              BillingCode,
              ProgramGroupName,
              LocationGroupName,
              DegreeGroupName,
              StaffGroupName,
              ServiceAreaGroupName,
              PlaceOfServiceGroupName,
              ClientName,
              RevenueCode,
              FromDate,
              ToDate,
              RecordDeleted,
              ClientWasPresent,
              BillingCodeClaimUnits,
              BillingCodeUnitType,
              RevenueCodeDescription,
              Comment,
              CoveragePlanId,
              CreatedBy,
              CreatedDate,
              ModifiedBy,
              ModifiedDate,
              DeletedDate,
              DeletedBy,
              Amount,
              ChargeType,
              FromUnit,
              ToUnit,
              ClientId,
              BillingCodeUnits,
              Modifier1,
              Modifier2,
              Modifier3,
              Modifier4,
              Advanced,
              StandardRateId,
              BillingCodeModified,
              NationalDrugCode,
              ModifierId1,
              ModifierId2,
              ModifierId3,
              ModifierId4,
              AddModifiersFromService,
              DisplayAs,
              ProcedureCodeName,
              BillingCodeAs,
              TotalCount,
              RowNumber,
              ModifierGroupName
      into    #FinalResultSet
      from    RankResultSet
      where   RowNumber > ((@PageNumber - 1) * @PageSize)
                
    declare @EffectiveRow int 
    
    set @EffectiveRow = 0
   
    if @EffectiveFlag = 'Y' 
      begin
        delete  from #FinalResultSet
        where   getdate() not between cast(FromDate as datetime)
                          and isnull(cast(ToDate as datetime), convert(datetime, '12/31/2099', 101))

        select  @EffectiveRow = @@ROWCOUNT 
		
      end
		
		
    if (select  isnull(count(*), 0)
        from    #FinalResultSet) < 1 
      begin
        select  0 as PageNumber,
                0 as NumberOfPages,
                0 NumberOfRows
      end
    else 
      begin                             
        select top 1
                @PageNumber as PageNumber,
                case (TotalCount - @EffectiveRow % @PageSize)
                  when 0 
                  then isnull((TotalCount - @EffectiveRow / @PageSize), 0)
                  else isnull(((TotalCount - @EffectiveRow) / @PageSize), 0) + 1
                end as NumberOfPages,
                isnull(TotalCount - @EffectiveRow, 0) as NumberOfRows
        from    #FinalResultSet 
      end         
                        
    select  ProcedureCodeId,
            ProcedureRateId,
            ProcedureCode,
            Priority,
            Charge,
            BillingCode,
            ProgramGroupName,
            LocationGroupName,
            DegreeGroupName,
            StaffGroupName,
            ServiceAreaGroupName,
            PlaceOfServiceGroupName,
            ClientName,
            RevenueCode,
            FromDate,
            ToDate,
            RecordDeleted,
            ClientWasPresent,
            BillingCodeClaimUnits,
            BillingCodeUnitType,
            RevenueCodeDescription,
            Comment,
            CoveragePlanId,
            CreatedBy,
            CreatedDate,
            ModifiedBy,
            ModifiedDate,
            DeletedDate,
            DeletedBy,
            Amount,
            ChargeType,
            FromUnit,
            ToUnit,
            ClientId,
            BillingCodeUnits,
            Modifier1,
            Modifier2,
            Modifier3,
            Modifier4,
            Advanced,
            StandardRateId,
            BillingCodeModified,
            NationalDrugCode,
            ModifierId1,
            ModifierId2,
            ModifierId3,
            ModifierId4,
            AddModifiersFromService,
            DisplayAs,
            ProcedureCodeName,
            BillingCodeAs,
            ModifierGroupName
    from    #FinalResultSet
    order by RowNumber
    drop table #CustomFilters
  end try
	
  begin catch
    declare @Error varchar(8000)       
    set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_DetailPagePMCoveragePlansBillingCode') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())
    raiserror
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
  end catch
end

go
