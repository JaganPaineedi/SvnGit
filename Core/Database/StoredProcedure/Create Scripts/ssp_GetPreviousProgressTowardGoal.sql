
/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousProgressTowardGoal]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPreviousProgressTowardGoal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPreviousProgressTowardGoal]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousProgressTowardGoal]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousProgressTowardGoal]    Script Date: 08/08/2014 08:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_GetPreviousProgressTowardGoal]                                           
 (  
    @ClientId INT,
    @EffectiveDate DATETIME,
    @DocumentCodeId INT,
    @DomainGoalId INT,
    @DomainObjectiveID INT,
    @RatingType CHAR(1) 
 )                                                                                                                                                   
AS                                                                                                                                                    
 /*********************************************************************/                                                                                        
 /* Stored Procedure: [ssp_GetPreviousProgressTowardGoal]					 */                                                                               
 /* Creation Date:  20/Dec/2011												 */                                                                                        
 /* Purpose: To Initialize													 */                                                                                       
 /* Input Parameters:  @Client,@EffectiveDate,@DocumentCodeId,@DomainGoalId  */                                                                                      
 /* Output Parameters:														 */                                                                                        
 /* Return:																	 */                                                                                        
 /* Called By:  Get Associated Needs										 */                                                                              
 /* Calls:																	 */                                                                                        
 /*																			 */                                                                                        
 /* Data Modifications:														 */                                                                                        
 /*	Updates:																 */                                                                                        
 /*	Date           Author		  Purpose									 */    
 /*	20/Dec/2011   Vikas Kashyap   Created-									 */                              
 /*	01Feb2012     Shifali		  Modified - added Order by Clause           */ 
 /* 01Feb2012	  Shifali		  Modified - Replaced single char with full text say 'D' --> 'Deterioration*/
 /* 29Aug2012	  Shifali		  Modified - Modified Effectivedate check, changed from '=' to '<=' */
 /*	23Jan2012	  Vikas Kashyap	  What:Added One more Condition For Objective Towards Rating*/
 /*								  Why:Made Changes as per Task#2616 threhsolds Bugs/Features*/	
 /* 2/18/2013     Vishant Garg    What- Added a if condition
								  Why- On sign of care plan a rating is set for care plan review but we can open the same from another banner.
								  so that time we need to show previous goal on that screen.
								  But we have no entry fot documentcodeid=1503 in CarePlanGoals 
								  with ref task# 2616 in threshold bugs/features */
/* 2/19/2013     Jagdeep          What: Changed the and condition to OR for @RatingType='O' 
                                  Why: Because when first time careplan is created the  @DomainGoalId @DomainObjectiveID is saved as null in the 
                                   DocumentCarePlanReviews table.			*/	
/* 04/27/2018     Neha            Added a radio button called 'Not reviewed' to the Progress towards objective field. Task #10004.2 Porter Starke Customizations	*/	  
 /****************************************************************************/                     
 BEGIN TRY
                                   
  BEGIN
  
  --Added By Vishant Garg
  IF(@DocumentCodeId =1632)
  BEGIN
		SET @DocumentCodeId=1620
  END
  ---------Ended By Vishant Garg
  
  
  /*@RatingType='G' ==> Goals Type Rating		*/
  /*@RatingType='O' ==> Objective Type Rating  */
  
  IF(@RatingType='G')
  Begin
	SELECT TOP 1 
	CASE ProgressTowardsGoal 
	WHEN 'D' THEN 'Deterioration'
	WHEN 'N' THEN 'No Change'
	WHEN 'S' THEN 'Some Improvement'
	WHEN 'M' THEN 'Moderate Improvement'
	WHEN 'A' THEN 'Achieved'
	WHEN 'R' THEN 'Not Reviewed'
	END AS ProgressTowardsGoal
	FROM CarePlanGoals CDCPG
	WHERE EXISTS (SELECT 1 FROM Documents WHERE CurrentDocumentVersionId = CDCPG.DocumentVersionId
				AND ClientId = @ClientId AND CONVERT(VARCHAR(10),EffectiveDate,110) <= CONVERT(VARCHAR(10),GETDATE(),110) 
				AND DocumentCodeId = @DocumentCodeId AND [Status] = 22 AND ISNULL(RecordDeleted,'N')='N')
		AND CDCPG.CarePlanDomainGoalId = @DomainGoalId  AND ISNULL(CDCPG.RecordDeleted,'N')='N' 	

END
ELSE IF(@RatingType='O')
   	SELECT TOP 1 
	CASE ProgressTowardsObjective 
	WHEN 'D' THEN 'Deterioration'
	WHEN 'N' THEN 'No Change'
	WHEN 'S' THEN 'Some Improvement'
	WHEN 'M' THEN 'Moderate Improvement'
	WHEN 'A' THEN 'Achieved'
	WHEN 'R' THEN 'Not Reviewed'
	END AS ProgressTowardsGoal
	FROM DocumentCarePlanReviews CDCPR
	WHERE EXISTS (SELECT 1 FROM Documents WHERE CurrentDocumentVersionId = CDCPR.DocumentVersionId
				AND ClientId = @ClientId AND CONVERT(VARCHAR(10),EffectiveDate,110) <= CONVERT(VARCHAR(10),GETDATE(),110) 
				AND DocumentCodeId = @DocumentCodeId AND [Status] = 22 AND ISNULL(RecordDeleted,'N')='N')
		or CDCPR.CarePlanDomainGoalId = @DomainGoalId or CDCPR.CarePlanDomainObjectiveId=@DomainObjectiveID  AND ISNULL(CDCPR.RecordDeleted,'N')='N'
		order by CDCPR.ModifiedDate desc 
  END
  
END TRY                                                                                                   
--Checking For Errors                                        
BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetPreviousProgressTowardGoal')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END CATCH
GO
