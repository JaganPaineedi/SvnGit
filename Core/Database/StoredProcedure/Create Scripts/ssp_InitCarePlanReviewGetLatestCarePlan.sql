
/****** Object:  StoredProcedure [dbo].[ssp_InitCarePlanReviewGetLatestCarePlan]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitCarePlanReviewGetLatestCarePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitCarePlanReviewGetLatestCarePlan]
GO


/****** Object:  StoredProcedure [dbo].[ssp_InitCarePlanReviewGetLatestCarePlan]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[ssp_InitCarePlanReviewGetLatestCarePlan]    Script Date: 08/08/2014 08:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[ssp_InitCarePlanReviewGetLatestCarePlan] 
(                                                    
 @ClientID INT ,
 @ReviewFromDate datetime,
 @ReviewToDate datetime,
 @DocumentVersionId int                                                                          
)                                                                            
As                                                                                    
/**********************************************************************/                                                                                        
 /* Stored Procedure: [ssp_InitCarePlanReviewGetLatestCarePlan]		  */                                                                               
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
 /*17/8/2015       Pabitra   Valley Client Acceptance Testing Issues: #543 Care Plan Review */
 /*03/22/2015      Pabitra Moved the logic to scsp_InitCarePlanReviewGetLatestCarePlan,Texas Customizations#83*/						  						  
 /*********************************************************************/
                                                                                         
BEGIN                            
BEGIN TRY                 

EXEC scsp_InitCarePlanReviewGetLatestCarePlan @ClientID,@ReviewFromDate,@ReviewToDate,@DocumentVersionId

END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitCarePlanReviewGetLatestCarePlan')                                                                                                       
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
