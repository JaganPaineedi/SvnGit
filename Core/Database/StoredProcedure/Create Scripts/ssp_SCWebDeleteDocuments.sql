IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDeleteDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebDeleteDocuments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebDeleteDocuments]                                                                   
(                                                                          
 @DocumentId as int,                                                                          
 @ServiceId as int,                                                                        
 @EventId as int,      
 @DeletedBy as varchar(30)          
)                                                                          
AS                                                                          
/*********************************************************************/                                                                            
/* Stored Procedure: dbo.ssp_SCWebDeleteDocuments                */                                                                            
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                                            
/* Creation Date:   24 March 2010                                         */                                                                            
/*                                                                   */                                                                            
/* Purpose:This procedure is used to Delete the custom documents/Events/ServiceNote*/                                                                          
/*                                                                   */                                                                          
/* Input Parameters: @DocumentId,@ServiceId,@EventId  @DeletedBy     */                                                                          
/*                                                                   */                                                                            
/* Output Parameters:        */                                                                            
/*                                                                   */                                                                            
/* Return:  0=success, otherwise an error number                     */                                                                            
/*                                                                   */                                                                            
/* Called By:                                                        */                                                                            
/*                                                                   */                                                                            
/* Calls:                                                            */                                                                            
/*                                                                   */                                                                            
/* Data Modifications:                                               */                                                                            
/*                                                                   */                                                                            
/* Updates:                                                          */                                                                            
/*  Date                Author               Purpose                                    */                                                                            
/*  24 March 2010       Vikas Monga     Delete the custom documents/Events/ServiceNote */  
/*	Jan 10,2012			Varinder Verma	Added DeletedBy & DeletedDate for Appointments table */

/* 26 April 2012		Sudhir Singh    Added code for Outlook integration*/    
/*	29 May 2012			Rahul Aneja		Deleted Date & Deleted By Updated with Delete Appointment*/
/*  09-Jan-2013         Jagdeep Hundal  Added "ssp_PMServiceAuthorizations" as per task #331- ASG Support.*/
/*  JUL-27-2013			dharvey			Added Resource tables to remove on Service Deletion */
/*  24/NOV/2017         Akwinass        Added ssp_SCDeleteImageRecordServices.(Task #589 in Engineering Improvement Initiatives- NBL(I)) */
/*********************************************************************/                                                                             
                                                                        
  Begin
   
 /*Added by Sudhir Singh on date 26 April 2012 fro outlook integration*/   
 declare @AppointmentId int
 set @AppointmentId = 0
                                                         
 Declare @DocumentVersionID int                        
   BEGIN TRY    
if(@DocumentId<>0)     
  begin       
 Select @DocumentVersionID=CurrentDocumentVersionId  from Documents where DocumentId=@DocumentId      
update DocumentVersions set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where DocumentId=@DocumentId                                                                        
update DocumentSignatures set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where DocumentId=@DocumentId                                                               
update CustomFieldsData set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where PrimaryKey1 =@DocumentVersionID                                                               

exec scsp_SCWebDeleteDocuments @DocumentId,@DeletedBy         
    
end    

-- Logic for Delete FollowUpEventId for Event Architecture
if(@EventId>0)
begin
    declare @FollowUpEventId int 
    declare @status int
    set @FollowUpEventId=(select FollowUpEventId from Events where EventId=@EventId) 
    if(@FollowUpEventId > 0)  
    begin
   set @status=( select [Status] from Events where EventId=@FollowUpEventId)
   if(@status=2061)
   begin
   update Events set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where EventId=@FollowUpEventId                                                                          
      update Documents set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where EventId=@FollowUpEventId
         update DocumentVersions set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where DocumentId=(select  DocumentId from Documents where EventId=@FollowUpEventId)                                                                          
   
   end
  end
  end
      
      

    
if (@ServiceId<>0)    
    
begin

/*Added by Sudhir Singh on date 26 April 2012 fro outlook integration*/
select @AppointmentId = isnull(AppointmentId,0) from Appointments where ServiceID =@ServiceId and isnull(RecordDeleted, 'N')='N'

/*Code Commented By Rahul Aneja on 28 May 2012 Deleted By & Deleted Date Must be Updated on Delete Appointment*/

--update Appointments set  RecordDeleted='Y' where ServiceID =@ServiceId 
update Appointments set  RecordDeleted='Y',DeletedBy=@DeletedBy, DeletedDate=getDate() where ServiceID =@ServiceId 
	
update Servicegoals set  RecordDeleted='Y',DeletedBy=@DeletedBy, DeletedDate=getDate()  where ServiceId =@ServiceId      
update Serviceobjectives set RecordDeleted='Y',DeletedBy=@DeletedBy, DeletedDate=getDate()  where ServiceId = @ServiceId 

exec ssp_SCDeleteImageRecordServices @ServiceId,@DeletedBy

exec ssp_PMServiceAuthorizations @DeletedBy,@ServiceId,'Y'


DECLARE @AppointmentMasterId INT
SELECT  @AppointmentMasterId = AppointmentMasterId
FROM    dbo.AppointmentMaster
WHERE   ServiceId = @ServiceId

--Remove Resource Tables on Delete
IF @AppointmentMasterId IS NOT NULL
	BEGIN
		UPDATE  dbo.AppointmentMaster
		SET     RecordDeleted = 'Y' ,
				DeletedBy = @DeletedBy ,
				DeletedDate = GETDATE()
		WHERE   AppointmentMasterId = @AppointmentMasterId
		
		UPDATE  dbo.AppointmentMasterResources
		SET     RecordDeleted = 'Y' ,
				DeletedBy = @DeletedBy ,
				DeletedDate = GETDATE()
		WHERE   AppointmentMasterId = @AppointmentMasterId
		
		UPDATE  dbo.AppointmentMasterStaff
		SET     RecordDeleted = 'Y' ,
				DeletedBy = @DeletedBy ,
				DeletedDate = GETDATE()
		WHERE   AppointmentMasterId = @AppointmentMasterId
	END      
End   
                                                        
    /*Added by Sudhir Singh on date 26 April 2012 fro outlook integration*/
   select @AppointmentId    
       
     END TRY                                      
  BEGIN CATCH                                      
   DECLARE @Error varchar(8000)                                                                
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                 
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebDeleteDocuments')                                                                 
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                  
         + '*****' + Convert(varchar,ERROR_STATE())                                                                
        RAISERROR                                                                 
   (                                                                
     @Error, -- Message text.                              
     16, -- Severity.                                                                
     1 -- State.                                                                
    );                                                                
  END CATCH   
       
       
       
  End     

GO


