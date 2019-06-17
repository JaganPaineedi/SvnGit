
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryReasonForReferral]    Script Date: 06/09/2015 05:24:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLTransitionCareSummaryReasonForReferral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryReasonForReferral]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryReasonForReferral]    Script Date: 06/09/2015 05:24:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryReasonForReferral] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
	/******************************************************************************                      
  **  File: ssp_RDLTransitionCareSummaryReasonForReferral.sql    
  **  Name: ssp_RDLTransitionCareSummaryReasonForReferral    
  **  Desc:     
  **                      
  **  Return values: <Return Values>                     
  **                       
  **  Called by: <Code file that calls>                        
  **                                    
  **  Parameters:                      
  **  Input   Output                      
  **  ClientId      -----------                      
  **                      
  **  Created By: Veena S Mani    
  **  Date:  Feb 25 2014    
  *******************************************************************************                      
  **  Change History                      
  *******************************************************************************                      
  **  Date:  Author:    Description:                      
  **  --------  --------    -------------------------------------------     
  **  22/10y/2014   Veena S Mani      Created            
  *******************************************************************************/
	BEGIN TRY
	IF @ClientId is null and @DocumentVersionId is not null
	BEGIN
	Select @ClientId= ClientId from Documents where InProgressDocumentVersionId=@DocumentVersionId
	END
	Select
	COALESCE(dbo.ssf_GetGlobalCodeNameById(ReferralReason1) + ', ' ,'') +  COALESCE(dbo.ssf_GetGlobalCodeNameById(ReferralReason2) + ', ' ,'')  +isnull(dbo.ssf_GetGlobalCodeNameById(ReferralReason3),'') as ReasonforReferral,
	ER.Name as Provider,
	ER.PhoneNumber,
	--ER.Address + ' '+ ER.City + ' '+ ER.[State] as [Address],
	CP.ProviderInformation as [Address],
	CP.ReasonComment as Comment 
	from ClientPrimaryCareExternalReferrals CP join ExternalReferralProviders ER on CP.ProviderName=ER.ExternalReferralProviderId
	where isnull(CP.Recorddeleted,'N')<>'Y' and isnull(ER.Recorddeleted,'N')<>'Y' and CP.ClientId=@ClientId
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCurrentMedicationlist') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

