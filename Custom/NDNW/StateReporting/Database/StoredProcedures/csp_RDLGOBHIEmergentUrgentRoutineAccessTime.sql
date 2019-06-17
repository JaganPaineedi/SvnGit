if exists ( select	*
			from	sys.objects
			where	object_id = object_id(N'[dbo].[csp_RDLGOBHIEmergentUrgentRoutineAccessTime]')
					and type in ( N'P', N'PC' ) )
   drop procedure [dbo].[csp_RDLGOBHIEmergentUrgentRoutineAccessTime];
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create procedure [dbo].[csp_RDLGOBHIEmergentUrgentRoutineAccessTime]
	   @ExecutedByStaffId int
	 , @StartDate datetime
	 , @EndDate datetime
	 , @AgeGroup varchar(5) = null
	 , @ServiceLevel varchar(max) = null
	 , @StaffId int = null
as /*********************************************************************                                                                                          
	File Procedure:		dbo.csp_RDLGOBHIEmergentUrgentRoutineAccessTime.sql
	Creation Date:		04/01/2017
	Created By:			mlightner
	Purpose:			Dataset for Emergent, Urgent, and Routine Access Times
	Customer:			New Directions Northwest

	Input Parameters:	Date Range (start, end), AgeGroup (adult, child), Staff
	Output Parameters:	
	Return:				
	
	Called By:			
	Calls:				exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '7/31/2017', null, null, null
						exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '1/31/2017', 'Adult', null, null
						exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '1/31/2017', 'Child', null, null
						exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '1/31/2017', null, 'Emergent', null
						exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '1/31/2017', 'Adult', 'Emergent', null
						exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '1/31/2017', 'Child', 'Emergent', null
						exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '1/31/2017', null, null, 674
						exec csp_RDLGOBHIEmergentUrgentRoutineAccessTime 764, '1/1/2017', '1/31/2017', 'Adult', 'Emergent', 719

	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	04/01/2017	mlightner		Created
	05/16/2017	mlightner		Modified based on customer feedback:
								* Emergent Programs source from Crisis documents (for activity and dates)
								* Urgent is okay (still need Custom Tab)
								* "Initial" for Routine programs based on Episode
								* "Initial" for Emergent and Urgent programs will be based on Program Enrollment.
	08/07/2017	mlightner		Modified based on customer feedback:
								* "Initial" for Routine programs based on Program Enrollment.
								
*********************************************************************/
	   set nocount on;
/********************************************************************
						GENERAL HOUSEKEEPING
********************************************************************/

	   declare @EmergentLimit int = 6;	-- 6 hours
	   declare @UrgentLimit int = 24;	-- 24 hours
	   declare @RoutineLimit int = 10;	-- 10 Business Days

	   declare @EmergentPeriod varchar(max) = 'hrs';
	   declare @UrgentPeriod varchar(max) = 'hrs';
	   declare @RoutinePeriod varchar(max) = 'days';

		-- GlobalCode for ProcedureCode Service Exclusion
	   declare @ServiceExcludeCatCodeId int;	
	   select	@ServiceExcludeCatCodeId = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and Category = 'PROCEDURECATEGORY2'
				and CodeName = 'Exclude From First Service And Follow Up';

		-- GlobalCode for Service Status Complete 
	   declare @ServiceStatusComplete int;
	   select	@ServiceStatusComplete = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and gc.Category = 'SERVICESTATUS'
				and CodeName = 'Complete';

		-- GlobalCode for Service Status Show 
	   declare @ServiceStatusShow int;
	   select	@ServiceStatusShow = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and gc.Category = 'SERVICESTATUS'
				and CodeName = 'Show';

		-- GlobalCode for Document Status Signed 
	   declare @DocumentStatusSigned int;
	   select	@DocumentStatusSigned = gc.GlobalCodeId
	   from		dbo.GlobalCodes gc
	   where	isnull(gc.RecordDeleted, 'N') = 'N'
				and gc.Category = 'DOCUMENTSTATUS'
				and CodeName = 'Signed'; 

		-- DocumentCode for Crisis Service Note
	   declare @DocumentCodeId int;
	   select	@DocumentCodeId = dc.DocumentCodeId	--select *
	   from		dbo.DocumentCodes dc
	   where	isnull(dc.RecordDeleted, 'N') = 'N'
				and dc.DocumentType = 10
				and isnull(dc.ServiceNote, 'N') = 'Y'
				and dc.DocumentName like '%crisis%';

	   /* Get Crisis Walk-In and Crisis Mobile procedure codes */
	   if object_id('tempdb..#CrisisProcs') is not null
		  drop table [#CrisisProcs];
	   create table #CrisisProcs
			  (	ProcedureCodeId int
			  , DisplayAs varchar(max)
			  , ProcedureCodeName varchar(max) );

	   insert	into #CrisisProcs
				( ProcedureCodeId
				, DisplayAs
				, ProcedureCodeName )
	   select	pc.ProcedureCodeId
			  , pc.DisplayAs
			  , pc.ProcedureCodeName
	   from		dbo.ProcedureCodes pc
	   where	isnull(pc.RecordDeleted, 'N') = 'N'
				and pc.DisplayAs like '%crisis%mobile%'
				or pc.DisplayAs like '%crisis%walk%in%';

	   /* Create table for list of Program in Service Level selected */
	   if object_id('tempdb..#ServiceLevelPrograms') is not null
		  drop table [#ServiceLevelPrograms];
	   create table #ServiceLevelPrograms
			  (	ServiceLevel varchar(max)
			  , ProgramId int );

	   -- Get Emergent level programs
	   if ( @ServiceLevel = 'Emergent'
			or @ServiceLevel is null )
		  begin
				insert	into #ServiceLevelPrograms
						( ServiceLevel
						, ProgramId )
				select	'Emergent'
					  , ep.IntegerCodeId
				from	dbo.ssf_RecodeValuesAsOfDate('GOBHIEmergentPrograms', @StartDate) ep
				join	dbo.Programs p
						on ep.IntegerCodeId = p.ProgramId
						   and isnull(p.RecordDeleted, 'N') = 'N';
		  end; 

	   -- Get Urgent level programs
	   if ( @ServiceLevel = 'Urgent'
			or @ServiceLevel is null )
		  begin
				insert	into #ServiceLevelPrograms
						( ServiceLevel
						, ProgramId )
				select	'Urgent'
					  , up.IntegerCodeId
				from	dbo.ssf_RecodeValuesAsOfDate('GOBHIUrgentPrograms', @StartDate) up
				join	dbo.Programs p
						on up.IntegerCodeId = p.ProgramId
						   and isnull(p.RecordDeleted, 'N') = 'N';
		  end;

	   -- Get Routine level programs
	   if ( @ServiceLevel = 'Routine'
			or @ServiceLevel is null )
		  begin
				insert	into #ServiceLevelPrograms
						( ServiceLevel
						, ProgramId )
				select	'Routine'
					  , p.ProgramId
				from	dbo.Programs p
				left join dbo.ssf_RecodeValuesAsOfDate('GOBHIEmergentPrograms', @StartDate) ep
						on p.ProgramId = ep.IntegerCodeId
				left join dbo.ssf_RecodeValuesAsOfDate('GOBHIUrgentPrograms', @StartDate) up
						on p.ProgramId = up.IntegerCodeId
				where	isnull(p.RecordDeleted, 'N') = 'N'
						and ep.IntegerCodeId is null
						and up.IntegerCodeId is null
				order by p.ProgramId;
		  end;

	   /* Output Temp table */
	   if object_id('tempdb..#Output') is not null
		  drop table [#Output];
	   create table #Output
			  (	ClientId int null
			  , ClientName varchar(100) null
			  , Age int null
			  , AgeGroup varchar(5) null
			  , RequestedDate datetime null
			  , AppointmentDate datetime null
			  , AppointmentOfferedDate datetime null
			  , ServiceLevel varchar(max) null
			  , OfferedWithinLimit char(1) null
			  , ReceivedWithinLimit char(1) null
			  , Period varchar(max) null
			  , Staff varchar(100) null
			  , StaffId int null );
	   
/********************************************************************
GET CRISIS (EMERGENT) INFORMATION FROM CUSTOMACUTESERVICESPRESCREENS
********************************************************************/

	   if ( @ServiceLevel is null
			or @ServiceLevel = 'Emergent' )
		  begin

		  ;		-- Get Initial Emergent Services Based on Client Program Enrollment and CustomAcuteServicesPrescreens Dates
				with	cteInitEmergentRequest
						  as ( select	row_number() over ( partition by d.ClientId order by asp.InitialCallTime ) as SortOrder
									  , d.ClientId [ClientId]
									  , asp.InitialCallTime [RequestedDate]
									  , s.DateOfService [AppointmentOfferedDate]
									  , 'Emergent' [ServiceLevel]
									  , d.AuthorId [StaffId]
									  , s.ProgramId [ProgramId]
									  , s.ServiceId [ServiceId]
									  , cp.ClientProgramId [ClientProgramId]
							   from		dbo.CustomAcuteServicesPrescreens asp
							   join		dbo.DocumentVersions dv
										on asp.DocumentVersionId = dv.DocumentVersionId
										   and isnull(dv.RecordDeleted, 'N') = 'N'
							   join		dbo.Documents d
										on dv.DocumentVersionId = d.CurrentDocumentVersionId
										   and isnull(d.RecordDeleted, 'N') = 'N'
										   and d.DocumentCodeId = @DocumentCodeId
										   and datediff(day, d.EffectiveDate, @EndDate) >= 0
										   and datediff(day, @StartDate, d.EffectiveDate) >= 0
										   and d.Status = @DocumentStatusSigned
							   join		dbo.Services s
										on d.ServiceId = s.ServiceId
										   and isnull(s.RecordDeleted, 'N') = 'N'
							   join		dbo.ClientPrograms cp
										on d.ClientId = cp.ClientId
										   and s.ProgramId = cp.ProgramId
										   and isnull(cp.RecordDeleted, 'N') = 'N'
										   and datediff(day, d.EffectiveDate, isnull(cp.DischargedDate, '12/31/9999')) >= 0
										   and datediff(day, coalesce(cp.EnrolledDate, cp.RequestedDate), d.EffectiveDate) >= 0
							   join		#CrisisProcs crp
										on s.ProcedureCodeId = crp.ProcedureCodeId
							   left join dbo.Clients c
										on d.ClientId = c.ClientId
										   and isnull(c.RecordDeleted, 'N') = 'N'
							   where	isnull(asp.RecordDeleted, 'N') = 'N'
										and ( @AgeGroup is null
											  or ( @AgeGroup = 'Adult'
												   and dbo.GetAge(c.DOB, s.DateOfService) >= 18 )
											  or ( @AgeGroup = 'Child'
												   and dbo.GetAge(c.DOB, s.DateOfService) < 18 ) )
										and ( @StaffId is null
											  or ( d.AuthorId = @StaffId
												   and d.AuthorId is not null ) )
							 )
					 insert	into #Output
							( ClientId
							, RequestedDate
							, AppointmentDate
							, AppointmentOfferedDate
							, ServiceLevel
							, StaffId )
					 select	cte.ClientId
						  , cte.RequestedDate
						  , cte.AppointmentOfferedDate
						  , cte.AppointmentOfferedDate
						  , cte.ServiceLevel
						  , cte.StaffId
					 from	cteInitEmergentRequest cte
					 where	cte.SortOrder = 1;
		  end;

/********************************************************************
		GET URGENT AND ROUTINE INFORMATION FROM CLIENT PROGRAMS
********************************************************************/

	   if ( @ServiceLevel is null
			or @ServiceLevel in ( 'Urgent', 'Routine' ) )
		  begin

	   ;	/* Get Initial Urgent Service Based on Client Program Enrollment and CustomClientPrograms Dates */
				with	cteInitUrgentRequest
						  as ( select	row_number() over ( partition by cp.ClientId, slp.ServiceLevel order by ccp.AppointmentRequestedDate ) as SortOrder
									  , cp.ClientId [ClientId]
									  , ccp.AppointmentRequestedDate [RequestedDate]
									  , ccp.AppointmentFirstOfferedDate [AppointmentOfferedDate]
									  , slp.ServiceLevel [ServiceLevel]
									  , cp.AssignedStaffId
							   from		dbo.ClientPrograms cp
							   join		dbo.Clients c
										on cp.ClientId = c.ClientId
										   and isnull(c.RecordDeleted, 'N') = 'N'
							   join		#ServiceLevelPrograms slp
										on cp.ProgramId = slp.ProgramId
										   and slp.ServiceLevel in ( 'Urgent' )
							   left	join dbo.CustomClientPrograms ccp
										on cp.ClientProgramId = ccp.ClientProgramId
										   and isnull(ccp.RecordDeleted, 'N') = 'N'
							   where	isnull(cp.RecordDeleted, 'N') = 'N'
										and datediff(day, @StartDate, ccp.AppointmentRequestedDate) >= 0
										and datediff(day, ccp.AppointmentRequestedDate, @EndDate) >= 0
							 )
					 insert	into #Output
							( ClientId
							, RequestedDate
							, AppointmentOfferedDate
							, ServiceLevel
							, StaffId )
					 select	cte.ClientId
						  , cte.RequestedDate
						  , cte.AppointmentOfferedDate
						  , cte.ServiceLevel
						  , cte.AssignedStaffId
					 from	cteInitUrgentRequest cte
					 where	cte.SortOrder = 1;

	   ;	/* Get Initial Routine Service Based on Client Episode Registration and CustomClientPrograms Dates */
				with	cteInitRoutineRequest
						  as ( select	row_number() over ( partition by cp.ClientId, slp.ServiceLevel order by ccp.AppointmentRequestedDate ) as SortOrder
									  , cp.ClientId [ClientId]
									  , ccp.AppointmentRequestedDate [RequestedDate]
									  , ccp.AppointmentFirstOfferedDate [AppointmentOfferedDate]
									  , slp.ServiceLevel [ServiceLevel]
									  , cp.AssignedStaffId
							   from		dbo.ClientPrograms cp
							   join		dbo.Clients c
										on cp.ClientId = c.ClientId
										   and isnull(c.RecordDeleted, 'N') = 'N'
							   join		#ServiceLevelPrograms slp
										on cp.ProgramId = slp.ProgramId
										   and slp.ServiceLevel in ( 'Routine' )
							   left	join dbo.CustomClientPrograms ccp
										on cp.ClientProgramId = ccp.ClientProgramId
										   and isnull(ccp.RecordDeleted, 'N') = 'N'
							   where	isnull(cp.RecordDeleted, 'N') = 'N'
										and datediff(day, @StartDate, ccp.AppointmentRequestedDate) >= 0
										and datediff(day, ccp.AppointmentRequestedDate, @EndDate) >= 0
							 )
					 insert	into #Output
							( ClientId
							, RequestedDate
							, AppointmentOfferedDate
							, ServiceLevel
							, StaffId )
					 select	cte.ClientId
						  , cte.RequestedDate
						  , cte.AppointmentOfferedDate
						  , cte.ServiceLevel
						  , cte.AssignedStaffId
					 from	cteInitRoutineRequest cte
					 where	cte.SortOrder = 1;
		
			/* Get Initial Service for Urgent and Routine */
				with	cteFirstService
						  as ( select	row_number() over ( partition by s2.ClientId, slp2.ServiceLevel order by s2.dateOfService ) as SortOrder
									  , s2.ServiceId
									  , s2.ClientId
									  , slp2.ServiceLevel
									  , s2.DateOfService
							   from		#Output o2
							   join		dbo.Services s2
										on o2.ClientId = s2.ClientId
										   and isnull(s2.RecordDeleted, 'N') = 'N'
										   and s2.Status in ( @ServiceStatusShow, @ServiceStatusComplete )
							   join		#ServiceLevelPrograms slp2
										on s2.ProgramId = slp2.ProgramId
										   and slp2.ServiceLevel in ( 'Urgent', 'Routine' )
										   and o2.ServiceLevel = slp2.ServiceLevel
							   where	datediff(minute, o2.RequestedDate, s2.DateOfService) >= 0
										and s2.ProcedureCodeId not in ( select	pc3.ProcedureCodeId
																		from	dbo.ProcedureCodes pc3
																		where	isnull(pc3.RecordDeleted, 'N') = 'N'
																				and pc3.Category2 = @ServiceExcludeCatCodeId )
							 )
					 update	o
					 set	o.AppointmentDate = cte.DateOfService
						  , o.AppointmentOfferedDate = case	when o.AppointmentOfferedDate is null then cte.DateOfService
															when datediff(minute, cte.DateOfService, isnull(o.AppointmentOfferedDate, '1/1/1899')) >= 0
															then cte.DateOfService
															else o.AppointmentOfferedDate
													   end
						  , o.StaffId = case when o.StaffId is null then s.ClinicianId
											 else o.StaffId
										end
					 from	#Output o
					 join	dbo.Services s
							on o.ClientId = s.ClientId
							   and isnull(s.RecordDeleted, 'N') = 'N'
					 join	cteFirstService cte
							on s.ServiceId = cte.ServiceId
							   and o.ServiceLevel = cte.ServiceLevel
							   and cte.SortOrder = 1;
		  end;

/********************************************************************
		ADD CLIENT AND STAFF INFORMATION
		ADD INDICATORS FOR SERVICES OFFERED AND SERVICES RECEIVED 
********************************************************************/

	   update	o
	   set		o.ClientName = case	when c.ClientId is null then 'Not Available'
									when sc.ClientId is null then 'No Access to Client Information'
									else isnull(c.FirstName, '') + case	when c.FirstName is null then ''
																		else ' '
																   end + isnull(c.LastName, '')
							   end
			  , o.Age = dbo.GetAge(c.DOB, o.RequestedDate)
			  , o.AgeGroup = case when c.DOB is null then 'N/A'
								  when dbo.GetAge(c.DOB, o.RequestedDate) >= 18 then 'Adult'
								  else 'Child'
							 end
			  , o.OfferedWithinLimit = case	when o.ServiceLevel = 'Emergent'
											then case when datediff(minute, o.RequestedDate, o.AppointmentOfferedDate) <= @EmergentLimit * 60 then 'Y'
													  else 'N'
												 end
											when o.ServiceLevel = 'Urgent'
											then case when datediff(minute, o.RequestedDate, o.AppointmentOfferedDate) <= @UrgentLimit * 60 then 'Y'
													  else 'N'
												 end
											when o.ServiceLevel = 'Routine'
											then case when datediff(day, o.RequestedDate, o.AppointmentOfferedDate) <= @RoutineLimit then 'Y'
													  else 'N'
												 end
									   end
			  , o.ReceivedWithinLimit = case when o.ServiceLevel = 'Emergent'
											 then case when datediff(minute, o.RequestedDate, o.AppointmentDate) <= @EmergentLimit * 60 then 'Y'
													   else 'N'
												  end
											 when o.ServiceLevel = 'Urgent'
											 then case when datediff(minute, o.RequestedDate, o.AppointmentDate) <= @UrgentLimit * 60 then 'Y'
													   else 'N'
												  end
											 when o.ServiceLevel = 'Routine'
											 then case when datediff(day, o.RequestedDate, o.AppointmentDate) <= @RoutineLimit then 'Y'
													   else 'N'
												  end
										end
			  , o.Period = case	when o.ServiceLevel = 'Emergent' then cast(@EmergentLimit as varchar) + ' ' + @EmergentPeriod
								when o.ServiceLevel = 'Urgent' then cast(@UrgentLimit as varchar) + ' ' + @UrgentPeriod
								when o.ServiceLevel = 'Routine' then cast(@RoutineLimit as varchar) + ' ' + @RoutinePeriod
						   end
			  , o.Staff = case when st.StaffId is null then 'Not Available'
							   else isnull(st.FirstName, '') + case	when st.FirstName is null then ''
																	else ' '
															   end + isnull(st.LastName, '')
						  end
	   from		#Output o
	   join		dbo.Clients c
				on o.ClientId = c.ClientId
				   and isnull(c.RecordDeleted, 'N') = 'N'
	   join		#ServiceLevelPrograms slp
				on o.ServiceLevel = slp.ServiceLevel
	   left join dbo.Staff st
				on o.StaffId = st.StaffId
				   and isnull(st.RecordDeleted, 'N') = 'N'
	   left join dbo.StaffClients sc
				on o.ClientId = sc.ClientId
				   and sc.StaffId = @ExecutedByStaffId;

/********************************************************************
		Create Report Output File
********************************************************************/

	   select	o.ClientName
			  , o.ClientId
			  , o.Age
			  , o.AgeGroup
			  , o.RequestedDate
			  , o.AppointmentDate
			  , o.AppointmentOfferedDate
			  , o.ServiceLevel
			  , o.OfferedWithinLimit
			  , o.ReceivedWithinLimit
			  , o.Period
			  , o.Staff
			  , o.StaffId
	   from		#Output o
	   where	( @AgeGroup is null
				  or ( @AgeGroup = 'Adult'
					   and o.AgeGroup = 'Adult' )
				  or ( @AgeGroup = 'Child'
					   and o.AgeGroup = 'Child' ) )
				and ( @StaffId is null
					  or ( o.StaffId = @StaffId
						   and o.StaffId is not null ) )
	   order by	o.AgeGroup desc	-- AgeGroup
			  , case when o.ServiceLevel = 'Emergent' then 1
					 when o.ServiceLevel = 'Urgent' then 2
					 when o.ServiceLevel = 'Routine' then 3
					 else 4
				end		-- ServiceLevel
			  , o.RequestedDate		-- RequestDate
			  , o.ClientId;		-- ClientId

go
