/****** Object:  StoredProcedure [dbo].[csp_SCGetDataDiagnosis]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDataDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDataDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDataDiagnosis]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                         
/* Stored Procedure: [csp_SCGetDataDiagnosis]        */                                                                         
/* Copyright: 2008 Streamline SmartCare          */                                                                                  
/* Creation Date:  September 11,2009          */                                                                                  
/* Purpose: Gets Data  For Diagnosis Document        */                                                                                 
/* Input Parameters: @DocumentId,@DocumentVersionID       */                
/* Output Parameters:              */                                                                                  
/* Return:  0=success, otherwise an error number       */                   
/* Purpose to show the web document for Diagnosis       */                                                                        
/* Calls:                 */                                        
/* Data Modifications:              */                                        
/* Updates:                 */                                        
/* Date       Author        Purpose           */                                        
/* 11/09/2009           Mohit Madaan    Created        */                  
/* 03/04/2010 Vikas Monga             */             
/* 30/03/2012 Amit Kumar Srivastava Added a) left outer join with globalcodes for codename as type,b) DiagnosesIIICodes.Source in DiagnosesIIICodes table, Task Number # 17,  Diagnosis Document Changes., Development Phase III (Offshore)             */     
            
/* 23/04/2012 Amit Kumar Srivastava Added "AxisIOrII" in DiagnosesIIICodes table, Task Number # 602,  Diagnosis Document Changes - List display(Axis I and II will show up as I and II (instead of 1 and 2).), Thresholds - Bugs/Features (Offshore)           
  */                 
/* -- Remove [Documents] and [DocumentVersions]        */   
 /* 03/May/2012  amit Kumar Srivastava   added DiagnosisAxisIVShowNone as ''DiagnosesIV'' */  
 /* mar/14/2013  Atul Pandey             What:pulled SP from 3.5x merge Interact SVN Why: w.r.t task #563 of   Centrawellness-Bugs/Features */                                              
/****************************************************************************/                  
CREATE PROCEDURE [dbo].[csp_SCGetDataDiagnosis]                   
   @DocumentVersionId INT                
AS                  
BEGIN                                           
 BEGIN TRY                  
                     
  --DiagnosesIAndII                  
 SELECT     D.DocumentVersionId, D.DiagnosisId, D.Axis, D.DSMCode, D.DSMNumber, D.DiagnosisType, D.RuleOut , D.Billable, D.Severity, D.DSMVersion, D.DiagnosisOrder,                 
       D.Specifier,D.Remission,D.[Source], D.RowIdentifier, D.CreatedBy, D.CreatedDate, D.ModifiedBy, D.ModifiedDate, D.RecordDeleted, D.DeletedDate, D.DeletedBy, DSM.DSMDescription       
       , case D.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText, gc.codename as ''DiagnosisTypeText'',  
       case D.Axis when 1 then ''I''  else ''II'' end as ''AxisIOrII''              
 FROM         DiagnosesIAndII AS D INNER JOIN              
       DiagnosisDSMDescriptions AS DSM ON DSM.DSMCode = D.DSMCode AND DSM.DSMNumber = D.DSMNumber    
       left outer join globalcodes gc    On   D.DiagnosisType =   gc.globalcodeid       
 WHERE     (D.DocumentVersionId = @DocumentVersionId) AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')                  
                  
  ---DiagnosesIII                  
 SELECT     DocumentVersionId, Specification, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                
 FROM         DiagnosesIII                
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')                 
                  
   --DiagnosesIV                  
 SELECT     DocumentVersionId, PrimarySupport, SocialEnvironment, Educational, Occupational, Housing, Economic, HealthcareServices, Legal, Other, Specification, CreatedBy,                 
       CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, DiagnosisAxisIVShowNone                
 FROM         DiagnosesIV                
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')                
                  
   --DiagnosesV                  
 SELECT     DocumentVersionId, AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                
 FROM         DiagnosesV                
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')                 
               
  --DiagnosesIIICodes          
    SELECT     DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,      
    DIIICod.DeletedBy,DIIICod.Source                
 FROM         DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode              
 WHERE     (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')                
       
   SELECT  top 1 max(DiagnosisOrder) as DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,    
   RecordDeleted,DeletedBy,DeletedDate from  DiagnosesIAndII     
   where DocumentVersionId=@DocumentVersionId              
      and  IsNull(RecordDeleted,''N'')=''N'' group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate    
      order by DiagnosesMaxOrder desc                           
                
 END TRY                  
 BEGIN CATCH                                                                 
 DECLARE @Error varchar(8000)                                     
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                            
 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetDataCustomDiagnosis'')                                                                   
 + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                    
 + ''*****'' + Convert(varchar,ERROR_STATE())                    
                                                                                  
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                                  
                                                                 
 END CATCH                              
END   ' 
END
GO
