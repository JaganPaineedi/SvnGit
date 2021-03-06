/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteDiagnosesTables]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteDiagnosesTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteDiagnosesTables]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteDiagnosesTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
    
                  
CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteDiagnosesTables]                         
(                            
 @DocumentVersionId as int                                                                                                                                               
)                            
As                  
/******************************************************************************                    
**  File:                    
**  Name: csp_SCWebGetServiceNoteDiagnosesTables                    
**  Desc: This fetches data for Service Note Diagnoses Tables                   
**                    
**  This template can be customized:                    
**                                  
**  Return values:                    
**                     
**  Called by:   csp_SCGetServiceNoteCustomTables Stored Procedures                  
**                                  
**  Parameters:                    
**  Input       Output                    
**     ----------      -----------                    
**  DocumentVersionId    Result Set containing values from Service Note Diagnoses Tables                  
**                    
**  Auth: Mohit Maddan                    
**  Date: 29-March-10                    
*******************************************************************************                    
**  Change History                    
*******************************************************************************                    
**  Date:    Author:    Description:       
**  19-07-2010  Damanpreet Kaur Modified Because of new data model                   
**  --------   --------   -------------------------------------------                    
                  
*******************************************************************************/                    
BEGIN TRY                    
              
  --DiagnosesIAndII                
 SELECT     D.DocumentVersionId, D.DiagnosisId, D.Axis, D.DSMCode, D.DSMNumber, D.DiagnosisType, D.RuleOut, D.Billable, D.Severity, D.DSMVersion, D.DiagnosisOrder,               
       D.Specifier,D.Remission,D.[Source], D.CreatedBy, D.CreatedDate, D.ModifiedBy, D.ModifiedDate, D.RecordDeleted, D.DeletedDate, D.DeletedBy, DSM.DSMDescription, case D.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText           
  
      
 FROM         DiagnosesIAndII AS D INNER JOIN              
       DiagnosisDSMDescriptions AS DSM ON DSM.DSMCode = D.DSMCode AND DSM.DSMNumber = D.DSMNumber              
 WHERE     (D.DocumentVersionId = @DocumentVersionId) AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')                
                
  ---DiagnosesIII                
 SELECT     DocumentVersionId, Specification, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy              
 FROM         DiagnosesIII              
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')               
                
   --DiagnosesIV                
 SELECT     DocumentVersionId, PrimarySupport, SocialEnvironment, Educational, Occupational, Housing, Economic, HealthcareServices, Legal, Other, Specification, CreatedBy,               
       CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy              
 FROM         DiagnosesIV              
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')              
                
   --DiagnosesV                
 SELECT     DocumentVersionId, AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy              
 FROM         DiagnosesV              
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')               
             
  --DiagnosesIIICodes        
    SELECT     DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,    
    DIIICod.DeletedBy              
 FROM  DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode            
 WHERE     (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')              
        
   --DiagnosesMaxOrder                        
 SELECT  top 1 max(DiagnosisOrder) as DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,  
 RecordDeleted,DeletedBy,DeletedDate from  DiagnosesIAndII   
 where DocumentVersionId=@DocumentVersionId            
 and  IsNull(RecordDeleted,''N'')=''N'' group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate  
 order by DiagnosesMaxOrder desc                
   
END TRY                 
BEGIN CATCH                    
 declare @Error varchar(8000)                    
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteDiagnosesTables'')                     
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                      
    + ''*****'' + Convert(varchar,ERROR_STATE())                    
 RAISERROR                     
 (                    
  @Error, -- Message text.                    
  16,  -- Severity.                    
  1  -- State.                    
 );                    
END CATCH ' 
END
GO
