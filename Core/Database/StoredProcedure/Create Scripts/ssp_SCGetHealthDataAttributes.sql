 /****** Object:  StoredProcedure [dbo].[ssp_SCGetHealthDataAttributes]    Script Date: 03/29/2012 11:02:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetHealthDataAttributes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetHealthDataAttributes]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetHealthDataAttributes]    Script Date: 03/29/2012 11:02:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

     
      
CREATE Procedure [dbo].[ssp_SCGetHealthDataAttributes]      
    
      
/********************************************************************************                                                            
-- Stored Procedure: dbo.ssp_SCGetHealthDataAttributes                                                              
--                                                            
-- Copyright: Streamline Healthcate Solutions                                                            
--                                                            
-- Purpose: used to Bind DropDown in Team Scheduling list page                                                            
--                                                            
-- Updates:                                                                                                                   
-- Date             Author           Purpose                                                            
-- Aug 09,2012      ROhit Katoch     Created.   
-- Aug 31,2012      Anil chaturvedi  Modified the name of primary key coloumn.
-- Sept 28,2012     Raghu Mohindru   Modified in order to task#20 in Primary Care Bugs/Features, fetched three column values in a string HealthDataValues. 
-- OCT 24 2016 Nandita    What : Added "DropdownType,SharedTableName,StoredProcedureName,TextField,ValueField" columns 
--						  Why : Keystone - Customizations > Tasks #51> Flow Sheet: Ability to filter behavior drop down based on client
*********************************************************************************/        
AS      
BEGIN      
BEGIN TRY      
 SELECT HDA.[HealthDataAttributeId]  
      ,HDA.[CreatedBy]  
      ,HDA.[CreatedDate]  
      ,HDA.[ModifiedBy]  
      ,HDA.[ModifiedDate]  
      ,HDA.[RecordDeleted]  
      ,HDA.[DeletedDate]  
      ,HDA.[DeletedBy]  
      ,HDA.Category  
      ,HDA.DataType  
     -- ,dbo.csf_GetGlobalCodeNameById(HDA.Category) as Category  
     -- ,dbo.csf_GetGlobalCodeNameById(HDA.DataType) as DataType  
      ,HDA.[Name]  
      ,HDA.[Description]  
      ,HDA.[Units]  
      ,HDA.[NumberOfParameters]  
      ,HDA.[Formula]  
      ,HDA.[NumbersAfterDecimal]  
      ,HDA.[DropDownCategory]  
      ,CONVERT(VARCHAR,ISNULL(HDA.[NumberOfParameters],0)) + ',' + CONVERT(VARCHAR,HDA.[DataType]) + ',' + CONVERT(VARCHAR,HDA.[HealthDataAttributeId]) as [HealthDataValues]  
	  ,HDA.DropdownType
	  ,HDA.SharedTableName
	  ,HDA.StoredProcedureName
	  ,HDA.TextField
	  ,HDA.ValueField
  FROM [HealthDataAttributes] AS HDA   
  WHERE   ISNULL(HDA.RecordDeleted,'N') = 'N' and HDA.[Name] IS NOT NULL    
     
   -------------------  [HealthDataSubTemplateAttributeParameters]------------------------   
 SELECT [HealthDataSubTemplateAttributeParameterId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[HealthDataSubTemplateAttributeId]  
      ,[HealthDataAttributeId]  
      ,[OrderNumber]  
  FROM [HealthDataSubTemplateAttributeParameters]       
  WHERE   ISNULL(RecordDeleted,'N') = 'N'         
      
END TRY      
       
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)             
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                  
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCGetHealthDataAttributes')                                                                                                   
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
      