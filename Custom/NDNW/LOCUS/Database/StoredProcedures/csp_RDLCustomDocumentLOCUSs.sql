/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentLOCUSs]    Script Date: 11/21/2013******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentLOCUSs]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomDocumentLOCUSs]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentLOCUSs]     Script Date: 11/21/2013******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentLOCUSs]                               
(                                      
@DocumentVersionId  int       
)                                      
As                                    
                                              
BEGIN TRY                                     
BEGIN                                              
/************************************************************************/                                                
/* Stored Procedure: [csp_RDLCustomDocumentLOCUSs]    */                                                                   
/* Copyright: 2011 Streamline SmartCare                            */                                                                            
/* Creation Date:  May 04 ,2014                                   */                                                
/*                                                                 */                                                
/* Purpose: Gets Data for CustomDocumentLOCUSs  task #10 MFS Customizations    */                                               
/*                                                                 */                                              
/* Input Parameters: @DocumentVersionId                            */                                              
/*                                                                 */                                                 
/* Output Parameters:                                              */                                                
/* Purpose: Used In RDL Report  of  CustomDocumentLOCUSs                                    */    
/* Call By:                                                        */                                      
/* Calls:                                                          */                                                
/*                                                                 */                                                
/* Author:Dhanil Manuel                                         */                                                
/************************************************************************/   
 
 
 
 select
 (Select OrganizationName from SystemConfigurations) as OrganizationName,
  Documents.ClientId,Clients.LastName + ', ' + Clients.FirstName as ClientName ,  
  EffectiveDate = CONVERT(varchar,Documents.EffectiveDate,101),
  CONVERT(varchar,Clients.DOB ,101) as DOB,
   case when SectionIScore=1 then
  '1- Minimal risk of harm'   when SectionIScore=2 then 
  '2- Low risk of harm'   when SectionIScore=3 then
  '3- Moderate risk of harm'   when SectionIScore=4 then
  '4 - Serious risk of harm'   when SectionIScore=5 then
  '5 - Extreme risk of harm'
   else  '' end as SectionIScore,
  
   case when SectionIIScore=1 then  '1 - Minimal Impairment'
   when SectionIIScore=2 then  '2 - Mild Impairment'
   when SectionIIScore=3 then  '3 - Moderate Impairment'
   when SectionIIScore=4 then  '4 - Serious Impairment'
   when SectionIIScore=5 then   '5 - Severe Impairment'
   else '' end as SectionIIScore,
   
     case when SectionIIIScore=1 then  '1 - No Co-morbidity'
   when SectionIIIScore=2 then  '2 - Minor Co-morbidity'
   when SectionIIIScore=3 then  '3 - Significant Co-morbidity'
   when SectionIIIScore=4 then  '4 - Major Co-morbidity'
   when SectionIIIScore=5 then  '5 - Severe Co-morbidity'
   else '' end as  SectionIIIScore,
 
   case when SectionIVaScore=1 then  '1 - Low Stress Environment'
   when SectionIVaScore=2 then  '2 - Mildly Stressful Environment'
   when SectionIVaScore=3 then  '3 - Moderately Stressful Environment'
   when SectionIVaScore=4 then  '4 - Highly Stressful Environment'
   when SectionIVaScore=5 then  '5 - Extremely Stressful Environment'
   else '' end as SectionIVaScore,
   


   case when SectionIVbScore=1 then  '1 - Highly Supportive Environment'
   when SectionIVbScore=2 then  '2 - Supportive Environment'
   when SectionIVbScore=3 then  '3 - Limited Support in Environment'
   when SectionIVbScore=4 then  '4 - Minimal Support in Environment'
   when SectionIVbScore=5 then  '5 - No Support in Environment'
   else '' end as SectionIVbScore,
  
   case when SectionVScore=1 then  '1 - Fully Responsive to Treatment and Recovery Management'
   when SectionVScore=2 then  '2 - Significant Response to Treatment and Recovery Management'
   when SectionVScore=3 then  '3 - Moderate or Equivocal Response to Treatment and Recovery Management'
   when SectionVScore=4 then  '4 - Poor Response to Treatment and Recovery Management'
   when SectionVScore=5 then  '5 - Negligible Response to Treatment'
   else '' end as SectionVScore,
   
   case when SectionVIScore=1 then  '1 - Optimal Engagement'
   when SectionVIScore=2 then  '2 - Positive Engagement'
   when SectionVIScore=3 then  '3 - Limited Engagement'
   when SectionVIScore=4 then  '4 - Minimal Engagement'
   when SectionVIScore=5 then  '5 - Unengaged'
   else '' end  as SectionVIScore,
   isnull(CompositeScore,'') as CompositeScore,
   
   case when LOCUSRecommendedLevelOfCare=1 then  'Service Level I'
   when LOCUSRecommendedLevelOfCare=2 then  'Service Level II'
   when LOCUSRecommendedLevelOfCare=3 then  'Service Level III'
   when LOCUSRecommendedLevelOfCare=4 then  'Service Level IV'
   when LOCUSRecommendedLevelOfCare=5 then  'Service Level V'
   when LOCUSRecommendedLevelOfCare=6 then  'Service Level VI'
   else '' end as LOCUSRecommendedLevelOfCare,	
   
   
   case when AssessorRecommendedLevelOfcare=1 then  ''
   when AssessorRecommendedLevelOfcare=2 then  'Service Level II'
   when AssessorRecommendedLevelOfcare=3 then  'Service Level III'
   when AssessorRecommendedLevelOfcare=4 then  'Service Level IV'
   when AssessorRecommendedLevelOfcare=5 then  'Service Level V'
   when AssessorRecommendedLevelOfcare=6 then  'Service Level VI'
   else '' end as AssessorRecommendedLevelOfcare,
   isnull(ReasonForDeviation,'') as  ReasonForDeviation,
   isnull(Comments,'') as  Comments,
   DocumentVersions.DocumentVersionId 
   from CustomDocumentLOCUSs
    inner join Documents on Documents.inprogressDocumentversionId=CustomDocumentLOCUSs.documentVersionId
   INNER JOIN DocumentVersions  ON Documents.DocumentId = DocumentVersions.DocumentId                       
 JOIN Clients ON Clients.ClientId = Documents.ClientId  
  where CustomDocumentLOCUSs.DocumentVersionId= @DocumentVersionId
  
 END                                                                                        
END TRY                                                                                                 
--Checking For Errors                                      
BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_RDLCustomDocumentLOCUSs]')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                                
END CATCH  