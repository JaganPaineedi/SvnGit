IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClinicianMeaningfulSubGlobalCodes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClinicianMeaningfulSubGlobalCodes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
              
 CREATE PROCEDURE [dbo].[ssp_GetClinicianMeaningfulSubGlobalCodes] @GlobalCodeId VARCHAR(MAX)            
 ,@InPatient BIT            
 ,@Stage VARCHAR(10) = NULL            
 /********************************************************************************                    
-- Stored Procedure: dbo.ssp_GetClinicianMeaningfulSubGlobalCodes    8697,0, 9373                
--                   
-- Copyright: Streamline Healthcate Solutions                 
--                    
-- Updates:                                                                           
-- Date   Author   Purpose                    
-- 30-Jul-2014  Revathi  What:GetMeaningfulSubGlobalCodes.                          
--      Why:task #25.3 MeaningFul Use                
-- 11-Jan-2016  Ravi     What : Change the code for Stage 9373 'Stage2 - Modified' requirement            
       why : Meaningful Use, Task #66 - Stage 2 - Modified              
-- 04-May-2017  Ravi What : added the code for SubMeasure 6261 'Measure 1 2017' for Patient Portal(8697)             
      why : Meaningful Use - Stage 3  # 39     
-- 14-Nov-2018  Gautam   What: Added code to include Lab and Radiology for MU Stage2 modified.
--              Meaningful Use - Environment Issues Tracking > Tasks#5 > Stage 2 Modified Report - Non-Face to Face services counted in denominator counts                   
*********************************************************************************/            
AS            
BEGIN            
 DECLARE @MeaningfulUseStageLevel VARCHAR(10)            
            
 IF @Stage IS NULL            
 BEGIN            
  SELECT TOP 1 @MeaningfulUseStageLevel = Value            
  FROM SystemConfigurationKeys            
  WHERE [key] = 'MeaningfulUseStageLevel'            
   AND ISNULL(RecordDeleted, 'N') = 'N'            
 END            
 ELSE            
 BEGIN            
  SET @MeaningfulUseStageLevel = @Stage            
 END            
            
 IF @InPatient = 1            
 BEGIN            
  SELECT GS.GlobalSubCodeId            
   ,GS.SubCodeName + '(H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item = GS.GlobalCodeId            
   AND ISNULL(GS.RecordDeleted, 'N') = 'N' -- 8665 (CPOE)                    
   AND TEMP.item IN (            
    8709            
    ,8680            
    ,8686            
    ,8688            
    ,8694            
    ,8698            
    ,8699            
    ,8682            
    ,8683            
    ,8704            
    ,8705            
    ,8706            
    )            
   AND GS.GlobalSubCodeId IN (            
    CASE             
     WHEN (            
       @MeaningfulUseStageLevel = 8766            
       -- 11-Jan-2016  Ravi            
       OR @MeaningfulUseStageLevel = 9373 OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477       
       OR @MeaningfulUseStageLevel = 9480     OR @MeaningfulUseStageLevel = 9481        
       )            
      AND TEMP.item = 8680            
      THEN 6177            
     ELSE GS.GlobalSubCodeId            
     END            
    )            
              
  UNION            
              
  SELECT 3 AS GlobalSubCodeId            
   ,'Measure 1(H) ' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8708)            
   AND (            
    @MeaningfulUseStageLevel = 8767            
    -- 11-Jan-2016  Ravi            
    OR @MeaningfulUseStageLevel = 9373            
    )            
              
  UNION            
              
  SELECT 4 AS GlobalSubCodeId            
   ,'Measure Alt(H) ' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8708)            
   AND (            
    @MeaningfulUseStageLevel = 8767            
    -- 11-Jan-2016  Ravi            
    OR @MeaningfulUseStageLevel = 9373            
    )            
              
  UNION            
              
  SELECT 3 AS GlobalSubCodeId            
   ,'Medication Alt(H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8680)            
   AND @MeaningfulUseStageLevel = 8766            
              
  UNION            
              
  SELECT 6213 AS GlobalSubCodeId            
   ,'No Measure Sub Type' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8700)            
   AND @MeaningfulUseStageLevel = 8766            
              
  UNION            
              
  SELECT 6213 AS GlobalSubCodeId            
   ,'Measure 1 (H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8700)            
   AND @MeaningfulUseStageLevel = 8767            
              
  UNION            
              
  SELECT 6214 AS GlobalSubCodeId            
   ,'Measure 2 (H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8700)            
   AND (            
    @MeaningfulUseStageLevel = 8767            
    -- 11-Jan-2016  Ravi            
    OR @MeaningfulUseStageLevel = 9373            
    )            
              
  UNION            
              
  SELECT 6211 AS GlobalSubCodeId            
   ,'Measure 1 (H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND (            
    @MeaningfulUseStageLevel = 8767            
    -- 11-Jan-2016  Ravi            
    --OR @MeaningfulUseStageLevel = 9373  -- 04-May-2017            
    )            
              
  -- Measure 1 2017     -- 04-May-2017  Ravi            
  UNION            
              
  SELECT 6211 AS GlobalSubCodeId            
   ,'Measure 1 2016 (H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND (            
     @MeaningfulUseStageLevel = 9373  OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477      
     OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481          
    )            
              
              
  UNION            
              
  SELECT 6261 AS GlobalSubCodeId            
   ,'Measure 1 2017 (H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND (            
     @MeaningfulUseStageLevel = 9373  OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477      
     OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481           
    )            
              
  UNION            
              
  SELECT 6212 AS GlobalSubCodeId            
   ,'Measure 2 (H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND (            
    @MeaningfulUseStageLevel = 8767            
    OR @MeaningfulUseStageLevel = 9373  OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477     
    OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481            
    )            
              
  UNION            
              
  SELECT 0 AS GlobalSubCodeId            
   ,'No Measure Sub Type' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8710,8703)            
   AND (@MeaningfulUseStageLevel = 9373   OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477    
   OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481   )          
            
    UNION            
              
  SELECT 0 AS GlobalSubCodeId            
   ,'No Measure Sub Type' AS SubCodeName            
  FROM GlobalSubCodes GS     
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND @MeaningfulUseStageLevel = 8766            
               
  UNION            
              
  SELECT 1 AS GlobalSubCodeId            
   ,'Measure 1 (ALL)(H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8687)            
  -- union                
  --SELECT 2    as GlobalSubCodeId                 
  --,'Measure 2 (HW)(H)' as SubCodeName                
  --  FROM GlobalSubCodes GS                  
  --cross apply dbo.fnSplit(@GlobalCodeId,',')  as temp where temp.item in (8687)              
  -- union                
  --SELECT 6    as GlobalSubCodeId                 
  --, 'Measure 3 (BP)(H)' as SubCodeName                
  --  FROM GlobalSubCodes GS                  
  --cross apply dbo.fnSplit(@GlobalCodeId,',')  as temp where temp.item in (8687)              
              
  UNION            
              
  SELECT 1 AS GlobalSubCodeId            
   ,'Advance Directives - 65 Years+ Admitted Hospital (H)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8707)            
  --union                
  --SELECT 2 as GlobalSubCodeId                  
  --,'Advance Directives - 65 Years+ Not Admitted Hospital (H)' as SubCodeName                
  --FROM GlobalSubCodes GS                   
  --cross apply dbo.fnSplit(@GlobalCodeId,',')  as temp where temp.item in (8707) and @MeaningfulUseStageLevel=8767                
              
  --UNION            
              
  --SELECT 5 AS GlobalSubCodeId            
  -- ,'Measure 1 (H)' AS SubCodeName            
  --FROM GlobalSubCodes GS            
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  --WHERE TEMP.item IN (8683)            
              
  UNION            
              
  SELECT 0 AS GlobalSubCodeId            
   ,'No Measure Sub Type' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item NOT IN (            
    8680            
    ,8683            
    ,8687            
    ,8697            
    ,8700            
    ,8707            
    ,8708            
    )            
 END            
 ELSE            
 BEGIN            
  SELECT GS.GlobalSubCodeId            
   ,GS.SubCodeName            
FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item = GS.GlobalCodeId            
   AND ISNULL(GS.RecordDeleted, 'N') = 'N' -- 8665 (CPOE)                 
   AND TEMP.item NOT IN (            
    8687            
    ,8683            
    ,8700            
    ,8697            
    )            
   AND GS.GlobalSubCodeId IN (            
    CASE             
     WHEN (            
       @MeaningfulUseStageLevel = 8766            
       --OR @MeaningfulUseStageLevel = 9373            
       )            
      AND TEMP.item = 8680            
      THEN 6177            
     ELSE GS.GlobalSubCodeId            
     END            
    )            
              
  UNION            
              
  SELECT 3 AS GlobalSubCodeId            
   ,'Medication Alt' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8680)            
   AND @MeaningfulUseStageLevel = 8766            
              
  UNION            
              
  SELECT 6213 AS GlobalSubCodeId            
   ,'No Measure Sub Type' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8700)            
   AND @MeaningfulUseStageLevel = 8766            
              
  UNION            
              
  SELECT 6213 AS GlobalSubCodeId            
   ,'Measure 1' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8700)            
   AND (@MeaningfulUseStageLevel = 8767  or @MeaningfulUseStageLevel = 9373 OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477     
   OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481  )              
              
  UNION            
              
  SELECT 6214 AS GlobalSubCodeId            
   ,'Measure 2 ' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8700)            
   AND (        
    @MeaningfulUseStageLevel = 8767            
    OR @MeaningfulUseStageLevel = 9373            
    )            
              
  UNION            
              
  SELECT 6211 AS GlobalSubCodeId            
   ,'Measure 1' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND (            
    @MeaningfulUseStageLevel = 8767            
   -- OR @MeaningfulUseStageLevel = 9373    -- 04-May-2017  Ravi            
    )            
              
              
  -- Measure 1 2017     -- 04-May-2017  Ravi            
  UNION            
              
  SELECT 6211 AS GlobalSubCodeId            
   ,'Measure 1 2016' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND (            
       @MeaningfulUseStageLevel = 9373 OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477      
       OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481           
    )            
              
              
  UNION             
            
  SELECT 6261 AS GlobalSubCodeId            
  ,'Measure 1 2017' AS SubCodeName            
  FROM GlobalSubCodes GS        
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
  AND (            
   @MeaningfulUseStageLevel = 9373 OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477      
   OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481           
  )            
                
              
  UNION            
              
  SELECT 6212 AS GlobalSubCodeId            
   ,'Measure 2 ' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND (            
    @MeaningfulUseStageLevel = 8767            
    or @MeaningfulUseStageLevel = 9373 OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477       
    OR @MeaningfulUseStageLevel = 9480 OR @MeaningfulUseStageLevel = 9481           
    )            
              
  UNION            
              
  SELECT 0 AS GlobalSubCodeId            
   ,'No Measure Sub Type' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8697)            
   AND @MeaningfulUseStageLevel = 8766            
              
  UNION            
              
  SELECT 3 AS GlobalSubCodeId            
   ,'Measure 1 (ALL)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8687)            
              
  UNION            
              
  SELECT 4 AS GlobalSubCodeId            
   ,'Measure 2 (HW)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8687)            
              
  UNION            
              
  SELECT 5 AS GlobalSubCodeId            
   ,'Measure 3 (BP)' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
WHERE TEMP.item IN (8687)            
  --UNION                 
  -- SELECT 0 AS GlobalSubCodeId                
  --  ,'No Measure Sub Type' AS SubCodeName                
              
  UNION            
              
  SELECT 3 AS GlobalSubCodeId            
   ,'Measure 1' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item IN (8683)            
              
  UNION            
              
  SELECT 0 AS GlobalSubCodeId            
   ,'No Measure Sub Type' AS SubCodeName            
  FROM GlobalSubCodes GS            
  CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP            
  WHERE TEMP.item NOT IN (            
    8680            
    ,8683            
    ,8687            
    ,8697            
    ,8700            
    )            
                
              
   --union             
   --SELECT 4  as GlobalSubCodeId                   
   -- ,'Measure 2'  as SubCodeName                
   --  FROM GlobalSubCodes GS                  
   -- cross apply dbo.fnSplit(@GlobalCodeId,',')  as temp where temp.item=8683                
 END            
END 