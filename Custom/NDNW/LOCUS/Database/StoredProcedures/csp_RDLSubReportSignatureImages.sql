  
  /****** Object:  StoredProcedure [dbo].[csp_RDLSubReportSignatureImages]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportSignatureImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportSignatureImages]
GO

/*********************************************************************/                  
/* Stored Procedure: dbo.csp_RDLSubReportSignatureImages                  */                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                  
/* Creation Date:    10/11/14                                         */                           
                 
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*   Date        Author           Purpose                                    */                  
/*********************************************************************/                     
  
CREATE PROCEDURE [dbo].[csp_RDLSubReportSignatureImages]  
    (  
      @DocumentVersionId INT                                     
    )  
AS   
    BEGIN                          
        DECLARE @DocumentId INT     
        DECLARE @Need5Columns CHAR(1)                         
        SET @DocumentId = ( SELECT DISTINCT  
                                    DocumentId  
                            FROM    DocumentSignatures  
                            WHERE   SignedDocumentVersionId = @DocumentVersionId  
                          );    
        SET @Need5Columns = ( SELECT    DocumentCodes.Need5Columns  
                              FROM      DocumentCodes  
                                        INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId  
                              WHERE     Documents.DocumentId = @DocumentId  
                            );  
-- If the isClient='Y'  Then Get The name from client other wise from staff,Signername from DocumentSignature Table                        
        SELECT  a.SignatureID ,  
                a.DocumentID ,  
                a.VerificationMode ,  
                CASE WHEN a.IsClient = 'Y'  
                     THEN RTRIM(c.FirstName + ' ' + c.LastName)  
                     ELSE ISNULL(a.SignerName,  
                                 ISNULL(b.Firstname, '') + ' '  
                                 + ISNULL(b.LastName, ''))  
                END AS 'SignerName' ,  
                CASE WHEN ISNULL(DeclinedSignature, 'N') = 'Y'  
                     THEN ' (Signature not available)'  
                     WHEN ISNULL(ClientSignedPaper, 'N') = 'Y'  
                     THEN ' (Signed Paper Copy)'  
                     ELSE ''  
                END AS 'Signature' ,  
                DeclinedSignature ,  
                a.StaffId ,  
                a.PhysicalSignature ,  
                CASE WHEN a.RelationToClient IS NOT NULL  
                     THEN dbo.csf_GetGlobalCodeNameById(a.RelationToClient)  
                     WHEN (a.StaffId IS NULL OR a.IsClient = 'Y') THEN ' Client'  
                     ELSE ' Clinician'  
                END AS Relation ,  
                CASE WHEN ISNULL(a.ClientSignedPaper, 'N') = 'Y'  
                     THEN 'See Paper Copy'  
                     ELSE CONVERT(VARCHAR(10), a.SignatureDate, 101)  
                END AS 'SignatureDate' ,  
                CASE WHEN (ISNULL(a.IsClient, 'N') = 'N')  
                     THEN dbo.csf_GetDocumentSignatureCredentials(a.staffid,@DocumentVersionId)    
                     ELSE ''  
                END AS 'Degree' ,  
                @Need5Columns AS 'Need5Columns'  
        FROM    documentSignatures a  
                LEFT JOIN Staff b ON a.staffid = b.staffid  
                LEFT JOIN Clients c ON c.Clientid = a.Clientid  
                LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId = a.SignedDocumentVersionId  
        WHERE   a.DocumentId = @DocumentId  
                AND ( a.SignatureDate IS NOT NULL  
                      OR ISNULL(DeclinedSignature, 'N') = 'Y'  
                    )  
                AND ( a.RecordDeleted = 'N'  
                      OR a.RecordDeleted IS  NULL  
                    )             
--AND (a.SignedDocumentVersionId = @DocumentVersionId)                   
                        
        IF ( @@error != 0 )   
            BEGIN                        
                RAISERROR  20002 'csp_RDLSubReportSignatureImages: An Error Occured'                        
                RETURN(1)                        
                            
            END                        
                        
        RETURN(0)                        
                        
    END             
  