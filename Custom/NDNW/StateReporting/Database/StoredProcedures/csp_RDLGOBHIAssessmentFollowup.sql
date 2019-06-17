if exists ( select	*
			from	sys.objects
			where	object_id = object_id(N'[dbo].[csp_RDLGOBHIAssessmentFollowup]')
					and type in ( N'P', N'PC' ) )
   drop procedure [dbo].[csp_RDLGOBHIAssessmentFollowup];
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create procedure [dbo].[csp_RDLGOBHIAssessmentFollowup]
	   @ExecutedByStaffId int
	 , @StartDate datetime
	 , @EndDate datetime
as /*********************************************************************                                                                                          
	File Procedure:		dbo.csp_RDLGOBHIAssessmentFollowup.sql
	Creation Date:		04/24/2017
	Created By:			mlightner
	Purpose:			Dataset for Assessment Followup
	Customer:			New Directions Northwest

	Input Parameters:	Date Range (start, end)
	Output Parameters:	
	Return:				
	
	Called By:			
	Calls:				exec csp_RDLGOBHIAssessmentFollowup 764, '1/1/2017', '3/31/2017'
 
	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	04/24/2017	mlightner		Created
*********************************************************************/

	   
	   declare @ServiceExcludeCatCodeId int;	-- /* GlobalCode for ProcedureCode Service Exclusion */
	   declare @AssessmentPCCatCodeId int;		-- /* GlobalCode for ProcedureCode Assessment */
	   declare @ServiceStatusShow int;
	   declare @ServiceStatusComplete int;

	   select	@ServiceExcludeCatCodeId = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and Category = 'PROCEDURECATEGORY2'
				and CodeName = 'Exclude From First Service And Follow Up';

	   select	@AssessmentPCCatCodeId = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and Category = 'PROCEDURECATEGORY3'
				and CodeName = 'Assessment';
	   
	   select	@ServiceStatusComplete = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and gc.Category = 'SERVICESTATUS'
				and CodeName = 'Complete';

	   select	@ServiceStatusShow = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and gc.Category = 'SERVICESTATUS'
				and CodeName = 'Show';

	   /* Get Admissions data */
	   if object_id('tempdb..#Admissions') is not null
		  drop table [#Admissions];
	   create table #Admissions
			  (	ClientId int
			  , EpisodeStartDate datetime
			  , EpisodeEndDate datetime
			  , InitialRequestDate datetime
			  , SortOrder int );

	   with	cteEpisodes
			  as ( select	row_number() over ( partition by ce.ClientId order by ce.EpisodeNumber ) as SortOrder
						  , ce.ClientId
						  , ce.RegistrationDate [EpisodeStartDate]
						  , isnull(ce.DischargeDate, '12/31/9999') [EpisodeEndDate]
				   from		dbo.ClientEpisodes ce
				   where	isnull(ce.RecordDeleted, 'N') = 'N'
							and datediff(day, ce.RegistrationDate, @EndDate) >= 0
							and datediff(day, @StartDate, isnull(ce.DischargeDate, '12/31/9999')) >= 0
				 )
			insert	into #Admissions
					( ClientId
					, EpisodeStartDate
					, EpisodeEndDate
					, InitialRequestDate
					, SortOrder )
			select	cp.ClientId
				  , e.EpisodeStartDate
				  , e.EpisodeEndDate
				  , coalesce(cp.RequestedDate, cp.EnrolledDate) [InitialRequestDate]
				  , e.SortOrder
			from	dbo.ClientPrograms cp
			join	cteEpisodes e
					on cp.ClientId = e.ClientId
					   and e.SortOrder = 1
			where	isnull(cp.RecordDeleted, 'N') = 'N'
					and datediff(day, coalesce(cp.RequestedDate, cp.EnrolledDate), e.EpisodeEndDate) >= 0
					and datediff(day, e.EpisodeStartDate, coalesce(cp.RequestedDate, cp.EnrolledDate)) >= 0
			order by cp.ClientId
				  , coalesce(cp.RequestedDate, cp.EnrolledDate);

	   /* Get Assessment ProcedureCode(s) */
	   if object_id('tempdb..#Assessments') is not null
		  drop table [#Assessments];
	   create table #Assessments
			  (	ProcedureCodeId int
			  , DisplayAs varchar(20) );
	   
	   insert	into #Assessments
				( ProcedureCodeId
				, DisplayAs )
	   select	pc.ProcedureCodeId
			  , pc.DisplayAs
	   from		dbo.ProcedureCodes pc
	   where	isnull(pc.RecordDeleted, 'N') = 'N'
				and pc.Category3 = @AssessmentPCCatCodeId;


	   /* Create output temp table to allow for gathering information from multiple data sources */
	   if object_id('tempdb..#Output') is not null
		  drop table [#Output];
	   create table #Output
			  (	ClientId int
			  , ClientName varchar(100)
			  , InitialRequestDate datetime
			  , AssessmentDate datetime
			  , AssessmentServiceId int
			  , ServiceDate datetime
			  , FollowupServiceId int
			  , FollowupDays int	-- (ServiceDate - AssessmentDate)
				);

	   /* Get Initial Request Date and Assessment Date from Assessment source */
	   insert	into #Output
				( ClientId
				, ClientName
				, InitialRequestDate
				, AssessmentDate
				, AssessmentServiceId
				, ServiceDate
				, FollowupServiceId
				, FollowupDays )
	   select	s.ClientId
			  , case when c.ClientId is null then 'Not Available'
					 when sc.ClientId is null then 'No Access to Client Information'
					 else isnull(c.FirstName, '') + case when c.FirstName is null then ''
														 else ' '
													end + isnull(c.LastName, '')
				end [ClientName]
			  , ( select top 1
							adm.InitialRequestDate
				  from		#Admissions adm
				  where		adm.ClientId = s.ClientId
				  order by	adm.InitialRequestDate asc
				) [InitialRequestDate]
			  , s.DateOfService [AssessmentDate]
			  , s.ServiceId [AssessmentServiceId]
			  , null [ServiceDate]
			  , null [FollowupServiceId]
			  , 9999 [FollowupDays]
	   from		dbo.Services s
	   join		dbo.Clients c
				on s.ClientId = c.ClientId
				   and isnull(c.RecordDeleted, 'N') = 'N'
	   join		#Assessments a
				on s.ProcedureCodeId = a.ProcedureCodeId
	   left join dbo.StaffClients sc
				on sc.ClientId = c.ClientId
				   and sc.StaffId = @ExecutedByStaffId
	   where	isnull(s.RecordDeleted, 'N') = 'N'
				and s.Status in ( @ServiceStatusShow, @ServiceStatusComplete )
				and datediff(day, s.DateOfService, @EndDate) >= 0
				and datediff(day, @StartDate, s.DateOfService) >= 0
				and s.ServiceId = ( select top 1
											s2.ServiceId
									from	dbo.Services s2
									join	#Assessments a2
											on s2.ProcedureCodeId = a2.ProcedureCodeId
									join	#Admissions adm2
											on s.ClientId = adm2.ClientId
									where	isnull(s2.RecordDeleted, 'N') = 'N'
											and s2.ClientId = s.ClientId
											and s2.Status in ( @ServiceStatusShow, @ServiceStatusComplete )
											and datediff(day, s2.DateOfService, @EndDate) >= 0
											and datediff(day, @StartDate, s2.DateOfService) >= 0
											and datediff(day, adm2.InitialRequestDate, s2.DateOfService) >= 0
									order by s2.DateOfService asc
								  );


	   /* Get Date Of First Service from Services source */	
	   update	o
	   set		o.ServiceDate = case when o.AssessmentDate is null then null
									 else s.DateOfService
								end
			  , o.FollowupServiceId = s.ServiceId
			  , o.FollowupDays = case when o.AssessmentDate is null then null
									  else datediff(day, o.AssessmentDate, s.DateOfService)
								 end
	   from		#Output o
	   join		dbo.Services s
				on o.ClientId = s.ClientId
				   and isnull(s.RecordDeleted, 'N') = 'N'
	   left join #Assessments a
				on s.ProcedureCodeId = a.ProcedureCodeId
	   where	a.ProcedureCodeId is null
				and s.ServiceId in ( select top 1
											s2.ServiceId
									 from	dbo.Services s2
									 where	s2.ClientId = o.ClientId
											and isnull(s2.RecordDeleted, 'N') = 'N'
											and s2.Status in ( @ServiceStatusShow, @ServiceStatusComplete )
											and datediff(minute, o.AssessmentDate, s2.DateOfService) > 0
											and s2.ProcedureCodeId not in ( select	pc3.ProcedureCodeId
																			from	dbo.ProcedureCodes pc3
																			where	isnull(pc3.RecordDeleted, 'N') = 'N'
																					and pc3.Category2 = @ServiceExcludeCatCodeId )
									 order by s2.DateOfService ); 
								 

	   /* Report Output */
	   select	o.ClientId
			  , o.ClientName
			  , o.InitialRequestDate
			  , o.AssessmentDate
			  , o.AssessmentServiceId
			  , o.ServiceDate
			  , o.FollowupServiceId
			  , o.FollowupDays
	   from		#Output o
	   order by	o.ClientName
			  , ClientId;


go
