/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInternalCollectionDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetInternalCollectionDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetInternalCollectionDetails] @CollectionId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetInternalCollectionDetails   137           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    11/AUG/2015                                         */
/*                                                                   */
/* Purpose:  Used in getdata() for Internal Collection Detail Page  */
/*                                                                   */
/* Input Parameters: @InternalCollectionId   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
-- 11-Dec-2015		 Venkatesh				 Get the current client balance. ref Task 936.2 in Valley Customization
/*********************************************************************/
BEGIN
	BEGIN TRY		
		SELECT [CollectionId]
			,IC.[CreatedBy]
			,IC.[CreatedDate]
			,IC.[ModifiedBy]
			,IC.[ModifiedDate]
			,IC.[RecordDeleted]
			,IC.[DeletedBy]
			,IC.[DeletedDate]
			,IC.[ClientId]
			,IC.[ClientNotReceiveServices]
			,IC.[NeedUpdatedAddress]
			,IC.[BalanceAmountToReachResolution]
			,IC.[CollectionStatus]
			,IC.[PaymentArrangementStartDate]
			,IC.[PaymentArrangementActive]
			,IC.[PaymentArrangementDelinquent]
			,IC.[PaymentPlanAmount]
			,IC.[PaymentFrequency]
			,IC.[NextPaymentDue]
			,IC.[PaymentArrangementComments]
			,CAST(C.CurrentBalance as DECIMAL(18,2))   as CurrentBalance  
		FROM [Collections] IC
		LEFT JOIN Clients C ON C.ClientId=IC.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N'
		WHERE CollectionId = @CollectionId
		AND ISNULL(IC.RecordDeleted, 'N') = 'N'

		SELECT CSH.[CollectionStatusHistoryId]
			,CSH.[CreatedBy]
			,CSH.[CreatedDate]
			,CSH.[ModifiedBy]
			,CSH.[ModifiedDate]
			,CSH.[RecordDeleted]
			,CSH.[DeletedBy]
			,CSH.[DeletedDate]
			,CSH.[CollectionId]
			,CSH.[CollectionDate]
			,CSH.[CollectionStatus]
			,CSH.[Balance]
			,CSH.[IsDeletable]
			,ISNULL(GC.CodeName, '-- None --') AS CollectionStatusText
		FROM [CollectionStatusHistory] CSH
		JOIN [Collections] C ON CSH.CollectionId = C.CollectionId
		LEFT JOIN GlobalCodes GC ON CSH.CollectionStatus = GC.GlobalCodeId
		WHERE CSH.CollectionId = @CollectionId
			AND ISNULL(CSH.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'

		SELECT CL.[CollectionLetterId]
			,CL.[CreatedBy]
			,CL.[CreatedDate]
			,CL.[ModifiedBy]
			,CL.[ModifiedDate]
			,CL.[RecordDeleted]
			,CL.[DeletedBy]
			,CL.[DeletedDate]
			,CL.[CollectionId]
			,CL.[LetterId]
			,L.LetterTemplateId
			,L.SentOn
			,L.LetterText
			,LT.TemplateName
		FROM [CollectionLetters] CL
		JOIN [Letters] L ON CL.LetterId = L.LetterId
		JOIN [LetterTemplates] LT ON L.LetterTemplateId = LT.LetterTemplateId
		WHERE CL.CollectionId = @CollectionId
			AND ISNULL(CL.RecordDeleted, 'N') = 'N'
			AND ISNULL(L.RecordDeleted, 'N') = 'N'
			AND ISNULL(LT.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetInternalCollectionDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


