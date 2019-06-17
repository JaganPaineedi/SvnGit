if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_ListPageSCAuthorizationDocument]')
                    and type in (N'P', N'PC') ) 
    drop procedure [dbo].[ssp_ListPageSCAuthorizationDocument]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCAuthorizationDocument]    Script Date: 02/18/2014 15:40:42 ******/
set ANSI_NULLS on
GO

set QUOTED_IDENTIFIER on
GO
CREATE procedure [dbo].[ssp_ListPageSCAuthorizationDocument]
    @ClientId int,
    @RequestorsFilter int,
    @ProgramsFilter int,
    @AuthDocStatusFilter int,
    @ProvidersFilter int,
    @SitesFilter int,
    @StartDate varchar(10),
    @EndDate varchar(10),
    @AuthNumber varchar(50),
    @OtherFilter int,
    @StaffId int, --Modified by Sahil Dated : 19-May-2010
    @OrganizationId int,
    @LoggedInStaffId int, --Modified by Sonia Dated : 7-April-2011 task #159
    @CoveragePlanFilter int,-- Added Sudhir Task #223 Venture Region Support
    @RequestedWithin int,-- Added Sudhir Task #224  Venture Region Support
    @AuthDocId int-- Added By S Ganesh Task #271  Summit 3.5 Implementation
--@OrganizationsFilter int  -- Modified by Rakesh Garg Dated : 26-Nov-2010
/********************************************************************************
-- Stored Procedure: dbo.ssp_ListPageSCAuthorizationDocument
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: used by  Attach/Review Claims list page
--
-- Updates:
-- Date        Author           Purpose
-- 06.1.2010   Ankesh           Created.
-- 29Sep,2010 Damanpreet Kaur   Modified Sp because Now, @ProgramsFilter get values from
                                GlobalCodes not from SubGlobalCodes as per Task#586 at StreamlineTesting
-- 26Nov2010  Rakesh Garg       Modified Sp As in New database Model Column Modified and Appealed from Authorization
                                table remove Also we have pass new parameter name Organisation Filter
 ---16 March 2012 Sudhir Singh     updated as per requirement of custom requirement in kalamazoo
 --03/dec/2012   Sudhir Singh  Task#223 Venture Region Support -Bug/Feature Add Coverage Plan Filter on Auth Documents Screen

 12.28.2012 dharvey  Task #224 Modified @RequestedWithin filter logic to return correct list
  -- 21 October 2013 Varun Task #271 Summit 3.5 Implementation - AuthDocId parameter added
  -- 18 February 2014 T.Remisoski	Changed to match widget logic with Recodes
  -- 06 March 2014   Revathi        what: Added join with StaffClients table to display associated Clients for Login staff
--									why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter
-- 28 July 2014      Kirtee         Added one more codition for AuthDocStatusFilter = 457 wrf Task# 286, Customization Bugs
-- 15 Oct  2015      Hemant         Added record deleted conditions wrf Task#222 Customization Bugs 
--17-DEC-2015		Basudev Sahu	Modified For Task #609 Network180 Customization to Get Organisation  As ClientName 
--05 Oct 2017		Neelima		   What: Added these 3 parametes in scsp_ListPageSCAuthorizationDocument since its not getting filtered based on these 3 parameters selection @CoveragePlanFilter @RequestedWithin,@AuthDocId Core Bugs #338	
*********************************************************************************/
as 
begin

    begin try

        create table #ResultSet
            (
             RowNumber int,
             PageNumber int,
             AuthorizationDocumentId int,
--ClientName varchar(80),
             ClientName varchar(100),  --Modified on Dated : 21-06-2010
--Staffname varchar(50),
             Staffname varchar(100),   --Modified on Dated : 21-06-2010
             DocumentCodeId int,
             DocumentName varchar(100),
             StaffId int,
             ClientId int,
             DocumentId int,
--AuthClientId int,                  --Modified on dated : 21-06-2010
--TotalUnits varchar(2),
             Total int,        --Modified on dated : 21-06-2010
             Pended char(1),
--Approved char(1),
             Approved int,     --Modified on dated : 21-06-2010
--Denied char(1),
             Denied int,         --Modified on dated : 21-06-2010
--Requested char(1),
             Requested int,     --Modified on dated : 21-06-2010
--Appealed char(1),
--Appealed int,    --Modified on dated : 21-06-2010   Modified on 03 Feb 2011
             ConsumerAppealed int,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page
             ClinicianAppealed int,
             PartialDenied int,
--Assigned int,            --Modified on dated : 21-06-2010
             RequesterComment varchar(max),
--DateRequested datetime,     --Modified on dated : 21-06-2010
             DocumentScreenId int,
             OrganizationId int
            )

        declare @CustomFilters table
            (
             AuthorizationDocumentId int
            )
        declare @DocumentCodeFilters table (DocumentCodeId int)
        declare @ApplyFilterClicked char(1)
        declare @CustomFiltersApplied char(1)
--Changes made as per task #224 in Venture Region Support
/** Requested Within Timeframe Filter **/
        declare @CurrentDate datetime
        select  @CurrentDate = dbo.RemoveTimeStamp(getdate())

        declare @FilterReviewLevel int,
            @FilterRequestStartTime datetime,
            @FilterRequestEndTime datetime
        if isnull(@RequestedWithin, 0) <> 0 
            begin
  --
  -- REVIEW LEVEL
  --
                if @RequestedWithin in (1, 2, 3, 4) 
                    begin
                        set @FilterReviewLevel = 6682 --CCM
                    end

                if @RequestedWithin in (5, 6, 7, 8) 
                    begin
                        set @FilterReviewLevel = 6681 --LCM
                    end

  --
  -- DATE REQUESTED
  --
                if @RequestedWithin in (1, 5) 
                    begin
    --Within 24 hours
                        select  @FilterRequestStartTime = dateadd(hour, -24,
                                                              @CurrentDate),
                                @FilterRequestEndTime = @CurrentDate
                    end

                if @RequestedWithin in (2, 6) 
                    begin
    --Within 24-48 hours
                        select  @FilterRequestStartTime = dateadd(hour, -48,
                                                              @CurrentDate),
                                @FilterRequestEndTime = dateadd(hour, -24,
                                                              @CurrentDate)
                    end

                if @RequestedWithin in (3, 7) 
                    begin
    --Within 48-72 hours
                        select  @FilterRequestStartTime = dateadd(hour, -72,
                                                              @CurrentDate),
                                @FilterRequestEndTime = dateadd(hour, -48,
                                                              @CurrentDate)
                    end

                if @RequestedWithin in (4, 8) 
                    begin
    --More than 72 hours
                        select  @FilterRequestStartTime = '01/01/1900',
                                @FilterRequestEndTime = dateadd(hour, -72,
                                                              @CurrentDate)
                    end


            end
----
---- New retrieve - the request came by clicking on the Apply Filter button
----

        set @ApplyFilterClicked = 'N'
        set @CustomFiltersApplied = 'N'
        if @AuthDocStatusFilter > 10000
            or @OtherFilter > 10000 
            begin
                set @CustomFiltersApplied = 'Y'
                insert  into #ResultSet
                        (
                         AuthorizationDocumentId,
                         ClientName,
                         Staffname,
                         DocumentCodeId,
                         DocumentName,
                         StaffId,
                         ClientId,
                         DocumentId,
                         Total,
                         Pended,
                         Approved,
                         Denied,
                         Requested,
                         ConsumerAppealed,
                         ClinicianAppealed,
                         PartialDenied,
                         RequesterComment,
                         DocumentScreenId,
                         OrganizationId
                        )
                        exec scsp_ListPageSCAuthorizationDocument 
                            @ClientId,
                            @RequestorsFilter,
                            @ProgramsFilter,
                            @AuthDocStatusFilter,
                            @ProvidersFilter,
                            @SitesFilter,
                            @StartDate,
                            @EndDate,
                            @AuthNumber,
                            @OtherFilter,
                            @StaffId,
                            @OrganizationId,
                            @LoggedInStaffId,
                            @CoveragePlanFilter ,  
							@RequestedWithin ,
							@AuthDocId 
            end

        if @CustomFiltersApplied = 'N' 
        BEGIN
            insert  into #ResultSet
                    (
                     AuthorizationDocumentId,
                     ClientName,
                     Staffname,
                     DocumentCodeId,
                     DocumentName,
                     StaffId,
                     ClientId,
                     DocumentId,
--AuthClientId,           --Modified on dated : 21-06-2010
                     Total,
                     Pended,
                     Approved,
                     Denied,
                     Requested,
                     ConsumerAppealed,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page
                     ClinicianAppealed,
                     PartialDenied,
                     DocumentScreenId,
                     OrganizationId
                    )
                    select  ad.AuthorizationDocumentId,
						CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END AS ClientName,
                            --(c.LastName + ', ' + c.FirstName) as ClientName,
                            (s.LastName + ', ' + s.FirstName) as Staffname,
                            (dc.DocumentCodeId) as DocumentCodeId,
                            (dc.DocumentName) as DocumentName,
                            (ad.StaffId) as StaffId,
                            (d.ClientId) as ClientId,
                            (d.DocumentId) as DocumentId,
       --max(c.ClientId) as AuthClientId,         --Modified on dated : 21-06-2010
                            sum(case a.Status
                                  when 4245 then 1
                                  else 0
                                end + case a.Status
                                        when 4243 then 1
                                        else 0
                                      end + case a.Status
                                              when 4244 then 1
                                              else 0
                                            end + case a.Status
                                                    when 6044 then 1
                                                    else 0
                                                  end + case a.Status
                                                          when 304 then 1
                                                          else 0
                                                        end + case a.Status
                                                              when 6045 then 1
                                                              else 0
                                                              end
                                + case a.Status
                                    when 4242 then 1
                                    else 0
                                  end) as Total,
                            sum(case a.Status
                                  when 4245 then 1
                                  else 0
                                end) as Pended,
                            sum(case a.Status
                                  when 4243 then 1
                                  else 0
                                end) as Approved,
                            sum(case a.Status
                                  when 4244 then 1
                                  else 0
                                end) as Denied,
                            sum(case a.Status
                                  when 4242 then 1
                                  else 0
                                end) as Requested,
                            sum(case a.Status
                                  when 6045 then 1
                                  else 0
                                end) as ConsumerAppealed,
                            sum(case a.Status
                                  when 6044 then 1
                                  else 0
                                end) as ClinicianAppealed,
                            sum(case a.Status
                                  when 304 then 1
                                  else 0
                                end) as PartialDenied,
                            sr.ScreenId,
                            @OrganizationId as OrganizationId
                    from    AuthorizationDocuments ad  
                    join    Authorizations a on a.AuthorizationDocumentId = ad.AuthorizationDocumentId
                    -- Added by Hemant on 15 Oct 2015 for Customization Bugs #222 
                     AND ISNULL(a.RecordDeleted, 'N') = 'N' AND ISNULL(ad.RecordDeleted, 'N') = 'N' 
                    
                    join    ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId
                                                       and isnull(ccp.RecordDeleted,
                                                              'N') = 'N'
                    left join Staff s on s.StaffId = ad.StaffId
                                         and isnull(s.RecordDeleted, 'N') = 'N'
                    left join Documents d on d.DocumentId = ad.DocumentId
                                             and isnull(d.RecordDeleted, 'N') = 'N'
                    left join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
                                                  and isnull(dc.RecordDeleted,'N') = 'N'
                    join    Clients c on c.ClientId = ccp.ClientId and isnull(c.RecordDeleted, 'N') = 'N' 
         --Added by Revathi on 06 March 2014 for task #77 Engineering Improvement Initiatives- NBL(I)
                  join StaffClients sc on sc.StaffId = @LoggedInStaffId and sc.ClientId = c.ClientId    
         --Added for Task #159 UM 2
         --join StaffClients sc on sc.StaffId = @LoggedInStaffId and sc.ClientId = c.ClientId
                    left join Providers p on p.ProviderId = a.ProviderId
                                             and isnull(p.RecordDeleted, 'N') = 'N'
                    left join Sites si on si.SiteId = a.SiteId
                                          and isnull(si.RecordDeleted, 'N') = 'N' 
                    join    CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                                                and isnull(cp.RecordDeleted,
                                                           'N') = 'N'
					-- 18 February 2014 T.Remisoski	Changed to match widget logic with Recodes
                    join    dbo.ssf_RecodeValuesCurrent('RECODECAPCOVERAGEPLANID') CAPCP on cp.CoveragePlanId = CAPCP.IntegerCodeId
                    inner join Screens sr on sr.DocumentCodeId = d.DocumentCodeId
                                             and isnull(sr.RecordDeleted, 'N') = 'N'
                    where cp.Capitated = 'Y' and  isnull(ad.RecordDeleted, 'N') = 'N'
                            and isnull(a.RecordDeleted, 'N') = 'N'
                            and (
                                 @AuthDocStatusFilter = 0
                                 or --- for All
                                 (
                                  @AuthDocStatusFilter = 238
                                  and (a.Status in (4242, 4245, 6044, 6045,305))
                                 )
                                 or -- or a.Modified = 'Y' or a.Appealed = 'Y'))or      on Open Request
                                 (
                                  @AuthDocStatusFilter = 239
                                  and a.Status = 4242
                                 )
                                 or (
                                     @AuthDocStatusFilter = 240
                                     and a.Status = 4245
                                    )
                                 or (
                                     @AuthDocStatusFilter = 455
                                     and a.Status = 6044
                                    )
                                 or    -- Modified BY Rakesh Get Data Based on CLinician Appeal or consumer appeal status
                                 (
                                  @AuthDocStatusFilter = 456
                                  and a.Status = 6045
                                 )
                                 or (
                                     @AuthDocStatusFilter = 242
                                     and a.Status = 4244
                                    )
                                 or (
                                     @AuthDocStatusFilter = 243
                                     and a.Status = 4243
                                    )
                                 or (
                                     @AuthDocStatusFilter = 245
                                     and a.Status in (4243, 4244, 304)
                                    )
                                 or    -- On Closed Request Aproved and Denied
                                 (
                                  @AuthDocStatusFilter = 454
                                  and a.Status in (304)
                                 )
                                 or    -- 28 July 2014      Kirtee, for Partially Approved
                                 (
                                  @AuthDocStatusFilter = 457
                                  and a.Status in (305)
                                 )
                                )
                            and (
                                 @ProvidersFilter <> 0
                                 and (a.ProviderID = cast(@ProvidersFilter as varchar(10)))
                                 or isnull(@ProvidersFilter, 0) = 0
                                )
                            and (
                                 @SitesFilter <> 0
                                 and (a.SiteId = cast(@SitesFilter as varchar(10)))
                                 or isnull(@SitesFilter, 0) = 0
                                )
                            and (
                                 @StartDate <> ''
                                 and (a.DateRequested >= @StartDate)
                                 or isnull(@StartDate, '') = ''
                                )
                            and (
                                 @EndDate <> ''
                                 and (a.DateRequested < convert(varchar(10), dateadd(dd,
                                                              1, @EndDate), 101))
                                 or isnull(@EndDate, '') = ''
                                )
                            and (
                                 @AuthNumber <> ''
                                 and (a.AuthorizationNumber = @AuthNumber)
                                 or isnull(@AuthNumber, '') = ''
                                )
   --and ( @RequestorsFilter <> 0  and (s.Staffid = cast(@RequestorsFilter as varchar(10)))or isnull(@AuthNumber, 0) = 0)
                            and (
                                 @RequestorsFilter <> 0
                                 and (s.Staffid = cast(@RequestorsFilter as varchar(10)))
                                 or isnull(@RequestorsFilter, 0) = 0
                                )      --Modified By Mahesh_Sharma Dated : 05-June-2010 Purpose : filter is not workin for requesters

    --Sudhir Singh added Coverage Plan filter as per task Id 223
                            and (
                                 @CoveragePlanFilter <> 0
                                 and (cp.CoveragePlanId = isnull(@CoveragePlanFilter,
                                                              0))
                                 or isnull(@CoveragePlanFilter, 0) = 0
                                )
  --SudhirSingh added Requested Within Filter as per task Id 224
  --DJH - modified
                            and (
                                 isnull(@RequestedWithin, 0) = 0
                                 or (
                                     a.ReviewLevel = @FilterReviewLevel
                                     and a.StartDateRequested between @FilterRequestStartTime
                                                              and
                                                              @FilterRequestEndTime
                                    )
                                )
                            and (
                                 @ClientId <> 0
                                 and (c.ClientId = cast(@ClientId as varchar(10)))
                                 or isnull(@ClientId, 0) = 0
                                )
--Changes with ref to ticket 586
                            and (
                                 @ProgramsFilter <> 0
                                 and (ad.Assigned = cast(@ProgramsFilter as varchar(10)))
                                 or (isnull(@ProgramsFilter, 0) = 0)
                                )
   -- Changes with Ref DHR(2)5 add new filter organisationID (Add another dropdown on Authorization Document List Page)
 --  and ( @OrganizationsFilter <> 0  and (@OrganisationID = cast(@OrganizationsFilter as varchar(10)))or (isnull(@OrganizationsFilter, 0) = 0))
                            and (
                                 @AuthDocId <> 0
                                 and (a.AuthorizationDocumentId = isnull(@AuthDocId,
                                                              0))
                                 or isnull(@AuthDocId, 0) = 0
                                )
                    group by ad.AuthorizationDocumentId,
                            ScreenId,
                            C.ClientType
                            ,C.OrganizationName
                            ,C.LastName 
                            ,C.FirstName,
                            ad.AuthorizationDocumentId,
                            (c.LastName + ', ' + c.FirstName),
                            (s.LastName + ', ' + s.FirstName),
                            (dc.DocumentCodeId),
                            (dc.DocumentName),
                            (ad.StaffId),
                            (d.ClientId),
                            (d.DocumentId)


END

        select  AuthorizationDocumentId,
                ClientName,
                Staffname,
                Requested,
                Pended,
                ConsumerAppealed,
                ClinicianAppealed,
                Approved,
                Denied,
                PartialDenied,
                Total,
                StaffId,
                ClientId,
                @OrganizationId as OrganizationId
        from    #ResultSet     --Modified on dated : 21-06-2010
        order by AuthorizationDocumentId desc
    end try
    begin catch

        declare @Error varchar(8000)
        set @Error = convert(varchar, error_number()) + '*****'
            + convert(varchar(4000), error_message()) + '*****'
            + isnull(convert(varchar, error_procedure()),
                     'ssp_ListPageSCAuthorizationDocument') + '*****'
            + convert(varchar, error_line()) + '*****'
            + convert(varchar, error_severity()) + '*****'
            + convert(varchar, error_state())
        raiserror
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );
    end catch
end
