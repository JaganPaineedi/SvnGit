
/****** Object:  StoredProcedure [dbo].[SCSP_RDLCarePlanGoalsReview]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_RDLCarePlanGoalsReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SCSP_RDLCarePlanGoalsReview]
GO


/****** Object:  StoredProcedure [dbo].[SCSP_RDLCarePlanGoalsReview]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[SCSP_RDLCarePlanGoalsReview]    Script Date: 08/08/2014 08:09:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SCSP_RDLCarePlanGoalsReview]
 (
 @DocumentVersionId  int
 )
AS 
      
/**************************************************************************/                                                          
/* Stored Procedure: csp_RDLCarePlanGoals							      */                                                 
/*																		  */                                                          
/* Creation Date:  22 Dec 2011									          */                                                          
/*																		  */                                                          
/* Purpose: Gets Data for csp_RDLCarePlanGoals							  */                                                         
/* Input Parameters: @DocumentVersionId									  */                                                        
/* Output Parameters:													  */                                                          
/* Purpose: Use For Rdl Report											  */                                                
/* Calls:																  */                                                          
/*																		  */                                                          
/* Author: Rohit Katoch													  */
/* Updates:															      */                                                                                        
/* Date				Author				Purpose							  */    
/* 06-Feb-2012		Vikas Kashyap		Added New Column in CustomDocumentCarePlanGoals Table	  */   
/* 1-21-2012		JJN					Changed logic to match dfa			*/   
/* 04/27/2018       Neha                Added a radio button called 'Not reviewed' to the Progress towards objective field. Task #10004.2 Porter Starke Customizations	*/	  
                                                    
/**************************************************************************/           
BEGIN      

DECLARE @LatestCarePlanDocumentVersionID INT,@ClientID INT;
Select TOP 1 @ClientID=ClientId From Documents Where CurrentDocumentVersionId=@DocumentVersionId	
SELECT TOP 1 
@LatestCarePlanDocumentVersionID = CurrentDocumentVersionId
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
      ,[ProgressTowardsObjective] = CASE CPR.ProgressTowardsObjective
		WHEN 'D' THEN 'Deterioration'
		WHEN 'N' THEN 'No Change'
		WHEN 'S' THEN 'Some Improvement'
		WHEN 'M' THEN 'Moderate Improvement'
		WHEN 'A' THEN 'Achieved'
		WHEN 'R' THEN 'Not Reviewed'
		ELSE '' END
      ,CPR.[ObjectiveReview] 
      --,CDG.GoalDescription AS GoalDescription
      --,CDO.ObjectiveDescription AS ObjectiveDescription
       ,ISNULL(CDG.GoalDescription,'') + ISNULL(CDDG.AssociatedGoalDescription,'') AS GoalDescription 
      ,ISNULL(CDO.ObjectiveDescription,'')+ISNULL(CDDO.AssociatedObjectiveDescription,'') AS ObjectiveDescription
      ,CONVERT(int,REPLACE((LTRIM(RTRIM(REPLACE(LTRIM(RTRIM(CPR.[ObjectiveNumber])),'.','')))),' ','')) AS ObjectiveNumberId
    FROM DocumentCarePlanReviews CPR
    --Left JOIN CarePlanDomainGoals AS CDG ON CDG.CarePlanDomainGoalId=CPR.CarePlanDomainGoalId AND ISNULL(CDG.RecordDeleted,'N')='N'
    --LEFT JOIN CarePlanDomainObjectives CDO ON CDO.CarePlanDomainObjectiveId=CPR.CarePlanDomainObjectiveId AND ISNULL(CDO.RecordDeleted,'N')='N'
	 LEFT JOIN CarePlanGoals CDDG ON(ISNULL(CDDG.RecordDeleted,'N')='N') AND CDDG.DocumentVersionId =@LatestCarePlanDocumentVersionID  and CDDG.goalNumber= CPR.goalnumber  
     LEFT JOIN CarePlanDomainGoals AS CDG ON CDG.CarePlanDomainGoalId=CDDG.CarePlanDomainGoalId AND ISNULL(CDG.RecordDeleted,'N')='N'
     LEFT JOIN CarePlanObjectives CDDO ON CDDO.CarePlanGoalId = CDDG.CarePlanGoalId AND ISNULL(CDDO.RecordDeleted,'N')='N'  and CDDO.objectivenumber=CPR.objectivenumber
    LEFT JOIN CarePlanDomainObjectives CDO ON CDO.CarePlanDomainObjectiveId=CPR.CarePlanDomainObjectiveId AND ISNULL(CDO.RecordDeleted,'N')='N'
    
	WHERE  CPR.DocumentVersionId=@DocumentVersionId AND ISNULL(CPR.RecordDeleted,'N')='N'
	ORDER BY GoalNumber,ObjectiveNumber
 

 END
GO
