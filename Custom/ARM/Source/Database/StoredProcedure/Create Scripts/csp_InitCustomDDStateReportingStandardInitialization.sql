/****** Object:  StoredProcedure [dbo].[csp_InitCustomDDStateReportingStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDDStateReportingStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDDStateReportingStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDDStateReportingStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
            
create PROCEDURE  [dbo].[csp_InitCustomDDStateReportingStandardInitialization]            
(                                
 @ClientID int,          
 @StaffID int,        
 @CustomParameters xml                                
)                                                        
As                                                          
                                                                 
 /*********************************************************************/                                                                    
 /* Stored Procedure: [csp_InitCustomDDStateReportingStandardInitialization]               */                                                           
                                                           
 /* Copyright: 2006 Streamline SmartCare*/                                                                    
                                                           
 /* Creation Date:  1/04/2011                                    */                                                                    
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
if(exists(Select * from CustomDDStateReporting C,Documents D ,        
 DocumentVersions V                                  
    where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId        
     and D.ClientId=@ClientID                                        
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                                    
BEGIN                   
                  
                          
 SELECT  TOP (1) ''CustomDDStateReporting'' AS TableName, C.DocumentVersionId, C.CommunicationStyle    
      ,C.MakeSelfUnderstood    
      ,C.SupportWithMobility    
      ,C.NutritionalIntake    
      ,C.SupportPersonalCare    
      ,C.Relationships    
      ,C.FamilyFriendSupportSystem    
      ,C.SupportForChallengingBehaviors    
      ,C.BehaviorPlanPresent    
      ,C.NumberOfAntiPsychoticMedications    
      ,C.NumberOfOtherPsychotropicMedications    
      ,C.MajorMentalIllness  , C.CreatedBy, C.CreatedDate,     
       C.ModifiedBy, C.ModifiedDate    
 FROM   CustomDDStateReporting AS C INNER JOIN    
        DocumentVersions AS V ON C.DocumentVersionId = V.DocumentVersionId INNER JOIN    
        Documents AS D ON V.DocumentId = D.DocumentId    
 WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')    
 ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC   ,V.DocumentVersionId DESC                          
END                                    
else                                    
BEGIN                                    
Select TOP 1 ''CustomDDStateReporting'' AS TableName, -1 as ''DocumentVersionId'',                        
                     
--Custom data         
/*               
'''' as  AssistanceMobility,                  
'''' as  AssistanceMedication,                  
'''' as  AssistancePersonal,                  
'''' as  AssistanceHousehold,                  
'''' as  AssistanceCommunity,                  
--Custom Data          
*/              
                                 
'''' as CreatedBy,                      
getdate() as CreatedDate,                      
'''' as ModifiedBy,                      
getdate() as ModifiedDate     
from systemconfigurations s left outer join CustomDDStateReporting C                                                                           
on s.Databaseversion = -1    
END                                       
end try                                                  
                                                                                           
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDDStateReportingStandardInitialization'')                                                                                 
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
