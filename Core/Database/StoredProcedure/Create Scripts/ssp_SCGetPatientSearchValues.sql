IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPatientSearchValues]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetPatientSearchValues]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
    
CREATE PROCEDURE [ssp_SCGetPatientSearchValues] (    
 @SearchStart VARCHAR(25)    
 ,@SearchEnd VARCHAR(25)    
 )    
AS    
/*********************************************************************/    
/* Stored Procedure: dbo.ssp_SCGetPatientSearchValues            */    
/* Creation Date:    15/Apr/2015                 */    
/* Purpose:  It will return the data based on input @SearchStart and  @SearchEnd              */    
/*    Exec ssp_SCGetPatientSearchValues null,null,null                                             */    
/* Input Parameters:                           */    
/*  Date   Author   Purpose              */    
/* 15/Apr/2015  Gautam   Created              */    
/*********************************************************************/    
BEGIN    
 BEGIN TRY    
 IF len(@SearchStart)>2  
 BEGIN  
   SELECT @SearchStart + '%'   
   return   
 END  
  CREATE TABLE #StartSearchLetters (    
   Id INT identity(1, 1)    
   ,StartLetter VARCHAR(2)    
   ,EndLetter VARCHAR(2)    
   );    
    
  WITH LetterSequence    
  AS (    
   SELECT 1 N    
       
   UNION ALL    
       
   SELECT 2    
       
   UNION ALL    
       
   SELECT 3    
       
   UNION ALL    
       
   SELECT 4    
       
   UNION ALL    
       
   SELECT 5    
       
   UNION ALL    
       
   SELECT 6    
       
   UNION ALL    
       
   SELECT 7    
       
   UNION ALL    
       
   SELECT 8    
       
   UNION ALL    
       
   SELECT 9    
       
   UNION ALL    
       
   SELECT 10    
       
   UNION ALL    
       
   SELECT 11    
       
   UNION ALL    
       
   SELECT 12    
       
   UNION ALL    
       
   SELECT 13    
       
   UNION ALL    
       
   SELECT 14    
       
   UNION ALL    
       
   SELECT 15    
       
   UNION ALL    
       
   SELECT 16    
       
   UNION ALL    
       
   SELECT 17    
       
   UNION ALL    
       
   SELECT 18    
       
   UNION ALL    
       
   SELECT 19    
       
   UNION ALL    
       
   SELECT 20    
       
   UNION ALL    
       
   SELECT 21    
       
   UNION ALL    
       
   SELECT 22    
       
   UNION ALL    
       
   SELECT 23    
       
   UNION ALL    
       
   SELECT 24    
       
   UNION ALL    
       
   SELECT 25    
       
   UNION ALL    
       
   SELECT 26    
   )    
   ,DualLetter    
  AS (    
   SELECT LS1.N C1    
    ,LS2.N C2    
   FROM LetterSequence LS1    
   CROSS JOIN LetterSequence LS2    
   )    
  INSERT INTO #StartSearchLetters (    
   StartLetter    
   ,EndLetter    
   )    
  SELECT CHAR(64 + LS3.N)    
   ,NULL    
  FROM LetterSequence LS3    
      
  UNION ALL    
      
  SELECT CHAR(64 + C2)    
   ,CHAR(64 + C1)    
  FROM DualLetter    
    
  SELECT SS.StartLetter + isnull(SS.EndLetter, '') + '%'    
  FROM #StartSearchLetters SS    
  WHERE SS.id >= (    
    SELECT id    
    FROM #StartSearchLetters    
    WHERE StartLetter = CASE     
      WHEN LEN(@SearchStart) > 1    
       THEN LEFT(@SearchStart, 1)    
      ELSE @SearchStart    
      END    
     AND (    
      (    
       LEN(@SearchStart) > 1    
       AND EndLetter = CASE     
        WHEN LEN(@SearchStart) > 1    
         THEN right(@SearchStart, 1)    
        ELSE @SearchStart    
        END    
       )    
      OR (    
       LEN(@SearchStart) = 1    
       AND EndLetter IS NULL    
       )    
      )    
    )    
   AND SS.id <= (    
    SELECT id    
    FROM #StartSearchLetters    
    WHERE StartLetter = CASE     
      WHEN LEN(@SearchEnd) > 1    
       THEN LEFT(@SearchEnd, 1)    
      ELSE LEFT(@SearchEnd, 1)    
      END    
     AND (    
      (    
       LEN(@SearchEnd) > 1    
       AND EndLetter = CASE     
        WHEN LEN(@SearchEnd) > 1    
         THEN right(@SearchEnd, 1)    
        ELSE @SearchEnd    
        END    
       )    
      OR (    
       LEN(@SearchEnd) = 1    
       AND EndLetter IS NULL    
       )    
      )    
    )    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(max)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetPatientSearchValues') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
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

GO