/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportDiagnosis2]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportDiagnosis2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportDiagnosis2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportDiagnosis2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlSubReportDiagnosis2]         
--@DocumentId int,                     
--@Version int                    
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010          
 AS                         
Begin                  
/*                        
** Object Name:  [csp_RdlSubReportDiagnosis]                        
**                        
**                        
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set                         
**    which matches those parameters.                         
**                        
** Programmers Log:                        
** Date  Programmer  Description                        
**------------------------------------------------------------------------------------------                        
** Get Data From    DiagnosesIII, DiagnosesIV, DiagnosesV,DiagnosisAxisVLevels, DiagnosisAxisVRanges                       
** Oct 16 2007 Ranjeetb                          
** Modified by: Rupali Patil June 20, 2008        
**    Renamed Specifications for III & IV to make it easier to distinguish       
Modified by Jitender Kumar Kamboj on July 26, 2010      
       
       exec csp_RdlSubReportDiagnosis2 1178989
       
*/                        
            
SELECT 
   dv.DocumentVersionId
  ,Documents.DocumentId        
  ,DiagnosesIII.Specification AS SpecificationIII        
  --,DiagnosesIII.ICDCode1  -- Commented by Jitender on July 26, 2010      
  --,DiagnosesIII.ICDCode2        
  --,DiagnosesIII.ICDCode3        
  --,DiagnosesIII.ICDCode4        
  --,DiagnosesIII.ICDCode5        
  --,DiagnosesIII.ICDCode6        
  --,DiagnosesIII.ICDCode7        
  --,DiagnosesIII.ICDCode8        
  --,DiagnosesIII.ICDCode9        
  --,DiagnosesIII.ICDCode10        
  --,DiagnosesIII.ICDCode11        
  --,DiagnosesIII.ICDCode12       
  ,DiagnosesIV.PrimarySupport        
  ,DiagnosesIV.SocialEnvironment        
  ,DiagnosesIV.Educational        
  ,DiagnosesIV.Occupational        
  ,DiagnosesIV.Housing        
  ,DiagnosesIV.Economic        
  ,DiagnosesIV.HealthcareServices        
  ,DiagnosesIV.Legal        
  ,DiagnosesIV.Other        
  ,DiagnosesIV.Specification AS SpecificationIV      
  ,DiagnosesV.AxisV        
  ,DiagnosisAxisVRanges.LevelDescription      
           
FROM Documents         
join DocumentVersions dv on dv.DocumentId = documents.DocumentId and ISNull(dv.RecordDeleted,''N'') = ''N''           
left join diagnosesIII ON DiagnosesIII.DocumentVersionId = dv.DocumentVersionId and ISNull(DiagnosesIII.RecordDeleted,''N'') = ''N''                
Left JOIN DiagnosesIV ON dv.DocumentVersionId = DiagnosesIV.DocumentVersionId and ISNull(DiagnosesIV.RecordDeleted,''N'') = ''N''                    
Left JOIN DiagnosesV ON dv.DocumentVersionId = DiagnosesV.DocumentVersionId and ISNull(DiagnosesV.RecordDeleted,''N'') = ''N''      
Left JOIN DiagnosisAxisVLevels ON DiagnosesV.AxisV = DiagnosisAxisVLevels.LevelNumber         
Left JOIN DiagnosisAxisVRanges ON DiagnosisAxisVLevels.LevelStart = DiagnosisAxisVRanges.LevelStart                   
Where dv.DocumentVersionId = @DocumentVersionId  
and ISNull(Documents.RecordDeleted,''N'') = ''N''           
            
              
--Checking For Errors             
If (@@error!=0)                          
 Begin                          
  RAISERROR  20006   ''csp_RdlSubReportDiagnosis : An Error Occured''                        
  Return                          
 End                          
                   
End
' 
END
GO
