  /****** Object:  StoredProcedure [dbo].[csp_RDLGetClientHealthData]    Script Date: 07/07/2015 16:26:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetClientHealthData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLGetClientHealthData]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLGetClientHealthData]    Script Date: 07/07/2015 16:26:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 
  --[csp_RDLGetClientHealthData] @ClientId=23,@HealthDataTemplateId=110,@StartDate='01/01/2016',@EndDate='04/05/2016'      
CREATE Procedure [dbo].[csp_RDLGetClientHealthData]       
(      
 @ClientId INT,      
 @HealthDataTemplateId INT,        
 @StartDate datetime = null,      
 @EndDate datetime = null      
)      
      
/********************************************************************************                                                                
-- Stored Procedure: dbo.csp_RDLGetClientHealthData.sql                                                                  
--  csp_RDLGetClientHealthData 4,110                                                             
-- Copyright: Streamline Healthcate Solutions
-- 10/11/2017 Pabitra New Vital Design TexasCustomizations#119                                                                    
                                                                                             
*********************************************************************************/      
AS          
BEGIN              
BEGIN TRY           
 
 
 
        SET @StartDate = (    
     SELECT DISTINCT healthrecorddate    
     FROM clienthealthdataattributes    
     WHERE clientid = @ClientId    
      AND healthrecorddate = (    
       SELECT Min(healthrecorddate)    
       FROM (    
        SELECT DISTINCT TOP (4) healthrecorddate    
        FROM clienthealthdataattributes    
        WHERE clientid = @ClientId    
        ORDER BY healthrecorddate DESC    
        ) T    
       )    
     )  
     

      SET @EndDate = (    
     SELECT DISTINCT healthrecorddate    
     FROM clienthealthdataattributes    
     WHERE clientid = @ClientId    
      AND healthrecorddate = (    
       SELECT MAX(healthrecorddate)    
       FROM (    
        SELECT DISTINCT TOP (4) healthrecorddate    
        FROM clienthealthdataattributes    
        WHERE clientid = @ClientId   
        ORDER BY healthrecorddate DESC    
        ) T    
       )    
     )   
  
 
     
 create table #TemplateResult  
(HealthDataAttributeId int,  
Name varchar(200),  
value varchar(250),  
HealthRecordDate varchar(250),  
HealthRecordDateTemp datetime,  
nr  varchar(250),  
DisplayAs varchar(60),  
EntryDisplayOrder int,  
OrderInFlowSheet int,
Units VARCHAR(200),
ValueWithUnits VARCHAR(500),
HealthDataSubTemplateName VARCHAR(500),
HealthDataSubTemplateId INT
,[Description] VARCHAR(500)
)  

     
-- Inserting filterd and unique Attributes into temp table for further filteration          
;WITH FilteredAttributes          
 AS           
 (           
SELECT HDSTA.HealthDataAttributeId,HDA.Name,HDSTA.OrderInFlowSheet     
FROM HealthDataTemplateAttributes HDTA          
 INNER JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId          
 INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDSTA.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId          
 INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId          
 INNER JOIN ClientHealthDataAttributes CHDA ON  (CHDA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId AND CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId)          
 -- INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = CHDA.HealthDataAttributeId   
 INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = CHDA.HealthDataAttributeId  AND CHDA.HealthDataSubTemplateId IN (110,111,112,113)         
WHERE HDT.HealthDataTemplateId = @HealthDataTemplateId AND CHDA.ClientId = @ClientId           
 AND ISNULL(HDSTA.DisplayInFlowSheet,'N') = 'Y'          
 AND ISNULL(HDT.RecordDeleted,'N')='N' AND HDT.Active='Y' AND ISNULL(HDTA.RecordDeleted,'N')='N'          
 AND ISNULL(HDSTA.RecordDeleted,'N')='N' AND ISNULL(HDST.RecordDeleted,'N')='N' AND HDST.Active='Y'          
 AND ISNULL(CHDA.RecordDeleted,'N')='N'           
 and CAST(CHDA.HealthRecordDate as DATE) between CAST(ISNULL(@StartDate,'01/01/1753') as Date)  and CAST(ISNULL(@EndDate,'01/01/2999') AS Date)         
GROUP BY HDSTA.HealthDataAttributeId,HDA.Name,HDSTA.OrderInFlowSheet           
),      
TemplateResult          
as          
(         
 SELECT CHDA.HealthDataAttributeId,HDA.Name,          
 CASE WHEN HDA.DataType = 8081 THEN          
 dbo.csf_GetGlobalCodeNameById(FLOOR(CHDA.Value))          
 ELSE CHDA.Value END AS 'Value',
  dbo.csf_GetGlobalCodeNameById(HDA.Units) AS Units,
    CASE   
    WHEN (  
      HDA.DataType = 8081  
      OR HDA.DataType = 8088  
      )  
     THEN dbo.csf_GetGlobalCodeNameById(FLOOR(CHDA.Value))  +' '+  ISNULL(dbo.csf_GetGlobalCodeNameById(HDA.Units),' ')   
    ELSE CHDA.Value  +' '+  ISNULL(dbo.csf_GetGlobalCodeNameById(HDA.Units),' ') 
    END AS 'ValueWithUnits',
    HSDT.Name  AS HealthDataSubTemplateName,
    HSDT.HealthDataSubTemplateId            
, CONVERT(VARCHAR(19),CHDA.HealthRecordDate,101)+' '+CONVERT(varchar(15),  CAST(CHDA.HealthRecordDate AS TIME), 100) as HealthRecordDate          
,CHDA.HealthRecordDate as   HealthRecordDateTemp  
,'' as nr          
,S.DisplayAs as 'DisplayAs'          
,HDTA.EntryDisplayOrder          
,FA.OrderInFlowSheet
,HDA.Description      
FROM ClientHealthDataAttributes CHDA          
INNER JOIN FilteredAttributes FA ON FA.HealthDataAttributeId = CHDA.HealthDataAttributeId          
INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = FA.HealthDataAttributeId          
INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId 
INNER JOIN HealthDataSubTemplates HSDT ON HSDT.HealthDataSubTemplateId=CHDA.HealthDataSubTemplateId          
LEFT JOIN STAFF S ON S.UserCode=CHDA.ModifiedBy           
WHERE CHDA.ClientId = @ClientId AND ISNULL(CHDA.RecordDeleted,'N')='N' AND HDTA.HealthDataTemplateId = @HealthDataTemplateId           
 and CAST(CHDA.HealthRecordDate as DATE) between CAST(ISNULL(@StartDate,'01/01/1753') as Date)  and CAST(ISNULL(@EndDate,'01/01/2999') AS Date)          
AND ISNULL(CHDA.RecordDeleted,'N')='N'     
AND ISNULL(HDTA.RecordDeleted,'N')='N'           
)          
          
insert into #TemplateResult  
(HealthDataAttributeId,Name,value,HealthRecordDate,HealthRecordDateTemp ,nr ,  
DisplayAs,EntryDisplayOrder,OrderInFlowSheet,Units,ValueWithUnits,HealthDataSubTemplateName,HealthDataSubTemplateId,[Description])  
select HealthDataAttributeId,Name,value,HealthRecordDate,HealthRecordDateTemp ,nr ,  
DisplayAs,EntryDisplayOrder,OrderInFlowSheet,Units,ValueWithUnits,HealthDataSubTemplateName,HealthDataSubTemplateId,[Description]  from TemplateResult where Value is not null     
order by HealthRecordDateTemp desc,EntryDisplayOrder   


-----------Color-------

  DECLARE @Gender CHAR(1)  
   ,@AGE INT  
   ,@FilterGraphCriteriaId INT  
  
  SELECT @Gender = Sex  
   ,@AGE = DATEDIFF(day, DOB, GETDATE()) / 30  
  FROM Clients  
  WHERE ClientId = @clientId  
  
  CREATE TABLE #HDGCriteira (  
   HealthDataGraphCriteriaId INT  
   ,HealthDataAttributeId INT  
   ,NAME VARCHAR(200)  
   ,Description VARCHAR(200)  
   ,MaximumValue DECIMAL(18, 2)  
   ,MinimumValue DECIMAL(18, 2)  
   ,Priority INT  
   );  
  
 ;WITH FilteredAttributes          
 AS           
 (           
SELECT HDSTA.HealthDataAttributeId,HDA.Name,HDSTA.OrderInFlowSheet     
FROM HealthDataTemplateAttributes HDTA          
 INNER JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId          
 INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDSTA.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId          
 INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId          
 INNER JOIN ClientHealthDataAttributes CHDA ON  (CHDA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId AND CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId)          
 -- INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = CHDA.HealthDataAttributeId   
 INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = CHDA.HealthDataAttributeId  AND CHDA.HealthDataSubTemplateId IN (110,111,112,113)         
WHERE HDT.HealthDataTemplateId = @HealthDataTemplateId AND CHDA.ClientId = @ClientId           
 AND ISNULL(HDSTA.DisplayInFlowSheet,'N') = 'Y'          
 AND ISNULL(HDT.RecordDeleted,'N')='N' AND HDT.Active='Y' AND ISNULL(HDTA.RecordDeleted,'N')='N'          
 AND ISNULL(HDSTA.RecordDeleted,'N')='N' AND ISNULL(HDST.RecordDeleted,'N')='N' AND HDST.Active='Y'          
 AND ISNULL(CHDA.RecordDeleted,'N')='N'           
 and CAST(CHDA.HealthRecordDate as DATE) between CAST(ISNULL(@StartDate,'01/01/1753') as Date)  and CAST(ISNULL(@EndDate,'01/01/2999') AS Date)         
GROUP BY HDSTA.HealthDataAttributeId,HDA.Name,HDSTA.OrderInFlowSheet           
),  HDGCriteira  
  AS (  
   SELECT HDGC.HealthDataGraphCriteriaId  
    ,HDGC.HealthDataAttributeId  
    ,HDA.NAME  
    ,HDA.Description  
    ,HDGC.MinimumValue  
    ,HDGC.MaximumValue  
    ,HDGC.AllAge  
    ,HDGC.AgeFrom  
    ,HDGC.AgeTo  
    ,HDGC.Priority  
   FROM healthdatagraphcriteria HDGC  
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDGC.Sex  
   INNER JOIN FilteredAttributes FA ON FA.HealthdataAttributeId = HDGC.HealthDataAttributeId  
   INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = HDGC.HealthDataAttributeId  
   WHERE ISNULL(HDGC.RecordDeleted, 'N') = 'N'  
    AND (  
     HDGC.Sex = CASE   
      WHEN @Gender = 'M'  
       THEN 8142  
      WHEN @Gender = 'F'  
       THEN 8143  
      ELSE 8144  
      END -- Both      
     OR HDGC.Sex = 8144  
     ) --    
    AND (  
     @AGE BETWEEN HDGC.AgeFrom  
      AND HDGC.AgeTo  
     OR HDGC.AllAge = 'Y'  
     )  
    AND HDGC.MinimumValue >= 0  
    AND HDGC.MaximumValue > 0  
   )  
   ,MinPriority  
  AS (  
   SELECT MIN(Priority) Priority  
    ,HealthDataAttributeId  
   FROM HDGCriteira  
   GROUP BY HealthDataAttributeId  
   )  
  INSERT INTO #HDGCriteira  
  SELECT HC.HealthDataGraphCriteriaId  
   ,hc.HealthDataAttributeId  
   ,HC.NAME  
   ,HC.Description  
   ,hc.MaximumValue  
   ,hc.MinimumValue  
   ,hc.Priority  
  FROM HDGCriteira HC  
  INNER JOIN MinPriority MP ON MP.Priority = HC.Priority  
   AND MP.HealthDataAttributeId = HC.HealthDataAttributeId  
  
 --SELECT * FROM  #HDGCriteira
  
  
  CREATE TABLE #HealthDataGraphCriteriaRanges ( 
  HealthDataGraphCriteriaRangeId  INT
   ,HealthDataGraphCriteriaId INT 
   ,HealthDataAttributeId INT 
   ,Level INT  
   ,MinimumValue Varchar(20) 
   ,MaximumValue Varchar(20)
   ,Color VARCHAR(100)
   ,NAME VARCHAR(200)  
   ,Description VARCHAR(200) 
   )  
   
  -- drop table #HealthDataGraphCriteriaRanges
  INSERT INTO #HealthDataGraphCriteriaRanges
  SELECT HDGCR.HealthDataGraphCriteriaRangeId  
   ,HDGCR.HealthDataGraphCriteriaId  
   ,hc.HealthDataAttributeId
   ,HDGCR.LEVEL  
   ,HDGCR.MinimumValue  
   ,HDGCR.MaximumValue  
   ,GC.Color
   ,HC.NAME
  ,HC.Description  
  FROM HealthDataGraphCriteriaRanges HDGCR  
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDGCR.LEVEL  
  INNER JOIN #HDGCriteira HC ON HDGCR.HealthDataGraphCriteriaId = HC.HealthDataGraphCriteriaId  
   WHERE ISNULL(HDGCR.RecordDeleted, 'N') = 'N'  AND  HDGCR.MaximumValue IS NOT NULL AND HDGCR.MinimumValue IS NOT NULL
   
    
 
 create table #FinalResult  
(HealthDataAttributeId int,  
value varchar(250),  
HealthRecordDate varchar(250),  
ValueWithUnits VARCHAR(500),
HealthDataSubTemplateName VARCHAR(500),
[Description] VARCHAR(500),
Color VARCHAR(200),
MinimumValue VARCHAR(25),
MaximumValue VARCHAR(25),
HealthRecordDateTemp DATETIME,
EntryDisplayOrder INT,
OrderInFlowSheet INT
)  


; with cte as
(
   SELECT distinct t.HealthDataAttributeId, t.value ,t.HealthRecordDate ,t.ValueWithUnits,t.HealthDataSubTemplateName,t.Description,CASE WHEN ((H.MinimumValue is null) OR (H.MaximumValue is null)) THEN 'Black'  ELSE H.Color end as Color ,H.MaximumValue,h.MinimumValue,t.HealthRecordDateTemp,t.EntryDisplayOrder,t.OrderInFlowSheet FROM #TemplateResult T left join #HealthDataGraphCriteriaRanges H ON T.HealthDataAttributeId=H.HealthDataAttributeId where ISNUMERIC(value)=1
   
 
  )
  
  Insert into #FinalResult
  
select  * from cte where (convert(decimal,value)>=ISNULL(MinimumValue,-1.00) and (convert(decimal,value)<=MaximumValue) OR MaximumValue is null) 
union
   SELECT distinct t.HealthDataAttributeId, t.value ,t.HealthRecordDate ,t.ValueWithUnits,t.HealthDataSubTemplateName,t.Description,CASE WHEN ((H.MinimumValue is null) OR (H.MaximumValue is null)) THEN 'Black'  ELSE H.Color end as Color ,H.MaximumValue,h.MinimumValue,t.HealthRecordDateTemp,t.EntryDisplayOrder,t.OrderInFlowSheet FROM #TemplateResult T left join #HealthDataGraphCriteriaRanges H ON T.HealthDataAttributeId=H.HealthDataAttributeId where ISNUMERIC(value)=0




Insert into #FinalResult
SELECT distinct tr.HealthDataAttributeId, tr.value ,tr.HealthRecordDate ,tr.ValueWithUnits,tr.HealthDataSubTemplateName,tr.Description,'Red'  AS  Color ,NULL AS MaximumValue,NULL AS MinimumValue,tr.HealthRecordDateTemp,tr.EntryDisplayOrder,tr.OrderInFlowSheet FROM #TemplateResult tr where NOT exists(select   1 from #FinalResult ts where ts.value=tr.value)  
 
 ;with cteFinalResult AS
 (
SELECT  *,
  ROW_NUMBER() OVER(PARTITION BY HealthDataSubTemplateName order by HealthRecordDate desc,EntryDisplayOrder ,OrderInFlowSheet) 
    AS RowNum 
FROM #FinalResult
)  

Update cteFinalResult SET HealthDataSubTemplateName=NULL where RowNum>1

SELECT * FROM  #FinalResult order by HealthRecordDate desc,EntryDisplayOrder ,OrderInFlowSheet
--,Case WHEN Description='Height' THEN 1
--WHEN Description='Weight' THEN 2
--WHEN Description='BMI' THEN 3
--ELSE 4 END 



 -- SELECT * FROM  #HDGCriteira
   --SELECT * FROM #HealthDataGraphCriteriaRanges
    DROP TABLE #HDGCriteira  
 
    
END TRY          
               
 BEGIN CATCH              
  DECLARE @Error VARCHAR(8000)                     
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                          
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_RDLGetClientHealthData.sql')                                                                                                           
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY())                                                                                                            
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())              
  RAISERROR              
  (              
   @Error, -- Message text.              
   16,  -- Severity.              
   1  -- State.              
  );              
 END CATCH              
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED               
              
END 

