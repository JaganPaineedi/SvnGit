/****** Object:  StoredProcedure [dbo].[csp_RdlCustomSubstanceFamilyHistory]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubstanceFamilyHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomSubstanceFamilyHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubstanceFamilyHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomSubstanceFamilyHistory] 
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010   
 AS             
Begin      
/*            
** Object Name:  [csp_RdlCustomSubstanceFamilyHistory]            
**            
**            
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set             
**    which matches those parameters.             
**            
** Programmers Log:            
** Date  Programmer  Description            
**------------------------------------------------------------------------------------------            
**     
** Oct 12 2007 Ranjeetb              
*/            
        
  Select '''' as DeleteButton, ''N'' as RadioButton, GCRelation.CodeName as RelationName, *  
  from CustomSubstanceUseFamilyHistory CSUFH, GlobalCodes GCRelation  
  Where IsNull(CSUFH.RecordDeleted,''N'')=''N'' and IsNull(GCRelation.RecordDeleted,''N'')=''N'' 
--and  DocumentId=@DocumentId and Version = @Version
and  DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010 
  and CSUFH.Relation = GCRelation.GlobalCodeId
    
        
  
    --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''csp_RdlCustomSubstanceFamilyHistory: An Error Occured''               
   Return              
   End              
       
            
  
End
' 
END
GO
