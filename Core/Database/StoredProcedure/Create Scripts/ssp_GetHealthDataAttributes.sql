IF OBJECT_ID('ssp_GetHealthDataAttributes', 'P') IS NOT NULL 
    DROP PROCEDURE [dbo].[ssp_GetHealthDataAttributes] 
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_GetHealthDataAttributes]           
@HealthDataAttributeId INT              
              
/********************************************************************************                                                                        
-- Stored Procedure: dbo.ssp_GetHealthDataAttributes.sql                                                                          
--                                                                        
-- Copyright: Streamline Healthcate Solutions                                                                        
--                                                                        
-- Purpose: used by Admin to Create/Open HealthdataAttributes              
--                                                                        
-- Updates:                                                                                                                               
-- Date   Author   Purpose                                                                        
-- Aug 14,2012 Varinder Verma Created.  
-- Feb 14 2014 Pradeep	Added new Columns LOINCCode,AlternativeName1,AlternativeName2,AlternativeName3,AlternativeName4,AlternativeName5,AlternativeName6 to HealthDataAttributes             
-- OCT 24 2016 Nandita    What : Added "DropdownType,SharedTableName,StoredProcedureName,TextField,ValueField" columns 
--						  Why : Keystone - Customizations > Tasks #51> Flow Sheet: Ability to filter behavior drop down based on client
-- Jan 20 2017 Bibhu      What: Removed ISNULL(DropdownType,'G') As it was giving error message. ClientHealthDataAttributes.ascx.cs handle null values while fetching Dropdowntype
                          Why:  Renaissance - Environment Issues Tracking #18 
*********************************************************************************/              
AS              
BEGIN                  
BEGIN TRY                  
              
 SELECT HealthDataAttributeId,Category,DataType,Name,[Description],Units,NumberOfParameters,Formula,NumbersAfterDecimal,DropDownCategory,IsSingleLineTextBox,
 LOINCCode,AlternativeName1,AlternativeName2,AlternativeName3,AlternativeName4,AlternativeName5,AlternativeName6,DropdownType,SharedTableName,StoredProcedureName,TextField,ValueField,EMCalculation  -- Jan 20 2017 Bibhu  
  ,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy              
 FROM HealthDataAttributes               
 WHERE HealthDataAttributeId = CASE WHEN @HealthDataAttributeId IS NULL OR @HealthDataAttributeId = -1 THEN HealthDataAttributeId ELSE @HealthDataAttributeId END              
  AND ISNULL(RecordDeleted,'N')='N'              
              
              
SELECT HDGC.HealthDataGraphCriteriaId, HDGC.HealthDataAttributeId, HDGC.MinimumValue, HDGC.MaximumValue, HDGC.Sex, HDGC.AllAge, HDGC.AgeFrom, HDGC.AgeTo              
 ,HDGC.Priority, HDGC.CreatedBy, HDGC.CreatedDate, HDGC.ModifiedBy, HDGC.ModifiedDate, HDGC.RecordDeleted, HDGC.DeletedDate, HDGC.DeletedBy ,
   HDA.DropdownType,HDA.SharedTableName,HDA.StoredProcedureName,HDA.TextField,HDA.ValueField    -- Jan 20 2017 Bibhu 
 ,GC.CodeName AS SexText, HDA.Name AS HealthDataAttributeIdText,              
  (SELECT HealthDataGraphCriteriaRangeId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate,DeletedBy,               
  HealthDataGraphCriteriaId, [Level], MinimumValue, MaximumValue                
  FROM HealthDataGraphCriteriaRanges              
  WHERE HealthDataGraphCriteriaId = HDGC.HealthDataGraphCriteriaId AND ISNULL(RecordDeleted,'N')='N'              
  FOR XML PATH ('HealthDataGraphCriteriaRanges'), ROOT('MainDataset'),ELEMENTS XSINIL)               
AS GraphRange              
FROM HealthDataGraphCriteria HDGC              
INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = HDGC.HealthDataAttributeId              
LEFT JOIN GlobalCodes GC ON HDGC.Sex = GC.GlobalCodeId              
WHERE HDGC.HealthDataAttributeId = @HealthDataAttributeId AND ISNULL(HDGC.RecordDeleted,'N')='N'              
              
SELECT HealthDataGraphCriteriaRangeId,HealthDataGraphCriteriaId,[Level],MinimumValue,MaximumValue              
 ,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy              
FROM HealthDataGraphCriteriaRanges              
WHERE ISNULL(RecordDeleted,'N')='N'              
              
              
              
END TRY              
                   
 BEGIN CATCH                  
  DECLARE @Error VARCHAR(8000)                         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetHealthDataAttributes.sql')                                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY())                                   
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())                  
  RAISERROR                  
  (                  
   @Error, -- Message text.                  
   16,  -- Severity.                  
   1  -- State.                  
  );                  
 END CATCH                  
               
                  
END 