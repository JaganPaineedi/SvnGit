/****** Object:  StoredProcedure [dbo].[csp_InitCustomHRMAssessmentDiagnosisIntialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHRMAssessmentDiagnosisIntialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomHRMAssessmentDiagnosisIntialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHRMAssessmentDiagnosisIntialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomHRMAssessmentDiagnosisIntialization]                                
(                                                                                                                                                                                                
                                                                                                                                                             
@DocumentVersionId int,                  
@InitializeDefaultFields char(1) ,    
@AssessmentType    char(1),  
@CurrentAuthorId int          
)                
As                  
 /* Stored Procedure: [csp_InitCustomHRMAssessmentDiagnosisIntialization]   */                                                                                                                                                                                 
  
 /* Copyright: 2006 Streamline SmartCare            */                                                                                                                                                                                                         
  
    
      
                             
 /* Creation Date:  24/Feb/2010               */                                                                                                                                                                                                          
 /*                      */                                                                                                                                                                                                       
 /* Purpose: To Initialize CustomPAAssessments Documents        */                                                                                                                                                                                             
  
    
      
 /*                      */                                                                                                                                                                                                       
 /* Input Parameters: @DocumentVersionId, @InitializeDefaultValues,   eg:- 14309,92,''N''    */                                                         
 /* Output Parameters:                 */                                                                                        
 /* Return:                    */                                                                                                
 /* Called By:CustomDocuments Class Of DataService          */                                                                                            
 /* Calls:                    */                                                                        
 /*                      */                                                                                                                                             
 /* Data Modifications:                 */                                                                                                                                                                              
 /*                      */                                                                                                                                                          
 /*   Updates:                   */                                                                                                                                                       
 /*       Date              Author                Purpose                            */                                                                                                                                                                        
  
    
      
       
 /*       Sandeep Singh                 */  
 /*   26/Jun/2012			Mamta Gupta			DocumentVersionId<0 check added to intialize Diagnonsis III, IV, V in case of update
												Kalamazoo Bugs Go Live - 1565*/                                     
 /*********************************************************************/                     
  BEGIN                
  BEGIN TRY    
  


--
-- Find Source of Master Level Previous Diagnosis Document
--  
Declare @Source varchar(max)
Declare @CanDiagnose char(1)

    
Set @Source = (Select s.FirstName + '' '' + s.LastName + (case when s.SigningSuffix IS null then '''' else  '', '' + isnull(s.SigningSuffix, '''') end)
           From Documents d    
           Join Staff s on s.StaffId = d.AuthorId    
           Join CustomDegreePriorities p on p.DegreeId = s.Degree    
           Where DocumentCodeId = 5    
           and Status in (22)    
           and isnull(p.CanDiagnose, ''N'')= ''Y''    
		   and d.CurrentDocumentVersionId = @DocumentVersionId
           and ISNULL(d.RecordDeleted, ''N'') = ''N''    
           and ISNULL(s.RecordDeleted, ''N'') = ''N''  
           ) 

--Can Author Diagnose    
If exists (Select * from Staff s    
   Join CustomDegreePriorities p on p.DegreeId = s.Degree    
   where s.StaffId = @CurrentAuthorId    
   and ISNULL(s.RecordDeleted, ''N'')= ''N''    
   and p.CanDiagnose = ''Y''    
   )    
   
Begin     
 Set @CanDiagnose = ''Y''    
End    
Else     
Begin     
 Set @CanDiagnose = ''N''    
End    
  
   
   
 --
 -- Initialize Axis I and II
 --
 If(@InitializeDefaultFields=''Y'')  or @AssessmentType in (''I'', ''S'') or (@AssessmentType in (''A'') and @CanDiagnose = ''Y'') or @DocumentVersionId is null
BEGIN
	GoTo axisIII
END
ELSE
BEGIN    
    SELECT ''DiagnosesIAndII'' as TableName                     
      ,Convert(int,0 - Row_Number() Over (Order by  DiagnosesIAndII.DiagnosisId asc))                                             
       as  [DiagnosisId]      
      ,[DocumentVersionId]      
      ,[Axis]      
      ,[DSMCode]      
      ,[DSMNumber]      
      ,[DiagnosisType]      
      ,[RuleOut]      
      ,[Billable]      
      ,[Severity]      
      ,[DSMVersion]      
      ,[DiagnosisOrder]      
      ,[Specifier]      
      ,[Remission]      
      ,isnull([Source], @Source) as [Source]--      
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]      
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedDate]      
      ,[DeletedBy]      
      ,''CustomGrid'' as ParentChildName         
   FROM [dbo].DiagnosesIAndII                    
      where DocumentVersionId=@DocumentVersionId and IsNull(RecordDeleted,''N'')=''N''                    
                                                                                                                                                                           
       
   SELECT  Top 1 ''DiagnosesIANDIIMaxOrder'' as TableName,max(DiagnosisOrder) as DiagnosesMaxOrder   ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate             
   From  DiagnosesIAndII             
   Where DocumentVersionId=@DocumentVersionId                      
   and  IsNull(RecordDeleted,''N'')=''N''            
   Group By CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate 
   Order by DiagnosesMaxOrder desc              
            
END
 
 
 
 --
 -- Initialize Axis III
 --
  AxisIII:
              
     If((@InitializeDefaultFields=''Y'')  or @AssessmentType in (''I'', ''S'')  or (@DocumentVersionId is null or   @DocumentVersionId<0))
     BEGIN                  
                       
     -----For DiagnosesIII-----                                                    
      SELECT ''DiagnosesIII'' AS TableName, -1 as ''DocumentVersionId''                              
      ,DiagnosesIII.CreatedBy                              
      ,DiagnosesIII.CreatedDate                              
      ,DiagnosesIII.ModifiedBy                              
      ,DiagnosesIII.ModifiedDate                              
      ,[RecordDeleted]                              
      ,[DeletedDate]                          
      ,[DeletedBy]                              
      ,[Specification]                               
      FROM systemconfigurations s left outer join DiagnosesIII                                                            
      on s.Databaseversion=-1                                                                                                                                                                                            
      END        
      ELSE     
      BEGIN    
            SELECT ''DiagnosesIII'' AS TableName, -1 as ''DocumentVersionId''                              
      ,DiagnosesIII.CreatedBy                              
      ,DiagnosesIII.CreatedDate                              
      ,DiagnosesIII.ModifiedBy                              
      ,DiagnosesIII.ModifiedDate                              
      ,[RecordDeleted]                              
      ,[DeletedDate]                          
      ,[DeletedBy]                              
      ,[Specification]                          
      FROM DiagnosesIII  WHERE DocumentVersionId=@DocumentVersionId       
          
      END        
                    
            
  -----For DiagnosesIV-----     
     if((@InitializeDefaultFields=''Y'')  or @AssessmentType in (''I'', ''A'', ''S'')      or (@DocumentVersionId is null or  @DocumentVersionId<0))
     BEGIN                  
                                                                                                                                                             
 SELECT ''DiagnosesIV'' AS TableName, -1 as ''DocumentVersionId'',PrimarySupport,SocialEnvironment,Educational                                                                                                                                                    
   
   
      
     ,Occupational,Housing,Economic,HealthcareServices,Legal,Other,Specification,DiagnosesIV.CreatedBy                                                                                                                                 
      ,DiagnosesIV.CreatedDate,DiagnosesIV.ModifiedBy                                                                                                                                                                                                          
      ,DiagnosesIV.ModifiedDate,DiagnosesIV.RecordDeleted,DeletedDate,DeletedBy                                                                                                                                                                                
  
    
      
      FROM systemconfigurations s left outer join DiagnosesIV                                                                                                          
      on s.Databaseversion=-1       
         
     END      
     ELSE    
     BEGIN    
       SELECT ''DiagnosesIV'' AS TableName, -1 as ''DocumentVersionId'',PrimarySupport,SocialEnvironment,Educational                                                                                                                                               
  
         
      
     ,Occupational,Housing,Economic,HealthcareServices,Legal,Other,Specification,DiagnosesIV.CreatedBy                                                                                        
      ,DiagnosesIV.CreatedDate,DiagnosesIV.ModifiedBy                                                                                                                                                                 
      ,DiagnosesIV.ModifiedDate,DiagnosesIV.RecordDeleted,DeletedDate,DeletedBy                                                                                                                                                                               
  
     
      
      FROM DiagnosesIV                                                                                                          
      WHERE DocumentVersionId=@DocumentVersionId        
      END                                                                                                          
                      
  -----For DiagnosesV-----        
     if((@InitializeDefaultFields=''Y'')  or @AssessmentType in (''I'', ''A'', ''S'')     or (@DocumentVersionId is null  or  @DocumentVersionId<0))            
     BEGIN                  
                                                                                                                                                                            
    SELECT ''DiagnosesV'' AS TableName, -1 as ''DocumentVersionId'',AxisV                                                                                                              
   ,DiagnosesV.CreatedBy,DiagnosesV.CreatedDate                                                    
      ,DiagnosesV.ModifiedBy                                                    
      ,DiagnosesV.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                                                                                                                                                          
      FROM systemconfigurations s left outer join DiagnosesV                                                                                                                                                                           
      on s.Databaseversion=-1                       
                        
      END                  
      ELSE    
      BEGIN    
           SELECT ''DiagnosesV'' AS TableName, -1 as ''DocumentVersionId'',AxisV                                                                                                              
      ,DiagnosesV.CreatedBy,DiagnosesV.CreatedDate                                       
      ,DiagnosesV.ModifiedBy                                                    
      ,DiagnosesV.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                                                                        
      FROM DiagnosesV  WHERE DocumentVersionId=@DocumentVersionId         
      END                
                  
      
      

                      
                        
                                            
                                 
        END TRY                
                        
        BEGIN CATCH                                                                  
DECLARE @Error varchar(8000)                                                            
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                                                 
  
    
      
        
          
           
              
                 
                                                               
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomHRMAssessmentsStandardInitialization'')                                                                                                                                                 
  
    
      
        
          
            
              
                
                                                               
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
