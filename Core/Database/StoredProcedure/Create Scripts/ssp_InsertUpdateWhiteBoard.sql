IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_InsertUpdateWhiteBoard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_InsertUpdateWhiteBoard]
GO
/********************************************************************************                                          
-- Stored Procedure: dbo.ssp_InsertUpdateWhiteBoard                                            
-- Copyright: Streamline Healthcate Solutions                                          
-- Purpose: used to update and insert the whiteboard info                                       
-- Updates:                                                                                                 
-- Date        Author				Purpose                                          
-- 21.06.2013  Praveen Potnuru		Created.      
*********************************************************************************/  
 
CREATE Procedure [dbo].[ssp_InsertUpdateWhiteBoard]     
@WhiteBoardInfoId int,
@ClientId int, 
@MiscellaneousText varchar(500), 
@DandA int, 
@CreatedBy varchar(30), 
@CreatedDate datetime, 
@ModifiedBy varchar(30), 
@ModifiedDate datetime, 
@RecordDeleted varchar(1), 
@DeletedDate datetime, 
@DeletedBy varchar(30),
@ClientInpatientVisitId INT,
@LegalStatus int,
@CompetencyStatus int,
@PaperToCourt datetime
AS

BEGIN TRY 
BEGIN TRAN
IF @WhiteBoardInfoId=0
BEGIN
INSERT INTO [WhiteBoard]
           ([ClientId]
           ,[MiscellaneousText]
           ,[DandA]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedDate]
           ,[DeletedBy]
           ,[ClientInpatientVisitId]
		   ,[LegalStatus]
		   ,[CompetencyStatus]
		   ,[PapersToCourt]
           )
           VALUES (
					@ClientId , 
					NULLIF(@MiscellaneousText,'') , 
					NULLIF(@DandA,0) , 
					@CreatedBy , 
					@CreatedDate , 
					@ModifiedBy , 
					@ModifiedDate , 
					@RecordDeleted , 
					@DeletedDate , 
					@DeletedBy,
					@ClientInpatientVisitId,
					@LegalStatus,
					@CompetencyStatus,
					@PaperToCourt  
                   )
END
ELSE 
BEGIN
UPDATE WhiteBoard   SET
					ClientId =@ClientId, 
					MiscellaneousText  =NULLIF(@MiscellaneousText,''), 
					DandA  =NULLIF(@DandA,0),  
					ModifiedBy =@ModifiedBy, 
					ModifiedDate =@ModifiedDate,
					RecordDeleted =@RecordDeleted, 
					DeletedDate =@DeletedDate,
					DeletedBy =@DeletedBy,
					ClientInpatientVisitId=@ClientInpatientVisitId,
					LegalStatus = @LegalStatus,
					CompetencyStatus = @CompetencyStatus,
					PapersToCourt = @PaperToCourt
					WHERE 
					WhiteBoardInfoId=@WhiteBoardInfoId
END		
COMMIT TRAN
END try                                                                                                             
BEGIN CATCH                
IF @@TRANCOUNT > 0
BEGIN
ROLLBACK TRAN 

END                                       
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InsertUpdateWhiteBoard')                                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                                       
 RAISERROR                                                                                                         
 (                                                              
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                     
  1 -- State.                                                                                                        
 );                                                                                                      
END CATCH       		