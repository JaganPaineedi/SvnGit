IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSaveMessageRecordWise]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSaveMessageRecordWise]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================                    
-- Author:  Mahesh                     
-- Create date: 7th-Dec-2010                    
-- Description: To Insert the Record in to Messages and MessageRecepients                    
-- =============================================                    
CREATE PROCEDURE [dbo].[ssp_SCSaveMessageRecordWise]                    
( @FromStaffId int,                                
      @ToStaffId int,                                
      @ClientId int,                                
      @Unread char(10),                                
      @DateReceived datetime,                                
      @Subject varchar(700),                                
      @Message text,                                
      @Priority int,                                
      @Reference varchar(150),                                
      @ReferenceLink varchar(150),                                
      --@DocumentVersionId int,                                
     -- @TabId int,                                
     @DeletedBySender char(1),                                
    @OtherRecipients varchar(2000),                                
    --  @RowIdentifier uniqueidentifier,                                
    @CreatedBy varchar(50),                                
    @CreatedDate datetime,                                
    @ModifiedBy varchar(30),                                
    @ModifiedDate datetime,                                
    @RecordDeleted char(10),                                
     -- @DeletedDate datetime,                                
     -- @DeletedBy varchar(30)                           
--     @MessageDocumentId  int, -- added by Mahesh S Commented on 26 July                        
    @ReferenceId int,                        
    @ReferenceType varchar(25),                      
     --Added By Mahesh on 27 Nov 2010                      
    @ToSystemDatabaseID int,                      
 @ToSystemStaffID int,                      
 @ToSystemStaffName varchar(50),                      
 @FromSystemDatabaseID int,                      
 @FromSystemStaffID int,                      
 @FromSystemStaffName varchar(50),                      
 @SenderCopy char(1),                      
 @ReceiverCopy char(1),                    
 @MessageIDInserted int ,                  
 @ReferenceSystemDatabaseId int ,  
 @PartOfClientRecord  char(1),  --added by Priya   
 @ProviderAuthorizationDocumentId int =NULL  --02 July 2018	Vithobha
  )                                
AS                                  
                                  
/*********************************************************************/                                    
/* Stored Procedure: dbo.ssp_SCSaveMessageRecordWise                */                                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                    
/* Creation Date:    18/01/2010                                         */                                    
/*                                                                   */                                    
/* Purpose: It is used to change the message and Alert status, it @varType=1 then it update message otherwise alerts      */                                   
/*                                                                   */                                  
/* Input Parameters: @varMessageid, @varType                */                                  
/*                                                                   */                                    
/* Output Parameters:   None                               */                                    
/*                                                                   */                                    
/* Return:  0=success, otherwise an error number                     */                                    
/*                                                                   */                                    
/* Called By:                                                        */                                    
/* */                                    
/* Calls:                                                            */           
/*                                                                */                                    
/* Data Modifications:                                           */                                  
/*                                                                   */                                    
/* Updates:         */                                    
/*  Date		Author       Purpose                                    */                                    
/* 8/1/05		Vikas		Created                                        */                           
/*Modifications History :            */                        
/* 18/7/201		Mahesh S	Added new parameter @MessageDocumentId which first use in send message from Authorization details*/    
/* 05/22/2014	Chethan		Reverted the latest change to previous to Making the reply/sent functionality work.*/   
/* 02 July 2018	Vithobha	Added @ProviderAuthorizationDocumentId as parameter to ssp_SCSaveMessageRecordWise for SWMBH - Support #1121 */                    
/*********************************************************************/                                     
BEGIN   
BEGIN TRY                               
                   
if @ClientId=0                     
set @ClientId=null                    
Declare @MessageID int                       
SET @MessageID=-1      
--added by priya    
 if(@ReferenceSystemDatabaseId =0)                      
   set @ReferenceSystemDatabaseId=null                        
IF(@ToSystemDatabaseID IS NULL)                    
BEGIN                    
Declare @FromSystemDatabaseIDValue int                    
set @FromSystemDatabaseIDValue=null                    
if(@FromSystemDatabaseID=-1)                    
set @FromSystemDatabaseIDValue=null                   
else                   
set  @FromSystemDatabaseIDValue=@FromSystemDatabaseID  
--02 July 2018	Vithobha
IF(@ProviderAuthorizationDocumentId = 0)
  SET @ProviderAuthorizationDocumentId = NULL      
          
Insert into Messages (                              
       FromStaffId                              
       ,ToStaffId                                
      ,ClientId                                
      ,Unread                                
      ,DateReceived                                
      ,Subject                                
      ,Message                                
      ,Priority                                
      ,Reference                                
      ,ReferenceLink                                
      --,DocumentVersionId                                
      --,TabId                                
      ,DeletedBySender                                
       ,OtherRecipients                                
      --,RowIdentifier                                
      ,CreatedBy                                
      ,CreatedDate                                
      ,ModifiedBy                                
      ,ModifiedDate                                
      ,RecordDeleted                         
      --,DocumentId --Added on 18 July,Commented on 26 July                        
      ,ReferenceId -- Added on 26 July,                        
      ,ReferenceType -- Added on 26 July                        
      --Added By Mahesh on 27-Nov-2010                      
      ,ToSystemDatabaseId                      
      ,ToSystemStaffId                      
      ,ToSystemStaffName                      
       ,FromSystemDatabaseId                      
      ,FromSystemStaffId                      
      ,FromSystemStaffName                      
      ,SenderCopy                      
      ,ReceiverCopy                   
      ,ReferenceSystemDatabaseId  
      ,PartOfClientRecord              
      ,ProviderAuthorizationDocumentId	--02 July 2018	Vithobha
     )                               
                                    
      values (                              
       @FromStaffId                              
      ,@ToStaffId                                
      ,@ClientId                                
      ,@Unread         
      ,@DateReceived                                
      ,@Subject                                
      ,@Message                                
      ,@Priority                                
      ,@Reference                                
      ,@ReferenceLink                                
                                 
      ,@DeletedBySender                                
      ,@OtherRecipients                                
                                   
      ,@CreatedBy                                
      ,@CreatedDate                                
      ,@ModifiedBy       
      ,@ModifiedDate                            
      ,null                        
                           
      ,@ReferenceId                     
      ,@ReferenceType                      
                         
      ,@ToSystemDatabaseID                      
      ,@ToSystemStaffID                      
      ,@ToSystemStaffName                      
      ,@FromSystemDatabaseIDValue                      
      ,@FromSystemStaffID                      
      ,@FromSystemStaffName                      
      ,@SenderCopy                      
      ,@ReceiverCopy                    
      ,@ReferenceSystemDatabaseId  
      ,@PartOfClientRecord   
      ,@ProviderAuthorizationDocumentId           --02 July 2018	Vithobha     
       )                        
                          
      select @MessageID=@@IDENTITY                         
      END                    
      select @MessageID as MessageIDInserted                       
      if(@MessageIDInserted<>-1)                    
  set @MessageID=@MessageIDInserted                     
   if(@MessageID=-1)                    
  select @MessageID=  MAX(isnull(MessageId,0)) from MessageRecepients                    
                           
                           
     --Modified By Mahesh on 27-Nov-2010                      
     IF(@FromSystemDatabaseID IS NULL)                    
     BEGIN                    
     IF(@ToStaffId is not null or @ToSystemStaffID is not null)                      
     begin                      
  INSERT INTO [MessageRecepients]                      
        ([MessageId]                      
           ,[StaffId]                      
           ,[SystemDatabaseId]                      
           ,[SystemStaffId]                      
           ,[SystemStaffName]                      
           ,[CreatedBy]                      
           ,[CreatedDate]                      
           ,[ModifiedBy]                      
           ,[ModifiedDate]                      
           ,[RecordDeleted]                      
           ,[DeletedBy])                      
     VALUES                      
           (                      
           @MessageID                      
           ,@ToStaffId                      
           ,@ToSystemDatabaseID                      
           ,@ToSystemStaffID                      
           ,@ToSystemStaffName                      
           ,@CreatedBy                      
           ,@CreatedDate                      
           ,@ModifiedBy                      
           ,@ModifiedDate                      
           ,null                    
           ,@DeletedBySender                      
           )                      
     End                 
     END                
                       
                                
END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSaveMessageRecordWise') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH                                   
 End 
 

GO


