 /****** Object:  StoredProcedure [dbo].[ssp_GetDocumentFamilyHistory]    Script Date: 11/13/2013 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDocumentFamilyHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDocumentFamilyHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE  [dbo].[ssp_GetDocumentFamilyHistory]               
(                                        
  @DocumentVersionId int                
)                                         
As                                                                                                                                                        
/*************************************************************/                                                                
/* Stored Procedure: ssp_GetDocumentFamilyHistory			 */                                                                                                                     
/* Creation Date:	 13 Nov 2013						     */                                                                                                                                                                                       
/* Input Parameters: @DocumentVersionId					     */                                                              
/* Author:			 Gayathri Naik							 */            
/* Purpose:			 Gets Data for Family History			 */ 
-- Date				Author			Purpose
-- June 14 2015		Chethan N		What : Retrieving ICD9Code,ICD10CodeId,SNOMEDCODE and SNOMEDCTDescription. 
--									Why : Meaningful Use - Stage 3 task# 12.
-- Aug 02 2018		Chethan N		What : Retrieving Comments. 
--									Why : Engineering Improvement Initiatives- NBL(I) task# 698.
/*************************************************************/                                                                                                                                            
BEGIN TRY                                       
BEGIN       
--------------------FamilyHistory   
  SELECT    
    DocumentFamilyHistoryId,    
    CFH.CreatedBy,    
    CFH.CreatedDate,    
    CFH.ModifiedBy,    
    CFH.ModifiedDate,    
    CFH.RecordDeleted,    
    CFH.DeletedBy,    
    CFH.DeletedDate,    
    DocumentVersionId,    
    FamilyMemberType,    
    IsLiving,    
    CurrentAge,    
    CauseOfDeath,    
    Hypertension,    
    Hyperlipidemia,    
    Diabetes,    
    DiabetesType1,    
    DiabetesType2,    
    Alcoholism,    
    COPD,    
    Depression,    
    ThyroidDisease,    
    CoronaryArteryDisease,    
    Cancer,    
    CancerType,    
    Other,    
    OtherComment,
    CFH.DiseaseConditionDXCode,
    CFH.DiseaseConditionDXCodeDescription,        
    GC.CodeName AS FamilyMemberTypeText,    
    CASE WHEN IsLiving ='Y' THEN 'Yes' WHEN IsLiving ='N' THEN 'No' ELSE '' END AS IsLivingDesc,      
  STUFF(  (    
     CASE WHEN Hypertension = 'Y' THEN ', Hypertension' ELSE '' END +     
     CASE WHEN Hyperlipidemia = 'Y' THEN ', Hyperlipidemia' ELSE '' END +    
     CASE WHEN Diabetes = 'Y' THEN ', Diabetes (' + CASE WHEN DiabetesType1 = 'Y' THEN 'Type1' ELSE '' END +     
       CASE WHEN DiabetesType2 = 'Y' THEN (CASE WHEN DiabetesType1 = 'Y' THEN ',' ELSE '' END) + ' Type2)' ELSE ')' END ELSE '' END +    
     CASE WHEN Other = 'Y' THEN ', Other( '+ CAST(OtherComment AS VARCHAR)+')' ELSE '' END +    
     CASE WHEN Alcoholism = 'Y' THEN ', Alcoholism' ELSE '' END +    
     CASE WHEN COPD = 'Y' THEN ', COPD' ELSE '' END +    
     CASE WHEN Depression = 'Y' THEN ', Depression' ELSE '' END +    
     CASE WHEN ThyroidDisease = 'Y' THEN ', Thyroid Disease' ELSE '' END +    
     CASE WHEN CoronaryArteryDisease = 'Y' THEN ', Coronary Artery Disease' ELSE '' END +    
     CASE WHEN Cancer = 'Y' THEN ', Cancer ('+GCC.CodeName +')' ELSE '' END     
    ),1,2,'')AS DiseaseCondition,    
    CASE WHEN IsLiving ='Y' THEN 'Yes' WHEN IsLiving ='N' THEN 'No' WHEN IsLiving ='U' THEN 'Unknown' ELSE '' END AS IsLivingValue,
    CFH.ICD9Code,
    CFH.ICD10CodeId,
    CFH.SNOMEDCODE,
	SNC.SNOMEDCTDescription,
	CFH.Comments
   FROM DocumentFamilyHistory CFH    
   LEFT JOIN GlobalCodes GC ON CFH.FamilyMemberType = GC.GlobalCodeId and ISNull(GC.RecordDeleted,'N')='N'     
   LEFT JOIN GlobalCodes GCC ON CFH.CancerType = GCC.GlobalCodeId    and ISNull(GCC.RecordDeleted,'N')='N' 
   LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CFH.SNOMEDCODE       
   WHERE DocumentVersionId  = @DocumentVersionId   and ISNull(CFH.RecordDeleted,'N')='N' 
   
END                                                                                          
 END TRY                                                                                                   
 BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetDocumentFamilyHistory')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                                                                                     
 END CATCH  
Go    