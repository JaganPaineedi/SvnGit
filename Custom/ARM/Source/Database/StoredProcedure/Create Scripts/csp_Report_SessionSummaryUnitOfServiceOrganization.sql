/****** Object:  StoredProcedure [dbo].[csp_Report_SessionSummaryUnitOfServiceOrganization]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_SessionSummaryUnitOfServiceOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_SessionSummaryUnitOfServiceOrganization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_SessionSummaryUnitOfServiceOrganization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create  proc [dbo].[csp_Report_SessionSummaryUnitOfServiceOrganization]
    @StartDate as datetime,
    @EndDate as datetime,
    @Billable as int,  -- 0 Mean All, 1 Billable, 2 Not Billable
    @ServiceAreaID as int,  -- 0 Means don''t group by, 1 means group by
    @ProgramID as int,  -- 0 Means don''t group by, 1 means group by
    @locationID as int  -- 0 Means don''t group by, 1 means group by
as 
begin

    if OBJECT_ID(''tempdb..#SSDetailedServiceUnitStaff'') is not null 
        begin
            drop table #SSDetailedServiceUnitStaff
        end


    create table #SSDetailedServiceUnitStaff (
     StaffID int not null,
     StaffName varchar(50) not null,
     SupervisorID int null,
     SupervisorName varchar(50) null
    )

    insert  #SSDetailedServiceUnitStaff
    select distinct
            S.StaffID as StaffID,
            S.LastName + '', '' + S.FirstName as StaffName,
            SS.SupervisorID as SupervisorID,
            S2.LastName + '', '' + S2.FirstName as SupervisorName
    from    Staff as S
    left join (
               select   ss1.StaffId,
                        MIN(ss1.SupervisorId) as SupervisorId
               from     dbo.StaffSupervisors as ss1
               where    ISNULL(ss1.RecordDeleted, ''N'') <> ''Y''
               group by ss1.StaffId
              ) as ss on ss.StaffId = S.StaffId
    left join Staff as S2 on SS.SuperVisorID = S2.StaffID

    if OBJECT_ID(''tempdb..#SSDetailedServiceUnitList'') is not null 
        drop table #SSDetailedServiceUnitList

    select  S.ServiceID,
            S.ProcedureCodeID,
            ClinicianID,
			Billable = case when C.ProcedureCategory is not null then ''Y'' else ''N'' end,
            ClientID,
            PR.ProgramId,
            pr.ProgramName,
            SR.ServiceAreaId,
            SR.ServiceAreaName,
            LO.LocationCode,
            LO.LocationId,
            PC.DisplayAs as ProcedureCode,
            Stf.*,
            1 as num_co_therapists,
            -- Apt kept is complete only
            CASE when s.Status in (75) then 1
                 else 0
            end as AptKept,
            -- no-show appts
            CASE when s.Status in (72) then 1
                 else 0
            end as NoShow,
            -- do not include clinician cancels here
            CASE when s.Status in (73)
                      and s.CancelReason <> 20466 then 1
                 else 0
            end as ClientsCancel,
            CASE when s.status in (71) then 1
                 else 0
            end as AptPending,
            -- include clinician cancels here
            CASE when s.Status in (73)
                      and s.CancelReason = 20466 then 1
                 else 0
            end as ClinicianCancel,
            CAST(null as decimal) as Units
    into    #SSDetailedServiceUnitList
    from    Services as S
    join    ProcedureCodes as PC on S.ProcedureCodeID = PC.ProcedureCodeID
    join    Programs as PR on PR.ProgramId = S.ProgramId
    join    ServiceAreas as SR on SR.ServiceAreaId = PR.ServiceAreaId
    join    Locations as LO on LO.LocationId = S.LocationId
    left join CustomUnitsOfServiceProcedureCategories C on c.ProcedureCodeId = PC.ProcedureCodeId
    join    #SSDetailedServiceUnitStaff as Stf on stf.StaffID = ClinicianID
    where   ISNULL(S.RecordDeleted, ''N'') <> ''Y''
            and S.[Status] in (71-- Show,
                      , 75--Completed
                      , 72-- No show
                      , 73-- cancel
                      )
            and DATEDIFF(DAY, DateOfService, @EndDate) >= 0
            and DATEDIFF(DAY, DateofService, @StartDate) <= 0


    if OBJECT_ID(''tempdb..#SSDetailedServiceUnitsResult'') is not null 
        drop table #SSDetailedServiceUnitsResult

    select
            CASE when @ServiceAreaID = 0 then null
                 else ServiceAreaName
            end as ServiceAreaName,
            CASE when @ProgramID = 0 then null
                 else ProgramName
            end as ProgramName,
            CASE when @locationID = 0 then null
                 else LocationCode
            end as LocationCode,
            ISNULL(gc.CodeName, ''Other'') as ProcedureCodeCatgory,
            ISNULL(cupc.ProcedureSubcategory, ''Other'') as ProcedureSubcategory,
            SUM(AptKept) as SumOfApptKept,
            SUM(NoShow) as SumOfNoShow,
            SUM(ClientsCancel) as SumOfClientsCanceled,
            SUM(AptPending) as SumAptPending,
            SUM(ClinicianCancel) as SumClinicianCancel
    into    #SSDetailedServiceUnitsResult
    from    #SSDetailedServiceUnitList S
    left join CustomUnitsOfServiceProcedureCategories as cupc on S.ProcedureCodeId = cupc.ProcedureCodeId
                                                              and ISNULL(cupc.RecordDeleted,
                                                              ''N'') <> ''Y''
    left join dbo.GlobalCodes as gc on gc.GlobalCodeId = cupc.ProcedureCategory
    group by
            CASE when @ServiceAreaID = 0 then null
                 else ServiceAreaName
            end,
            CASE when @ProgramID = 0 then null
                 else ProgramName
            end,
            CASE when @locationID = 0 then null
                 else LocationCode
            end,
            ISNULL(gc.CodeName, ''Other''),
            ProcedureSubcategory


    if OBJECT_ID(''tempdb..#SSDetailedServiceUnitList'') is not null 
        drop table #SSDetailedServiceUnitList


    select  s.*,
            (s.SumOfApptKept + s.SumOfNoShow + s.SumOfClientsCanceled
             + SumAptPending + SumClinicianCancel) as TotalApptsScheduled,
            f.OrganizationName
    from    #SSDetailedServiceUnitsResult as S
    cross join SystemConfigurations f
    order by
		   CASE when @ServiceAreaID = 0 then null
                 else ServiceAreaName
            end,
            CASE when @ProgramID = 0 then null
                 else ProgramName
            end,
            CASE when @locationID = 0 then null
                 else LocationCode
            end,
            ProcedureCodeCatgory,
            ProcedureSubcategory,
            ProgramName



    if OBJECT_ID(''tempdb..#SSDetailedServiceUnitStaff'') is not null 
        begin
            drop table #SSDetailedServiceUnitStaff
        end



end
' 
END
GO
