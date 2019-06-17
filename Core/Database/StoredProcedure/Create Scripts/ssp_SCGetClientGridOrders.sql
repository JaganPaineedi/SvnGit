IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientGridOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientGridOrders]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientGridOrders] @OrderXML XML
-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 14/MAY/2018
-- Purpose     : To Get ClientGridOrders table.
-- Updates:
-- Date			  Author    Purpose 
-- 14/MAY/2018  Akwinass  Created.(Task #650 in Engineering Improvement Initiatives- NBL(I)) 
/* 03/JUL/2018	Chethan N	What : Added new column LocationId to ClientOrders table.
							Why : Engineering Improvement Initiatives- NBL(I)  task #667*/
/* 14/11/2018	Neha     	What : Added 2 new columns 'Frequency' and 'Start Date' to ClientOrders Grid.
							Why : Engineering Improvement Initiatives- NBL(I)  task #713 */
-- ============================================================================================================================
AS
BEGIN
	BEGIN TRY	
		IF OBJECT_ID('tempdb..#ClientOrders') IS NOT NULL
			DROP TABLE #ClientOrders
		
		IF OBJECT_ID('tempdb..#ClientOrdersDiagnosisIIICodes') IS NOT NULL
			DROP TABLE #ClientOrdersDiagnosisIIICodes

		IF OBJECT_ID('tempdb..#Diagnosis') IS NOT NULL
			DROP TABLE #Diagnosis

		CREATE TABLE #ClientOrders (
			GridClientOrderId INT
			,CreatedBy VARCHAR(100)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(100)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR(1)
			,DeletedBy VARCHAR(100)
			,DeletedDate DATETIME
			,DocumentVersionId INT
			,OrderId INT
			,LaboratoryId INT
			,ClinicalLocation INT
			,LocationId INT
			)

		CREATE TABLE #ClientOrdersDiagnosisIIICodes (
			GridClientOrderId INT
			,ICDCode VARCHAR(100)
			,[Description] VARCHAR(MAX)
			,RecordDeleted CHAR(1)
			)

		CREATE TABLE #Diagnosis (
			GridClientOrderId INT
			,DiagnosisName VARCHAR(max)
			)
		
		INSERT INTO #ClientOrders (
			GridClientOrderId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,DocumentVersionId
			,OrderId
			,LaboratoryId
			,ClinicalLocation
			,LocationId
			)
		SELECT CASE WHEN a.b.value('ClientOrderId[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('ClientOrderId[1]', 'INT') END
			,CASE WHEN a.b.value('CreatedBy[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('CreatedBy[1]', 'VARCHAR(100)') END
			,CASE WHEN a.b.value('CreatedDate[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('CreatedDate[1]', 'DATETIME') END
			,CASE WHEN a.b.value('ModifiedBy[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('ModifiedBy[1]', 'VARCHAR(100)') END
			,CASE WHEN a.b.value('ModifiedDate[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('ModifiedDate[1]', 'DATETIME') END
			,CASE WHEN a.b.value('RecordDeleted[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('RecordDeleted[1]', 'CHAR(1)') END
			,CASE WHEN a.b.value('DeletedBy[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('DeletedBy[1]', 'VARCHAR(100)') END
			,CASE WHEN a.b.value('DeletedDate[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('DeletedDate[1]', 'DATETIME') END
			,CASE WHEN a.b.value('DocumentVersionId[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('DocumentVersionId[1]', 'INT') END
			,CASE WHEN a.b.value('OrderId[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('OrderId[1]', 'INT') END
			,CASE WHEN a.b.value('LaboratoryId[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('LaboratoryId[1]', 'INT') END
			,CASE WHEN a.b.value('ClinicalLocation[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('ClinicalLocation[1]', 'INT') END
			,CASE WHEN a.b.value('LocationId[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('LocationId[1]', 'INT') END
		FROM @OrderXML.nodes('NewDataSet/ClientOrders') a(b)

		INSERT INTO #ClientOrdersDiagnosisIIICodes (
			GridClientOrderId
			,ICDCode
			,[Description]
			,RecordDeleted
			)
		SELECT CASE WHEN a.b.value('ClientOrderId[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('ClientOrderId[1]', 'INT') END
			,CASE WHEN a.b.value('ICDCode[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('ICDCode[1]', 'VARCHAR(100)') END
			,CASE WHEN a.b.value('Description[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('Description[1]', 'VARCHAR(max)') END
			,CASE WHEN a.b.value('RecordDeleted[1]', 'VARCHAR(max)') = '' THEN NULL ELSE a.b.value('RecordDeleted[1]', 'CHAR(1)') END
		FROM @OrderXML.nodes('NewDataSet/ClientOrdersDiagnosisIIICodes') a(b)

		INSERT INTO #Diagnosis(GridClientOrderId,DiagnosisName)
		SELECT D.GridClientOrderId
			,(ICDCode + ' - ' + D.[Description]) AS DiagnosisName
		FROM #ClientOrders AS CO
		LEFT JOIN Orders O ON O.OrderId = CO.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
		LEFT JOIN #ClientOrdersDiagnosisIIICodes D ON D.GridClientOrderId = CO.GridClientOrderId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(CO.RecordDeleted, 'N') = 'N'

		SELECT CO.GridClientOrderId
			,CO.CreatedBy
			,CO.CreatedDate
			,CO.ModifiedBy
			,CO.ModifiedDate
			,CO.RecordDeleted
			,CO.DeletedBy
			,CO.DeletedDate
			,O.OrderName
			,O.OrderId
			,L.LaboratoryName AS LabsName
			,L.LaboratoryId AS LabId
			,REPLACE(REPLACE(STUFF((
							SELECT DISTINCT ', ' + QE.DiagnosisName
							FROM #Diagnosis QE
							WHERE CO.GridClientOrderId = QE.GridClientOrderId
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>') AS DiagnosisName
			,LO.LocationCode AS ClinicalLocationName 
			,OTF.DisplayName AS FrequencyName
			,CONVERT(VARCHAR(10), COO.OrderStartDateTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, COO.OrderStartDateTime, 100), 7)  AS StartDate 
		FROM #ClientOrders AS CO
		JOIN ClientOrders AS COO ON COO.ClientOrderId=CO.GridClientOrderId
		JOIN Orders O ON O.OrderId = CO.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
		LEFT JOIN Laboratories AS L ON L.LaboratoryId = CO.LaboratoryId
			AND ISNULL(L.RecordDeleted, 'N') = 'N'
		 LEFT JOIN Locations LO ON LO.LocationId = CO.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'
		 LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = COO.OrderTemplateFrequencyId
		WHERE ISNULL(CO.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientGridOrders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


