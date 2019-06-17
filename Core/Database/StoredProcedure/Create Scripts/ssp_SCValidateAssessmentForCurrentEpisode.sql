/****** Object:  StoredProcedure [dbo].[ssp_SCValidateAssessmentForCurrentEpisode]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateAssessmentForCurrentEpisode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateAssessmentForCurrentEpisode]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCValidateAssessmentForCurrentEpisode]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

/**********************************************************

***********/  
/* Stored Procedure: 

[ssp_SCValidateAssessmentForCurrentEpisode]              */ 

 
/* Date              Author                  Purpose        

          */  
/* 08/26/2015         snadavati            To Validate the Assessment for Current Episode based on requirement #616 Network180 Env. Issues Tracking   **/  
/**********************************************************

***********/  
/**  Change History **/                                     

                                      
/***********************************************************/    
  
CREATE PROCEDURE [dbo].[ssp_SCValidateAssessmentForCurrentEpisode]@clientId INT
   
AS  
BEGIN  
 BEGIN TRY  
  if OBJECT_ID('scsp_SCValidateAssessmentForCurrentEpisode','p')is NOT NULL
  Begin
 Exec scsp_SCValidateAssessmentForCurrentEpisode  @clientId
  END
 END TRY   
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + 

Convert(VARCHAR(4000), ERROR_MESSAGE())  
   + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 

'ssp_SCValidateAssessmentForCurrentEpisode')  
    + '*****' + Convert(VARCHAR, ERROR_LINE()) + 

'*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) 

+   
    '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error /* Message text*/  
    ,16 /*Severity*/  
    ,1 /*State*/  
    )  
 END CATCH  
END
GO


