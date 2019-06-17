
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_GetClientVitals]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SCSP_GetClientVitals]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 CREATE PROCEDURE [dbo].[SCSP_GetClientVitals] (  
  @ClientId INT  
 ,@HealthDataTemplateId INT  
 ,@StartDate DATETIME = NULL  
 ,@EndDate DATETIME = NULL  
 )  
 /********************************************************************************                                                                          
-- Stored Procedure: dbo.SCSP_GetClientVitals.sql                                                                            
--   SCSP_GetClientVitals 4,110                                                                       
-- Copyright: Streamline Healthcate Solutions                                                                                                                                                 
-- 30/05/2018 Pabitra New Vital Design 
--21/11/2018  Kavya   what: Added Cast (HealthRecordDate) for startdate, enddate and added DISTINCT key for #ClientHTAttributes to fetch distinct HealthRecordDate
                      Why: SC: Service Note (Psych): Client cannot view Exam tab--PEP SGL#66

*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY 
 
  
  CREATE TABLE #FilteredAttributes (HealthDataAttributeId INT)  
        SET @StartDate = (    
     SELECT DISTINCT CAST(HealthRecordDate AS DATE) AS HealthRecordDate     
     FROM clienthealthdataattributes    
     WHERE clientid = @ClientId    
      AND CAST(HealthRecordDate AS DATE) = (    
       SELECT Min(healthrecorddate)    
       FROM (    
        SELECT DISTINCT TOP (4) CAST(HealthRecordDate AS DATE) AS HealthRecordDate     
        FROM clienthealthdataattributes    
        WHERE clientid = @ClientId    
        ORDER BY healthrecorddate DESC    
        ) T    
       )    
     )  
     

      SET @EndDate = (    
     SELECT DISTINCT CAST(HealthRecordDate AS DATE) AS HealthRecordDate     
     FROM clienthealthdataattributes    
     WHERE clientid = @ClientId    
      AND CAST(HealthRecordDate AS DATE) = (    
       SELECT MAX(healthrecorddate)    
       FROM (    
        SELECT DISTINCT TOP (4) CAST(HealthRecordDate AS DATE) AS HealthRecordDate     
        FROM clienthealthdataattributes    
        WHERE clientid = @ClientId   
        ORDER BY healthrecorddate DESC    
        ) T    
       )    
     )   
  
  
  CREATE TABLE #ClientHTAttributes (  
   id INT identity(1, 1)  
   ,OldHealthRecordDate DATETIME  
   ,HealthRecordDate DATETIME  
   ,DisplayAs VARCHAR(120)  
   ,DisplayAsAll VARCHAR(120)  
   ,DRank INT  
   )  
  
  IF EXISTS (  
    SELECT 1  
    FROM SystemConfigurations  
    WHERE ISNULL(FlowSheetSpecificToClient, 'N') <> 'N'  
    )  
  BEGIN  
   SELECT HDT.HealthDataTemplateId  
    ,HDT.TemplateName  
    ,HDT.Active  
    ,HDT.NumberOfColumns  
    ,HDT.CreatedBy  
    ,HDT.CreatedDate  
    ,HDT.ModifiedBy  
    ,HDT.ModifiedDate  
    ,HDT.RecordDeleted  
    ,HDT.DeletedDate  
    ,HDT.DeletedBy  
    ,HDT.PatientPortal  
    ,HDT.DefaultDateRange
   FROM HealthDataTemplates HDT  
   INNER JOIN ClientTemplates CT ON CT.HealthDataTemplateId = HDT.HealthDataTemplateId  
    AND CT.ClientId = @ClientId  
    AND ISNULL(CT.RecordDeleted, 'N') = 'N'  
    AND ISNULL(CT.Active, 'N') <> 'N'  
   WHERE ISNULL(HDT.RecordDeleted, 'N') = 'N'  
    AND HDT.Active = 'Y'  
   ORDER BY TemplateName  
  END  
  ELSE  
  BEGIN  
   SELECT HealthDataTemplateId  
    ,TemplateName  
    ,Active  
    ,NumberOfColumns  
    ,CreatedBy  
    ,CreatedDate  
    ,ModifiedBy  
    ,ModifiedDate  
    ,RecordDeleted  
    ,DeletedDate  
    ,DeletedBy  
    ,PatientPortal  
    ,DefaultDateRange  
   FROM HealthDataTemplates  
   WHERE ISNULL(RecordDeleted, 'N') = 'N'  
    AND Active = 'Y'  
   ORDER BY TemplateName  
  END  
  
  -- Inserting filterd and unique Attributes into temp table for further filteration                
  INSERT INTO #FilteredAttributes  
  SELECT HDSTA.HealthDataAttributeId  
  FROM HealthDataTemplateAttributes HDTA  
  INNER JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId  
  INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDSTA.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId  
  INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId  
  INNER JOIN ClientHealthDataAttributes CHDA ON (  
    CHDA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId  
    AND CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId  
    AND (  
     HDT.HealthDataTemplateId = CHDA.HealthDataTemplateId  
     OR CHDA.HealthDataTemplateId IS NULL  
     )  
    )  
  INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = CHDA.HealthDataAttributeId  
  WHERE HDT.HealthDataTemplateId = @HealthDataTemplateId  
   AND CHDA.ClientId = @ClientId  
   AND ISNULL(HDT.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDT.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDT.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
   AND HDT.Active = 'Y'  
   AND ISNULL(HDTA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END   
   AND ISNULL(HDSTA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDSTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDSTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
   AND ISNULL(HDST.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
   AND HDST.Active = 'Y'  
   AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'  

   AND ISNULL(HDA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
               
   AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
    AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
  GROUP BY HDSTA.HealthDataAttributeId  
              
  SELECT HDA.HealthDataAttributeId  
   ,hda.NAME  
   ,hda.Description 
  FROM HealthDataAttributes HDA  
  INNER JOIN HealthDataGraphCriteria HDGC ON HDGC.HealthDataAttributeId = HDA.HealthDataAttributeId  
  INNER JOIN ClientHealthDataAttributes CHDA ON CHDA.HealthDataAttributeId = HDA.HealthDataAttributeId  
  WHERE CHDA.ClientId = @ClientId  
   AND HDA.DataType IN (  
    8082  
    ,8083  
    ,8086  
    )      
   AND ISNULL(HDA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
   AND ISNULL(HDGC.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDGC.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDGC.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
          
   AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
    AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
  GROUP BY HDA.HealthDataAttributeId  
   ,hda.NAME  
   ,hda.Description  
  
  INSERT INTO #ClientHTAttributes (  
   OldHealthRecordDate  
   ,HealthRecordDate  
   ,DisplayAs  
   ,DisplayAsAll  
   ,DRank  
   )  
  SELECT CAST(CONVERT(VARCHAR(17), CHDA.HealthRecordDate, 121) + '00.000' AS DATETIME)  
   ,CAST(CONVERT(VARCHAR(17), CHDA.HealthRecordDate, 121) + '00.000' AS DATETIME) AS HealthRecordDate  
   ,CASE   
    WHEN LEN(S.DisplayAs) >= 12  
     THEN SUBSTRING(S.DisplayAs, 0, 10) + '...'  
    ELSE S.DisplayAs  
    END AS 'DisplayAs'  
   ,S.DisplayAs  
   ,ROW_NUMBER() OVER (  
    PARTITION BY CHDA.HealthRecordDate ORDER BY CHDA.HealthRecordDate  
    )  

  FROM ClientHealthDataAttributes CHDA  
  INNER JOIN #FilteredAttributes FA ON CHDA.HealthDataAttributeId = FA.HealthDataAttributeId  
  INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId  
  LEFT JOIN STAFF S ON S.UserCode = CASE WHEN CHDA.ModifiedBy != CHDA.CreatedBy THEN CHDA.CreatedBy ELSE CHDA.ModifiedBy END --CHDA.ModifiedBy  
  WHERE CHDA.ClientId = @ClientId  
   AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'  
   AND HDTA.HealthDataTemplateId = @HealthDataTemplateId  
   AND (  
    CHDA.HealthDataTemplateId = @HealthDataTemplateId  
    OR CHDA.HealthDataTemplateId IS NULL  
    )  
   AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
    AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
  GROUP BY CHDA.HealthRecordDate  
   ,S.DisplayAs  
  ORDER BY CHDA.HealthRecordDate DESC  
  
  UPDATE c  
  SET c.HealthRecordDate = DATEADD(MINUTE, c.DRank, c.HealthRecordDate)  
  FROM #ClientHTAttributes c  
  WHERE c.Drank >= 2  
  
  SELECT DISTINCT HealthRecordDate  
   ,DisplayAs  
  FROM #ClientHTAttributes Order by  HealthRecordDate DESC  
 SELECT HDSTA.HealthDataSubTemplateId  
   ,HDST.NAME AS HealthDataSubTemplateName  
   ,ISNULL(HDST.IsHeading, 'N') AS IsHeading  
   ,HDSTA.HealthDataAttributeId  
   ,HDSTA.OrderInFlowSheet  
   ,HDA.NAME  
   ,HDA.Description  
   ,HDTA.EntryDisplayOrder  
  FROM HealthDataTemplateAttributes HDTA  
  INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId  
  INNER JOIN HealthDataSubTemplateAttributes HDSTA ON Hdsta.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId  
  INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId  
  INNER JOIN ClientHealthDataAttributes CHDA ON (  
    CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId  
    AND CHDA.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId  
    )  
  WHERE HDTA.HealthDataTemplateId = @HealthDataTemplateId  
   AND (  
    CHDA.HealthDataTemplateId = @HealthDataTemplateId  
    OR CHDA.HealthDataTemplateId IS NULL  
    )  
   AND HDST.Active = 'Y'  
   AND CHDA.ClientId = @ClientId  
   AND ISNULL(HDTA.RecordDeleted, 'N') = 'N'  
 AND ISNULL(HDST.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  

   AND ISNULL(HDSTA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDSTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDSTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
   AND ISNULL(HDA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
   AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'  
            
   AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
    AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
  GROUP BY HDSTA.HealthDataSubTemplateId  
   ,HDSTA.HealthDataAttributeId  
   ,HDTA.EntryDisplayOrder  
   ,HDSTA.OrderInFlowSheet  
   ,HDA.NAME  
   ,HDST.NAME  
   ,HDST.IsHeading  
   ,HDA.Description  
  ORDER BY HDTA.EntryDisplayOrder  
   ,HDSTA.OrderInFlowSheet           
  
  SELECT DISTINCT CHDA.ClientHealthDataAttributeId  
   ,CHDA.HealthDataAttributeId  
   ,HDA.NAME  
   ,HDA.Description
   ,CASE   
    WHEN (  
      HDA.DataType = 8081  
      OR HDA.DataType = 8088  
      )  
     THEN dbo.csf_GetGlobalCodeNameById(FLOOR(CHDA.Value))  
    ELSE CHDA.Value  
    END AS 'Value'  
   ,CASE   
    WHEN CH.DRank >= 2  
     AND CHDA.HealthRecordDate = CH.OldHealthRecordDate  
     THEN CH.HealthRecordDate  
    ELSE CHDA.HealthRecordDate  
    END AS HealthRecordDate  
   ,CHDA.CreatedBy  
   ,CHDA.CreatedDate  
   ,CHDA.ModifiedBy  
   ,CHDA.ModifiedDate  
   ,CHDA.RecordDeleted  
   ,CHDA.DeletedDate  
   ,CHDA.DeletedBy  
   ,CHDA.HealthDataSubTemplateId  
   ,HSDT.Name AS HealthDataSubTemplateName
   ,HDA.Units
  FROM ClientHealthDataAttributes CHDA  
  INNER JOIN #FilteredAttributes FA ON FA.HealthDataAttributeId = CHDA.HealthDataAttributeId  
  INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = FA.HealthDataAttributeId  
  INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId 
  INNER JOIN HealthDataSubTemplates HSDT ON HSDT.HealthDataSubTemplateId=CHDA.HealthDataSubTemplateId  AND CHDA.HealthDataSubTemplateId IN (110,111,112,113)
  --INNER JOIN HealthDataSubTemplates HSDT ON HSDT.HealthDataSubTemplateId=CHDA.HealthDataSubTemplateId  
  
  LEFT JOIN STAFF S ON S.UserCode = CHDA.ModifiedBy  
  LEFT JOIN #ClientHTAttributes CH ON CH.DisplayAsAll = S.DisplayAs  
  WHERE CHDA.ClientId = @ClientId  
   AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'  
   AND HDTA.HealthDataTemplateId = @HealthDataTemplateId  
   AND (  
    CHDA.HealthDataTemplateId = @HealthDataTemplateId  
    OR CHDA.HealthDataTemplateId IS NULL  
    )  
   AND CAST(CHDA.HealthRecordDate as DATE) between CAST(ISNULL(@StartDate,'01/01/1753') as Date)  and CAST(ISNULL(@EndDate,'01/01/2999') AS Date)         
   AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'  
   AND ISNULL(HDA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
   AND ISNULL(HDTA.RecordDeleted, 'N') = CASE   
    WHEN CAST(HDTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(HDTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END  
    

  --SelectedAttributeDetails                
  SELECT DISTINCT OCHDA.HealthdataAttributeId  
   ,CASE   
    WHEN CH.DRank >= 2  
     AND OCHDA.HealthRecordDate = CH.OldHealthRecordDate  
     THEN CH.HealthRecordDate  
    ELSE OCHDA.HealthRecordDate  
    END AS HealthRecordDate  
   ,OHDA.Description  
   ,OCHDA.Value  
   ,OCHDA.SubTemplateCompleted  
   ,OHDST.NAME  
   ,S.DisplayAs  
   ,CH.DRank  
   ,MAX(OHDA.DataType) as [DataType]  
  INTO #SelectedAttributeDetails  
  FROM ClientHealthDataAttributes OCHDA  
  INNER JOIN #FilteredAttributes FA ON FA.HealthdataAttributeId = OCHDA.HealthDataAttributeId  
  INNER JOIN HealthDataAttributes OHDA ON OHDA.HealthDataAttributeId = OCHDA.HealthDataAttributeId  
  INNER JOIN HealthDataSubTemplates OHDST ON OHDST.HealthDataSubTemplateId = OCHDA.HealthDataSubTemplateId  
  LEFT JOIN STAFF S ON S.UserCode = OCHDA.ModifiedBy  
  LEFT JOIN #ClientHTAttributes CH ON CH.DisplayAsAll = S.DisplayAs  
  WHERE OCHDA.ClientId = @ClientId  
   AND ISNULL(OCHDA.RecordDeleted, 'N') = 'N'    
   AND ISNULL(OHDA.RecordDeleted, 'N') = CASE   
    WHEN CAST(OHDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(OHDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END                
   AND ISNULL(OHDST.RecordDeleted, 'N') = CASE   
    WHEN CAST(OHDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
     AND CAST(OHDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     THEN 'Y'  
    ELSE 'N'  
    END               
   AND CAST(OCHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
    AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
  GROUP BY OCHDA.HealthdataAttributeId  
   ,OCHDA.HealthRecordDate  
   ,OHDA.Description  
   ,OCHDA.Value  
   ,OCHDA.SubTemplateCompleted  
   ,OHDST.NAME  
   ,S.DisplayAs  
   ,CH.HealthRecordDate  
   ,CH.OldHealthRecordDate  
   ,CH.DRank  
  
  SELECT   
  HealthdataAttributeId,  
  HealthRecordDate,  
  CONVERT(VARCHAR(20), OCHDA.HealthRecordDate, 101) + '  ' + CONVERT(VARCHAR(20), CAST(OCHDA.HealthRecordDate AS TIME), 100) + ' Entered By : ' + DisplayAs + ' ' + Description + ': ' + CASE   
    WHEN (  
      OCHDA.DataType = 8081  
      OR OCHDA.DataType = 8088  
      )  
     THEN dbo.csf_GetGlobalCodeNameById(FLOOR(OCHDA.Value))  
    ELSE OCHDA.Value  
    END + -- 8081 ='DropDown', 8088="RadioButton'               
   ' (' + OCHDA.NAME + ':' + SUBSTRING((  
     SELECT ', (' + HDA.Description + ' ' + CASE   
       WHEN (  
         MAX(HDA.DataType) = 8081  
         OR MAX(HDA.DataType) = 8088  
         )  
        THEN dbo.csf_GetGlobalCodeNameById(FLOOR(CHDA.Value))  
       ELSE CHDA.Value  
       END + ')' -- 8081 ='DropDown', 8088="RadioButton'           
     FROM ClientHealthDataAttributes CHDA  
     INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId  
     INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = CHDA.HealthDataAttributeId  
     WHERE CHDA.HealthDataSubTemplateId IN (  
       SELECT HealthDataSubTemplateId  
       FROM HealthDataSubTemplateAttributes  
       WHERE HealthDataAttributeId = OCHDA.HealthDataAttributeId     
        AND ISNULL(RecordDeleted, 'N') = CASE   
         WHEN CAST(DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
          AND CAST(DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
          THEN 'Y'  
         ELSE 'N'  
         END  
       GROUP BY HealthDataSubTemplateId  
       )  
      AND CHDA.ClientId = @ClientId  
      AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'  
      AND CHDA.HealthRecordDate = OCHDA.HealthRecordDate  
      AND ISNULL(HDST.RecordDeleted, 'N') = CASE   
       WHEN CAST(HDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
        AND CAST(HDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
        THEN 'Y'  
       ELSE 'N'  
       END  
      AND ISNULL(HDA.RecordDeleted, 'N') = CASE   
       WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
        AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
        THEN 'Y'  
       ELSE 'N'  
       END  
      AND CHDA.Value NOT IN (  
       'Y'  
       ,'N'  
       )                
      AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)  
       AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)  
     GROUP BY HDST.NAME  
      ,HDA.Description  
      ,CHDA.Value  
      ,CHDA.HealthRecordDate  
      ,CHDA.SubTemplateCompleted  
     FOR XML PATH('')  
     ), 2, 2500) + + ') ' + CASE   
    WHEN OCHDA.SubTemplateCompleted = 'Y'  
     THEN ' Completed'  
    ELSE ''  
    END 'SelectedAttributeDetails'  
  FROM #SelectedAttributeDetails OCHDA  
  
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
  
  WITH HDGCriteira  
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
   INNER JOIN #FilteredAttributes FA ON FA.HealthdataAttributeId = HDGC.HealthDataAttributeId  
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
  
  SELECT *  
  FROM #HDGCriteira  
  
  SELECT HDGCR.HealthDataGraphCriteriaRangeId  
   ,HDGCR.HealthDataGraphCriteriaId  
   ,HDGCR.LEVEL  
   ,HDGCR.MinimumValue  
   ,HDGCR.MaximumValue  
   ,GC.Color  
  FROM HealthDataGraphCriteriaRanges HDGCR  
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDGCR.LEVEL  
  INNER JOIN #HDGCriteira HC ON HDGCR.HealthDataGraphCriteriaId = HC.HealthDataGraphCriteriaId  
  WHERE ISNULL(HDGCR.RecordDeleted, 'N') = 'N'  
  
  DROP TABLE #HDGCriteira  
  

  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SCSP_GetClientVitals.sql') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                    
    16  
    ,-- Severity.                    
    1 -- State.                    
    );  
 END CATCH  
  
END  