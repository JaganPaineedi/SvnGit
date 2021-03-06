/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomDBTGroupNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDBTGroupNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomDBTGroupNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDBTGroupNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomDBTGroupNotes]               
(                  
 @DocumentVersionId  int                                                                                                                                     
)                  
As        
/******************************************************************************          
**  Name: csp_SCWebGetServiceNoteCustomDBTGroupNotes          
**  Desc: This fetches data for Service Note Custom Tables         
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Parameters:          
**  Input       Output          
**     ----------      -----------          
** DocumentVersionId    Result Set containing values from Service Note Custom Tables        
**          
**  Auth: Mohit Madaan          
**  Date: 5-April-2010          
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:    Author:    Description:          
**  --------   --------   -------------------------------------------          
        
*******************************************************************************/          
BEGIN TRY          
    
SELECT [DocumentVersionId]    
      ,[BillingClinician]    
      ,[GoalsAddressed]    
      ,[CurrentDiagnosis]    
      ,[CurrentTreatmentPlan]    
      ,[Module]    
      ,[ModuleNote]    
      ,[MoodAnger]    
      ,[MoodDepression]    
      ,[MoodEuthymic]    
      ,[MoodMania]    
      ,[MoodSuicidal]    
      ,[MoodNote]    
      ,[CompletedDiaryCard]    
      ,[CompletedHomework]    
      ,[DiaryCardNote]    
      ,[HandsOutReiviewed]    
      ,[HomeworkAssigned]    
      ,[Intervention]    
      ,[OptionalComments]    
      ,[AxisV]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]    
  FROM [CustomDBTGroupNotes]    
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId          
         
END TRY          
        
BEGIN CATCH          
 declare @Error varchar(8000)          
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomDBTGroupNotes'')           
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())            
    + ''*****'' + Convert(varchar,ERROR_STATE())          
            
 RAISERROR           
 (          
  @Error, -- Message text.          
  16,  -- Severity.          
  1  -- State.          
 );          
          
END CATCH
' 
END
GO
