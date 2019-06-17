/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardGetAdmissionOrderClients]    Script Date: 07/01/2014 14:07:32 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebBedBoardGetAdmissionOrderClients]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebBedBoardGetAdmissionOrderClients]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardGetAdmissionOrderClients]    Script Date: 07/01/2014 14:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebBedBoardGetAdmissionOrderClients] @ClientId INT
	,@OrderType VARCHAR(10)
AS
/*********************************************************************/
/* Created By Deej on 22nd August-2013								*/
/* Purpose:   Populate the Clients based on the Admission Order     */
-- 24-09-2013   Akwinass  Modified for Admission Order              */
-- 30-09-2013   Akwinass  Replaced CName as ClientName              */
-- 03-01-2013   Akwinass  Implemented Order By Clause               */
-- 03-MAR-2014  Akwinass  Included active and record deleted check for clientOrders, Orders, Clients and Documents */
-- 24-MAR-2014  Akwinass  Admission order and Discharge order functionlity implementes as per recode*/
-- 01-JUL-2014  Akwinass  Implemented completed status check as per task #185 in Philhaven Development*/
--  21 Oct 2015    Revathi    what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--            why:task #609, Network180 Customization  /
BEGIN
	BEGIN TRY
		IF @OrderType = 'ADMISSION'
		BEGIN
			IF @ClientId = 0
			BEGIN
				SELECT DISTINCT c.ClientId
					--Added by Revathi 21 Oct 2015
					,CASE 
						WHEN ISNULL(C.ClientType, 'I') = 'I'
							THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '') + ' (' + CONVERT(VARCHAR(10), DO.EffectiveDate, 101) + ')'
						ELSE ISNULL(C.OrganizationName, '') + ' (' + CONVERT(VARCHAR(10), DO.EffectiveDate, 101) + ')'
						END AS ClientName
				FROM clientOrders co
				INNER JOIN dbo.ssf_RecodeValuesCurrent('ADT_ADMISSION') AS rel ON rel.IntegerCodeId = co.OrderId
				INNER JOIN Orders O ON O.OrderId = co.OrderId
					AND O.ordertype = 8503
				INNER JOIN Clients C ON C.ClientId = co.ClientId
				INNER JOIN Documents DO ON co.DocumentVersionId = DO.CurrentDocumentVersionId
				WHERE co.Active = 'Y'
					AND ISNULL(co.RecordDeleted, 'N') = 'N'
					AND O.Active = 'Y'
					AND ISNULL(O.RecordDeleted, 'N') = 'N'
					AND C.Active = 'Y'
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
					AND ISNULL(DO.RecordDeleted, 'N') = 'N'
					-- 01-JUL-2014  Akwinass
					AND ISNULL(co.OrderStatus, 0) <> 6508
					AND C.ClientId NOT IN (
						SELECT CIV.ClientId
						FROM ClientInpatientVisits CIV
						INNER JOIN GlobalCodes GC ON CIV.STATUS = GC.GlobalCodeId
						WHERE ClientId = C.ClientId
							AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
							AND (
								CAST(AdmitDate AS DATE) <= CAST(GETDATE() AS DATE)
								OR AdmitDate IS NULL
								)
							AND (
								CAST(DischargedDate AS DATE) > CAST(GETDATE() AS DATE)
								OR DischargedDate IS NULL
								)
						)
				ORDER BY ClientName
			END
			ELSE
			BEGIN
				SELECT DISTINCT c.ClientId
					--Added by Revathi 21 Oct 2015
					,CASE 
						WHEN ISNULL(C.ClientType, 'I') = 'I'
							THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '') + ' (' + CONVERT(VARCHAR(10), DO.EffectiveDate, 101) + ')'
						ELSE ISNULL(C.OrganizationName, '') + ' (' + CONVERT(VARCHAR(10), DO.EffectiveDate, 101) + ')'
						END AS ClientName
				FROM clientOrders co
				INNER JOIN dbo.ssf_RecodeValuesCurrent('ADT_ADMISSION') AS rel ON rel.IntegerCodeId = co.OrderId
				INNER JOIN Orders O ON O.OrderId = co.OrderId
					AND O.ordertype = 8503
				INNER JOIN Clients C ON C.ClientId = co.ClientId
				INNER JOIN Documents DO ON co.DocumentVersionId = DO.CurrentDocumentVersionId
				WHERE co.Active = 'Y'
					AND ISNULL(co.RecordDeleted, 'N') = 'N'
					AND O.Active = 'Y'
					AND ISNULL(O.RecordDeleted, 'N') = 'N'
					AND C.Active = 'Y'
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
					AND ISNULL(DO.RecordDeleted, 'N') = 'N'
					-- 01-JUL-2014  Akwinass
					AND ISNULL(co.OrderStatus, 0) <> 6508
					AND c.ClientId = @ClientId
				ORDER BY ClientName
			END
		END

		IF @OrderType = 'DISCHARGE'
		BEGIN
			SELECT DISTINCT c.ClientId
				--Added by Revathi 21 Oct 2015
				,CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '') + ' (' + CONVERT(VARCHAR(10), DO.EffectiveDate, 101) + ')'
					ELSE ISNULL(C.OrganizationName, '') + ' (' + CONVERT(VARCHAR(10), DO.EffectiveDate, 101) + ')'
					END AS ClientName
			FROM clientOrders co
			INNER JOIN dbo.ssf_RecodeValuesCurrent('ADT_DISCHARGE') AS rel ON rel.IntegerCodeId = co.OrderId
			INNER JOIN Orders O ON O.OrderId = co.OrderId
				AND O.ordertype = 8503
			INNER JOIN Clients C ON C.ClientId = co.ClientId
			INNER JOIN Documents DO ON co.DocumentVersionId = DO.CurrentDocumentVersionId
			WHERE co.Active = 'Y'
				AND ISNULL(co.RecordDeleted, 'N') = 'N'
				AND O.Active = 'Y'
				AND ISNULL(O.RecordDeleted, 'N') = 'N'
				AND C.Active = 'Y'
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(DO.RecordDeleted, 'N') = 'N'
				-- 01-JUL-2014  Akwinass 
				AND ISNULL(co.OrderStatus, 0) <> 6508
				AND c.ClientId = @ClientId
			ORDER BY ClientName
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebBedBoardGetAdmissionOrderClients') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

