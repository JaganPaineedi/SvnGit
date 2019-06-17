 /****** Object:  StoredProcedure [dbo].[ssp_GetHealthDataAndTemplates]    Script Date: 08/07/2012 12:36:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHealthDataAndTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHealthDataAndTemplates]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetHealthDataAndTemplates]    Script Date: 08/07/2012 12:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
CREATE Procedure [dbo].[ssp_GetHealthDataAndTemplates]    
@HealthDataTemplateId INT

/********************************************************************************                                                          
-- Stored Procedure: dbo.ssp_GetHealthDataAndTemplates.sql                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: used by Admin to Create/Open Templates
--                                                          
-- Updates:                                                                                                                 
-- Date			Author			Purpose                                                          
-- Aug 07,2012	Varinder Verma	Created. 
-- Jul 17,2013  Praveen Potnuru Modified //Added new fields IsLabOrder and LoincCode to tabel HealthDataTemplates
-- Mar 07 2014	PradeepA		Added New column "OrderCode" #1906 (Summit Pointe Support)
-- june 9 2015  Hemant          Added New column "PatientPortal" in the table HealthDataTemplates why:Flow Sheet #60 Macon County Design 
-- June 01 2017  Manjunath K	What : Added DefaultDateRange column from HealthDataTemplates Table.
--							    Why : Engineering Improvement Initiatives- NBL(I) #525. 
*********************************************************************************/                                                          
as    
BEGIN    
BEGIN TRY    
     
  ---------------------------HealthDataTemplates----------------------------    
SELECT     
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
IsLabOrder,
LoincCode,
OrderCode,
PatientPortal,
DefaultDateRange   
FROM HealthDataTemplates      
WHERE     
(HealthDataTemplateId =@HealthDataTemplateId  OR  ISNULL(@HealthDataTemplateId, 0) = 0)  
     
AND ISNULL(RecordDeleted,'N')='N'      
    
    
  --------------HealthDataTemplateAttributes----------------    
SELECT     
HDTA.HealthDataTemplateAttributeId,    
HDTA.HealthDataTemplateId,    
HDTA.HealthDataSubTemplateId,    
HDTA.HealthDataGroup,    
HDST.Name,    
HDTA.EntryDisplayOrder,    
HDTA.ShowCompletedCheckBox ,    
HDTA.CreatedBy,    
HDTA.CreatedDate,    
HDTA.ModifiedBy,    
HDTA.ModifiedDate,    
HDTA.RecordDeleted,    
HDTA.DeletedDate,    
HDTA.DeletedBy,    
HDTA.HealthDataSubTemplateId, 
dbo.csf_GetGlobalCodeNameById(HDTA.HealthDataGroup) as HealthDataGroupName    

FROM HealthDataTemplateAttributes HDTA    
INNER JOIN HealthDataTemplates HDT  ON HDT.HealthDataTemplateId=HDTA.HealthDataTemplateId    
INNER JOIN HealthDataSubTemplates HDST On HDTA.HealthDataSubTemplateId=HDST.HealthDataSubTemplateId    
WHERE ISNULL(HDTA.RecordDeleted,'N')='N'    
 AND ISNULL(HDT.RecordDeleted,'N')='N'    
 AND ISNULL(HDST.RecordDeleted,'N')='N'    
 AND (HDTA.HealthDataTemplateId = @HealthDataTemplateId OR  ISNULL(@HealthDataTemplateId, 0) = 0)      
     
 
      
END TRY
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetHealthDataAndTemplates.sql')                                                                                                 
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



GO
