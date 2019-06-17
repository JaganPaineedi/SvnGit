

/****** Object:  StoredProcedure [dbo].[SSP_RDLRevertEpisodeDischarge]    Script Date: 10/24/2016 13:11:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_RDLRevertEpisodeDischarge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_RDLRevertEpisodeDischarge]
GO


/****** Object:  StoredProcedure [dbo].[SSP_RDLRevertEpisodeDischarge]    Script Date: 10/24/2016 13:11:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[SSP_RDLRevertEpisodeDischarge](  
@Client_Id INT,  
@RegistrationDate Datetime  
)  
 /********************************************************************************                                                                            
-- Stored Procedure: dbo.SSP_RDLRevertEpisodeDischarge.sql                                                                              
--                                                                            
-- Copyright: Streamline Healthcate Solutions                                                                            
--                                                                            
-- Purpose: Used to update Client Episode status                  
--                                                                            
-- Updates:                                                                                                                                   
-- Date			Author				Purpose      
  10/24/2016    MD Hussain Khusro   Created
***********************************************************************************/  
AS  
  
BEGIN 
    BEGIN TRY 
        DECLARE @Message VARCHAR(200) 
		DECLARE @ClientEpisodeId INT
		SET @ClientEpisodeId = (SELECT TOP 1 ClientEpisodeId FROM ClientEpisodes 
								WHERE ClientId=@Client_Id AND ISNULL(RecordDeleted,'N')='N' 
								ORDER BY EpisodeNumber DESC)

		IF EXISTS(SELECT 1 
				FROM   ClientEpisodes 
				WHERE  ClientId = @Client_Id 
					   AND [Status] IN ( 100, 101 ) AND ISNULL(RecordDeleted,'N')='N') 
		        SET @Message = 'Client has an open episode.' 
		
		ELSE IF EXISTS(SELECT 1 
				FROM   ClientEpisodes 
				WHERE  Cast(RegistrationDate AS DATE) > Cast(@RegistrationDate AS DATE) 
					   AND ClientEpisodeId = @ClientEpisodeId AND ISNULL(RecordDeleted,'N')='N') 
			    SET @Message = 'Discharge status can be removed only from the most recent episode.' 
			            
        ELSE IF EXISTS(SELECT 1 
                  FROM   ClientEpisodes 
                  WHERE  ClientEpisodeId = @ClientEpisodeId
                         AND NOT EXISTS (SELECT 1 
                                         FROM   ClientEpisodes 
                                         WHERE  ClientId = @Client_Id 
                                                AND [Status] IN ( 100, 101 ) AND ISNULL(RecordDeleted,'N')='N' )) 
          BEGIN 
              UPDATE ClientEpisodes 
              SET    [Status] = 101, 
                     DischargeDate = NULL,
                     ModifiedBy = 'RevertEpisodeReport',
                     ModifiedDate = GETDATE()
              WHERE  ClientEpisodeId = @ClientEpisodeId
					 AND Cast(RegistrationDate AS DATE) = Cast(@RegistrationDate AS DATE) 
                     AND [Status] = 102
                     AND ISNULL(RecordDeleted,'N')='N' 

              SET @Message = 'Reverted Client Episode Status from Discharged to In Treatment Successfully.' 
		  END 
		  
		  ELSE 
		        SET @Message = 'No record found.' 

		  SELECT @Message AS [Message] 
	END TRY 

    BEGIN CATCH 
        DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'SSP_RDLRevertEpisodeDischarge') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 

        RAISERROR ( @Error, 
                    -- Message text.                                                                                        
                    16, 
                    -- Severity.                                                                                        
                    1 
        -- State.                                                                                        
        ); 
    END CATCH 
END 
  
GO


