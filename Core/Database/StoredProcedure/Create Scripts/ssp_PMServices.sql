if object_id('dbo.ssp_PMServices') is not null
  drop procedure dbo.ssp_PMServices
go

create procedure dbo.ssp_PMServices
/******************************************************************************         
** File: ssp_PMServices.sql        
** Name: ssp_PMServices        
** Desc:          
**         
**         
** This template can be customized:         
**         
** Return values: Filter Values - Service List Page        
**         
** Called by:         
**         
** Parameters:         
** Input Output         
** ---------- -----------         
** N/A   Dropdown values        
** Auth: Mary Suma        
** Date: 16/06/2011        
*******************************************************************************         
** Change History         
*******************************************************************************         
** Date:			Author:			Description:         
** 16/06/2011		Mary Suma		Query to return values for the grid in Services List Page        
-------------  --------				---------------------------------------------------------       
** 25/08/2011    Mary Suma			Included Javed's Changes on Performance Tuning         
** 05/12/2011    Mary Suma			Modified Date format for DOS      
-- 28 Mar 2012   PSelvan			Performance Tuning.	 
-- 4.04.2012     Ponnin Selvan		Conditions added for Export 
-- 13.04.2012    PSelvan			Added Conditions for NumberOfPages. 
-- 22.04.2012    MSuma				Removed Join on StaffClients  
-- 25.04.2012    MSuma				Included count for zero records 
-- 08.06.2012    MSuma				Included Complete ServiceErrors 
-- 17.Apr.2015	 Revathi			what:FinancialAssignment filter added 
								    why:task #950 Valley - Customizations 
-- 06-Aug-2015  Revathi			    what:ServiceArea  filter Modified with Programs 
								    why:task #950 Valley - Customizations 		
--21-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName	
--3/1/2016-3/8/2016	 jcarlson			performance improvements from slavik, changed how error messages are concatenated.
--								if user enters a serviceid, the script ignores the filters
--								if user selects an error message, that error message is the first in the error message list	
  25.Mar.2016     Gautam        Changed code to see those services that are in a Program that is associated to the Staff Account based on sys key 'ShowAllClientsServices'
								Why : Engineering Improvement Initiatives- NBL(I) > Tasks#297 	
/*  05.Aug.2016     Basudev     Changed code to see those services from claims if filter @ServicesfromClaims = 'Y' 
								Why : CEI - Support Go Live Task #233 */
								
22-Nov-2016 Sachin Borgave		Added Charge Column For Getting ASC and DESC Order For Core Bugs #2329 	
12-Dec-2016  	Gautam         Added code to display Service Units (only for export) & corrcted Claim units code,Philhaven-Support# 77 ,Keystone - Customizations #43 
01-Feb-2017		NJain		   Updated Service Units in Export to add unit name also. Philhaven Support #136		    
21.Feb.2017     Alok Kumar	Added a new filter 'Add On Codes' and a new column to the List page. 
								Why : Harbor - Support	Task #1003. 
06.Jul.2017		Gautam		Modified code for Performance issue.,Thresholds - Support, Task#991			
08.01.2017      SFarber             Modified to use ssf_FinancialAssignmentServices
03.Aug.2017     Ajay            Added Clinician Parameter to ssf_FinancialAssignmentServices function. AHN-Customization:#44 
08/11/2017		Chethan N		What : Added condition to filter Scheduled or Show Services when any specific error is selected in the filter. 
								Why : Engineering Improvement Initiatives- NBL(I) task # 592.
12 May 2018		Vithobha		Added NonBillableServices,ServiceArea,ClientId & OrganizationProgramId filters for Engineering Improvement Initiatives- NBL(I) task # 302.	
11/Sep 2018     Prem Reddy      What:Added Distinct keyword while inserting Program Id's to the #TempOrganizationPrograms table.
                                Why:	CCC - SGL #9	
12/SEP/2018      Akwinass       What: Added a new column 'Group Name' to display the Group name if the service is a Group Service Note.
                                Why: New Directions - Enhancements #13
*******************************************************************************/
  @SessionId varchar(30),
  @InstanceId int,
  @PageNumber int,
  @PageSize int,
  @SortExpression varchar(100),
  @StaffId int,
  @ServiceFilter int,
  @Status int,
  @ShowDoNotComplete char(1),
  @Signed char(1),
  @ProgramId int,
  @LocationId int,
  @ClinicainId int,
  @ServiceEntryStaffId int,
  @EnteredFrom varchar(30),
  @EnteredTo varchar(30),
  @DOSFrom varchar(30),
  @DOSTo varchar(30),
  @ProcedureCodeID int,
  @ServiceId int,
  @OtherFilter int,
  @FinancialAssignmentId int,
  @ServicesfromClaims char(1) = 'N',
  @AddOnCodes char(1) = 'N',				--13.Feb.2017     Alok Kumar
  @NonBillableServices char(1),				--12 May 2018	Vithobha
  @ServiceArea int,
  @ClientId int,
  @OrganizationProgramId varchar(max)
as
begin try
--12 May 2018		Vithobha
	IF OBJECT_ID('tempdb..#TempOrganizationPrograms') IS NULL
	BEGIN
		CREATE TABLE #TempOrganizationPrograms (ProgramId INT)
	END

	IF (@ProgramId != - 1)
	BEGIN
		INSERT INTO #TempOrganizationPrograms (ProgramId)
		SELECT @ProgramId
	END

	IF @ProgramId = - 1
	BEGIN
		INSERT INTO #TempOrganizationPrograms (ProgramId)
		SELECT Distinct CONVERT(INT, item) --Distinct Keyword Added by Prem
		FROM dbo.fnSplitWithIndex(@OrganizationProgramId, ',')
	END

	
  create table #ServiceFilter (ServiceId int null)

  create table #temp1 (RowNumber int,
                       PageNumber int,
                       ServiceId int,
                       ClientId int,
                       Name varchar(50),
                       DateOfService datetime,
                       ProcedureCodeId int,
                       DisplayAs varchar(50),
                       StaffName varchar(50),
                       ProgramId int,
                       ProgramCode varchar(100),
                       LocationId int,
                       LocationName varchar(100),
                       ProcedureRateId varchar(50),
                       Charge money,
                       STATUS int,
                       ErrorMessage varchar(300),
                       DoNotComplete char,
                       ClinicianId int,
                       CreatedDate datetime,
                       CreatedBy varchar(30),
                       MaxServiceErrorId int,
                       CodeName varchar(200),
                       CompleteErrorMessage varchar(max),
                       Units decimal(18, 2),
                       ServiceUnits varchar(300), --12-Dec-2016  	Gautam 
                       AddOnCodes varchar(max),	--13.Feb.2017     Alok Kumar
					   GroupName  varchar(250), --12/SEP/2018      Akwinass
					   GroupId int,      
					   GroupServiceId int
                       )

  if (@EnteredFrom = convert(datetime, N''))
    begin
      set @EnteredFrom = null
    end

  if (@EnteredTo = convert(datetime, N''))
    begin
      set @EnteredTo = null
    end

  if (@DOSFrom = convert(datetime, N''))
    begin
      set @DOSFrom = null
    end

  if (@DOSTo = convert(datetime, N''))
    begin
      set @DOSTo = null
    end

  create table #ServiceErrors (ServiceId int,
                               ServiceErrorId int,
                               ErrorMessage varchar(500))

  declare @EntryStaffUserCode varchar(30)

  if @ServiceEntryStaffId is not null
    select  @EntryStaffUserCode = UserCode
    from    Staff
    where   StaffId = @ServiceEntryStaffId

  declare @CustomFilters table (ServiceId int)
  declare @ApplyFilterClicked char(1)
  declare @CustomFiltersApplied char(1)
  declare @ClientFirstLastName varchar(25)
  declare @ClientLastLastName varchar(25)
  declare @ClientLastNameCount int = 0

  create table #ClientLastNameSearch (LastNameSearch varchar(max))

  if isnull(@FinancialAssignmentId, -1) <> -1
    begin
      select  @ClientFirstLastName = FinancialAssignmentServiceClientLastNameFrom,
              @ClientLastLastName = FinancialAssignmentServiceClientLastNameTo
      from    FinancialAssignments
      where   FinancialAssignmentId = @FinancialAssignmentId
              and isnull(RecordDeleted, 'N') = 'N'

      insert  into #ClientLastNameSearch
              exec ssp_SCGetPatientSearchValues @ClientFirstLastName, @ClientLastLastName

      set @ClientLastNameCount = (select  count(1)
                                  from    #ClientLastNameSearch)
    end

  set @SortExpression = rtrim(ltrim(@SortExpression))

  if isnull(@SortExpression, '') = ''
    set @SortExpression = 'DateOfService'

  --         
  -- New retrieve - the request came by clicking on the Apply Filter button                           
  --        
  set @ApplyFilterClicked = 'Y'
  set @CustomFiltersApplied = 'N'
            
  declare @ShowAllClientsServices char(1)   
  create table #StaffPrograms (ProgramId int)
		   
  select  @ShowAllClientsServices = dbo.ssf_GetSystemConfigurationKeyValue('ShowAllClientsServices')
  if isnull(@ShowAllClientsServices, 'Y') = 'N'
    begin
      if exists ( select  1
                  from    ViewStaffPermissions
                  where   StaffId = @StaffId
                          and PermissionTemplateType = 5705
                          and PermissionItemId = 5744 ) --5744 (Clinician in Program Which Shares Clients) 5741(All clients)
        and not exists ( select 1
                         from   ViewStaffPermissions
                         where  StaffId = @StaffId
                                and PermissionTemplateType = 5705
                                and PermissionItemId = 5741 )
        begin                          
          insert  into #StaffPrograms
          select  ProgramId
          from    StaffPrograms
          where   StaffId = @StaffId
                  and isnull(RecordDeleted, 'N') <> 'Y'
        end
      else
        begin
          set @ShowAllClientsServices = 'Y'
        end
    end 
  else
    begin
      set @ShowAllClientsServices = 'Y'
    end
			   

  if isnull(@FinancialAssignmentId, -1) <> -1
    if @OtherFilter > 10000
      begin
        set @CustomFiltersApplied = 'Y'

        insert  into @CustomFilters
                (ServiceId)
                exec scsp_PMServices @StaffId = @StaffId, @ServiceFilter = @ServiceFilter, @Status = @Status, @ShowDoNotComplete = @ShowDoNotComplete, @Signed = @Signed, @ProgramId = @ProgramId, @LocationId = @LocationId, @ClinicainId = @ClinicainId, @ServiceEntryStaffId = @ServiceEntryStaffId, @EnteredFrom = @EnteredFrom, @EnteredTo = @EnteredTo, @DOSFrom = @DOSFrom, @DOSTo = @DOSTo, @ProcedureCodeID = @ProcedureCodeID, @ServiceId = @ServiceId, @OtherFilter = @OtherFilter
      end

  --        
  --  Find only billable procedure codes for the corresponding coverage plan        
  --        
  begin
    if @CustomFiltersApplied = 'Y'
      begin
        insert  into #ServiceFilter
                (ServiceId)
        select  ServiceId
        from    @CustomFilters
      end
    if @CustomFiltersApplied = 'N'
      begin
        --if the user enters a service id return it, ignore other filters
        if @ServiceId <> -1
          begin
            insert  into #ServiceFilter
                    (ServiceId)
            select  s.ServiceId
            from    dbo.services as s
                    join dbo.StaffClients as sc on s.ClientId = sc.ClientId
                                                   and sc.StaffId = @StaffId
            where   s.ServiceId = @ServiceId
                    and (s.RecordDeleted = 'N'
                         or s.RecordDeleted is null)
          end
        else
          begin
            if @ServiceFilter > 0
              or @ServiceFilter = -2
              begin
                insert  into #ServiceFilter
                        (ServiceId)
                select distinct
                        s.ServiceId
                from    services s
                        inner join StaffClients sc on sc.ClientId = s.ClientId
                        left join Programs p on p.ProgramId = s.ProgramId AND ISNULL(p.RecordDeleted,'N')='N'  --12 May 2018		Vithobha  
                        left join ServiceAreas sa on p.ServiceAreaId = sa.ServiceAreaId  
                        left join #TempOrganizationPrograms T on T.ProgramId = s.ProgramId 
                        cross apply dbo.ssf_FinancialAssignmentServices(@FinancialAssignmentId, s.ClientId, s.ProgramId, s.ProcedureCodeId, s.LocationId, s.ClinicianId) --Added by Ajay on 03-Aug-2017
                where   isnull(s.OverrideError, 'N') = 'N'
                        and ((@Status = -1  AND S.Status IN (70,71))  --Added by Chethan N on 08/11/2017
                             or s.Status = @Status)
                        and((@ProgramId = - 1 AND @OrganizationProgramId='')or EXISTS ( SELECT 1 FROM  #TempOrganizationPrograms TP WHERE TP.ProgramId = p.ProgramId))        --12 May 2018  Vithobha
                        and (@ServiceArea = -1 or (sa.ServiceAreaId = @ServiceArea))
                        and (@LocationId = -1
                             or s.LocationId = @LocationId)
                        and (@ClinicainId = -1
                             or s.ClinicianId = @ClinicainId)
                        and (@ProcedureCodeID = -1
                             or s.ProcedureCodeId = @ProcedureCodeID)
                        and (@DOSFrom is null
                             or s.DateOfService >= @DOSFrom)
                        and (isnull(@DOSTo, '') = ''
                             or s.DateOfService < dateadd(dd, 1, @DOSTo))
                        and (@ShowDoNotComplete = 'I'
                             or (@ShowDoNotComplete = 'E'
                                 and isnull(s.DoNotComplete, 'N') = 'N')
                             or (@ShowDoNotComplete = 'O'
                                 and s.DoNotComplete = 'Y'))
                        and (@ServiceEntryStaffId = -1
                             or s.CreatedBy = @EntryStaffUserCode)
                        and (@EnteredFrom is null
                             or s.CreatedDate >= @EnteredFrom)
                        and (isnull(@EnteredTo, '') = ''
                             or s.CreatedDate < dateadd(dd, 1, @EnteredTo))
                        and sc.StaffId = @StaffId
                        --jcarlson 3/8/2016
                        and exists ( select 1
                                     from   dbo.ServiceErrors se
                                     where  se.ServiceId = s.ServiceId
                                            and isnull(se.RecordDeleted, 'N') = 'N'
                                            and (@ServiceFilter = -2
                                                 or (@ServiceFilter > 0
                                                     and se.ErrorType = @ServiceFilter)) )
                        and isnull(s.RecordDeleted, 'N') = 'N'
              end                 
            else
              begin

                insert  into #ServiceFilter
                        (ServiceId)
                select  s.ServiceId
                from    services s
                        left join Programs p on p.ProgramId = s.ProgramId AND ISNULL(p.RecordDeleted,'N')='N'  --12 May 2018		Vithobha  
                        left join ServiceAreas sa on p.ServiceAreaId = sa.ServiceAreaId  
                        left join #TempOrganizationPrograms T on T.ProgramId = s.ProgramId
                        inner join StaffClients sc on sc.ClientId = s.ClientId
                        cross apply dbo.ssf_FinancialAssignmentServices(@FinancialAssignmentId, s.ClientId, s.ProgramId, s.ProcedureCodeId, s.LocationId,s.ClinicianId) --Added by Ajay on 03-Aug-2017
                where   (@Status = -1
                         or s.Status = @Status)
                        and((@ProgramId = - 1 AND @OrganizationProgramId='')or EXISTS ( SELECT 1 FROM  #TempOrganizationPrograms TP WHERE TP.ProgramId = p.ProgramId))        --12 May 2018  Vithobha
                        and (@ServiceArea = -1 or (sa.ServiceAreaId = @ServiceArea))
                        and (@LocationId = -1
                             or s.LocationId = @LocationId)
                        and (@ClinicainId = -1
                             or s.ClinicianId = @ClinicainId)
                        and (@ProcedureCodeID = -1
                             or s.ProcedureCodeId = @ProcedureCodeID)
                        and (@DOSFrom is null
                             or s.DateOfService >= @DOSFrom)
                        and (isnull(@DOSTo, '') = ''
                             or s.DateOfService < dateadd(dd, 1, @DOSTo))
                        and (@ShowDoNotComplete = 'I'
                             or (@ShowDoNotComplete = 'E'
                                 and isnull(s.DoNotComplete, 'N') = 'N')
                             or (@ShowDoNotComplete = 'O'
                                 and s.DoNotComplete = 'Y'))
                        and (@ServiceEntryStaffId = -1
                             or s.CreatedBy = @EntryStaffUserCode)
                        and (@EnteredFrom is null
                             or s.CreatedDate >= @EnteredFrom)
                        and (isnull(@EnteredTo, '') = ''
                             or s.CreatedDate < dateadd(dd, 1, @EnteredTo))
                        and (@ServiceFilter = -1
                             or (@ServiceFilter = 0
                                 and s.Status = 71
                                 and not exists ( select  '*'
                                                  from    ServiceErrors se
                                                  where   s.ServiceId = se.ServiceId
                                                          and isnull(se.RecordDeleted, 'N') = 'N' )))
                        and isnull(s.RecordDeleted, 'N') = 'N'
                        and sc.StaffId = @StaffId
              end
          end
      end


    insert  into #temp1
            (ServiceId,
             ClientId,
             Name,
             DateOfService,
             ProcedureCodeId,
             DisplayAs,
             StaffName,
             ProgramId,
             ProgramCode,
             LocationId,
             LocationName,
             ProcedureRateId,
             Charge,
             STATUS,
             DoNotComplete,
             ClinicianId,
             CreatedDate,
             CreatedBy,
             CodeName,
             ServiceUnits,
             AddOnCodes		--13.Feb.2017     Alok Kumar
             )
    select  s.ServiceId,
            c.ClientId,
            case when isnull(c.ClientType, 'I') = 'I' then substring(c.LastName + ', ' + c.FirstName, 1, 50)
                 else substring(c.OrganizationName, 1, 50)
            end,
            convert(datetime, s.DateOfService),
            pc.ProcedureCodeId,
            substring(pc.DisplayAs, 1, 50),
            substring(st.LastName + ', ' + st.Firstname, 1, 50),
            p.ProgramId,
            p.ProgramCode,
            l.LocationId,
            l.LocationName,
            convert(varchar, s.Charge) + case when s.ProcedureRateId is null then rtrim('')
                                              else ' ( ' + convert(varchar, s.ProcedureRateId) + ' )'
                                         end,
            s.Charge,
            s.STATUS,
            s.DoNotComplete,
            s.ClinicianId,
            convert(datetime, convert(varchar(10), s.CreatedDate, 101)),
            s.CreatedBy,
            gc.CodeName + rtrim(isnull(' (' + rtrim(gc1.CodeName) + ')', '')) as CodeName --Added by Priya to concat Cncel Reason in lieu of #1143                            
            ,
            convert(varchar(25), s.Unit) + ' ' + isnull(GCD2.CodeName, '') as Units,   --02-Dec-2016  	Gautam 
            null as AddOnCodes		--13.Feb.2017     Alok Kumar
    from    #ServiceFilter sf
            inner join services s on sf.ServiceId = s.ServiceId
            inner join Clients c on s.ClientId = c.ClientId
                                  and (exists ( select  1
                                                  from    #ClientLastNameSearch f
                                                  where   isnull(c.ClientType, 'I') = 'I'
                                                          and c.LastName collate database_default like f.LastNameSearch collate database_default )
                                         or exists ( select 1
                                                     from   #ClientLastNameSearch f
                                                     where  isnull(c.ClientType, 'I') = 'O'
                                                            and c.OrganizationName collate database_default like f.LastNameSearch collate database_default )
                                         or (isnull(@ClientLastNameCount, 0) = 0))
            inner join ProcedureCodes pc on s.ProcedureCodeId = pc.ProcedureCodeId
            inner join Programs p on s.ProgramId = p.ProgramId
            left join Staff st on s.ClinicianId = st.StaffId
            left join Locations l on s.LocationId = l.LocationId
            left join GlobalCodes gc on s.STATUS = gc.GlobalCodeId
            left join GlobalCodes gc1 on s.CancelReason = gc1.GlobalCodeId --Added by Priya to concat Cncel Reason in lieu of #1143            
            left join GlobalCodes GCD2 on GCD2.GlobalCodeId = s.UnitType
    where   (@ShowAllClientsServices = 'Y'
             or (@ShowAllClientsServices = 'N'
                 and exists ( select  *
                              from    #StaffPrograms SP
                              where   SP.ProgramId = s.ProgramId )))
            --13.Feb.2017     Alok Kumar 
            and (@AddOnCodes = 'N'
                 or (@AddOnCodes = 'Y'
                     and exists ( select  1
                                  from    ServiceAddOnCodes ACS
                                  where   ACS.ServiceId = s.ServiceId
                                          and isnull(ACS.RecordDeleted, 'N') = 'N' )))			--15.Mar.2017     Alok Kumar
            and (@ServicesfromClaims = 'Y'
                 or (@ServicesfromClaims = 'N'
                     and not exists ( select  1
                                      from    ClaimLineServiceMappings CLSM
                                      where   CLSM.ServiceId = sf.ServiceId
                                              and ((CLSM.RecordDeleted = 'N')
                                                   or (CLSM.RecordDeleted is null)) ))) 
            and (@NonBillableServices = 'N' or (@NonBillableServices = 'Y' and isnull(s.Billable,'N') ='N'))	--12 May 2018	Vithobha
            and (@ClientId = 0 or c.ClientId = @ClientId)
            
    
	-- Update Units (Claim units) --12-Dec-2016  	Gautam 
    update  C
    set     C.Units = ch2.Units
    from    #temp1 C
            inner join (select  ServiceId,
                                ChargeId,
                                Units
                        from    (select Ch.ServiceId,
                                        Ch.ChargeId,
                                        Ch.Units,
                                        row_number() over (partition by Ch.ServiceId order by Ch.ChargeId asc) as RNK
                                 from   Charges Ch
                                        join #temp1 d on Ch.ServiceId = d.ServiceId
                                                         and Ch.Priority <= 1
                                 where  isnull(Ch.RecordDeleted, 'N') = 'N') Ch1
                        where   RNK = 1) ch2 on C.ServiceId = ch2.ServiceId      
							
	--06-July-2017	Gautam
    update  C
    set     C.AddOnCodes = isnull(replace(replace(stuff((select distinct
                                                                ', ' + PC.ProcedureCodeName
                                                         from   ProcedureCodes PC
                                                                join ServiceAddOnCodes SOC on PC.ProcedureCodeId = SOC.AddOnProcedureCodeId
                                                         where  SOC.ServiceId = C.ServiceId
                                                                and isnull(SOC.RecordDeleted, 'N') = 'N'
                                                        for
                                                         xml path('')), 1, 1, ''), '&lt;', '<'), '&gt;', '>'), '')
    from    #temp1 C
            join ServiceAddOnCodes SOC1 on SOC1.ServiceId = C.ServiceId
                                           and isnull(SOC1.RecordDeleted, 'N') = 'N'

	--12/SEP/2018      Akwinass
	UPDATE C
	SET C.GroupName = ISNULL(G.GroupName, '')
		,C.GroupId = GS.GroupId
		,C.GroupServiceId = GS.GroupServiceId
	FROM #temp1 C
	JOIN Services S ON C.ServiceId = S.ServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N'
	JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId AND ISNULL(GS.RecordDeleted, 'N') = 'N'
	JOIN Groups G ON GS.GroupId = G.GroupId
			                         
	-- Get the list of service  errors                                        
    insert  into #ServiceErrors
            (ServiceId,
             ServiceErrorId,
             ErrorMessage)
    select  a.ServiceId,
            b.ServiceErrorId,
            b.ErrorMessage
    from    #temp1 a
            inner join ServiceErrors b on (a.ServiceId = b.ServiceId)
                                          and isnull(b.RecordDeleted, 'N') = 'N'
    order by case when @ServiceFilter in (-2, -1, 0) then 100
                  when @ServiceFilter = b.ErrorType then 1
                  else 100
             end

	-- Showing a maximum of 3 errors                                        
    update  p
    set     ErrorMessage = stuff((select top 3
                                          ', ' + case when len(c.ErrorMessage) > 35 then substring(c.ErrorMessage, 1, 32) + '...'
                                                      else c.ErrorMessage
                                                 end
                                  from    #ServiceErrors c
                                  where   c.ServiceId = p.ServiceId
                                 for
                                  xml path('')), 1, 2, '')
    from    #temp1 p;
					
    update  p
    set     CompleteErrorMessage = stuff((select  ', ' + ErrorMessage
                                          from    #ServiceErrors c
                                          where   c.ServiceId = p.ServiceId
                                         for
                                          xml path('')), 1, 2, '')
    from    #temp1 p;

    with  counts
            as (select  count(*) as totalrows
                from    #temp1),
          RankResultSet
            as (select  ServiceId,
                        ClientId,
                        Name,
                        DateOfService,
                        ProcedureCodeId,
                        DisplayAs,
                        StaffName,
                        ProgramId,
                        ProgramCode,
                        LocationId,
                        LocationName,
                        ProcedureRateId,
                        Charge,
                        STATUS,
                        ErrorMessage,
                        DoNotComplete,
                        ClinicianId,
                        CreatedDate,
                        CreatedBy,
                        CodeName,
                        Units,
                        CompleteErrorMessage,
                        ServiceUnits, --12-Dec-2016  	Gautam 
                        AddOnCodes,		--13.Feb.2017     Alok Kumar
						GroupName,--12/SEP/2018      Akwinass
						GroupId,
						GroupServiceId,
                        count(*) over () as TotalCount,
                        rank() over (order by case when @SortExpression = 'ServiceId' then ServiceId end
							, case when @SortExpression = 'ServiceId DESC' then ServiceId end desc
							, case when @SortExpression = 'DateOfService' then DateOfService end
							, case when @SortExpression = 'DateOfService DESC' then DateOfService end desc
							, case when @SortExpression = 'Name' then Name end
							, case when @SortExpression = 'Name DESC' then Name end desc
							, case when @SortExpression = 'DisplayAs' then DisplayAs end
							, case when @SortExpression = 'DisplayAs DESC' then DisplayAs end desc
							, case when @SortExpression = 'StaffName' then StaffName end
							, case when @SortExpression = 'StaffName DESC' then StaffName end desc
							, case when @SortExpression = 'ProgramCode' then ProgramCode end
							, case when @SortExpression = 'ProgramCode DESC' then ProgramCode end desc
							, case when @SortExpression = 'LocationName' then LocationName end
							, case when @SortExpression = 'LocationName DESC' then LocationName end desc
							, case when @SortExpression = 'ProcedureRateId' then Charge end
 							, case when @SortExpression = 'ProcedureRateId DESC' then Charge end desc
							, case when @SortExpression = 'Status' then STATUS end
							, case when @SortExpression = 'Status DESC' then STATUS end desc
							, case when @SortExpression = 'ErrorMessage' then ErrorMessage end
							, case when @SortExpression = 'ErrorMessage DESC' then ErrorMessage end desc
							, case when @SortExpression = 'CodeName' then CodeName end
							, case when @SortExpression = 'CodeName DESC' then CodeName end desc
							, case when @SortExpression = 'Units' then Units end
							, case when @SortExpression = 'Units DESC' then Units end desc
                            , case when @SortExpression = 'AddOnCodes' then AddOnCodes end
							, case when @SortExpression = 'AddOnCodes DESC' then AddOnCodes end desc
							, ServiceId) as RowNumber
                from    #temp1)
      select top (case when (@PageNumber = -1) then (select isnull(totalrows, 0)
                                                     from   counts)
                       else (@PageSize)
                  end)
              ServiceId,
              ClientId,
              Name,
              DateOfService,
              ProcedureCodeId,
              DisplayAs,
              StaffName,
              ProgramId,
              ProgramCode,
              LocationId,
              LocationName,
              ProcedureRateId,
              STATUS,
              ErrorMessage,
              DoNotComplete,
              ClinicianId,
              CreatedDate,
              CreatedBy,
              CodeName,
              Units,
              TotalCount,
              RowNumber,
              CompleteErrorMessage,
              ServiceUnits,
              AddOnCodes,			--13.Feb.2017     Alok Kumar
			  GroupName,--12/SEP/2018      Akwinass
			  GroupId,
			  GroupServiceId
      into    #FinalResultSet
      from    RankResultSet
      where   RowNumber > ((@PageNumber - 1) * @PageSize)

    if (select  isnull(count(*), 0)
        from    #FinalResultSet) < 1
      begin
        select  0 as PageNumber,
                0 as NumberOfPages,
                0 as NumberOfRows
      end
    else
      begin
        select top 1
                @PageNumber as PageNumber,
                case (TotalCount % @PageSize)
                  when 0 then isnull((TotalCount / @PageSize), 0)
                  else isnull((TotalCount / @PageSize), 0) + 1
                end as NumberOfPages,
                isnull(TotalCount, 0) as NumberOfRows
        from    #FinalResultSet
      end

    select  a.ServiceId,
            a.Name,
            a.ClientId,
            convert(varchar(19), a.DateOfService, 101) + ' ' + ltrim(substring(convert(varchar(19), a.DateOfService, 100), 12, 6)) + ' ' + ltrim(substring(convert(varchar(19), a.DateOfService, 100), 18, 2)) as DateOfService,
            a.DisplayAs,
            a.StaffName,
            a.ProgramCode,
            a.LocationName,
            a.ProcedureRateId,
            a.STATUS,
            a.ErrorMessage,
            a.CreatedDate,
            a.CreatedBy,
            a.CodeName,
            a.Units,
            a.ProcedureCodeId,
            a.CompleteErrorMessage,
            convert(varchar, b.Unit) + ' ' + (select  gc.CodeName
                                              from    dbo.GlobalCodes gc
                                              where   gc.GlobalCodeId = b.UnitType) as ServiceUnits,
            a.AddOnCodes,		--13.Feb.2017     Alok Kumar
			a.GroupName,--12/SEP/2018      Akwinass
			a.GroupId,
			a.GroupServiceId
    from    #FinalResultSet a
            join dbo.services b on b.ServiceId = a.ServiceId
    order by RowNumber
    
    Delete from #TempOrganizationPrograms
  end
end try

begin catch
  declare @Error varchar(8000)

  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PMServices') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())

  raiserror (@Error, 16, 1);
end catch

go



