 CREATE PROCEDURE  [dbo].[ssp_RDLDocumentAudit]                            
(                                        
@DocumentVersionId  int         
)                                        
as                                        
/************************************************************************/                                                  
/* Stored Procedure: ssp_RDLDocumentAudit 532     */                                                                     
/* Copyright: 2018  Streamline SmartCare                            */                                                                              
/* Creation Date:  Apr ,2018                               */                                                  
/*                                                                 */                                                  
/* Purpose: RDL SP for Audit   */                                                 
/*                                                                 */                                                
/* Input Parameters: @DocumentVersionId                            */                                                
/*                                                                 */                                                   
/* Output Parameters:                                              */                                                  
/* Purpose: Use For Rdl Report                                     */      
/* Call By:                                                        */                                        
/* Calls:                                                          */                                                  
/*                                                                 */                                                  
/* Author: Pradeep Y                                   */    
/* What : created Report for Audit      */  
/* wha/y : Task #10030 Porter Starke-Customizations                              */  

/************************************************************************/     
                                                                     
BEGIN TRY  
BEGIN     
  

      
 SELECT (SELECT TOP 1  
    OrganizationName  
     FROM SystemConfigurations)  
     AS OrganizationName,  
     DocumentCodes.DocumentName,  
     Documents.ClientId AS ClientId,  
     Clients.LastName + ', ' + Clients.FirstName AS ClientName,  
     CONVERT(varchar(10), Clients.DOB, 101) AS DOB,  
     CONVERT(varchar(10), Documents.EffectiveDate, 101) AS EffectiveDate,  
      
     'Audit' AS DocumentType 
   
 FROM Documents  
 JOIN DocumentVersions  
   ON Documents.DocumentId = DocumentVersions.DocumentId  
 LEFT JOIN DocumentAssessmentAudits AS DAA  
   ON DAA.DocumentVersionId = DocumentVersions.DocumentVersionId  
 JOIN Clients  
   ON Clients.ClientId = Documents.ClientId  
 INNER JOIN DocumentCodes  
   ON DocumentCodes.DocumentCodeid = Documents.DocumentCodeId  
 WHERE DocumentVersions.DocumentVersionId = @DocumentVersionId  
 AND ISNULL(DAA.RecordDeleted, 'N') = 'N'  
  
END                                                                                          
END TRY                                                                                                   
BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLDocumentAudit')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END CATCH            