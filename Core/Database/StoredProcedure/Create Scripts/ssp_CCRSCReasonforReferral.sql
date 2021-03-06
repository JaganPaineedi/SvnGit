
/****** Object:  StoredProcedure [dbo].[ssp_CCRSCReasonforReferral]    Script Date: 05/15/2013 18:38:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRSCReasonforReferral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRSCReasonforReferral]
GO



/****** Object:  StoredProcedure [dbo].[ssp_CCRSCReasonforReferral]    Script Date: 05/15/2013 18:38:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_CCRSCReasonforReferral] @ClientId BIGINT
	,@ServiceID INT=NULL
	,@DocumentVersionId INT=NULL
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR Reson for Referral Data      
/*      
 Author			Modified Date			Reason      
04 Dec 2018	Ravichandra		What : Renamed from [ProviderName] to [ExternalReferralProviderId] in table ClientPrimaryCareExternalReferrals 
							Why : Engineering Improvement Initiatives- NBL(I) task# 441		   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		IF @ClientId IS NULL
			AND @DocumentVersionId IS NOT NULL
		BEGIN
			SELECT @ClientId = ClientId
			FROM the Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
		END
        SELECT
		COALESCE(dbo.ssf_GetGlobalCodeNameById(ReferralReason1) + ', ' ,'') +  COALESCE(dbo.ssf_GetGlobalCodeNameById(ReferralReason2) + ', ' ,'')  +isnull(dbo.ssf_GetGlobalCodeNameById(ReferralReason3),'') as ReasonforReferral
		FROM ClientPrimaryCareExternalReferrals CP
		INNER JOIN ExternalReferralProviders ER ON CP.ExternalReferralProviderId = ER.ExternalReferralProviderId
		WHERE isnull(CP.Recorddeleted, 'N') = 'N'
			AND isnull(ER.Recorddeleted, 'N') = 'N'
			AND CP.ClientId = @ClientId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CCRSCReasonforReferral') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
