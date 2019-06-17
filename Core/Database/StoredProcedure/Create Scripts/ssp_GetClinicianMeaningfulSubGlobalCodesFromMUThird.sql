IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClinicianMeaningfulSubGlobalCodesFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClinicianMeaningfulSubGlobalCodesFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                                  
CREATE PROCEDURE [dbo].[ssp_GetClinicianMeaningfulSubGlobalCodesFromMUThird] @GlobalCodeId VARCHAR(MAX)                                  
 ,@InPatient BIT                                  
 ,@Stage VARCHAR(10) = NULL                                  
 /********************************************************************************                                          
-- Stored Procedure: dbo.ssp_GetClinicianMeaningfulSubGlobalCodesFromMUThird    8697,0, 9373                                      
--                                         
-- Copyright: Streamline Healthcate Solutions                                       
--                                          
-- Updates:                                                                                             
-- Date   Author  Purpose                                      
-- 15-Oct-2017  Gautam  What:ssp  to get Meaningful SubGlobalCodes                                           
--       Why:task MeaningFul Use Stage3                                 
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
                           
 create table #MUGlobalSubCodes                          
 (GlobalSubCodeId int,                          
 SubCodeName varchar(250)                          
 )                             
                           
                                  
                                    
  CREATE TABLE #MeasureList(Measure varchar(250))                                            
  INSERT INTO #MeasureList                                            
  SELECT item FROM [dbo].fnSplit(@GlobalCodeId,',')                                   
                          
                                
 IF @InPatient = 1                                  
 BEGIN                      
 If exists(Select 1 from #MeasureList where measure =8683 )                          
 begin                          
  insert into #MUGlobalSubCodes                              
  SELECT top 1 6266 AS GlobalSubCodeId                                  
   ,'Measure 1(H) ' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                  
  WHERE TEMP.measure =8683                                   
 AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
       OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481  )                              
                            
                                
   insert into #MUGlobalSubCodes                                    
  SELECT top 1 6267 AS GlobalSubCodeId                                  
   ,'Measure 2(H) ' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                   
  WHERE TEMP.measure =8683                                  
  AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                                 
     end                           
              
  If exists(Select 1 from #MeasureList where measure in (8698,8710,9478,9479,8699,8680,8703) )   --8703(secure message not required for IP)                         
 begin                          
  insert into #MUGlobalSubCodes                  
  SELECT top 1 0 AS GlobalSubCodeId                                  
   ,'No Measure Sub Type ' AS SubCodeName                   
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                  
  WHERE TEMP.measure in (8698,8710,9478,9479,8699,8680,8703)                                   
 AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                              
end                
If exists(Select 1 from #MeasureList where measure =8697 )                          
 begin                          
  insert into #MUGlobalSubCodes                              
  SELECT top 1 6261 AS GlobalSubCodeId                                  
   ,'Measure 1(H)' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                  
  WHERE TEMP.measure =8697                                   
 AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                              
end          
 If exists(Select 1 from #MeasureList where measure =8700 )   --8703(secure message not required for IP)                         
 begin                          
  insert into #MUGlobalSubCodes                              
  SELECT top 1 6214 AS GlobalSubCodeId                                  
   ,'Measure 1(H) ' AS SubCodeName                   
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                  
  WHERE TEMP.measure =8700                                 
 AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                              
end               
           
  --SELECT GS.GlobalSubCodeId                                  
  -- ,GS.SubCodeName + '(H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item = GS.GlobalCodeId                                  
  -- AND ISNULL(GS.RecordDeleted, 'N') = 'N' -- 8665 (CPOE)                                          
  -- AND TEMP.item IN (                                  
  --  8709                                  
  --  ,8680                                  
  --  ,8686                                  
  --  ,8688                                  
  --  ,8694                                  
  --  ,8698                                  
  --  ,8699                                  
  --  ,8682                                  
  --  ,8683                                  
  -- ,8704                                  
  --  ,8705                                  
  --  ,8706                                  
  --  )                                  
  -- AND GS.GlobalSubCodeId IN (                 
  --  CASE                                   
  --   WHEN (                                  
  --     @MeaningfulUseStageLevel = 8766                                  
  --     -- 11-Jan-2016  Ravi                                  
  --     OR @MeaningfulUseStageLevel = 9373                                  
  --     )                                  
  --    AND TEMP.item = 8680                                  
  --    THEN 6177                                  
  --   ELSE GS.GlobalSubCodeId                                  
  --   END                                  
  --  )                                  
                                    
  --UNION                                  
                                    
  --SELECT 3 AS GlobalSubCodeId                                  
  -- ,'Measure 1(H) ' AS SubCodeName              
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8708)                                  
  -- AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  -- 11-Jan-2016  Ravi                                  
  --  OR @MeaningfulUseStageLevel = 9373                                  
  --  )                                  
                                    
  --UNION                                  
                                    
  --SELECT 4 AS GlobalSubCodeId                                  
  -- ,'Measure Alt(H) ' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8708)                             
  -- AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  -- 11-Jan-2016  Ravi                                  
  --  OR @MeaningfulUseStageLevel = 9373                                  
  --  )                           
                                    
  --UNION                  
                                    
  --SELECT 3 AS GlobalSubCodeId                                  
  -- ,'Medication Alt(H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8680)                                  
  -- AND @MeaningfulUseStageLevel = 8766                                  
                                    
  --UNION                                  
                                    
  --SELECT 6213 AS GlobalSubCodeId                                  
  -- ,'No Measure Sub Type' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8700)                                  
  -- AND @MeaningfulUseStageLevel = 8766                                  
                                    
  --UNION                                  
                                    
  --SELECT 6213 AS GlobalSubCodeId                                  
  -- ,'Measure 1 (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8700)                                  
  -- AND @MeaningfulUseStageLevel = 8767                                  
                                    
  --UNION                                  
                                    
  --SELECT 6214 AS GlobalSubCodeId                                  
  -- ,'Measure 2 (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8700)                                  
  -- AND (                           
  --  @MeaningfulUseStageLevel = 8767                                  
  --  -- 11-Jan-2016  Ravi                                  
  --  OR @MeaningfulUseStageLevel = 9373                                  
  --  )                                  
                                    
  --UNION                                  
                                    
  --SELECT 6211 AS GlobalSubCodeId                               
  -- ,'Measure 1 (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  -- 11-Jan-2016  Ravi                                  
  --  --OR @MeaningfulUseStageLevel = 9373  -- 04-May-2017                                  
  --  )                                  
                                 
  ---- Measure 1 2017     -- 04-May-2017  Ravi                                  
  --UNION                                  
  --      SELECT 6211 AS GlobalSubCodeId                                  
  -- ,'Measure 1 2016 (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND (                                  
  --   @MeaningfulUseStageLevel = 9373                                  
  --  )                                  
                                    
                                    
  --UNION                                  
                                    
  --SELECT 6261 AS GlobalSubCodeId                                  
  -- ,'Measure 1 2017 (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND (                                  
  --   @MeaningfulUseStageLevel = 9373                                  
  --  )                                  
          
  --UNION                                  
                                    
  --SELECT 6212 AS GlobalSubCodeId                                  
  -- ,'Measure 2 (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  OR @MeaningfulUseStageLevel = 9373                                  
  --  )                                  
                                    
  --UNION                                  
                                    
  --SELECT 0 AS GlobalSubCodeId                                  
  -- ,'No Measure Sub Type' AS SubCodeName                        
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND @MeaningfulUseStageLevel = 8766                                  
                                    
  --UNION                                  
                                    
  --SELECT 1 AS GlobalSubCodeId                                  
  -- ,'Measure 1 (ALL)(H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8687)                                  
  ---- union                                      
  ----SELECT 2    as GlobalSubCodeId                                       
  ----,'Measure 2 (HW)(H)' as SubCodeName                                      
  ----  FROM GlobalSubCodes GS                                        
  ----cross apply dbo.fnSplit(@GlobalCodeId,',')  as temp where temp.item in (8687)                               
  ---- union                                      
  ----SELECT 6    as GlobalSubCodeId                                       
  ----, 'Measure 3 (BP)(H)' as SubCodeName                                      
  ----  FROM GlobalSubCodes GS                                        
  ----cross apply dbo.fnSplit(@GlobalCodeId,',')  as temp where temp.item in (8687)                                    
                                    
  --UNION                                  
              
  --SELECT 1 AS GlobalSubCodeId                                  
  -- ,'Advance Directives - 65 Years+ Admitted Hospital (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8707)                                  
  ----union                                      
  ----SELECT 2 as GlobalSubCodeId                                        
  ----,'Advance Directives - 65 Years+ Not Admitted Hospital (H)' as SubCodeName                         
  ----FROM GlobalSubCodes GS                                         
  ----cross apply dbo.fnSplit(@GlobalCodeId,',')  as temp where temp.item in (8707) and @MeaningfulUseStageLevel=8767                                      
                                    
  --UNION                                  
                                    
  --SELECT 5 AS GlobalSubCodeId                                  
  -- ,'Measure 1 (H)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8683)                                  
  --AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  OR @MeaningfulUseStageLevel = 9373                                  
  --  OR @MeaningfulUseStageLevel = 8766                                  
  --  )                                  
                                    
  --UNION                                  
                                    
  --SELECT 0 AS GlobalSubCodeId                                  
  -- ,'No Measure Sub Type' AS SubCodeName          
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item NOT IN (                                  
  --  8680                                  
  --  ,8683                                  
  --  ,8687                                  
  --  ,8697                                  
  --  ,8700                                  
  --  ,8707                                  
  --  ,8708                                  
  --  )                                  
 END                                  
 ELSE                                  
 BEGIN                             
 If exists(Select 1 from #MeasureList where measure =8683 )                          
 begin                          
  insert into #MUGlobalSubCodes                              
  SELECT top 1 6266 AS GlobalSubCodeId                                  
   ,'Measure 1' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                  
  WHERE TEMP.measure =8683                                   
 AND (  @MeaningfulUseStageLevel = 8768         
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                              
                            
                                
   insert into #MUGlobalSubCodes                                    
  SELECT top 1 6267 AS GlobalSubCodeId                                  
   ,'Measure 2' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                   
  WHERE TEMP.measure =8683                                  
  AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                                 
     end                           
                               
                               
   If exists(Select 1 from #MeasureList where measure =8680 )                          
 begin                          
  insert into #MUGlobalSubCodes                            
  SELECT  GS.GlobalSubCodeId                                  
   ,GS.SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                    
  WHERE TEMP.measure =8680                             
  and GS.GlobalCodeId    =8680                            
   AND ISNULL(GS.RecordDeleted, 'N') = 'N' -- 8665 (CPOE)                              
   AND (  @MeaningfulUseStageLevel = 8768                          
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                                
                               
   end                                  
                             
      If exists(Select 1 from #MeasureList where measure =8697 )                          
 begin                          
  insert into #MUGlobalSubCodes                                  
  SELECT top 1 6261 AS GlobalSubCodeId                                  
   ,'Measure 1' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                
  WHERE TEMP.measure= 8697                                  
   AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                                
                                   
                       
  -- insert into #MUGlobalSubCodes                                 
  --SELECT top 1 6212 AS GlobalSubCodeId                                  
  --,'Measure 2' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY #MeasureList AS TEMP                               
  --WHERE TEMP.measure IN (8697)                                  
  --AND (  @MeaningfulUseStageLevel = 8768                                  
  --     OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477  )                               
                                  
  end                          
                          
    If exists(Select 1 from #MeasureList where measure =8700 )                          
 begin                          
  insert into #MUGlobalSubCodes                              
  SELECT top 1 6213 AS GlobalSubCodeId                                  
   ,'Measure 1' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                
  WHERE TEMP.measure= 8700     
   AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                                
  end                          
                          
     If exists(Select 1 from #MeasureList where measure in (8698 ,8703,8699,8710,9478,9479) )                   begin                          
  insert into #MUGlobalSubCodes                           
  SELECT  distinct 0 AS GlobalSubCodeId                                  
   ,'No Measure Sub Type' AS SubCodeName                                  
  FROM GlobalSubCodes GS                                  
  CROSS APPLY #MeasureList AS TEMP                                
  WHERE TEMP.measure IN (                                  
    8698 ,8703 ,8699,8710 ,9478,9479                             
    )                                  
   AND (  @MeaningfulUseStageLevel = 8768                                  
       OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477   
        OR @MeaningfulUseStageLevel = 9480  OR @MeaningfulUseStageLevel = 9481 )                                
                          
    end                              
                            
                           
                                          
   --AND TEMP.item IN (8665)                                  
   -- --8687                                  
   -- --,8683                                  
   -- --,8700                                  
   -- --,8697                                  
   -- --)                     
   --AND GS.GlobalSubCodeId IN (                                  
   -- CASE                                   
   -- WHEN (                                  
   --    @MeaningfulUseStageLevel = 8768                                  
   --    OR @MeaningfulUseStageLevel = 9476  OR @MeaningfulUseStageLevel = 9477                                  
   --    )                                  
   --   AND TEMP.item = 8680                                  
   --   THEN 6177                                  
   --  ELSE GS.GlobalSubCodeId                                  
   --  END                           
   -- )                                  
                                    
  --UNION                                  
                                    
  --SELECT 6213 AS GlobalSubCodeId                                  
  -- ,'No Measure Sub Type' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8700)                                  
  -- AND @MeaningfulUseStageLevel = 8766                                  
                                    
  --UNION                                  
                                    
  --SELECT 6213 AS GlobalSubCodeId                                  
  -- ,'Measure 1' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8700)                                  
  -- AND @MeaningfulUseStageLevel = 8767                                  
                                    
  --UNION                                  
                                    
  --SELECT 6214 AS GlobalSubCodeId                                  
  -- ,'Measure 2 ' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                 
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8700)                                  
  -- AND (                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  OR @MeaningfulUseStageLevel = 9373                           
  --  )                                  
                                    
  --UNION                     
                                    
  --SELECT 6211 AS GlobalSubCodeId                                  
  -- ,'Measure 1' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  -- -- OR @MeaningfulUseStageLevel = 9373    -- 04-May-2017  Ravi                                  
  --  )                                  
                                    
                                    
 ---- Measure 1 2017     -- 04-May-2017  Ravi                                  
  --UNION                       
                                    
  --SELECT 6211 AS GlobalSubCodeId                                  
  -- ,'Measure 1 2016' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND (                                  
  --   @MeaningfulUseStageLevel = 9373                                  
  --  )                                  
                                    
                                    
  --UNION                                   
                                  
  --SELECT 6261 AS GlobalSubCodeId                                  
  --,'Measure 1 2017' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  --AND (                                  
  -- @MeaningfulUseStageLevel = 9373                                  
  --)                                  
                                      
                                 
  --UNION                                  
                                    
  --SELECT 6212 AS GlobalSubCodeId                                  
  -- ,'Measure 2 ' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  OR @MeaningfulUseStageLevel = 9373                                --  )                                  
                                    
  --UNION                                  
                                    
  --SELECT 0 AS GlobalSubCodeId                                  
  -- ,'No Measure Sub Type' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8697)                                  
  -- AND @MeaningfulUseStageLevel = 8766                                  
                                    
  --UNION                                  
                                    
  --SELECT 3 AS GlobalSubCodeId                                  
  -- ,'Measure 1 (ALL)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8687)                                  
                                    
  --UNION                                  
                                    
  --SELECT 4 AS GlobalSubCodeId                                  
  -- ,'Measure 2 (HW)' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8687)                                  
                                    
  --UNION                                  
                                    
  --SELECT 5 AS GlobalSubCodeId                                  
  -- ,'Measure 3 (BP)' AS SubCodeName                 
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8687)                                  
  ----UNION                                       
  ---- SELECT 0 AS GlobalSubCodeId                         
  ----  ,'No Measure Sub Type' AS SubCodeName                                      
                                    
  --UNION                                  
                                    
  --SELECT 3 AS GlobalSubCodeId                                  
  -- ,'Measure 1' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item IN (8683)                                  
  -- AND (                                  
  --  @MeaningfulUseStageLevel = 8767                                  
  --  OR @MeaningfulUseStageLevel = 9373                                  
  --  OR @MeaningfulUseStageLevel = 8766                                  
  --  )                                  
           
  --UNION                                  
                                    
  --SELECT 0 AS GlobalSubCodeId                                  
  -- ,'No Measure Sub Type' AS SubCodeName                                  
  --FROM GlobalSubCodes GS                                  
  --CROSS APPLY dbo.fnSplit(@GlobalCodeId, ',') AS TEMP                                  
  --WHERE TEMP.item NOT IN (                                  
  --  8680                                  
  --  ,8683                                  
  --  ,8687                                  
  --  ,8697                                  
  --  ,8700                                  
  --  )                                  
                                      
                                
                                    
                                 
 END                    
   Select GlobalSubCodeId,SubCodeName From #MUGlobalSubCodes              
                             
END 