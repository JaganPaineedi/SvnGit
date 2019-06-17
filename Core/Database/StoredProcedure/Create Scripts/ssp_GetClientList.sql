/****** Object:  StoredProcedure [dbo].[ssp_GetClientList]    ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_GetClientList]')
					AND type IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE [dbo].[ssp_GetClientList] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientList] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_GetClientList]
AS 
	BEGIN                   
/***********************************************************************************************************************                       
**  Name: [ssp_GetClientList]                        
**  Desc:      
************************************************************************************************************************                        
**  Change History                        
************************************************************************************************************************                       
**  Date:            Author:      Description:                        
**  10 July 2017    Vijay        Created as Part of new requirement - Task # 28.1, Meaningful Use - Stage 3
************************************************************************************************************************/
                     
		BEGIN TRY      
			--select count(clientId) from clients where ClientId = 94897
 			SELECT ClientId, LastName + ', ' + FirstName as ClientName FROM Clients 
			WHERE Active = 'Y' and ISNULL(RecordDeleted,'N')='N' 
		 			
		END TRY                                                                        
		
		BEGIN CATCH                              
			DECLARE	@Error VARCHAR(8000)                                                                           
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'ssp_GetClientList') + '*****'
				+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
				+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
				+ CONVERT(VARCHAR, ERROR_STATE())                                                      
			RAISERROR                                                                                                         
 (                                                                           
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                                                                                        
  1 -- State.                                                                                                        
 );                                                                                                      
		END CATCH                                                     
	END                                                           
  
  
  