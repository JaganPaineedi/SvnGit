/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanSummaryInformation]    Script Date: 01/12/2015 17:44:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RdlCarePlanSummaryInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RdlCarePlanSummaryInformation] --180
GO

/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanSummaryInformation]    Script Date: 01/12/2015 17:44:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************************************************************************/                                                                
/* Stored Procedure: ssp_RdlCarePlanSummaryInformation  6832   */                                                       
/*                     */                                                                
/* Creation Date:  19 Dec 2011                          */                                                                
/*                              */                                                                
/* Purpose: Gets Data for ssp_RdlCarePlanSummaryInformation    */                                                               
/* Input Parameters: DocumentVersionId         */                                                              
/* Output Parameters:             */                                                                
/* Purpose: Use For Rdl Report           */                                                      
/* Calls:                */                                                                
/*                  */                                                                
/* Author: Rohit Katoch             */                                                                
/* Updates:                */                                                                      
/* Date           Author                    Purpose      */                                             
/* 20-June-2012   Vikas Kashyap             Add GlobalCode Function  */       
/* 26-Nov-2012    RaghuM                    These columns are no more required to be shown in RDL as per issue #7 Care/Plan Review Changes In Development Phase4(Offshore) */        
/* 11-Dec-2012    Vikas Kashyap             What:Added New Column CarePlanAddendumInfo*/
/*											Why:Ref Task#2407 Threshold Bugs/Features*/
/* 20-March-2013    Vikas Kashyap           What:Added New Column LevelOfCare*/
/*											Why:Ref Task#23 Threshold Development Phase IV Offshore*/
/* 19 April 2013   Bernardin                Added column CarePlan to Show or hide the rdl*/
/* 26 Dec 2014     Aravind                  Modified As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans
				                            Valley - Customizations  
  20 Dec 2018	  Kaushal Pandey			Added a Temporary column 'LABELLEVELOFCAREFIELD' to show the label based on "Overridetext" which comes from "ScreenLabels" table.
											If value is null show default value "'MH Assessment Level of Care:"
											Label comes under Transition/Level of Care/Discharge Plan' section of 'General' tab Ref :#17 Porter Starke-Enhancements Go Live.
				                            */
				                            
/************************************************************************/                                   

CREATE PROCEDURE [dbo].[ssp_RdlCarePlanSummaryInformation]                                               
 (      
  @DocumentVersionId AS INT        
 )          
AS            
BEGIN   

DECLARE @DocumentCodeId INT
DECLARE @ScreenId INT
DECLARE @Overridetext VARCHAR(500)
Declare @TabControlId varchar(500)
Declare @LabelControlId varchar(500)

Set @TabControlId = 'CarePlanTabPageInstance_C0'
Set @LabelControlId = 'span_MHLoc'

	SELECT TOP 1 @DocumentCodeId = DocumentCodeId 
	FROM Documents Doc		 
	WHERE Doc.CurrentDocumentVersionId = @DocumentVersionId 
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'			
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
	
SELECT TOP 1 @ScreenId = ScreenId FROM Screens WHERE DocumentCodeId = @DocumentCodeId 
			
SELECT @Overridetext = dbo.ssf_GetOverriddenTextFromScreenLabels(@ScreenId,@TabControlId,@LabelControlId)

         
 Select                 
 DCP.[DocumentVersionId]                
 ,DCP.[CreatedBy]                
 ,DCP.[CreatedDate]                
 ,DCP.[ModifiedBy]                
 ,DCP.[ModifiedDate]                
 ,DCP.[RecordDeleted]                
 ,DCP.[DeletedDate]                
 ,DCP.[DeletedBy]                
 ,CASE DCP.[CarePlanType]                 
 WHEN 'AD' THEN 'Addendum'
 ELSE 'Care Plan'
 END AS [CarePlanType]                 
 --,DCP.[Adult]                
 ,DCP.[NameInGoalDescriptions]                
 ,DCP.[Strengths]                
 --,DCP.[Needs]                
 ,DCP.[Abilities]                
 ,DCP.[Preferences]
 ,DCP.Barriers                
 ,DCP.[ReductionInSymptoms]                
 ,DCP.[ReductionInSymptomsDescription]                
 ,DCP.[AttainmentOfHigherFunctioning]                
 ,DCP.[AttainmentOfHigherFunctioningDescription]                
 ,DCP.[TreatmentNotNecessary]                
 ,DCP.[TreatmentNotNecessaryDescription]                
 ,DCP.[OtherTransitionCriteria]                
 ,DCP.[OtherTransitionCriteriaDescription]                
 ,CONVERT(VARCHAR(10),DCP.[EstimatedDischargeDate],101) AS EstimatedDischargeDate                
 --,DCP.[OverallProgress]                
 --,dbo.csf_GetGlobalCodeNameById(DCP.[CILASupportLevel]) AS CILASupportLevel                
 --,DCP.[CILAHours]                
 --,DCP.[CILATimeAloneCircumstances]        
 --Commented as per new requirement, these columns are no more required to be shown in RDL      
 --,DCP.[SupportsFamilyChoseNotToCome]          
 --,DCP.[SupportsMemberDeclined]                
 --,DCP.[SupportsNoFamilyMember]                
 --,DCP.[SupportsFamilyUnableToAttend]             
 ,[GC].CodeName AS SupportsInvolvement   
 --,DCP.[Comments]      
 ,DCP.CarePlanAddendumInfo
 ,DCP.LevelOfCare
 ,DCP.ASAMLevelOfCare
 ,DCP.MHAssessmentLevelOfCare 
 ,DCP.[CarePlanType] AS CarePlan       
 ,CASE WHEN (@Overridetext IS NULL) THEN 'MH Assessment Level of Care:' ELSE @Overridetext END As LABELLEVELOFCAREFIELD   
 FROM [DocumentCarePlans] DCP LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = DCP.SupportsInvolvement                    
 WHERE ISNull(DCP.RecordDeleted,'N')='N' AND DCP.DocumentVersionId=@DocumentVersionId                 
         
         
END

GO

--select * from DocumentCarePlans


