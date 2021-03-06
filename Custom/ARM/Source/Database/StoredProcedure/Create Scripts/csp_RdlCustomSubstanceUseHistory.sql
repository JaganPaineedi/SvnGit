/****** Object:  StoredProcedure [dbo].[csp_RdlCustomSubstanceUseHistory]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubstanceUseHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomSubstanceUseHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubstanceUseHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomSubstanceUseHistory] 
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010               
 AS             
Begin      
/*            
** Object Name:  [csp_RdlCustomSubstanceUseHistory]            
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
        
Select SubstanceUseHistoryId,GCSubstance.CodeName as SubstanceName, Substance, AgeOfFirstUse, 
Method,  CurrentFrequencyAmount, LengthOfBinge, LastUsed, Preferred
from  CustomSubstanceUseHistory CSUH
left join GlobalCodes GCSubstance on CSUH.Substance = GCSubstance.GlobalCodeId and IsNull(GCSubstance.RecordDeleted,''N'')=''N'' 
--where DocumentId=@DocumentID and Version=@Version    
where DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010    
and IsNull(CSUH.RecordDeleted,''N'')=''N''    
order by 2
  
    --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''csp_RdlSubReportHospitalPrescreen : An Error Occured''               
   Return              
   End              
       
            
  
End
' 
END
GO
