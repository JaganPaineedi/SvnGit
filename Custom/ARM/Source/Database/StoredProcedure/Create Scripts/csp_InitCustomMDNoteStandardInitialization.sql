/****** Object:  StoredProcedure [dbo].[csp_InitCustomMDNoteStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMDNoteStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMDNoteStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMDNoteStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomMDNoteStandardInitialization]            
(                                    
 @ClientID int,              
 @StaffID int,            
 @CustomParameters xml                                    
)                                                            
As                                                                    
 /*********************************************************************/                                                                        
 /* Stored Procedure: [csp_InitCustomMDNoteStandardInitialization]               */                                                               
                                                               
 /* Copyright: 2006 Streamline SmartCare*/                                                                        
                                                               
 /* Creation Date:  12/Feb/2010                                    */                                                                        
 /*                                                                   */                                                                        
 /* Purpose: To Initialize */                                                                       
 /*                                                                   */                                                                      
 /* Input Parameters:  */                                                                      
 /*                                                                   */                                                                         
 /* Output Parameters:                                */                                                                        
 /*                                                                   */                                                                        
 /* Return:   */                                                                        
 /*                                                                   */                                                                        
 /* Called By:CustomDocuments Class Of DataService    */                                                              
 /*      */                                                              
                                                               
 /*                                                                   */                                                                        
 /* Calls:                                                            */                                                                        
 /*                                                                   */                                                                        
 /* Data Modifications:                                               */                                                                        
 /*                                                                   */                                                                        
 /*   Updates:                                                          */                                                                        
                                                               
 /*       Date              Author                  Purpose                                    */                                                                        
 /*********************************************************************/                                                                         
Begin          
Begin try    
declare @LatestDocumentVersionID int          
set @LatestDocumentVersionID =(select top 1 CurrentDocumentVersionId                                
from Documents a                                                    
where a.ClientId = @ClientID                                                    
and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                    
and a.Status = 22                
and a.DocumentCodeId=5                                                     
and isNull(a.RecordDeleted,''N'')<>''Y''                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc )  




Select TOP 1 ''CustomMDNotes'' AS TableName, -1 as ''DocumentVersionId''                          
--Custom data                        
      ,C.NoteData    
      ,C.NoteSignatureLine    
      ,C.TranscriptionDate,     
--Custom Data                        
  '''' as CreatedBy,                          
  getdate() as CreatedDate,                          
  '''' as ModifiedBy,                          
  getdate() as ModifiedDate                            
 from systemconfigurations s left outer join CustomMDNotes C           
 on s.Databaseversion = -1  
 
 
 If Exists (Select * From DiagnosesIAndII where DocumentVersionId = @LatestDocumentVersionID and isnull(RecordDeleted, ''N'')= ''N'')
 Begin
 	SELECT ''DiagnosesIAndII'' AS TableName,DIandII.DiagnosisId,DIandII.DocumentVersionId,DIandII.Axis                                                
	,DIandII.DSMCode,DIandII.DSMNumber,DIandII.DiagnosisType,DIandII.RuleOut,DIandII.Billable                                                
	,DIandII.Severity,DIandII.DSMVersion,DIandII.DiagnosisOrder,DIandII.Specifier,DIandII.Source,DIandII.Remission,DIandII.RowIdentifier                                                
	,DIandII.CreatedBy,DIandII.CreatedDate,DIandII.ModifiedBy,DIandII.ModifiedDate,DIandII.RecordDeleted                                                
	,DIandII.DeletedDate,DIandII.DeletedBy,DSM.DSMDescription,case DIandII.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText                                                             
	from DiagnosesIAndII as DIandII                               
	inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = DIandII.DSMCode and DSM.DSMNumber=DIandII.DSMNumber      
	inner join DocumentVersions V  on V.DocumentVersionId=DIandII.DocumentVersionId         
	inner join Documents D on  D.DocumentId= V.DocumentId and DIandII.DocumentVersionId=D.CurrentDocumentVersionId      
	where D.CurrentDocumentVersionId=@LatestDocumentVersionID and D.Status=22 and IsNull(DIandII.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                    
	order by D.EffectiveDate desc          

  ----For DiagnosesIANDIIMaxOrder 
	SELECT  top 1 ''DiagnosesIANDIIMaxOrder'' as TableName,max(DiagnosisOrder) as DiagnosesMaxOrder,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate 
	from  DiagnosesIAndII 
	where DocumentVersionId=@LatestDocumentVersionID          
	and  IsNull(RecordDeleted,''N'')=''N''
	group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,
	DeletedDate order by DiagnosesMaxOrder desc

 End
 
                                       
 If Exists (Select * From DiagnosesIII where DocumentVersionId = @LatestDocumentVersionID and isnull(RecordDeleted, ''N'')= ''N'')
 Begin
      ------For DiagnosesIII----                                                    
      SELECT TOP 1 ''DiagnosesIII'' AS TableName
      ,DIII.DocumentVersionId
      ,DIII.Specification
      ,DIII.CreatedBy
      ,DIII.CreatedDate
      ,DIII.ModifiedBy
      ,DIII.ModifiedDate
      ,DIII.RecordDeleted
      ,DIII.DeletedDate
      ,DIII.DeletedBy                                                     
      from DiagnosesIII as DIII,Documents D, DocumentVersions V   where           
   D.DocumentId=V.DocumentId and V.DocumentVersionId=DIII.DocumentVersionId           
   and DIII.DocumentVersionId=D.CurrentDocumentVersionId  
   and D.CurrentDocumentVersionId=@LatestDocumentVersionID                                          
   and D.Status=22 and IsNull(DIII.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                        
   order by D.EffectiveDate  desc          

      ----For DiagnosesIIICodes
	SELECT  ''DiagnosesIIICodes'' AS TableName,DIIICod.DiagnosesIIICodeId,DIIICod.DocumentVersionId,DIIICod.ICDCode,DIIICod.Billable                                                
	,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy ,DICD.ICDDescription                                                 
	from DiagnosesIIICodes as DIIICod,Documents D, DocumentVersions V ,DiagnosisICDCodes as DICD   where       
	D.DocumentId=V.DocumentId and V.DocumentVersionId=DIIICod.DocumentVersionId       
	and DIIICod.DocumentVersionId=D.CurrentDocumentVersionId  
	and D.CurrentDocumentVersionId=@LatestDocumentVersionID                                       
	and D.Status=22 and IsNull(DIIICod.RecordDeleted,''N'')=''N'' and DICD.ICDCode=DIIICod.ICDCode and IsNull(D.RecordDeleted,''N'')=''N''                                    
	order by D.EffectiveDate  desc     

End
Else
Begin
		SELECT TOP 1 ''DiagnosesIII'' AS TableName
		,DocumentVersionId
		,Specification
		,DiagnosesIII.CreatedBy,DiagnosesIII.CreatedDate                                                  
		,DiagnosesIII.ModifiedBy,DiagnosesIII.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                                     
		FROM systemconfigurations s left outer join DiagnosesIII                                                                                  
		on s.Databaseversion=-1                                                  





ENd          


 If Exists (Select * From DiagnosesIV where DocumentVersionId = @LatestDocumentVersionID and isnull(RecordDeleted, ''N'')= ''N'')
Begin
      ----For DiagnosesIV--                                                    
      SELECT TOP 1 ''DiagnosesIV'' AS TableName,DIV.DocumentVersionId,DIV.PrimarySupport,DIV.SocialEnvironment,DIV.Educational                                                    
      ,DIV.Occupational,DIV.Housing,DIV.Economic,DIV.HealthcareServices,DIV.Legal,DIV.Other,DIV.Specification,DIV.CreatedBy                                                    
      ,DIV.CreatedDate,DIV.ModifiedBy,DIV.ModifiedDate,DIV.RecordDeleted,DIV.DeletedDate,DIV.DeletedBy                                                     
      from DiagnosesIV as DIV,Documents D, DocumentVersions V   where           
   D.DocumentId=V.DocumentId and V.DocumentVersionId=DIV.DocumentVersionId           
   and DIV.DocumentVersionId=D.CurrentDocumentVersionId  
   and D.CurrentDocumentVersionId=@LatestDocumentVersionID                                        
   and D.Status=22 and IsNull(DIV.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                        
   order by D.EffectiveDate  desc          
End
Else
Begin
      ----For DiagnosesIV--                                                    
      SELECT TOP 1 ''DiagnosesIV'' AS TableName,DocumentVersionId,PrimarySupport,SocialEnvironment,Educational                                                    
      ,Occupational,Housing,Economic,HealthcareServices,Legal,Other,Specification,DiagnosesIV.CreatedBy                                                    
      ,DiagnosesIV.CreatedDate,DiagnosesIV.ModifiedBy                                                  
      ,DiagnosesIV.ModifiedDate,DiagnosesIV.RecordDeleted,DeletedDate,DeletedBy                                                     
      FROM systemconfigurations s left outer join DiagnosesIV                                                                                  
      on s.Databaseversion=-1  

End    


 If Exists (Select * From DiagnosesV where DocumentVersionId = @LatestDocumentVersionID and isnull(RecordDeleted, ''N'')= ''N'')
 Begin    
          
      -----For DiagnosesV---                                                    
      SELECT TOP 1 ''DiagnosesV'' AS TableName,DV.DocumentVersionId,DV.AxisV,DV.CreatedBy,DV.CreatedDate,DV.ModifiedBy                                                    
      ,DV.ModifiedDate,DV.RecordDeleted,DV.DeletedDate,DV.DeletedBy                  
      from DiagnosesV as DV,Documents D, DocumentVersions V   where           
   D.DocumentId=V.DocumentId and V.DocumentVersionId=DV.DocumentVersionId           
   and DV.DocumentVersionId=D.CurrentDocumentVersionId  
   and D.CurrentDocumentVersionId=@LatestDocumentVersionID                        
   and D.Status=22 and IsNull(DV.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                        
   order by D.EffectiveDate  desc          
End
Else
Begin
     -----For DiagnosesV---                                                    
      SELECT TOP 1 ''DiagnosesV'' AS TableName,DocumentVersionId,AxisV                                                          
      ,DiagnosesV.CreatedBy,DiagnosesV.CreatedDate                                                      
      ,DiagnosesV.ModifiedBy                                                        
      ,DiagnosesV.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                           
      FROM systemconfigurations s left outer join DiagnosesV                                                                                      
      on s.Databaseversion=-1   


End

                                   
end try                                                      
                                                                                               
BEGIN CATCH          
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomMDNoteStandardInitialization'')                                                                                     
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + ''*****'' + Convert(varchar,ERROR_STATE())                                  
 RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                                    
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 );                                                                                  
END CATCH                                 
END
' 
END
GO
