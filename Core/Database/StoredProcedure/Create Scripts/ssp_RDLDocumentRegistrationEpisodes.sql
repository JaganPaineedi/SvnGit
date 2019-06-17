/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationEpisodes]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationEpisodes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].ssp_RDLDocumentRegistrationEpisodes
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationEpisodes]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationEpisodes (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationEpisodes.sql                
**  Name: ssp_RDLDocumentRegistrationEpisodes           
**  Desc: Get data for Episodes tab Sub report                            
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
	Aug 06 2018		Ravi		Get data for Episodes tab Sub report
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
		SELECT dbo.ssf_GetGlobalCodeNameById(E.Disposition) AS Disposition
			,CONVERT(VARCHAR(10), E.ReferralScreeningDate, 101) AS ReferralScreeningDate
			,LTRIM(RIGHT(CONVERT(VARCHAR(20), E.ReferralScreeningDate, 100), 7)) as ReferralScreeningTime  
			,dbo.ssf_GetGlobalCodeNameById(E.ReferralReason1) AS ReferralReason1
			,dbo.ssf_GetGlobalCodeNameById(E.ReferralReason2) AS ReferralReason2
			,dbo.ssf_GetGlobalCodeNameById(E.ReferralReason3) AS ReferralReason3
			,E.ReferralComment
			,dbo.ssf_GetGlobalCodeNameById(E.ProviderType) AS ProviderType
			,ERP.Name AS ProviderName
			,CONVERT(VARCHAR(10), E.RegistrationDate, 101) AS RegistrationDate
			,Information
			,CONVERT(VARCHAR(10), E.ReferralDate, 101) AS ReferralDate
			,dbo.ssf_GetGlobalCodeNameById(E.ReferralType) AS ReferralType
			,dbo.ssf_GetGlobalCodeNameById(E.ReferralSubtype) AS ReferralSubtype
			,E.ReferralOrganization
			,E.ReferrralPhone
			,E.ReferrralFirstName
			,E.ReferrralLastName
			,E.ReferrralAddress1
			,E.ReferrralAddress2
			,E.ReferrralCity
			,S.StateName AS ReferrralState
			,E.ReferrralZipCode
			,E.ReferrralEmail
			,E.ReferrralComment
			,E.RegistrationComment
		FROM DocumentRegistrationEpisodes AS E
		left join ExternalReferralProviders ERP on ERP.ExternalReferralProviderId = E.ExternalReferralProviderId  AND Isnull(ERP.recorddeleted, 'N') = 'N' 
		left join States s on S.StateAbbreviation = E.ReferrralState
		WHERE E.DocumentVersionId = @DocumentVersionId
			AND ISNULL(E.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationEpisodes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
