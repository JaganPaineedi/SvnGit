/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentDischarges]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentDischarges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE  [dbo].[csp_SCGetCustomDocumentDischarges]  
(  
 @DocumentVersionId INT  
)          
AS    

/*********************************************************************/                        
/* Stored Procedure: dbo.csp_SCGetCustomDocumentDischarges                */               
/* Copyright: 2011 Streamline SmartCare*/                        
/* Creation Date:  29/04/2011                                    */                        
/* Purpose: Gets Data for CustomDocumentDischarges*/                       
/* Input Parameters: DocumentVersionID */                      
/* Output Parameters:                                */                        
/* Return:   */                        
/* Calls:                                                            */                        
/* Data Modifications:                                               */                        
/*  Updates:                                                          */                        
/*  Date                  Author                  Purpose                                    */                        
/*  29/04/2011            Pradeep                 Created                         */
/*  09/28/2011            Rohit Katoch            Modified - added column ''ReasonForDischargeCode''      */ 
/*  25/04/2013            Aravinda halemane       Modified - added columns ''DASTScore'', ''MASTScore'',''InitialLevelofCare'', ''DischargeLevelofCare'' */                                                              
/*********************************************************************/                  
BEGIN                      
 SELECT [DocumentVersionId],    
  [CreatedBy],    
  [CreatedDate],     
  [ModifiedBy],     
  [ModifiedDate],    
  [RecordDeleted],    
  [DeletedBy],    
  [DeletedDate], 
  [ClientAddress], 
  [HomePhone],  
  [ParentGuardianName],  
  [AdmissionDate],  
  [LastServiceDate],  
  [DischargeDate],  
  [DischargeTransitionCriteria],  
  [ServicesParticpated],  
  [MedicationsPrescribed],  
  [PresentingProblem],  
  [ReasonForDischarge],
  [ReasonForDischargeCode],  
  [ClientParticpation],  
  [ClientStatusLastContact],  
  [ClientStatusComment],  
  [ReferralPreference1],  
  [ReferralPreference2],  
  [ReferralPreference3],  
  [ReferralPreferenceOther],  
  [ReferralPreferenceComment],  
  [InvoluntaryTermination],  
  [ClientInformedRightAppeal],  
  [StaffMemberContact72Hours],
  [DASTScore],
  [MASTScore],
  [InitialLevelofCare],
  [DischargeLevelofCare]    
    FROM [CustomDocumentDischarges]   
 WHERE     (isnull(RecordDeleted,''N'')=''N'') AND (DocumentVersionId = @DocumentVersionId)   
   
 SELECT   
  [DischargeGoalId],
  [DocumentVersionId],    
  [CreatedBy],    
  [CreatedDate],     
  [ModifiedBy],     
  [ModifiedDate],    
  [RecordDeleted],    
  [DeletedBy],    
  [DeletedDate],  
  [GoalNumber],  
  [GoalText],  
  [GoalRatingProgress]  
  FROM [CustomDocumentDischargeGoals]    
  WHERE     (isnull(RecordDeleted,''N'')=''N'') AND (DocumentVersionId = @DocumentVersionId) order by [GoalNumber]      
             
  --Checking For Errors              
 If (@@error!=0)              
 BEGIN              
  RAISERROR  20006   ''csp_SCGetCustomDocumentDischarges: An Error Occured''               
  Return              
 END                      
END
' 
END
GO
