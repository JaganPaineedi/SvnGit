/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomAIMS]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomAIMS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomAIMS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomAIMS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                                                
 /* Stored Procedure:csp_SCGetCustomAIMS                                     */                                       
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */     
 /* Author: Pradeep                                                          */                                               
 /* Creation Date:  Aug 20,2009                                              */                                                
 /* Purpose: Gets Data for Custom AIMS Document                              */                                               
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                              
 /* Output Parameters:None                                                   */                                                
 /* Return:                                                                  */                                                
 /* Calls:                                                                   */    
 /* Called From:                                                             */                                                
 /* Data Modifications:                                                      */                                                
 /*-------------Modification History--------------------------               */
 /*-------Date----Author-------Purpose---------------------------------------*/ 
 /* 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0      */ 
 /* 03/04/2010 Vikas Monga													 */  
 /* -- Remove [Documents] and [DocumentVersions]							 */                        
 /****************************************************************************/                                                 

CREATE PROCEDURE  [dbo].[csp_SCGetCustomAIMS]                                  
  @DocumentVersionId INT                                   
AS                                 
 BEGIN                    
   BEGIN TRY                        
   -- For CustomAIMS table                 
	SELECT     DocumentVersionId, TotalScore, DentalStatusWearDentures, DentalStatusCurrentProblems, GlobalJudgementAwareness, GlobalJudgementIncapacitation, 
					  GlobalJudgementSeverity, FacialOralMovementsMuscles, FacialOralMovementsLips, FacialOralMovementsJaw, FacialOralMovementsTongue, 
					  ExtremityMovementsUpper, ExtremityMovementsLower, ExtremityMovementsTrunk, Rater, ClientInformed, Method, Comments, RowIdentifier, CreatedBy, 
					  CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomAIMS
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)                                                  
 END TRY                    
 BEGIN CATCH                    
   DECLARE @Error varchar(8000)                                                       
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                      
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomAIMS]'')                                                       
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                      
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                      
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
 END CATCH                                  
End
' 
END
GO
