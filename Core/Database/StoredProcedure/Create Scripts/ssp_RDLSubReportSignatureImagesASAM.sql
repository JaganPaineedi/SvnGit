IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSubReportSignatureImagesASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSubReportSignatureImagesASAM]
GO
      
CREATE PROCEDURE  [dbo].[ssp_RDLSubReportSignatureImagesASAM] -- 4880     
(                                          
@DocumentVersionId int                                       
)                                          
As  
  
/*************************************************************************/                                                                  
/* Stored Procedure: ssp_RDLSubReportSignatureImagesASAM      */                                                                                                                       
/* Creation Date:  12 Aug 2013            */                                                                                                                             
/* Purpose: Gets Data for Signature              */                                                                 
/* Input Parameters: @DocumentVersionId          */                                                                                                                                                                                                            
                                                                                                  
/* Author: Gayathri Naik                */        
/* Pulled this sp from Newaygo database from 3.5xMerged with task #52 in Phillhaven Development */    
/* Modified by: Gayathri Naik  17/10/2013   clientid and name columns included*/   
/* 10/02/14    Md Hussain Khusro  Removed white space before text 'Client', 'Clinician' and 'See Paper Copy' because it is creating alignment issue wrt to task #909 Philhaven Issues*/
/*************************************************************************/       
         
                           
Begin                            
  DECLARE @DocumentId INT       
  DECLARE @Need5Columns char(1)                           
  SET @DocumentId = (Select Distinct DocumentId from DocumentSignatures Where SignedDocumentVersionId = @DocumentVersionId);      
  SET @Need5Columns = (SELECT DocumentCodes.Need5Columns FROM DocumentCodes INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId WHERE Documents.DocumentId = @DocumentId);    
  
select a.SignatureID,a.DocumentID,a.VerificationMode ,         
  CASE  WHEN  a.ClientId is null Then 'Clinician:' else 'Client Name:' END as Name,  a.ClientId,                       
case                                   
when a.IsClient='Y' then                           
 RTRIM(c.lastName+', '+ c.Firstname)                          
else                             
IsNull(a.SignerName, IsNull(b.Firstname,'')+' '+IsNull(b.LastName,''))                    
end as 'SignerName',        
                        
                        
case                                 
 WHEN ISNULL(DeclinedSignature,'N')='Y' THEN                                
  '(Signature not available)'                          
 WHEN ISNULL(ClientSignedPaper,'N')='Y' THEN                                
  '(Signed Paper Copy)'                          
 ELSE                           
''                        
end as 'Signature',                  
DeclinedSignature,        
a.StaffId,      
a.PhysicalSignature ,      
      
Case WHEN a.RelationToClient IS NOT NULL THEN dbo.csf_GetGlobalCodeNameById(a.RelationToClient)      
        WHEN a.StaffId IS NULL THEN 'Client' ELSE 'Clinician' End As Relation, 
        
         
  case WHEN ISNULL(a.ClientSignedPaper,'N')='Y' THEN 'See Paper Copy' ELSE CONVERT(VARCHAR(10),a.SignatureDate,101) end as 'SignatureDate'  ,    
  Case WHEN a.staffid IS NOT NULL THEN dbo.csf_GetDegrees(a.staffid)      
         ELSE '' end as 'Degree' ,    
         @Need5Columns As 'Need5Columns'     
                        
from documentSignatures a                 
left join Staff b on a.staffid=b.staffid                            
left join Clients c ON c.Clientid=a.Clientid      
LEFT JOIN DocumentVersions DV on DV.DocumentVersionId =  a.SignedDocumentVersionId                            
where a.DocumentId=@DocumentId and       
(a.SignatureDate is Not Null OR ISNULL(DeclinedSignature,'N')='Y')       
and (a.RecordDeleted='N' or a. RecordDeleted Is  NULL)               
--AND (a.SignedDocumentVersionId = @DocumentVersionId)                     
                          
 IF (@@error!=0)                     
    BEGIN                          
        RAISERROR  20002 'ssp_RDLSubReportSignatureImagesASAM: An Error Occured'                          
        RETURN(1)                          
                              
    END                          
                          
RETURN(0)                          
                          
END 