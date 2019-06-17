
/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationInsurance]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationInsurance]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLDocumentRegistrationInsurance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationInsurance]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationInsurance (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationInsurance.sql                
**  Name: ssp_RDLDocumentRegistrationInsurance           
**  Desc:  Get data for Insurance tab Sub report                      
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
	Aug 06 2018		Ravi		Get data for Insurance tab Sub report
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
		 
   
		
		SELECT R.DocumentVersionId
			,R.CoverageInformation
		FROM DocumentRegistrations R
		WHERE R.DocumentVersionId = @DocumentVersionId
			AND ISNULL(R.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationInsurance') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END

