/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationPictures]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationPictures]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLDocumentRegistrationPictures]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationPictures]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationPictures (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationPictures.sql                
**  Name: ssp_RDLDocumentRegistrationPictures   3159        
**  Desc: Show Image in Demographics RDL                                  
**  Return values: <Return Values>                                                                 
**  Called by: <Code file that calls>                                                                               
**  Parameters:    @DocumentVersionId                              
**  Input   Output                                  
**  ----    -----------                                                                
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	-----			-------		-----------
	Aug 06 2018		Ravi		Get Picture in Demographics RDL
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document	                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
			
		
		SELECT CP.Picture
		FROM DocumentRegistrationClientPictures CP
		WHERE CP.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CP.Active, 'N') = 'Y' 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationPictures') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
