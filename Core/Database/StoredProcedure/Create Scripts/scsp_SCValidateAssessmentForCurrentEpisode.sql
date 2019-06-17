/****** Object:  StoredProcedure [dbo].[scsp_SCValidateAssessmentForCurrentEpisode]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCValidateAssessmentForCurrentEpisode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCValidateAssessmentForCurrentEpisode]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCValidateAssessmentForCurrentEpisode]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

/**********************************************************

***********/  
/* Stored Procedure: 

[scsp_SCValidateAssessmentForCurrentEpisode]              */ 

 
/* Date              Author                  Purpose        

          */  
/* 08/26/2015        snadavati             To Validate the Assessment for Current Episode   */  
/* 09/14/2015		 Deej				Changed the logic in invoking csp */
/*****************************************************************************************************/  
   
  
CREATE PROCEDURE [dbo].[scsp_SCValidateAssessmentForCurrentEpisode](@clientId INT)
   
AS  
BEGIN  
 BEGIN TRY  
	IF OBJECT_ID('csp_SCValidateAssessmentForCurrentEpisode', 'p') IS NOT NULL
	BEGIN
		EXEC csp_SCValidateAssessmentForCurrentEpisode @clientId
	END
	ELSE
	BEGIN
		SELECT 1 AS NoofItems
	END 
 END TRY   
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + 

Convert(VARCHAR(4000), ERROR_MESSAGE())  
   + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 

'scsp_SCValidateAssessmentForCurrentEpisode')  
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


