IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCStaffMeetingAttendeesList]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCStaffMeetingAttendeesList] 

GO 
               
CREATE procedure [dbo].[ssp_SCStaffMeetingAttendeesList]                                                                         
                                 
/********************************************************************************                                                                
-- Stored Procedure: dbo.ssp_SCStaffMeetingAttendeesList                                                                 
--                                                                
-- Copyright: Streamline Healthcate Solutions                                                                
--                                                                
-- Purpose: used by Report list page                                                                
--                                                                
-- Updates:                                                                                                                       
-- Date               Author                Purpose                                                                 
-- 23.9.2011          Rohit					Create           
/*  19/Jun/2017       Anto                  Modified the sp to call scsp if it exists in the database - Core Bugs #2387 */                                                           
*********************************************************************************/                                                                
AS                            
BEGIN    
  BEGIN TRY    
  IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[scsp_SCStaffMeetingAttendeesList]')
					AND type IN ( N'P', N'PC' ) ) 
   BEGIN					
		EXEC scsp_SCStaffMeetingAttendeesList

   END
   ELSE
   BEGIN
     
      SELECT  CSMA.StaffMeetingAttendeeId,             
          CSMA.StaffMeetingId,             
          CSMA.StaffId,             
          ltrim(rtrim(S.LastName)) + ', ' + S.FirstName AS StaffIdText            
FROM         CustomStaffMeetingAttendees AS CSMA             
    LEFT JOIN Staff AS S ON CSMA.StaffId = S.StaffId            
WHERE   (ISNULL(CSMA.RecordDeleted, 'N') = 'N')            
  AND (ISNULL(S.RecordDeleted,'N') = 'N')            
  END              
          
 END TRY                                                                                                                                       
                                                                                                                                              
 BEGIN CATCH                                                                                                                                                                                                                                        
   DECLARE @Error varchar(8000)                                                                                                                                                      
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                  
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCStaffMeetingAttendeesList')                                                                                          
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                                       
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                     
 END CATCH              
               
 End 