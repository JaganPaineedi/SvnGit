
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMedicationReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMedicationReconciliation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE Procedure [dbo].[ssp_GetMedicationReconciliation]        
 @DocumentVersionId INT            
 AS            
 /*********************************************************************/                                                                                                  
 /* Stored Procedure: ssp_GetMedicationReconciliation  3315968               */                                                                                         
 /* Creation Date:  21/August/2017                                    */
 /* Author : Arjun K R                                                */                                                                                                  
 /* Purpose: To Get Medication Reconciliation                         */                                                                                                 
 /* Input Parameters: @DocumentVersionId                              */                                                                                                
 /* Output Parameters:                                                */                                                                                                  
 /* Return:                                                           */                                                                                                  
 /* Data Modifications:                                               */                                                                                                  
 /* Updates:                                                          */                                                                                                                  
 /* Date              Author                  Purpose                 */  
 /* 17/08/2018       Arjun K R               Modified to add new column "DiscontinuedMedications" in select query for Task #2 Denton Customization */  
 /* 08/10/2018       Neha                    Added a new table which takes care of the other external medications. Task #6120.1 Comprehensive Customizations. */
 /* 12/06/2018		Shankha B			Modified to get correct Start Date as reported in (Meaningful Use - Environment Issues Tracking #  7)*/									
 /*********************************************************************/               
              
  Begin                                        
  Begin TRY   
  
  DECLARE @ClientId INT
  SET @ClientId=(SELECT D.ClientId 
				 FROM Documents AS D
				 JOIN DocumentVersions as DV on DV.DocumentId = D.DocumentId 
				 WHERE DV.DocumentVersionId=@DocumentVersionId)         
  
    DECLARE @LastScriptIdTable TABLE (  
   ClientMedicationInstructionId INT  
   ,ClientMedicationScriptId INT  
   )  
  
  INSERT INTO @LastScriptIdTable (  
   ClientMedicationInstructionId  
   ,ClientMedicationScriptId  
   )  
  SELECT ClientMedicationInstructionId  
   ,ClientMedicationScriptId  
  FROM (  
   SELECT cmsd.ClientMedicationInstructionId  
    ,cmsd.ClientMedicationScriptId  
    ,cms.OrderDate  
    ,ROW_NUMBER() OVER (  
     PARTITION BY cmsd.ClientMedicationInstructionId ORDER BY cms.OrderDate DESC  
      ,cmsd.ClientMedicationScriptId DESC  
     ) AS rownum  
   FROM ClientMedicationScriptDrugs cmsd  
   INNER JOIN ClientMedicationScripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)  
   WHERE ClientMedicationInstructionId IN (  
     SELECT ClientMedicationInstructionId  
     FROM clientmedications a  
     INNER JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)  
     WHERE a.ClientId = @ClientId  
      AND ISNULL(a.RecordDeleted, 'N') = 'N'  
      AND ISNULL(b.Active, 'Y') = 'Y'  
      AND ISNULL(b.RecordDeleted, 'N') = 'N'  
     )  
    AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'  
    AND ISNULL(cms.RecordDeleted, 'N') = 'N'  
    AND ISNULL(cms.Voided, 'N') = 'N'  
   ) AS a  
  WHERE rownum = 1  
  
 
  SELECT [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[ReconciliationType]
      ,[ClientCCDId]
      ,[Comment]
      ,[ExternalReferenceId]
  FROM [DocumentMedicationReconciliations] DMR
  WHERE ISNULL(DMR.RecordDeleted,'N')='N'
  AND DMR.DocumentVersionId=@DocumentVersionId
          
   SELECT MRCM.[MedicationReconciliationCurrentMedicationId]
      ,MRCM.[CreatedBy]
      ,MRCM.[CreatedDate]
      ,MRCM.[ModifiedBy]
      ,MRCM.[ModifiedDate]
      ,MRCM.[RecordDeleted]
      ,MRCM.[DeletedBy]
      ,MRCM.[DeletedDate]
      ,MRCM.[DocumentVersionId]
      ,MRCM.[ClientMedicationInstructionId]
      ,MRCM.[MedicationType]
      ,MRCM.[DiscontinuedMedication] --17/08/2018       Arjun K R
  FROM [MedicationReconciliationCurrentMedications] MRCM
  INNER JOIN [DocumentMedicationReconciliations] DMR ON DMR.DocumentVersionId=MRCM.DocumentVersionId
  WHERE ISNULL(DMR.RecordDeleted,'N')='N'
  AND MRCM.DocumentVersionId=@DocumentVersionId


  
  SELECT MCCD.[MedicationReconciliationCCDMedicationId]
      ,MCCD.[CreatedBy]
      ,MCCD.[CreatedDate]
      ,MCCD.[ModifiedBy]
      ,MCCD.[ModifiedDate]
      ,MCCD.[RecordDeleted]
      ,MCCD.[DeletedBy]
      ,MCCD.[DeletedDate]
      ,MCCD.[DocumentVersionId]
      ,MCCD.[ClientCCDId]
      ,MCCD.[MedicationNameId]
      ,MCCD.[StrengthId]
      ,MCCD.[RouteId]
      ,MCCD.[RXNormCode]
      ,MCCD.[MedicationName]
      ,MCCD.[Quantity]
      ,MCCD.[Unit]
      ,MCCD.[UnitId]
      ,MCCD.[StrengthDescription]
      ,MCCD.[MedicationRoute]
      ,MCCD.[Schedule]
      ,MCCD.[ScheduleId]
      ,MCCD.[MedicationStartDate]
      ,MCCD.[MedicationEndDate]
      ,MCCD.[AdditionalInformation]
      ,MCCD.[DiscontinuedMedication] --17/08/2018       Arjun K R
  FROM [MedicationReconciliationCCDMedications] MCCD
  INNER JOIN [DocumentMedicationReconciliations] DMR ON DMR.DocumentVersionId=MCCD.DocumentVersionId
  WHERE ISNULL(DMR.RecordDeleted,'N')='N'
  AND ISNULL(MCCD.RecordDeleted,'N')='N'
  AND MCCD.DocumentVersionId=@DocumentVersionId
  
 
 --added by Neha  
    SELECT MROED.[MedicationReconciliationExternalMedicationId]  
      ,MROED.[CreatedBy]  
      ,MROED.[CreatedDate]  
      ,MROED.[ModifiedBy]  
      ,MROED.[ModifiedDate]  
      ,MROED.[RecordDeleted]  
      ,MROED.[DeletedBy]  
      ,MROED.[DeletedDate]  
      ,MROED.[DocumentVersionId]  
      ,MROED.[ExternalReferenceId]  
      ,MROED.[MedicationNameId]  
      ,MROED.[StrengthId]  
      ,MROED.[RouteId]  
      ,MROED.[RXNormCode]  
      ,MROED.[MedicationName]  
      ,MROED.[Quantity]  
      ,MROED.[Unit]  
      ,MROED.[UnitId]  
      ,MROED.[StrengthDescription]  
      ,MROED.[MedicationRoute]  
      ,MROED.[Schedule]  
      ,MROED.[ScheduleId]  
      ,ISNULL(CONVERT(VARCHAR(10), MROED.[MedicationStartDate], 101), '')  as MedicationStartDate    
      ,ISNULL(CONVERT(VARCHAR(10), MROED.[MedicationEndDate], 101), '')  as MedicationEndDate     
      ,MROED.[AdditionalInformation]  
      ,MROED.[DiscontinuedMedication]
  FROM [MedicationReconciliationExternalMedications] MROED  
  INNER JOIN [DocumentMedicationReconciliations] DMR ON DMR.DocumentVersionId=MROED.DocumentVersionId  
  WHERE ISNULL(DMR.RecordDeleted,'N')='N'  
  AND ISNULL(MROED.RecordDeleted,'N')='N'  
  AND MROED.DocumentVersionId=@DocumentVersionId 
   
 SELECT DISTINCT CMI.ClientMedicationInstructionId  
     ,CM.CreatedBy
     ,CM.CreatedDate
     ,CM.ModifiedBy
     ,CM.ModifiedDate
     ,CM.RecordDeleted
     ,CM.DeletedBy
     ,CM.DeletedDate
     ,CM.ClientId
     ,ISNULL(CM.Ordered,'N') AS Ordered
     ,MDM.MedicationName AS MedicationName  
     ,MD.Strength+' '+ MD.StrengthUnitOfMeasure AS Strength  
     ,cast(CMI.Quantity as varchar)+'  '+ dbo.ssf_GetGlobalCodeNameById(CMI.Unit)  AS Dose  
     ,MR.RouteDescription AS [Route]  
     ,CASE  WHEN (cm.IncludeCommentOnPrescription = 'Y')  
      THEN COALESCE(dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) + ', ', '') + isnull(cm.comments, '')  
      ELSE dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId)  
      END AS Instructions  
     ,ISNULL(CONVERT(VARCHAR(10), CMSD.StartDate, 101), '') AS StrartDate  
     ,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS EndDate  
     ,CM.PrescriberName AS Prescriber 
     ,CASE WHEN ISNULL(MRCM.MedicationReconciliationCurrentMedicationId,0)<>0 THEN 'Y' ELSE 'N' END AS IsSelected
  FROM ClientMedicationInstructions CMI  
  LEFT JOIN [MedicationReconciliationCurrentMedications] MRCM ON MRCM.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
  INNER JOIN ClientMedications CM ON (CMI.ClientMedicationId = CM.ClientMedicationId  AND ISNULL(cm.RecordDeleted, 'N') <> 'Y')  
  LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit) AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'  
  LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'  
  INNER JOIN MDMedicationNames MDM ON (CM.MedicationNameId = MDM.MedicationNameId AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y')  
  INNER JOIN MDMedications MD ON (MD.MedicationID = CMI.StrengthId AND ISNULL(MD.RecordDeleted, 'N') <> 'Y')  
  INNER JOIN MDRoutes MR ON (MD.RouteID = MR.RouteID AND ISNULL(MR.RecordDeleted, 'N') <> 'Y')  
  INNER JOIN ClientMedicationScriptDrugs CMSD ON (CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y')  
  LEFT JOIN @LastScriptIdTable LSId ON (cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId)  
  LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
  WHERE cm.ClientId = @ClientId  
   AND cm.discontinuedate IS NULL  
   AND Isnull(Discontinued, 'N') <> 'Y'      
   AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())  
   AND ISNULL(cmi.Active, 'Y') = 'Y'  
   AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  
   AND (CMSD.ClientMedicationScriptId IS NULL OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId)  
   ORDER BY MDM.MedicationName        
                        
  END TRY                    
  BEGIN CATCH                                        
  If (@@error!=0)            
  Begin            
   RAISERROR  ('ssp_GetMedicationReconciliation: An Error Occured'   ,16,1)           
   Return            
   End                                                                                                         
  END CATCH                                                               
  END 