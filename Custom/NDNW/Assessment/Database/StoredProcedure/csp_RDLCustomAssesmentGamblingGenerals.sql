/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAssesmentGamblingGenerals]    Script Date: 11/27/2013 16:30:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAssesmentGamblingGenerals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomAssesmentGamblingGenerals]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAssesmentGamblingGenerals]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomAssesmentGamblingGenerals] 
(
@DocumentVersionId INT
)  
AS  
/*************************************************************************************/  
/* Stored Procedure: [csp_RDLCustomAssesmentGamblingGenerals]                      */  
/* Creation Date:				                                                   */  
/* Purpose: Gets Data from CustomDocumentGambling								 */  
/* Input Parameters: @DocumentVersionId                                         */  
/* Purpose: Use For Rdl Report                                                 */  
/* Author:                                                                   */  
/*************************************************************************************/  
BEGIN  
 DECLARE @MaritalStatus VARCHAR(100)  
 DECLARE @EmploymentStatus VARCHAR(100)  
 BEGIN TRY  
  SELECT @MaritalStatus=dbo.csf_GetGlobalCodeNameById(c.MaritalStatus) 
		,@EmploymentStatus=dbo.csf_GetGlobalCodeNameById(c.EmploymentStatus) 
  FROM Documents D 
  JOIN Clients C ON D.ClientId = C.ClientId  
   AND isnull(C.RecordDeleted, 'N') <> 'Y'  
  WHERE D.CurrentDocumentVersionId =@DocumentVersionId   
   AND isnull(D.RecordDeleted, 'N') = 'N'  
  
 
  
  SELECT ISNULL(@MaritalStatus,'') AS MaritalStatus
		 ,ISNULL(@EmploymentStatus,'') AS EmploymentStatus
		 ,CONVERT(VARCHAR(10),GamblingDate,101) AS GamblingDate 
		 ,CAST(TotalMonthlyHousehold as decimal(18,2)) AS TotalMonthlyHousehold
		,dbo.csf_GetGlobalCodeNameById(HealthInsurance) AS HealthInsurance
		,dbo.csf_GetGlobalCodeNameById(PrimarySourceOfIncome) AS PrimarySourceOfIncome
		,TotalNumberOfDependents
		,LastGradeCompleted
		,CAST(TotalEstimatedGamblingDebt as decimal(18,2)) AS TotalEstimatedGamblingDebt
		,dbo.csf_GetGlobalCodeNameById(LifeInGeneral) AS LifeInGeneral
		,dbo.csf_GetGlobalCodeNameById(OverallPhysicalHealth) AS OverallPhysicalHealth
		,dbo.csf_GetGlobalCodeNameById(OverallEmotionalWellbeing) AS OverallEmotionalWellbeing
		,dbo.csf_GetGlobalCodeNameById(RelationshipWithSpouse) AS RelationshipWithSpouse
		,dbo.csf_GetGlobalCodeNameById(RelationshipWithFriends) AS RelationshipWithFriends
		,dbo.csf_GetGlobalCodeNameById(RelationshipWithOtherFamilyMembers) AS RelationshipWithOtherFamilyMembers
		,dbo.csf_GetGlobalCodeNameById(RelationshipWithChildren) AS RelationshipWithChildren
		,dbo.csf_GetGlobalCodeNameById(Job) AS Job
		,dbo.csf_GetGlobalCodeNameById(School) AS School
		,dbo.csf_GetGlobalCodeNameById(SpiritualWellbeing) AS SpiritualWellbeing
		,dbo.csf_GetGlobalCodeNameById(AccomplishedResponsibilitiesAtWork) AS AccomplishedResponsibilitiesAtWork
		,dbo.csf_GetGlobalCodeNameById(PaidBillsOnTime) AS PaidBillsOnTime
		,dbo.csf_GetGlobalCodeNameById(AccomplishedResponsibilitiesAtHome) AS AccomplishedResponsibilitiesAtHome
		,dbo.csf_GetGlobalCodeNameById(HaveThoughtsOfSuicide) AS HaveThoughtsOfSuicide
		,dbo.csf_GetGlobalCodeNameById(AttemptToCommitSuicide) AS AttemptToCommitSuicide
		,dbo.csf_GetGlobalCodeNameById(DrinkAlcohol) AS DrinkAlcohol
		,dbo.csf_GetGlobalCodeNameById(ProblemsAssociatedWithAlcohol) AS ProblemsAssociatedWithAlcohol
		,dbo.csf_GetGlobalCodeNameById(UseOfIllegalDrugs) AS UseOfIllegalDrugs
		,dbo.csf_GetGlobalCodeNameById(ProblemsAssociatedWithIllegalDrugs) AS ProblemsAssociatedWithIllegalDrugs
		,dbo.csf_GetGlobalCodeNameById(UseOfTobacco) AS UseOfTobacco
		,dbo.csf_GetGlobalCodeNameById(CommitIllegalActs) AS CommitIllegalActs
		,dbo.csf_GetGlobalCodeNameById(MaintainSupportiveNetworkOfFamily) AS MaintainSupportiveNetworkOfFamily
		,dbo.csf_GetGlobalCodeNameById(TakeTimeToRelax) AS TakeTimeToRelax
		,dbo.csf_GetGlobalCodeNameById(EatHealthyFood) AS EatHealthyFood
		,dbo.csf_GetGlobalCodeNameById(Exercise) AS Exercise
		,dbo.csf_GetGlobalCodeNameById(AttendCommunitySupport) AS AttendCommunitySupport
		,dbo.csf_GetGlobalCodeNameById(ThinkingAboutGambling) AS ThinkingAboutGambling
		,dbo.csf_GetGlobalCodeNameById(GamblingWithMoreMoney) AS GamblingWithMoreMoney
		,dbo.csf_GetGlobalCodeNameById(UnsuccessfulAttemptsToControlGambling) AS UnsuccessfulAttemptsToControlGambling
		,dbo.csf_GetGlobalCodeNameById(RestlessOrIrritable) AS RestlessOrIrritable
		,dbo.csf_GetGlobalCodeNameById(GambleToEscapeFromProblems) AS GambleToEscapeFromProblems
		,dbo.csf_GetGlobalCodeNameById(ReturningAfterLosingGamblingMoney) AS ReturningAfterLosingGamblingMoney
		,dbo.csf_GetGlobalCodeNameById(LieToFamily) AS LieToFamily
		,dbo.csf_GetGlobalCodeNameById(GoBeyondLegalGambling) AS GoBeyondLegalGambling
		,dbo.csf_GetGlobalCodeNameById(LoseSignificantRelationship) AS LoseSignificantRelationship
		,dbo.csf_GetGlobalCodeNameById(SeekHelpFromOthers) AS SeekHelpFromOthers
		,NumberOfDaysGambled
		,AverageAmountGambled
		,PrimaryGamblingActivity
		,PrimarilyGamblingPlace
		,NumberOfTimesEnteredEmergencyRoom
		,dbo.csf_GetGlobalCodeNameById(EnrolledInTreatmentProgramForAlcohol) AS EnrolledInTreatmentProgramForAlcohol
		,CASE AlcoholInpatientAAndD
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'NO' 
		   END AS AlcoholInpatientAAndD
		,CASE AlcoholOutpatientAAndD
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'NO' 
		   END AS AlcoholOutpatientAAndD
		, dbo.csf_GetGlobalCodeNameById(EnrolledInTreatmentProgramForMentalHealth) AS EnrolledInTreatmentProgramForMentalHealth
		,CASE MentalHealthInpatientAAndD
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No'
		   END AS MentalHealthInpatientAAndD
		,CASE MentalHealthOutpatientAAndD
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No' 
		   END AS MentalHealthOutpatientAAndD
		,dbo.csf_GetGlobalCodeNameById(EnrolledInAnotherGamblingProgram) AS EnrolledInAnotherGamblingProgram
		,CASE GamblingInpatientAAndD
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No' 
		   END AS GamblingInpatientAAndD
		,CASE GamblingOutpatientAAndD
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No' 
		   END AS GamblingOutpatientAAndD
		,CASE FiledForBankruptcy
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No'
		   END AS FiledForBankruptcy
		,CASE ConvictedOfGambling
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No'
		   END AS ConvictedOfGambling
		,CASE ExperiencedPhysicalViolence
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No' 
		   END AS ExperiencedPhysicalViolence
		,CASE AbuseInRelationship
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No'
		   END AS AbuseInRelationship
		,CASE ControlloedManipulatedByOther
		   WHEN 'Y' THEN 'Yes' 
		   WHEN 'N' THEN 'No' 
		   END AS ControlloedManipulatedByOther
	FROM [CustomDocumentGambling]    
   WHERE DocumentVersionId = @DocumentVersionId AND isnull(RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomAssesmentGamblingGenerals') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  