    /****** Object:  StoredProcedure [dbo].[ssp_PAInsertNewImportedFile]    Script Date: 05/19/2014 10:01:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PAInsertNewImportedFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PAInsertNewImportedFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[ssp_PAInsertNewImportedFile]   
   @SenderId int,  
   @FileName varchar(100),  
   @FileText text,  
   @Acknowledgement997Text text,  
   @UserId int,  
   @CreatedBy varchar(30)  
--   @Import837FileId int output  
As                                                                                                                         
/******************************************************************************          
**  File:           
**  Name: ssp_PAInsertNewImportedFile          
**  Desc: Used to insert new record in import837files table by importing and processing the new file.         
**          
**  This template can be customized:          
**                        
**  Return values:Table containing   
**           
**  Called by: DataServices\**                        
**  Parameters:          
**  Input         Output          
**  @SenderId  
**  @FileName  
**  @FileText  
**  @UserId  
**  @CreatedBy  
**     
**  Auth:  Shruthi.S        
**  Date:  October 17,2014        
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:                   Author:        Description:          
    October 17,2014         Shruthi.S      Used to insert new record in import837files table by importing and processing the new file.Ref #124 CM to SC.
    May 08,2018		   Pradeep.A	   Introduced call to scsp_PAInsertNewImportedFile procedure to customize the ACK message.
*******************************************************************************/                                                                    
BEGIN                                                                                                                          
  
BEGIN TRY  
  
DECLARE @Import837FileId int  
BEGIN TRAN  


IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PAInsertNewImportedFile]')
          AND type IN(N'P', N'PC')
)
    BEGIN
        EXECUTE scsp_PAInsertNewImportedFile
                @SenderId,
                @FileName,
                @FileText,                
                @UserId,
                @CreatedBy,
			 @Acknowledgement997Text OUTPUT
    END;

-- Inserting new imported file.   
INSERT INTO [Import837Files]  
           ([Import837SenderId]  
           ,[FileName]  
           ,[ImportDate]  
           ,[FileText]  
           ,[Acknowledgement997Text]  
           ,[CreatedBy])  
     VALUES  
           (@SenderId,  
            @FileName,  
            getdate(),  
            @FileText,  
            @Acknowledgement997Text,  
            @CreatedBy)  
  
-- Fetching recently added identity value  
SET @Import837FileId = @@IDENTITY  
SELECT @Import837FileId AS Import837FileId  
  
-- Schema for Import837FileSegments table  
SELECT [Import837FileSegmentId]  
      ,[Import837FileId]  
      ,[FileLineNumber]  
      ,[Import837BatchId]  
      ,[BatchLineNumber]  
      ,[LineText]  
      ,[RowIdentifier]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
  FROM [Import837FileSegments]  
  WHERE 1>2  
  
-- Executing the procedure for processing the file.  
--EXEC ssp_PAProcess837FileImport @Import837FileId,@UserId  
COMMIT TRAN  
  
END TRY      
           
BEGIN CATCH         
   if @@tranCount <> 0 ROLLBACK TRAN   
   DECLARE @Error varchar(8000)           
   set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_PAInsertNewImportedFile]')           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())          
   RAISERROR           
   (           
    @Error, -- Message text.           
    16, -- Severity.           
    1 -- State.           
   )           
END CATCH    
     
END               
               
  