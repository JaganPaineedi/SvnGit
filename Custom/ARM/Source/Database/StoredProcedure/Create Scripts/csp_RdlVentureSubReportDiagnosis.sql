/****** Object:  StoredProcedure [dbo].[csp_RdlVentureSubReportDiagnosis]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlVentureSubReportDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlVentureSubReportDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlVentureSubReportDiagnosis]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlVentureSubReportDiagnosis]         
                 
@DocumentVersionId  int   
 AS                         
Begin                  
/*                        
** Object Name:  [csp_RdlVentureSubReportDiagnosis]                        
**                        
**                        
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set                         
**    which matches those parameters.                         
**                        
** Programmers Log:                        
** Date  Programmer  Description                        
**------------------------------------------------------------------------------------------                        
** Get Data From    DiagnosesIII, DiagnosesIV, DiagnosesV,DiagnosisAxisVLevels, DiagnosisAxisVRanges                       

       
*/                        
           
           
create table #Temp ( id int identity, icdcode varchar(12) )
 insert into #Temp ( icdcode )
 select top 12 
 d.ICDCode
 from DiagnosesIIICodes d  
 where d.DocumentVersionId  = @DocumentVersionId
 and ISNull(d.RecordDeleted,''N'') = ''N''                
 Order by Case Billable when ''Y'' then 1 else 2 end, d.DiagnosesIIICodeId
 
create table #DiagnosesIIICodes ( 
 DocumentVersionId int
,ICDCode1 varchar(12)
,ICDCode2 varchar(12)
,ICDCode3 varchar(12)
,ICDCode4 varchar(12)
,ICDCode5 varchar(12)
,ICDCode6 varchar(12)
,ICDCode7 varchar(12)
,ICDCode8 varchar(12)
,ICDCode9 varchar(12)
,ICDCode10 varchar(12)
,ICDCode11 varchar(12)
,ICDCode12 varchar(12)
 )

insert into #DiagnosesIIICodes
select 
 @DocumentVersionId
,(Select IcdCode from #Temp where id=1)
,(Select IcdCode from #Temp where id=2)
,(Select IcdCode from #Temp where id=3)
,(Select IcdCode from #Temp where id=4)
,(Select IcdCode from #Temp where id=5)
,(Select IcdCode from #Temp where id=6)
,(Select IcdCode from #Temp where id=7)
,(Select IcdCode from #Temp where id=8)
,(Select IcdCode from #Temp where id=9)
,(Select IcdCode from #Temp where id=10)
,(Select IcdCode from #Temp where id=11)
,(Select IcdCode from #Temp where id=12)         

            
SELECT 
   dv.DocumentVersionId
  ,Documents.DocumentId        
  ,DiagnosesIII.Specification AS SpecificationIII        
  ,x.ICDCode1       
  ,x.ICDCode2        
  ,x.ICDCode3        
  ,x.ICDCode4        
  ,x.ICDCode5        
  ,x.ICDCode6        
  ,x.ICDCode7        
  ,x.ICDCode8        
  ,x.ICDCode9        
  ,x.ICDCode10        
  ,x.ICDCode11        
  ,x.ICDCode12       
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
join DocumentVersions dv with (nolock) on dv.DocumentId = documents.DocumentId and ISNull(dv.RecordDeleted,''N'') = ''N''           
left join diagnosesIII  with (nolock) ON DiagnosesIII.DocumentVersionId = dv.DocumentVersionId and ISNull(DiagnosesIII.RecordDeleted,''N'') = ''N''                
Left JOIN DiagnosesIV  with (nolock) ON dv.DocumentVersionId = DiagnosesIV.DocumentVersionId and ISNull(DiagnosesIV.RecordDeleted,''N'') = ''N''                    
Left JOIN DiagnosesV  with (nolock) ON dv.DocumentVersionId = DiagnosesV.DocumentVersionId and ISNull(DiagnosesV.RecordDeleted,''N'') = ''N''      
Left JOIN DiagnosisAxisVLevels  with (nolock) ON DiagnosesV.AxisV = DiagnosisAxisVLevels.LevelNumber         
Left JOIN DiagnosisAxisVRanges  with (nolock) ON DiagnosisAxisVLevels.LevelStart = DiagnosisAxisVRanges.LevelStart  
left join #DiagnosesIIICodes x on x.DocumentVersionId = dv.DocumentVersionId                 
Where dv.DocumentVersionId = @DocumentVersionId  
and ISNull(Documents.RecordDeleted,''N'') = ''N''           
            
              
--Checking For Errors             
If (@@error!=0)                          
 Begin                          
  RAISERROR  20006   ''csp_RdlVentureSubReportDiagnosis : An Error Occured''                        
  Return                          
 End                          
                   
End
' 
END
GO
