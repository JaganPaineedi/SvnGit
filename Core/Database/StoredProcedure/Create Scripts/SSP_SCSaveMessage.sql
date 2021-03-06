/****** Object:  StoredProcedure [dbo].[SSP_SCSaveMessage]    Script Date: 11/18/2011 16:25:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCSaveMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCSaveMessage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO                      
                      
CREATE PROCEDURE [dbo].[SSP_SCSaveMessage]                                                                          
	  @FromStaffId int,                                    
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
    --modified by priya        
   -- @ToSystemDatabaseID varchar(max),                        
	 @ToSystemStaffID int,                          
	 @ToSystemStaffName varchar(50),                          
     @FromSystemDatabaseID int,                          
	 @FromSystemStaffID int,                          
	 @FromSystemStaffName varchar(50),                          
	 @SenderCopy char(1),                          
	 @ReceiverCopy char(1),                        
	 @MessageIDInserted int ,                        
	 @ToStaffIDConcatenated varchar(max),                        
	 @SenderName varchar(50),                        
	 @ReceiverName varchar(50) ,                      
	 @ReferenceSystemDatabaseId int,                    
	 @ScreenId int, --added By priya                        
	 @SameOrganizationDataBaseId char(1),  
	 @PartOfClientRecord  char(1),  --added by Priya    
	 @ProviderAuthorizationDocumentId int = 0    --added by Alok Kumar                                                                    
AS                                      
                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.SSP_SCSaveMessage                */                                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                        
/* Creation Date:    18/01/2010                                         */                                        
/*                                                                   */                                        
/* Purpose: It is used to change the message and Alert status, it @varType=1 then it update message otherwise alerts      */                                       
/*                                                                   */                                      
/* Input Parameters: @varMessageid, @varType                */                                      
/*                                                                   */                                        
/* Output Parameters:   None    */                                        
/*                                                                   */      
/* Return:  0=success, otherwise an error number                     */                                        
/*                                                        */                                        
/* Called By:                                   */                                        
/*                                                                   */                                        
/* Calls:                                                   */                                        
/*                        */                                        
/* Data Modifications:                                               */                                   
/*                                                                   */                                        
/* Updates:                                                       */                                        
/*  Date     Author       Purpose              */                                        
/* 8/1/05   Vikas     Created                                        */                               
/*Modifications History :            */                            
/* 18/7/201 Mahesh S Added new parameter @MessageDocumentId which first use in send message from Authorization details*/              
/* 14/3/2011 Priya  Added 2 new parameter @ScreenId and @SameOrganizationDataBaseId required for UM Messages*/    
/* 05/22/2014	Chethan	Reverted the latest change to previous to Making the reply/sent functionality work.*/  
/* 02/16/2017	Alok Kumar	Added one more parameter @ProviderAuthorizationDocumentId Ref: Task# 1121  	SWMBH - Support.*/ 
/* 02 July 2018	Vithobha Added @ProviderAuthorizationDocumentId as parameter to ssp_SCSaveMessageRecordWise for SWMBH - Support #1121 */ 
/*********************************************************************/                                         
BEGIN
	BEGIN TRY                                     
--BEGIN TRAN                          
Declare @MessageID int                           
SET @MessageID=-1                             
   --added By priya for UM Messages                
   declare @allreceipients varchar(2000)                
   set @allreceipients=@OtherRecipients                
   --end                     
declare @Index int                                
    declare @ToStaffIDValue varchar(8000)                          
                            
   if(@ReferenceType =0)                      
   set @ReferenceType=null                      
   if(@ReferenceSystemDatabaseId =0)                      
   set @ReferenceSystemDatabaseId=null                         
                                          
  exec  dbo.ssp_SCSaveMessageRecordWise @FromStaffId,Null,@ClientId,@Unread,@DateReceived,@Subject,@Message,                        
  @Priority,@Reference, @ReferenceLink,@DeletedBySender,Null,@CreatedBy,@CreatedDate ,@ModifiedBy,@ModifiedDate,@RecordDeleted,                        
  @ReferenceId,@ReferenceType,null,null,null,-1,null,null,'Y',null,@MessageIDInserted,@ReferenceSystemDatabaseId,@PartOfClientRecord                       
                          
       Select @MessageIDInserted=@@IDENTITY                           
       Print @MessageIDInserted            
		--added By Priya          
        if(@ScreenId in(96, 15 ,973))                   
		begin       
			IF(@ReferenceId  > 0 and @ScreenId=96 and @SameOrganizationDataBaseId='Y')                      
			begin                  
				exec ssp_SCSaveAuthorizationDocumentMessages @Subject,@Message,@allreceipients,@CreatedBy ,@CreatedDate,@ModifiedBy,@ModifiedDate,@SenderName ,@MessageID,null,@ReferenceId                 
			end
			IF(@ProviderAuthorizationDocumentId > 0)     --02/16/2017	Alok Kumar                 
			begin                  
				exec ssp_CMSaveAuthorizationDocumentMessages @Subject,@Message,@allreceipients,@CreatedBy ,@CreatedDate,@ModifiedBy,@ModifiedDate,@SenderName ,@MessageIDInserted,null,@ProviderAuthorizationDocumentId                 
			end
		end       
		--end                     
    select @Index = 1                                
        if len(@ToStaffIDConcatenated)<1 or @ToStaffIDConcatenated is null  return                                
       declare @RecordSelected int                        
       set @RecordSelected=-1                        
    while @Index!= 0                                
    begin                           
    declare @OtherRecepientsValue varchar(max)                        
         set @RecordSelected=@RecordSelected+1                        
     set @OtherRecepientsValue=dbo.fn_FetchOtherRecepients(@OtherRecipients,@RecordSelected)     
        
                             
        set @Index = charindex(',',@ToStaffIDConcatenated)                                
        if @Index!=0                                
            set @ToStaffIDValue = left(@ToStaffIDConcatenated,@Index - 1)                                
        else                                
            set @ToStaffIDValue = @ToStaffIDConcatenated                             
                                   
        if(len(@ToStaffIDValue)>0)                           
        Begin                        
                                
           set @ToStaffIDConcatenated = right(@ToStaffIDConcatenated,len(@ToStaffIDConcatenated) - @Index)                         
           if(CHARINDEX('_',@ToStaffIDValue)=0)                        
           Begin                        
                                   
                                  
            exec  dbo.ssp_SCSaveMessageRecordWise @FromStaffId,@ToStaffIDValue,@ClientId,@Unread,@DateReceived,@Subject,@Message,@Priority,@Reference,                        
                          
  @ReferenceLink,@DeletedBySender,@OtherRecepientsValue,@CreatedBy,@CreatedDate,@ModifiedBy,@ModifiedDate,@RecordDeleted,@ReferenceId,@ReferenceType,                        
  null,null,null,null,null,null,null,'Y',@MessageIDInserted ,@ReferenceSystemDatabaseId,@PartOfClientRecord,@ProviderAuthorizationDocumentId  --02 July 2018	Vithobha                    
                         
           End                        
             else                        
             Begin                        
             Declare @StaffID int                        
             set @StaffID=0                        
             declare @DatabaseID int                        
             Declare @Index_ int                        
             set @Index_=CHARINDEX('_',@ToStaffIDValue)                        
                                     
             set @StaffID = Convert(int,LEFT(@ToStaffIDValue,@Index_-1))                        
             set @DatabaseID=RIGHT(@ToStaffIDValue,LEN(@ToStaffIDValue)-@Index_)                        
             -- print   @DatabaseID                     
  --           exec  dbo.ssp_SCSaveMessageRecordWise @FromStaffId,Null,@ClientId,@Unread,@DateReceived,@Subject,@Message,@Priority,@Reference,                                            
  --@ReferenceLink,@DeletedBySender,@OtherRecepientsValue,@CreatedBy,@CreatedDate,@ModifiedBy,@ModifiedDate,@RecordDeleted,@ReferenceId,@ReferenceType,                        
  --@ToSystemDatabaseID,@StaffID,@ReceiverName,null,null,null,null,''Y'',@MessageIDInserted,@ReferenceSystemDatabaseId         
  --modified by priya change the parameter @ToSystemDatabaseID with  @DatabaseID      
  exec  dbo.ssp_SCSaveMessageRecordWise @FromStaffId,Null,@ClientId,@Unread,@DateReceived,@Subject,@Message,@Priority,@Reference,                   
                        
  @ReferenceLink,@DeletedBySender,@OtherRecepientsValue,@CreatedBy,@CreatedDate,@ModifiedBy,@ModifiedDate,@RecordDeleted,@ReferenceId,@ReferenceType,                        
  @DatabaseID,@StaffID,@ReceiverName,null,null,null,null,'Y',@MessageIDInserted,@ReferenceSystemDatabaseId,@PartOfClientRecord, @ProviderAuthorizationDocumentId         --02 July 2018	Vithobha                            
                          
             End                        
                           
                                 
        end                              
        if len(@ToStaffIDConcatenated) = 0 break                          
    end                            
                        
END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCSaveMessage') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
