/****** Object:  StoredProcedure [dbo].[SSP_CheckClientActive]    Script Date: 07/06/2016 11:35:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_CheckClientActive]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_CheckClientActive]
GO


/****** Object:  StoredProcedure [dbo].[SSP_CheckClientActive]    Script Date: 07/06/2016 11:35:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 Create PROCEDURE [dbo].[SSP_CheckClientActive] @ClientId INT  
AS  
-- =============================================          
-- Author:  Varun          
-- Create date: Jun 02, 2016          
-- Description: Get active status of Client  
 
-- =============================================     
BEGIN TRY  

Declare @Active char
set @Active =  (select Active from Clients where ClientId=@ClientId)
SELECT @Active AS 'ClientActiveStatus'
END TRY  
  
BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
  
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_CheckClientActive') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
 RAISERROR (  
   @Error  
   ,-- Message text.           
   16  
   ,-- Severity.           
   1 -- State.                                                             
   );  
END CATCH  
GO


