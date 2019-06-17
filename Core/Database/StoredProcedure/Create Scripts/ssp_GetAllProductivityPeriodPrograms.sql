IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_GetAllProductivityPeriodPrograms]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].ssp_GetAllProductivityPeriodPrograms 

GO 

/****** Object:  StoredProcedure [dbo].[ssp_GetAllProductivityPeriodPrograms]    Script Date: 01/28/2018 15:24:58 ******/ 
SET ansi_nulls ON 

GO 

SET quoted_identifier ON 

GO 

CREATE PROCEDURE [DBO].[ssp_GetAllProductivityPeriodPrograms] 
AS 
/*****************************************************************/ 
/* Stored Procedure: dbo.ssp_GetAllProductivityPeriodPrograms    */ 
/* Creation Date:  07-March-2012                                 */ 
/* Created By: Jagdeep Hundal                                    */ 
/* Purpose: To  Get all programs list for Productivity Period    */ 
/*                                                               */ 
/* Input Parameters:                                             */ 
/*                                                               */ 
/* Output Parameters:                                            */ 
/*                                                               */ 
/*  Date                  Author                 Purpose         */ 
/*  24-06-2014        katta sharat kumar Added Order by ProgramName with ref to task#1494-Core Bugs*/ 
/*  28/01/2018   Chita Ranjan   What: Modified select statement to get all the programs mapped into 'TEAMPRODUCTIVITYPROGRAMTYPE' recode category instead of pulling it from OrganizationLevels.
                                Why: CCC - Customizations #35 */
  /*****************************************************************/ 
  BEGIN 
      BEGIN TRY 
          --DECLARE @LevelNumber INT 

          --SET @LevelNumber=(SELECT OrganizationLevelTypes.LevelNumber - 1 AS 
          --                         'LevelNumber' 
          --                  FROM   OrganizationLevelTypes 
          --                  WHERE  ProgramLevel = 'Y' 
          --                         AND Isnull(RecordDeleted, 'N') = 'N') 

          --IF( @LevelNumber > 0 ) 
          --  BEGIN 
          --      SELECT ProgramId=OL.OrganizationLevelId, 
          --             ProgramName=OL.LevelName 
          --      FROM   OrganizationLevels OL 
          --             INNER JOIN OrganizationLevelTypes OLT 
          --                     ON OLT.LevelTypeId = OL.LevelTypeId 
          --      WHERE  OLT.LevelNumber = @LevelNumber 
          --             AND Isnull(OLT.RecordDeleted, 'N') = 'N' 
          --             AND Isnull(OL.RecordDeleted, 'N') = 'N' 
          --      ORDER  BY ProgramName 

		  SELECT DISTINCT P.ProgramId, P.ProgramCode From Programs P 
		  WHERE EXISTS (SELECT * FROM dbo.Ssf_recodevaluescurrent('TEAMPRODUCTIVITYPROGRAMTYPE') AS CD 
						WHERE  CD.IntegercodeId = P.ProgramId)
						AND Isnull(P.RecordDeleted, 'N') = 'N'
            
      END TRY 
	  
      --Checking For Errors    
      BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetAllProductivityPeriodPrograms') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                                           
				16
				,-- Severity.                                           
				1 -- State.                                           
				);
	END CATCH 
  END 