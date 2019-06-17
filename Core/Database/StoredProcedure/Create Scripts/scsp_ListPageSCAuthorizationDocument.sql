/****** Object:  StoredProcedure [dbo].[scsp_ListPageSCAuthorizationDocument]    Script Date: 02/18/2014 15:40:34 ******/
if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[scsp_ListPageSCAuthorizationDocument]')
                    and type in (N'P', N'PC') ) 
    drop procedure [dbo].[scsp_ListPageSCAuthorizationDocument]
GO

/****** Object:  StoredProcedure [dbo].[scsp_ListPageSCAuthorizationDocument]    Script Date: 02/18/2014 15:40:34 ******/
set ANSI_NULLS on
GO

set QUOTED_IDENTIFIER on
GO


create procedure [dbo].[scsp_ListPageSCAuthorizationDocument]
    (
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
     @StaffId int,
     @OrganizationId int,
     @LoggedInStaffId int,
     @CoveragePlanFilter int,
     @RequestedWithin int,
     @AuthDocId int
    )
/********************************************************************************
-- Stored Procedure: dbo.scsp_ListPageSCAuthorizationDocument
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: used by Authorization Document list page to apply custom filters
-- Called by: ssp_ListPageSCAuthorizationDocument
--
-- Updates:
-- Date			Author			Purpose
-- 18.2.2013	T.Remisoski	For Ionia, if the custom proc is called, reset a couple 
							of filter values and run the same logic as CORE
--06-Feb-2015 Merging from 3.5 X to 4.0X for Task #418 CM to SC Issues. 4.0 : CM : Error on loading "Auth Document" list page
--15 Oct  2015      Hemant        what: Added join with StaffClients table to display associated Clients for Login staff wrf Task#222 Customization Bugs 	
--05 Oct 2017		Neelima		   What: Added these 3 parametes since its not getting filtered based on these 3 parameters selection @CoveragePlanFilter
								   @RequestedWithin,@AuthDocId 	Core Bugs #338						
*********************************************************************************/
as 
begin

    begin try

        create table #ResultSet2
            (
             RowNumber int,
             PageNumber int,
             AuthorizationDocumentId int,
             ClientName varchar(100),  --Modified on Dated : 21-06-2010
             Staffname varchar(100),   --Modified on Dated : 21-06-2010
             DocumentCodeId int,
             DocumentName varchar(100),
             StaffId int,
             ClientId int,
             DocumentId int,
             Total int,        --Modified on dated : 21-06-2010
             Pended char(1),
             Approved int,     --Modified on dated : 21-06-2010
             Denied int,         --Modified on dated : 21-06-2010
             Requested int,     --Modified on dated : 21-06-2010
             ConsumerAppealed int,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page
             ClinicianAppealed int,
             PartialDenied int,
             RequesterComment varchar(max),
             DocumentScreenId int,
             OrganizationId int
            )

        --declare @RequestedWithin int = 0
        --declare @CoveragePlanFilter int = 0
        --declare @AuthDocId int = 0

        declare @CustomFilters table
            (
             AuthorizationDocumentId int
            )
        declare @DocumentCodeFilters table (DocumentCodeId int)
        declare @ApplyFilterClicked char(1)
        declare @CustomFiltersApplied char(1)
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


        set @ApplyFilterClicked = 'N'
        set @CustomFiltersApplied = 'N'

        if @AuthDocStatusFilter > 10000
            or @OtherFilter > 10000 
            begin
                set @AuthDocStatusFilter = 238	-- open requests
                set @OtherFilter = 0			-- don't care about population
            end

        if @CustomFiltersApplied = 'N' 
            insert  into #ResultSet2
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
                            (c.LastName + ', ' + c.FirstName) as ClientName,
                            (s.LastName + ', ' + s.FirstName) as Staffname,
                            (dc.DocumentCodeId) as DocumentCodeId,
                            (dc.DocumentName) as DocumentName,
                            (ad.StaffId) as StaffId,
                            (d.ClientId) as ClientId,
                            (d.DocumentId) as DocumentId,
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
                    AND ISNULL(a.RecordDeleted, 'N') = 'N' AND ISNULL(ad.RecordDeleted, 'N') = 'N' 
                    join    ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId
                                                       and isnull(ccp.RecordDeleted,
                                                              'N') = 'N'
                    left join Staff s on s.StaffId = ad.StaffId
                                         and isnull(s.RecordDeleted, 'N') = 'N'
                    left join Documents d on d.DocumentId = ad.DocumentId
                                             and isnull(d.RecordDeleted, 'N') = 'N'
                    left join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
                                                  and isnull(dc.RecordDeleted,
                                                             'N') = 'N'
                    join    Clients c on c.ClientId = ccp.ClientId
                                         and isnull(c.RecordDeleted, 'N') = 'N'
                    left join Providers p on p.ProviderId = a.ProviderId
                                             and isnull(p.RecordDeleted, 'N') = 'N'
                    left join Sites si on si.SiteId = a.SiteId
                                          and isnull(si.RecordDeleted, 'N') = 'N'
                    join    CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                                                and isnull(cp.RecordDeleted,
                                                           'N') = 'N'
                    join    dbo.ssf_RecodeValuesCurrent('RECODECAPCOVERAGEPLANID') CAPCP on cp.CoveragePlanId = CAPCP.IntegerCodeId
                    inner join Screens sr on sr.DocumentCodeId = d.DocumentCodeId
                                             and isnull(sr.RecordDeleted, 'N') = 'N'
                     --15 Oct  2015      Hemant                         
                    join StaffClients sc on sc.StaffId = @LoggedInStaffId and sc.ClientId = c.ClientId 
                    where cp.Capitated = 'Y' and  isnull(ad.RecordDeleted, 'N') = 'N'
                            and isnull(a.RecordDeleted, 'N') = 'N'
                            and (
                                 @AuthDocStatusFilter = 0
                                 or --- for All
                                 (
                                  @AuthDocStatusFilter = 238
                                  and (a.Status in (4242, 4245, 6044, 6045))
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
                            ad.AuthorizationDocumentId,
                            (c.LastName + ', ' + c.FirstName),
                            (s.LastName + ', ' + s.FirstName),
                            (dc.DocumentCodeId),
                            (dc.DocumentName),
                            (ad.StaffId),
                            (d.ClientId),
                            (d.DocumentId)

        select  AuthorizationDocumentId,
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
                @OrganizationId as OrganizationId
        from    #ResultSet2     --Modified on dated : 21-06-2010

    end try
    begin catch

        declare @Error varchar(8000)
        set @Error = convert(varchar, error_number()) + '*****'
            + convert(varchar(4000), error_message()) + '*****'
            + isnull(convert(varchar, error_procedure()),
                     'scsp_ListPageSCAuthorizationDocument') + '*****'
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
GO


