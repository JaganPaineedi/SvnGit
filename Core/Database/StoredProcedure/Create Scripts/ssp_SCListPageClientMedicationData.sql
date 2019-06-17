/****** Object:  StoredProcedure [dbo].[ssp_SCListPageClientMedicationData]    Script Date: 05/23/2017 12:59:48 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageClientMedicationData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageClientMedicationData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageClientMedicationData]    Script Date: 05/23/2017 12:59:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageClientMedicationData] (
	@ClientId INT
	,@PrescriberId INT
	,@RxStart DATETIME
	,@RxEnd DATETIME
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@OtherFilter INT
	,@MedicationStatus INT = NULL -- Added by Vichee 01/29/2016
	)
	/********************************************************************************    
-- Stored Procedure: dbo.ssp_SCListPageClientMedicationData      
--    ssp_SCListPageClientMedicationData 17036,575,0,100,null,null
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 20-may-2014	 Revathi		What:Client Medication List Page.          
--								Why:task #20 MeaningFul Use
-- 13-Jun-2014	 Chethan N		What: Retriving Quantity and Refills column to display in the list page
-- 3/25/2015	 Steczynski		Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215
-- 01/29/2016    Vichee Humane  Added  @MedicationStatus and DiscontinueDate to check the status of Medication
								CEI - Support Go Live #100
-- 12/04/2016    Venkatesh     Modify the logic to get the Quantity and Refils which has to same as in RX as per Task- KeyPoint Support Go Live - 221
-- 19/Dec/2016   Gautam         Rewrite the logic from Rx to show correct Prescriber Name,RxStart & End Date,
								Why: Key Point - Support Go Live > Tasks #585> Medication List page - wrong prescriber listed 
-- 03/FEB/2017   Neelima        Added condition to check the filtering based on RxStart Date and RxEnddate 
								Why: CEI - Support Go Live #365								
-- 23/MAY/2017   Shankha        Modified condition to check Voided medications
								Why: Network180 Support Go Live #253
-- 27/AUG/2017	 Chethan N		What : Added condition to avoid displaying duplicate medication.
								Why : Renaissance - Dev Items task #5.1
--11/OCT/2018    Veena          What:Removed PrescriberId is not null and made MDMedication table as left join
                                Why:CCC - Support Go Live #2
						
-- 28-Feb-2018   Sachin         What : Discontinued date is not displaying in SC clients medications list page.
                                Why  : Because while retreiving results of Non Order Medications, added the "AND ISNULL(CM.Ordered, 'N') = 'Y'" 
                                condition for non orders hence it is not showing the discontinued date in medications list page. To make it i have removed 
                                the "AND ISNULL(CM.Ordered, 'N') = 'Y'" condition from ssp_SCListPageClientMedicationData stored procedure. 
                                for WestBridge - Support Go Live #69.for 	WestBridge - Support Go Live #69.	
                                							
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #CustomFilters (ClientMedicationId INT)

		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @strMedStatus VARCHAR(10) -- Added by Vichee 01/29/2016 

		CREATE TABLE #ResultSet (
			ClientMedicationId INT
			,MedicationName VARCHAR(100)
			,DateInitialized DATETIME
			,Instruction VARCHAR(MAX)
			,RxStart DATETIME
			,RxEnd DATETIME
			,PrescribedBy VARCHAR(100)
			,Comments VARCHAR(MAX)
			,Quantity VARCHAR(100)
			,Refills VARCHAR(100)
			,DiscontinueDate DATETIME
			,ScriptId INT
			,OrderStatus VARCHAR(20)
			,OrderStatusDate DATETIME
			,PrescriberId INT
			)

		----Retrive StartDate and EndDate from ClientMedicationScriptDrugs                                                  
		CREATE TABLE #tempClientMedication (
			MedicationStartDate DATETIME
			,MedicationEndDate DATETIME
			,clientmedicationid INT
			,ScriptEventType CHAR(1)
			,ScriptId INT
			,SpecialInstructions VARCHAR(1000)
			,OrderDate DATETIME
			,Ordered CHAR(1)
			)

		SET @SortExpression = rtrim(ltrim(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'DateInitialized desc'
		SET @ApplyFilterClicked = 'Y'

		-- Added by Vichee 01/29/2016 
		IF @MedicationStatus = 9374
		BEGIN
			SET @strMedStatus = 'N'
		END

		IF @MedicationStatus = 9375
		BEGIN
			SET @strMedStatus = 'Y'
		END

		-- End by Vichee 01/29/2016 
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters (ClientMedicationId)
			EXEC scsp_SCListPageClientMedicationData @ClientId = @ClientId
				,@PrescriberId = @PrescriberId
				,@RxStart = @RxStart
				,@RxEnd = @RxEnd
				,@OtherFilter = @OtherFilter
				,@MedicationStatus = @MedicationStatus -- Added by Vichee 01/29/2016
		END

		INSERT INTO #tempClientMedication
		SELECT CASE CMS.ScriptEventType
				WHEN 'R'
					THEN CM.MedicationStartDate
				ELSE Min(CMSD.StartDate)
				END AS MedicationStartDate
			,Max(CMSD.EndDate) AS MedicationEndDate
			,cm.clientmedicationid
			,CMS.ScriptEventType AS ScriptEventType
			,CMS.ClientMedicationScriptId AS ScriptId
			,CM.SpecialInstructions AS SpecialInstructions
			,CMS.OrderDate AS OrderDate
			,ISNULL(CM.Ordered, 'N') AS Ordered
		FROM ClientMedications CM
		LEFT JOIN ClientMedicationInstructions CMI ON CMI.ClientMedicationId = CM.ClientMedicationId
			AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
			AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientMedicationScripts CMS ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId
			AND ISNULL(CMS.RecordDeleted, 'N') = 'N'
		WHERE CM.ClientId = @ClientId
		AND NOT EXISTS(SELECT 1 FROM ClientOrderMedicationReferences COMR WHERE CMI.ClientMedicationInstructionId = COMR.ClientMedicationInstructionId
			AND ISNULL(CMI.Active, 'N') = 'N')
			AND ISNULL(CM.RecordDeleted, 'N') = 'N'
			--AND (@PrescriberId = -1 OR CM.PrescriberId=@PrescriberId)  
			AND (
				@MedicationStatus = - 1
				OR (
					@MedicationStatus = 9374
					AND (
						(ISNULL(CM.Discontinued, 'N') = 'N')
						AND ISNULL(CMS.Voided, 'N') = 'N'
						)
					)
				OR (
					@MedicationStatus = 9375
					AND (
						(ISNULL(CM.Discontinued, 'N') = 'Y')
						OR ISNULL(CMS.Voided, 'N') = 'Y'
						)
					)
				)
			--AND (@RxStart is null or cast(MedicationStartDate as date) >= cast(@RxStart as date))                        
			--AND (@RxEnd is null or cast(MedicationEndDate as date) <= cast(@RxEnd as date))   
			AND (
				(
					ISNULL(CM.Ordered, 'N') = 'Y'
					AND ISNULL(CMS.WaitingPrescriberApproval, 'N') = 'N'
					)
				OR (ISNULL(CM.Ordered, 'N') = 'N')
				)
		GROUP BY cm.clientmedicationid
			,CMS.ScriptEventType
			,CMS.ClientMedicationScriptId
			,CM.MedicationStartDate
			,CM.SpecialInstructions
			,CMS.OrderDate
			,cm.Ordered
		ORDER BY cm.clientmedicationid

		INSERT INTO #ResultSet (
			ClientMedicationId
			,MedicationName
			,DateInitialized
			,Instruction
			,RxStart
			,RxEnd
			,PrescribedBy
			,Comments
			,Quantity
			,Refills
			,DiscontinueDate
			,ScriptId
			,OrderStatus
			,OrderStatusDate
			,PrescriberId
			)
		SELECT CM.ClientMedicationId
			,ISNULL(mdn.MedicationName, '') AS MedicationName
			,t.OrderDate AS DateInitialized
			,(MD.StrengthDescription + ' ' + dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' ' + CONVERT(VARCHAR, GC.CodeName) + ' ' + CONVERT(VARCHAR, GC1.CodeName)) AS Instruction
			,ISNULL(cmsd.StartDate, t.MedicationStartDate) AS RxStart
			,ISNULL(cmsd.EndDate, t.MedicationEndDate) AS RxEnd
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN ISNULL(cm.PrescriberName, cm.ExternalPrescriberName)
				ELSE cms.OrderingPrescriberName
				END AS PrescriberName
			,CM.Comments AS Comments
			,CASE 
				WHEN CMSD.PharmacyText IS NULL
					THEN CAST(CMSD.Pharmacy AS VARCHAR(30))
				ELSE CMSD.PharmacyText
				END AS Quantity
			,CONVERT(VARCHAR, CMSD.Refills) AS Refills
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.DiscontinueDate
				ELSE NULL
				END AS DiscontinueDate
			,t.ScriptId
			,CASE 
				WHEN ISNULL(CMS.Voided, 'N') = 'Y'
					THEN 'Voided'
				ELSE CASE CMS.ScriptEventType
						WHEN 'N'
							THEN 'New'
						WHEN 'C'
							THEN 'Changed'
						WHEN 'R'
							THEN 'Re-Ordered'
						END
				END AS OrderStatus
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.DiscontinueDate
				ELSE cms.ScriptCreationDate
				END AS OrderStatusDate
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.PrescriberId
				ELSE OrderingPrescriberId
				END AS PrescriberId
		FROM ClientMedications cm
		LEFT JOIN MDMedicationNames mdn ON (
				mdn.MedicationNameId = cm.MedicationNameId
				AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
				)
		JOIN ClientMedicationInstructions cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
			AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
		JOIN ClientMedicationScriptDrugs cmsd ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
			AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
		JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
			AND ISNULL(cms.RecordDeleted, 'N') = 'N'
		JOIN #tempClientMedication t ON (
				t.Clientmedicationid = cm.Clientmedicationid
				AND t.ScriptEventType = cms.ScriptEventType
				AND cms.ClientMedicationScriptId = t.ScriptId
				AND t.ordered = 'Y'
				)
		-- making MDMedications as left join code changed by Veena on 11/10/18 for CCC - Support Go Live #2
		LEFT JOIN MDMedications MD ON (MD.MedicationID = CMI.StrengthId)
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CMI.Unit
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CMI.Schedule
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		WHERE cm.ClientId = @ClientId
			AND ISNULL(cm.RecordDeleted, 'N') = 'N'
			AND ISNULL(cm.Ordered, 'N') = 'Y'
			AND ISNULL(cms.WaitingPrescriberApproval, 'N') = 'N'
			--AND (
			--	@PrescriberId = - 1
			--	OR PrescriberId = @PrescriberId
			--	)
			AND (
				@MedicationStatus = - 1
				--OR ISNULL(CM.Discontinued, 'N') = @strMedStatus
				OR (
					@MedicationStatus = 9374
					AND (
						(ISNULL(CM.Discontinued, 'N') = 'N')
						AND ISNULL(CMS.Voided, 'N') = 'N'
						)
					)
				OR (
					@MedicationStatus = 9375
					AND (
						(ISNULL(CM.Discontinued, 'N') = 'Y')
						OR ISNULL(CMS.Voided, 'N') = 'Y'
						)
					)
				) -- Added by Vichee 01/29/2016      
			AND (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #CustomFilters CF
						WHERE CF.ClientMedicationId = CM.ClientMedicationId
						)
					)
				OR (@CustomFiltersApplied = 'N')
				)
			AND (
				@RxStart IS NULL
				OR cast(ISNULL(cmsd.StartDate, t.MedicationStartDate) AS DATE) >= cast(@RxStart AS DATE)
				)
			AND (
				@RxEnd IS NULL
				OR cast(ISNULL(cmsd.EndDate, t.MedicationEndDate) AS DATE) <= cast(@RxEnd AS DATE)
				OR (
					cast(ISNULL(cmsd.StartDate, t.MedicationStartDate) AS DATE) <= cast(@RxEnd AS DATE)
					AND cast(@RxEnd AS DATE) < cast(ISNULL(cmsd.EndDate, t.MedicationEndDate) AS DATE)
					)
				)
			-- commenting below code PrescriberName is not null by Veena on 11/10/18 for CCC - Support Go Live #2
            --AND PrescriberName IS NOT NULL
		
		UNION
		
		--Retreive results of Non Order Medications        
		SELECT CM.ClientMedicationId
			,ISNULL(mdn.MedicationName, '') AS MedicationName
			,t.MedicationStartDate AS DateInitialized
			,(MD.StrengthDescription + ' ' + dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' ' + CONVERT(VARCHAR, GC.CodeName) + ' ' + CONVERT(VARCHAR, GC1.CodeName)) AS Instruction
			,t.MedicationStartDate AS RxStart
			,t.MedicationEndDate AS RxEnd
			,ISNULL(cm.PrescriberName, cm.ExternalPrescriberName) AS PrescriberName
			,CM.Comments AS Comments
			,CASE 
				WHEN CMSD.PharmacyText IS NULL
					THEN CAST(CMSD.Pharmacy AS VARCHAR(30))
				ELSE CMSD.PharmacyText
				END AS Quantity
			,CONVERT(VARCHAR, CMSD.Refills) AS Refills
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					-- AND ISNULL(CM.Ordered, 'N') = 'Y' 
					THEN cm.DiscontinueDate
				ELSE NULL
				END AS DiscontinueDate
			,t.ScriptId
			,CASE cm.Discontinued
				WHEN 'Y'
					THEN 'Discontinued'
				ELSE 'New'
				END AS OrderStatus
			,CASE cm.Discontinued
				WHEN 'Y'
					THEN cm.DiscontinueDate
				ELSE cm.CreatedDate
				END AS OrderStatusDate
			,cm.PrescriberId AS PrescriberId
		FROM ClientMedications CM
		LEFT JOIN MDMedicationNames mdn ON (
				mdn.MedicationNameId = cm.MedicationNameId
				AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
				)
		LEFT OUTER JOIN ClientMedicationInstructions cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
			AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientMedicationScriptDrugs cmsd ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
			AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
		JOIN #tempClientMedication t ON (
				t.Clientmedicationid = cm.Clientmedicationid
				AND t.ordered = 'N'
				)
		-- making MDMedications as left join code changed by Veena on 11/10/18 for CCC - Support Go Live #2

		LEFT JOIN MDMedications MD ON (MD.MedicationID = CMI.StrengthId)
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CMI.Unit
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CMI.Schedule
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		WHERE cm.ClientId = @ClientId
			AND ISNULL(cm.RecordDeleted, 'N') = 'N'
			AND ISNULL(cm.Ordered, 'N') = 'N'
			--AND (
			--	@PrescriberId = - 1
			--	OR CM.PrescriberId = @PrescriberId
			--	)
			AND (
				@MedicationStatus = - 1
				OR ISNULL(CM.Discontinued, 'N') = @strMedStatus
				)
			AND (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #CustomFilters CF
						WHERE CF.ClientMedicationId = CM.ClientMedicationId
						)
					)
				OR (@CustomFiltersApplied = 'N')
				)
			AND (
				@RxStart IS NULL
				OR cast(t.MedicationStartDate AS DATE) >= cast(@RxStart AS DATE)
				)
			AND (
				@RxEnd IS NULL
				OR cast(t.MedicationEndDate AS DATE) <= cast(@RxEnd AS DATE)
				OR (
					cast(t.MedicationStartDate AS DATE) <= cast(@RxEnd AS DATE)
					AND cast(@RxEnd AS DATE) < cast(t.MedicationEndDate AS DATE)
					)
				)
			-- commenting below code PrescriberName is not null by Veena on 11/10/18 for CCC - Support Go Live #2
			--AND PrescriberName IS NOT NULL
			--select * from #ResultSet order by medicationname
			--Select R.ClientMedicationId ,r.MedicationName , ISNULL(r.RxStart,r.DateInitialized) as DateInitialized,r.Instruction ,
			--		 r.RxStart as RxStart,
			--		  r.RxEnd as RxEnd,
			--		 r.PrescribedBy      
			--	,r.Comments ,r.Quantity ,r.Refills ,r.DiscontinueDate
			--   FROM   #ResultSet R   
			--   Where PrescribedBy is not null                  
			--      ORDER  BY MedicationName, 
			--               OrderStatusDate, 
			--               CASE OrderStatus 
			--                 WHEN 'New' THEN 1 
			--                 WHEN 'Re-Ordered' THEN 2 
			--                 WHEN 'Changed' THEN 3 
			--                 WHEN 'Discontinued' THEN 4 
			--                 ELSE 5 
			--               END 
			;

		WITH FinalResult
		AS (
			SELECT ClientMedicationId
				,MedicationName
				,DateInitialized
				,Instruction
				,RxStart
				,RxEnd
				,PrescribedBy
				,Comments
				,Quantity
				,Refills
				,DiscontinueDate
				,PrescriberId
			FROM #ResultSet
			WHERE (
					@PrescriberId = - 1
					OR PrescriberId = @PrescriberId
					)
			)
			,Counts
		AS (
			SELECT COUNT(*) AS TotalRows
			FROM FinalResult
			)
			,RankResultSet
		AS (
			SELECT ClientMedicationId
				,MedicationName
				,DateInitialized
				,Instruction
				,RxStart
				,RxEnd
				,PrescribedBy
				,Comments
				,Quantity
				,Refills
				,DiscontinueDate -- Added by Vichee 01/29/2016 
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'MedicationName'
								THEN MedicationName
							END
						,CASE 
							WHEN @SortExpression = 'MedicationName desc'
								THEN MedicationName
							END DESC
						,CASE 
							WHEN @SortExpression = 'DateInitialized'
								THEN DateInitialized
							END
						,CASE 
							WHEN @SortExpression = 'DateInitialized desc'
								THEN DateInitialized
							END DESC
						,CASE 
							WHEN @SortExpression = 'Instruction'
								THEN Instruction
							END
						,CASE 
							WHEN @SortExpression = 'Instruction desc'
								THEN Instruction
							END DESC
						,CASE 
							WHEN @SortExpression = 'RxStart'
								THEN RxStart
							END
						,CASE 
							WHEN @SortExpression = 'RxStart desc'
								THEN RxStart
							END DESC
						,CASE 
							WHEN @SortExpression = 'RxEnd'
								THEN RxStart
							END
						,CASE 
							WHEN @SortExpression = 'RxEnd desc'
								THEN RxStart
							END DESC
						,CASE 
							WHEN @SortExpression = 'Quantity'
								THEN RxStart
							END
						,CASE 
							WHEN @SortExpression = 'Quantity desc'
								THEN RxStart
							END DESC
						,CASE 
							WHEN @SortExpression = 'Refills'
								THEN RxStart
							END
						,CASE 
							WHEN @SortExpression = 'Refills desc'
								THEN RxStart
							END DESC
						,CASE 
							WHEN @SortExpression = 'PrescribedBy'
								THEN PrescribedBy
							END
						,CASE 
							WHEN @SortExpression = 'PrescribedBy desc'
								THEN PrescribedBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'DiscontinueDate'
								THEN DiscontinueDate
							END -- Added by Vichee 01/29/2016   
						,CASE 
							WHEN @SortExpression = 'DiscontinueDate desc'
								THEN DiscontinueDate
							END DESC
						,ClientMedicationId
					) AS RowNumber
			FROM FinalResult
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) ClientMedicationId
			,MedicationName
			,ISNULL(CONVERT(VARCHAR, DateInitialized, 101), '') AS DateInitialized
			,ISNULL(Instruction, '') AS Instruction
			,ISNULL(CONVERT(VARCHAR, RxStart, 101), '') AS RxStart
			,ISNULL(CONVERT(VARCHAR, RxEnd, 101), '') AS RxEnd
			,PrescribedBy
			,ISNULL(Comments, '') AS Comments
			,ISNULL(Quantity, '') AS Quantity
			,ISNULL(Refills, '') AS Refills
			,Convert(VARCHAR(10), DiscontinueDate, 101) AS DiscontinueDate
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT MedicationName AS 'MedicationName'
			,DateInitialized AS 'DateInitialized'
			,Instruction
			,RxStart AS 'RxStart'
			,RxEnd AS 'RxEnd'
			,PrescribedBy AS 'PrescribedBy'
			,Comments
			,Quantity
			,Refills
			,DiscontinueDate AS 'DiscontinueDate' -- Added by Vichee 01/29/2016              
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageClientMedicationData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, 
				ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
GO


