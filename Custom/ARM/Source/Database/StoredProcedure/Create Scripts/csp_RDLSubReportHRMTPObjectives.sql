/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPObjectives]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPObjectives]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHRMTPObjectives]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPObjectives]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLSubReportHRMTPObjectives]    
(                                            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int, --Modified by Anuj Dated 03-May-2010 
@NeedId  int                                        
)                                            
As                                            
                                                    
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: csp_RDLSubReportHRMTPObjectives    */                                             
                                            
/* Copyright: 2008 Streamline SmartCare*/                                                      
                                            
/*********************************************************************/                                             
select a.ObjectiveNumber, 
null as ObjectiveText,--a.ObjectiveText, 
gc.CodeName as ObjectiveStatus, 
a.TargetDate
From  TPObjectives a 
Join GlobalCodes gc on gc.GlobalCodeId = a.ObjectiveStatus
--Where a.DocumentId = @DocumentId
--and a.Version = @Version
Where a.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010 
and a.NeedId = @NeedId
and isnull(a.RecordDeleted, ''N'') = ''N''
order by a.ObjectiveNumber

                   
  --Checking For Errors                              
  If (@@error!=0)                                            
  Begin                                            
   RAISERROR  20006   ''csp_RDLSubReportHRMTPObjectives : An Error Occured''                                             
   Return                                            
   End                                                     
                       
End
' 
END
GO
