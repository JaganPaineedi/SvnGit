/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportSubStanceUseAssessment]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSubStanceUseAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportSubStanceUseAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSubStanceUseAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlSubReportSubStanceUseAssessment]      
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010             
 AS             
Begin      
/*            
** Object Name:  [csp_RdlSubReportSubStanceUseAssessment]            
**            
**            
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set             
**    which matches those parameters.             
**            
** Programmers Log:            
** Date  Programmer  Description            
**------------------------------------------------------------------------------------------            
** Get Data From CustomSubstanceUseHistory       
** Oct 11 2007 Ranjeetb              
*/            
        
 Select GCSubstance.CodeName as SubstanceName, 0 as CurrentFrequencyAmount
  from  GlobalCodes GCSubstance   
  where IsNull(GCSubstance.RecordDeleted,''N'')=''N'' and GCSubstance.Category = ''XSUBSTANCEGRID''  
  --and not exists(Select substance from CustomSubstanceUseHistory CSUH  where  DocumentId=@DocumentID and Version=@Version   and CSUH.Substance = GCSubstance.GlobalCodeId and IsNull(RecordDeleted ,''N'')=''N'' )  
  and not exists(Select substance from CustomSubstanceUseHistory CSUH  where  DocumentVersionId=@DocumentVersionId and CSUH.Substance = GCSubstance.GlobalCodeId and IsNull(RecordDeleted ,''N'')=''N'' )   --Modified by Anuj Dated 03-May-2010  
  
    --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''csp_RdlSubReportSubStanceUseAssessment: An Error Occured''               
   Return              
   End              
       
            
  
End
' 
END
GO
