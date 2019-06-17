
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientEducationResourcePDFBytes]    Script Date: 06/13/2015 16:48:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientEducationResourcePDFBytes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientEducationResourcePDFBytes]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientEducationResourcePDFBytes]    Script Date: 06/13/2015 16:48:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************                  
**  File: ssp_GetClientEducationResourcePDFBytes.sql
**  Name: ssp_GetClientEducationResourcePDFBytes
**  Desc: Returns report binary for Client Education Resources
**                  
**  Return values: Image
**                   
**  Called by: SHS.DataServices.PrimaryCare.cs
**                                
**  Parameters:                  
**  Input			Output                  
**  ClientEducationResourceId      -----------                  
**                  
**  Crated By:	Chuck Blaine
**  Date:		Feb 12 2014
*******************************************************************************                  
**  Change History                  
*******************************************************************************                  
**  Date:  Author:    Description:                  
**  --------  --------    -------------------------------------------                  
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_GetClientEducationResourcePDFBytes]
	@ClientEducationResourceId INT
AS 
	BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;
		BEGIN TRY
			SELECT	ResourcePDF
			FROM	dbo.EducationResources AS cer
			WHERE	EducationResourceId = @ClientEducationResourceId
		END TRY
		BEGIN CATCH                                                
			DECLARE	@Error VARCHAR(8000)                                                                                           
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'ssp_GetClientEducationResourcePDFBytes') + '*****'
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

GO

