IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentFamilyHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentFamilyHistory]
GO

CREATE PROCEDURE  [dbo].[ssp_RDLDocumentFamilyHistory]                       
(                                      
  @DocumentVersionId int              
)                                       
As                                                                                                                                                      
/************************************************************/                                                              
/* Stored Procedure: ssp_RDLDocumentFamilyHistory           */                                                                                                               
/* Creation Date:  14 Nov 2013								*/                                                                                                                           
/* Purpose: Gets Data for Family History					*/                                                             
/* Input Parameters: @DocumentVersionId						*/                                                                                                                        
/* Author: Gayathri Naik									*/  
/* Gayathri Naik		11/20/2013		Left join with Documents table added*/   
/* Gayathri Naik		11/20/2013		Added 'Unknown' if IsLiving is 'U'*/  
/* Pavani               20/06/2016      Added ICD9Code,ICD10CodeId,SNOMEDCODE columns
                                        Meaningful Use  Task#12 - Stage 3
-- Chethan N			Aug 02 2018		What : Retrieving Comments. 
--										Why : Engineering Improvement Initiatives- NBL(I) task# 698.*/
/************************************************************/                                                                                                                                          
BEGIN TRY                                     
BEGIN
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
		GC.CodeName AS FamilyMemberTypeName,
		D.ClientId,
		 CFH.DiseaseConditionDXCodeDescription AS DiseaseCondition, 
		CASE WHEN IsLiving ='Y' THEN 'Yes' WHEN IsLiving ='N' THEN 'No' ELSE 'Unknown' END AS IsLivingDesc,		
		--STUFF(  (  
		--   CASE WHEN Hypertension = 'Y' THEN ', Hypertension' ELSE '' END +   
		--   CASE WHEN Hyperlipidemia = 'Y' THEN ', Hyperlipidemia' ELSE '' END +  
		--   CASE WHEN Diabetes = 'Y' THEN ', Diabetes (' + CASE WHEN DiabetesType1 = 'Y' THEN 'Type1' ELSE '' END +   
		--			  CASE WHEN DiabetesType2 = 'Y' THEN (CASE WHEN DiabetesType1 = 'Y' THEN ',' ELSE '' END) + ' Type2)' ELSE ')' END ELSE '' END +  
		--   CASE WHEN Other = 'Y' THEN ', Other( '+ CAST(OtherComment AS VARCHAR)+')' ELSE '' END +  
		--   CASE WHEN Alcoholism = 'Y' THEN ', Alcoholism' ELSE '' END +  
		--   CASE WHEN COPD = 'Y' THEN ', COPD' ELSE '' END +  
		--   CASE WHEN Depression = 'Y' THEN ', Depression' ELSE '' END +  
		--   CASE WHEN ThyroidDisease = 'Y' THEN ', Thyroid Disease' ELSE '' END +  
		--   CASE WHEN CoronaryArteryDisease = 'Y' THEN ', Coronary Artery Disease' ELSE '' END +  
		--   CASE WHEN Cancer = 'Y' THEN ', Cancer ('+GCC.CodeName +')' ELSE '' END   
		--  ),1,2,'') AS DiseaseCondition
		
	--Pavani 20/06/2016
    CFH.ICD9Code,
    CFH.ICD10CodeId,
    CFH.SNOMEDCODE,
    SNC.SNOMEDCTDescription,
    --End	
    CFH.DiseaseConditionDXCode,	
    CFH.Comments
	FROM DocumentFamilyHistory CFH
	LEFT JOIN GlobalCodes GC ON CFH.FamilyMemberType = GC.GlobalCodeId and ISNull(GC.RecordDeleted,'N')='N' 
	LEFT JOIN GlobalCodes GCC ON CFH.CancerType = GCC.GlobalCodeId and ISNull(GCC.RecordDeleted,'N')='N' 
	--Pavani 20/06/2016
	LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CFH.SNOMEDCODE 
	--End
	left join Documents D on CFH.DocumentVersionId=D.CurrentDocumentVersionId and ISNull(D.RecordDeleted,'N')='N' 
	WHERE DocumentVersionId  = @DocumentVersionId and ISNull(CFH.RecordDeleted,'N')='N' 
	
END                                                                                        
 END TRY                                                                                                 
 BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLDocumentFamilyHistory')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                     
                                                                                                                                
 END CATCH 