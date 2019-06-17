
/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationAdditionalInformations]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationAdditionalInformations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLDocumentRegistrationAdditionalInformations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationAdditionalInformations]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationAdditionalInformations (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationAdditionalInformations.sql                
**  Name: ssp_RDLDocumentRegistrationAdditionalInformations           
**  Desc:  Get data for Additional Informations tab Sub report                               
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
	Aug 06 2018		Ravi		Get data for Additional Informations tab Sub report.
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document 	                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
		 
   
		
		SELECT dbo.ssf_GetGlobalCodeNameById(R.Citizenship) AS Citizenship
			,dbo.ssf_GetGlobalCodeNameById(R.EmploymentStatus) AS EmploymentStatus
			,R.BirthPlace
			,R.BirthCertificate
			,dbo.ssf_GetGlobalCodeNameById(R.MilitaryStatus) AS MilitaryStatus
			,dbo.ssf_GetGlobalCodeNameById(R.EducationalLevel) AS EducationalLevel
			,dbo.ssf_GetGlobalCodeNameById(R.JusticeSystemInvolvement) AS  JusticeSystemInvolvement
			,dbo.ssf_GetGlobalCodeNameById(R.EducationStatus) AS EducationStatus
			,R.NumberOfArrestsLast30Days
			,dbo.ssf_GetGlobalCodeNameById(R.Religion) AS Religion
			,dbo.ssf_GetGlobalCodeNameById(R.SmokingStatus) AS  SmokingStatus
			,dbo.ssf_GetGlobalCodeNameById(R.ForensicTreatment) AS  ForensicTreatment
			,dbo.ssf_GetGlobalCodeNameById(R.CriminogenicRiskLevel) AS  CriminogenicRiskLevel
			,dbo.ssf_GetGlobalCodeNameById(R.ScreenForMHSUD) AS  ScreenForMHSUD
			,dbo.ssf_GetGlobalCodeNameById(R.AdvanceDirective) AS  AdvanceDirective
			,dbo.ssf_GetGlobalCodeNameById(R.LivingArrangments) AS  LivingArrangments
			,dbo.ssf_GetGlobalCodeNameById(R.SSISSDStatus) AS  SSISSDStatus
		FROM DocumentRegistrationAdditionalInformations R
		WHERE R.DocumentVersionId = @DocumentVersionId
			AND ISNULL(R.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationAdditionalInformations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END


