
/****** Object:  StoredProcedure [dbo].[SSP_RDLSubReportDocumentHeaderCarePlanReview]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_RDLSubReportDocumentHeaderCarePlanReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_RDLSubReportDocumentHeaderCarePlanReview]
GO


/****** Object:  StoredProcedure [dbo].[SSP_RDLSubReportDocumentHeaderCarePlanReview]    Script Date: 08/08/2014 08:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SSP_RDLSubReportDocumentHeaderCarePlanReview]  -- 42354         
@DocumentVersionId int            
                    
 AS                     
/*********************************************************************/                                                                                        
 /* Stored Procedure: [SSP_RDLSubReportDocumentHeaderCarePlanReview]               */                                                                               
 /* Creation Date:  17/Feb/2012                                    */                                                                                        
 /* Purpose: To Initialize */                                                                                       
 /* Input Parameters:   @DocumentVersionId */                                                                                      
 /* Output Parameters:                                */                                                                                        
 /* Return:   */                                                                                        
 /* Called By: RdlSubReportDocumentHeaderCarePlanReview  */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /*   Updates:                                                          */                                                                                        
 /*       Date              Author                  Purpose    */  
 /*	      25/06/13          Veena                   Threshold Bugs and Features #3264	*/      
 --		22-DEC-2015			Basudev Sahu			 Modified For Task #609 Network180 Customization to Get Organisation  As															ClientName
 /*********************************************************************/  
BEGIN TRY    
                
SELECT  DocumentCodes.DocumentName  
        ,Documents.DocumentId          
        ,(select OrganizationName from SystemConfigurations ) as OrganizationName          
        ,CONVERT(VARCHAR(10),Documents.EffectiveDate,101) as EffectiveDate   
        ,CONVERT(VARCHAR(10),DATEADD(mm,6,Documents.EffectiveDate),101) as ToDate   
        ,CASE       
		  WHEN ISNULL(Clients.ClientType, 'I') = 'I'  
		   THEN ISNULL(Clients.LastName, '') + ' ' + ISNULL(Clients.FirstName, '')  
		  ELSE ISNULL(Clients.OrganizationName, '')  
		  END AS ClientName 
        --,ISNULL(Clients.FirstName, '') + ' ' + ISNULL(Clients.LastName, '') AS ClientName           
        ,Clients.ClientId       
        ,DocumentCodes.DocumentCodeId  
        ,NULL  As ReviewPeriodFromDate
        ,NULL As ReviewPeriodToDate
        ,CASE WHEN ReviewPeriodFromDate IS NULL AND ReviewPeriodToDate IS NULL THEN NULL 
				ELSE  ISNULL(CONVERT(VARCHAR(10),DocumentCarePlanReviewPeriods.ReviewPeriodFromDate,101),'') + ' - ' + 
						ISNULL(CONVERT(VARCHAR(10),DocumentCarePlanReviewPeriods.ReviewPeriodToDate,101),'') END AS ReviewPeriod
        --,CONVERT(VARCHAR(10),DocumentCarePlanReviews.ReviewPeriodFromDate,110) As ReviewPeriodFromDate
        --,CONVERT(VARCHAR(10),DocumentCarePlanReviews.ReviewPeriodToDate,110) As ReviewPeriodToDate
FROM  Documents           
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId    
	AND ISNULL(Clients.RecordDeleted,'N')='N'       
Inner join DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId  
	AND ISNULL(DocumentCodes.RecordDeleted,'N')='N'            
INNER JOIN DOCUMENTVERSIONS ON DOCUMENTS.DOCUMENTID=DOCUMENTVERSIONS.DOCUMENTID      
	AND ISNULL(DOCUMENTVERSIONS.RecordDeleted,'N')='N'     
	AND DocumentVersions.DocumentVersionId = @DocumentVersionID    
 LEFT OUTER JOIN DocumentCarePlanReviewPeriods on DocumentCarePlanReviewPeriods.DocumentVersionId= DOCUMENTVERSIONS.DocumentVersionId 
  
  
END TRY                      
BEGIN CATCH                      
 declare @Error varchar(8000)                      
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_RDLSubReportDocumentHeaderCarePlanReview')                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                        
    + '*****' + Convert(varchar,ERROR_STATE())                      
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16,  -- Severity.                      
  1  -- State.                      
 );                   
END CATCH
GO
