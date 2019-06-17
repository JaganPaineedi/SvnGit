if exists ( select	*
			from	sys.objects
			where	object_id = object_id(N'[dbo].[csp_GetCustomClientPrograms]')
					and type in ( N'P', N'PC' ) )
   drop procedure [dbo].[csp_GetCustomClientPrograms];
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create procedure [dbo].[csp_GetCustomClientPrograms]
	   @ClientProgramId as int
as /*********************************************************************                                                                                          
	File Procedure:		dbo.csp_GetCustomClientPrograms.sql
	Creation Date:		05/16/2017
	Created By:			mlightner
	Purpose:			
	Customer:			

	Input Parameters:	
	Output Parameters:	
	Return:				
	
	Called By:			
	Calls:				
 
	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	05/16/2017	mlightner		Created
*********************************************************************/

	   select	ccp.ClientProgramId
			  , ccp.CreatedBy
			  , ccp.CreatedDate
			  , ccp.ModifiedBy
			  , ccp.ModifiedDate
			  , ccp.RecordDeleted
			  , ccp.DeletedBy
			  , ccp.DeletedDate
			  , ccp.AppointmentRequestedDate
			  , ccp.AppointmentFirstOfferedDate
	   from		dbo.CustomClientPrograms ccp
	   where	ccp.ClientProgramId = @ClientProgramId;

go