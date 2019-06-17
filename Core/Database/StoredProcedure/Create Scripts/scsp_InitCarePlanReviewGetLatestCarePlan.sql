
/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanReviewGetLatestCarePlan]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitCarePlanReviewGetLatestCarePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_InitCarePlanReviewGetLatestCarePlan]
GO


/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanReviewGetLatestCarePlan]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanReviewGetLatestCarePlan]    Script Date: 08/08/2014 08:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[scsp_InitCarePlanReviewGetLatestCarePlan] 
(                                                    
 @ClientID INT ,
 @ReviewFromDate datetime,
 @ReviewToDate datetime,
 @DocumentVersionId int                                                                          
)                                                                            
As                                                                                    
/**********************************************************************/                                                                                        
 /* Stored Procedure: [scsp_InitCarePlanReviewGetLatestCarePlan]		  */                                                                               
 /* Creation Date:  19/March/2013                                     */                                                                                        
 /* Purpose: To Get Care Plan Review Period Date 					  */                                                                                       
 /* Input Parameters:   @DocumentVersionId						      */                                                                                      
 /* Output Parameters:											      */                                                                                        
 /* Return:															  */                                                                                        
 /* Called By: Inside stored procedure								  */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /* Updates:                                                          */                                                                                        
 /* Date		   Author		 Purpose							  */
 /*03/22/2017       Pabitra   Why: created the scsp to call from the  ssp_InitCarePlanReviewGetLatestCarePlan,Texas Customizations#83 */					 /*03/22/2017        Neelima   Why: created the scsp SCSP_INITCAREPLANREVIEWGETLATESTCAREPLANREFRESHGOALS call to write custom logic for CCC based on the goal and objectives end dates CCC-Customizations #55 */	  						  
 /*********************************************************************/
                                                                                         
BEGIN                            
BEGIN TRY                 

DECLARE @LatestCarePlanDocumentVersionID INT;
DECLARE @CareplanStartDate datetime;
DECLARE @CareplanEndDate datetime; 

SELECT TOP 1 @CareplanEndDate = CONVERT(VARCHAR(10), DATEADD(MONTH, 6, Doc.EffectiveDate),101)  
   ,@CareplanStartDate=Doc.EffectiveDate      
 FROM Documents Doc       
   INNER JOIN DocumentCarePlans CDCP ON cdcp.DocumentVersionId = doc.CurrentDocumentVersionId      
   INNER JOIN Clients C on C.ClientId=Doc.ClientId                   
   WHERE (CDCP.CarePlanType='IN' OR CDCP.CarePlanType = 'AN') AND ISNULL(CDCP.RecordDeleted,'N')='N'      
   AND Doc.ClientId=@ClientID AND DocumentCodeId IN (1620) AND Doc.Status = 22       
   AND DATEDIFF(MONTH,Doc.EffectiveDate,GETDATE())  <= 6       
   AND ISNULL(Doc.RecordDeleted,'N')='N'      
   AND CONVERT(DATE,DOC.EffectiveDate) <= CONVERT(DATE,GETDATE())       
   ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC   
     
 SELECT TOP 1 @LatestCarePlanDocumentVersionID=doc.CurrentDocumentVersionId            
 FROM DocumentCarePlans CDCP Inner join Documents Doc  on CDCP.DocumentVersionId = Doc.CurrentDocumentVersionId            
 AND  ISNULL(CDCP.RecordDeleted,'N')='N' and  ISNULL(Doc.RecordDeleted,'N')='N'          
 INNER JOIN Clients C on C.ClientId=Doc.ClientId           
 WHERE  Doc.ClientId=@ClientID AND DocumentCodeId=1620 AND Doc.Status = 22  
 AND ((CONVERT(DATE,@ReviewFromDate) between CONVERT(DATE,@CareplanStartDate ) and CONVERT(DATE,@CareplanEndDate ))  
 OR (CONVERT(DATE,@ReviewToDate ) between CONVERT(DATE,@CareplanStartDate ) and CONVERT(DATE,@CareplanEndDate ))  
 OR (CONVERT(DATE,@CareplanStartDate) between CONVERT(DATE,@ReviewFromDate ) and CONVERT(DATE,@ReviewToDate ))  
 OR (CONVERT(DATE,@CareplanEndDate) between CONVERT(DATE,@ReviewFromDate ) and CONVERT(DATE,@ReviewToDate ))  
 )   
 ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC  

IF EXISTS(SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_INITCAREPLANREVIEWGETLATESTCAREPLANREFRESHGOALS]') AND type in (N'P', N'PC'))
	  BEGIN
		EXEC SCSP_INITCAREPLANREVIEWGETLATESTCAREPLANREFRESHGOALS  @ClientID,@ReviewFromDate,@ReviewToDate,@DocumentVersionId              
	  END
	  ELSE
	  BEGIN	   
 SELECT   
      CONVERT(int,'-' + CONVERT(varchar(50),row_number() over (ORDER BY CO.CarePlanDomainObjectiveId))) AS   DocumentCarePlanReviewId
      ,CDO.[RecordDeleted]                         
      ,CDG.[DocumentVersionId]  
      ,CDG.[CarePlanDomainGoalId]  
      ,CDG.[GoalNumber]  
      ,CDG.[ClientGoal]  as MemberGoalVision
      ,CDO.[CarePlanDomainObjectiveId]  
      ,CDO.[ObjectiveNumber]  
      ,CDO.[StaffSupports]  
      ,CDO.[MemberActions]  
      ,CDO.[UseOfNaturalSupports]  
      ,null as [ProgressTowardsObjective]  
      ,null as [ObjectiveReview]  
      ,ISNULL(CG.GoalDescription,'') + ISNULL(CDG.AssociatedGoalDescription,'') AS GoalDescription 
      ,ISNULL(CO.ObjectiveDescription,'')+ISNULL( CDO.AssociatedObjectiveDescription,'') AS ObjectiveDescription
      ,CONVERT(int,REPLACE((LTRIM(RTRIM(REPLACE(LTRIM(RTRIM(CDO.[ObjectiveNumber])),'.','')))),' ','')) AS ObjectiveNumberId
     FROM   
     (SELECT 'DocumentCarePlanReviews' AS TableName) AS Placeholder   
  LEFT JOIN CarePlanGoals CDG ON(ISNULL(CDG.RecordDeleted,'N')='N') AND CDG.DocumentVersionId =@LatestCarePlanDocumentVersionID  
  LEFT JOIN CarePlanDomainGoals CG ON CG.CarePlanDomainGoalId = CDG.CarePlanDomainGoalId AND ISNULL(CG.RecordDeleted,'N')='N'  
  LEFT JOIN CarePlanObjectives CDO ON CDO.CarePlanGoalId = CDG.CarePlanGoalId AND ISNULL(CDO.RecordDeleted,'N')='N'  
  LEFT JOIN CarePlanDomainObjectives CO ON CO.CarePlanDomainObjectiveId = CDO.CarePlanDomainObjectiveId AND ISNULL(CO.RecordDeleted,'N')='N'	
  END

END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_InitCarePlanReviewGetLatestCarePlan')                                                                                                       
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
