
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSubReportSignature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSubReportSignature]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_RDLSubReportSignature                 */                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                
/* Creation Date:    7/24/05                                         */                         
               
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*   Date        Author           Purpose                                    */                
/* 29-Apr-14     Revathi          display signature in PDF 
                                  Philhaven Development #26 Inpatient Order Management */
/* 13/11/2018   Chita Ranjan   Added one more condition to display a text 'Agreed Over Phone' in the RDL when signature is done by using 
                               'Verbally Agreed Over Phone' option. PEP - Customizations #10212  */
/* 12/12/2018   Suman           Added logic to check for "ShowSigningSuffixORBillingDegreeInSignatureRDL" system configuration key and display signing suffix on PDF 
                                Renaissance Dev Items #128 */
/* 02/20/2018   MD				Added logic to check for "ShowSigningSuffixORBillingDegreeInSignatureRDL" system configuration key and display billing degree on PDF 
								WestBridge - Support Go Live #40 */                                
/*********************************************************************/                   

CREATE PROCEDURE  [dbo].[ssp_RDLSubReportSignature]      
(                                      
@DocumentVersionId int                                   
)                                      
As     
                       
BEGIN  
Begin Try                       
        DECLARE @DocumentId INT   
        DECLARE @Need5Columns CHAR(1) 
		DECLARE @SystemConfigKeyValue varchar(20)                      
        SET @DocumentId = ( SELECT DISTINCT  TOP 1
                                    DocumentId
                            FROM    DocumentSignatures
                            WHERE   SignedDocumentVersionId = @DocumentVersionId ORDER BY DocumentId DESC
                          );  
        SET @Need5Columns = ( SELECT   TOP 1 DocumentCodes.Need5Columns
                              FROM      DocumentCodes
                                        INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId
                              WHERE     Documents.DocumentId = @DocumentId ORDER BY DocumentCodes.DocumentCodeId DESC
                            );
		SET @SystemConfigKeyValue=(select dbo.ssf_GetSystemConfigurationKeyValue('ShowSigningSuffixORBillingDegreeInSignatureRDL'));
-- If the isClient='Y'  Then Get The name from client other wise from staff,Signername from DocumentSignature Table                      
        SELECT  a.SignatureID ,
                a.DocumentID ,
                a.VerificationMode ,
                CASE WHEN a.IsClient = 'Y'
                     THEN RTRIM(c.FirstName + ' ' + c.LastName)
                     WHEN @SystemConfigKeyValue = 'BillingDegree'  -- Added by MD
                     THEN ISNULL(b.Firstname, '') + ' ' + ISNULL(b.LastName, '')
                     ELSE ISNULL(a.SignerName,
                                 ISNULL(b.Firstname, '') + ' '
                                 + ISNULL(b.LastName, ''))
                END AS 'SignerName' ,
                CASE WHEN ISNULL(DeclinedSignature, 'N') = 'Y'
                     THEN ' (Signature not available)'
                     WHEN ISNULL(ClientSignedPaper, 'N') = 'Y'
                     THEN ' (Signed Paper Copy)'
                     WHEN a.VerificationMode='V'   --Chita Ranjan 13/11/2018
					 THEN ' (Agreed Over Phone)'
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
				CASE WHEN (ISNULL(a.IsClient, 'N') = 'N') AND (@SystemConfigKeyValue = 'SigningSuffix')  -- Added by suman on 12/12/2018
				       THEN ''
                 WHEN (ISNULL(a.IsClient, 'N') = 'N')
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
                
  End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLSubReportSignature')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END

