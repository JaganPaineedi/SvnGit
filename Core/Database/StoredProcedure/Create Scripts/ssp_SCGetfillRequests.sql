IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCGetfillRequests]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SCGetfillRequests;
GO

SET QUOTED_IDENTIFIER OFF;
SET ANSI_NULLS ON;
GO

      
CREATE PROCEDURE [dbo].[ssp_SCGetfillRequests]    --92,0    
    @StaffId INT ,
    @PrescriberId INT
AS
    BEGIN TRY        
/*********************************************************************/        
---Copyright: 2011 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : Pranay

---Purpose:To get the change request

---Input Parameters:  @StaffId INT ,
                  -- @PrescriberId INT
---Called by:Application
---Log:
--	Date                     Author                             Purpose
/*********************************************************************/     
         
        SELECT      DISTINCT
             
                RTRIM(LTRIM(ssrr.PrescriberLastName)) + ', '
                + RTRIM(LTRIM(ssrr.PrescriberFirstName)) AS OrderingPrescriberName ,
                RTRIM(LTRIM(ssrr.ClientLastName)) + ', '
                + RTRIM(LTRIM(ssrr.ClientFirstName)) AS PatientName ,
                ssrr.ClientId ,
              --  ssrr.SureScriptsPharmacyId ,
                ssrr.PharmacyName ,
                ssrr.CreatedDate ,
                CASE WHEN ISNULL(ssrr.DispensedDrugDescription, '') = ''
                     THEN ssrr.DrugDescription
                     ELSE ssrr.DispensedDrugDescription
                END AS MedicationName ,
                CASE WHEN cms.SureScriptsRefillRequestId IS NOT NULL THEN 0
                     ELSE 1
                END AS IsExistSureScriptRequestRefillId ,
                ssrr.Directions AS Instruction ,
                ssrr.Note ,
                'ELE' AS Method ,
                CASE WHEN C.LastName <> ssrr.ClientLastName THEN C.LastName
                     ELSE '0'
                END AS SameLastName ,
                CASE WHEN C.FirstName <> ssrr.ClientFirstName THEN C.FirstName
                     ELSE '0'
                END AS SameFirstName ,
                CAST(ssrr.QuantityValue AS VARCHAR) + ' x '
                + ISNULL(map.SmartCareRxCode, '') AS PharmacyText ,
                ISNULL(MDDrugs.DEACode, '0') AS DrugCategory ,
                ssrr.DispensedDrugDescription ,
                ssrr.DispensedDrugCode ,
                ssrr.DispensedClientMedicationScriptDrugStrengthId ,
                ssrr.DispensedNumberOfDaysSupply ,
                ssrr.DispensedRefillType ,
                ssrr.DispensedNumberOfRefills ,
                ssrr.DispensedQuantityQualifier ,
                ssrr.DispensedQuantityValue ,
                ssrr.DispensedSubstitutions ,
                ssrr.DispensedDirections ,
                ssrr.DispensedNote ,
                ISNULL(ssrr.DispensedPotencyUnitCode, 'C38046') AS DispensedPotencyUnitCode ,
                ISNULL(map3.SmartCareRxCode, 'Unspecified') AS DispensedPotencyUnitCodeDesc ,
                ssrr.DispensedWrittenDate ,
                ssrr.DispensedDiagnosis1 ,
                ssrr.DispensedDiagnosis2 ,
                ssrr.DispensedPriorAuthStatus ,
                '' AS DispensedPriorAuthStatusValue ,
                ssrr.DispensedPriorAuthQualifier ,
                '' AS DispensedPriorAuthQualifierValue ,
                ssrr.DispensedPriorAuthValue ,
                LTRIM(RTRIM(ISNULL(gc.ExternalCode1, '0'))) AS ServiceLevel ,
                ssrr.FillStatus AS [Status] ,
                ssrr.FillNote AS StatusDescription
        FROM    SureScriptsfillRequests ssrr
                JOIN Staff s ON s.StaffId = ssrr.PrescriberId
                                AND ISNULL(ssrr.RecordDeleted, 'N') = 'N'
                                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                LEFT JOIN ClientMedicationScriptDrugStrengths csds ON csds.ClientMedicationScriptDrugStrengthId = ssrr.ClientMedicationScriptDrugStrengthId
                LEFT JOIN ClientMedications cm ON cm.ClientMedicationId = csds.ClientMedicationId        
--Added For Ref:Task No:3274     
                LEFT JOIN ClientMedicationInstructions ON ClientMedicationInstructions.ClientMedicationId = cm.ClientMedicationId
                                                          AND ISNULL(ClientMedicationInstructions.Active,
                                                              'Y') = 'Y'
                                                          AND ISNULL(ClientMedicationInstructions.RecordDeleted,
                                                              'N') <> 'Y'
                LEFT JOIN MDMedications ON MDMedications.MedicationId = ClientMedicationInstructions.StrengthId
                                           AND ISNULL(dbo.MDMedications.RecordDeleted,
                                                      'N') <> 'Y'
                LEFT JOIN MDDrugs ON dbo.MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId
                                     AND ISNULL(dbo.MDDrugs.RecordDeleted, 'N') <> 'Y'                                                                                    
--end    
                LEFT JOIN MDMedicationNames md ON md.MedicationNameId = cm.MedicationNameId
                LEFT JOIN ClientMedicationScripts cms ON cms.SureScriptsRefillRequestId = ssrr.SureScriptsfillRequestId
                LEFT JOIN Clients C ON C.ClientId = ssrr.ClientId
                LEFT JOIN dbo.GlobalCodes gc ON ( gc.GlobalCodeId = s.SureScriptsServiceLevel
                                                  AND gc.Category = 'SURESCRIPTSLEVEL'
                                                  AND gc.Active = 'Y'
                                                  AND ISNULL(gc.RecordDeleted,
                                                             'N') = 'N'
                                                )
                LEFT JOIN SureScriptsCodes AS map ON map.Category = 'QUANTITYTYPE'
                                                     AND map.SureScriptsCode = ssrr.QuantityQualifier
                                                     AND ISNULL(map.RecordDeleted,
                                                              'N') = 'N'
                LEFT JOIN SureScriptsCodes AS map2 ON ( map2.Category = 'QuantityUnitOfMeasure'
                                                        AND map2.SureScriptsCode = ssrr.PotencyUnitCode
                                                      )
                LEFT JOIN SureScriptsCodes AS map3 ON ( map3.Category = 'QuantityUnitOfMeasure'
                                                        AND map3.SureScriptsCode = ssrr.DispensedPotencyUnitCode
                                                      )
        WHERE   (        
   -- match on selected prescriber or all accessible prescribers        
                  ( ( s.StaffId = @PrescriberId )
                    OR ( @PrescriberId = 0 )
                  )
                  AND ( s.StaffId = @StaffId -- logged-in staff is the prescriber        
                        OR ( EXISTS (           -- logged-in staff is a proxy for the prescriber        
                             SELECT *
                             FROM   PrescriberProxies AS pp
                             WHERE  pp.PrescriberId = s.StaffId
                                    AND pp.ProxyStaffId = @StaffId
                                    AND ISNULL(pp.RecordDeleted, 'N') <> 'Y' ) )
                      )
                )
                AND ssrr.StatusOfRequest = 'F'
        ORDER BY PatientName DESC;        
        
        
        
        
    END TRY        
    BEGIN CATCH        
        DECLARE @err_msg NVARCHAR(4000);        
        DECLARE @err_severity INT ,
            @err_state INT;        
        
        SET @err_msg = 'ssp_SCGetfillRequests: ' + ERROR_MESSAGE();        
        SET @err_severity = ERROR_SEVERITY();        
        SET @err_state = ERROR_STATE();        
        RAISERROR(@err_msg, @err_severity, @err_state);        
        
    END CATCH;




GO

