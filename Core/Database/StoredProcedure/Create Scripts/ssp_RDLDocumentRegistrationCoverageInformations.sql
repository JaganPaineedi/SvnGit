
/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationEpisodes]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationCoverageInformations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLDocumentRegistrationCoverageInformations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationCoverageInformations]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationCoverageInformations (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationCoverageInformations.sql                
**  Name: ssp_RDLDocumentRegistrationCoverageInformations           
**  Desc: Get data for Insurance - > Coverage Informations Sub report                    
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
	Aug 06 2018		Ravi		Get data for Insurance - > Coverage Informations Sub report
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document                                    
*******************************************************************************/
BEGIN
	BEGIN TRY
		 
   
		
		SELECT CP.CoveragePlanName
			,RCP.DocumentVersionId
			,RCP.CoveragePlanId
			,RCP.InsuredId
			,RCP.GroupId
			,RCP.Comment
		FROM DocumentRegistrationCoverageInformations AS RCP
		LEFT JOIN CoveragePlans AS CP ON CP.CoveragePlanId = RCP.CoveragePlanId
		WHERE RCP.DocumentVersionId = @DocumentVersionId
			AND isNull(RCP.RecordDeleted, 'N') = 'N'
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationCoverageInformations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
