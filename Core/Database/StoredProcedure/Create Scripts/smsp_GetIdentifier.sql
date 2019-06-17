/****** Object:  StoredProcedure [dbo].[smsp_GetIdentifier]    Script Date: 09/27/2017 15:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetIdentifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetIdentifier]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetIdentifier]    Script Date: 09/27/2017 15:36:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetIdentifier]  @ClientId INT
, @Type VARCHAR(10)
, @FromDate DATETIME
, @ToDate DATETIME
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Sep 27, 2017      
-- Description: Retrieves Patient details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)     
/*      
 Author			Modified Date			Reason     
*/
-- =============================================      
BEGIN
	BEGIN TRY
	
	SET NOCOUNT ON		
	SELECT @JsonResult = dbo.smsf_FlattenedJSON((
		SELECT 'Official' as [Use] --Usual, Official, Temp, Secondary
			,'TAX' AS [Type] --DL, PPN, BRN, MR, MCN, EN, TAX, NIIP, PRN, MD, DR, ACSN					
			,'' as [System]
			,SSN as Value
			,CreatedDate AS Start	--Period
			,DeletedDate AS [End]	--Period
			,'' as Assigner
			FROM Clients WHERE ClientId = @ClientId
			AND Active = 'Y' 
			AND ISNULL(RecordDeleted,'N')='N'
			FOR XML path
			,ROOT
			))
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetIdentifier') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END

GO


