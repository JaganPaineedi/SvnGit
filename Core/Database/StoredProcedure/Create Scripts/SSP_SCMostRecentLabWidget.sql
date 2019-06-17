/****** Object:  StoredProcedure [dbo].[SSP_SCMostRecentLabWidget]    Script Date: 8/23/2018 4:33:34 AM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCMostRecentLabWidget]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCMostRecentLabWidget]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCMostRecentLabWidget]    Script Date: 8/23/2018 4:33:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCMostRecentLabWidget]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SSP_SCMostRecentLabWidget] AS'
END
GO

ALTER PROCEDURE [dbo].[SSP_SCMostRecentLabWidget] @LOGINSTAFFID INT
,@SelectedOrderingPhysician INT
AS
/************************************************************************************/
/* Stored Procedure: dbo.[SSP_SCMostRecentLabWidget]      */
/* Creation Date:   06/10/2014                 */
/* Purpose:  Alert widget to notify them that an electronic lab result have come into the system */
/*                        */
/* Input Parameters: @LoginStaffId          */
/* Data Modifications:                */
/*                     */
/* Updates:                   */
/*  Date		Author   Purpose            */
/* 06/10/2014	Gautam   Created         Task #139,Primary Care - Summit Pointe  */
/* 10/28/2014   Gautam   Coded RecordType column Both, Imag and Text based on Document Codes 1616,1617*/
/* 3/13/2015	Chethan N	What: Checking for orders permission for the logged in staff
							Why: Woods - Customizations task#844  */
/* 12/20/2016   Gautam   Added SystemConfigurationKeys and Recodes logic as per task Woods - Support Go Live #390	*/
/* 3/28/2017	Chethan N	What: Retrieving ClientId
							Why: Core Bugs task# 2367   */
/* 08/24/2017   Shankha   What : Added SystemConfigurationKeys 'AllowLabResultsToShowOnClientPrimaryClinicianWidget'
						  Why : CCC-Environmental Issues task #122*/
/* 10/16/2018	Chethan N	What: Added Recodes logic to get Lab Results and removed all existing logics
							Why: CCC-Customizations task# 83   */
/************************************************************************************/
BEGIN
	BEGIN TRY
		/*                          MostRecentLab             */
		/*       Start         */
		DECLARE @LabsWidgetLookbackMonths INT = 3
		DECLARE @AllowOnClientPrimaryPhysicianWidget VARCHAR(10) = 'No'
		DECLARE @AllowLabResultsToShowOnClientPrimaryClinicianWidget VARCHAR(10) = 'No'
		
		DECLARE @OrderingPhysician CHAR(1)
		DECLARE @PermissionTemplateId INT

		SELECT @LabsWidgetLookbackMonths = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'LabsWidgetLookbackMonths'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		--12/20/2016   Gautam 
		SELECT @AllowOnClientPrimaryPhysicianWidget = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowLabResultsToShowOnClientPrimaryPhysicianWidget'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @AllowLabResultsToShowOnClientPrimaryClinicianWidget = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowLabResultsToShowOnClientPrimaryClinicianWidget'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		CREATE TABLE #WidgetFlowSheetLab (
			DateResulted VARCHAR(12)
			,ClientName VARCHAR(120)
			,OrderName VARCHAR(500)
			,ClientOrderId INT
			,OrderDate VARCHAR(12)
			,OrderType VARCHAR(50)
			,RecordType VARCHAR(50)
			,ClientId INT
			,OrderStatus VARCHAR(50)
			,FontClass VARCHAR(10) 
			)

		------ Get Permissioned Orders for the logged in Staff ------		
		CREATE TABLE #PermissionTable (PermissionItemId INT)

		INSERT INTO #PermissionTable (PermissionItemId)
		EXEC ssp_GetPermisionedOrder @LoggedInStaffId = @LoginStaffId
		
		SELECT TOP 1 @PermissionTemplateId =  GlobalCodeID
		FROM GlobalCodes
		WHERE Code = 'Ordering Physician'
			AND Category = 'STAFFLIST'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT @OrderingPhysician = CASE 
				WHEN EXISTS (
						SELECT 1
						FROM ViewStaffPermissions vs
						WHERE vs.permissionitemid = @PermissionTemplateId
							AND vs.StaffId = @LOGINSTAFFID
							AND vs.PermissionTemplateType = 5704
						)
					THEN 'Y'
				ELSE 'N'
				END 

		INSERT INTO #WidgetFlowSheetLab
		-- Display Orders to doctor that incoming labs are available for him to review            
		SELECT convert(VARCHAR, CO.FlowSheetDateTime, 101) AS 'DateResulted'
			,C.LastName + ', ' + C.FirstName AS 'ClientName'
			,Isnull(O.OrderName, '') AS 'OrderName'
			,CO.ClientOrderId
			,convert(VARCHAR, CO.OrderStartDateTime, 101) AS 'OrderDate'
			,'Lab' AS 'OrderType'
			,'' AS 'RecordType'
			,C.ClientId
			,GC.CodeName AS OrderStatus
			,'' AS FontClass 
		FROM ClientOrders CO
		INNER JOIN Orders O ON CO.OrderId = O.OrderId
			AND (ISNULL(CO.RecordDeleted, 'N') = 'N')
		INNER JOIN Clients C ON CO.ClientId = C.ClientId
			AND (ISNULL(C.RecordDeleted, 'N') = 'N')
		JOIN GlobalCodes GC ON GC.GlobalCodeId = CO.OrderStatus
		WHERE 
		Cast(ISNULL(CO.OrderStartDateTime, DATEADD(DAY, 1, GETDATE())) AS DATE) >= dateadd(mm, - @LabsWidgetLookbackMonths, cast(getdate() AS DATE))
			AND (
				CO.OrderingPhysician = @SelectedOrderingPhysician
				OR CO.AssignedTo = @LOGINSTAFFID
				)
			AND O.OrderType = 6481
			--AND CO.OrderStatus = 6504 -- Results Obtained(6504)     
			AND ( EXISTS(
					SELECT 1
					FROM Recodes R
					JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
					WHERE RC.CategoryCode = 'LABWIDGETDRSTATUS'
						AND R.IntegerCodeId = CO.OrderStatus
						AND ISNULL(R.RecordDeleted, 'N') = 'N'
						AND @OrderingPhysician = 'Y'
					) 
					OR EXISTS(
					SELECT 1
					FROM Recodes R
					JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
					WHERE RC.CategoryCode = 'LABWIDGETRNSTATUS'
						AND R.IntegerCodeId = CO.OrderStatus
						AND ISNULL(R.RecordDeleted, 'N') = 'N'
						AND @OrderingPhysician = 'N'
					) 
				)
			AND CO.ReviewedFlag IS NULL
			AND (ISNULL(O.RecordDeleted, 'N') = 'N')
			AND (
				ISNULL(O.Permissioned, 'N') = 'N'
				OR (
					O.Permissioned = 'Y'
					AND O.OrderId IN (
						SELECT PermissionItemId
						FROM #PermissionTable
						)
					)
				)
		
		UNION
		
		SELECT DISTINCT convert(VARCHAR, IR.EffectiveDate, 101) AS 'DateResulted'
			,C.LastName + ', ' + C.FirstName AS 'ClientName'
			,Isnull(O.OrderName, '') AS 'OrderName'
			,CO.ClientOrderId
			,convert(VARCHAR, CO.OrderStartDateTime, 101) AS 'OrderDate'
			,'Radiology' AS 'OrderType'
			,IR.AssociatedId AS 'RecordType'
			,C.ClientId
			,GC.CodeName AS OrderStatus
			,'' AS FontClass 
		FROM ClientOrders CO
		INNER JOIN Orders O ON CO.OrderId = O.OrderId
			AND (ISNULL(CO.RecordDeleted, 'N') = 'N')
		INNER JOIN Clients C ON CO.ClientId = C.ClientId
			AND (ISNULL(C.RecordDeleted, 'N') = 'N')
		INNER JOIN ImageRecords IR ON CO.DocumentVersionId = IR.DocumentVersionId
			AND (ISNULL(IR.RecordDeleted, 'N') = 'N')
		JOIN GlobalCodes GC ON GC.GlobalCodeId = CO.OrderStatus
		WHERE Cast(ISNULL(CO.OrderStartDateTime, DATEADD(DAY, 1, GETDATE())) AS DATE) >= dateadd(mm, - @LabsWidgetLookbackMonths, cast(getdate() AS DATE))
			AND (
				CO.OrderingPhysician = @SelectedOrderingPhysician
				OR CO.AssignedTo = @LOGINSTAFFID
				)
			AND O.OrderType = 6482 --ORDERTYPE- Radiology(6482)      
			AND ( EXISTS(
					SELECT 1
					FROM Recodes R
					JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
					WHERE RC.CategoryCode = 'LABWIDGETDRSTATUS'
						AND R.IntegerCodeId = CO.OrderStatus
						AND ISNULL(R.RecordDeleted, 'N') = 'N'
						AND @OrderingPhysician = 'Y'
					) 
					OR EXISTS(
					SELECT 1
					FROM Recodes R
					JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
					WHERE RC.CategoryCode = 'LABWIDGETRNSTATUS'
						AND R.IntegerCodeId = CO.OrderStatus
						AND ISNULL(R.RecordDeleted, 'N') = 'N'
						AND @OrderingPhysician = 'N'
					) 
				)       
			AND CO.ReviewedFlag IS NULL
			AND (ISNULL(O.RecordDeleted, 'N') = 'N')
			AND (
				ISNULL(O.Permissioned, 'N') = 'N'
				OR (
					O.Permissioned = 'Y'
					AND O.OrderId IN (
						SELECT PermissionItemId
						FROM #PermissionTable
						)
					)
				)
		ORDER BY DateResulted DESC

		UPDATE W
		SET W.RecordType = 'Both'
		FROM #WidgetFlowSheetLab W
		WHERE EXISTS (
				SELECT 1
				FROM #WidgetFlowSheetLab WT
				WHERE W.ClientOrderId = WT.ClientOrderId
					AND WT.RecordType = '1616'
				)
			AND EXISTS (
				SELECT 1
				FROM #WidgetFlowSheetLab WT
				WHERE W.ClientOrderId = WT.ClientOrderId
					AND WT.RecordType = '1617'
				)

		UPDATE W
		SET W.RecordType = 'Image'
		FROM #WidgetFlowSheetLab W
		WHERE EXISTS (
				SELECT 1
				FROM #WidgetFlowSheetLab WT
				WHERE W.ClientOrderId = WT.ClientOrderId
					AND WT.RecordType = '1616'
				)
			AND NOT EXISTS (
				SELECT 1
				FROM #WidgetFlowSheetLab WT
				WHERE W.ClientOrderId = WT.ClientOrderId
					AND WT.RecordType = '1617'
				)

		UPDATE W
		SET W.RecordType = 'Text'
		FROM #WidgetFlowSheetLab W
		WHERE EXISTS (
				SELECT 1
				FROM #WidgetFlowSheetLab WT
				WHERE W.ClientOrderId = WT.ClientOrderId
					AND WT.RecordType = '1617'
				)
			AND NOT EXISTS (
				SELECT 1
				FROM #WidgetFlowSheetLab WT
				WHERE W.ClientOrderId = WT.ClientOrderId
					AND WT.RecordType = '1616'
				)       
          
  UPDATE WT  
  SET WT.FontClass = CASE Flag 
						WHEN 'L'  THEN 'RED'
						WHEN 'H'  THEN 'RED'
						ELSE '' END--GC.Color      
  FROM #WidgetFlowSheetLab WT      
  JOIN ClientOrderResults COR ON COR.ClientOrderId = WT.ClientOrderId         
   AND (ISNULL(COR.RecordDeleted, 'N') = 'N')         
  JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId         
   AND (ISNULL(COO.RecordDeleted, 'N') = 'N') 

		SELECT DISTINCT DateResulted
			,ClientName
			,OrderName
			,ClientOrderId
			,OrderDate
			,OrderType
			,RecordType
			,ClientId
			,OrderStatus
			,FontClass
		FROM #WidgetFlowSheetLab
		ORDER BY DateResulted DESC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCMostRecentLabWidget') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                           
				16
				,
				-- Severity.                                                                                           
				1
				-- State.     
				);
	END CATCH
END
GO


