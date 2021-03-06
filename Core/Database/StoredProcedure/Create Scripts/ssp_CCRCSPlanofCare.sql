/****** Object:  StoredProcedure [dbo].[ssp_CCRCSPlanofCare]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSPlanofCare]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSPlanofCare] @ClientId BIGINT
	,@ServiceID INT
	,@DocumentVersionId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR MedicationAdministrated Data      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		Select * from Clients Where CLientId =0
	END TRY
		
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSPlanofCare'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END
' 
END
GO
