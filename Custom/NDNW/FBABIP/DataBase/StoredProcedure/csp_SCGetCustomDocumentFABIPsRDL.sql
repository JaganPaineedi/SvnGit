/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentFABIPsRDL]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentFABIPsRDL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentFABIPsRDL]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentFABIPsRDL]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[csp_SCGetCustomDocumentFABIPsRDL]  
@DocumentVersionId INT          
AS        
/*****************************************************************************/                                                  
/* Stored Procedure:[csp_SCGetCustomDocumentFABIPsRDL]                   */                                         
/* Copyright: 2011 Streamline Healthcare Solutions                          */       
/* Author: Devi Dayal                                                   */                                                 
/* Creation Date:  3/1/2012                                                 */                                                  
/* Purpose: Gets Data for CustomDocumentFABIPs In RDL                     */                                                 
/* Input Parameters: @DocumentVersionId                                     */                                                
/* Output Parameters:None                                                   */                                                  
/* Return:                                                                  */                                                  
/* Calls:                                                                   */      
/* Called From:                                                             */                                                  
/* Data Modifications:                                                      */                                                  
/*-------------Modification History--------------------------               */  
/*-------Date----    Author   ----    Purpose   ----------------------------*/   
/*    4/1/2012      Devi Dayal         Created                                */   
/* 25-SEP-2012   Jagdeep               Modify as per task #2023-FBA/BIP - Document Issues- added @CheckTargetBehavior2,@CheckTargetBehavior3,@CheckTargetBehavior4,@CheckTargetBehavior5 */ 
/****************************************************************************/             
BEGIN     
  
BEGIN TRY    


declare @QuarterlyStatusId int
declare @CheckTargetBehavior2 char(1)
declare @CheckTargetBehavior3 char(1)
declare @CheckTargetBehavior4 char(1)
declare @CheckTargetBehavior5 char(1)

set @CheckTargetBehavior2='N'
set @CheckTargetBehavior3='N'
set @CheckTargetBehavior4='N'
set @CheckTargetBehavior5='N'

select @QuarterlyStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTYPE' and GlobalCodes.Code='QUARTERLY'

 
 SELECT  @CheckTargetBehavior2='Y'
 FROM CustomDocumentFABIPs CDF  
 INNER JOIN DocumentVersions DV on DV.DocumentVersionId=CDF.DocumentVersionId AND (ISNULL(DV.RecordDeleted,'N')='N')      
 INNER JOIN Documents AS D ON D.DocumentId = DV.DocumentId AND ISNULL(D.RecordDeleted,'N')='N'  
 WHERE CDF.DocumentVersionId=@DocumentVersionId AND (ISNULL(CDF.RecordDeleted, 'N') = 'N')    
 AND isnull(CDF.TargetBehavior2,'')='' AND isnull(dbo.csf_GetGlobalCodeNameById([Status2]),'N/A')='N/A'
 AND isnull(CDF.FrequencyIntensityDuration2,'')=''  
 AND isnull(CDF.Settings2,'')=''  
 AND isnull(CDF.Antecedent2,'')=''  
 AND isnull(CDF.ConsequenceThatReinforcesBehavior2,'')=''  
 AND isnull(CDF.EnvironmentalConditions2,'')=''  
 AND isnull(CDF.HypothesisOfBehavioralFunction2,'')=''  
 AND isnull(CDF.ExpectedBehaviorChanges2,'')=''  
 AND isnull(CDF.MethodsOfOutcomeMeasurement2,'')=''  
 AND isnull(CDF.ScheduleOfOutcomeReview2,'')=''  
 AND isnull(CDF.QuarterlyReview2,'')=''  

SELECT  @CheckTargetBehavior3='Y'
 FROM CustomDocumentFABIPs CDF  
 INNER JOIN DocumentVersions DV on DV.DocumentVersionId=CDF.DocumentVersionId AND (ISNULL(DV.RecordDeleted,'N')='N')      
 INNER JOIN Documents AS D ON D.DocumentId = DV.DocumentId AND ISNULL(D.RecordDeleted,'N')='N'  
 WHERE CDF.DocumentVersionId=@DocumentVersionId AND (ISNULL(CDF.RecordDeleted, 'N') = 'N')    
 AND isnull(CDF.TargetBehavior3,'')='' AND isnull(dbo.csf_GetGlobalCodeNameById([Status3]),'N/A')='N/A'
 AND isnull(CDF.FrequencyIntensityDuration3,'')=''  
 AND isnull(CDF.Settings3,'')=''  
 AND isnull(CDF.Antecedent3,'')=''  
 AND isnull(CDF.ConsequenceThatReinforcesBehavior3,'')=''  
 AND isnull(CDF.EnvironmentalConditions3,'')=''  
 AND isnull(CDF.HypothesisOfBehavioralFunction3,'')=''  
 AND isnull(CDF.ExpectedBehaviorChanges3,'')=''  
 AND isnull(CDF.MethodsOfOutcomeMeasurement3,'')=''  
 AND isnull(CDF.ScheduleOfOutcomeReview3,'')=''  
 AND isnull(CDF.QuarterlyReview3,'')=''  
 
 SELECT  @CheckTargetBehavior4='Y'
 FROM CustomDocumentFABIPs CDF  
 INNER JOIN DocumentVersions DV on DV.DocumentVersionId=CDF.DocumentVersionId AND (ISNULL(DV.RecordDeleted,'N')='N')      
 INNER JOIN Documents AS D ON D.DocumentId = DV.DocumentId AND ISNULL(D.RecordDeleted,'N')='N'  
 WHERE CDF.DocumentVersionId=@DocumentVersionId AND (ISNULL(CDF.RecordDeleted, 'N') = 'N')    
 AND isnull(CDF.TargetBehavior4,'')='' AND isnull(dbo.csf_GetGlobalCodeNameById([Status4]),'N/A')='N/A'
 AND isnull(CDF.FrequencyIntensityDuration4,'')=''  
 AND isnull(CDF.Settings4,'')=''  
 AND isnull(CDF.Antecedent4,'')=''  
 AND isnull(CDF.ConsequenceThatReinforcesBehavior4,'')=''  
 AND isnull(CDF.EnvironmentalConditions4,'')=''  
 AND isnull(CDF.HypothesisOfBehavioralFunction4,'')=''  
 AND isnull(CDF.ExpectedBehaviorChanges4,'')=''  
 AND isnull(CDF.MethodsOfOutcomeMeasurement4,'')=''  
 AND isnull(CDF.ScheduleOfOutcomeReview4,'')=''  
 AND isnull(CDF.QuarterlyReview4,'')=''  
 
 SELECT  @CheckTargetBehavior5='Y'
 FROM CustomDocumentFABIPs CDF  
 INNER JOIN DocumentVersions DV on DV.DocumentVersionId=CDF.DocumentVersionId AND (ISNULL(DV.RecordDeleted,'N')='N')      
 INNER JOIN Documents AS D ON D.DocumentId = DV.DocumentId AND ISNULL(D.RecordDeleted,'N')='N'  
 WHERE CDF.DocumentVersionId=@DocumentVersionId AND (ISNULL(CDF.RecordDeleted, 'N') = 'N')    
 AND isnull(CDF.TargetBehavior5,'')='' AND isnull(dbo.csf_GetGlobalCodeNameById([Status5]),'N/A')='N/A'
 AND isnull(CDF.FrequencyIntensityDuration5,'')=''  
 AND isnull(CDF.Settings5,'')=''  
 AND isnull(CDF.Antecedent5,'')=''  
 AND isnull(CDF.ConsequenceThatReinforcesBehavior5,'')=''  
 AND isnull(CDF.EnvironmentalConditions5,'')=''  
 AND isnull(CDF.HypothesisOfBehavioralFunction5,'')=''  
 AND isnull(CDF.ExpectedBehaviorChanges5,'')=''  
 AND isnull(CDF.MethodsOfOutcomeMeasurement5,'')=''  
 AND isnull(CDF.ScheduleOfOutcomeReview5,'')=''  
 AND isnull(CDF.QuarterlyReview5,'')=''  




SELECT  
  
D.ClientId         
,CONVERT(VARCHAR(10),D.EffectiveDate,110) as EffectiveDate         
,C.LastName+ ', ' + C.FirstName  as ClientName          
,ST.LastName + ', ' + ST.FirstName as ClinicianName   
,(Select OrganizationName from SystemConfigurations) as OrganizationName    
,CDF.DocumentVersionId  
,CDF.CreatedBy  
,CDF.CreatedDate  
,CDF.ModifiedBy  
,CDF.ModifiedDate  
,CDF.RecordDeleted  
,CDF.DeletedBy  
,CDF.DeletedDate  
,isnull(dbo.csf_GetGlobalCodeNameById([Type]),'N/A') AS 'Type'
,CDF.StaffParticipants  
,CDF.TargetBehavior1  
,isnull(dbo.csf_GetGlobalCodeNameById([Status1]),'N/A') AS 'Status1'
,CDF.FrequencyIntensityDuration1  
,CDF.Settings1  
,CDF.Antecedent1  
,CDF.ConsequenceThatReinforcesBehavior1  
,CDF.EnvironmentalConditions1  
,CDF.HypothesisOfBehavioralFunction1  
,CDF.ExpectedBehaviorChanges1  
,CDF.MethodsOfOutcomeMeasurement1  
,CDF.ScheduleOfOutcomeReview1  
,CDF.QuarterlyReview1  
,CDF.TargetBehavior2  
,isnull(dbo.csf_GetGlobalCodeNameById([Status2]),'N/A') AS 'Status2'
,CDF.FrequencyIntensityDuration2  
,CDF.Settings2  
,CDF.Antecedent2  
,CDF.ConsequenceThatReinforcesBehavior2  
,CDF.EnvironmentalConditions2  
,CDF.HypothesisOfBehavioralFunction2  
,CDF.ExpectedBehaviorChanges2  
,CDF.MethodsOfOutcomeMeasurement2  
,CDF.ScheduleOfOutcomeReview2  
,CDF.QuarterlyReview2  
,CDF.TargetBehavior3  
,isnull(dbo.csf_GetGlobalCodeNameById([Status3]),'N/A') AS 'Status3'
,CDF.FrequencyIntensityDuration3  
,CDF.Settings3  
,CDF.Antecedent3  
,CDF.ConsequenceThatReinforcesBehavior3  
,CDF.EnvironmentalConditions3  
,CDF.HypothesisOfBehavioralFunction3  
,CDF.ExpectedBehaviorChanges3  
,CDF.MethodsOfOutcomeMeasurement3  
,CDF.ScheduleOfOutcomeReview3  
,CDF.QuarterlyReview3  
,CDF.ConsequenceThatReinforcesBehavior4  
,CDF.EnvironmentalConditions4  
,CDF.HypothesisOfBehavioralFunction4  
,CDF.ExpectedBehaviorChanges4  
,CDF.MethodsOfOutcomeMeasurement4  
,CDF.ScheduleOfOutcomeReview4  
,CDF.QuarterlyReview4  
,CDF.TargetBehavior4  
,isnull(dbo.csf_GetGlobalCodeNameById([Status4]),'N/A') AS 'Status4'
,CDF.FrequencyIntensityDuration4  
,CDF.Settings4  
,CDF.Antecedent4  
,CDF.TargetBehavior5  
,isnull(dbo.csf_GetGlobalCodeNameById([Status5]),'N/A') AS 'Status5'    
,CDF.FrequencyIntensityDuration5  
,CDF.Settings5  
,CDF.Antecedent5  
,CDF.ConsequenceThatReinforcesBehavior5  
,CDF.EnvironmentalConditions5  
,CDF.HypothesisOfBehavioralFunction5  
,CDF.ExpectedBehaviorChanges5  
,CDF.MethodsOfOutcomeMeasurement5  
,CDF.ScheduleOfOutcomeReview5  
,CDF.QuarterlyReview5  
,CDF.InterventionsAttempted  
,CDF.ReplacementBehaviors  
,CDF.Motivators  
,CDF.NonrestrictiveInterventions  
,CDF.RestrictiveInterventions  
,CDF.StaffResponsible  
,CDF.ReceiveCopyOfPlan  
,CDF.WhoCoordinatePlan  
,CDF.HowCoordinatePlan  
,case when CDF.UseOfManualRestraints is not null then (select top 1 CodeName from GlobalCodes where ExternalCode1=CDF.UseOfManualRestraints and category='XFABIPRESTRAINTS') else CDF.UseOfManualRestraints end as UseOfManualRestraints 
,CASE when CDF.Type=@QuarterlyStatusId then 'Y'  else 'N' end AS ShowQuaterlyReview
,@CheckTargetBehavior2 as 'CheckTargetBehavior2'
,@CheckTargetBehavior3 as 'CheckTargetBehavior3'
,@CheckTargetBehavior4 as 'CheckTargetBehavior4'
,@CheckTargetBehavior5 as 'CheckTargetBehavior5'
FROM CustomDocumentFABIPs CDF  
INNER JOIN DocumentVersions DV on DV.DocumentVersionId=CDF.DocumentVersionId AND (ISNULL(DV.RecordDeleted,'N')='N')      
INNER JOIN Documents AS D ON D.DocumentId = DV.DocumentId AND ISNULL(D.RecordDeleted,'N')='N'   
INNER JOIN Clients C ON C.ClientId=D.ClientId AND (ISNULL(C.RecordDeleted, 'N') = 'N')      
 INNER JOIN Staff ST ON ST.StaffId =D.AuthorId AND (ISNULL(ST.RecordDeleted, 'N') = 'N')         

WHERE CDF.DocumentVersionId=@DocumentVersionId AND (ISNULL(CDF.RecordDeleted, 'N') = 'N')    
  
END TRY       
  
BEGIN CATCH    
  
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCustomDocumentFABIPsRDL')                                                                                     
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
+ '*****' + Convert(varchar,ERROR_STATE())                                  
RAISERROR                                                                                     
(                                                       
@Error, -- Message text.                                                                                    
16, -- Severity.                                                                                    
1 -- State.                                                                                    
);              
                     
END CATCH        
  
END

GO


