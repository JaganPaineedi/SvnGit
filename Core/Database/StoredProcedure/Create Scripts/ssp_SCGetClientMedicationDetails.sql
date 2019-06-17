/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientMedicationDetails]    Script Date: 10/30/2013 2:28:20 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = Object_id(N'[dbo].[ssp_SCGetClientMedicationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetClientMedicationDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientMedicationDetails] 245   Script Date: 10/30/2013 2:28:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientMedicationDetails] (@ClientId BIGINT)
AS /**********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetClientMedicationDetails  128878  */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC     */
/* Creation Date:    09/04/2007                              */
/*                                                           */
/* Purpose:Used to get the medication details for the client */
/*                                                           */
/* Input Parameters: @ClientId         */
/*                                                           */
/* Output Parameters:   None         */
/*                                                           */
/* Return:  0=success, otherwise an error number    */
/*                                                           */
/* Called By: ssp_SCGetClientMedicationDetails() in ClientMedications  */
/*                                                           */
/* Calls:                                                    */
/*                                                           */
/* Data Modifications:                                       */
/*                                                           */
/* Updates:  Edited By Rohit Verma on  09/07/2007            */
/*    Date        Author       Purpose                       */
/* 09/04/2007   Rohit Verma    Created                       */
/* 27/02/2008   Sonia  To get discontinued medications    */
/* 4thApril2008 Sonia  Modified (To accomodate data Model Changes of 2377)*/
/* 11thApril2007 Sonia Modified (To accomodate changes as per Task #1 Med Mgt -Support*/
/* 16thApril2008 Sonia (To accomodate changes related to retrieval of OrderStatus and OrderStatusDate*/
/* Changes as specified in 2377 SC-Support  i.e Logic of retrieval of StartDate,EndDate,OrderStatus and OrderStatusDate has been changed*/
/* Reference Task #38 Procedure altered to Display MedicationStartDate as ClientMedications.MedicationStartDate in case of refill and Min(ScriptDrugs.StartDate) in case of Change Order*/
/* 10/06/2008   Sonia   To Display Min(ScriptDrug.StartDate) in View History for refill case also*/
/* Reference Task Reference Task 1.5.3 - View Medication History: Start and End dates displaying wrong value  */
/* Reference Task #67 1.6.1 - Special Instructions Changes*/
/* Changes made to retrive SpecialInstructions value from ClientMedicationScriptDrugs*/
/* 16/01/2009   Loveena   To OrderDate in View History*/
/* 10/02/2009   Loveena   Ref to Task#2387 View History Sort Order*/
/* 11/04/2009   Loveena   To get OffLabel and DisContinuedReason in View History*/
/* 11/10/2009   Pradeep   select ClientMedication.PermitChengesByOtherUsers as per task#31 */
/* 11/04/2009   Loveena   To get Comments in View History*/
/* 8/17/2012    Kneale    Added Non Orders to #Temp table so start and end dates could be pulled and updated final sql select to pull in result start and end if null */
/* 10/24/2012   Kneale    Changed from join to left join on instructions table.  Some none ordered medications don't have any instructions. */
/* 10/30/2013   Kneale   Increase the Diagnosis Desc field to 7 characters to handle 123-123 */
/* May 20 2014  Chuck Blaine  Added column for determining if medications were added from SmartCare or not */
/* 3/25/2015  Steczynski    Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 */
/* Dec 29 2015  Malathi Shiva  When a queued order is cancelled/Voided it should display the status as Voided WRT Valley - Customizations: Task# 68 */
/* Apr 15 2016  Malathi Shiva	Discontinued medications were duplicating in Medication History screen because the discontinued medications were pulled as part of ordered medication select query 
								as well from a seperate query to select discontinued medication so there was duplicate entries displayed in the screen WRT Key Point - Support Go Live: Task# 217	*/
/* Apr 28 2016  Malathi Shiva	Special Instructions have 2 different entries in ClientMedicationScriptDrugs table but only one entry can be entered from ClientMedications table but 
								there is a group by using CMSD.SpecialInstructions which is displaying duplicate entries Core Bugs Task# 2003 */
/* Sep 22 2016	Malathi Shiva	KCMHSAS - Support: Task# 589 : When an order is discontinued, Medication History display the history of all the medication status to discontinued instead of showing the previous history */
/* Oct 3 2016	Malathi Shiva	Added User defined Medication tables used in the process of creating ClientMedications from Reconciliation for non-matching NDC codes. */
/* Sep 4 2017	Chethan N		What : Added condition to avoid displaying duplicate medication.
								Why : Renaissance - Dev Items task #5.1 */
--	jan  23 2018	 Mrunali        What : fetched Createdby column with Lastname and Firstname value of staff table and added DiscontinuedBy column (CreatedBy displays who added the medication.Discontinued By displays who discontinued the medication in format of 'LastName, Firstname')
--                                  Why  : Key Point-Enhancements #656
--	Feb  13 2018	 Mrunali        What : Added new  column in format of 'LastName, Firstname' 
--                                  Why  : Key Point-Enhancements #656
--   Aug  08/13/2018  PranayB       What/Why: Instructions are pulled from	ClientMedicationsScripts Drugs w.r.tTask# AHN 353 	
--   Sep 09/10/2018	  JyothiB      What/Why : For each medication,the Active  most recent activity should be at the top as defined by the order status date Non Active Medications (Have been discontinued)  should appear.CEI - Enhancements -# 910			
-- Nov   11/07/2018   Jyothi B    what/why : The script creation date will display as Orderstatus date for medications except discontinued medication. For discontinued medications discontinued is displayed as order status
--1/30/2019 Deej Added record deleted check in staff name selection.  KP SGL #1425
--   02/08/2019    Robert Caffrey  What/Why : Only Print Discontinued Reason for the latest Script - Else Reason shows multiple times in the History (Each Script) - Key point SGL #1447  
--   02/15/2019    Robert Caffrey  What/Why : Added logic for the Discontinued By showing as Well. Key Point SGL #1447   
/**********************************************************************/
BEGIN
	----Retrive StartDate and EndDate from ClientMedicationScriptDrugs                                                  
	CREATE TABLE #temp (
		MedicationStartDate DATETIME
		,MedicationEndDate DATETIME
		,clientmedicationid INT
		,ScriptEventType CHAR(1)
		,ScriptId INT
		,SpecialInstructions VARCHAR(1000)
		,OrderDate DATETIME
		,Ordered CHAR(1)
		)

	INSERT INTO #temp
	SELECT
		--Following changes by sonia                                           
		--Reference Task 1.5.3 - View Medication History: Start and End dates displaying wrong value                                          
		CASE CMS.ScriptEventType
			WHEN 'R'
				THEN CM.MedicationStartDate
			ELSE Min(CMSD.StartDate)
			END AS MedicationStartDate
		,
		--Min(CMSD.StartDate) as MedicationStartDate,              
		--changes end over here                                               
		Max(CMSD.EndDate) AS MedicationEndDate
		,cm.clientmedicationid
		,CMS.ScriptEventType AS ScriptEventType
		,CMS.ClientMedicationScriptId AS ScriptId
		,CMSD.SpecialInstructions AS SpecialInstructions
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
		AND ISNULL(CM.RecordDeleted, 'N') = 'N'
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
		,CMSD.SpecialInstructions
		,CMS.OrderDate
		,cm.Ordered
	ORDER BY cm.clientmedicationid

	---------------------- Client Medications ----------------------       
	CREATE TABLE #results (
		ClientMedicationId INT
		,ClientId INT
		,Ordered CHAR(1)
		,MedicationNameId INT
		,DrugPurpose VARCHAR(250)
		,DSMCode VARCHAR(7)
		,DSMNumber INT
		,NewDiagnosis CHAR(1)
		,PrescriberId INT
		,PrescriberName VARCHAR(100)
		,ExternalPrescriberName VARCHAR(50)
		,SpecialInstructions VARCHAR(1000)
		,DAW CHAR(1)
		,Discontinued CHAR(1)
		,DiscontinuedReason VARCHAR(1000)
		,DiscontinueDate DATETIME
		,RowIdentifier UNIQUEIDENTIFIER
		,CreatedBy VARCHAR(30)
		,CreatedDate DATETIME
		,ModifiedBy VARCHAR(30)
		,ModifiedDate DATETIME
		,RecordDeleted CHAR(1)
		,DeletedDate DATETIME
		,DeletedBy VARCHAR(30)
		,MedicationName VARCHAR(100)
		,PrescribedByName VARCHAR(100)
		,MedicationStartDate DATETIME
		,MedicationEndDate DATETIME
		,DxId VARCHAR(100)
		,MedicationName2 VARCHAR(100)
		,OrderStatus VARCHAR(20)
		,OrderStatusDate DATETIME
		,MedicationScriptId INT
		,OrderDate DATETIME
		,TitrationType CHAR(1)
		,OffLabel CHAR(1)
		,DiscontinuedReasonCode INT
		,PermitChangesByOtherUsers CHAR(1)
		,Comments VARCHAR(MAX)
		,SmartCareOrderEntry CHAR(1)
		,DiscontinuedBy VARCHAR(30)
		,AddedBy VARCHAR(30)
		)

	--Retreive results of Ordered Medications       
	INSERT INTO #results (
		ClientMedicationId
		,ClientId
		,Ordered
		,MedicationNameId
		,DrugPurpose
		,DSMCode
		,DSMNumber
		,NewDiagnosis
		,PrescriberId
		,PrescriberName
		,ExternalPrescriberName
		,SpecialInstructions
		,DAW
		,Discontinued
		,DiscontinuedReason
		,DiscontinueDate
		,RowIdentifier
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,MedicationName
		,PrescribedByName
		,MedicationStartDate
		,MedicationEndDate
		,DxId
		,MedicationName2
		,OrderStatus
		,OrderStatusDate
		,MedicationScriptId
		,OrderDate
		,TitrationType
		,OffLabel
		,DiscontinuedReasonCode
		,PermitChangesByOtherUsers
		,Comments
		,SmartCareOrderEntry
		,DiscontinuedBy
		,AddedBy
		)
	SELECT DISTINCT cm.ClientMedicationId
		,cm.ClientId
		,cm.Ordered
		,cm.MedicationNameId
		,cm.DrugPurpose
		,cm.DSMCode
		,cm.DSMNumber
		,cm.NewDiagnosis
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN cm.PrescriberId
			ELSE cms.OrderingPrescriberId
			END AS PrescriberId
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN cm.PrescriberName
			ELSE cms.OrderingPrescriberName
			END AS PrescriberName
		,cm.ExternalPrescriberName
		,t.SpecialInstructions
		,cm.DAW
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN cm.Discontinued
			ELSE NULL
			END AS Discontinued
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				AND cms.ScripteventType NOT IN (
					'N'
					,'C'
					,'R'
					)
				THEN cm.DiscontinuedReason
			ELSE NULL
			END AS DiscontinuedReason
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN cm.DiscontinueDate
			ELSE NULL
			END AS DiscontinueDate
		,cm.RowIdentifier
		,cm.CreatedBy
		,cm.CreatedDate
		,cm.ModifiedBy
		,cm.ModifiedDate
		,cm.RecordDeleted
		,cm.DeletedDate
		,cm.DeletedBy
		,ISNULL(mdn.MedicationName, UDMN.MedicationName) AS MedicationName
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN ISNULL(cm.PrescriberName, cm.ExternalPrescriberName)
			ELSE cms.OrderingPrescriberName
			END AS PrescribedByName
		,t.MedicationStartDate AS MedicationStartDate
		,t.MedicationEndDate AS MedicationEndDate
		,ISNULL(cm.DSMCode, '0') + '_' + ISNULL(Cast(cm.DSMNumber AS VARCHAR), '0') AS DxId
		,ISNULL(mdn.MedicationName, UDMN.MedicationName) AS MedicationName
		,CASE 
			--  WHEN ISNULL(CM.Discontinued, 'N') = 'Y' 
			--       AND Rtrim(CM.DiscontinuedReason) NOT IN ( 
			--           'Re-Order', 'Change Order' ) 
			--THEN 'Discontinued' 
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
		,
		--CASE 
		--  WHEN ISNULL(CM.Discontinued, 'N') = 'Y' 
		--       AND ISNULL(CM.Ordered, 'N') = 'Y' THEN 
		--  cm.DiscontinueDate 
		--  ELSE cms.ScriptCreationDate 
		--END                                          AS 
		--OrderStatusDate, 
		CASE 
			WHEN ISNULL(CMS.Voided, 'N') = 'Y'
				THEN cm.DiscontinueDate
			ELSE CASE CMS.ScriptEventType
					WHEN 'N'
						THEN cms.ScriptCreationDate
					WHEN 'C'
						THEN cms.ScriptCreationDate
					WHEN 'R'
						THEN cms.ScriptCreationDate
					END
			END AS OrderStatusDate
		,cms.ClientMedicationScriptId AS MedicationScriptId
		,t.OrderDate AS OrderDate
		,cm.TitrationType
		,cm.OffLabel
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				AND cms.ScripteventType NOT IN (
					'N'
					,'C'
					,'R'
					)
				THEN cm.DiscontinuedReasonCode
			ELSE NULL
			END AS DiscontinuedReasonCode
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN 'Y'
			ELSE cm.PermitChangesByOtherUsers
			END AS PermitChangesByOtherUsers
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN ''
			ELSE cm.Comments
			END AS Comments
		,cm.SmartCareOrderEntry
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				AND cms.ScripteventType NOT IN (
					'N'
					,'C'
					,'R'
					)
				THEN (
						SELECT s.LastName + ', ' + s.FirstName
						FROM staff s
						WHERE usercode = cm.modifiedby
							AND ISNULL(s.RecordDeleted, 'N') = 'N'
						)
			ELSE ''
			END AS DiscontinuedBy
		,(
			SELECT s.LastName + ', ' + s.FirstName
			FROM staff s
			WHERE usercode = cm.CreatedBy
				AND ISNULL(s.RecordDeleted, 'N') = 'N'
			) AS AddedBy
	FROM ClientMedications cm
	LEFT JOIN MDMedicationNames mdn ON (
			mdn.MedicationNameId = cm.MedicationNameId
			AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
			)
	LEFT JOIN UserDefinedMedicationNames UDMN ON (
			UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
			AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y'
			)
	JOIN ClientMedicationInstructions cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
		AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
	JOIN ClientMedicationScriptDrugs cmsd ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
		AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
	JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
		AND ISNULL(cms.RecordDeleted, 'N') = 'N'
	JOIN #temp t ON (
			t.Clientmedicationid = cm.Clientmedicationid
			AND t.ScriptEventType = cms.ScriptEventType
			AND cms.ClientMedicationScriptId = t.ScriptId
			AND t.ordered = 'Y'
			)
	WHERE cm.ClientId = @ClientId
		AND ISNULL(cm.RecordDeleted, 'N') = 'N'
		AND ISNULL(cm.Ordered, 'N') = 'Y'
		AND ISNULL(cms.WaitingPrescriberApproval, 'N') = 'N'
	
	UNION
	
	--Malathi Shiva 589 Changes starts here
	SELECT Main.ClientMedicationId
		,Main.ClientId
		,Main.Ordered
		,Main.MedicationNameId
		,Main.DrugPurpose
		,Main.DSMCode
		,Main.DSMNumber
		,Main.NewDiagnosis
		,Main.PrescriberId
		,Main.PrescriberName
		,Main.ExternalPrescriberName
		,Main.SpecialInstructions
		,Main.DAW
		,Main.Discontinued
		,Main.DiscontinuedReason
		,Main.DiscontinueDate
		,Main.RowIdentifier
		,Main.CreatedBy
		,Main.CreatedDate
		,Main.ModifiedBy
		,Main.ModifiedDate
		,Main.RecordDeleted
		,Main.DeletedDate
		,Main.DeletedBy
		,Main.MedicationName
		,Main.PrescribedByName
		,Main.MedicationStartDate
		,Main.MedicationEndDate
		,Main.DxId
		,Main.name1 AS MedicationName
		,Main.OrderStatus
		,Main.OrderStatusDate
		,Main.MedicationScriptId
		,Main.OrderDate
		,Main.TitrationType
		,Main.OffLabel
		,Main.DiscontinuedReasonCode
		,Main.PermitChangesByOtherUsers
		,Main.Comments
		,Main.SmartCareOrderEntry
		,Main.DiscontinuedBy
		,Main.AddedBy
	FROM (
		SELECT DISTINCT cm.ClientMedicationId
			,cm.ClientId
			,cm.Ordered
			,cm.MedicationNameId
			,cm.DrugPurpose
			,cm.DSMCode
			,cm.DSMNumber
			,cm.NewDiagnosis
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.PrescriberId
				ELSE cms.OrderingPrescriberId
				END AS PrescriberId
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.PrescriberName
				ELSE cms.OrderingPrescriberName
				END AS PrescriberName
			,cm.ExternalPrescriberName
			,t.SpecialInstructions
			,cm.DAW
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.Discontinued
				ELSE NULL
				END AS Discontinued
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.DiscontinuedReason
				ELSE NULL
				END AS DiscontinuedReason
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.DiscontinueDate
				ELSE NULL
				END AS DiscontinueDate
			,cm.RowIdentifier
			,cm.CreatedBy
			,cm.CreatedDate
			,cm.ModifiedBy
			,cm.ModifiedDate
			,cm.RecordDeleted
			,cm.DeletedDate
			,cm.DeletedBy
			,ISNULL(mdn.MedicationName, UDMN.MedicationName) AS MedicationName
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN ISNULL(cm.PrescriberName, cm.ExternalPrescriberName)
				ELSE cms.OrderingPrescriberName
				END AS PrescribedByName
			,t.MedicationStartDate AS MedicationStartDate
			,t.MedicationEndDate AS MedicationEndDate
			,ISNULL(cm.DSMCode, '0') + '_' + ISNULL(Cast(cm.DSMNumber AS VARCHAR), '0') AS DxId
			,ISNULL(mdn.MedicationName, UDMN.MedicationName) AS name1
			,
			-- today
			CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND Rtrim(CM.DiscontinuedReason) NOT IN (
						'Re-Order'
						,'Change Order'
						)
					THEN 'Discontinued'
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
			,
			-- end
			CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND Rtrim(CM.DiscontinuedReason) NOT IN (
						'Re-Order'
						,'Change Order'
						,'New'
						)
					THEN cm.DiscontinueDate
				WHEN ISNULL(CMS.Voided, 'N') = 'Y'
					THEN 'Voided'
				ELSE CASE CMS.ScriptEventType
						WHEN 'N'
							THEN cms.ScriptCreationDate
						WHEN 'C'
							THEN cms.ScriptCreationDate
						WHEN 'R'
							THEN cms.ScriptCreationDate
						END
				END AS OrderStatusDate
			,
			--CASE 
			--  WHEN ISNULL(CM.Discontinued, 'N') = 'Y' 
			--       AND ISNULL(CM.Ordered, 'N') = 'Y' THEN 
			--  cm.DiscontinueDate 
			--  ELSE cms.ScriptCreationDate 
			--END                                          AS 
			--OrderStatusDate, 
			cms.ClientMedicationScriptId AS MedicationScriptId
			,t.OrderDate AS OrderDate
			,cm.TitrationType
			,cm.OffLabel
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN cm.DiscontinuedReasonCode
				ELSE NULL
				END AS DiscontinuedReasonCode
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN 'Y'
				ELSE cm.PermitChangesByOtherUsers
				END AS PermitChangesByOtherUsers
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					AND ISNULL(CM.Ordered, 'N') = 'Y'
					THEN ''
				ELSE cm.Comments
				END AS Comments
			,cm.SmartCareOrderEntry
			,ROW_NUMBER() OVER (
				PARTITION BY cm.MedicationNameId ORDER BY cm.MedicationNameId ASC
					,cms.ClientMedicationScriptId DESC
				) AS RowCountNo
			,CASE 
				WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
					THEN (
							SELECT s.LastName + ' , ' + s.FirstName
							FROM staff s
							WHERE usercode = cm.modifiedby
								AND ISNULL(s.RecordDeleted, 'N') = 'N'
							)
				ELSE ''
				END AS DiscontinuedBy
			,(
				SELECT s.LastName + ' , ' + s.FirstName
				FROM staff s
				WHERE usercode = cm.CreatedBy
					AND ISNULL(s.RecordDeleted, 'N') = 'N'
				) AS AddedBy
		FROM ClientMedications cm
		LEFT JOIN MDMedicationNames mdn ON (
				mdn.MedicationNameId = cm.MedicationNameId
				AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
				)
		LEFT JOIN UserDefinedMedicationNames UDMN ON (
				UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
				AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y'
				)
		JOIN ClientMedicationInstructions cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
			AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
		JOIN ClientMedicationScriptDrugs cmsd ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
			AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
			AND ISNULL(cms.RecordDeleted, 'N') = 'N'
		JOIN #temp t ON (
				t.Clientmedicationid = cm.Clientmedicationid
				AND t.ScriptEventType = cms.ScriptEventType
				AND cms.ClientMedicationScriptId = t.ScriptId
				AND t.ordered = 'Y'
				)
		WHERE cm.ClientId = @ClientId
			AND ISNULL(cm.RecordDeleted, 'N') = 'N'
			AND ISNULL(cm.Ordered, 'N') = 'Y'
			AND ISNULL(cms.WaitingPrescriberApproval, 'N') = 'N'
			AND ISNULL(Discontinued, 'N') = 'Y'
		) Main
	WHERE RowCountNo = 1
	--Malathi Shiva 589 Changes end here
	
	UNION
	
	--Retreive results of Non Order Medications       
	SELECT DISTINCT cm.ClientMedicationId
		,cm.ClientId
		,cm.Ordered
		,cm.MedicationNameId
		,cm.DrugPurpose
		,cm.DSMCode
		,cm.DSMNumber
		,cm.NewDiagnosis
		,cm.PrescriberId
		,cm.PrescriberName
		,cm.ExternalPrescriberName
		,cm.SpecialInstructions
		,cm.DAW
		,cm.Discontinued
		,cm.DiscontinuedReason
		,cm.DiscontinueDate
		,cm.RowIdentifier
		,cm.CreatedBy
		,cm.CreatedDate
		,cm.ModifiedBy
		,cm.ModifiedDate
		,cm.RecordDeleted
		,cm.DeletedDate
		,cm.DeletedBy
		,ISNULL(mdn.MedicationName, UDMN.MedicationName) AS MedicationName
		,ISNULL(cm.PrescriberName, cm.ExternalPrescriberName) AS PrescribedByName
		,
		--cm.MedicationStartDate , 
		t.MedicationStartDate AS MedicationStartDate
		,t.MedicationEndDate AS MedicationEndDate
		,
		--cm.MedicationEndDate , 
		ISNULL(cm.DSMCode, '0') + '_' + ISNULL(Cast(cm.DSMNumber AS VARCHAR), '0') AS DxId
		,ISNULL(mdn.MedicationName, UDMN.MedicationName) AS MedicationName
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
		,- 1 AS MedicationScriptId
		,t.MedicationStartDate AS OrderDate
		,cm.TitrationType
		,cm.OffLabel
		,
		--Added by Loveena in ref to Task#2433 to get Off Label and DisContinueReason in View History      
		cm.DiscontinuedReasonCode
		,cm.PermitChangesByOtherUsers
		,
		--Aded by Pradeep as per task#31       
		cm.Comments
		,-- Added by Loveena in ref to Task#32       
		cm.SmartCareOrderEntry
		,CASE 
			WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
				THEN (
						SELECT s.LastName + ' , ' + s.FirstName
						FROM staff s
						WHERE usercode = cm.modifiedby
							AND ISNULL(s.RecordDeleted, 'N') = 'N'
						)
			ELSE ''
			END AS DiscontinuedBy
		,(
			SELECT s.LastName + ', ' + s.FirstName
			FROM staff s
			WHERE usercode = cm.CreatedBy
				AND ISNULL(s.RecordDeleted, 'N') = 'N'
			) AS AddedBy
	FROM ClientMedications CM
	LEFT JOIN MDMedicationNames mdn ON (
			mdn.MedicationNameId = cm.MedicationNameId
			AND ISNULL(mdn.RecordDeleted, 'N') = 'N'
			)
	LEFT JOIN UserDefinedMedicationNames UDMN ON (
			UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
			AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y'
			)
	LEFT OUTER JOIN ClientMedicationInstructions cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
		AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
	JOIN #temp t ON (
			t.Clientmedicationid = cm.Clientmedicationid
			AND t.ordered = 'N'
			)
	WHERE cm.ClientId = @ClientId
		AND ISNULL(cm.RecordDeleted, 'N') = 'N'
		AND ISNULL(cm.Ordered, 'N') = 'N'
	ORDER BY OrderDate
		,MedicationScriptId DESC

	SELECT ClientMedicationId
		,ClientId
		,Ordered
		,MedicationNameId
		,DrugPurpose
		,DSMCode
		,DSMNumber
		,NewDiagnosis
		,PrescriberId
		,PrescriberName
		,ExternalPrescriberName
		,SpecialInstructions
		,DAW
		,Discontinued
		,DiscontinuedReason
		,DiscontinueDate
		,RowIdentifier
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,MedicationName
		,PrescribedByName
		,MedicationStartDate
		,MedicationEndDate
		,DxId
		,MedicationName2
		,OrderStatus
		,OrderStatusDate
		,MedicationScriptId
		,OrderDate
		,TitrationType
		,OffLabel
		,DiscontinuedReasonCode
		,PermitChangesByOtherUsers
		,Comments
		,SmartCareOrderEntry
		,DiscontinuedBy
		,AddedBy
		,ROW_NUMBER() OVER (
			PARTITION BY ClientMedicationId ORDER BY CASE OrderStatus
					WHEN 'New'
						THEN 1
					WHEN 'Re-Ordered'
						THEN 2
					WHEN 'Changed'
						THEN 3
					WHEN 'Discontinued'
						THEN 4
					ELSE 5
					END ASC
			) AS Row#
	FROM #results
	ORDER BY isnull(Discontinued, 'N') ASC
		,ClientMedicationId DESC
		,OrderStatusDate DESC
		,Row# DESC
		,CASE OrderStatus
			WHEN 'New'
				THEN 1
			WHEN 'Re-Ordered'
				THEN 2
			WHEN 'Changed'
				THEN 3
			WHEN 'Discontinued'
				THEN 4
			ELSE 5
			END

	----------------- End of Client Medications --------------------       
	---------------------- Client Medication Instructions ----------------------       
	-- Loveena - I have removed the "cmi.*" from the query.  Please add only the columns you need.      
	SELECT cmi.ClientMedicationInstructionId
		,cmi.ClientMedicationId
		,cmi.StrengthId
		,cmi.Quantity
		,cmi.Unit
		,cmi.Schedule
		,cmi.TitrationStepNumber
		,cmi.Active
		,cmi.RowIdentifier
		,cmi.CreatedBy
		,cmi.CreatedDate
		,cmi.ModifiedBy
		,cmi.ModifiedDate
		,cmi.RecordDeleted
		,cmi.DeletedDate
		,cmi.DeletedBy
		,(ISNULL(MD.StrengthDescription, ISNULL(UDM.StrengthDescription, '')) + ' ' + ISNULL(dbo.ssf_RemoveTrailingZeros(CMI.Quantity), '') + ' ' + ISNULL(GC.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '')) AS Instruction
		,r.MedicationName AS 'MedicationName'
		,r.OrderStatus AS MedicationOrderStatus
		,ISNULL(cms.ClientMedicationScriptId, - 1) AS MedicationScriptId
		,ISNULL(cmsd.StartDate, r.MedicationStartDate) AS StartDate
		,ISNULL(cmsd.EndDate, r.MedicationEndDate) AS EndDate
		,
		--Added by Loveena as to Filter of MedicationNameId,PrescriberId applies to Instructions Table so to get the Column        
		r.MedicationNameId
		,r.PrescriberId
		,
		--Added by Loveena         
		r.DiscontinuedReasonCode
	FROM ClientMedicationInstructions cmi
	JOIN #results AS r ON (r.clientmedicationId = cmi.clientMedicationid)
	LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = cmi.Unit)
	LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = cmi.Schedule)
	LEFT JOIN MDMedications MD ON (
			MD.MedicationID = cmi.StrengthId
			AND ISNULL(MD.RecordDeleted, 'N') = 'N'
			)
	LEFT JOIN UserDefinedMedications UDM ON (
			UDM.UserDefinedMedicationNameId = CMI.UserDefinedMedicationId
			AND ISNULL(UDM.RecordDeleted, 'N') <> 'Y'
			)
	LEFT JOIN ClientMedicationScriptDrugs cmsd ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
		AND cmsd.ClientMedicationScriptId = r.MedicationScriptId
		AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
	LEFT JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
		AND ISNULL(cms.RecordDeleted, 'N') = 'N'
		AND NOT EXISTS (
			SELECT 1
			FROM ClientOrderMedicationReferences COMR
			WHERE CMI.ClientMedicationInstructionId = COMR.ClientMedicationInstructionId
				AND ISNULL(CMI.Active, 'N') = 'N'
			)
	ORDER BY r.MedicationStartDate
		,r.MedicationEndDate

	DROP TABLE #temp

	DROP TABLE #results

	----------------- End of Client Medication Instructions --------------------       
	IF (@@error != 0)
	BEGIN
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientMedicationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);

		RETURN (1)
	END

	RETURN (0)
END
GO

