/****** Object:  StoredProcedure [dbo].[ssp_SCGetPaymentEOBList]    Script Date: 03/07/2016 11:35:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPaymentEOBList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetPaymentEOBList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPaymentEOBList]    Script Date: 03/07/2016 11:35:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetPaymentEOBList] (
	@PaymentId INT
	)

/********************************************************************************                                                 
** Stored Procedure: ssp_SCGetPaymentEOBList                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 07-MAR-2016	   Akwinass			   What:To Get Payment EOB List      
**									   Why:Task #840 in Renaissance - Dev Items 
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		SELECT ImageRecordId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ScannedOrUploaded
			,DocumentVersionId
			,ImageServerId
			,ClientId
			,AssociatedId
			,AssociatedWith
			,CASE WHEN ISNULL(RecordDescription,'') = '' THEN '[untitled]' ELSE RecordDescription END AS RecordDescription
			,EffectiveDate
			,NumberOfItems
			,AssociatedWithDocumentId
			,AppealId
			,StaffId
			,EventId
			,ProviderId
			,TaskId
			,AuthorizationDocumentId
			,ScannedBy
			,CoveragePlanId
			,ClientDisclosureId
			,ProviderAuthorizationDocumentId
			,BatchId
			,PaymentId
		FROM ImageRecords
		WHERE PaymentId = @PaymentId
			AND ISNULL(RecordDeleted,'N') = 'N'
		ORDER BY ImageRecordId ASC
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCGetPaymentEOBList')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
GO


