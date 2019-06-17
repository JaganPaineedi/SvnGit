/****** Object:  StoredProcedure [dbo].[SSP_ParseConnectionString]    Script Date: 4/6/2017 2:00:31 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_ParseConnectionString]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_ParseConnectionString]
GO

/****** Object:  StoredProcedure [dbo].[SSP_ParseConnectionString]    Script Date: 4/6/2017 2:00:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SSP_ParseConnectionString] (
       @ServerName VARCHAR(100) OUTPUT ,
       @DBName     VARCHAR(100) OUTPUT
                                      )
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Apr 06, 2016    
-- Description: Parse ReportServerConnection Connection String     
/*      
 Author			Modified Date			Reason      
 
      
*/
-- =============================================    
BEGIN
     BEGIN TRY
         DECLARE @ReportServerConnection VARCHAR(100)= '';

         SELECT @ReportServerConnection = ReportServerConnection
         FROM SystemConfigurations;

         SELECT @ServerName = Token
         FROM dbo.SplitString ( @ReportServerConnection , ';')
         WHERE Token LIKE 'Data Source%';

         SELECT @DBName = Token
         FROM dbo.SplitString ( @ReportServerConnection , ';')
         WHERE Token LIKE 'Initial Catalog%';

         SELECT @ServerName = Token
         FROM dbo.SplitString ( @ServerName , '=')
         WHERE Position = 2;

         SELECT @DBName = Token
         FROM dbo.SplitString ( @DBName , '=')
         WHERE Position = 2;

         SET @ServerName = ISNULL(@ServerName , @@SERVERNAME);
         SET @DBName = ISNULL(@DBName , DB_NAME());
     END TRY
	BEGIN CATCH
	   DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_ParseConnectionString') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


