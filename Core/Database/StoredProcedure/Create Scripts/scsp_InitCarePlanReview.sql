
/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanReview]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitCarePlanReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_InitCarePlanReview]
GO


/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanReview]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanReview]    Script Date: 03/07/2015 08:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[scsp_InitCarePlanReview]
 @ClientID INT,                              
 @StaffID INT,                            
 @CustomParameters XML 
AS
/**********************************************************************/                                                                                        
 /* Stored Procedure: [csp_InitCarePlanInitial]						  */                                                                               
 /* Creation Date:  03/07/2015                                       */                                                                                        
 /* Purpose: To Initialize											  */                                                                                       
 /* Input Parameters:   @DocumentVersionId						      */                                                                                      
 /* Output Parameters:											      */                                                                                        
 /* Return:															  */                                                                                        
 /* Called By: Care Plan Documents				  */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /* Updates:                                                          */                                                                                        
 /* Date   Author   Purpose											  */    
 /* 03/07/2015     Veena S Mani       Created- Initialise table Field of  CarePlans        */ 
 /*03/22/2017        Neelima   Why: created the scsp scsp_InitCarePlanReviewGetLatestCarePlanGoals call to write custom logic for CCC based on the goal and objectives end dates CCC-Customizations #55 */	 
/*******************************************************************************************************/
BEGIN 
BEGIN TRY
  
  	Declare  @ReviewFromDate datetime,@ReviewToDate datetime;
  	
    SET @ReviewFromDate = @CustomParameters.value('(/Root/Parameters/@ReviewFromDate)[1]', 'datetime');
	SET @ReviewToDate = @CustomParameters.value('(/Root/Parameters/@ReviewToDate)[1]', 'datetime');
	
  	DECLARE @LatestCarePlanDocumentVersionID INT, @ReviewPeriodTo DATE, @ReviewPeriodFrom DATE;
	SELECT TOP 1 @LatestCarePlanDocumentVersionID = CurrentDocumentVersionId
	--, @EffectiveDate = Doc.EffectiveDate
	--		,@EffectiveDateDifference = DATEDIFF(YEAR,Doc.EffectiveDate,GETDATE())
		FROM Documents Doc 
		WHERE EXISTS(SELECT 1 FROM DocumentCarePlans C WHERE C.DocumentVersionId = Doc.CurrentDocumentVersionId
		AND ISNULL(C.RecordDeleted,'N')='N')
		/*AND Doc.ClientId=@ClientID AND DocumentCodeId = @DocumentCodeID AND Doc.Status = 22 */
		AND Doc.ClientId=@ClientID AND DocumentCodeId 
		--IN (1501,1502) 
		IN (1620) AND Doc.Status = 22  
		AND ISNULL(Doc.RecordDeleted,'N')='N'
		/*Vikas Kashyap : Changes w.r.t. Task#993*/
		--AND DOC.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101)) 
		--AND CONVERT(DATE,DOC.EffectiveDate) <= CONVERT(Date,GETDATE()) 
		AND ((CONVERT(DATE,Doc.EffectiveDate )<= CONVERT(DATE,@ReviewToDate )) and (CONVERT(DATE,Doc.EffectiveDate )>= CONVERT(DATE,@ReviewFromDate )))
		ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC
	/***************************************************************/
	
	
	/***************************************************************/
		
		SELECT TOP 1 Placeholder.TableName
						,ISNULL(CSLD.DocumentVersionId,-1) AS DocumentVersionId		       									
						--,CASE 
						--	WHEN @DocumentCodeID = 1501 THEN -- When a ‘Initial/Annual’ plan is created
						--		CASE WHEN @LatestCarePlanDocumentVersionID IS NULL
						--			THEN 'IN' -- and the member does NOT have a previous signed care plan in the system for the current episode.
						--			ELSE 'AN' -- and the member DOES have a previous signed care plan in the system for the current episode.
						--		END
						--	WHEN @DocumentCodeID = 1502 THEN --When an ‘Addendum’ plan is created
						--		'AD' 
						--	WHEN @DocumentCodeID = 1503 THEN --When a ‘Review’ plan is created
						,'RE' As CarePlanType	
						--,@Adult AS [Adult]      
						--,@ClientFirstName AS NameInGoalDescriptions
						,CSLD.[Strengths]      
						--,@NeedNames AS 'Needs'
						,CSLD.[Abilities]      
						,CSLD.[Preferences]      
						,CSLD.[ReductionInSymptoms]      
						,CSLD.[ReductionInSymptomsDescription]      
						,CSLD.[AttainmentOfHigherFunctioning]      
						,CSLD.[AttainmentOfHigherFunctioningDescription]      
						,CSLD.[TreatmentNotNecessary]      
						,CSLD.[TreatmentNotNecessaryDescription]      
						,CSLD.[OtherTransitionCriteria]      
						,CSLD.[OtherTransitionCriteriaDescription]      
						,CSLD.[EstimatedDischargeDate]      
						--,CSLD.[OverallProgress]      
						--,CSLD.[CILASupportLevel]      
						--,CSLD.[CILAHours]      
						--,CSLD.[CILATimeAloneCircumstances]      
						,CSLD.CarePlanReviewComments AS 'Comments'  
						,CSLD.SupportsInvolvement    
						 ,CSLD.CarePlanAddendumInfo
						 ,CSLD.LevelOfCare
					FROM (SELECT 'DocumentCarePlans' AS TableName) AS Placeholder        
					LEFT JOIN DocumentCarePlans CSLD ON ( CSLD.DocumentVersionId  = @LatestCarePlanDocumentVersionID        
					AND ISNULL(CSLD.RecordDeleted,'N') = 'N' )
					
	IF EXISTS(SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitCarePlanReviewGetLatestCarePlanGoals]') AND type in (N'P', N'PC'))
	  BEGIN
		EXEC scsp_InitCarePlanReviewGetLatestCarePlanGoals @LatestCarePlanDocumentVersionID
	  END
	  ELSE
	  BEGIN		
			SELECT  Placeholder.TableName  
      ,CONVERT(int,'-' + CONVERT(varchar(50),row_number() over (ORDER BY CO.CarePlanDomainObjectiveId))) AS   CarePlanReviewId                         
      ,CDG.[DocumentVersionId]  
      ,CDG.[CarePlanDomainGoalId]  
      ,CDG.[GoalNumber]  
      ,CDG.[ClientGoal]  as MemberGoalVision
      ,CDO.[CarePlanDomainObjectiveId]  
      ,CDO.[ObjectiveNumber]  
      ,CDO.[StaffSupports]  
      ,CDO.[MemberActions]  
      ,CDO.[UseOfNaturalSupports]  
      --,CDO.ProgressTowardsObjective 
     -- ,CDO.[ObjectiveReview]   
      ,ISNULL(CG.GoalDescription,'') + ISNULL(CDG.AssociatedGoalDescription,'') AS GoalDescription 
      
      --,CDG.GoalId  
      ,ISNULL(CO.ObjectiveDescription,'')+ISNULL( CDO.AssociatedObjectiveDescription,'') AS ObjectiveDescription
      --,CG.GoalDescription AS GoalDescription  
      --,CDG.GoalId  
      --,CO.ObjectiveDescription  
      --,CDO.ObjectiveId  
      ,CONVERT(int,REPLACE((LTRIM(RTRIM(REPLACE(LTRIM(RTRIM(CDO.[ObjectiveNumber])),'.','')))),' ','')) AS ObjectiveNumberId,
	   Convert(VARCHAR(10),@ReviewPeriodFrom,101) AS ReviewPeriodFrom,
	  -- Convert(VARCHAR(10),@ReviewPeriodTo,101) AS ReviewPeriodTo
	  --Convert(VARCHAR(10),getdate(),101) AS ReviewPeriodFrom,
      Convert(VARCHAR(10),getdate(),101) AS ReviewPeriodTo
     FROM   
     (SELECT 'DocumentCarePlanReviews' AS TableName) AS Placeholder   
  LEFT JOIN CarePlanGoals CDG ON(ISNULL(CDG.RecordDeleted,'N')='N') AND CDG.DocumentVersionId =@LatestCarePlanDocumentVersionID  
  LEFT JOIN CarePlanDomainGoals CG ON CG.CarePlanDomainGoalId = CDG.CarePlanDomainGoalId AND ISNULL(CG.RecordDeleted,'N')='N'  
  LEFT JOIN CarePlanObjectives CDO ON CDO.CarePlanGoalId = CDG.CarePlanGoalId AND ISNULL(CDO.RecordDeleted,'N')='N'  
  LEFT JOIN CarePlanDomainObjectives CO ON CO.CarePlanDomainObjectiveId = CDO.CarePlanDomainObjectiveId AND ISNULL(CO.RecordDeleted,'N')='N'
  END
  
  SELECT  Placeholder.TableName  
      ,-1  AS   CarePlanReviewPeriodId                         
     
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedDate
,DeletedBy
,DocumentVersionId
,ReviewPeriodFromDate
,ReviewPeriodToDate
     FROM   
     (SELECT 'DocumentCarePlanReviewPeriods' AS TableName) AS Placeholder   
  LEFT JOIN DocumentCarePlanReviewPeriods CPRP ON(ISNULL(CPRP.RecordDeleted,'N')='N') AND CPRP.DocumentVersionId =@LatestCarePlanDocumentVersionID  
 
  
END TRY
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_InitCarePlanReview')                                                                                                       
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
