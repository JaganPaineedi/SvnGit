/****** Object:  StoredProcedure [dbo].[csp_InitCustomConectionNoteStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomConectionNoteStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomConectionNoteStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomConectionNoteStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE  [dbo].[csp_InitCustomConectionNoteStandardInitialization]                                   
(                                        
  @ClientID int                                     
)                                        
As                                        
 /****************************************************************************/                                                  
 /* Stored Procedure:csp_InitCustomConectionNoteStandardInitialization       */                                         
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */       
 /* Author: Pradeep                                                          */                                                 
 /* Creation Date:  Sept11,2009                                              */                                                  
 /* Purpose: Used to initialize PrePlanningCheckList document                */                                                 
 /* Input Parameters: @ClientID int                        */                                                
 /* Output Parameters:None                                                   */                                                  
 /* Return:                                                                  */                                                  
 /* Calls:                                                                   */      
 /* Called From:csp_SCInitializeDocument                                                             */                                                  
 /* Data Modifications:                                                      */                                                  
 /*                                                                          */  
 /*-------------Modification History--------------------------               */  
 /****************************************************************************/                                                   
BEGIN                      
   BEGIN TRY 

         Select TOP 1 ''CustomConnectionsNotes'' AS TableName,-1 as ''DocumentVersionId'',                      
         0 as DocumentId,0 as Version                   
         --Custom data                  
		   ,C.[Purpose]
           ,C.[Location]
           ,C.[EmploymentStatus]
           ,C.[HoursWorked]
           ,C.[Narrative]
           ,C.[OnTime]
           ,C.[Appearance]
           ,C.[ProductiveWork]
           ,C.[AppropriatePlacement]
           ,C.[InteractSupervisor]
           ,C.[InteractCoWorker]
           ,C.[Hygiene]
           ,C.[SatisfactoryWork]
           ,C.[ProductiveSession]
		   ,'''' as CreatedBy
		   ,getdate() as CreatedDate
		   ,'''' as ModifiedBy
		   ,getdate() as ModifiedDate 
		    from systemconfigurations s left outer join CustomConnectionsNotes  c         
			on s.Databaseversion = -1   
               
  
   ---
                                                  
 END TRY                      
 BEGIN CATCH                      
    DECLARE @Error varchar(8000)                                                         
   set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                        
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_InitCustomPrePlanningChecklistStandardInitialization]'')                                                         
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                        
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                        
   RAISERROR                                                         
   (                   
   @Error, -- Message text.                                                         
   16, -- Severity.                                                         
   1 -- State.                                                         
   )                      
 END CATCH                                    
End
' 
END
GO
