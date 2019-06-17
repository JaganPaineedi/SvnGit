IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCErrorServiceDocuments]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_SCErrorServiceDocuments]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROC ssp_SCErrorServiceDocuments(
 @DocumentId INT,@StaffId int)

AS
/*==============================================================================          
--Stored Procedure: dbo.ssp_SCErrorServiceDocuments                     
--Copyright: 2017 Streamline Healthcare Solutions,  LLC                   
--Creation Date:    5/12/2017                                              
--CreatedBy: PranayB
--Purpose: Updated the Serive Status to Error 76 and Document Status
--Input Parameters:@DocumentId - DocumentId        
-- Output Parameters:   None                              
--Return: DocumentScreenId                     
--Data Modifications:                                                    
--Date                Author       Purpose                                             
 07/24/2017           Pranay       Added DocumentScreenId w.r.t Task#857 Harbor-To open the Error Document with "Error" WaterMark
 07/25/2017           Pranay       Added @Success
================================================================================*/     
BEGIN 
 DECLARE @ServiceId int
 DECLARE @UserCode VARCHAR(20)
 DECLARE @Success INT = 0
 
SET @UserCode =(SELECT UserCode FROM dbo.Staff WHERE StaffId=@StaffId AND ISNULL(RecordDeleted,'N')='N')
IF (@DocumentId IS NOT NULL)
 BEGIN TRY
   BEGIN
     UPDATE Documents SET Status=26 ,CurrentVersionStatus=26,RecordDeleted=NULL,ModifiedBy=@UserCode WHERE DocumentId=@DocumentId   
      IF(@ServiceId IS NOT NULL)
       BEGIN
         UPDATE services SET [Status]=76,ModifiedBy=@UserCode WHERE ServiceId=@ServiceId
       END 
     SET @Success=1
  END
 
 IF(@Success!=0)
    SELECT  sr.ScreenId AS DocumentScreenId FROM documents d 	
                      LEFT JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId AND ISNULL(sr.RecordDeleted,'N')='N'
	                  WHERE d.DocumentId = @DocumentId and isnull(d.RecordDeleted, 'N') = 'N' 
END TRY

 BEGIN CATCH                                                      
            DECLARE @Error VARCHAR(8000)                                                                                                 
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCErrorServiceDocuments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                   
            RAISERROR                                                                                                     
  (                                                                                                   
   @Error, -- Message text.                                                                                                                     
   16, -- Severity.                                                                                                                                
   1 -- State.                                                         
  );                                                                                                                              
        END CATCH              
END

GO

