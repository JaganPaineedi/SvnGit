IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateClientInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdateClientInformation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PostUpdateClientInformation]                 
@ScreenKeyId int,                
@StaffId int,                
@CurrentUser varchar(30),                
@CustomParameters xml   
AS
/******************************************************************** */
/* Stored Procedure: [csp_PostUpdateClientInformation]               */
/* Creation Date:  05/FEB/2015   */
/* Auth:  SuryaBalan    */
/* Purpose: To Update TitleXXNo on Custom */
--Copied from valley to New Directions Customization Task 4

/***********************************************************************/
BEGIN
	BEGIN TRY

			DECLARE @TitleXXNo Varchar(50)
			SET @TitleXXNo = (
			select SUBSTRING(FirstName, 1, 1)+ '9' + SUBSTRING(LastName, 1, 1) 
+ CONVERT(VARCHAR(5), DATEPART(mm,DOB), 114)+ CONVERT(VARCHAR(5), DATEPART(dd,DOB), 114)+ 
RIGHT(CONVERT(VARCHAR(5), DATEPART(yy,DOB), 114),2) + Sex  as TitleXXNo from clients where ClientId =  @ScreenKeyId)
			UPDATE CustomClients SET TitleXXNo = @TitleXXNo where ClientId =  @ScreenKeyId
			
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_PostUpdateClientInformation') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

