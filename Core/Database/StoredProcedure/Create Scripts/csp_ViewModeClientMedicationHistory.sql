/****** Object:  StoredProcedure [dbo].[csp_ViewModeClientMedicationHistory]    Script Date: 5/6/2013 4:39:15 PM ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_ViewModeClientMedicationHistory]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[csp_ViewModeClientMedicationHistory]
GO

/****** Object:  StoredProcedure [dbo].[csp_ViewModeClientMedicationHistory]  245,'11-07-10','11-07-18','expand' Script Date: 5/6/2013 4:39:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
    
CREATE PROCEDURE [dbo].[csp_ViewModeClientMedicationHistory]    
    (    
      @ClientId INT  ,   
      @StartDate DATETIME ,    
      @EndDate DATETIME,  
      @ExpandCollapseAll varchar(15)=null  
    )    
AS
  /*
/	Purpose: Used for View Mode RDL of Client Medication History
/	Created Date		Created BY
/	2/22/2008			avoss
/	Modified Date		Modified By		Reason
/   7/17/2008			avoss			To Correct for new joins in mm
/   3/27/2013           kalpers         Changed how the start and end dates are determined
/                                       and changed the start and end dates columns that were
/                                       being used.  Added left join on Instructions, ScriptDrugs
/                                       and scripts to allow non-ordered drugs to show up on the list.
/   5/6/2013            kalpers         Added logic to exclude none ordered medications that are flagged as ordered
/	3/25/2015			Steczynski		Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215
/   10/17/2016			Anto     		Removed the active check condition with ClientMedicationInstructions table for SWMBH - Support : Task# 930,Key Point - Support Go Live #218 and Summit Pointe - Support: Task# 645
/   10/03/2018          jyothi         For each medication, the most recent activity should be at the top as defined by the order status date : CEI - Enhancements -# 910
/   11/07/2018          Jyothi         The script creation date will display as Orderstatus date for medications except discontinued medication. For discontinued medications discontinued is displayed as order status.
/   11/28/2018          PranayB        Added CMSD.SpecialInstructions w.r.t Rx Hotpack Issues Task 2.1
*/
 

    
--GO    
  DECLARE @expandcollapse AS VARCHAR(10)

SET @expandcollapse = 'expand';

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
--LEFT JOIN ClientMedicationInstructions CMI ON CMI.ClientMedicationId = CM.ClientMedicationId 
RIGHT JOIN ClientMedicationInstructions CMI ON CMI.ClientMedicationId = CM.ClientMedicationId
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
	--,CASE 
	--	WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
	--		AND ISNULL(CM.Ordered, 'N') = 'Y'
	--		THEN cm.DiscontinueDate
	--	ELSE cms.ScriptCreationDate
	--	END AS OrderStatusDate
	  ,CASE 
                         WHEN ISNULL(CMS.Voided, 'N') = 'Y' THEN cm.DiscontinueDate 
                        ELSE 
                          CASE CMS.ScriptEventType 
                            WHEN 'N' THEN cms.ScriptCreationDate 
                            WHEN 'C' THEN cms.ScriptCreationDate 
                            WHEN 'R' THEN cms.ScriptCreationDate 
                          END 
                             
                      END                                          AS 
                     OrderStatusDate
	,cms.ClientMedicationScriptId AS MedicationScriptId
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
	,CASE 
		WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
			THEN (
					SELECT s.LastName + ', ' + s.FirstName
					FROM staff s
					WHERE usercode = cm.modifiedby
					)
		ELSE ''
		END AS DiscontinuedBy
	,(
		SELECT s.LastName + ', ' + s.FirstName
		FROM staff s
		WHERE usercode = cm.CreatedBy
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
	AND T.MedicationStartDate >= @StartDate
	AND t.MedicationEndDate <= @EndDate

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
		,CASE 
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
		--,CASE 
		--	WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
		--		AND ISNULL(CM.Ordered, 'N') = 'Y'
		--		THEN cm.DiscontinueDate
		--	ELSE cms.ScriptCreationDate
		--	END AS OrderStatusDate
		, CASE 
                        WHEN ISNULL(CM.Discontinued, 'N') = 'Y' 
                             AND Rtrim(CM.DiscontinuedReason) NOT IN ( 
                                 'Re-Order', 'Change Order','New' ) 
                      THEN    cm.DiscontinueDate 
                      ELSE                        
                      cms.ScriptCreationDate
                      END
                      AS OrderStatusDate
		,cms.ClientMedicationScriptId AS MedicationScriptId
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
						)
			ELSE ''
			END AS DiscontinuedBy
		,(
			SELECT s.LastName + ' , ' + s.FirstName
			FROM staff s
			WHERE usercode = cm.CreatedBy
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
		AND T.MedicationStartDate >= @StartDate
		AND t.MedicationEndDate <= @EndDate
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
					)
		ELSE ''
		END AS DiscontinuedBy
	,(
		SELECT s.LastName + ', ' + s.FirstName
		FROM staff s
		WHERE usercode = cm.CreatedBy
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
	AND T.MedicationStartDate >= @StartDate
	AND t.MedicationEndDate <= @EndDate
ORDER BY OrderDate
	,MedicationScriptId DESC

CREATE TABLE #ClientMedicatedDataSearch (
	ClientMedicationId INT
	,MedicationName VARCHAR(200)
	,OrderStatus VARCHAR(24)
	,OrderStatusDate DATETIME
	,DrugPurpose VARCHAR(250)
	,DSMCode VARCHAR(15)
	,PrescriberName VARCHAR(100)
	,ExternalPrescriberName VARCHAR(50)
	,SpecialInstructions VARCHAR(1000)
	,DiscontinuedReason VARCHAR(1000)
	,Discontinued CHAR(1)
	,MedicationScriptId INT
	)

INSERT INTO #ClientMedicatedDataSearch
SELECT ClientMedicationId
	,MedicationName
	,OrderStatus
	,OrderStatusDate
	,DrugPurpose
	,DSMCode
	,PrescriberName
	,ExternalPrescriberName
	,SpecialInstructions
	,DiscontinuedReason
	,Discontinued
	,MedicationScriptId
FROM #results
ORDER BY MedicationName
	,OrderStatusDate
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
CREATE TABLE #ClientMedicatedData (
	ClientMedicationInstructionId INT
	,ClientId INT
	,Ordered CHAR(1)
	,OrderDate DATETIME
	,MedicationName VARCHAR(200)
	,PrescriberName VARCHAR(100)
	,ExternalPrescriberName VARCHAR(50)
	,SpecialInstructions VARCHAR(1000)
	,DrugPurpose VARCHAR(250)
	,DSMCode VARCHAR(15)
	,Discontinued CHAR(1)
	,StrengthId INT
	,Quantity DECIMAL(10, 2)
	,Unit INT
	,Schedule INT
	,TitrationStepNumber INT
	,OrderStatusDate DATETIME
	,Instruction VARCHAR(100)
	,OrderStatus VARCHAR(24)
	,ClientMedicationId INT
	,StartDate DATETIME
	,EndDate DATETIME
	,MedicationNameId INT
	,PrescriberId INT
	,DiscontinuedReasonCode INT
	,Days INT
	,Pharmacy DECIMAL(10, 2)
	,Sample DECIMAL(10, 2)
	,Stock DECIMAL(10, 2)
	,Refills DECIMAL(10, 2)
	,MedicationScriptId INT
	)

INSERT INTO #ClientMedicatedData
SELECT DISTINCT cmi.ClientMedicationInstructionId
	,r.ClientId
	,r.Ordered
	,cms.OrderDate
	,r.MedicationName AS 'MedicationName'
	,r.PrescriberName
	,r.ExternalPrescriberName
	,r.SpecialInstructions
	,r.DrugPurpose
	,r.DSMCode
	,r.Discontinued
	,cmi.StrengthId
	,cmi.Quantity
	,cmi.Unit
	,cmi.Schedule
	,cmi.TitrationStepNumber
	,CASE 
		WHEN ISNULL(r.Discontinued, 'N') = 'Y'
			AND RTRIM(r.DiscontinuedReason) NOT IN (
				'Re-Order'
				,'Change Order'
				)
			THEN r.DiscontinueDate
		ELSE CMS.ScriptCreationDate
		END AS OrderStatusDate
	,(ISNULL(MD.StrengthDescription, ISNULL(UDM.StrengthDescription, '')) + ' ' + ISNULL(dbo.ssf_RemoveTrailingZeros(CMI.Quantity), '') + ' ' + ISNULL(GC.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '')) AS Instruction
	,r.OrderStatus AS OrderStatus
	,CM.ClientMedicationId
	-- ,ISNULL(cmsd.StartDate, r.MedicationStartDate) AS StartDate    
	--,ISNULL(cmsd.EndDate, r.MedicationEndDate) AS EndDate   
	,r.MedicationStartDate AS StartDate
	,r.MedicationEndDate AS EndDate
	,r.MedicationNameId
	,r.PrescriberId
	,r.DiscontinuedReasonCode
	,cmsd.Days
	,cmsd.Pharmacy
	,cmsd.Sample
	,cmsd.Stock
	,cmsd.Refills
	,ISNULL(cms.ClientMedicationScriptId, - 1) AS MedicationScriptId --DID modified  jyo  
FROM ClientMedicationInstructions cmi
INNER JOIN #results AS r ON (r.clientmedicationId = cmi.clientMedicationid) -- add left  
INNER JOIN #ClientMedicatedDataSearch CM ON CM.ClientMedicationId = cmi.ClientMedicationId
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
			AND (
				(
					CASE 
						WHEN @StartDate IS NULL
							THEN 1
						ELSE CASE 
								WHEN ISNULL(CMSD.StartDate, r.MedicationStartDate) >= @StartDate
									OR ISNULL(cmsd.EndDate, r.MedicationEndDate) >= @StartDate
									THEN 1
								ELSE CASE 
										WHEN ISNULL(cmsd.EndDate, r.MedicationEndDate) IS NULL
											THEN 1
										ELSE 0
										END
								END
						END = 1
					)
				AND (
					(
						CASE 
							WHEN @EndDate IS NULL
								OR ISNULL(cmsd.EndDate, r.MedicationEndDate) IS NULL
								THEN 1
							ELSE CASE 
									WHEN r.MedicationEndDate <= @EndDate
										OR ISNULL(CMSD.StartDate, r.MedicationStartDate) <= @EndDate
										THEN 1
									ELSE CASE 
											WHEN ISNULL(cmsd.EndDate, r.MedicationEndDate) IS NULL
												THEN 1
											ELSE 0
											END
									END
							END = 1
						)
					)
				)
			AND @ClientId = r.ClientId
			AND (
				CASE 
					WHEN r.Ordered = 'Y'
						AND cms.ClientMedicationScriptId IS NULL
						THEN 0
					ELSE 1
					END
				) = 1
		)
ORDER BY CM.ClientMedicationId DESC
	,OrderStatusDate DESC
	,r.MedicationStartDate DESC
	,r.MedicationEndDate

CREATE TABLE #ClientMedicatedDataSearchList (
	ClientMedicationId INT
	,MedicationName VARCHAR(200)
	,OrderStatus VARCHAR(24)
	,OrderStatusDate DATETIME
	,DrugPurpose VARCHAR(250)
	,DSMCode VARCHAR(15)
	,PrescriberName VARCHAR(100)
	,ExternalPrescriberName VARCHAR(50)
	,SpecialInstructions VARCHAR(1000)
	,DiscontinuedReason VARCHAR(1000)
	,Discontinued CHAR(1)
	,MedicationScriptId INT
	,MedicationStartDate DATETIME
	,MedicationEndDate DATETIME
	,OrderDate DateTime
	)

INSERT INTO #ClientMedicatedDataSearchList
SELECT ClientMedicationId
	,MedicationName
	,OrderStatus
	,OrderStatusDate
	,DrugPurpose
	,DSMCode
	,PrescriberName
	,ExternalPrescriberName
	,SpecialInstructions
	,DiscontinuedReason
	,Discontinued
	,MedicationScriptId
	,MedicationStartDate
	,MedicationEndDate
	,OrderDate DateTime
FROM #results
WHERE ClientMedicationId IN (
		SELECT DISTINCT ClientMedicationId
		FROM #ClientMedicatedData
		)
ORDER BY isnull(Discontinued, 'N') ASC
	,ClientMedicationId DESC
	,OrderStatusDate DESC
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
				END DESC
		)

SELECT S.ClientMedicationInstructionId
	,S.ClientId
	,S.Ordered	
	,S.MedicationName 
	,S.PrescriberName
	,S.ExternalPrescriberName 
	,S.SpecialInstructions 
	,S.DrugPurpose 
	,S.DSMCode 
	,S.Discontinued 
	,S.StrengthId 
	,S.Quantity 
	,S.Unit 
	,S.Schedule 
	,S.TitrationStepNumber	
	,S.Instruction 
	,S.OrderStatus 
	,S.ClientMedicationId 
	,S.StartDate 
	,S.EndDate 
	,S.MedicationNameId 
	,S.PrescriberId
	,S.DiscontinuedReasonCode 
	,S.Days 
	,S.Pharmacy 
	,S.Sample 
	,S.Stock 
	,S.Refills 
	,S.MedicationScriptId 
	,t.OrderDate
	,t.OrderStatusDate
INTO #FinalResult
FROM #ClientMedicatedData s
JOIN (
	SELECT ClientMedicationId
		,OrderStatus
		,MedicationScriptId
		,OrderStatusDate
		,OrderDate
	FROM #ClientMedicatedDataSearchList
	) T ON s.ClientMedicationId = T.ClientMedicationId
	AND s.OrderStatus = T.OrderStatus
	AND s.MedicationScriptId = T.MedicationScriptId

IF @expandcollapse = @ExpandCollapseAll
	SELECT *
	FROM #FinalResult
	ORDER BY isnull(Discontinued, 'N') ASC
		,ClientMedicationId DESC
		,OrderStatusDate DESC
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
				END DESC
ELSE
	SELECT *
	FROM (
		SELECT *
			,Row_number() OVER (
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
				END DESC 
				) rno
		FROM #FinalResult
		) a
	WHERE rno = 1
	ORDER BY isnull(Discontinued, 'N') ASC
		,ClientMedicationId DESC
		,OrderStatusDate DESC
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
				END DESC
 IF (@@error != 0)    
 BEGIN    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_ViewModeClientMedicationHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT
  
(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
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
--END    
    
    

