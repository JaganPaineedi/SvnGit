if exists ( select	*
			from	sys.objects
			where	object_id = object_id(N'[dbo].[csp_CheckAppointmentDates]')
					and type in ( N'P', N'PC' ) )
   drop procedure [dbo].[csp_CheckAppointmentDates];
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create procedure [dbo].[csp_CheckAppointmentDates]
	   @DocumentVersionId as int
as /*********************************************************************                                                                                          
	File Procedure:		dbo.csp_CheckAppointmentDates.sql
	Creation Date:		07/20/2017
	Created By:			mlightner
	Purpose:			Retrieve Appointment Requested and Appointment First Offered Dates 
							to determine if there is a value
	Customer:			New Directions

	Input Parameters:	DocumentVersionId
	Output Parameters:	
	Return:				#WarningReturnTable
	
	Called By:			
	Calls:				
 
	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	07/20/2017	mlightner		Created
*********************************************************************/

	   declare @ClientId int;
	   declare @ServiceId int;
	   declare @ProgramId int;
	   declare @DocumentCodeId int;
  
	   select	@ClientId = d.ClientId
			  , @ServiceId = d.ServiceId
			  , @ProgramId = s.ProgramId
			  , @DocumentCodeId = d.DocumentCodeId
	   from		dbo.Documents d
	   join		dbo.DocumentVersions dv
				on d.DocumentId = dv.DocumentId
				   and isnull(dv.RecordDeleted, 'N') = 'N'
	   join		dbo.Services s
				on d.ServiceId = s.ServiceId
				   and isnull(s.RecordDeleted, 'N') = 'N'
	   where	isnull(d.RecordDeleted, 'N') = 'N'
				and dv.DocumentVersionId = @DocumentVersionId;  
  
		-- DocumentCode for Crisis Service Note
	   declare @CrisisDocumentCodeId int;
	   select	@CrisisDocumentCodeId = dc.DocumentCodeId	--select *
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
	   insert	into #ServiceLevelPrograms
				( ServiceLevel
				, ProgramId )
	   select	'Emergent'
			  , ep.IntegerCodeId
	   from		dbo.ssf_RecodeValuesCurrent('GOBHIEmergentPrograms') ep
	   join		dbo.Programs p
				on ep.IntegerCodeId = p.ProgramId
				   and isnull(p.RecordDeleted, 'N') = 'N';
	
	   -- Get Urgent level programs
	   insert	into #ServiceLevelPrograms
				( ServiceLevel
				, ProgramId )
	   select	'Urgent'
			  , up.IntegerCodeId
	   from		dbo.ssf_RecodeValuesCurrent('GOBHIUrgentPrograms') up
	   join		dbo.Programs p
				on up.IntegerCodeId = p.ProgramId
				   and isnull(p.RecordDeleted, 'N') = 'N';

	   -- Get Routine level programs
	   insert	into #ServiceLevelPrograms
				( ServiceLevel
				, ProgramId )
	   select	'Routine'
			  , p.ProgramId
	   from		dbo.Programs p
	   left join dbo.ssf_RecodeValuesCurrent('GOBHIEmergentPrograms') ep
				on p.ProgramId = ep.IntegerCodeId
	   left join dbo.ssf_RecodeValuesCurrent('GOBHIUrgentPrograms') up
				on p.ProgramId = up.IntegerCodeId
	   where	isnull(p.RecordDeleted, 'N') = 'N'
				and ep.IntegerCodeId is null
				and up.IntegerCodeId is null
	   order by	p.ProgramId;

	   if object_id('tempdb..#AppointmentDates') is not null
		  drop table [#AppointmentDates];
	   create table #AppointmentDates
			  (	DocumentVersionId int
			  , ServiceLevel varchar(max)
			  , ApptRequestedDate datetime
			  , ApptOfferedDate datetime );
	   

/********************************************************************
GET CRISIS (EMERGENT) INFORMATION FROM CUSTOMACUTESERVICESPRESCREENS
********************************************************************/

	   if ( @DocumentCodeId = @CrisisDocumentCodeId )
		  begin

				insert	into #AppointmentDates
						( DocumentVersionId
						, ServiceLevel
						, ApptRequestedDate
						, ApptOfferedDate )
				select	asp.DocumentVersionId [DocumentVersionId]
					  , 'Emergent'
					  , asp.InitialCallTime [RequestedDate]
					  , s.DateOfService [AppointmentOfferedDate]
				from	dbo.CustomAcuteServicesPrescreens asp
				join	dbo.DocumentVersions dv
						on asp.DocumentVersionId = dv.DocumentVersionId
						   and isnull(dv.RecordDeleted, 'N') = 'N'
				join	dbo.Documents d
						on dv.DocumentVersionId = d.CurrentDocumentVersionId
						   and isnull(d.RecordDeleted, 'N') = 'N'
				join	dbo.Services s
						on d.ServiceId = s.ServiceId
						   and isnull(s.RecordDeleted, 'N') = 'N'
				join	#CrisisProcs crp
						on s.ProcedureCodeId = crp.ProcedureCodeId
				where	isnull(asp.RecordDeleted, 'N') = 'N'
						and asp.DocumentVersionId = @DocumentVersionId;
												
		  end;

/********************************************************************
		GET URGENT INFORMATION FROM CUSTOM CLIENT PROGRAMS
********************************************************************/

	   if exists ( select	*
				   from		#ServiceLevelPrograms slp
				   where	slp.ProgramId = @ProgramId
							and slp.ServiceLevel = 'Urgent' )
		  begin

				insert	into #AppointmentDates
						( DocumentVersionId
						, ServiceLevel
						, ApptRequestedDate
						, ApptOfferedDate )
				select	@DocumentVersionId [DocumentVersionId]
					  , 'Urgent'
					  , ccp.AppointmentRequestedDate [RequestedDate]
					  , ccp.AppointmentFirstOfferedDate [AppointmentOfferedDate]
				from	dbo.ClientPrograms cp
				left	join dbo.CustomClientPrograms ccp
						on cp.ClientProgramId = ccp.ClientProgramId
						   and isnull(ccp.RecordDeleted, 'N') = 'N'
				where	isnull(cp.RecordDeleted, 'N') = 'N'
						and cp.ProgramId = @ProgramId
						and cp.ClientId = @ClientId
						and cp.Status in ( 1, 3, 4 );
		  end;

/********************************************************************
		GET ROUTINE INFORMATION FROM CUSTOM CLIENT PROGRAMS
********************************************************************/

	   if exists ( select	*
				   from		#ServiceLevelPrograms slp
				   where	slp.ProgramId = @ProgramId
							and slp.ServiceLevel = 'Routine' )
		  begin

				insert	into #AppointmentDates
						( DocumentVersionId
						, ServiceLevel
						, ApptRequestedDate
						, ApptOfferedDate )
				select	@DocumentVersionId [DocumentVersionId]
					  , 'Routine'
					  , ccp.AppointmentRequestedDate [RequestedDate]
					  , ccp.AppointmentFirstOfferedDate [AppointmentOfferedDate]
				from	dbo.ClientPrograms cp
				join	dbo.Clients c
						on cp.ClientId = c.ClientId
						   and isnull(c.RecordDeleted, 'N') = 'N'
				left	join dbo.CustomClientPrograms ccp
						on cp.ClientProgramId = ccp.ClientProgramId
						   and isnull(ccp.RecordDeleted, 'N') = 'N'
				where	isnull(cp.RecordDeleted, 'N') = 'N'
						and cp.ProgramId = @ProgramId
						and cp.ClientId = @ClientId
						and cp.Status in ( 1, 3, 4 );
		  end;

/********************************************************************
		LOAD WARNINGS FOR RECORDS WITHOUT SPECIFIED DATES
********************************************************************/

	   insert	into #WarningReturnTable
				( TableName
				, ColumnName
				, ErrorMessage
				, ValidationOrder )
	   select	case ad.ServiceLevel
				  when 'Emergent' then 'CustomAcuteServicesPrescreens'
				  when 'Urgent' then 'CustomClientPrograms'
				  when 'Routine' then 'CustomClientPrograms'
				  else 'Unknown'
				end [TableName]
			  , case ad.ServiceLevel
				  when 'Emergent' then 'InitialCallTime'
				  when 'Urgent' then 'AppointmentRequestedDate'
				  when 'Routine' then 'AppointmentRequestedDate'
				  else 'Unknown'
				end [ColumnName]
			  , 'WARNING: Appointment Requested Date/Time is blank' [ErrorMessage]
			  , 1
	   from		#AppointmentDates ad
	   where	ad.ApptRequestedDate is null;

	   insert	into #WarningReturnTable
				( TableName
				, ColumnName
				, ErrorMessage
				, ValidationOrder )
	   select	case ad.ServiceLevel
				  when 'Emergent' then 'Services'
				  when 'Urgent' then 'CustomClientPrograms'
				  when 'Routine' then 'CustomClientPrograms'
				  else 'Unknown'
				end [TableName]
			  , case ad.ServiceLevel
				  when 'Emergent' then 'DateOfService'
				  when 'Urgent' then 'AppointmentFirstOfferedDate'
				  when 'Routine' then 'AppointmentFirstOfferedDate'
				  else 'Unknown'
				end [ColumnName]
			  , 'WARNING: Appointment First Offered Date/Time is blank' [ErrorMessage]
			  , 2
	   from		#AppointmentDates ad
	   where	ad.ApptOfferedDate is null;

go