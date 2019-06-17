/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionClientInformation]    Script Date: 01/29/2019 10:51:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderElectronicRequisitionClientInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.ssp_RDLClientOrderElectronicRequisitionClientInformation
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionClientInformation]    Script Date: 01/29/2019 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClientOrderElectronicRequisitionClientInformation] (@DocumentVersionId INT)
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
		SELECT DISTINCT c.ClientId
			,CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.FirstName, '') + ' ' + ISNULL(C.MiddleName, '') + ' ' + ISNULL(C.LastName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END + ' ' + ISNULL(c.Suffix, '') AS ClientName
			,(
				SELECT TOP 1 CASE 
						WHEN ISNULL(cp.PhoneNumber, '') <> ''
							THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
						ELSE ''
						END
				FROM ClientPhones cp
				WHERE cp.ClientId = c.ClientId
					AND ISNULL(cp.RecordDeleted, 'N') = 'N'
					AND cp.PhoneType = 30 --home    
				) AS ClientPhoneNumber
			,(
				SELECT TOP 1 CASE 
						WHEN ISNULL(cp.PhoneNumber, '') <> ''
							THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
						ELSE ''
						END
				FROM ClientPhones cp
				WHERE cp.ClientId = c.ClientId
					AND ISNULL(cp.RecordDeleted, 'N') = 'N'
					AND cp.PhoneType = 31 --Business     
				) AS ClientBusinessNumber
			,CD.[Address] AS ClientAddress
			,CD.City
			,CD.[State]
			,CD.Zip
			,CASE 
				WHEN C.Sex = 'M'
					THEN 'Male'
				WHEN C.Sex = 'M'
					THEN 'Male'
				END Gender
			,'***-**-' + SUBSTRING(ssn, (len(C.ssn) - 4), 4) AS SSN
			,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB
		FROM Documents d
		JOIN DocumentVersions DV ON d.DocumentId = DV.DocumentId
		JOIN ClientOrders CO ON CO.DocumentVersionId = DV.DocumentVersionId
		JOIN Clients c ON d.ClientId = c.ClientId
		LEFT JOIN ClientAddresses CD ON CD.ClientId = C.ClientId
			AND CD.AddressType = 90 -- 90 home        
			AND ISNULL(CD.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(d.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND CO.DocumentVersionId = @DocumentVersionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClientOrderElectronicRequisitionClientInformation') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
