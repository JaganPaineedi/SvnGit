/****** Object:  StoredProcedure [dbo].[csp_InitCustomHRMServiceNotesStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHRMServiceNotesStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomHRMServiceNotesStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHRMServiceNotesStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'        
CREATE PROCEDURE  [dbo].[csp_InitCustomHRMServiceNotesStandardInitialization]      
(                                          
 @ClientID int,          
 @StaffID int,        
 @CustomParameters xml                                         
)                                                                    
As                                                                      
 /*********************************************************************/                                                                                
 /* Stored Procedure: csp_InitCustomHRMServiceNotesStandardInitialization               */        
                                                                       
 /* Creation Date:  12/April/2010                                    */                                                                                
 /*                                                                   */                                                                                
 /* Purpose: Gets Fields of CustomHRMServiceNotes last signed Document Corresponding to clientd */                                                                               
 /*                                                                   */                                                                              
 /* Input Parameters:  */                                                                              
 /*                                                                   */                                                                                 
 /* Output Parameters:                                */                                                                                
 /*                                                                   */                                                                                
 /* Return:   */                                                                                
 /*                                                                   */                                                                                
 /* Called By:CustomDocuments Class Of DataService    */                                                                      
 /*                                                                   */                                                                                
 /* Calls:                                                            */                                                                                
 /*                                                                   */                                                                                
 /* Data Modifications:                                               */                                                                                
 /*                                                                   */                                                                                
 /*   Updates:                                                          */                                                                                
                                                                       
 /*       Date                Author                  Purpose                                    
		02/08/2011			avoss			corrected diagnosis to show all dx''s through loop. 
		03/08/2011			dharvey			Replaced existing loop to handle large DiagnosisOrder values.
 
 
 */                                                                                
 /***********************************************************************************************/           
Begin                            
            
Begin try        
--DECLARE @CurrentAddress VARCHAR(MAX)         
DECLARE @Diagnosis VARCHAR(MAX)          
DECLARE @CurrentDocumentVersionId INT          
          
          
-- Fetch Current DocumentVersionId          
          
set @CurrentDocumentVersionId = (select top 1 CurrentDocumentVersionId          
from Documents a                              
where a.ClientId = @ClientID                              
and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                              
and a.Status = 22                              
and isNull(a.RecordDeleted,''N'')<>''Y''                                 
and a.DocumentCodeId =5                              
order by a.EffectiveDate desc,a.ModifiedDate desc )          
    

--
-- Replaced existing loop to prevent DB Timeout when DiagnosisOrder is stored as extremely large integers
--
DECLARE @DxOrder Table (PK INT IDENTITY(1,1), DiagnosisOrder int)

INSERT into @DxOrder
Select a.DiagnosisOrder
from DiagnosesIAndII a                                
Join DiagnosisDSMDescriptions b on a.DSMCode=b.DSMCode                                
where a.DocumentVersionId = @CurrentDocumentVersionId                            
and isNull(a.RecordDeleted,''N'')<>''Y'' 
and a.billable=''Y''
Order by a.DiagnosisOrder

--select top 100 * from DiagnosesIAndII
set @Diagnosis =  ''Axis I-II\r\n^'' 

DECLARE @DxCounter INT
DECLARE @LoopCounter INT
DECLARE @DiagnosisOrder INT

        SET @LoopCounter = ISNULL((SELECT COUNT(*) FROM @DxOrder),0)                                                                     
        SET @DxCounter = 1

        WHILE @LoopCounter > 0 AND @DxCounter <= @LoopCounter
            BEGIN
                SELECT @DiagnosisOrder = DiagnosisOrder
                FROM @DxOrder 
                WHERE PK = @DxCounter
                
					select top 1 @Diagnosis = @Diagnosis 
											+ ISNULL(Convert(varchar(10),isnull(a.DsmCode,'''')) 
											+ ''^'' +ISNULL(b.DsmDescription,''''),'''')+''\r\n^''
					from DiagnosesIAndII a                                
					Join DiagnosisDSMDescriptions b on a.DSMCode=b.DSMCode                                
					where a.DocumentVersionId = @CurrentDocumentVersionId
					and a.DiagnosisOrder = @DiagnosisOrder          
					and a.DSMNumber  = b.DSMNumber                 
					and isNull(a.RecordDeleted,''N'')<>''Y'' 
					and a.billable=''Y''      
					and a.RuleOut<>''Y''
                
               SET @DxCounter = @DxCounter + 1
            END

/*
declare @Id int, @MaxId int
select 
	 @Id = ISNULL(min(a.DiagnosisOrder),0)
	,@MaxId = isnull(Max(a.DiagnosisOrder),0)
from DiagnosesIAndII a                                
Join DiagnosisDSMDescriptions b on a.DSMCode=b.DSMCode                                
where a.DocumentVersionId = @CurrentDocumentVersionId                            
and isNull(a.RecordDeleted,''N'')<>''Y'' 
and a.billable=''Y''
group by a.DocumentVersionId

--select top 100 * from DiagnosesIAndII
set @Diagnosis =  ''Axis I-II\r\n^'' 

-- Fetch Current Diagnosis
if @Id <> 0 and @MaxId <> 0
begin 
	--Begin Loop       
	While @Id <= @MaxId           
	Begin      
		select top 1 @Diagnosis = @Diagnosis + ISNULL(Convert(varchar(10),isnull(a.DsmCode,'''')) + ''^'' +ISNULL(b.DsmDescription,''''),'''')+''\r\n^''
		from DiagnosesIAndII a                                
		Join DiagnosisDSMDescriptions b on a.DSMCode=b.DSMCode                                
		where a.DocumentVersionId = @CurrentDocumentVersionId
		and a.DiagnosisOrder = @Id          
		and a.DSMNumber  = b.DSMNumber                 
		and isNull(a.RecordDeleted,''N'')<>''Y'' 
		and a.billable=''Y''      
		and a.RuleOut<>''Y''
		
		set @Id = @Id + 1      
	End 
end
*/
/*     
set @Diagnosis = @Diagnosis + isnull((select convert(varchar(10),ISNULL(a.DSMCODE, '' ''))+ ''^'' + ISNULL(b.DSMDescription,'' '')           
from DiagnosesIAndII a                                
Join DiagnosisDSMDescriptions b on a.DSMCode=b.DSMCode                                
where a.DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII  where DocumentVersionId = @CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y'')                             
and isNull(a.RecordDeleted,''N'')<>''Y'' and billable=''Y''),'''')   
*/
   

       
                            
Select TOP 1 ''CustomHRMServiceNotes'' AS TableName,
 -1 as ''HRMServiceNoteId''
,-1 as ''DocumentVersionId''
,@Diagnosis as Diagnosis
,'''' as CreatedBy          
,getdate() as CreatedDate          
,'''' as ModifiedBy          
,getdate() ModifiedDate                      
,NEWID()  AS RowIdentifier
from systemconfigurations s left outer join CustomHRMServiceNotes          
on s.Databaseversion = -1        
                               
end try                                                      
     
BEGIN CATCH          
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomHRMServiceNotesStandardInitialization'')                                                                                     
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
