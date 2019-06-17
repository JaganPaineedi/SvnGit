
/****** Object:  StoredProcedure [dbo].[scsp_SCGetCarePlanReview]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetCarePlanReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCGetCarePlanReview] 
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCGetCarePlanReview]    Script Date: 08/08/2014 08:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[scsp_SCGetCarePlanReview]    Script Date: 03/07/2015 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[scsp_SCGetCarePlanReview]
(                                
 @DocumentVersionId  int    
)                                
As    
 /*********************************************************************/                                                                                                
 /* Stored Procedure: scsp_SCGetCarePlanReview						  */                                                                                       
 /* Creation Date:  03/07/2015                                        */                                                                                                
 /* Purpose: To Initialize											  */                                                                                               
 /* Input Parameters:   @DocumentVersionId							  */                                                                                              
 /* Output Parameters:												  */                                                                                                
 /* Return:															  */                                                                                                
 /* Called By:  Care Plan Documents Review      */                                                                                      
 /* Calls:                                                             */                                                                                                
 /*                                                                    */                                                                                                
 /* Data Modifications:                                                */                                                                                                
 /*Updates:                                                            */                                                                                                
 /*Date            Author           Purpose            */            
 /*03/07/2015     Veena S Mani      Created- Get data from  CarePlan Review     */ 
 /*********************************************************************/
  BEGIN
  BEGIN Try
 SELECT   
  CSLD.[DocumentVersionId]                  
 ,CSLD.[CreatedBy]                  
 ,CSLD.[CreatedDate]                  
 ,CSLD.[ModifiedBy]                  
 ,CSLD.[ModifiedDate]                  
 ,CSLD.[RecordDeleted]                  
 ,CSLD.[DeletedDate]                  
 ,CSLD.[DeletedBy]                  
 ,CSLD.[CarePlanType]                  
 --,CSLD.[Adult]                  
 ,CSLD.[NameInGoalDescriptions]                  
 ,CSLD.[Strengths]                  
-- ,CSLD.[Needs]                  
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
 ,CSLD.[CarePlanReviewComments]    
 ,CSLD.SupportsInvolvement        
 ,CSLD.CarePlanAddendumInfo
 ,CSLD.LevelOfCare   
 FROM [DocumentCarePlans] CSLD                       
 WHERE ISNull(CSLD.RecordDeleted,'N')='N' AND CSLD.DocumentVersionId=@DocumentVersionId    
 
/***************************************************************/
    DECLARE @LatestCarePlanDocumentVersionID INT, @ReviewPeriodTo DATE, @ReviewPeriodFrom DATE;
	DECLARE 
		@DocumentCodeID INT, 
		@LatestMHADocumentVersionID INT, 
		@LatestDocumentVersionID INT, 
		@LatestCarePlanINDocumentVersionID INT,	
		@EffectiveDate DATETIME, 
		@EffectiveDateMHA DATETIME,
		@EffectiveDateDifference INT,
		@CurrentDate DateTime,
		@GenralAddendumDate DATE,
		@LatestCarePlanANDocumentVersionID INT,
		@EffectiveDateAN DATE,
		@EffectiveDateDifferenceAN INT,
		@ClientID INT;
		
Select TOP 1 @ClientID=ClientId From Documents Where CurrentDocumentVersionId=@DocumentVersionId		

SELECT TOP 1 
@LatestCarePlanDocumentVersionID = CurrentDocumentVersionId, 
@EffectiveDate = Doc.EffectiveDate,
@EffectiveDateDifference = DATEDIFF(YEAR,Doc.EffectiveDate,GETDATE())
FROM 
Documents Doc 
WHERE 
EXISTS(SELECT 1 FROM DocumentCarePlans CDCP inner join Clients C on C.ClientId=Doc.ClientId		 
		WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
		AND ISNULL(CDCP.RecordDeleted,'N')='N')
AND Doc.ClientId=@ClientID AND DocumentCodeId=1620 AND Doc.Status = 22
AND DATEDIFF(MONTH,Doc.EffectiveDate,GETDATE())  <= 6 
AND ISNULL(Doc.RecordDeleted,'N')='N'                  
AND CONVERT(DATE,DOC.EffectiveDate) <= CONVERT(DATE,GETDATE()) 
ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC

SELECT TOP 1 
@LatestCarePlanINDocumentVersionID = CurrentDocumentVersionId, 
@EffectiveDate = Doc.EffectiveDate,
@EffectiveDateDifference = DATEDIFF(YEAR,Doc.EffectiveDate,GETDATE())
FROM 
Documents Doc 
WHERE EXISTS(SELECT 1 FROM DocumentCarePlans CDCP
			inner join Clients C on C.ClientId=Doc.ClientId
			--inner join ClientEpisodes CE on CE.ClientId=C.ClientId and CONVERT(DATE,DOC.EffectiveDate)>=CONVERT(DATE,CE.RegistrationDate) 
			WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
			AND CDCP.CarePlanType='IN' AND ISNULL(CDCP.RecordDeleted,'N')='N')
AND Doc.ClientId=@ClientID AND DocumentCodeId=1620 AND Doc.Status = 22
AND DATEDIFF(MONTH,Doc.EffectiveDate,GETDATE())  <= 6 
AND ISNULL(Doc.RecordDeleted,'N')='N'                  
AND CONVERT(DATE,DOC.EffectiveDate) <= CONVERT(DATE,GETDATE()) 
ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC

SELECT TOP 1 
@LatestCarePlanANDocumentVersionID = CurrentDocumentVersionId, 
@EffectiveDateAN = Doc.EffectiveDate,
@EffectiveDateDifferenceAN = DATEDIFF(YEAR,Doc.EffectiveDate,GETDATE())
FROM Documents Doc 
WHERE EXISTS(SELECT 1 FROM DocumentCarePlans CDCP
			INNER JOIN Clients C on C.ClientId=Doc.ClientId
			--INNER JOIN ClientEpisodes CE on CE.ClientId=C.ClientId and CONVERT(DATE,DOC.EffectiveDate)>=CONVERT(DATE,CE.RegistrationDate) 
			WHERE CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId
AND CDCP.CarePlanType='AN' AND ISNULL(CDCP.RecordDeleted,'N')='N')
AND Doc.ClientId=@ClientID AND DocumentCodeId=1501 AND Doc.Status = 22
AND DATEDIFF(MONTH,Doc.EffectiveDate,GETDATE())  <= 6 
AND ISNULL(Doc.RecordDeleted,'N')='N'                  
AND CONVERT(DATE,DOC.EffectiveDate) <= CONVERT(DATE,GETDATE()) 
ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC

SET @EffectiveDateMHA = ISNULL(@EffectiveDateMHA,DATEADD(YEAR,-100,GETDATE()))
SET @EffectiveDate = ISNULL(@EffectiveDate,DATEADD(YEAR,-100,GETDATE()))


IF (@LatestCarePlanANDocumentVersionID IS NOT NULL)
BEGIN
	SELECT @GenralAddendumDate=CONVERT(VARCHAR(10), DATEADD(MONTH, 6, Doc.EffectiveDate),101)
	FROM DOCUMENTS Doc WHERE Doc.CurrentDocumentVersionId=@LatestCarePlanANDocumentVersionID

	SELECT   TOP 1 @ReviewPeriodFrom=CONVERT(VARCHAR, Doc.EffectiveDate,101), @ReviewPeriodTo=CONVERT(VARCHAR(10),@GenralAddendumDate,101)
	FROM DOCUMENTS Doc
	INNER JOIN DocumentCarePlans C on doc.CurrentDocumentVersionId=c.DocumentVersionId   
	WHERE Doc.ClientId=@ClientID AND ISNULL(C.RecordDeleted,'N')='N'  AND ISNULL(Doc.RecordDeleted,'N')='N'     
	And C.CarePlanType='AD' 
	AND DATEDIFF(MONTH,Doc.EffectiveDate,GETDATE())  <= 6  
	AND (Convert(DATE,Doc.EffectiveDate)>=@EffectiveDateAN AND CONVERT(DATE,GETDATE())>=(CONVERT(DATE,Doc.EffectiveDate)))
END	
ELSE IF(@LatestCarePlanINDocumentVersionID IS NOT NULL)
BEGIN
	SELECT top 1 @GenralAddendumDate=CONVERT(VARCHAR(10), DATEADD(MONTH, 6, Doc.EffectiveDate),101)
	FROM DOCUMENTS Doc WHERE Doc.CurrentDocumentVersionId=@LatestCarePlanINDocumentVersionID

	SELECT  top 1 @ReviewPeriodFrom=CONVERT(VARCHAR, Doc.EffectiveDate,101), @ReviewPeriodTo=CONVERT(VARCHAR(10),@GenralAddendumDate,101)
	FROM DOCUMENTS Doc
	INNER JOIN DocumentCarePlans C on doc.CurrentDocumentVersionId=c.DocumentVersionId   
	WHERE Doc.ClientId=@ClientID AND ISNULL(C.RecordDeleted,'N')='N'  AND ISNULL(Doc.RecordDeleted,'N')='N'     
	And C.CarePlanType='IN' AND DATEDIFF(MONTH,Doc.EffectiveDate,GETDATE())  <= 6 
END

/***************************************************************/
	
 SELECT CPR.DocumentCarePlanReviewId
      ,CPR.[CreatedBy]
      ,CPR.[CreatedDate]
      ,CPR.[ModifiedBy]
      ,CPR.[ModifiedDate]
      ,CPR.[RecordDeleted]
      ,CPR.[DeletedDate]
      ,CPR.[DeletedBy]
      ,CPR.[DocumentVersionId]
      ,CPR.[CarePlanDomainGoalId]
      ,CPR.[GoalNumber]
      ,CPR.[MemberGoalVision]
      ,CPR.[CarePlanDomainObjectiveId]
      ,CPR.[ObjectiveNumber]
      ,CPR.[StaffSupports]
      ,CPR.[MemberActions]
      ,CPR.[UseOfNaturalSupports]
      ,CPR.ProgressTowardsObjective
      ,CPR.[ObjectiveReview] 
      --,CDG.GoalDescription AS GoalDescription
      --,CDO.ObjectiveDescription AS ObjectiveDescription
      ,ISNULL(CDG.GoalDescription,'') + ISNULL(CDDG.AssociatedGoalDescription,'') AS GoalDescription 
      ,ISNULL(CDO.ObjectiveDescription,'')+ISNULL(CDDO.AssociatedObjectiveDescription,'') AS ObjectiveDescription
      ,CONVERT(int,REPLACE((LTRIM(RTRIM(REPLACE(LTRIM(RTRIM(CPR.[ObjectiveNumber])),'.','')))),' ','')) AS ObjectiveNumberId
      ,Convert(VARCHAR(10),@ReviewPeriodFrom,101) AS ReviewPeriodFrom
	  ,Convert(VARCHAR(10),@ReviewPeriodTo,101) AS ReviewPeriodTo
    FROM DocumentCarePlanReviews CPR
     LEFT JOIN CarePlanGoals CDDG ON(ISNULL(CDDG.RecordDeleted,'N')='N') AND CDDG.DocumentVersionId =@LatestCarePlanDocumentVersionID  and CDDG.goalNumber= CPR.goalnumber 
     LEFT JOIN CarePlanDomainGoals AS CDG ON CDG.CarePlanDomainGoalId=CDDG.CarePlanDomainGoalId AND ISNULL(CDG.RecordDeleted,'N')='N'
     LEFT JOIN CarePlanObjectives CDDO ON CDDO.CarePlanGoalId = CDDG.CarePlanGoalId AND ISNULL(CDDO.RecordDeleted,'N')='N' and CDDO.objectivenumber=CPR.objectivenumber
    LEFT JOIN CarePlanDomainObjectives CDO ON CDO.CarePlanDomainObjectiveId=CPR.CarePlanDomainObjectiveId AND ISNULL(CDO.RecordDeleted,'N')='N'
    
    --Left JOIN CarePlanDomainGoals AS CDG ON CDG.CarePlanDomainGoalId=CPR.CarePlanDomainGoalId AND ISNULL(CDG.RecordDeleted,'N')='N'
    --LEFT JOIN CarePlanDomainObjectives CDO ON CDO.CarePlanDomainObjectiveId=CPR.CarePlanDomainObjectiveId AND ISNULL(CDO.RecordDeleted,'N')='N'
	WHERE  CPR.DocumentVersionId=@DocumentVersionId AND ISNULL(CPR.RecordDeleted,'N')='N'
  
  SELECT   DocumentCarePlanReviewPeriodId
,CPRP.CreatedBy
,CPRP.CreatedDate
,CPRP.ModifiedBy
,CPRP.ModifiedDate
,CPRP.RecordDeleted
,CPRP.DeletedDate
,CPRP.DeletedBy
,CPRP.DocumentVersionId
,ReviewPeriodFromDate
,ReviewPeriodToDate

From DocumentCarePlanReviewPeriods  CPRP
WHERE  CPRP.DocumentVersionId=@DocumentVersionId AND ISNULL(CPRP.RecordDeleted,'N')='N'
  END Try
             
 BEGIN CATCH                                  
 DECLARE @Error VARCHAR(8000)                                  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())               
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCarePlanInitial')                                   
 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                    
 + '*****' + Convert(varchar,ERROR_STATE())                                  
 RAISERROR                                   
 (                                  
  @Error, -- Message text.                                  
  16,  -- Severity.                                  
  1  -- State.                                  
 );                               
END CATCH 
END
GO
