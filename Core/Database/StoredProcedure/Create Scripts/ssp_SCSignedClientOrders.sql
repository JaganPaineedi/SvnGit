/****** Object:  StoredProcedure [dbo].[ssp_SCSignedClientOrders]    Script Date: 06/01/2015 11:10:05 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSignedClientOrders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCSignedClientOrders]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSignedClientOrders]    Script Date: 06/01/2015 11:10:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCSignedClientOrders]
	-- =============================================                            
	-- Author: Vithobha                          
	-- Create date:27/06/2013                           
	-- Description: Return the Client Orders data for Selection Pop Up.                     
	-- exec ssp_SCSignedClientOrders 12                    
	/*   Updates:                                                       */
	/*   Date			Author		Purpose                       */
	/* 19/Feb/2015	Gautam		The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
								and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */
	/* 13/Mar/2015	Chethan N	What: Checking for orders permission for the logged in staff
								Why: Woods - Customizations task#844*/
	/* 15/May/2015	Chethan N	What: Checking for SmartCare Rx Current medications 
								Why: Philhaven Development task#265*/
	/* 06/Jun/2015	Chethan N	What: Changed INNER JOINS to LEFT JOINS 
								Why: Philhaven Development task#265*/
	/* 29/Jul/2015  Gautam      What : Multiply Dose* Strength only for Tablet and capsules not for other forms like Inj,Solns etc
								Why : Philhaven Development task#259  */
	/*03/Oct/2018  Chethan N		What : Changes to list Child Orders beneath the parent Order and prefixed tab space in Order Name for Child Orders.
									Why : Engineering Improvement Initiatives- NBL(I) task #722							
		30/Jan/2019  Chethan N		What : Changes to ignore Rx medication mapped Client Orders.
		04/02/2019   MD				What: Corrected the logic to show Client Order status for Active column instead of Order template status	
									Why: Journey-Support Go Live #453						
									
									*/
	-- =============================================                           
	@ClientId INT
	,@LoggedInStaffId INT = - 1
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #PermissionTable (PermissionItemId INT)

		------ Get Permissioned Orders for the logged in Staff ------
		INSERT INTO #PermissionTable (PermissionItemId)
		EXEC ssp_GetPermisionedOrder @LoggedInStaffId = @LoggedInStaffId

		CREATE TABLE #ClientOrdersTable (ClientOrderId INT
				,ParentClientOrderId INT
				,OrderId INT
				,OrderName VARCHAR(MAX)
				,OrderType VARCHAR(300)
				,FrequencyName VARCHAR(300)
				,OrderStartDateTime DATETIME
				,DiscontinuedDateTime DATETIME
				,OrderingPhysician VARCHAR(300)
				,AssignedStaff VARCHAR(300)
				,Priority VARCHAR(300)
				,OrderPended VARCHAR(1)
				,Active VARCHAR(10))
		
		INSERT INTO #ClientOrdersTable
		SELECT T.ClientOrderId
				,CASE 
					WHEN T.ParentClientOrderId = T.ClientOrderId
						THEN NULL
					ELSE T.ParentClientOrderId
					END AS ParentClientOrderId
				,T.OrderId
				,T.OrderName
				,T.OrderType
				,T.FrequencyName
				,T.OrderStartDateTime
				,T.DiscontinuedDateTime
				,T.OrderingPhysician
				,T.AssignedStaff
				,T.Priority
				,T.OrderPended
				,T.Active
			FROM (
				SELECT CO.ClientOrderId
					,ISNULL(CO.ParentClientOrderId, ClientOrderId) AS ParentClientOrderId
					,CASE ISNULL(CO.[MedicationUseOtherUsage], 'N')
						WHEN 'Y'
							THEN (O.OrderName + ' ' + CO.[MedicationOtherDosage])
						WHEN 'N'
							THEN CASE 
									WHEN O.OrderType = 8501
										THEN O.OrderName + ' ' + CASE 
												WHEN (
														ISNUMERIC(isnull(md.Strength, 'a')) = 1
														AND CHARINDEX('.', md.Strength) <= 0
														)
													AND (
														MDF.DosageFormDescription = 'Tablet'
														OR MDF.DosageFormDescription = 'Capsule'
														)
													THEN UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(REPLACE(md.Strength, ',', ''), 1) * isnull(CO.MedicationDosage, 1) AS INT) AS VARCHAR(200)) + ISNULL(md.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
												ELSE '(' + UPPER(ISNULL(convert(VARCHAR(15), CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100), '') + ') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(md.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ISNULL(md.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
												END
									ELSE (O.OrderName + ' ' + ISNULL(md.StrengthDescription, ''))
									END
						END AS ordername
					,G.CodeName AS [OrderType]
					,OTF.DisplayName AS FrequencyName
					,CO.OrderStartDateTime
					,CO.DiscontinuedDateTime
					,S1.LastName + ', ' + S1.FirstName AS OrderingPhysician
					,S.LastName + ', ' + S.FirstName AS AssignedStaff
					,G1.CodeName AS Priority
					,CO.OrderPended
					,CO.OrderId
					,G2.CodeName as Active -- Modified by MD on 04/02/2019
				FROM clientorders AS CO
				INNER JOIN orders AS O ON O.OrderId = CO.OrderId
					AND (Isnull(O.RecordDeleted, 'N') = 'N')
				INNER JOIN globalcodes AS G ON G.GlobalCodeId = O.OrderType
					AND (Isnull(G.RecordDeleted, 'N') = 'N')
				--LEFT JOIN orderfrequencies OFR         
				--  ON CO.OrderFrequencyId = OFR.OrderFrequencyId  AND ( Isnull(OFR.RecordDeleted, 'N') = 'N' )            
				LEFT JOIN ordertemplatefrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
					AND (Isnull(OTF.RecordDeleted, 'N') = 'N')
				LEFT JOIN OrderStrengths OS ON OS.OrderStrengthId = CO.MedicationOrderStrengthId
					AND (Isnull(OS.RecordDeleted, 'N') = 'N')
				LEFT JOIN staff S ON S.StaffId = CO.AssignedTo
					AND s.Active = 'Y'
					AND (Isnull(S.RecordDeleted, 'N') = 'N')
				LEFT JOIN staff S1 ON S1.StaffId = CO.OrderingPhysician
					AND S1.Active = 'Y'
					AND (Isnull(S1.RecordDeleted, 'N') = 'N')
				LEFT JOIN globalcodes AS G1 ON G1.GlobalCodeId = CO.OrderPriorityId
					AND (Isnull(G1.RecordDeleted, 'N') = 'N')
				LEFT JOIN MDMedications md ON md.MedicationId = isnull(OS.MedicationId, 0)
					AND ISNULL(md.RecordDeleted, 'N') = 'N'
				LEFT JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId = md.RoutedDosageFormMedicationId
					AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
				LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId = MDRF.DosageFormId
					AND ISNULL(MDF.RecordDeleted, 'N') = 'N'
				LEFT JOIN OrderRoutes AS ORT ON ORT.OrderRouteId = CO.MedicationOrderRouteId
					AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
				LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = ORT.RouteId
					AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
				LEFT JOIN GlobalCodes AS G2 ON G2.GlobalCodeId = CO.OrderStatus  -- Added by MD on 04/02/2019
					AND ISNULL(G2.RecordDeleted, 'N') = 'N'
				WHERE (
						CO.ClientId = @ClientId
						AND CO.Active = 'Y'
						AND Isnull(CO.RecordDeleted, 'N') = 'N'
						AND CO.OrderFlag = 'Y'
						AND (ISNULL(CO.OrderDiscontinued, 'N') = 'N')
						AND CO.OrderStatus NOT IN (
							6510
							,6508
							) --Discontinued,Complete      
						AND (
							ISNULL(O.Permissioned, 'N') = 'N'
							OR (
								O.Permissioned = 'Y'
								AND EXISTS (
									SELECT 1
									FROM #PermissionTable
									WHERE PermissionItemId = O.OrderId
									)
								)
							)
						AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
							AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
							AND R.IntegerCodeId = O.OrderId ))
						)
				) AS T
			ORDER BY T.OrderName
				,T.ParentClientOrderId
				,T.ClientOrderId
				
		UPDATE  CT
			SET CT.ParentClientOrderId = NULL
		FROM #ClientOrdersTable CT
		WHERE CT.ParentClientOrderId IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM #ClientOrdersTable T WHERE T.ClientOrderId = CT.ParentClientOrderId)
				
		SELECT * FROM #ClientOrdersTable

		-- Getting values from RX to SC
		DECLARE @LastScriptIdTable TABLE (
			clientmedicationinstructionid INT
			,clientmedicationscriptid INT
			)

		INSERT INTO @LastScriptIdTable (
			clientmedicationinstructionid
			,clientmedicationscriptid
			)
		SELECT clientmedicationinstructionid
			,clientmedicationscriptid
		FROM (
			SELECT cmsd.clientmedicationinstructionid
				,cmsd.clientmedicationscriptid
				,cms.orderdate
				,Row_number() OVER (
					PARTITION BY cmsd.clientmedicationinstructionid ORDER BY cms.orderdate DESC
						,cmsd.clientmedicationscriptid DESC
					) AS rownum
			FROM clientmedicationscriptdrugs cmsd
			INNER JOIN clientmedicationscripts cms ON (cmsd.clientmedicationscriptid = cms.clientmedicationscriptid)
			WHERE clientmedicationinstructionid IN (
					SELECT clientmedicationinstructionid
					FROM clientmedications a
					INNER JOIN dbo.clientmedicationinstructions b ON (a.clientmedicationid = b.clientmedicationid)
					WHERE a.clientid = @ClientId
						AND Isnull(a.recorddeleted, 'N') = 'N'
						AND Isnull(b.active, 'Y') = 'Y'
						AND Isnull(b.recorddeleted, 'N') = 'N'
					)
				AND Isnull(cmsd.recorddeleted, 'N') = 'N'
				AND Isnull(cms.recorddeleted, 'N') = 'N'
				AND Isnull(cms.voided, 'N') = 'N'
			) AS a
		WHERE rownum = 1

		SELECT CM.ClientMedicationId
			,CASE 
				WHEN CM.Ordered = 'Y'
					THEN 'Prescribed'
				ELSE 'Other'
				END AS [OrderType]
			,ISNULL(MDMN.MedicationName, '') + ' ' + ISNULL(MDM.StrengthDescription, '') AS OrderName
			,CMSD.StartDate AS OrderStartDateTime
			,GC.Codename AS FrequencyName
			,'Active' AS Active
			,CM.PrescriberName AS OrderingPhysician
			,'' AS AssignedStaff
		FROM Clientmedications CM
		INNER JOIN MDMedicationnames MDMN ON CM.Medicationnameid = MDMN.Medicationnameid
		LEFT JOIN Clientmedicationinstructions CMI ON CM.Clientmedicationid = CMI.Clientmedicationid
			AND ISNULL(CMI.Active, 'Y') = 'Y'
			AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Globalcodes gc ON CMI.Schedule = GC.Globalcodeid
		LEFT JOIN MDMedications MDM ON MDM.Medicationid = CMI.Strengthid
		LEFT JOIN Clientmedicationscriptdrugs CMSD ON (
				CMI.Clientmedicationinstructionid = CMSD.Clientmedicationinstructionid
				AND Isnull(CMSD.RecordDeleted, 'N') <> 'Y'
				)
		LEFT JOIN @LastScriptIdTable LSId ON (
				CMI.Clientmedicationinstructionid = LSId.Clientmedicationinstructionid
				-- the rest of the join is in the Where statement to eliminate multiple instruction records   
				)
			AND (
				CMSD.Clientmedicationscriptid IS NULL
				OR CMSD.Clientmedicationscriptid = LSId.Clientmedicationscriptid
				)
			AND (
				(
					LSId.Clientmedicationscriptid IS NOT NULL
					AND CMSD.Clientmedicationscriptid = LSId.Clientmedicationscriptid
					)
				OR LSId.Clientmedicationscriptid IS NULL
				)
			AND (
				CMSD.ClientMedicationScriptId IS NULL
				OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
			AND (
				(
					LSId.ClientMedicationScriptId IS NOT NULL
					AND CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
					)
				OR LSId.ClientMedicationScriptId IS NULL
				)
		WHERE ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'
			--CM.ClientMedicationId NOT IN (SELECT ClientMedicationId FROM ClientOrderMedicationReferences CMR INNER JOIN ClientOrders CO ON CMR.ClientOrderId = CO.ClientOrderId AND CO.ClientId = @ClientId) 
			AND CM.Clientid = @ClientId
			AND ISNULL(CM.Discontinued, 'N') != 'Y'
		ORDER BY MDMN.Medicationname ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCClientOrders') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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

