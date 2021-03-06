/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportDiagnosisIAndII]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportDiagnosisIAndII]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportDiagnosisIAndII]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportDiagnosisIAndII]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'      
CREATE PROCEDURE [dbo].[csp_RdlSubReportDiagnosisIAndII]                   
--@DocumentId int,                         
--@Version int                        
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010             
AS                             
Begin                      
/*                            
** Object Name:  [csp_RdlSubReportDiagnosisIAndII]                            
**                            
**                            
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set                             
**    which matches those parameters.                             
**                            
** Programmers Log:                            
** Date  Programmer  Description                            
**------------------------------------------------------------------------------------------                            
** Get Data From     DiagnosesIAndII,DiagnosisDSMDescriptions                  
** Oct 16 2007 Ranjeetb        

Modified by Jitender Kumar Kamboj  on 30 July 2010    Added 2 columns(Remission and Source)                              
*/ 
/*Modified By: Amit Kumar Srivastava, 
     From: Javed Husain [mailto:jhusain@streamlinehealthcare.com]
    Sent: 30 June 2012 02:45
    To: Devinder Pal Singh
    Subject: Diagnosis Order
    Hi Devinder,
        We need to get a fix for the Diagnosis Order issue tomorrow.
        Also, I am thinking that we should display the order and also allow for duplicates so user has complete control on how they wish to order them.
    Thanks,
    */        
          
SELECT  ''('' + convert(varchar(2),isnull(DiagnosesIAndII.DiagnosisOrder, '''')) + '') ''+   case when DiagnosesIAndII.Axis=''1'' then ''Axis I'' else ''Axis II'' end as Axis , DiagnosesIAndII.DSMCode, DiagnosesIAndII.DSMNumber,           
DiagnosisDSMDescriptions.DSMDescription,  gc2.CodeName as Severity, gc.CodeName as DiagnosisType, DiagnosesIAndII.RuleOut, DiagnosesIAndII.Billable as Billable, DiagnosesIAndII.Specifier,                 
                      DiagnosesIAndII.DiagnosisOrder, DiagnosesIAndII.DSMVersion,          
                      --Documents.Documentcodeid,  
                      gc3.CodeName as Remission,DiagnosesIAndII.Source    -- Added 2 columns by Jitender 
                      ,
        case when  DiagnosesIAndII.DiagnosisType=140 then 0 else 1 end ''PrimaryColumn''             
FROM    DiagnosesIAndII             
  LEFT OUTER JOIN DiagnosisDSMDescriptions ON DiagnosesIAndII.DSMCode = DiagnosisDSMDescriptions.DSMCode              
      and DiagnosesIAndII.DSMNumber =  DiagnosisDSMDescriptions.DSMNumber             
  --left join Documents on Documents.DocumentId=@DocumentId             
  --left join Documents on Documents.CurrentDocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010             
  left join GlobalCodes gc on gc.GlobalCodeId = DiagnosesIAndII.DiagnosisType            
  left join GlobalCodes gc2 on gc2.GlobalCodeId = DiagnosesIAndII.Severity           
   left join GlobalCodes gc3 on gc3.GlobalCodeId = DiagnosesIAndII.Remission  -- Added by Jitender          
--Where DiagnosesIAndII.DocumentId=@DocumentId             
--  and DiagnosesIAndII.Version=@Version              
Where DiagnosesIAndII.DocumentVersionId= @DocumentVersionId  --Modified by Anuj Dated 03-May-2010             
  and ISNull(DiagnosesIAndII.RecordDeleted,''N'')=''N'' 
 order by PrimaryColumn,DiagnosesIAndII.DiagnosisOrder               
        
                
            
                
--Checking For Errors                              
  If (@@error!=0)                              
  Begin                              
   RAISERROR  20006   ''csp_RdlSubReportDiagnosisIAndII : An Error Occured''                               
   Return                              
   End                              
                       
                            
                  
End' 
END
GO
