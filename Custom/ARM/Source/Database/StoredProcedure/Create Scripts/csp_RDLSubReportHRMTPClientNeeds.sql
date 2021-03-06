/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPClientNeeds]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPClientNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHRMTPClientNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPClientNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLSubReportHRMTPClientNeeds]    
(                                            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int, --Modified by Anuj Dated 03-May-2010  
@NeedId  int                                        
)                                            
As                                            
                                                    
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: csp_RDLSubReportTPGoals    */                                             
                                            
/* Copyright: 2006 Streamline SmartCare*/                                                      
                                            
/*********************************************************************/                                             
select c.NeedName, c.NeedDescription
From  TPNeeds a 
join CustomTPNeedsClientNeeds b on a.NeedId = b.NeedID
join CustomClientNeeds c on c.ClientNeedId = b.ClientNeedID
--Where a.DocumentId = @DocumentId
--and a.Version = @Version
Where a.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and a.NeedId = @NeedId
and isnull(a.RecordDeleted, ''N'') = ''N''
and isnull(b.RecordDeleted, ''N'') = ''N''
and isnull(c.RecordDeleted, ''N'') = ''N''

                   
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
