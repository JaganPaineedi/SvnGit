/****** Object:  StoredProcedure [dbo].[ssp_CMSaveAuthorizationDocumentMessages]    Script Date: 11/18/2011 16:25:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMSaveAuthorizationDocumentMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMSaveAuthorizationDocumentMessages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================          
-- Author:  Alok Kumar           
-- Create date: 16th-Feb-2017         
-- Description: To Insert the Record in to [ProviderAuthorizationDocumentMessages]          
-- =============================================          
CREATE PROCEDURE [dbo].[ssp_CMSaveAuthorizationDocumentMessages]    
                
@Subject varchar(700),                  
@Message text,       
              
@OtherRecipients varchar(2000),                  
@CreatedBy varchar(50),                  
@CreatedDate datetime,                  
@ModifiedBy varchar(30),                  
@ModifiedDate datetime,                                   
  
@FromSystemStaffName varchar(50),        
@MessageID int ,    
@ReferenceSystemDatabaseId int,  
@ProviderAuthorizationDocumentId int  
                                              
AS 

BEGIN
	BEGIN TRY
	
	INSERT INTO [ProviderAuthorizationDocumentMessages]  
			   ([CreatedBy]  
			   ,[CreatedDate]  
			   ,[ModifiedBy]  
			   ,[ModifiedDate]  
			   ,[RecordDeleted]  
			   ,[DeletedDate]  
			   ,[DeletedBy]  
			   ,[ProviderAuthorizationDocumentId]  
			   ,[MessageSystemDatabaseId]  
			   ,[MessageId]  
			   ,[SendingStaffName]  
			   ,[Recipients]  
			   ,[Subject]  
			   ,[Message])  
		 VALUES  
           (@CreatedBy   
           ,@CreatedDate  
           ,@ModifiedBy      
           ,@ModifiedDate   
           ,null  
           ,null  
           ,null  
           ,@ProviderAuthorizationDocumentId  
           ,@ReferenceSystemDatabaseId  
           ,@MessageID    
           ,@FromSystemStaffName  
           ,@OtherRecipients  
           ,@Subject   
           ,@Message)  
 	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMSaveAuthorizationDocumentMessages') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH
END
GO
