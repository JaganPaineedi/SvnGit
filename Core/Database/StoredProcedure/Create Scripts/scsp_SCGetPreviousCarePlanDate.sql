
/****** Object:  StoredProcedure [dbo].[scsp_SCGetPreviousCarePlanDate]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetPreviousCarePlanDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCGetPreviousCarePlanDate] --9999814 
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCGetPreviousCarePlanDate]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCGetPreviousCarePlanDate]    Script Date: 03/07/2015 08:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[scsp_SCGetPreviousCarePlanDate]
 @ClientID INT                            
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
/*******************************************************************************************************/
BEGIN 
BEGIN TRY
  
  	Declare  @EffectiveDate datetime
	
  	DECLARE @LatestCarePlanDocumentVersionID INT, @ReviewPeriodTo DATE, @ReviewPeriodFrom DATE;
	SELECT TOP 1 @LatestCarePlanDocumentVersionID = CurrentDocumentVersionId
		FROM Documents Doc 
		WHERE EXISTS(SELECT 1 FROM DocumentCarePlans C WHERE C.DocumentVersionId = Doc.CurrentDocumentVersionId
		AND ISNULL(C.RecordDeleted,'N')='N')
		/*AND Doc.ClientId=@ClientID AND DocumentCodeId = @DocumentCodeID AND Doc.Status = 22 */
		AND Doc.ClientId=@ClientID AND DocumentCodeId 
		--IN (1501,1502) 
		IN (1620) AND Doc.Status = 22  
		AND ISNULL(Doc.RecordDeleted,'N')='N'
	--	AND ((CONVERT(DATE,Doc.EffectiveDate )<= CONVERT(DATE,@ReviewToDate )) and (CONVERT(DATE,Doc.EffectiveDate )>= CONVERT(DATE,@ReviewFromDate )))
		ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC
		
		Select EffectiveDate from Documents where InprogressDocumentVersionId=@LatestCarePlanDocumentVersionID
	/***************************************************************/
	
	
  
END TRY
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_SCGetPreviousCarePlanDate')                                                                                                       
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
