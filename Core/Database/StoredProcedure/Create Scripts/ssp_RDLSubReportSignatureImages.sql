IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_RDLSubReportSignatureImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_RDLSubReportSignatureImages]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
 /*********************************************************************/                    
/* Stored Procedure: dbo.SSP_RDLSubReportSignatureImages                */                    
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
/* 14/12/12    Bernardin          customized for threshold to display signature in PDF (Development Phase IV (Offshore) Task # 15) */    
/* 20 Oct 2015 Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.*/                 
/*        why:task #609, Network180 Customization */       
/*  01 June 2016  Ajay          Why: Woods is requesting that the Diagnosis document read as 'signed by' and not 'Clinician' for the author signature.Woods - Support Go Live    
:Task#44*/    
/* 06-09-2016 Sachin Borgave    Added DV.DocumentVersionId=@DocumentVersionId for Diagnoses Document & PHQ9-A Document Task #2286 Core Bugs */
/* 10/04/2016 Hemant            Added If exists condition for drop amd recreate the storedprocedure.*/
/* 02/06/2018 MD                Added logic to check for "ShowSigningSuffixORBillingDegreeInSignatureRDL" system configuration key and display signing suffix on PDF w.r.t MFS - Support Go Live #216 */
/* 13/12/2018   Chita Ranjan    Added one more condition to display a text 'Agreed Over Phone' in the RDL when signature is done by using 
                               'Verbally Agreed Over Phone' option. PEP - Customizations #10212  */ 
/* 02/20/2018   MD				Added logic to check for "ShowSigningSuffixORBillingDegreeInSignatureRDL" system configuration key and display billing degree on PDF 
								WestBridge - Support Go Live #40 */                                
/*********************************************************************/                       
    
Create PROCEDURE  [dbo].[SSP_RDLSubReportSignatureImages]          
(                                          
@DocumentVersionId int                                       
)                                          
As         
                           
Begin    
--Added by Ajay    
  IF EXISTS (    
  SELECT *    
  FROM sys.objects    
  WHERE object_id = OBJECT_ID(N'[dbo].[scsp_RDLSubReportSignatureImages]')    
   AND type IN (    
    N'P'    
    ,N'PC'    
    )    
  )    
   BEGIN    
    EXEC scsp_RDLSubReportSignatureImages @DocumentVersionId      
   END    
       
ELSE    
BEGIN    
                            
  DECLARE @DocumentId INT       
  DECLARE @Need5Columns char(1)                           
  SET @DocumentId = (Select Distinct DocumentId from DocumentSignatures Where SignedDocumentVersionId = @DocumentVersionId);      
  SET @Need5Columns = (SELECT DocumentCodes.Need5Columns FROM DocumentCodes INNER JOIN Documents ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId WHERE Documents.DocumentId = @DocumentId);    
-- If the isClient='Y'  Then Get The name from client other wise from staff,Signername from DocumentSignature Table                          
select a.SignatureID,a.DocumentID,a.VerificationMode ,         
                       
case                                   
when a.IsClient='Y'     
 -- Modified by Revathi 20 Oct 2015    
 THEN case when  ISNULL(C.ClientType,'I')='I' then RTRIM(ISNULL(c.FirstName,'') + ' ' + ISNULL(c.LastName,'')) else ISNULL(C.OrganizationName,'') end  
when (select dbo.ssf_GetSystemConfigurationKeyValue('ShowSigningSuffixORBillingDegreeInSignatureRDL'))='BillingDegree'  -- Added by MD
then IsNull(b.Firstname,'')+' '+IsNull(b.LastName,'')                     
else                             
IsNull(a.SignerName, IsNull(b.Firstname,'')+' '+IsNull(b.LastName,''))                    
end as 'SignerName',        
                        
                        
case                                 
 WHEN ISNULL(a.DeclinedSignature,'N')='Y' THEN                                
  ' (Signature not available)'                          
 WHEN ISNULL(ClientSignedPaper,'N')='Y' THEN                                
  ' (Signed Paper Copy)'
  WHEN a.VerificationMode='V'   --Chita Ranjan 13/11/2018
  THEN ' (Agreed Over Phone)'                          
 ELSE                           
''                        
end as 'Signature',       
a.DeclinedSignature,        
a.StaffId,      
a.PhysicalSignature ,            
Case WHEN a.RelationToClient IS NOT NULL THEN dbo.csf_GetGlobalCodeNameById(a.RelationToClient)      
        WHEN a.StaffId IS NULL THEN ' Client' ELSE ' Clinician' End As Relation,        
case WHEN ISNULL(a.ClientSignedPaper,'N')='Y' THEN ' See Paper Copy' ELSE CONVERT(VARCHAR(10),a.SignatureDate,101) end as 'SignatureDate'  ,    
CASE 
		WHEN a.StaffId IS NOT NULL AND (select dbo.ssf_GetSystemConfigurationKeyValue('ShowSigningSuffixORBillingDegreeInSignatureRDL'))='SigningSuffix'
			THEN '' -- Added by MD on 02/06/2018
		WHEN a.staffid IS NOT NULL THEN dbo.csf_GetDegrees(a.staffid) 	
		ELSE ''
END AS 'Degree',
@Need5Columns As 'Need5Columns'     
                        
from documentSignatures a                 
left join Staff b on a.staffid=b.staffid                            
left join Clients c ON c.Clientid=a.Clientid      
LEFT JOIN DocumentVersions DV on DV.DocumentVersionId =  a.SignedDocumentVersionId                            
where a.DocumentId=@DocumentId and    
DV.DocumentVersionId=@DocumentVersionId and     -- Added by Sachin Borgave   
(a.SignatureDate is Not Null OR ISNULL(a.DeclinedSignature,'N')='Y')                            
and (a.RecordDeleted='N' or a. RecordDeleted Is  NULL)               
--AND (a.SignedDocumentVersionId = @DocumentVersionId)                     
                          
 IF (@@error!=0)                     
   BEGIN                                                      
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_RDLSubReportSignatureImages')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END                           
                          
RETURN(0)                          
  END                        
END               
print 'Completed ### SSP_RDLSubReportSignatureImages.sql' 