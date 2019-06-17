/****** Object:  StoredProcedure [dbo].[ssp_PMServicesChargesCount]    Script Date: 10/13/2015 20:16:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMServicesChargesCount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMServicesChargesCount]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PMServicesChargesCount]    Script Date: 10/13/2015 20:16:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMServicesChargesCount] (
	@StaffId INT
	,@FinancialAssignmentId INT
	)
AS
/******************************************************************************          
**  File: dbo.ssp_PMServicesChargesCount.prc          
**  Name: dbo.ssp_PMServicesChargesCount          
**  Desc: This SP returns the data required by dashboard          
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Called by:             
**                        
**  Parameters:          
**  Input       Output          
**     ----------       -----------          
**          
**  Auth: MSuma           
**  Date:           
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:  Author:   Description:          
**  -------- --------  -------------------------------------------          
**  23/08/2011  Msuma   Created.  
**  09/10/2011 MSuma   Fixed Count to resolve conflicts  
**  09/10/2011 MSuma   Included Try Catch Block  
**  24/11/2011  MSuma   Included from Charges and Claims to match Claim numbers  
**  15/12/2011  MSuma   Moved filter on staff client as join   
**  05/01/2011  MSuma   Modified Left join to Join on CLientCoveragePlans  
**  06/08/2012  MSuma   Modified Left join to Join on CoveragePlans  
**  29.06.12    MSuma      Changed to Local Variable  
** 17.Apr.2015 Revathi   what:FinancialAssignment filter added   
                         why:task #950 Valley - Customization  
**  10/13/2015  Sbhowmik	Changed the logic for Flagged conditions for Claim Count 

** 31/08/2017  Prem    Added where Conditions for Claims and Charges as part of MFS-Support Go Live #154   
** 03/08/2017  Ajay    Parameter @Clinician to ssf_FinancialAssignmentServices function. AHN-Customization: Task#44 
** 08/11/2017  Chethan N	What : Added Service status check as Service Errors should only count errors on Services with a status of Scheduled or Show.
							Why : Engineering Improvement Initiatives- NBL(I) task # 592.
 23/01/2017  Sunil.D 	What : Added code to get the Charges with Balance to dashBoard
						Why : New Directions - Support Go Live#657.
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @local_StaffId INT

		SET @local_StaffId = @StaffId

		--Added by Revathi 17.Apr.2015   
		DECLARE @ChargeResponsibleDays VARCHAR(MAX)

		SET @ChargeResponsibleDays = (
				SELECT ChargeResponsibleDays
				FROM FinancialAssignments
				WHERE FinancialAssignmentId = @FinancialAssignmentId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)

		DECLARE @ClientFirstLastName VARCHAR(25)
		DECLARE @ClientLastLastName VARCHAR(25)
		DECLARE @ClientServiceFirstLastName VARCHAR(25)
		DECLARE @ClientServiceLastLastName VARCHAR(25)
		DECLARE @IncludeClientCharge CHAR(1)

		CREATE TABLE #ClientLastNameSearch (LastNameSearch VARCHAR(MAX))

		CREATE TABLE #ClientServiceLastNameSearch (ServiceLastNameSearch VARCHAR(MAX))

		IF ISNULL(@FinancialAssignmentId, - 1) <> - 1
		BEGIN
			SELECT @ClientFirstLastName = FinancialAssignmentChargeClientLastNameFrom
				,@ClientLastLastName = FinancialAssignmentChargeClientLastNameTo
			FROM FinancialAssignments
			WHERE FinancialAssignmentId = @FinancialAssignmentId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			SELECT @ClientServiceFirstLastName = FinancialAssignmentServiceClientLastNameFrom
				,@ClientServiceLastLastName = FinancialAssignmentServiceClientLastNameTo
			FROM FinancialAssignments
			WHERE FinancialAssignmentId = @FinancialAssignmentId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			INSERT INTO #ClientLastNameSearch
			EXEC ssp_SCGetPatientSearchValues @ClientFirstLastName
				,@ClientLastLastName

			INSERT INTO #ClientServiceLastNameSearch
			EXEC ssp_SCGetPatientSearchValues @ClientServiceFirstLastName
				,@ClientServiceLastLastName
		END

		IF ISNULL(@FinancialAssignmentId, - 1) <> - 1
			SET @IncludeClientCharge = (
					SELECT ChargeIncludeClientCharge
					FROM FinancialAssignments
					WHERE FinancialAssignmentId = @FinancialAssignmentId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)

		SELECT * 
		INTO #rslt
		FROM 
		(SELECT 
		 CntType = CAST('Service' as varchar(20))
		,Cnt = count(DISTINCT ServiceID)
		FROM services S
		INNER JOIN StaffClients sc ON sc.StaffId = @local_StaffId
			AND s.ClientId = sc.ClientId
		INNER JOIN Clients c ON c.ClientId = s.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			--Added by Revathi 17.Apr.2015    
			AND (
				EXISTS (
					SELECT 1
					FROM #ClientServiceLastNameSearch f
					WHERE c.LastName COLLATE DATABASE_DEFAULT LIKE F.ServiceLastNameSearch COLLATE DATABASE_DEFAULT
					)
				OR (
					NOT EXISTS (
						SELECT 1
						FROM #ClientServiceLastNameSearch
						)
					AND c.LastName = c.LastName
					)
				)
        CROSS APPLY [dbo].[ssf_FinancialAssignmentServices](@FinancialAssignmentId, 					                                         
													s.ClientId, 
													s.ProgramId, 
													s.ProcedureCodeId, 
													s.LocationId,
													s.ClinicianId) --Added by Ajay on 03-Aug-2017
		WHERE isnull(s.OverrideError, 'N') = 'N'
			AND isnull(s.RecordDeleted, 'N') = 'N'
			AND S.Status IN (70,71) --Added by Chethan N on 08/11/2017
			AND EXISTS (
				SELECT *
				FROM ServiceErrors SE
				WHERE S.ServiceId = SE.ServiceId
					AND ISNULL(SE.RecordDeleted, 'N') = 'N'
				)
		UNION ALL
		SELECT 
		CntType = CAST('Claims' as varchar(20)),
		Cnt = count(ch.ChargeId)
		FROM Charges ch
		INNER JOIN Services s ON s.ServiceId = ch.ServiceId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		INNER JOIN StaffClients sc ON sc.ClientId = s.ClientId
		--Included from Charges and Claims to match Claim numbers  
		INNER JOIN Clients c ON c.ClientId = s.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			--Added by Revathi 17.Apr.2015   
			AND (
				EXISTS (
					SELECT 1
					FROM #ClientLastNameSearch f
					WHERE c.LastName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT
					)
				OR (
					NOT EXISTS (
						SELECT 1
						FROM #ClientLastNameSearch
						)
					AND c.LastName = c.LastName
					)
				)
		INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId
			AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
		LEFT JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
		INNER JOIN OpenCharges och ON och.ChargeId = ch.ChargeId
		LEFT JOIN Payers p ON (cp.PayerId = p.PayerId)
			AND ISNULL(p.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
			AND ISNULL(s.RecordDeleted, 'N') = 'N'
        CROSS APPLY dbo.ssf_FinancialAssignmentCharges(@FinancialAssignmentId, 					                                         
													s.ClientId, 
													s.ProgramId, 
													cp.CoveragePlanId, 
													p.PayerId, 
													p.PayerType, 
													s.ProcedureCodeId, 
													s.LocationId, 
													ch.ChargeId)	
													
where ISNULL(ch.RecordDeleted,'N')='N' and s.Status <> 76  and ch.Priority > 0 --Added by Prem  31/07/2017
 and exists(select * from ChargeErrors che where che.ChargeId = ch.ChargeId and  che.ErrorType = 4556 and 
 isnull(che.RecordDeleted, 'N') = 'N') and isnull(cp.RecordDeleted, 'N') = 'N' and ch.LastBilledDate is null and isnull(ch.DoNotBill,'N') <> 'Y'
		and
		 sc.StaffId = @local_StaffId	
		--WHERE sc.StaffId = @local_StaffId
		--	AND Isnull(ch.RecordDeleted, 'N') = 'N'
			--AND IsNull(ch.Flagged,'N') = 'Y'
			--Added by Revathi 17.Apr.2015   
			AND (
				ISNULL(@FinancialAssignmentId, - 1) = - 1
				OR (
						(
						ISNULL(@ChargeResponsibleDays, - 1) = - 1
						OR (
							s.DateOfService < CASE 
								WHEN @ChargeResponsibleDays = 8980
									THEN CONVERT(VARCHAR, DATEADD(dd, - 90, GETDATE()), 101)
								WHEN @ChargeResponsibleDays = 8981
									THEN CONVERT(VARCHAR, DATEADD(dd, - 180, GETDATE()), 101)
								WHEN @ChargeResponsibleDays = 8982
									THEN CONVERT(VARCHAR, DATEADD(dd, - 360, GETDATE()), 101)
								END
							)
						)
					AND (
						ISNULL(@IncludeClientCharge, 'N') = 'N'
						OR (
							ISNULL(@IncludeClientCharge, 'N') = 'Y'
							AND ch.Priority = 0
							)
						)
					)
				)
		UNION ALL
		SELECT 
		CntType = CAST('Charges' as varchar(20)),
		Cnt = Count(ch.ChargeId)
		FROM Charges ch
		INNER JOIN OpenCharges oc ON (ch.ChargeId = oc.ChargeId)
			AND ISNULL(ch.RecordDeleted, 'N') = 'N'
		INNER JOIN Services s ON s.ServiceId = ch.ServiceId
			AND ISNULL(s.RecordDeleted, 'N') = 'N'
		--join StaffClients sc on sc.ClientId = s.ClientId   
		INNER JOIN StaffClients sc ON sc.StaffId = @local_StaffId
			AND s.ClientId = sc.ClientId
		--Included from Charges and Claims to match Claim numbers  
		INNER JOIN Clients c ON c.ClientId = s.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND (
				EXISTS (
					SELECT 1
					FROM #ClientLastNameSearch f
					WHERE c.LastName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT
					)
				OR (
					NOT EXISTS (
						SELECT 1
						FROM #ClientLastNameSearch
						)
					AND c.LastName = c.LastName
					)
				)
		INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		--Modified Left join to Join MSuma  
		LEFT JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId
			AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
		LEFT JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
		LEFT JOIN Payers p ON (cp.PayerId = p.PayerId)
			AND ISNULL(p.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
			AND ISNULL(s.RecordDeleted, 'N') = 'N'
        CROSS APPLY dbo.ssf_FinancialAssignmentCharges(@FinancialAssignmentId, 					                                         
													s.ClientId, 
													s.ProgramId, 
													cp.CoveragePlanId, 
													p.PayerId, 
													p.PayerType, 
													s.ProcedureCodeId, 
													s.LocationId, 
													ch.ChargeId)		
		WHERE EXISTS (
				SELECT *
				FROM ChargeErrors che
				WHERE che.ChargeId = ch.ChargeId
					AND isnull(che.RecordDeleted, 'N') = 'N'
				)  and s.Status <> 76  --Added by Prem  31/07/2017
			--Added by Revathi 17.Apr.2015   
			AND (
				ISNULL(@FinancialAssignmentId, - 1) = - 1
				OR (
					   (
						ISNULL(@ChargeResponsibleDays, - 1) = - 1
						OR (
							s.DateOfService < CASE 
								WHEN @ChargeResponsibleDays = 8980
									THEN CONVERT(VARCHAR, DATEADD(dd, - 90, GETDATE()), 101)
								WHEN @ChargeResponsibleDays = 8981
									THEN CONVERT(VARCHAR, DATEADD(dd, - 180, GETDATE()), 101)
								WHEN @ChargeResponsibleDays = 8982
									THEN CONVERT(VARCHAR, DATEADD(dd, - 360, GETDATE()), 101)
								END
							)
						)
					AND (
						ISNULL(@IncludeClientCharge, 'N') = 'N'
						OR (
							ISNULL(@IncludeClientCharge, 'N') = 'Y'
							AND ch.Priority = 0
							)
						)
					)
				)
		) rslt

		SELECT 
		SUM(CASE WHEN CntType = 'Service' THEN Cnt END) as ServicesCount,
		SUM(CASE WHEN CntType = 'Charges' THEN Cnt END) as ChargesCount,
		SUM(CASE WHEN CntType = 'Claims' THEN Cnt  END) as ClaimsCount
		FROM #rslt

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMServicesChargesCount') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH

	RETURN
END

GO


