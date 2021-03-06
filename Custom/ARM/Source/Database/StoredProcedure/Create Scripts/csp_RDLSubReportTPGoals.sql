/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportTPGoals]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTPGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportTPGoals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTPGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLSubReportTPGoals]    
(                                            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                                            
)                                            
As                                            
                                                    
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: csp_RDLSubReportTPGoals    */                                             
                                            
/* Copyright: 2006 Streamline SmartCare*/                                                      
                                            
/* Creation Date:  Dec 4 ,2007                                  */                                                      
/*                                                                   */                                                      
/* Purpose: Gets Data for csp_RDLSubReportTPGoals  */                                                     
/*                                                                   */                                                    
/* Input Parameters: DocumentID,Version */                                                    
/*                                                                   */                                                       
/* Output Parameters:                                */                                                      
/*                                                                   */                                                      
/*    */                                                      
/*                                                                   */                                                      
/* Purpose Use For Rdl Report  */                                            
/*      */                                            
                                            
/*                                                                   */                                                      
/* Calls:                                                            */                                                      
/*                                                                   */                                                      
/* Author Rishu Chopra                                            */                                                      
/*                                                                   */                                                      
/*                                                             */                                                      
                                            
/*                                        */                                                      
/*           */                                                      
/*********************************************************************/                                             
select         
Documents.DocumentCodeid,
TPN.NeedNumber,
TPN.NeedText,
TPN.NeedCreatedDate,
TPN.GoalText,
TPN.NeedModifiedDate,           
TPO.ObjectiveNumber,
TPO.ObjectiveText,
Convert(varchar,GC1.CodeName) as ObjectiveStatus,
TPO.TargetDate,
TPI.InterventionNumber,
TPI.InterventionText,
PRN.Review  
from TPNeeds TPN   
Join DocumentVersions dv on dv.DocumentVersionId=TPN.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''
--INNER JOIN Documents ON  TPN.DocumentId = Documents.DocumentId  and isnull(Documents.RecordDeleted,''N'')<>''Y''    
--left Join TPObjectives  TPO on (TPN.Documentid=TPO.Documentid and TPN.Version=TPO.Version and TPN.NeedID=TPO.NeedID and ISNull(TPO.RecordDeleted,''N'')=''N'')           
--left Join TPInterventions  TPI on (TPN.Documentid=TPI.Documentid and TPN.Version=TPI.Version and TPN.NeedID=TPI.NeedID and ISNull(TPI.RecordDeleted,''N'')=''N'')          
--left Join PeriodicReviewNeeds  PRN on (TPN.Documentid=PRN.Documentid and TPN.Version=PRN.Version and TPN.NeedID=PRN.NeedID and ISNull(PRN.RecordDeleted,''N'')=''N'')   
INNER JOIN Documents ON  dv.DocumentId = Documents.DocumentId  and isnull(Documents.RecordDeleted,''N'')<>''Y''    --Modified by Anuj Dated 03-May-2010 
left Join TPObjectives  TPO on (TPN.DocumentVersionId=TPO.DocumentVersionId and TPN.NeedID=TPO.NeedID and ISNull(TPO.RecordDeleted,''N'')=''N'')  --Modified by Anuj Dated 03-May-2010 
left Join TPInterventions  TPI on (TPN.DocumentVersionId=TPI.DocumentVersionId and TPN.NeedID=TPI.NeedID and ISNull(TPI.RecordDeleted,''N'')=''N'')   --Modified by Anuj Dated 03-May-2010        
left Join PeriodicReviewNeeds  PRN on (TPN.DocumentVersionId=PRN.DocumentVersionId and TPN.NeedID=PRN.NeedID and ISNull(PRN.RecordDeleted,''N'')=''N'')  --Modified by Anuj Dated 03-May-2010   
left JOIN GlobalCodes GC1 on GC1.GlobalCodeID = TPO.ObjectiveStatus     
and ISNull(GC1.RecordDeleted,''N'')=''N''             
--where TPN.DocumentID=@DocumentId and TPN.Version =@Version and ISNull(TPN.RecordDeleted,''N'')=''N''    
where TPN.DocumentVersionId=@DocumentVersionId and ISNull(TPN.RecordDeleted,''N'')=''N''    --Modified by Anuj Dated 03-May-2010 
Order by tpn.NeedNumber, tpo.ObjectiveNumber
                    
  --Checking For Errors                              
  If (@@error!=0)                                            
  Begin                                            
   RAISERROR  20006   ''csp_RDLSubReportTPGoals : An Error Occured''                                             
   Return                                            
   End                                                     
                       
End
' 
END
GO
