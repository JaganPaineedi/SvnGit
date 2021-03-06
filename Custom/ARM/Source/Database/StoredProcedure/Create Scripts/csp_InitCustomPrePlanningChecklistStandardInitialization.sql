/****** Object:  StoredProcedure [dbo].[csp_InitCustomPrePlanningChecklistStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPrePlanningChecklistStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomPrePlanningChecklistStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPrePlanningChecklistStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomPrePlanningChecklistStandardInitialization]                                       
(                                              
  @ClientID int,      
  @StaffID int,    
  @CustomParameters xml                                           
)                                           
As                                            
 /****************************************************************************/                                                        
 /* Stored Procedure:csp_InitCustomPrePlanningChecklistStandardInitialization*/                                               
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
 /*   Nov18,2009         Ankesh     Made changes as paer dataModel SCWebVenture3.0  */                                                                                                                                                            
 /****************************************************************************/                                                         
BEGIN                            
   BEGIN TRY       

         Select TOP 1 ''CustomPrePlanningChecklists'' AS TableName,-1 as ''DocumentVersionId''                            
                             
   --Custom data                        
    ,[Residential]      
    ,[OccupationalCommunityParticpation]      
    ,[Safety]      
    ,[Legal]      
    ,[Health]      
    ,[NaturalSupports]      
    ,[Other]      
    ,[Participants]      
    ,[Facilitator]      
    ,[Assessments]      
    ,[TimeLocation]      
    ,[ISsuesToAvoid]      
    ,[CommunicationAccomodations]      
    ,[WishToDiscuss]      
    ,[SourceOfPrePlanningInformation]      
    ,[SelfDetermination]      
    ,[FiscalIntermediary]      
    ,[PCPInformationPamphletGiven]      
    ,[PCPInformationDiscussed]      
    ,'''' as CreatedBy      
    ,getdate() as CreatedDate      
    ,'''' as ModifiedBy      
    ,getdate() as ModifiedDate       
    FROM systemconfigurations s left outer join CustomPrePlanningChecklists                                                                      
    on s.Databaseversion = -1                     
       
                                                        
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
