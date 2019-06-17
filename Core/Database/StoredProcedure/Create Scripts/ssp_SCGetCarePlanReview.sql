
/****** Object:  StoredProcedure [dbo].[ssp_SCGetCarePlanReview]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCarePlanReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCarePlanReview] 
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetCarePlanReview]    Script Date: 08/08/2014 08:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetCarePlanReview]    Script Date: 03/07/2015 08:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ssp_SCGetCarePlanReview]
(                                
 @DocumentVersionId  int    
)                                
As    
 /*********************************************************************/                                                                                                
 /* Stored Procedure: ssp_SCGetCarePlanReview						  */                                                                                       
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
 /*01/06/2017     Venkatesh MR      Move the logic ti SCSP, since few customers are using Custom Care Plan   */ 
 /*********************************************************************/
  BEGIN
  BEGIN Try
	EXEC scsp_SCGetCarePlanReview @DocumentVersionId
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
