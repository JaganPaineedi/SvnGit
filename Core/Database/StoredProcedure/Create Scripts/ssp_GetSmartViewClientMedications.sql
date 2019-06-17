/****** Object:  StoredProcedure [dbo].[ssp_GetSmartViewClientMedications]    Script Date: 10/17/2017 15:02:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSmartViewClientMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSmartViewClientMedications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSmartViewClientMedications] 13460   Script Date: 10/17/2017 15:02:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

               
CREATE proc [dbo].[ssp_GetSmartViewClientMedications]        
(                      
  @ClientId int                           
)                      
as                  
/******************************************************************************                        
**  File: ssp_GetSmartViewClientMedications.sql                       
**  Name: ssp_GetSmartViewClientMedications   66899 55762
**  Desc: To Retrive SmartView Sections Data.
**  Return values:                        
**  Parameters:                     
**  Auth: Manjunath K                        
**  Date: 28 OCT 2017             
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:      Author:     Description:                        
**  ---------  --------    -------------------------------------------                        
**      
*************************************************************************************/                      
BEGIN                     
                
BEGIN TRY                 

 --#region Current Medication
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
  AND NOT EXISTS(SELECT 1 FROM ClientOrderMedicationReferences COMR WHERE CMI.ClientMedicationInstructionId = 
  COMR.ClientMedicationInstructionId  AND ISNULL(CMI.Active, 'N') = 'N')  
   AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
   AND ((ISNULL(CM.Discontinued, 'N') = 'N')  AND ISNULL(CMS.Voided, 'N') = 'N')
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
    AND ISNULL(mdn.RecordDeleted, 'N') = 'N')  
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
  JOIN MDMedications MD ON (MD.MedicationID = CMI.StrengthId)  
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CMI.Unit  
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'  
  LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CMI.Schedule  
   AND ISNULL(GC1.RecordDeleted, 'N') = 'N'  
  WHERE cm.ClientId = @ClientId  
   AND ISNULL(cm.RecordDeleted, 'N') = 'N'  
   AND ISNULL(cm.Ordered, 'N') = 'Y'  
   AND ISNULL(cms.WaitingPrescriberApproval, 'N') = 'N'     
   AND ((ISNULL(CM.Discontinued, 'N') = 'N')AND ISNULL(CMS.Voided, 'N') = 'N')
   --AND (  
   -- @RxStart IS NULL  
   -- OR cast(ISNULL(cmsd.StartDate, t.MedicationStartDate) AS DATE) >= cast(@RxStart AS DATE)  
   -- )  
   --AND (  
   -- @RxEnd IS NULL  
   -- OR cast(ISNULL(cmsd.EndDate, t.MedicationEndDate) AS DATE) <= cast(@RxEnd AS DATE)  
   -- OR (  
   --  cast(ISNULL(cmsd.StartDate, t.MedicationStartDate) AS DATE) <= cast(@RxEnd AS DATE)  
   --  AND cast(@RxEnd AS DATE) < cast(ISNULL(cmsd.EndDate, t.MedicationEndDate) AS DATE)  
   --  )  
   -- )  
   AND PrescriberName IS NOT NULL  
    
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
     AND ISNULL(CM.Ordered, 'N') = 'Y'  
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
  JOIN MDMedications MD ON (MD.MedicationID = CMI.StrengthId)  
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CMI.Unit  
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'  
  LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CMI.Schedule  
   AND ISNULL(GC1.RecordDeleted, 'N') = 'N'  
  WHERE cm.ClientId = @ClientId  
   AND ISNULL(cm.RecordDeleted, 'N') = 'N'  
   AND ISNULL(cm.Ordered, 'N') = 'N'  
   AND ISNULL(CM.Discontinued, 'N') = 'N'
   --AND (  
   -- @RxStart IS NULL  
   -- OR cast(t.MedicationStartDate AS DATE) >= cast(@RxStart AS DATE)  
   -- )  
   --AND (  
   -- @RxEnd IS NULL  
   -- OR cast(t.MedicationEndDate AS DATE) <= cast(@RxEnd AS DATE)  
   -- OR (  
   --  cast(t.MedicationStartDate AS DATE) <= cast(@RxEnd AS DATE)  
   --  AND cast(@RxEnd AS DATE) < cast(t.MedicationEndDate AS DATE)  
   --  )  
   -- )  
   AND PrescriberName IS NOT NULL  
   
   
	SELECT 
	MedicationName AS Name,
	Instruction,
	CONVERT(VARCHAR(10),RxStart,101) As Start,
	CONVERT(VARCHAR(10),RxEnd,101) As [End]
	FROM #ResultSet

END TRY                                                                                    
BEGIN CATCH                                        
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                 
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                
'ssp_GetSmartViewClientMedications')                                                                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                                                
 RAISERROR                                                                                       
 (                                                                                     
  @Error, -- Message text.                                                                                                       
  16, -- Severity.                                                                                                                  
  1 -- State.                                           
 );                                                                                                                
END CATCH                  
end
GO