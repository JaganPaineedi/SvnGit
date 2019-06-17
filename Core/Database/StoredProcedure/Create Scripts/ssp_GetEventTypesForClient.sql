/****** Object:  StoredProcedure [dbo].[ssp_GetEventTypesForClient]    Script Date: 05/13/2014 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetEventTypesForClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetEventTypesForClient]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetEventTypesForClient]    Script Date: 05/13/2014 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_GetEventTypesForClient]       
@ClientId int ,      
@StaffId int,      
@EventTypeId  int                     
as                                    
/*********************************************************************/                                                    
/* Stored Procedure: dbo.ssp_CMGetEventTypesForClient                */                                                    
/* Copyright: 2005 Provider Claim Management System                  */                                                    
/* Creation Date:  13 May 2014                                       */                                                    
/* SP taken form ..\SC\3.5xMerge\Database\SQLSourceControl\Venture\Summit\Stored Procedures		*/ 
/* Purpose: To show data for Event types                             */                                                   
/*                                                                   */                                                  
/* Input Parameters:     @ClientId, @StaffId, @EventTypeId			 */                                                  
/*                                                                   */                                                    
/* Output Parameters:                                                */                                                    
/*                                                                   */                                                    
/* Return: EventTypes based on ClientId                              */                                                    
/*                                                                   */                                                    
/* Called By:                                                        */                                                    
/*                                                                   */                                                    
/* Calls:                                                            */                                                    
/*                                                                   */                                                    
/* Data Modifications:                                               */                                                    
/*                                                                   */                                                    
/* Updates:                                                          */   
/* Dhanil Manuel added    event type 5774 for task 65 cm to sc         */ 
/* Dhanil Manuel removed  event type 5774 for task 65 cm to sc         */
/* Shruthi.S              Added eventtype 5772 to pull SU event types for a new client.Ref #155 Care Management to SmartCare Env. Issues Tracking.*/ 
/* 03 Feb 2015			Munish		Added Record Deleted Check KCMHSAS 3.5 Implementation Task #221 */ 
/* 20 Apr 2016		Alok Kumar		Replace type 5772 to 5774 as the types 5774 is common for both MH Client and SU Client for the Task#113 Network 180 Environment Issues Tracking */     
/*05 July 2016      Bernardin       Removed Type 5774 not to display "ReadOnlyEvents" and Display MH Event or SU Event with 5773(Both MH and SU Event) based on "MasterRecord" values in "Client" table.*/
/*03 Oct 2017    Lakshmi    Modified 'OR' condition to avoid Event Name duplication, As per the task Allegan - Support #1148*/
/*28 June 2018		Dasari Sunil 	 	What: Added inner join with document codes table to check that document in document code table Active Or Not. we implemented joining with document codes table to prevent user to create an Inactivated Events as well as to see the completed Events.
									 	Why: Creating the event the dropdown list should be driven by the edit permissions on document codes,we can't deactivate an Event for all users, and we still need everyone to be able to see the Created/completed events.
									 	SWMBH - Support #1255 */

/*********************************************************************/                                                     
BEGIN  
	BEGIN TRY                                
declare @EventType int                  
              
select @EventType = case when c.MasterRecord = 'Y'                   
                         then 5771 -- MH Client            
                         else 5772 -- SU Client                  
                    end                   
 from Clients c                   
 where c.ClientId = @ClientId              
 --select @EventType = 5772                            
                             
select distinct et.EventTypeId,                  
       et.EventName,                  
       s.ScreenId,                  
       et.AssociatedDocumentCodeId                      
  from EventTypes et                
       left join Screens s on s.DocumentCodeId = et.AssociatedDocumentCodeId        
 and s.screentype=5763  --  By Rakesh -II  for Document type i.e.  5763    
   --inner join ViewStaffPermissions P  on  et.EventTypeId= p.PermissionItemId                
 where et.EventType in (@EventType, 5773)  and isnull(et.RecordDeleted,'N')='N'
      
  and isnull(et.RecordDeleted, 'N') = 'N'                     
   and isnull(s.RecordDeleted, 'N') = 'N'        
   ------AND P.StaffId=@StaffId and P.PermissionTemplateType=5905  
   and exists(
   select 1 from ViewStaffPermissions P  
   where   P.StaffId=@StaffId AND 
    (P.PermissionTemplateType=5702 or P.PermissionTemplateType=5905) 
    and et.EventTypeId= p.PermissionItemId 
     )            
   ---because this a dummy data for Event           
       and (et.EventTypeId !=1087       
    or (@EventTypeId <> -1 AND et.EventTypeId=@EventTypeId))   --Added by Lakshmi on 03/10/2017 
   order by EventName 
   
   
   select top 1 a.EventId,a.InsurerId,b.EventTypeId,b.EventName,b.EventType,b.AssociatedDocumentCodeId from Events a ,EventTypes b where a.EventTypeId=b.EventTypeId and ClientId=@ClientId and b.eventTypeId=@EventTypeId order by EventId desc
   
   END TRY
  
  BEGIN CATCH
  declare @Error varchar(8000)    
	 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())     
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetEventTypesForClient')     
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())      
		+ '*****' + Convert(varchar,ERROR_STATE())    
	      
	 RAISERROR     
	 (    
	  @Error, -- Message text.    
	  16, -- Severity.    
	  1 -- State.    
	 ) 
   END CATCH             
END     

GO


