IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCGetDataForCustomStaffMeeting]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetDataForCustomStaffMeeting] 

GO 
               
CREATE PROCEDURE [DBO].[ssp_SCGetDataForCustomStaffMeeting]   
(                                                                                                                                                                                                                                                              
  @StaffMeetingId INT                  
)                                                                                                                                                                                                                                                              
As                                                                                                                                                                                                          
                                                                                                                                                                                       
                                   
/********************************************************************************                                                                
-- Stored Procedure: dbo.ssp_SCGetDataForCustomStaffMeeting                                                               
--                                                                
-- Copyright: Streamline Healthcate Solutions                                                                
--                                                                
-- Purpose: Get Data for Staff Meeting Detail  Pages                                                             
--                                                                
-- Updates:                                                                                                                       
-- Date               Author                Purpose                                                                           
/*  19/Jun/2017       Anto                  Created a new ssp to make it as a core sp - Core Bugs #2387 */                                                           
*********************************************************************************/     
       
       
          
                                                                                                                                                                    
BEGIN                                                                                                                                                            
                                                                                                                                                     
   BEGIN TRY                                                                                                  
              
    --######################## CustomStaffMeetings Table ##################          
     SELECT StaffMeetingId,           
   CreatedBy,           
   CreatedDate,           
   ModifiedBy,           
   ModifiedDate,           
   RecordDeleted,           
   DeletedBy,           
   DeletedDate,           
   MeetingType,           
   FacilitatorId,           
   [Status],          
   StartDateTime,           
            EndTime,           
            LocationId,           
            MeetingTopic,           
            StructuredGuide,           
            MeetingNotes,     
            case  when [Status] in ('C','A') then 1    
            else 0 end as RecordSaved       
                      
FROM        CustomStaffMeetings          
WHERE  [StaffMeetingId]=@StaffMeetingId           
   AND (ISNULL(RecordDeleted, 'N') = 'N')              
                  
   --######################## CustomStaffMeetingAttendees Table ##################          
          
  SELECT    CSMA.StaffMeetingAttendeeId,                 
   CSMA.CreatedBy,                 
   CSMA.CreatedDate,                 
            CSMA.ModifiedBy,                 
            CSMA.ModifiedDate,                 
            CSMA.RecordDeleted,                 
            CSMA.DeletedBy,                 
            CSMA.DeletedDate,                 
            CSMA.StaffMeetingId,                 
            CSMA.StaffId,                 
             COALESCE(S.LastName,'') + ', ' + COALESCE(S.FirstName,'') AS StaffIdText                
FROM         CustomStaffMeetingAttendees AS CSMA                 
   LEFT JOIN Staff AS S ON CSMA.StaffId = S.StaffId                
WHERE  (ISNULL(CSMA.RecordDeleted, 'N') = 'N')                
    AND (ISNULL(S.RecordDeleted,'N') = 'N')                
    AND CSMA.StaffMeetingId=@StaffMeetingId             
          
   --######################## ImageRecords Table ##################          
SELECT  ImageRecords.ImageRecordId,          
   ImageRecords.CreatedBy,           
   ImageRecords.CreatedDate,           
   ImageRecords.ModifiedBy,           
   ImageRecords.ModifiedDate,           
   ImageRecords.RecordDeleted,           
   ImageRecords.DeletedBy,           
   ImageRecords.DeletedDate,           
   ImageRecords.ScannedOrUploaded,          
   DocumentVersionId,          
   ImageServerId,          
   ClientId,          
   AssociatedId,          
   AssociatedWith,          
   RecordDescription,          
   EffectiveDate,          
   NumberOfItems,          
   AssociatedWithDocumentId,          
   AppealId,          
   StaffId,          
   EventId,          
   ProviderId,          
   TaskId,          
   AuthorizationDocumentId,          
   ScannedBy,          
   CoveragePlanId,          
   ClientDisclosureId          
             
FROM   ImageRecords inner join CustomStaffMeetingImageRecords on ImageRecords.ImageRecordId=CustomStaffMeetingImageRecords.ImageRecordId          
WHERE       CustomStaffMeetingImageRecords.StaffMeetingId = @StaffMeetingId AND (ISNULL(CustomStaffMeetingImageRecords.RecordDeleted, 'N') = 'N')  and (ISNULL(ImageRecords.RecordDeleted, 'N') = 'N')         
                  
          
   --######################## CustomStaffMeetingImageRecords Table ##################          
SELECT DISTINCT       
                       CustomStaffMeetingImageRecords.StaffMeetingImageRecordId,  CustomStaffMeetingImageRecords.CreatedBy,       
                       CustomStaffMeetingImageRecords.CreatedDate,  CustomStaffMeetingImageRecords.ModifiedBy,  CustomStaffMeetingImageRecords.ModifiedDate,       
                       CustomStaffMeetingImageRecords.RecordDeleted,  CustomStaffMeetingImageRecords.DeletedBy,  CustomStaffMeetingImageRecords.DeletedDate,       
                       CustomStaffMeetingImageRecords.StaffMeetingId,  CustomStaffMeetingImageRecords.ImageRecordId      
FROM          CustomStaffMeetingImageRecords INNER JOIN      
                       ImageRecords ON  CustomStaffMeetingImageRecords.ImageRecordId =  ImageRecords.ImageRecordId         
WHERE       StaffMeetingId = @StaffMeetingId AND (ISNULL( CustomStaffMeetingImageRecords.RecordDeleted, 'N') = 'N')   and (ISNULL( ImageRecords.RecordDeleted, 'N') = 'N')                     
                   
                                                                                          
 END TRY                                                                                                                                           
                                                                                                                                                  
 BEGIN CATCH                                                                                                                                                                                                                                            
   DECLARE @Error varchar(8000)                                                                                                                                                          
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetDataForCustomStaffMeeting')                                                                                              
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                     
   
   
       
            
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                                           
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                         
 END CATCH                  
                   
 End  