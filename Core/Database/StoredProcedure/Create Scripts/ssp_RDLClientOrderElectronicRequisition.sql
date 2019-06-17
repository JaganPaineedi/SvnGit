/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisition]    Script Date: 01/29/2019 10:51:17 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderElectronicRequisition]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE dbo.ssp_RDLClientOrderElectronicRequisition
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisition]    Script Date: 01/29/2019 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClientOrderElectronicRequisition] (
	@DocumentVersionId INT = NULL
	,@ClientOrderId INT = NULL
	)
AS
/********************************************************************************************************     
    Report Request:     
     Details ... Gulf Bend - Enhancements > Tasks #211 > CPL - Add Lab  
  
             
    Purpose:  
    Parameters: DocumentVersionId  
    Modified Date   Modified By   Reason     
    ----------------------------------------------------------------     
    Ravi      21/11/2018   Created  Gulf Bend - Enhancements > Tasks #211> CPL - Add Lab  
    ************************************************************************************************************/
BEGIN
	BEGIN TRY
	DECLARE @OrderNumber varchar(300)
	DECLARE @ClientOrderIds varchar(500)
	
	SELECT @OrderNumber=OrderNumber
	FROM ClientOrderOrderNumbers
	WHERE ClientOrderId=@ClientOrderId
	
	
	
	select TOP 1 @ClientOrderIds=ISNULL(STUFF((SELECT ',' + CAST(ISNULL(D.ClientOrderId,'') AS VARCHAR)
      FROM ClientOrderOrderNumbers D   
       where Doc.OrderNumber=D.OrderNumber  
      FOR XML PATH('')
      ,type ).value('.', 'nvarchar(max)'), 1, 1, ''), '') 
    FROM ClientOrderOrderNumbers Doc   
    where Doc.OrderNumber=@OrderNumber
    
	
		DECLARE @Account VARCHAR(max)
		DECLARE @AgencyName VARCHAR(max)

		SELECT TOP 1 @AgencyName = AddressDisplay
		FROM Agency

		SELECT TOP 1 @Account = HL.SendingFacility
		FROM ClientOrders CO
		JOIN Laboratories L ON CO.LaboratoryId = L.LaboratoryId
		JOIN HL7CPVendorConfigurations HL ON HL.VendorId = L.VendorId
		WHERE (
				CO.DocumentVersionId = @DocumentVersionId
				OR CO.ClientOrderId = @ClientOrderId
				)

		DECLARE @Network VARCHAR(max)

		SELECT TOP 1 @Network = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'CPLNetworkNode'

		SELECT @AgencyName AS AgencyName
			,@Account AS Account
			,COI.BarCodeImage
			,COI.OrderNumber
			,@Network AS Network
			,LB.LaboratoryName
			,LB.LaboratoryId
			,OrderingPhysician AS OrderedPhysician
			,ISNULL(S.LastName + ', ', '') + ISNULL(S.FirstName, '') AS OrderedName
			,CONVERT(VARCHAR(10), CO.OrderStartDateTime, 101) AS CollectionDate
			,LEFT(RIGHT(CONVERT(VARCHAR, CO.OrderStartDateTime, 100), 7), 5) + ' ' + Right(RIGHT(CONVERT(VARCHAR, CO.OrderStartDateTime, 100), 7), 2) AS CollectionTime
			,COI.OrderNumber AS ReferenceLabId
			,ISNULL(STUFF((
						SELECT ',' + ISNULL(SL.LicenseNumber, '')
						FROM StaffLicenseDegrees SL
						WHERE S.StaffId = SL.StaffId
							AND SL.LicenseTypeDegree = 9408 -- NPI Number    
							AND ISNULL(SL.RecordDeleted, 'N') = 'N'
						FOR XML PATH('')
							,type
						).value('.', 'nvarchar(max)'), 1, 2, ' '), '') AS NPINumber
			,CO.ClientOrderId
			,O.OrderName
			,DBO.ssf_GetGlobalCodeNameById(CO.OrderPriorityId) AS OrderPriorityId
			,CO.DocumentVersionId AS DocumentVersionId
			,@ClientOrderIds AS ClientOrderIds
		FROM ClientOrderOrderNumbers COI 
		JOIN ClientOrders CO on  COI.ClientOrderId = CO.ClientOrderId
		JOIN Orders O ON O.OrderId = CO.OrderId
		JOIN Laboratories LB ON CO.LaboratoryId = LB.LaboratoryId
		JOIN Staff S ON CO.OrderingPhysician = S.StaffId
				
		WHERE 
				COI.OrderNumber = @OrderNumber	
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(LB.RecordDeleted, 'N') = 'N'
			AND ISNULL(COI.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClientOrderElectronicRequisition') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
