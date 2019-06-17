SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('ssp_SCGetClientHealthDataAttributes', 'P') IS NOT NULL 
    DROP PROCEDURE [dbo].[ssp_SCGetClientHealthDataAttributes]
go

CREATE Procedure [dbo].[ssp_SCGetClientHealthDataAttributes]                
@ClientId INT  ,              
@HealthDataTemplateId INT,              
@HealthRecordDate datetime              
              
/********************************************************************************                                                                        
-- Stored Procedure: dbo.ssp_SCGetClientHealthDataAttributes                                                                          
--                                                                        
-- Copyright: Streamline Healthcate Solutions                                                                        
--                                                                        
-- Purpose: used by Client to Create/ Health Data Attributes              
--                                                                        
-- Updates:                                                                                                                               
-- Date   Author   Purpose                                                                        
-- Aug 24,2012 Rohit Katoch Created.               
-- Aug 24,2012 Rohit Katoch add two Tables HealthDataGraphCriteria and ClientHealthDataSubTemplates ref#19 in Primary Bugs and Features   
--7/Jan/2013Mamta Gupta  Task Primary Care - Summit Pointe - ClientHealthDataSubTemplates table commented. Table removed from Datamodel   
        as it's not used any where in application    
-- 3/11/2013 Vishant garg   Added  HealthDataSubTemplates.Isheading to get in GetData(). with ref to task # 360 Primary care bugs/features                   
-- 05/June/2013 Gayathri Naik    Task #24 in Core Bugs and Features. Added Description field in the table HealthDataSubTemplateAttributes.  
-- Jul 18 2014 Pradeep.A  Selected New columns added to ClientHealthDataAttributes table HealthDataTemplateId,Flag,Range,IsCorrected,Comments,ResultStatus  
-- Apr 28 2015 Chethan N  What : Removing seconds in HealthRecordDate Time compare 
-- Aug 07 2015 Chethan N  What : Replace line feed with <br/>
--						  Why : Summit Pointe - Enhancements task # 1
-- Aug 18 2016 Akwinass   What : Added missing column "HDA.LOINCCode,HDA.AlternativeName1,HDA.AlternativeName2,HDA.AlternativeName3,HDA.AlternativeName4,HDA.AlternativeName5,HDA.AlternativeName6" in "HealthDataAttributes" table select query.
--						  Why : Keystone Environment Issues Tracking #131
-- OCT 13 2016 Akwinass   What : Added "Lock" columns and moved ClientHealthDataAttributes to top.
--						  Why : Woods - Support Go Live #111
-- OCT 24 2016 Nandita    What : Added "DropdownType,SharedTableName,StoredProcedureName,TextField,ValueField" columns 
--						  Why : Keystone - Customizations > Tasks #51> Flow Sheet: Ability to filter behavior drop down based on client
-- DEC 27 2016 Chethan N  What : Added missing columns 'IsLabOrder', 'OrderCode' and 'PatientPortal' to table 'HealthDataTemplates'.
--						  Why : Offshore QA Bugs task #545
*********************************************************************************/                                                                        
as                  
BEGIN                  
BEGIN TRY                  
                
   ---------------------------ClientHealthDataAttributes----------------------------                  
                 
SELECT               
      CHDA.ClientHealthDataAttributeId              
      ,CHDA.HealthDataAttributeId              
      ,CHDA.Value              
      ,CHDA.ClientId              
      ,CHDA.HealthRecordDate              
      ,CHDA.HealthDataSubTemplateId              
      ,CHDA.SubTemplateCompleted              
      ,CHDA.CreatedBy              
      ,CHDA.CreatedDate              
      ,CHDA.ModifiedBy              
      ,CHDA.ModifiedDate              
      ,CHDA.RecordDeleted              
      ,CHDA.DeletedDate              
      ,CHDA.DeletedBy    
      ,CHDA.HealthDataTemplateId  
   ,CHDA.Flag  
   ,CHDA.Range  
   ,CHDA.IsCorrected  
   ,REPLACE(CHDA.Comments,CHAR(13), '<br/>') AS Comments        
   ,CHDA.ResultStatus  
   ,CHDA.Locked
   ,CHDA.LockedBy
   ,CHDA.LockedDate  
   ,(SELECT TOP 1 S.LastName + ', ' + S.FirstName FROM Staff S WHERE S.UserCode = CHDA.LockedBy AND ISNULL(RecordDeleted,'N') = 'N') AS CompletedBy  
  FROM ClientHealthDataAttributes CHDA
WHERE  (CHDA.ClientId =@ClientId )        
-- Chethan N changes          
 -- AND ( HealthRecordDate=@HealthRecordDate)  
   AND   
 CONVERT(VARCHAR(17),CHDA.HealthRecordDate,113)  =  CONVERT(VARCHAR(17),@HealthRecordDate,113)     
   -- End Chethan N changes  
AND (CHDA.HealthDataTemplateId = @HealthDataTemplateId OR CHDA.HealthDataTemplateId IS NULL OR @HealthDataTemplateId IS NULL)
AND ISNULL(CHDA.RecordDeleted,'N')='N'             
                   
                 
  ---------------------------HealthDataTemplates----------------------------                  
SELECT                   
	HDT.HealthDataTemplateId
	,HDT.CreatedBy
	,HDT.CreatedDate
	,HDT.ModifiedBy
	,HDT.ModifiedDate
	,HDT.RecordDeleted
	,HDT.DeletedDate
	,HDT.DeletedBy
	,HDT.TemplateName
	,HDT.Active
	,HDT.NumberOfColumns
	,HDT.IsLabOrder
	,HDT.LoincCode
	,HDT.OrderCode
	,HDT.PatientPortal                    
FROM HealthDataTemplates HDT                 
WHERE                   
(HDT.HealthDataTemplateId =@HealthDataTemplateId )                
                   
AND ISNULL(RecordDeleted,'N')='N'                    
                  
  --------------HealthDataTemplateAttributes----------------                  
SELECT                   
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
HDST.Name as SubTemplateName              
FROM HealthDataTemplateAttributes HDTA                  
INNER JOIN HealthDataTemplates HDT  ON HDT.HealthDataTemplateId=HDTA.HealthDataTemplateId                  
INNER JOIN  HealthDataSubTemplates HDST On HDTA.HealthDataSubTemplateId=HDST.HealthDataSubTemplateId   AND ISNULL(HDST.RecordDeleted,'N')='N'                   
WHERE ISNULL(HDTA.RecordDeleted,'N')='N'                  
 AND ISNULL(HDT.RecordDeleted,'N')='N'                  
 AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId )                    
               
               
------------------------- HealthDataSubTemplates-----------------------------                  
               
 SELECT  distinct               
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
CHDA.HealthRecordDate              
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
               
  SELECT               
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
 HA.Description, 
 HA.DropdownType,
 HA.SharedTableName,
 HA.StoredProcedureName,
 HA.TextField,
 HA.ValueField               
              
FROM HealthDataSubTemplateAttributes as HSA                  
INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HSA.HealthDataSubTemplateId              
INNER JOIN HealthDataAttributes as HA on HSA.HealthDataAttributeId=HA.HealthDataAttributeId                 
INNER JOIN   HealthDataTemplateAttributes HDTA on  HDTA.HealthDataSubTemplateId=HSA.HealthDataSubTemplateId              
              
WHERE  ISNULL(HSA.RecordDeleted,'N')='N'  AND ISNULL(HDST.RecordDeleted,'N')='N'               
AND    ISNULL(HDTA.RecordDeleted,'N')='N'  AND ISNULL(HA.RecordDeleted,'N')='N'               
AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId )                   
               
                   
                
  ------------------------- HealthDataSubTemplateAttributeParameters--------------                  
                   
 SELECT               
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
 HDSTP.DeletedBy                  
FROM HealthDataSubTemplateAttributeParameters HDSTP              
   INNER JOIN   HealthDataSubTemplateAttributes HDSTA on  HDSTA.HealthDataSubTemplateAttributeId=HDSTP.HealthDataSubTemplateAttributeId              
   INNER JOIN   HealthDataTemplateAttributes HDTA on  HDTA.HealthDataSubTemplateId=HDSTA.HealthDataSubTemplateId              
                 
WHERE ISNULL(HDSTP.RecordDeleted,'N')='N'                
AND ISNULL(HDSTA.RecordDeleted,'N')='N'               
AND ISNULL(HDTA.RecordDeleted,'N')='N'                      
AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId )                
              
              
  ---------------------------HealthDataAttributes----------------------------                  
                
                  
SELECT Distinct HDA.[HealthDataAttributeId]                
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
	  ,HDA.DropdownType
	  ,HDA.SharedTableName
	  ,HDA.StoredProcedureName
	  ,HDA.TextField
	  ,HDA.ValueField  
  FROM [HealthDataAttributes] AS HDA              
   Inner JOIN   HealthDataSubTemplateAttributes HDSTA on  HDSTA.HealthDataAttributeId=HDA.HealthDataAttributeId              
   INNER JOIN   HealthDataTemplateAttributes HDTA on  HDTA.HealthDataSubTemplateId=HDSTA.HealthDataSubTemplateId              
              
  WHERE   ISNULL(HDA.RecordDeleted,'N') = 'N'              
  AND   ISNULL(HDSTA.RecordDeleted,'N') = 'N'               
  AND   ISNULL(HDTA.RecordDeleted,'N') = 'N'                  
AND   HDTA.HealthDataTemplateId=@HealthDataTemplateId              
                       
               
                 
               
               
  ---------------------------ClientHealthDataSubTemplates----------------------------                  
--SELECT [ClientHealthdataSubTemplateId]              
--      ,[CreatedBy]              
--      ,[CreatedDate]              
--      ,[ModifiedBy]              
--      ,[ModifiedDate]              
--      ,[RecordDeleted]              
--      ,[DeletedDate]              
--      ,[DeletedBy]              
--      ,[ClientId]              
--      ,[HealthDataSubTemplateId]              
--      ,[HealthRecordDate]              
--      ,[HealthDataSubTemplateCompleted]              
--  FROM ClientHealthDataSubTemplates              
--  WHERE  (ClientId =@ClientId )                
--  AND ( HealthRecordDate=@HealthRecordDate)                   
--  AND ISNULL(RecordDeleted,'N')='N'                 
               
  --------------------HealthDataGraphCriteria---------------------------              
                
                
  SELECT HDGC.[HealthDataGraphCriteriaId]              
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
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCGetClientHealthDataAttributes.sql')                        
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