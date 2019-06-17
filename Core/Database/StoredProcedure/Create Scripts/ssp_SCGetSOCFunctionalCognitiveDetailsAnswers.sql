/****** Object:  StoredProcedure [dbo].[ssp_SCGetSOCFunctionalCognitiveDetailsAnswers]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_SCGetSOCFunctionalCognitiveDetailsAnswers'
		)
	DROP PROCEDURE [dbo].[ssp_SCGetSOCFunctionalCognitiveDetailsAnswers]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSOCFunctionalCognitiveDetailsAnswers]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetSOCFunctionalCognitiveDetailsAnswers] @ClientId INT  
 ,@Startdate DATE  
 ,@EndDate DATE  
 ,@Type VARCHAR(1)  
 ,@OrderName VARCHAR(500)  
AS /*********************************************************************/  
/* Stored Procedure: dbo.ssp_SCGetSOCFunctionalCognitiveDetailsAnswers            */  
/* Creation Date:    22/Aug/2017                */  
/* Purpose:  To Get summary Of care Functional, Cognitive ,Assessment and Plan of Treatment                */  
/*    Exec ssp_SCGetSOCFunctionalCognitiveDetailsAnswers                                              */  
/* Input Parameters:                           */  
/* Date   Author   Purpose              */  
/* 22/Aug/2017  Gautam   Created           Certification MU3   */ 
/* 12/Dec/2017	Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care */
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  CREATE TABLE #FunctionalCognitiveDetailsAnswers (  
   QuestionId INT  
   ,Question VARCHAR(300)  
   ,answer VARCHAR(max)  
   ,OrderName VARCHAR(500)  
   ,SNOMEDCode VARCHAR(50)  
   )  
  
  IF EXISTS (  
    SELECT *  
    FROM sys.objects  
    WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSOCFunctionalCognitiveDetailsAnswers]')  
     AND type IN (  
      N'P'  
      ,N'PC'  
      )  
    )  
  BEGIN  
   EXEC csp_SCGetSOCFunctionalCognitiveDetailsAnswers @ClientId  
    ,@Startdate  
    ,@EndDate  
    ,@Type  
    ,@OrderName  
  END  
  
  SELECT QuestionId  
   ,Question  
   ,answer  
   ,OrderName  
   ,SNOMEDCode  
  FROM #FunctionalCognitiveDetailsAnswers  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(max)  
  
  SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCGetSOCFunctionalCognitiveDetailsAnswers') + '*****' + convert(VARCHAR, error_line()) + '****
*' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())  
  
  RAISERROR (  
    @Error  
    ,  
    -- Message text.                         
    16  
    ,  
    -- Severity.                                                                                                           
    1  
    -- State.                                                                                                           
    );  
 END CATCH  
END  

