/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportHRMDiagnosis]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportHRMDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportHRMDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportHRMDiagnosis]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_RdlSubReportHRMDiagnosis]       
                 
@DocumentVersionId  int       
 AS                       
Begin                
/*                      
** Object Name:  [csp_RdlSubReportHRMDiagnosis]                      
**                      
**                      
** Notes:  Accepts two parameters (DocumentVersionId) and returns a record set                       
**    which matches those parameters.                       
**                      
** Programmers Log:                      
** Date  Programmer  Description                      
**------------------------------------------------------------------------------------------                      
** Get Data From    DiagnosesIII, DiagnosesIV, DiagnosesV,DiagnosisAxisVLevels, DiagnosisAxisVRanges                     
** July 26, 2010   Jitender Kumar Kamboj                        
**     
**       
     
     
*/                      
          
SELECT Documents.DocumentId      
  ,DiagnosesIII.Specification AS SpecificationIII      
  ,CHA.PhysicalConditionQuadriplegic      
  ,CHA.PhysicalConditionMultipleSclerosis    
  ,CHA.PhysicalConditionBlindness    
  ,CHA.PhysicalConditionDeafness    
  ,CHA.PhysicalConditionParaplegic    
  ,CHA.PhysicalConditionCerebral    
  ,CHA.PhysicalConditionMuteness    
  ,CHA.PhysicalConditionOtherHearingImpairment    
        
      
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
  ,CHA.StaffAxisV   
  ,CHA.StaffAxisVReason     
         
FROM  Documents
Join DocumentVersions dv on dv.DocumentId=Documents.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''      
       
left join diagnosesIII ON DiagnosesIII.DocumentVersionId = dv.DocumentVersionId      
and ISNull(DiagnosesIII.RecordDeleted,''N'') = ''N''         
      
Left JOIN DiagnosesIV ON dv.DocumentVersionId = DiagnosesIV.DocumentVersionId    
and ISNull(DiagnosesIV.RecordDeleted,''N'') = ''N''         
                 
Left JOIN DiagnosesV ON dv.DocumentVersionId = DiagnosesV.DocumentVersionId      
and ISNull(DiagnosesV.RecordDeleted,''N'') = ''N''    
    
Left Join CustomHRMAssessments CHA ON dv.DocumentVersionId = CHA.DocumentVersionId       
      
Left JOIN DiagnosisAxisVLevels ON DiagnosesV.AxisV = DiagnosisAxisVLevels.LevelNumber       
Left JOIN DiagnosisAxisVRanges ON DiagnosisAxisVLevels.LevelStart = DiagnosisAxisVRanges.LevelStart          
      
Where dv.DocumentVersionId = @DocumentVersionId            
and ISNull(Documents.RecordDeleted,''N'') = ''N''         
          
            
--Checking For Errors                        
If (@@error!=0)                        
 Begin                        
  RAISERROR  20006   ''csp_RdlSubReportHRMDiagnosis : An Error Occured''                         
  Return                        
 End                        
                 
End
' 
END
GO
