IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportSPMISignatureImages]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[csp_RDLSubReportSPMISignatureImages] 
  END 

GO 

CREATE  PROCEDURE  [dbo].[csp_RDLSubReportSPMISignatureImages]        
(                                        
@DocumentVersionId int                                     
)                                        
As

/*************************************************************************/                                                                
/* Stored Procedure: csp_RDLSubReportSPMISignatureImages				*/  
/* moved from ssp_RDLSubReportSignatureImages      */                                                                                                                   
/*************************************************************************/     
       
                         
Begin                          
  DECLARE @DocumentId INT     
  DECLARE @Need5Columns char(1)                         
  SET @DocumentId = (Select Distinct DocumentId from DocumentSignatures Where SignedDocumentVersionId = @DocumentVersionId and ISNull(RecordDeleted,'N')='N' );    
  SET @Need5Columns = (SELECT top 1 DocumentCodes.Need5Columns FROM DocumentCodes INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId WHERE Documents.DocumentId = @DocumentId and ISNull(DocumentCodes.RecordDeleted,'N')='N' and ISNull(Documents.RecordDeleted,'N')='N');  

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
  ' (Signature not available)'                        
 WHEN ISNULL(ClientSignedPaper,'N')='Y' THEN                              
  ' (Signed Paper Copy)'                        
 ELSE                         
''                      
end as 'Signature',                
DeclinedSignature,      
a.StaffId,    
a.PhysicalSignature ,    
    
Case WHEN a.RelationToClient IS NOT NULL THEN dbo.csf_GetGlobalCodeNameById(a.RelationToClient)    
        WHEN a.StaffId IS NULL THEN ' Client Name' ELSE ' Clinician' End As Relation,      
  case WHEN ISNULL(a.ClientSignedPaper,'N')='Y' THEN ' See Paper Copy' ELSE CONVERT(VARCHAR(10),a.SignatureDate,101) end as 'SignatureDate'  ,  
  Case WHEN a.staffid IS NOT NULL THEN dbo.csf_GetDegrees(a.staffid)    
         ELSE '' end as 'Degree' ,  
         @Need5Columns As 'Need5Columns'   
                      
from documentSignatures a               
left join Staff b on a.staffid=b.staffid  and ISNull(b.RecordDeleted,'N')='N'                        
left join Clients c ON c.Clientid=a.Clientid   and ISNull(c.RecordDeleted,'N')='N' 
LEFT JOIN DocumentVersions DV on DV.DocumentVersionId =  a.SignedDocumentVersionId   and ISNull(DV.RecordDeleted,'N')='N'                       
where a.DocumentId=@DocumentId and     
(a.SignatureDate is Not Null OR ISNULL(DeclinedSignature,'N')='Y')     
and ISNull(a.RecordDeleted,'N')='N'             
--AND (a.SignedDocumentVersionId = @DocumentVersionId)                   
                        
 IF (@@error!=0)                   
    BEGIN                        
        RAISERROR  20002 'csp_RDLSubReportSPMISignatureImages: An Error Occured'                        
        RETURN(1)                        
                            
    END                        
                        
RETURN(0)                        
                        
END             