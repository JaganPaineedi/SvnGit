IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[scsp_SCStaffMeetingAttendeesList]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_SCStaffMeetingAttendeesList] 

GO 
               
CREATE procedure [dbo].[scsp_SCStaffMeetingAttendeesList]           
                                                                      
/********************************************************************************/                
/* Stored Procedure: scsp_SCStaffMeetingAttendeesList       */       
      
/*  Copyright: Streamline Healthcate Solutions				*/          
      
/* Creation Date:  19/Jun/2017								*/                                                  
/*   Updates:											    */                
      
/*       Date              Author                  Purpose                      */                
/*  19/Jun/2017             Anto                 Created a scsp to call the csp if it exists -  Core Bugs #2387*/                
/********************************************************************************/                   
      
                                 
AS                              
BEGIN      
  BEGIN TRY       
  
  
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[csp_SCStaffMeetingAttendeesList]')
					AND type IN ( N'P', N'PC' ) ) 
BEGIN					
	
	EXEC csp_SCStaffMeetingAttendeesList

 END
  ELSE
   BEGIN
     
      SELECT    CSMA.StaffMeetingAttendeeId,             
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
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_SCStaffMeetingAttendeesList')                                                                                            
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())         
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                                         
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                       
 END CATCH                
                 
 End    

