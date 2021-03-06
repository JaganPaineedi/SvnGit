

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGlobalCodesDetailInitData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGlobalCodesDetailInitData]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE  PROCEDURE [dbo].[ssp_PMGlobalCodesDetailInitData]            
 @CategoryId INT       ,
 @Category VARCHAR(20)     
AS     
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMGlobalCodesDetailInitData
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: This SP returns the specified GlobalCodeCategory, related GlobalCodes and GlobalSubCodes
--
-- Author:  Veena S Mani
-- Date:    12 Apr 2011
--
-- *****History****
-- 24 Aug 2011 Girish		Removed References to Rowidentifier and ExternalReferenceId
-- 27 Aug 2011 Girish		Readded References to Rowidentifier and ExternalReferenceId
-- 02 Nov 2011 MSuma		To retrieve Deleted records to check if Category Exists
-- 13 Jan 2012 MSuma		Removed References to Rowidentifier and ExternalReferenceId

--16/06/2012   Shruthi.S    Added code to fix concurrency issue
-- 12/8/2017   Ponnin		Added condition to set parameter value @Category if it is null or empty. Why :For task #629 - Offshore QA Bugs.
*********************************************************************************/       
BEGIN      

IF(ISNULL(@Category, '') = '')
BEGIN
   SET @Category = (SELECT TOP 1 RTRIM(LTRIM(Category)) FROM GlobalCodeCategories WHERE GlobalCodeCategoryId = @CategoryId)
END

    
--GlobalCodeCategories            
SELECT        
  GlobalCodeCategoryId     
  ,RTRIM(LTRIM(Category)) AS Category            
 ,RTRIM(LTRIM(CategoryName)) AS CategoryName            
 ,Active            
 ,AllowAddDelete            
 ,AllowCodeNameEdit            
 ,AllowSortOrderEdit            
 ,Description            
 ,UserDefinedCategory            
 ,RowIdentifier            
 ,CreatedBy            
 ,CreatedDate            
 ,ModifiedBy            
 ,ModifiedDate            
 ,RecordDeleted            
 ,DeletedDate            
 ,DeletedBy            
 ,HasSubcodes            
 ,UsedInPracticeManagement            
 ,UsedInCareManagement            
 ,ExternalReferenceId            
FROM             
 GlobalCodeCategories            
WHERE             
 GlobalCodeCategoryId = @CategoryId           
            
--GlobalCodes            
SELECT              
  GC.GlobalCodeId            
 ,RTRIM(LTRIM(GC.Category)) AS Category            
 ,RTRIM(LTRIM(GC.CodeName)) AS CodeName            
 ,GC.Description            
 ,GC.Active            
 ,GC.CannotModifyNameOrDelete            
 ,GC.SortOrder            
 ,RTRIM(LTRIM(GC.ExternalCode1)) AS ExternalCode1            
 ,GC.ExternalSource1            
 ,RTRIM(LTRIM(GC.ExternalCode2)) AS ExternalCode2            
 ,GC.ExternalSource2            
 ,GC.Bitmap            
 ,GC.Color    
 ,GC.BitmapImage -- Added by Jaspreet ref ticket#776    
 --,GC.RowIdentifier            
 ,GC.CreatedBy            
 ,GC.CreatedDate            
 ,GC.ModifiedBy            
 ,GC.ModifiedDate            
 ,GC.DeletedBy            
 ,GC.RecordDeleted            
 ,GC.DeletedDate              
 --,ExternalReferenceId 
 ,GC.GlobalCodeId as GlobalCodeNo 
 ,GC.Code as Code        
FROM             
 GlobalCodes GC            
WHERE            
 GC.Category = @Category            
ORDER BY GC.GlobalCodeId             
            
--GlobalSubCodes            
SELECT             
  GSC.GlobalSubCodeId            
 ,GSC.GlobalCodeId            
 ,GSC.SubCodeName            
 ,GSC.[Description]            
 ,GSC.Active            
 ,GSC.CannotModifyNameOrDelete            
 ,GSC.SortOrder            
 ,GSC.ExternalCode1            
 ,GSC.ExternalSource1            
 ,GSC.ExternalCode2            
 ,GSC.ExternalSource2            
 ,GSC.Bitmap   
 ,GSC.Color       -- Added by Jaspreet ref ticket#788  
 ,GSC.BitmapImage -- Added by Jaspreet ref ticket#788             
 ,GSC.RowIdentifier            
 ,GSC.CreatedBy            
 ,GSC.CreatedDate            
 ,GSC.ModifiedBy            
 ,GSC.ModifiedDate            
 ,GSC.DeletedBy            
 ,GSC.RecordDeleted            
 ,GSC.DeletedDate            
 ,GSC.GlobalSubCodeId as GlobalSubcodeNo  
 ,GSC.Code as Code        
FROM             
 GlobalSubCodes GSC            
INNER JOIN            
 GlobalCodes GC            
ON            
 GC.GlobalCodeId = GSC.GlobalCodeId            
INNER JOIN            
 GlobalCodeCategories GCC            
ON            
 GCC.Category = GC.Category                
WHERE             
 (GSC.RecordDeleted = 'N' OR GSC.RecordDeleted IS NULL)             
AND            
 (GC.RecordDeleted = 'N' OR GC.RecordDeleted IS NULL)             
AND            
 GCC.Category = @Category   
 
 --Max(GlobalCodeId)
 
 SELECT MAX(GlobalcodeId) FROM GlobalCodes
 
 --Max(GlobalSubcodeId)
 
 SELECT MAX(GlobalSubCodeId) FROM GlobalSubCodes 
 
 --To retrieve Deleted records to check if Category Exists
 
 SELECT GlobalCodeCategoryId,
		Category,
		CategoryName,
		Active,
		AllowAddDelete,
		AllowCodeNameEdit,
		AllowSortOrderEdit,
		Description,
		UserDefinedCategory,
		HasSubcodes,
		UsedInPracticeManagement,
		UsedInCareManagement,
		ExternalReferenceId,
		RowIdentifier,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedDate,
		DeletedBy
	FROM 
	GlobalCodeCategories WHERE RecordDeleted = 'Y'
         
END

GO