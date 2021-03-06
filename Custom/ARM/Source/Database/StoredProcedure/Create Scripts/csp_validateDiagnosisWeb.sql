/****** Object:  StoredProcedure [dbo].[csp_validateDiagnosisWeb]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDiagnosisWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateDiagnosisWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDiagnosisWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateDiagnosisWeb]      
     
@DocumentVersionId INT      
as      
/******************************************************************************                                    
**  File: csp_validateDiagnosisWeb                                
**  Name: csp_validateDiagnosisWeb            
**  Desc: For Validation  on Custom Diagnosis document(For Prototype purpose, Need modification)            
**  Return values: Resultset having validation messages                                    
**  Called by:                                     
**  Parameters:                
**  Auth:  Ankesh Bharti                   
**  Date:  Nov 17 2009                                
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:       Author:       Description:                                    
**  17/11/2009  Ankesh Bharti  Created according to Data Model 3.0      
**  --------    --------        ----------------------------------------------------                                    
*******************************************************************************/                                  
    
Begin                                                  
        
 Begin try     
 --*TABLE CREATE*--               
Create Table #DiagnosesIandII      
(      
 Axis int NOT NULL ,      
 DSMCode char (6) NOT NULL ,      
 DSMNumber int NOT NULL ,      
 DiagnosisType int,      
 RuleOut char(1),      
 Billable char(1),      
 Severity int,      
 DSMVersion varchar (6) NULL ,      
 DiagnosisOrder int NOT NULL ,      
 Specifier text NULL ,      
 RowIdentifier char(36),      
 CreatedBy varchar(100),      
 CreatedDate Datetime,      
 ModifiedBy varchar(100),      
 ModifiedDate Datetime,      
 RecordDeleted char(1),      
 DeletedDate datetime NULL ,      
 DeletedBy varchar(100)       
)      
--*INSERT LIST*--             
Insert into #DiagnosesIandII      
(      
Axis, DSMCode, DSMNumber, DiagnosisType,      
RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier,      
 RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,       
RecordDeleted, DeletedDate, DeletedBy )      
--*Select LIST*--             
select      
Axis, DSMCode, DSMNumber, DiagnosisType,      
 RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier,       
a.RowIdentifier, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate,      
 a.RecordDeleted, a.DeletedDate, a.DeletedBy      
FROM DiagnosesIAndII a        
where a.DocumentVersionId = @DocumentVersionId      
and isnull(a.RecordDeleted,''N'') = ''N''      
    
--*TABLE CREATE*--               
CREATE TABLE #DiagnosesV (      
 AxisV int NULL ,      
 CreatedBy varchar(100),      
 CreatedDate Datetime,      
 ModifiedBy varchar(100),      
 ModifiedDate Datetime,      
 RecordDeleted char(1),      
 DeletedDate datetime NULL ,      
 DeletedBy varchar(100))      
--*INSERT LIST*--             
Insert into #DiagnosesV      
(      
AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,      
 DeletedDate, DeletedBy      
)      
--*Select LIST*--       
select      
AxisV, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted,      
a.DeletedDate, a.DeletedBy      
FROM DiagnosesV a      
where a.DocumentVersionId = @DocumentVersionId     
and isnull(a.RecordDeleted,''N'') = ''N''      
      
      
/*If (@DocumentVersionId in (101,5))      
Begin      
 Insert into #validationReturnTable      
 (TableName,      
 ColumnName,      
 ErrorMessage      
 )      
   
 Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please specify Axis I - II primary diagnosis''      
  where not exists      
  (select * from #diagnosesIandII where isnull(DSMCode,'''') <> ''''       
   and DiagnosisType = 140      
   and isnull(Axis,'''') in (1, 2))      
 UNION    
 Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please select Axis I - II diagnosis type''      
  where not exists      
  (select * from #diagnosesIandII where isnull(DSMCode,'''') <> ''''      
  and isnull(Axis,'''') in (1, 2) and isnull(DiagnosisType,'''') <> '''')       
 Union      
 Select ''CustomDiagnosis'', ''DeletedBy'', ''Dx - V code or 799 cannot be primary diagnosis''      
 where exists (Select * from #DiagnosesIAndII      
      where (DSMCode like ''V%'' or DSMCode like ''799%'')      
      and DiagnosisType = 140)      
 UNION      
 Select ''DiagnosesV'', ''AxisV'', ''Dx - Please specify Axis V''      
  where not exists      
  (select * from #diagnosesV where isnull(AxisV,'''') <> '''')   
  
END     */    
      
If (@DocumentVersionId in (349))      
Begin      
 Insert into #validationReturnTable      
 (TableName,      
 ColumnName,      
 ErrorMessage,      
 PageIndex      
 )      
      
 Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please specify Axis I - II primary diagnosis'',16      
  where not exists      
  (select * from #diagnosesIandII where isnull(DSMCode,'''') <> ''''       
   and DiagnosisType = 140      
   and isnull(Axis,'''') in (1, 2))      
 UNION      
 Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please select Axis I - II diagnosis type'',16      
  where not exists      
  (select * from #diagnosesIandII where isnull(DSMCode,'''') <> ''''      
  and isnull(Axis,'''') in (1, 2) and isnull(DiagnosisType,'''') <> '''')       
 Union      
 Select ''CustomDiagnosis'', ''DeletedBy'', ''Dx - V code or 799 cannot be primary diagnosis'',16      
 where exists (Select * from #DiagnosesIAndII      
      where (DSMCode like ''V%'' or DSMCode like ''799%'')      
      and DiagnosisType = 140)      
 UNION      
 Select ''DiagnosesV'', ''AxisV'', ''Dx - Please specify Axis V'',16      
  where not exists      
  (select * from #diagnosesV where isnull(AxisV,'''') <> '''')      
END      
       
 If (@DocumentVersionId in (117, 121))      
 Begin      
 Insert into #validationReturnTable      
 (TableName,      
 ColumnName,      
 ErrorMessage      
 )      
      
 Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please specify Axis I - II primary diagnosis''      
  where not exists      
  (select * from #diagnosesIandII where isnull(DSMCode,'''') <> ''''       
   and DiagnosisType = 140      
   and isnull(Axis,'''') in (1, 2))      
 UNION      
 Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please select Axis I - II diagnosis type''      
  where not exists      
  (select * from #diagnosesIandII where isnull(DSMCode,'''') <> ''''      
  and isnull(Axis,'''') in (1, 2) and isnull(DiagnosisType,'''') <> '''')       
 Union      
 Select ''CustomDiagnosis'', ''DeletedBy'', ''Dx - V code or 799 cannot be primary diagnosis''      
 where exists (Select * from #DiagnosesIAndII      
      where (DSMCode like ''V%'' or DSMCode like ''799%'')      
      and DiagnosisType = 140)      
     
 End      
end try                                                                                     
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateDiagnosisWeb'')                                                                                 
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
