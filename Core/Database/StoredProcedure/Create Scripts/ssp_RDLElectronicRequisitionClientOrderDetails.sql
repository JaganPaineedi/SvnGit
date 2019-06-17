/****** Object:  StoredProcedure [dbo].[ssp_RDLElectronicRequisitionClientOrderDetails]    Script Date: 01/29/2019 10:51:17 ******/

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLElectronicRequisitionClientOrderDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.ssp_RDLElectronicRequisitionClientOrderDetails
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLElectronicRequisitionClientOrderDetails]    Script Date: 01/29/2019 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLElectronicRequisitionClientOrderDetails] (
	@OrderedPhysician INT
	,@DocumentVersionId INT
	,@LaboratoryId INT
	,@ClientOrderId VARCHAR(max)
	)
	/********************************************************************************************************       
    Report Request:       
     Details ... Gulf Bend - Enhancements > Tasks #211 > CPL - Add Lab    
    
               
    Purpose:    
    Parameters: DocumentVersionId    
    Modified Date   Modified By   Reason       
    ----------------------------------------------------------------       
    Ravi      21/11/2018   Created  Gulf Bend - Enhancements > Tasks #211> CPL - Add Lab    
    ************************************************************************************************************/
AS
BEGIN
	BEGIN TRY
		SELECT CONVERT(VARCHAR(10), CO.OrderStartDateTime, 101) AS CollectionDate
			,LEFT(RIGHT(CONVERT(VARCHAR, CO.OrderStartDateTime, 100), 7), 5) + ' ' + Right(RIGHT(CONVERT(VARCHAR, CO.OrderStartDateTime, 100), 7), 2) AS CollectionTime
			,CO.DocumentVersionId AS ReferenceLabId
			,CO.ClientOrderId
			,O.OrderName
			,DBO.ssf_GetGlobalCodeNameById(CO.OrderPriorityId) AS OrderPriorityId
			,H.OrderCode
			,CO.CommentsText as Comment
		FROM ClientOrders CO
		JOIN Orders O ON O.OrderId = CO.OrderId
		JOIN HealthDataTemplates H ON O.LabId = H.HealthDataTemplateId
		WHERE CO.OrderingPhysician = @OrderedPhysician
			AND CO.DocumentVersionId = @DocumentVersionId
			AND CO.ClientOrderId IN (
				SELECT item
				FROM dbo.fnSplit(@ClientOrderId, ',')
				)
			AND CO.LaboratoryId = @LaboratoryId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLElectronicRequisitionClientOrderDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
