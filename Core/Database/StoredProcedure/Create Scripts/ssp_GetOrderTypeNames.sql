/****** Object:  StoredProcedure [dbo].[ssp_GetOrderTypeNames]    Script Date: 06/21/2016 03:51:55 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrderTypeNames]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetOrderTypeNames]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetOrderTypeNames]    Script Date: 06/21/2016 03:51:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetOrderTypeNames] @OrderName VARCHAR(50)
	,@ScreenType INT = 0
	,@IncludeAdhocOrder BIT = 0
	,@LoggedInUserId VARCHAR(50)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_GetOrderTypeNames]       */
/* Creation Date:  26/June/2013                                      */
/* Purpose: To get OrderNames For Order Entry       */
/* Input Parameters:@@OrderName           */
/* Output Parameters:             */
/* Returns The Table of Orders          */
/* Called By:                                                        */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date   Author    Purpose          */
/* 26/June/2013  S Ganesh  Created             */
/* 10/April/2014  Prasan   added SearchedOrderName,MedicationName             */
/* 3/10/2015      Jeff Riley   Modified - Match against all three names separately */
/* 3/13/2015	  Chethan N	   What: Checking for orders permission for the logged in staff
							   Why: Woods - Customizations task#844*/
/* 06/21/2016	  Shankha	   What: Removed Top 5 restriction for the list
   17/07/2018	  Chethan N		What : Retrieving Laboratory name for the Lab Orders
								and sorting results that start with searched text first, then followed by results with Like match . 
								Why : Engineering Improvement Initiatives- NBL(I)  task #694 
   28/11/2018	  Chethan N		What : Sorting results that start with searched text first, then followed by results with Like match . 
								Why : AHN-Build Cycle Tasks  task #7   */
/* 19/02/2019     Neha			What/Why: Replaced Union All with Union. Gulf Bend Customizations #211 */
/*********************************************************************/
DECLARE @Name VARCHAR(50)
DECLARE @StartWith VARCHAR(50)

SET @Name = '%' + @OrderName + '%'
SET @StartWith = @OrderName + '%'

DECLARE @OrderNameSelection VARCHAR(50) = '';
DECLARE @LoggedInStaffId INT;

SELECT @LoggedInStaffId = StaffId
FROM Staff
WHERE UserCode = @LoggedInUserId

------ Get Permissioned Orders for the logged in Staff ------
CREATE TABLE #PermissionTable (PermissionItemId INT)

INSERT INTO #PermissionTable (PermissionItemId)
EXEC ssp_GetPermisionedOrder @LoggedInStaffId = @LoggedInStaffId

IF @ScreenType = 0
BEGIN
	-- Order Name
	SELECT OrderName, OrderId, AdhocOrder, SearchedOrderName, MedicationName FROM (
		SELECT ORD.OrderId
		,CASE 
			WHEN L.LaboratoryId IS NOT NULL
				THEN ORD.OrderName + ' ('+ ISNULL(LaboratoryName, '') +')'
			ELSE ORD.OrderName
			END + CASE 
			WHEN ORD.AdhocOrder IS NULL
				OR ORD.AdhocOrder = 'N'
				THEN ''
			ELSE ' (Adhoc Order)'
			END AS OrderName
		,ISNULL(ORD.AdhocOrder, 'N') AS AdhocOrder
		,CASE 
			WHEN L.LaboratoryId IS NOT NULL
				THEN ORD.OrderName + ' ('+ ISNULL(LaboratoryName, '') +')'
			ELSE ORD.OrderName
			END + CASE 
			WHEN ORD.AdhocOrder IS NULL
				OR ORD.AdhocOrder = 'N'
				THEN ''
			ELSE ' (Adhoc Order)'
			END AS SearchedOrderName
		,mdn.MedicationName
	FROM Orders ORD
	LEFT OUTER JOIN MDMedicationNames mdn ON mdn.MedicationNameId = ORD.MedicationNameId
		AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
	LEFT JOIN OrderLabs OL ON OL.OrderId = ORD.OrderId AND ISNULL(Isdefault, 'N') = 'Y' AND ISNULL(OL.RecordDeleted, 'N') = 'N'
	LEFT JOIN Laboratories L ON L.LaboratoryId = OL.LaboratoryId AND ISNULL(L.RecordDeleted, 'N') = 'N'
	WHERE (ORD.OrderName LIKE @Name)
		AND ISNULL(ORD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Active, 'Y') = 'Y'
		AND (
			(
				@IncludeAdhocOrder = 0
				AND ISNULL(ORD.AdhocOrder, 'N') <> 'Y'
				AND (
					ISNULL(ORD.Permissioned, 'N') = 'N'
					OR (
						ORD.Permissioned = 'Y'
						AND ORD.OrderId IN (
							SELECT PermissionItemId
							FROM #PermissionTable
							)
						)
					)
				)
			OR (
				@IncludeAdhocOrder = 1
				AND ISNULL(ORD.AdhocOrder, 'N') = 'Y'
				AND @LoggedInUserId = ORD.CreatedBy
				)
			OR (
				@IncludeAdhocOrder = 1
				AND ISNULL(ORD.AdhocOrder, 'N') = 'N'
				)
			)
	-- Alternate Name 1
	
	UNION 
	
	SELECT ORD.OrderId
		,CASE 
			WHEN L.LaboratoryId IS NOT NULL
				THEN ORD.OrderName + ' ('+ ISNULL(LaboratoryName, '') +')'
			ELSE ORD.OrderName
			END + CASE 
			WHEN ORD.AdhocOrder IS NULL
				OR ORD.AdhocOrder = 'N'
				THEN ''
			ELSE ' (Adhoc Order)'
			END AS OrderName
		,ISNULL(ORD.AdhocOrder, 'N') AS AdhocOrder
		,CASE 
			WHEN L.LaboratoryId IS NOT NULL
				THEN ORD.AlternateOrderName1 + ' ('+ ISNULL(LaboratoryName, '') +')'
			ELSE ORD.AlternateOrderName1
			END + CASE 
			WHEN ORD.AdhocOrder IS NULL
				OR ORD.AdhocOrder = 'N'
				THEN ''
			ELSE ' (Adhoc Order)'
			END AS SearchedOrderName
		,mdn.MedicationName
	FROM Orders ORD
	LEFT OUTER JOIN MDMedicationNames mdn ON mdn.MedicationNameId = ORD.MedicationNameId
		AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
	LEFT JOIN OrderLabs OL ON OL.OrderId = ORD.OrderId AND ISNULL(Isdefault, 'N') = 'Y' AND ISNULL(OL.RecordDeleted, 'N') = 'N'
	LEFT JOIN Laboratories L ON L.LaboratoryId = OL.LaboratoryId AND ISNULL(L.RecordDeleted, 'N') = 'N'
	WHERE (ORD.AlternateOrderName1 LIKE @Name)
		AND ISNULL(ORD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Active, 'Y') = 'Y'
		AND (
			(
				@IncludeAdhocOrder = 0
				AND ISNULL(ORD.AdhocOrder, 'N') <> 'Y'
				AND (
					ISNULL(ORD.Permissioned, 'N') = 'N'
					OR (
						ORD.Permissioned = 'Y'
						AND ORD.OrderId IN (
							SELECT PermissionItemId
							FROM #PermissionTable
							)
						)
					)
				)
			OR (
				@IncludeAdhocOrder = 1
				AND ISNULL(ORD.AdhocOrder, 'N') = 'Y'
				AND @LoggedInUserId = ORD.CreatedBy
				)
			OR (
				@IncludeAdhocOrder = 1
				AND ISNULL(ORD.AdhocOrder, 'N') = 'N'
				)
			)
	-- Alternate Name 2
	
	UNION 
	
	SELECT ORD.OrderId
		,CASE 
			WHEN L.LaboratoryId IS NOT NULL
				THEN ORD.OrderName + ' ('+ ISNULL(LaboratoryName, '') +')'
			ELSE ORD.OrderName
			END + CASE 
			WHEN ORD.AdhocOrder IS NULL
				OR ORD.AdhocOrder = 'N'
				THEN ''
			ELSE ' (Adhoc Order)'
			END AS OrderName
		,ISNULL(ORD.AdhocOrder, 'N') AS AdhocOrder
		,CASE 
			WHEN L.LaboratoryId IS NOT NULL
				THEN ORD.AlternateOrderName2 + ' ('+ ISNULL(LaboratoryName, '') +')'
			ELSE ORD.AlternateOrderName2
			END + CASE 
			WHEN ORD.AdhocOrder IS NULL
				OR ORD.AdhocOrder = 'N'
				THEN ''
			ELSE ' (Adhoc Order)'
			END AS SearchedOrderName
		,mdn.MedicationName
	FROM Orders ORD
	LEFT OUTER JOIN MDMedicationNames mdn ON mdn.MedicationNameId = ORD.MedicationNameId
		AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
	LEFT JOIN OrderLabs OL ON OL.OrderId = ORD.OrderId AND ISNULL(Isdefault, 'N') = 'Y' AND ISNULL(OL.RecordDeleted, 'N') = 'N'
	LEFT JOIN Laboratories L ON L.LaboratoryId = OL.LaboratoryId AND ISNULL(L.RecordDeleted, 'N') = 'N'
	WHERE (ORD.AlternateOrderName2 LIKE @Name)
		AND ISNULL(ORD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Active, 'Y') = 'Y'
		AND (
			(
				@IncludeAdhocOrder = 0
				AND ISNULL(ORD.AdhocOrder, 'N') <> 'Y'
				AND (
					ISNULL(ORD.Permissioned, 'N') = 'N'
					OR (
						ORD.Permissioned = 'Y'
						AND ORD.OrderId IN (
							SELECT PermissionItemId
							FROM #PermissionTable
							)
						)
					)
				)
			OR (
				@IncludeAdhocOrder = 1
				AND ISNULL(ORD.AdhocOrder, 'N') = 'Y'
				AND @LoggedInUserId = ORD.CreatedBy
				)
			OR (
				@IncludeAdhocOrder = 1
				AND ISNULL(ORD.AdhocOrder, 'N') = 'N'
				)
			)
			) T
	ORDER BY 
		CASE 
		  WHEN SearchedOrderName LIKE @StartWith THEN 1
		  WHEN SearchedOrderName LIKE @Name THEN 2
		END, SearchedOrderName, MedicationName, AdhocOrder
END
ELSE IF @ScreenType = 1
BEGIN
	SELECT OrderSetId AS OrderId
		,DisplayName AS OrderName
		,'' AS AdhocOrder
		,'' AS SearchedOrderName
		,'' AS MedicationName
	FROM OrderSets
	WHERE DisplayName LIKE @Name
		AND ISNULL(RecordDeleted, 'N') = 'N'
		AND ISNULL(Active, 'Y') = 'Y'
	ORDER BY 
		CASE 
		  WHEN DisplayName LIKE @StartWith THEN 1
		  WHEN DisplayName LIKE @Name THEN 2
		END, DisplayName, OrderId, AdhocOrder, SearchedOrderName, MedicationName
END
GO


