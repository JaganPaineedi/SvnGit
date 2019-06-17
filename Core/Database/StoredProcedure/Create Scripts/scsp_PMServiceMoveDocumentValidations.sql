IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PMServiceMoveDocumentValidations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_PMServiceMoveDocumentValidations]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[scsp_PMServiceMoveDocumentValidations]                               
(                                      
	@ServiceIdTo int ,          
	@ServiceIdFrom int,          
	@StaffId int,           
	@DocumentIdTo int,            
	@DocumentCodeIdTo int,          
	@ClientIdTo int,          
	@AuthorIdTo int,           
	@DocumentIdFrom int,           
	@DocumentCodeIdFrom int,            
	@ClientIdFrom int ,           
	@AuthorIdFrom  int              
)  
/*********************************************************************                                      
-- Stored Procedure: dbo.scsp_PMServiceMoveDocumentValidations                                      
--                                      
-- Copyright: 2010 Streamline Healthcare Solutions                                      
--                                      
-- Purpose: Validation Move of ServiceId from one DocumentId to another.                                                              
--                                      
--                                      
-- Updates:                                       
-- Date--------------Author-------------Purpose-----------------------------------      
-- 04 May 2018		Vithobha			ssp_PMServiceMoveDocument was calling csp_PMServiceMoveDocumentValidations, so introduced the scsp   
**********************************************************************/                                                       
as   
BEGIN
	BEGIN TRY
	IF EXISTS (SELECT  1  
				FROM    sys.objects  
				WHERE   object_id = OBJECT_ID(N'csp_PMServiceMoveDocumentValidations')  
						AND type IN ( N'P', N'PC' ))     
	BEGIN                          
		exec csp_PMServiceMoveDocumentValidations @ServiceIdTo ,@ServiceIdFrom ,@StaffId , @DocumentIdTo ,      
		 @DocumentCodeIdTo ,@ClientIdTo , @AuthorIdTo , @DocumentIdFrom , @DocumentCodeIdFrom ,                                
		 @ClientIdFrom ,  @AuthorIdFrom                                    
	END  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'scsp_PMServiceMoveDocumentValidations') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                        
				16
				,-- Severity.                        
				1 -- State.                        
				)
	END CATCH
END	
GO


