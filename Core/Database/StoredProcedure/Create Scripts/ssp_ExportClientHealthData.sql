
/****** Object:  StoredProcedure [dbo].[ssp_ExportClientHealthData]    Script Date: 03/31/2016 18:03:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ExportClientHealthData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ExportClientHealthData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ExportClientHealthData]    Script Date: 03/31/2016 18:03:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 --[ssp_ExportClientHealthData] @ClientId=23,@HealthDataTemplateId=110,@StartDate='01/01/2016',@EndDate='04/05/2016'    
CREATE Procedure [dbo].[ssp_ExportClientHealthData]     
(    
 @ClientId INT,    
 @HealthDataTemplateId INT,      
 @StartDate datetime = null,    
 @EndDate datetime = null    
)    
    
/********************************************************************************                                                              
-- Stored Procedure: dbo.ssp_ExportClientHealthData.sql                                                                
--                                                              
-- Copyright: Streamline Healthcate Solutions                                                              
--                                                              
-- Purpose: used to export data of flowsheet    
--                                                              
-- Updates:                                                                                                                     
-- Date   Author   Purpose                                                              
-- Apr 28 2015 Chethan N	 What : Retriving Staff.DisplayAs to display in Printed Report/Exported document.  
-- Mar 31 2016 Shaik Irfan	 What : Added two fields i.e HDA.Name,HDSTA.OrderInFlowSheet in CTE "FilteredAttributes" 
									and t2.EntryDisplayOrder,t2.OrderInFlowSheet in Subquery and added order by clause in Pivot to make an order according 
									to these two fields i.e, EntryDisplayOrder,OrderInFlowSheet
							 Why :  Keystone Environment Issues Tracking Task#54	
-- April 5 2016 jcarlson	   Commented out "and isnull(HDA.RecordDeleted,'N')='N'
								 if a health attribute has been record deleted, we still want to include any records 
								 that use that attribute
-- 5/25//2017 MD Hussain   What: Added where clause to check for Value field, it should not be null
						   Why: To remove blank rows from Print/Export data w.r.t Bear River - SGL #179   
-- 07/28/2017	Gautam	   What: Added code to display HealthRecordDate in desc order 	
						   why : Bear River - Support Go Live #179
-- 08/18/2017	Anto	   What: Modified the sp by changing the length of the variable '@cols' into max.
						   Why : Keystone Support Go Live - #101		
-- 09/08/2018	Ponnin		What: Added distinct for the #DistictColumns temp table to avoid duplicate/similar dates. 
							Why: Key Point - Support Go Live - 1357												          								 	
*********************************************************************************/    
AS        
BEGIN            
BEGIN TRY         
    
 create table #TemplateResult
(HealthDataAttributeId int,
Name varchar(200),
value varchar(250),
HealthRecordDate varchar(250),
HealthRecordDateTemp datetime,
nr  varchar(250),
DisplayAs varchar(60),
EntryDisplayOrder int,
OrderInFlowSheet int)

create table #DistictColumns
(HealthRecordDate varchar(200)
,HealthRecordDateTemp datetime
,DisplayAs varchar(60))
   
-- Inserting filterd and unique Attributes into temp table for further filteration        
;WITH FilteredAttributes        
 AS         
 (         
SELECT HDSTA.HealthDataAttributeId,HDA.Name,HDSTA.OrderInFlowSheet    -- Mar 31 2016 Shaik Irfan    
FROM HealthDataTemplateAttributes HDTA        
 INNER JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId        
 INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDSTA.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId        
 INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId        
 INNER JOIN ClientHealthDataAttributes CHDA ON  (CHDA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId AND CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId)        
 INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = CHDA.HealthDataAttributeId        
WHERE HDT.HealthDataTemplateId = @HealthDataTemplateId AND CHDA.ClientId = @ClientId         
 AND ISNULL(HDSTA.DisplayInFlowSheet,'N') = 'Y'        
 AND ISNULL(HDT.RecordDeleted,'N')='N' AND HDT.Active='Y' AND ISNULL(HDTA.RecordDeleted,'N')='N'        
 AND ISNULL(HDSTA.RecordDeleted,'N')='N' AND ISNULL(HDST.RecordDeleted,'N')='N' AND HDST.Active='Y'        
 AND ISNULL(CHDA.RecordDeleted,'N')='N'     
  --AND ISNULL(HDA.RecordDeleted,'N')='N' jcarlson 4/5/2016, if a health attribute it record deleted but was used, we dont want to exclude those records that have prevously used the attribute         
 --3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe        
 and CAST(CHDA.HealthRecordDate as DATE) between CAST(ISNULL(@StartDate,'01/01/1753') as Date)  and CAST(ISNULL(@EndDate,'01/01/2999') AS Date)       
GROUP BY HDSTA.HealthDataAttributeId,HDA.Name,HDSTA.OrderInFlowSheet         
),    
TemplateResult        
as        
(       
 SELECT CHDA.HealthDataAttributeId,HDA.Name,        
 CASE WHEN HDA.DataType = 8081 THEN        
 dbo.csf_GetGlobalCodeNameById(FLOOR(CHDA.Value))        
 ELSE CHDA.Value END AS 'Value'        
, CONVERT(VARCHAR(19),CHDA.HealthRecordDate,101)+' '+CONVERT(varchar(15),  CAST(CHDA.HealthRecordDate AS TIME), 100) as HealthRecordDate        
,CHDA.HealthRecordDate as   HealthRecordDateTemp
,'' as nr        
,S.DisplayAs as 'DisplayAs'        
,HDTA.EntryDisplayOrder        
,FA.OrderInFlowSheet    
FROM ClientHealthDataAttributes CHDA        
INNER JOIN FilteredAttributes FA ON FA.HealthDataAttributeId = CHDA.HealthDataAttributeId        
INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = FA.HealthDataAttributeId        
INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId        
LEFT JOIN STAFF S ON S.UserCode=CHDA.ModifiedBy         
WHERE CHDA.ClientId = @ClientId AND ISNULL(CHDA.RecordDeleted,'N')='N' AND HDTA.HealthDataTemplateId = @HealthDataTemplateId         
 and CAST(CHDA.HealthRecordDate as DATE) between CAST(ISNULL(@StartDate,'01/01/1753') as Date)  and CAST(ISNULL(@EndDate,'01/01/2999') AS Date)        
AND ISNULL(CHDA.RecordDeleted,'N')='N' -- AND ISNULL(HDA.RecordDeleted,'N')='N'  jcarlson 4/5/2016    
AND ISNULL(HDTA.RecordDeleted,'N')='N'         
)        
        
insert into #TemplateResult
(HealthDataAttributeId,Name,value,HealthRecordDate,HealthRecordDateTemp ,nr ,
DisplayAs,EntryDisplayOrder,OrderInFlowSheet )
select HealthDataAttributeId,Name,value,HealthRecordDate,HealthRecordDateTemp ,nr ,
DisplayAs,EntryDisplayOrder,OrderInFlowSheet  from TemplateResult where Value is not null -- Added where clause to remove null Value by MD on 5/25/2017    
order by HealthRecordDateTemp desc,EntryDisplayOrder  

insert into #DistictColumns
(HealthRecordDate,HealthRecordDateTemp,DisplayAs)
Select distinct HealthRecordDate,HealthRecordDateTemp,DisplayAs from #TemplateResult group by HealthRecordDate,HealthRecordDateTemp,DisplayAs
order by HealthRecordDateTemp desc --order by HealthRecordDate desc   
        
DECLARE @cols NVARCHAR(Max)         
SELECT @cols = STUFF(( SELECT distinct      
'],[' +   HealthRecordDate       
FROM #DistictColumns AS t2              
FOR XML PATH('')         
), 1, 2, '') + ']'       
        
        
DECLARE @query NVARCHAR(Max)         
        
SET @query = N'SELECT HealthDataAttributeId, name, '+         
@cols +'         
FROM         
--------------------------subquery-----         
(SELECT         
t1.HealthRecordDate,         
t2.Name,         
t2.Value,        
t2.HealthDataAttributeId,    
t2.EntryDisplayOrder,     
t2.OrderInFlowSheet         
FROM #DistictColumns AS t1         
JOIN #TemplateResult AS t2 ON t1.HealthRecordDate = t2.HealthRecordDate         
) p         
--------------------pivot -------------------------         
PIVOT         
(         
max ([Value] )         
FOR HealthRecordDate IN         
( '+         
@cols +' )         
) AS pvt         
order by EntryDisplayOrder,OrderInFlowSheet          
'         
EXECUTE(@query)         
        
----- Chethan N changes--         
--select DISTINCT HealthRecordDate,DisplayAs from #TemplateResult   

select HealthRecordDate,DisplayAs from #DistictColumns  

     
-- End Chethan N changes        
        
END TRY        
             
 BEGIN CATCH            
  DECLARE @Error VARCHAR(8000)                   
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                        
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ExportClientHealthData.sql')                                                                                                         
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