
/****** Object:  StoredProcedure [dbo].[ssp_RdlObjectives]    Script Date: 01/13/2015 12:09:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RdlObjectives]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RdlObjectives]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RdlObjectives]    Script Date: 01/13/2015 12:09:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RdlObjectives] --2552
(
  @DocumentVersionId AS INT  
 )    
AS
BEGIN 
/************************************************************************/                                                          
/* Stored Procedure: ssp_RdlObjectives 4277471							*/                                                 
/* Creation Date:  25-03-2013											*/                                                           
/* Purpose: Get Data for the RDL										*/                                                         
/* Input Parameters: DocumentVersionId									*/                                                        
/* Purpose: Use For Rdl Report											*/                                                                                                     
/* Author:  Gayathri Naik												*/
/* Modified By: Bernardin												*/
/* Purpose: Query modified as it is not displaying Goal and Objectives  */  
/* Updates																*/
/* -------------------------------------------------------------------- */
/* 12/11/2013     Jeff Riley    Added record deleted clause for CarePlanPrescribedServices */
/* 26 Dec 2014    Aravind       Modified As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans
				                 Valley - Customizations   */
/* 01 April 2015  Aravind        Modified the logic to get the Goal Description,Objective Description based on
                                 CarePlanDomainGoalId and CarePlanDomainObjectiveId respectively  */	
/* 17 April 2015  Aravind        Added a Space between CarePlanDomainObjectives.ObjectiveDescription and CarePlanObjectives.AssociatedObjectiveDescription to reflect in the  Pdf.*/                                			                 
/* 07 Oct 2015    Venkatesh      Get Associated needs and Intervention based on the CarePlanGoalId not from DocumentVersionId. Call 2 functions to achive this- Ref Task 514 in VCAT.*/ 
/* 09 Nov 2015    Venkatesh      Get Personresponsible CarePlanObjectiveId not from DocumentVersionId. Call function to achive this- Ref Task 64 in Valley Go Live Support.*/ 
-- 12 jan 2016    Vijay          Added column 'ProgressTowardsObjective' and 'ObjectiveReview' for Valley - Support Go Live Task#210
/* 2016.05.11    Veena S Mani       Review changes Valley Support Go live #390               */
/* 05 Jan 2018   Kavya   Checking ISNULL condtion for cloumns GoalDescription, ObjectiveDescription- Spring River-Support Go Live: #137*/
/* 09 Jan 2018   Bernardin Removed hard coded documentVersionId and added @DocumentVersionId as selection parametr. Spring River - Support Go Live# 145 */
/* 02 July 2018   Neha            Added a radio button called 'Not reviewed' to the Progress towards objective field. Task #10004.14 Porter Starke Customizations	*/	  
/* 28 August 2018 Mrunali         Added condition to check Configuration Keys Value. Task PEP-Customizations : #10188 	*/	  

/************************************************************************/
Begin Try

DECLARE @ConfigurationKeysVal Varchar(15)


SELECT @ConfigurationKeysVal=ISNULL(Value,'')
		FROM SystemConfigurationKeys
		WHERE [Key] = 'UseBTATemplateForGoalsAndObjectivesInCarePlan'
SELECT  Distinct  CarePlanGoals.DocumentVersionId,
           CarePlanObjectives.ObjectiveNumber, 
           CarePlanObjectives.StaffSupports, 
           CarePlanObjectives.MemberActions,
           CarePlanObjectives.UseOfNaturalSupports,
           
            case when ISNULL(CarePlanObjectives.[ProgressTowardsObjective],'')='S'  then 'Some Improvement'  
        when ISNULL(CarePlanObjectives.[ProgressTowardsObjective],'')='N'  then 'No Change '
         when ISNULL(CarePlanObjectives.[ProgressTowardsObjective],'')='D'  then 'Deterioration'
         when ISNULL(CarePlanObjectives.[ProgressTowardsObjective],'')='M'  then 'Moderate Improvement'
        when ISNULL(CarePlanObjectives.[ProgressTowardsObjective],'')='A'  then 'Achieved' 
        when ISNULL(CarePlanObjectives.[ProgressTowardsObjective],'')='R'  then 'Not Reviewed' 
   else '' END  AS ProgressTowardsObjective,
   --Added by Veena
   Case when (ObjectiveEndDate IS NOT NULL OR DCP.CarePlanType='RE')
   THEN 'Y' else 'N' end as ShowProgress, 
           CarePlanObjectives.ObjectiveReview,
           CONVERT(VARCHAR(10), CarePlanObjectives.ObjectiveStartDate,101) as ObjectiveStartDate,
           CONVERT(VARCHAR(10), CarePlanObjectives.ObjectiveEndDate,101) as ObjectiveEndDate,
           CarePlanGoals.ClientGoal,
          CarePlanGoals.GoalNumber,
           CONVERT(VARCHAR(10), CarePlanGoals.GoalStartDate,101) as GoalStartDate,
           CONVERT(VARCHAR(10), CarePlanGoals.GoalEndDate,101) as GoalEndDate,
           CarePlanGoals.MonitoredByType,
           CarePlanGoals. MonitoredByOtherDescription, 
			CASE  When  isnull(CarePlanGoals.MonitoredByType,'') = 'S' 
		   THEN S.LastName + ', ' + S.FirstName 
			END AS MonitoredBy,
           dbo.ssf_SCGetCarePlanGoalInterventions(CarePlanObjectives.CarePlanObjectiveId) as AuthorizationCodeName,
           --GlobalCodes.CodeName as PersonResponsible,
           dbo.ssf_SCGetCarePlanPersonResponsible(CarePlanObjectives.CarePlanObjectiveId) as PersonResponsible,
        
           CASE WHEN  ISNULL(CarePlanGoals.CarePlanDomainGoalId,'')='' OR @ConfigurationKeysVal ='Yes' then
           CarePlanGoals.AssociatedGoalDescription 
           ELSE ISNULL(DCP.NameInGoalDescriptions,'') + ' ' + ISNULL(CarePlanDomainGoals.GoalDescription,'') + ISNULL(CarePlanGoals.AssociatedGoalDescription,'') END as GoalDescription,--Checking ISNULL condtion for cloumns GoalDescription, ObjectiveDescription- Spring River-Support Go Live: #137-Kavya
           CASE WHEN  ISNULL(CarePlanObjectives.CarePlanDomainObjectiveId,'')='' OR @ConfigurationKeysVal ='Yes' then
           CarePlanObjectives.AssociatedObjectiveDescription 
           ELSE ISNULL(DCP.NameInGoalDescriptions,'') + ' ' + ISNULL(CarePlanDomainObjectives.ObjectiveDescription,'') + ' ' + ISNULL(CarePlanObjectives.AssociatedObjectiveDescription,'') END as ObjectiveDescription,--Checking ISNULL condtion for cloumns GoalDescription, ObjectiveDescription- Spring River-Support Go Live: #137-Kavya
          -- ISNULL(CarePlanDomainGoals.GoalDescription,'')<>'' then  ISNULL(DCP.NameInGoalDescriptions,'') + ' ' + CarePlanDomainGoals.GoalDescription END as GoalDescription,
          -- ISNULL(DCP.NameInGoalDescriptions,'') + ' ' + CarePlanDomainObjectives.ObjectiveDescription AS ObjectiveDescription,
           CONVERT(int,REPLACE((LTRIM(RTRIM(REPLACE(LTRIM(RTRIM(CarePlanObjectives.ObjectiveNumber)),'.','')))),' ','')) AS ObjectiveNumberId,
           CarePlanGoals.CarePlanGoalId, 
           CarePlanGoals.InitializedFromPreviousCarePlan,
           dbo.ssf_SCGetCarePlanGoalAssociatedNeeds(CarePlanGoals.CarePlanGoalId) AS AssociatedNeeds 
FROM         GlobalCodes LEFT JOIN
                      CarePlanPrescribedServices ON GlobalCodes.GlobalCodeId = CarePlanPrescribedServices.PersonResponsible RIGHT OUTER JOIN
                      CarePlanGoals  LEFT JOIN
                      CarePlanObjectives ON CarePlanGoals.CarePlanGoalId = CarePlanObjectives.CarePlanGoalId AND ISNULL(CarePlanObjectives.RecordDeleted,'N')='N'  LEFT JOIN
                      CarePlanDomainGoals ON CarePlanGoals.CarePlanDomainGoalId = CarePlanDomainGoals.CarePlanDomainGoalId AND ISNULL(CarePlanDomainGoals.RecordDeleted,'N')='N' LEFT JOIN
                      CarePlanDomainObjectives ON CarePlanObjectives.CarePlanDomainObjectiveId = CarePlanDomainObjectives.CarePlanDomainObjectiveId  AND ISNULL(CarePlanDomainObjectives.RecordDeleted,'N')='N'  LEFT JOIN
          -- GlobalCodes GC ON  CarePlanGoals.MonitoredBy=GC.GlobalCodeId INNER JOIN
                      --CustomDocumentCarePlanReviews ON CarePlanGoals.DocumentVersionId = CustomDocumentCarePlanReviews.DocumentVersionId INNER JOIN
                      Documents ON CarePlanGoals.DocumentVersionId = Documents.CurrentDocumentVersionId AND Documents.DocumentCodeId = 1620/*AND 
                      Documents.Status = 22*/ LEFT JOIN
                      Clients ON Documents.ClientId = Clients.ClientId ON 
                      CarePlanPrescribedServices.DocumentVersionId = CarePlanGoals.DocumentVersionId 
                      left join Staff S on CarePlanGoals.MonitoredBy=S.StaffId  
                      left join DocumentCarePlans DCP on CarePlanGoals.DocumentVersionId =DCP.DocumentVersionId
                      --left Join  CarePlanGoalNeeds CPGN ON CPGN.CarePlanGoalId=CarePlanGoals.CarePlanGoalId
                      --left join CarePlanNeeds CPN ON CPN.CarePlanNeedId=CPGN.CarePlanNeedId
                      --Left join CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId=CPN.CarePlanDomainNeedId

                    
WHERE CarePlanGoals.DocumentVersionId = @DocumentVersionId
     -- AND ISNULL(CustomDocumentCarePlanReviews.RecordDeleted,'N')<>'Y'
	  AND ISNULL(CarePlanGoals.RecordDeleted,'N')='N' 
	--  AND ISNULL(CarePlanDomainGoals.RecordDeleted,'N')='N'
	 -- AND ISNULL(CarePlanObjectives.RecordDeleted,'N')='N' 
	  AND ISNULL(Globalcodes.RecordDeleted,'N')='N'	   
	--  AND ISNULL(CarePlanDomainObjectives.RecordDeleted,'N')='N'  
	  AND ISNULL(Documents.RecordDeleted,'N')<>'Y'  
	  AND ISNULL(Clients.RecordDeleted,'N')<>'Y'
	  AND ISNULL(DCP.RecordDeleted,'N')<>'Y'



  END TRY    
BEGIN CATCH                              
DECLARE @Error varchar(8000)                                                                        
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RdlObjectives')                                                                                                         
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


