if exists ( select	*
			from	sys.objects
			where	object_id = object_id(N'[dbo].[csp_RDLGOBHIPsychiatricAccessTime]')
					and type in ( N'P', N'PC' ) )
   drop procedure [dbo].[csp_RDLGOBHIPsychiatricAccessTime];
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create procedure [dbo].[csp_RDLGOBHIPsychiatricAccessTime]
	   @ExecutedByStaffId int
	 , @StartDate datetime
	 , @EndDate datetime
	 , @AgeGroup varchar(5) = null
	 , @StaffId int = null
as /*********************************************************************                                                                                          
	File Procedure:		dbo.csp_RDLGOBHIPsychiatricAccessTime.sql
	Creation Date:		04/11/2017
	Created By:			mlightner
	Purpose:			Dataset for Psychiatric Access Time
	Customer:			New Directions Northwest

	Input Parameters:	Date Range (start, end), AgeGroup (adult, child), Staff
	Output Parameters:	
	Return:				
	
	Called By:			
	Calls:				exec csp_RDLGOBHIPsychiatricAccessTime 764, '1/1/2014', '3/31/2017', null, null
 
	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	04/11/2017	mlightner		Created
*********************************************************************/

	   /* Get Psychiatric Programs */
	   if object_id('tempdb..#PsychAccess') is not null
		  drop table [#PsychAccess];
	   create table #PsychAccess
			  (	ProgramId int
			  , ProgramCode varchar(max)
			  , ProgramName varchar(max) );

	   insert	into #PsychAccess
				( ProgramId
				, ProgramCode
				, ProgramName )
	   select	p.ProgramId
			  , p.ProgramCode
			  , p.ProgramName
	   from		dbo.Programs p
	   where	isnull(p.RecordDeleted, 'N') = 'N'
				and p.ProgramCode like '%psych%'
				or p.ProgramName like '%psych%';		--select * from #PsychAccess pa

	   /* Get information from Psychiatric Programs */
	   select	case when c.ClientId is null then 'Not Available'
					 when sc.ClientId is null then 'No Access to Client Information'
					 else isnull(c.FirstName, '') + case when c.FirstName is null then ''
														 else ' '
													end + isnull(c.LastName, '')
				end [ClientName]
			  , isnull(cast(c.ClientId as varchar), 'N/A') [ClientId]
			  , dbo.GetAge(c.DOB, cp.RequestedDate) [Age]
			  , case when c.DOB is null then 'N/A'
					 when dbo.GetAge(c.DOB, cp.RequestedDate) >= 18 then 'Adult'
					 else 'Child'
				end [AgeGroup]
			  , cp.RequestedDate [RequestedDate]
			  , coalesce(cp.MustBeEnrolledByDate, cp.EnrolledDate) [AssessmentOfferedDate]
			  , datediff(day, cp.RequestedDate, coalesce(cp.MustBeEnrolledByDate, cp.EnrolledDate)) [AccessTime]
			  , case when st.StaffId is null then 'Not Available'
					 else isnull(st.FirstName, '') + case when st.FirstName is null then ''
														  else ' '
													 end + isnull(st.LastName, '')
				end [Staff]
			  , st.StaffId
	   from		dbo.ClientPrograms cp
	   join		#PsychAccess pa
				on cp.ProgramId = pa.ProgramId
	   join dbo.Clients c
				on cp.ClientId = c.ClientId
				   and isnull(c.RecordDeleted, 'N') = 'N'
	   left join dbo.Staff st
				on cp.AssignedStaffId = st.StaffId
				   and isnull(st.RecordDeleted, 'N') = 'N'
	   left join dbo.StaffClients sc
				on sc.ClientId = c.ClientId
				   and sc.StaffId = @ExecutedByStaffId
	   where	isnull(cp.RecordDeleted, 'N') = 'N'
				and datediff(day, @StartDate, cp.RequestedDate) >= 0
				and datediff(day, cp.RequestedDate, @EndDate) >= 0
				and ( @AgeGroup is null
					  or ( @AgeGroup = 'Adult'
						   and dbo.GetAge(c.DOB, cp.RequestedDate) >= 18 )
					  or ( @AgeGroup = 'Child'
						   and dbo.GetAge(c.DOB, cp.RequestedDate) < 18 ) )
				and ( @StaffId is null
					  or ( st.StaffId = @StaffId
						   and st.StaffId is not null ) )
	   order by	4 desc	-- AgeGroup
			  , 5		-- RequestedDate
			  , 2;		-- ClientId

go
