/****** Object:  StoredProcedure [dbo].[csp_RDLHarborConsentElectronicSignature]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHarborConsentElectronicSignature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLHarborConsentElectronicSignature]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHarborConsentElectronicSignature]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDLHarborConsentElectronicSignature]       
(                    
 @DocumentVersionId int                  
)         
/*********************************************************************/      
/* Procedure: csp_RDLHarborConsentElectronicSignature            */      
/*                                                                   */      
/* Purpose: retrieve  data for rendering the RDL Report for Harbor Consent */      
/*                  */      
/*                                                                   */      
/* Parameters: @DocumentVersionId int                           */      
/*                                                                   */      
/*                                                                   */      
/* Returns/Results: Returns fields required for generating RDL Report (Electronic Signature) */      
/*                                                                   */      
/* Created By: Loveena                                       */      
/*                                                                   */      
/* Created Date: 25-May-2009                                          */      
/*                                                                   */      
/* Revision History:                                                 */      
/* Date : 13/April/2018         Anto		   What : Modified the logic to display the correct staff name when they do only patient consent sign(not staff sign) with different staff logged in.  
											   Why  : MFS - Support Go Live #370.    */     
/*********************************************************************/                    
AS       
                   
BEGIN       
      
 BEGIN TRY                 
                                               
  declare @ClientId as int      
  select @ClientId=DocumentSignatures.ClientId from DocumentSignatures   
  inner join Documents on Documents.DocumentId = DocumentSignatures.DocumentId  
  inner join DocumentVersions on  DocumentVersions.DocumentId =  Documents.DocumentId  
  where DocumentVersions.DocumentVersionId = @DocumentVersionId 
  and isnull(Documents.RecordDeleted, ''N'') <> ''Y'' 
  and isnull(DocumentVersions.RecordDeleted, ''N'') <> ''Y'' 
  and isnull(DocumentSignatures.RecordDeleted, ''N'') <> ''Y''     
                            
  select Staff.LastName + '','' + Staff.FirstName as StaffName, Clients.LastName + '','' + Clients.FirstName as ClientName,  
case DocumentSignatures.IsClient   
 when ''N'' then   
  (select SignerName + '' ('' + CodeName + '')'' + '' on '' + Convert(varchar,DocumentSignatures.CreatedDate,101) from GlobalCodes where Category=''RELATIONSHIP'' And ISNULL(GlobalCodes.RecordDeleted,''N'')<>''Y'' and GlobalCodeId=RelationToClient and DocumentSignatures.ClientId=@ClientId and isnull(DocumentSignatures.RecordDeleted, ''N'') <> ''Y'' and isnull(GlobalCodes.RecordDeleted, ''N'') <> ''Y'' )  
 when ''Y'' then   
 (select Clients.LastName + '','' + Clients.FirstName + '' (Patient)'' + '' on '' + Convert(varchar,DocumentSignatures.CreatedDate,101)  from Clients where ClientId=@ClientId and isnull(Clients.RecordDeleted, ''N'') <> ''Y'' )   
 else  
   (select Staff.LastName + '','' + Staff.FirstName + '' (Medical Staff)'' + '' on '' + Convert(varchar,DocumentSignatures.CreatedDate,101) from Staff where StaffId=DocumentSignatures.StaffId and isnull(Staff.RecordDeleted, ''N'') <> ''Y'' )                                                                                                         
end  
as SignedBy,  
 PhysicalSignature  
from DocumentSignatures  
inner join Staff on Staff.StaffId = DocumentSignatures.StaffId  
left outer join Clients on Clients.ClientId = DocumentSignatures.ClientId  
inner join Documents on Documents.DocumentId = DocumentSignatures.DocumentId  
inner join DocumentVersions on  DocumentVersions.DocumentId =  Documents.DocumentId  
where DocumentVersions.DocumentVersionId = @DocumentVersionId 
and isnull(Documents.RecordDeleted, ''N'') <> ''Y'' 
and isnull(DocumentVersions.RecordDeleted, ''N'') <> ''Y'' 
and isnull(DocumentSignatures.RecordDeleted, ''N'') <> ''Y''    
order by SignatureId asc  

 END TRY      
       
 BEGIN CATCH      
   DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLHarborConsentElectronicSignature'')                                                           
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                            
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                      
   16, -- Severity.                                                          
   1 -- State.                                                          
  );                  
 END CATCH      
    
END
' 
END
GO
