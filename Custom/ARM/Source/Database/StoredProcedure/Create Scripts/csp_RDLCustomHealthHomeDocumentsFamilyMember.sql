/****** Object:  StoredProcedure [dbo].[csp_RDLCustomHealthHomeDocumentsFamilyMember]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthHomeDocumentsFamilyMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomHealthHomeDocumentsFamilyMember]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthHomeDocumentsFamilyMember]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomHealthHomeDocumentsFamilyMember]         
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

SELECT     HealthHomeCommPlanFamilyMemberId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, 
                      DocumentVersionId, FamilyMemberName, FamilyMemberPhone
FROM         CustomDocumentHealthHomeCommPlanFamilyMembers
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

--Checking For Errors                          
If (@@error!=0)                                                      
 Begin                                                      
  RAISERROR  20006   ''[csp_RDLCustomHealthHomeDocumentsFamilyMember] : An Error Occured''                                                       
  Return                                                      
 End                                                               
End
' 
END
GO
