 if exists ( select	*
			 from	sys.objects
			 where	object_id = object_id(N'[dbo].[csp_WarningMiscellaneousComplete]')
					and type in ( N'P', N'PC' ) )
	drop procedure [dbo].[csp_WarningMiscellaneousComplete];
 go
 
 set ansi_nulls on;
 go
 
 set quoted_identifier on;
 go
 
 create procedure [dbo].[csp_WarningMiscellaneousComplete]
		@DocumentVersionId as int
 as /*********************************************************************                                                                                          
 	File Procedure:		dbo.csp_WarningMiscellaneousComplete.sql
 	Creation Date:		07/20/2017
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
 	07/20/2017	mlightner		Created
 	12/29/2017  Veena           Adding condition to create the temp table only if not exist and removing the drop,as when we drop the table from csp,it is no longer available for the parent scsp.
 	                            NewDirection SGL #735
 *********************************************************************/
		begin                                                              
                    
			  begin try     
   
					/* Check for table existence */
					if object_id('tempdb..#WarningReturnTable') is null
					 --  drop table [#WarningReturnTable];

					/* Create Warning Return Temp Table */
					create table #WarningReturnTable
						   ( TableName varchar(200)
						   , ColumnName varchar(200)
						   , ErrorMessage varchar(max)
						   , PageIndex int
						   , TabOrder int
						   , ValidationOrder int );    
      
					/* Validate existence of Appointment Requested and Appointment First Offered dates */
					if exists ( select	*
								from	sys.objects
								where	object_id = object_id(N'[dbo].[csp_CheckAppointmentDates]')
										and type in ( N'P', N'PC' ) )
					   begin
							 exec dbo.csp_CheckAppointmentDates @DocumentVersionId;  
					   end;
  
					select	TableName
						  , ColumnName
						  , ErrorMessage
						  , PageIndex
						  , TabOrder
						  , ValidationOrder
					from	#WarningReturnTable
					order by TabOrder
						  , ValidationOrder
						  , PageIndex
						  , ErrorMessage;    
  
			  end try                                                              
                                                                                              
			  begin catch                  
                
					declare	@Error varchar(8000);                                                               
					set @Error = convert(varchar, error_number()) + '*****' 
							   + convert(varchar(4000), error_message()) + '*****' 
							   + isnull(convert(varchar, error_procedure()), '[csp_WarningMiscellaneousComplete]') + '*****' 
							   + convert(varchar, error_line()) + '*****' 
							   + convert(varchar, error_severity()) + '*****' 
							   + convert(varchar, error_state());
					raiserror                                                                                             
							 (                                                               
							  @Error, -- Message text.                                                                                            
							  16, -- Severity.                                                                                            
							  1 -- State.                                                                                            
							 );                                                                      
			  end catch;                                        
		end;                   

go