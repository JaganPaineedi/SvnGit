
/****** Object:  StoredProcedure [dbo].[SSP_RDLCarePlanGoalsReview]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_RDLCarePlanGoalsReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_RDLCarePlanGoalsReview]
GO


/****** Object:  StoredProcedure [dbo].[SSP_RDLCarePlanGoalsReview]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[SSP_RDLCarePlanGoalsReview]    Script Date: 08/08/2014 08:09:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SSP_RDLCarePlanGoalsReview]
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
/**************************************************************************/           
BEGIN      

	EXEC SCSP_RDLCarePlanGoalsReview @DocumentVersionId

 END
GO
