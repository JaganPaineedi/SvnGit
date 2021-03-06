/****** Object:  StoredProcedure [dbo].[ssp_InitNewEntryFlowSheet]    Script Date: 07/24/2015 12:06:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitNewEntryFlowSheet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitNewEntryFlowSheet]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitNewEntryFlowSheet]    Script Date: 07/24/2015 12:06:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
  
CREATE PROCEDURE [dbo].[ssp_InitNewEntryFlowSheet] (  
 @ClientID INT  
 ,@StaffID INT  
 ,@CustomParameters XML  
 )  
AS  
/*********************************************************************/  
/* Stored Procedure: [ssp_InitNewEntryFlowSheet]               */  
/* Creation Date:  10/OCT/2016                                    */  
/* Purpose: To Initialize */  
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/  
-- Updates:                                                                                                                                 
-- Date         Author                     Purpose                                                                          
-- OCT 13 2016  Akwinass   What : Created.  
--         Why : Woods - Support Go Live #111  
-- 25 Sept 2017  Vandana Ojha      Modified to initialize height field from previous vitals 
--								   if key 'InitializeHeightFromPreviousVitals' is yes
--								   Task #1120 Valley-Enhancements

/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  SET ARITHABORT ON   
  DECLARE @HealthDataTemplateId INT  
   ,@HealthRecordDate DATETIME  
   ,@CustomHealthRecordDate VARCHAR(50) = ''  
  
  SET @HealthDataTemplateId = @CustomParameters.value('(/Root/Parameters/@HealthDataTemplateId)[1]', 'varchar(20)');  
  SET @CustomHealthRecordDate = @CustomParameters.value('(/Root/Parameters/@HealthRecordDate)[1]', 'varchar(50)');  
  
  IF ISNULL(@CustomHealthRecordDate, '') <> ''  
   SET @HealthRecordDate = CAST(@CustomHealthRecordDate AS DATETIME)  
     
  IF OBJECT_ID('tempdb..#ClientHealthDataAttributes') IS NOT NULL  
   DROP TABLE #ClientHealthDataAttributes  
  
  CREATE TABLE #ClientHealthDataAttributes (  
   [ClientHealthDataAttributeId] int IDENTITY(1, 1)  
   ,[HealthDataAttributeId] int  
   ,[ClientId] int  
   ,[Value] varchar(200)   
   ,[HealthRecordDate] datetime  
   ,[HealthDataSubTemplateId] int  
   ,[SubTemplateCompleted] CHAR(1)  
   ,[HealthDataTemplateId] INT  
   ,[HealthRecordDateFormatted] VARCHAR(50)  
   )  
  
  INSERT INTO #ClientHealthDataAttributes (HealthDataAttributeId,HealthDataSubTemplateId)  
  SELECT DISTINCT HDA.[HealthDataAttributeId]  
   ,HDTA.HealthDataSubTemplateId  
  FROM [HealthDataAttributes] AS HDA  
  INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDSTA.HealthDataAttributeId = HDA.HealthDataAttributeId  
  INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId  
  WHERE ISNULL(HDA.RecordDeleted, 'N') = 'N'  
   AND ISNULL(HDSTA.RecordDeleted, 'N') = 'N'  
   AND ISNULL(HDTA.RecordDeleted, 'N') = 'N'  
   AND HDTA.HealthDataTemplateId = @HealthDataTemplateId  
     
  UPDATE #ClientHealthDataAttributes  
  SET [ClientId] = @ClientID  
   ,[HealthRecordDate] = @HealthRecordDate  
   ,[SubTemplateCompleted] = 'N'  
   ,[HealthDataTemplateId] = @HealthDataTemplateId  
   ,[HealthRecordDateFormatted] = @CustomHealthRecordDate  
   
   --Task #1120 Valley-Enhancements--
     
 
   DECLARE @Value varchar(20)  
   SET @Value=(SELECT Value  
   FROM SystemConfigurationKeys  
   WHERE [Key] = 'InitializeHeightFromPreviousVitals')   
   IF (@Value='Yes')  
   BEGIN   
		DECLARE @HeightValue varchar(200)  
		SET @HeightValue = (SELECT Top 1 Value FROM ClientHealthDataAttributes   
        WHERE [HealthDataSubTemplateId] = 111 AND [HealthDataAttributeId] = 111   
        AND ClientId=@ClientID AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY HealthRecordDate DESC)   
    
       UPDATE #ClientHealthDataAttributes    
       SET [Value] = @HeightValue  
       WHERE [HealthDataSubTemplateId] = 111 AND [HealthDataAttributeId] = 111   
   END  
     
     
  SELECT 'ClientHealthDataAttributes' AS TableName  
   ,(-1 * [ClientHealthDataAttributeId]) AS ClientHealthDataAttributeId  
   ,[HealthDataAttributeId]  
   ,[ClientId]  
   ,[Value]  
   ,[HealthRecordDate]  
   ,[HealthDataSubTemplateId]  
   ,[SubTemplateCompleted]  
   ,[HealthDataTemplateId]  
   ,[HealthRecordDateFormatted]  
  FROM #ClientHealthDataAttributes  
  
    
---------------------------HealthDataTemplates----------------------------                    
SELECT 'HealthDataTemplates' AS TableName,                   
HealthDataTemplateId,                    
TemplateName,                    
Active,    
NumberOfColumns ,                    
CreatedBy,                    
CreatedDate,                    
ModifiedBy,                    
ModifiedDate,                    
RecordDeleted,                    
DeletedDate,                    
DeletedBy,    
LoincCode,  
'N' AS IsInitialize                      
FROM HealthDataTemplates                      
WHERE                     
(HealthDataTemplateId =@HealthDataTemplateId )                  
                     
AND ISNULL(RecordDeleted,'N')='N'                      
                    
  --------------HealthDataTemplateAttributes----------------                    
SELECT 'HealthDataTemplateAttributes' AS TableName,                     
HDTA.HealthDataTemplateAttributeId,                    
HDTA.HealthDataTemplateId,                    
HDTA.HealthDataSubTemplateId,                    
HDTA.HealthDataGroup,                    
HDTA.EntryDisplayOrder,                    
HDTA.ShowCompletedCheckBox,                    
HDTA.CreatedBy,                    
HDTA.CreatedDate,                    
HDTA.ModifiedBy,                    
HDTA.ModifiedDate,                    
HDTA.RecordDeleted,                    
HDTA.DeletedDate,                    
HDTA.DeletedBy,                    
HDST.Name as SubTemplateName,      
'N' AS IsInitialize            
FROM HealthDataTemplateAttributes HDTA                    
INNER JOIN HealthDataTemplates HDT  ON HDT.HealthDataTemplateId=HDTA.HealthDataTemplateId                    
INNER JOIN  HealthDataSubTemplates HDST On HDTA.HealthDataSubTemplateId=HDST.HealthDataSubTemplateId   AND ISNULL(HDST.RecordDeleted,'N')='N'                     
WHERE ISNULL(HDTA.RecordDeleted,'N')='N'                    
 AND ISNULL(HDT.RecordDeleted,'N')='N'                    
 AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId )                      
                 
                 
------------------------- HealthDataSubTemplates-----------------------------                    
                 
 SELECT  distinct  'HealthDataSubTemplates' AS TableName,               
HDST.HealthDataSubTemplateId,                    
HDST.Name,                
HDST.Active,                    
HDST.CreatedBy,                    
HDST.CreatedDate,                    
HDST.ModifiedBy,                    
HDST.ModifiedDate,                    
HDST.RecordDeleted,                    
HDST.DeletedDate,                    
HDST.DeletedBy ,       
HDST.IsHeading,               
CHDA.SubTemplateCompleted,                 
CHDA.HealthRecordDate,  
'N' AS IsInitialize                
FROM HealthDataSubTemplates  HDST                
 INNER JOIN   HealthDataTemplateAttributes HDTA ON  HDTA.HealthDataSubTemplateId=HDST.HealthDataSubTemplateId                
 LEFT JOIN  ClientHealthDataAttributes CHDA ON  HDTA.HealthDataSubTemplateId=CHDA.HealthDataSubTemplateId                  
    AND ISNULL(CHDA.RecordDeleted,'N')='N'                 
    AND CHDA.ClientId =@ClientId                
      AND ( CHDA.HealthRecordDate=@HealthRecordDate)                
WHERE ISNULL(HDST.RecordDeleted,'N')='N'                       
    AND ISNULL(HDTA.RecordDeleted,'N')='N'                     
    AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId )                 
                  
                   
 ------------------------- HealthDataSubTemplateAttributes-----------------------------                    
                 
  SELECT  'HealthDataSubTemplateAttributes' AS TableName,               
  HSA.HealthDataSubTemplateAttributeId,                    
 HSA.HealthDataSubTemplateId,                    
 HSA.DisplayInFlowSheet,                    
 HSA.OrderInFlowSheet  ,          
 HSA.IsSingleLineDisplay,                
 HSA.CreatedBy,                    
 HSA.CreatedDate,                    
 HSA.ModifiedBy,                    
 HSA.ModifiedDate,                    
 HSA.RecordDeleted,                    
 HSA.DeletedDate,                    
 HSA.DeletedBy,                
 HSA.HealthDataAttributeId,                     
 HA.Name As AttributeName,    
 HA.Description,   'N' AS IsInitialize                    
                
FROM HealthDataSubTemplateAttributes as HSA                    
INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HSA.HealthDataSubTemplateId                
INNER JOIN HealthDataAttributes as HA on HSA.HealthDataAttributeId=HA.HealthDataAttributeId                   
INNER JOIN   HealthDataTemplateAttributes HDTA on  HDTA.HealthDataSubTemplateId=HSA.HealthDataSubTemplateId                
                
WHERE  ISNULL(HSA.RecordDeleted,'N')='N'  AND ISNULL(HDST.RecordDeleted,'N')='N'                 
AND    ISNULL(HDTA.RecordDeleted,'N')='N'  AND ISNULL(HA.RecordDeleted,'N')='N'                 
AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId )                     
                 
                     
                  
  ------------------------- HealthDataSubTemplateAttributeParameters--------------                    
                     
 SELECT  'HealthDataSubTemplateAttributeParameters' AS TableName,               
 HDSTP.HealthDataSubTemplateAttributeParameterId,                    
 HDSTP.HealthDataSubTemplateAttributeId,                    
 HDSTP.HealthDataAttributeId,                
 HDSTP.OrderNumber,                    
 HDSTP.CreatedBy,                    
 HDSTP.CreatedDate,                    
 HDSTP.ModifiedBy,                    
 HDSTP.ModifiedDate,                    
 HDSTP.RecordDeleted,                    
 HDSTP.DeletedDate,                    
 HDSTP.DeletedBy,  
 'N' AS IsInitialize                    
FROM HealthDataSubTemplateAttributeParameters HDSTP                
   INNER JOIN   HealthDataSubTemplateAttributes HDSTA on  HDSTA.HealthDataSubTemplateAttributeId=HDSTP.HealthDataSubTemplateAttributeId                
   INNER JOIN   HealthDataTemplateAttributes HDTA on  HDTA.HealthDataSubTemplateId=HDSTA.HealthDataSubTemplateId                
                   
WHERE ISNULL(HDSTP.RecordDeleted,'N')='N'                  
AND ISNULL(HDSTA.RecordDeleted,'N')='N'                 
AND ISNULL(HDTA.RecordDeleted,'N')='N'                        
AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId )                  
                
                
  ---------------------------HealthDataAttributes----------------------------                    
                  
                    
SELECT Distinct 'HealthDataAttributes' AS TableName  
   ,HDA.[HealthDataAttributeId]                  
      ,HDA.[CreatedBy]                  
      ,HDA.[CreatedDate]                  
      ,HDA.[ModifiedBy]                  
      ,HDA.[ModifiedDate]                  
      ,HDA.[RecordDeleted]                  
      ,HDA.[DeletedDate]                  
      ,HDA.[DeletedBy]                  
   ,HDA.Category                  
   ,HDA.DataType                  
      ,HDA.[Name]                  
      ,HDA.[Description]                  
      ,HDA.[Units]                  
      ,HDA.[NumberOfParameters]                  
      ,HDA.[Formula]                  
      ,HDA.[NumbersAfterDecimal]                  
      ,HDA.[DropDownCategory]                  
      ,HDTA.HealthDataSubTemplateId              
      ,HDA.IsSingleLineTextBox     
      -- Aug 18 2016 Akwinass  
   ,HDA.LOINCCode  
   ,HDA.AlternativeName1  
   ,HDA.AlternativeName2  
   ,HDA.AlternativeName3  
   ,HDA.AlternativeName4  
   ,HDA.AlternativeName5  
   ,HDA.AlternativeName6  
   ,'N' AS IsInitialize     
  FROM [HealthDataAttributes] AS HDA                
   Inner JOIN   HealthDataSubTemplateAttributes HDSTA on  HDSTA.HealthDataAttributeId=HDA.HealthDataAttributeId                
   INNER JOIN   HealthDataTemplateAttributes HDTA on  HDTA.HealthDataSubTemplateId=HDSTA.HealthDataSubTemplateId                
                
  WHERE   ISNULL(HDA.RecordDeleted,'N') = 'N'                
  AND   ISNULL(HDSTA.RecordDeleted,'N') = 'N'                 
  AND   ISNULL(HDTA.RecordDeleted,'N') = 'N'                    
AND   HDTA.HealthDataTemplateId=@HealthDataTemplateId                
                         
                 SELECT 'HealthDataGraphCriteria' AS TableName  
   ,HDGC.[HealthDataGraphCriteriaId]                
      ,HDGC.[CreatedBy]                
      ,HDGC.[CreatedDate]                
      ,HDGC.[ModifiedBy]                
      ,HDGC.[ModifiedDate]                
      ,HDGC.[RecordDeleted]                
      ,HDGC.[DeletedDate]                
   ,HDGC.[DeletedBy]                
      ,HDGC.[HealthDataAttributeId]                
      ,HDGC.[MinimumValue]                
      ,HDGC.[MaximumValue]                
      ,HDGC.[Sex]                
      ,HDGC.[AllAge]                
      ,HDGC.[AgeFrom]                
      ,HDGC.[AgeTo]                
      ,HDGC.[Priority]  
      ,'N' AS IsInitialize                
  FROM HealthDataGraphCriteria as HDGC                
       Inner JOIN   HealthDataSubTemplateAttributes HDSTA on  HDSTA.HealthDataAttributeId=HDGC.HealthDataAttributeId                
   INNER JOIN   HealthDataTemplateAttributes HDTA on  HDTA.HealthDataSubTemplateId=HDSTA.HealthDataSubTemplateId                
                
  WHERE   ISNULL(HDGC.RecordDeleted,'N') = 'N'                
  AND   ISNULL(HDSTA.RecordDeleted,'N') = 'N'                 
  AND   ISNULL(HDTA.RecordDeleted,'N') = 'N'                    
AND   HDTA.HealthDataTemplateId=@HealthDataTemplateId   
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_InitNewEntryFlowSheet]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                        
    16  
    ,-- Severity.                                                                                                        
    1 -- State.                                                                                                        
    );  
 END CATCH  
END  
  