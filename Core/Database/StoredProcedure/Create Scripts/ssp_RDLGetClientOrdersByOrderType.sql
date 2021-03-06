IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLGetClientOrdersByOrderType]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLGetClientOrdersByOrderType]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLGetClientOrdersByOrderType]    Script Date: 03/18/2014 12:20:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLGetClientOrdersByOrderType] --3021520,'Labs'
	(
	@DocumentVersionId INT = 0
	,@OrderType VARCHAR(50)
	,@OrderingPhysician INT = NULL
	,@LocationId INT = NULL
	)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 18-mar-2014    Revathi      What:Get ClientOrders by OrderType 
                             Why:Philhaven Development #26 Inpatient Order Management
 19-Feb-2015    Gautam       What : The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
						     and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development 
 18-Fab-2016	Ajay	     What: Added CASE to return RationaleText if it is in Rationale other Text.
						     Why: RDL is showing blank if other text is entered.Barry - Support: #287	
 10 Feb 2017	Chethan N	 What : Added new column 'ClinicalLocation' to ClientOrders table.
							 Why : Key Point - Support Go Live task #365
 28 AUG 2018	Akwinass	 What : Level column join (Gc4) is mapped correctly with global codes.
							 Why : StarCare - SmartCareIP #15	
 19 AUG 2018	Neha    	 What : Modified code to pull DisplayName for displaying Frequency on the PDF.
							 Why : Engineering Improvement Initiatives- NBL(I) task #713								
************************************************/
AS
BEGIN
	BEGIN TRY
		SET @LocationId = ISNULL(@LocationId, - 1)

		CREATE TABLE #OrderTypeCount (
			OrderType VARCHAR(50)
			,Counts INT
			)

		INSERT INTO #OrderTypeCount (
			OrderType
			,Counts
			) (
			SELECT
			--Co.OrderType,
			GC.CodeName AS OrderType
			,ISNULL(COUNT(Co.ClientOrderId), 0) FROM ClientOrders Co INNER JOIN Documents D ON D.CurrentDocumentVersionId = Co.DocumentVersionId INNER JOIN DocumentVersions Dv ON Dv.DocumentVersionId = Co.DocumentVersionId INNER JOIN Orders O ON O.OrderId = Co.OrderId LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = O.OrderType WHERE ISNULL(Co.RecordDeleted, 'N') <> 'Y'
			AND Dv.DocumentVersionId = @DocumentVersionId
			AND D.STATUS = 22
			AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(Dv.RecordDeleted, 'N') <> 'Y' GROUP BY GC.CodeName --Co.OrderType
			)
		SELECT DISTINCT Co.ClientOrderId
			,O.OrderName
			,[dbo].[GetGlobalCodeName](Otf.FrequencyId) AS Frequency
			,Co.MedicationDaySupply AS Daysupply
			,CONVERT(VARCHAR, Co.OrderStartDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, Co.OrderStartDateTime, 0), 7)), 7) AS Startdate
			,CASE 
				WHEN RIGHT(CONVERT(VARCHAR, Co.OrderEndDateTime, 100), 8) = ' 12:00AM'
					THEN CONVERT(VARCHAR, Co.OrderEndDateTime, 101)
				ELSE CONVERT(VARCHAR, Co.OrderEndDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, Co.OrderEndDateTime, 0), 7)), 7)
				END AS Enddate
			,Co.MedicationRefill
			,Gc1.CodeName AS Priority
			,CASE 
				WHEN ISNULL(Co.RationaleOtherText, '') = ''
					THEN Co.RationaleText
				ELSE Co.RationaleOtherText
				END AS RationaleText -- Added by: Ajay Date:18.Fab.2016
			,Co.CommentsText AS Comments
			,D.STATUS
			,CASE 
				WHEN ISNULL(O.IsSelfAdministered, 'N') = 'Y'
					THEN 'Yes'
				ELSE 'NO'
				END AS Selfadmin
			,ISNULL(Gc2.CodeName, '') AS Legal
			,ISNULL(Gc4.CodeName, '') AS [Level]
			,S.LastName + ', ' + S.FirstName AS Orderedby
			,S1.LastName + ', ' + S1.FirstName AS Assignedto
			,S2.LastName + ', ' + S2.FirstName AS Physician
			,S2.StaffId AS StaffId
			,G.CodeName AS Orderstatus
			,G1.CodeName AS Ordermode
			,ISNULL(Otf.DisplayName, '') AS OrderFrequency
			,ISNULL((
					SELECT SUM(ISNULL(Ot.Counts, 0))
					FROM #OrderTypeCount Ot
					WHERE Ot.OrderType = 'Labs'
					), 0) AS Labcount
			,ISNULL((
					SELECT SUM(ISNULL(Ot.Counts, 0))
					FROM #OrderTypeCount Ot
					WHERE Ot.OrderType = 'Radiology'
					), 0) AS Radiologycount
			,ISNULL((
					SELECT SUM(ISNULL(Ot.Counts, 0))
					FROM #OrderTypeCount Ot
					WHERE Ot.OrderType = 'Additional'
					), 0) AS Additionalcount
			,ISNULL((
					SELECT SUM(ISNULL(Ot.Counts, 0))
					FROM #OrderTypeCount Ot
					WHERE Ot.OrderType = 'Consults'
					), 0) AS Consultscount
			,ISNULL((
					SELECT SUM(ISNULL(Ot.Counts, 0))
					FROM #OrderTypeCount Ot
					WHERE Ot.OrderType = 'Nursing'
					), 0) AS Nursingcount
			,L.LaboratoryName AS LaboratoryName
			,LC.LocationCode AS ClinicalLocation
			,LC.LocationId
		FROM ClientOrders Co
		JOIN orders AS O ON O.OrderId = Co.OrderId
			AND (ISNULL(O.RecordDeleted, 'N') = 'N')
		INNER JOIN Documents D ON D.CurrentDocumentVersionId = Co.DocumentVersionId
		INNER JOIN DocumentVersions Dv ON Dv.DocumentVersionId = Co.DocumentVersionId
		--LEFT JOIN OrderFrequencies Ofr ON Ofr.OrderFrequencyId = Co.OrderFrequencyId AND ISNULL(Ofr.RecordDeleted, 'N') <> 'Y' 
		LEFT JOIN OrderTemplateFrequencies Otf ON Otf.OrderTemplateFrequencyId = Co.OrderTemplateFrequencyId
			AND ISNULL(Otf.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes Gc1 ON Gc1.GlobalCodeId = Co.OrderPriorityId
			AND ISNULL(Gc1.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes Gc2 ON Gc2.GlobalCodeId = Co.Legal
			AND Gc2.Category = 'XORDERLEGALSTATUS'
			AND ISNULL(Gc2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes Gc4 ON Gc4.GlobalCodeId = Co.[Level]
			AND Gc4.Category = 'XORDERLEVEL'
			AND ISNULL(Gc4.RecordDeleted, 'N') <> 'Y' -- 28 AUG 2018	Akwinass
		INNER JOIN globalcodes AS G ON G.GlobalCodeId = Co.OrderStatus
			AND (ISNULL(G.RecordDeleted, 'N') = 'N')
		LEFT JOIN globalcodes AS G1 ON G1.GlobalCodeId = Co.OrderMode
			AND (ISNULL(G.RecordDeleted, 'N') = 'N')
		INNER JOIN staff S ON S.StaffId = Co.OrderedBy
			AND S.Active = 'Y'
			AND (ISNULL(S.RecordDeleted, 'N') = 'N')
		LEFT JOIN staff S1 ON S1.StaffId = Co.AssignedTo
			AND S1.Active = 'Y'
			AND (ISNULL(S1.RecordDeleted, 'N') = 'N')
		LEFT JOIN staff S2 ON S2.StaffId = Co.OrderingPhysician
			AND S2.Active = 'Y'
			AND (ISNULL(S2.RecordDeleted, 'N') = 'N')
		LEFT JOIN GlobalCOdes OTC ON OTC.GlobalCOdeId = O.OrderType
		LEFT JOIN Laboratories L ON L.LaboratoryId = CO.LaboratoryId
			AND (ISNULL(L.RecordDeleted, 'N') = 'N')
		LEFT JOIN Locations LC ON LC.LocationId = CO.LocationId
		WHERE ISNULL(O.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(Co.RecordDeleted, 'N') <> 'Y'
			AND Dv.DocumentVersionId = @DocumentVersionId
			AND OTC.CodeName = @OrderType
			--AND Co.OrderType = @OrderType
			AND D.STATUS = 22
			AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(Dv.RecordDeleted, 'N') <> 'Y'
			AND (
				@OrderingPhysician IS NULL
				OR Co.OrderingPhysician = @OrderingPhysician
				)
			AND ISNULL(Co.OrderDiscontinued, 'N') = 'N'
			AND ISNULL(Co.DiscontinuedDateTime, '') = ''
			AND (ISNULL(CO.LocationId, - 1) = @LocationId)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLGetClientOrdersByOrderType') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
