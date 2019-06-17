
/****** Object:  StoredProcedure [dbo].[ssp_InitCarePlanReview]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitCarePlanReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitCarePlanReview]
GO


/****** Object:  StoredProcedure [dbo].[ssp_InitCarePlanReview]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[ssp_InitCarePlanReview]    Script Date: 03/07/2015 08:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ssp_InitCarePlanReview]
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
 /* 29/05/2017     Venkatesh MR       Created SCSP since few customers are using the Custom Care Plan ex Texas Customers*/
/*******************************************************************************************************/
BEGIN 
BEGIN TRY
  
  	  EXEC scsp_InitCarePlanReview @ClientID,@StaffID,@CustomParameters
  
END TRY
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitCarePlanReview')                                                                                                       
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
