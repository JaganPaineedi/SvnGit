/****** Object:  StoredProcedure [dbo].[ssp_MedicationReconciliationDocumentVersions]    Script Date: 05/19/2016 14:53:13 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MedicationReconciliationDocumentVersions]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_MedicationReconciliationDocumentVersions]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MedicationReconciliationDocumentVersions]    Script Date: 05/19/2016 14:53:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_MedicationReconciliationDocumentVersions] @ClientId INT
AS
/******************************************************************************                
**  File:                 
**  Name: ssp_MedicationReconciliationDocumentVersions                
**  Desc: Retrieves a list of document versions for select client based on   
**   last signed document per documentcodeid  
**           
**                
**  Return values: List of DocumentVersionId, Name                
**                 
**  Called by:                   
**                              
**  Parameters:                
**  Input       Output                
**     ----------       -----------                
**                
**  Auth: Kneale Alpers                
**  Date: Dec 12, 2011                
*******************************************************************************                
**  Change History                
*******************************************************************************                
**  Date:  Author:    Description:                
**  --------  --------    -------------------------------------------                
**  15-Sep-2017  Arjun K R    Isnull() is added to  NAME in select statement. Task #26.1 MeaningfulUse Stage3
**  11-Oct-2017	 Alok Kumar		Commented records NOT EXISTS cheking for ClientMedicationReconciliations	Ref: task#26.2/26.3 MeaningfulUse Stage3.
*******************************************************************************/
SELECT cast(b.CurrentDocumentVersionId AS VARCHAR(30)) AS DocumentVersionId
	,CASE CCD.FileType
		WHEN 8807
			THEN -- Pharmacy Interface  
				RTRIM(V.VendorName)
		ELSE RTRIM(a.DocumentName)
		END + ' - ' +
	-- isnull(CONVERT(VARCHAR(10), c.SignatureDate, 101), convert(VARCHAR(10), b.EffectiveDate, 101)) + ' - ' + isnull(ltrim(substring(rtrim(right(convert(VARCHAR(26), c.SignatureDate, 100), 7)), 0, 6) + ' ' + right(convert(VARCHAR(26), c.SignatureDate, 109), 2)), ltrim(substring(rtrim(right(convert(VARCHAR(26), b.EffectiveDate, 100), 7)), 0, 6) + ' ' + right(convert(VARCHAR(26), b.EffectiveDate, 109), 2)))   
	isnull(convert(VARCHAR(10), hl7.CreatedDate, 101) + ' - ' + ltrim(substring(rtrim(right(convert(VARCHAR(26), hl7.CreatedDate, 100), 7)), 0, 6) + ' ' + right(convert(VARCHAR(26), hl7.CreatedDate, 109), 2)) + ' (' + hl7.MedicationName + ')' + CASE 
		WHEN HL7.STATUS = 2164
			THEN ' - Discontinued '
		ELSE ''
		END,'') AS NAME
	,ccd.ClientCCDId AS ClientCCDId
FROM documentcodes a
INNER JOIN documents b ON (
		a.DocumentCodeId = b.DocumentCodeId
		AND ISNULL(b.RecordDeleted, 'N') = 'N'
		AND b.STATUS = '22'
		)
INNER JOIN dbo.DocumentSignatures c ON (
		b.DocumentId = c.DocumentId
		AND ISNULL(c.RecordDeleted, 'N') = 'N'
		)
INNER JOIN dbo.ClientCCDs ccd ON (
		ccd.DocumentVersionId = b.CurrentDocumentVersionId
		AND ISNULL(ccd.RecordDeleted, 'N') = 'N'
		)
LEFT JOIN dbo.HL7DocumentInboundMessageMappings HL7 ON (
		HL7.DocumentVersionId = ccd.DocumentVersionId
		AND ISNULL(HL7.RecordDeleted, 'N') = 'N'
		)
LEFT JOIN dbo.HL7CPQueueMessages Q ON (
		Q.HL7CPQueueMessageID = HL7.HL7CPQueueMessageID
		AND ISNULL(Q.RecordDeleted, 'N') = 'N'
		)
LEFT JOIN dbo.HL7CPVendorConfigurations V ON (
		V.VendorId = Q.CPVendorConnectorID
		AND ISNULL(V.RecordDeleted, 'N') = 'N'
		)
WHERE b.ClientId = @ClientId
	AND ISNULL(a.RecordDeleted, 'N') = 'N'
	AND ISNULL(a.MedicationReconciliationDocument, 'N') = 'Y'
	AND DATEDIFF(MONTH, b.EffectiveDate, Getdate()) <= 3
	--AND NOT EXISTS (
	--	SELECT 1
	--	FROM ClientMedicationReconciliations CM
	--	WHERE CM.DocumentVersionId = b.CurrentDocumentVersionId
	--		AND ISNULL(CM.RecordDeleted, 'N') = 'N'
	--		AND NOT EXISTS (
	--			SELECT 1
	--			FROM dbo.HL7DocumentInboundMessageMappings HL71
	--			WHERE HL71.DocumentVersionId = CM.DocumentVersionId
	--				AND HL71.STATUS = 2164
	--				AND ISNULL(HL71.RecordDeleted, 'N') = 'N'
	--			)
	--	)
ORDER BY ccd.ClientCCDId DESC
GO


