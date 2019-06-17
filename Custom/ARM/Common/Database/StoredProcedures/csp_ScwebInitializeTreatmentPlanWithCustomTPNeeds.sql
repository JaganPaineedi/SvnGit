    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ScwebInitializeTreatmentPlanWithCustomTPNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE csp_ScwebInitializeTreatmentPlanWithCustomTPNeeds
GO
    
CREATE PROCEDURE [DBO].[csp_ScwebInitializeTreatmentPlanWithCustomTPNeeds]   
 @ClientID int ,                
 @StaffID int ,
@CurrentDocumentVersionId int        
 AS              
BEGIN            
/*********************************************************************/             
                                                                                 
/* Stored Procedure: [csp_ScwebInitializeTreatmentPlanWithCustomTPNeeds]       */            
                                                                         
/* Creation Date:  17/8/2011                                       */            
                                                                                  
/* Purpose: To Initialize Tables Used in the Harbor Treatment Plan WITH CustomTPNeeds*/                                                                                  
          
/* Input Parameters: @ClientID ,@StaffID          */            
                                                                                
/* Output Parameters:   Table Assoicated with the Harbor treatment */           
                                                                                   
                                                                                 
/*       Author          Purpose            Date  */                                                                                    
/*       Maninder        Creation   17/8/2011 */   
    
-- Feb 26, 2018    Vijeta        Converted ssp_ScwebInitializeTreatmentPlanWithCustomTPNeeds to csp_ScwebInitializeTreatmentPlanWithCustomTPNeeds for 	A Renewed Mind - Support #814                                                                             
/*********************************************************************/            
            
  DECLARE @DocumentVersionId int      
  Declare @DocumentCodeId int   
     
BEGIN TRY              
---------CustomTreatMentPlan                            
    set @DocumentVersionId= (SELECT TOP (1) CurrentDocumentVersionId FROM Documents where ClientId=@ClientID AND Status =22 AND DocumentCodeId in (1483,1486) AND ISNULL(RecordDeleted, 'N') = 'N' order by ModifiedDate desc)                     
   
IF(exists(SELECT              
     1              
   FROM CustomTreatmentPlans CTP,Documents D                                        
   -- before modify where C.DocumentId=D.DocumentId and D.ClientId=@ClientID                                            
   WHERE CTP.DocumentVersionId =D.CurrentDocumentVersionId AND D.DocumentCodeId in (1483,1486) AND D.ClientId=@ClientID                                            
   AND D.Status=22 AND IsNull(CTP.RecordDeleted,'N')='N' AND IsNull(D.RecordDeleted,'N')='N'))                 
                                        
BEGIN                              
   ---------------CustomTPNeeds              
  SELECT  Distinct             
  CTN.NeedId                
      ,CTN.CreatedBy                
      ,CTN.CreatedDate                
      ,CTN.ModifiedBy                
      ,CTN.ModifiedDate                
      ,CTN.RecordDeleted                
      ,CTN.DeletedDate                
      ,CTN.DeletedBy                
      ,CTN.ClientId                
      ,CTN.NeedText             
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CTN.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,'N')<>'Y')>=1 then 'Y' else 'N' end) as LinkedInDb              
      ,'N' as LinkedInSession             
    FROM CustomTPNeeds CTN 
    LEFT JOIN CustomTPGoalNeeds CTGN  on CTGN.NeedId=CTN.NeedId 
    LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId  
    WHERE CTN.ClientId=@ClientId 
    AND CTG.DocumentVersionId in (@DocumentVersionId,@CurrentDocumentVersionId)
    AND ISNULL(CTG.RecordDeleted,'N')='N'
    AND ISNULL(CTN.RecordDeleted,'N')='N'               
    AND ISNULL(CTGN.RecordDeleted,'N')='N'         
    
    --CustomTPQuickObjectives      
   select [TPQuickId]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
      ,[StaffId]          
      ,[TPElementTitle]          
      ,[TPElementOrder]          
      ,[TPElementText]          
  FROM CustomTPQuickObjectives WHERE StaffId=@StaffID    AND ISNULL(RecordDeleted,'N')='N'       
                
 ---------CustomTPGoalNeeds              
              
  SELECT                
      CTGN.TPGoalNeeds              
     ,CTGN.CreatedBy              
     ,CTGN.CreatedDate              
     ,CTGN.ModifiedBy              
     ,CTGN.ModifiedDate              
     ,CTGN.RecordDeleted              
     ,CTGN.DeletedDate              
     ,CTGN.DeletedBy              
     ,CTGN.TPGoalId              
     ,CTGN.NeedId              
     ,CTGN.DateNeedAddedToPlan            
     --,CTN.NeedText as NeedText             
   FROM CustomTPGoalNeeds CTGN               
   LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId  
   LEFT JOIN CustomTPNeeds CTN on CTGN.NeedId=CTN.NeedId   
   WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTG.RecordDeleted,'N')='N'  and ClientId=@ClientId AND ISNULL(CTN.RecordDeleted,'N')='N'               
    AND ISNULL(CTGN.RecordDeleted,'N')='N'                         
              
              
--------------CustomTPObjectives              
              
 SELECT               
      CTO.TPObjectiveId              
     ,CTO.CreatedBy              
     ,CTO.CreatedDate              
     ,CTO.ModifiedBy              
     ,CTO.ModifiedDate              
  ,CTO.RecordDeleted              
     ,CTO.DeletedDate              
     ,CTO.DeletedBy              
     ,CTO.TPGoalId              
     ,CTO.ObjectiveNumber              
     ,CTO.ObjectiveText              
     ,CTO.TargetDate             
     ,CTO.DeletionNotAllowed             
    FROM CustomTPObjectives CTO              
    LEFT JOIN CustomTPGoals CTG on CTO.TPGoalId=CTG.TPGoalId              
    WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTO.RecordDeleted,'N')='N'   AND ISNULL(CTG.RecordDeleted,'N')='N'            
              
--------------CustomTPServices              
              
 SELECT            
      CTS.TPServiceId              
     ,CTS.CreatedBy              
     ,CTS.CreatedDate              
     ,CTS.ModifiedBy              
   ,CTS.ModifiedDate              
     ,CTS.RecordDeleted              
     ,CTS.DeletedDate              
     ,CTS.DeletedBy              
     ,CTS.TPGoalId              
     ,CTS.ServiceNumber              
     ,CTS.AuthorizationCodeId              
     ,CTS.Units              
     ,CTS.FrequencyType              
     ,CTS.DeletionNotAllowed            
     ,(select GC.codename from GlobalCodes GC where exists (select Unittype from AuthorizationCodes where   GC.GlobalCodeId=UnitType and AuthorizationCodeId=CTS.AuthorizationCodeId)) as  UnitType              
   FROM CustomTPServices CTS              
   LEFT JOIN CustomTPGoals CTG ON CTS.TPGoalId= CTG.TPGoalId         
   LEFT JOIN AuthorizationCodes AC ON CTS.AuthorizationCodeId=AC.AuthorizationCodeId               
   WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTS.RecordDeleted,'N')='N'              
   AND ISNULL(CTG.RecordDeleted,'N')='N' AND ISNULL(AC.RecordDeleted,'N')='N'  and isnull(AC.Active,'N')='Y'                  
          
                 
END                                        
 ELSE                                        
BEGIN                
                   
                                 
---------------CustomTPNeeds              
  SELECT Distinct                 
       CTN.NeedId                  
      ,CTN.CreatedBy                  
      ,CTN.CreatedDate                  
      ,CTN.ModifiedBy                  
      ,CTN.ModifiedDate                  
    ,CTN.RecordDeleted                  
      ,CTN.DeletedDate                  
      ,CTN.DeletedBy                  
      ,CTN.ClientId                  
      ,CTN.NeedText                
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CTN.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,'N')<>'Y')>=1 then 'Y' else 'N' end) as LinkedInDb                
      ,'N' as LinkedInSession    
       FROM CustomTPNeeds CTN   
    LEFT JOIN CustomTPGoalNeeds CTGN  on CTGN.NeedId=CTN.NeedId   
    LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId    
    WHERE CTN.ClientId=@ClientId   
    AND CTG.DocumentVersionId in (@DocumentVersionId, @CurrentDocumentVersionId)
    AND ISNULL(CTG.RecordDeleted,'N')='N'  
    AND ISNULL(CTN.RecordDeleted,'N')='N'                 
    AND ISNULL(CTGN.RecordDeleted,'N')='N'                
         
   --CustomTPQuickObjectives      
   select [TPQuickId]     
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
      ,[StaffId]          
      ,[TPElementTitle]          
      ,[TPElementOrder]          
      ,[TPElementText]          
  FROM CustomTPQuickObjectives WHERE StaffId=@StaffID     AND ISNULL(RecordDeleted,'N')='N'       
                 
                                    
                          
END               
END TRY              
BEGIN CATCH              
 DECLARE @Error varchar(8000)                                                             
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ScwebInitializeTreatmentPlanWithCustomTPNeeds')       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                        
 RAISERROR                                                                                           
 (                                                             
   @Error, -- Message text.                                                                                          
   16, -- Severity.                                                                                          
   1 -- State.                                                                                          
  );               
END CATCH                                     
                                        
               
 --NEED              
               
               
               
END   