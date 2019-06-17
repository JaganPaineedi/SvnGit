if exists ( select	*
			from	sys.objects
			where	object_id = object_id(N'[dbo].[csp_RDLGOBHICrisisCallResponseTime]')
					and type in ( N'P', N'PC' ) )
   drop procedure [dbo].[csp_RDLGOBHICrisisCallResponseTime];
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create procedure [dbo].[csp_RDLGOBHICrisisCallResponseTime]
	   @ExecutedByStaffId int
	 , @StartDate datetime
	 , @EndDate datetime
	 , @AgeGroup varchar(5) = null
	 , @StaffId int = null
as /*********************************************************************                                                                                          
	File Procedure:		dbo.csp_RDLGOBHICrisisCallResponseTime.sql
	Creation Date:		03/24/2017
	Created By:			mlightner
	Purpose:			Dataset for Crisis Call Response Times
	Customer:			New Directions Northwest

	Input Parameters:	Date Range (start, end), AgeGroup (adult, child), Staff
	Output Parameters:	
	Return:				
	
	Called By:			
	Calls:				exec csp_RDLGOBHICrisisCallResponseTime 764, '1/1/2017', '3/31/2017', null, null
 
	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	03/24/2017	mlightner		Created
*********************************************************************/

	   declare @DocumentCodeId int;

	   select	@DocumentCodeId = dc.DocumentCodeId
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

	   /* Get information from Crisis Service Note */
	   select	case when c.ClientId is null then 'Not Available'
					 when sc.ClientId is null then 'No Access to Client Information'
					 else isnull(c.FirstName, '') + case when c.FirstName is null then ''
														 else ' '
													end + isnull(c.LastName, '')
				end [ClientName]
			  , isnull(cast(c.ClientId as varchar), 'N/A') [ClientId]
			  , dbo.GetAge(c.DOB, s.DateOfService) [Age]
			  , case when c.DOB is null then 'N/A'
					 when dbo.GetAge(c.DOB, s.DateOfService) >= 18 then 'Adult'
					 else 'Child'
				end [AgeGroup]
			  , convert(varchar, s.DateOfService, 101) [DateOfService]
			  , replace(replace(right(convert(varchar(32), asp.InitialCallTime, 100), 8), 'AM', ' AM'), 'PM', ' PM') [InitialCallTime]
			  , replace(replace(right(convert(varchar(32), asp.ClientAvailableTimeForScreen, 100), 8), 'AM', ' AM'), 'PM', ' PM') [ConsumerAvailableForScreen]
			  , datediff(minute, asp.InitialCallTime, asp.ClientAvailableTimeForScreen) [ResponseTime(Min)]
			  , case when st.StaffId is null then 'Not Available'
					 else isnull(st.FirstName, '') + case when st.FirstName is null then ''
														  else ' '
													 end + isnull(st.LastName, '')
				end [Staff]
			  , st.StaffId
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
				   and d.Status = 22
	   join		dbo.Services s
				on d.ServiceId = s.ServiceId
				   and isnull(s.RecordDeleted, 'N') = 'N'
	   join		#CrisisProcs cp
				on s.ProcedureCodeId = cp.ProcedureCodeId
	   left join dbo.Clients c
				on d.ClientId = c.ClientId
				   and isnull(c.RecordDeleted, 'N') = 'N'
	   left join dbo.Staff st
				on d.AuthorId = st.StaffId
				   and isnull(st.RecordDeleted, 'N') = 'N'
	   left join dbo.StaffClients sc
				on sc.ClientId = c.ClientId
				   and sc.StaffId = @ExecutedByStaffId
	   where	isnull(asp.RecordDeleted, 'N') = 'N'
				and ( @AgeGroup is null
					  or ( @AgeGroup = 'Adult'
						   and dbo.GetAge(c.DOB, s.DateOfService) >= 18 )
					  or ( @AgeGroup = 'Child'
						   and dbo.GetAge(c.DOB, s.DateOfService) < 18 ) )
				and ( @StaffId is null
					  or ( st.StaffId = @StaffId
						   and st.StaffId is not null ) )
	   order by	4 desc	-- AgeGroup
			  , 5		-- DateOfService
			  , 2;		-- ClientId

go
