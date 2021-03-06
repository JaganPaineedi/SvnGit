/****** Object:  StoredProcedure [dbo].[csp_RDLCustomHealthHomeDocumentsProvider]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthHomeDocumentsProvider]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomHealthHomeDocumentsProvider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthHomeDocumentsProvider]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomHealthHomeDocumentsProvider]         
(                               
@DocumentVersionId  int           
)                      
AS                      
                
Begin                
-- =============================================
-- Author:		Bernardin
-- Create date: 31/01/2013
-- Description:	To get data for Custom Health Home Documents RDL.
-- ============================================= 


SELECT     HealthHomeCommPlanProviderId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, DocumentVersionId, 
                      ProviderName,ProviderSpecialty, ProviderPhone, ProviderFax
FROM         CustomDocumentHealthHomeCommPlanProviders
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

--Checking For Errors                          
If (@@error!=0)                                                      
 Begin                                                      
  RAISERROR  20006   ''[csp_RDLCustomHealthHomeDocumentsProvider] : An Error Occured''                                                       
  Return                                                      
 End                                                               
End
' 
END
GO
