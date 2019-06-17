/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionGuarantoInformation]    Script Date: 01/29/2019 10:51:17 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderElectronicRequisitionGuarantoInformation]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE dbo.ssp_RDLClientOrderElectronicRequisitionGuarantoInformation
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionGuarantoInformation]    Script Date: 01/29/2019 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClientOrderElectronicRequisitionGuarantoInformation] (
	@DocumentVersionId INT
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
		SELECT ISNULL(CC.LastName + ', ', '') + ISNULL(CC.FirstName, '') AS Name
			,DBO.ssf_GetGlobalCodeNameById(CC.Relationship) AS Relationship
			,(
				SELECT TOP 1 Display
				FROM ClientContactAddresses CCD
				WHERE CCD.ClientContactId = CC.ClientContactId
					AND ISNULL(CCD.RecordDeleted, 'N') = 'N'
				) AS Addresses
			,(
				SELECT TOP 1 CASE 
						WHEN ISNULL(CCP.PhoneNumber, '') <> ''
							THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CCP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CCP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CCP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
						ELSE ''
						END
				FROM ClientContactPhones CCP
				WHERE CCP.ClientContactId = CC.ClientContactId
					AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
				) AS Phone
		FROM Documents d
		JOIN DocumentVersions DV ON d.DocumentId = DV.DocumentId
		JOIN ClientOrders CO ON CO.DocumentVersionId = DV.DocumentVersionId
		JOIN Clients c ON d.ClientId = c.ClientId
		JOIN ClientContacts CC ON CC.ClientId = C.ClientId
		WHERE DV.DocumentVersionId = @DocumentVersionId
			AND ISNULL(d.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CC.FinanciallyResponsible, 'Y') = 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClientOrderElectronicRequisitionGuarantoInformation') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
