IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCGetChangeRequests]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SCGetChangeRequests;
GO

SET QUOTED_IDENTIFIER OFF;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE [dbo].[ssp_SCGetChangeRequests]    --92,0    
    @StaffId INT ,
    @PrescriberId INT
AS
    BEGIN TRY        
/*********************************************************************/        
---Copyright: 2017 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : Pranay

---Purpose:To get the change request

---Input Parameters: @StaffId,@PrescriberId

---Return:Change List Medication Order

---Called by:Application
---Log:
--	Date                     Author                             Purpose
--  03/07/2018             Pranay              Added PharmacyFullName 
/*********************************************************************/      
        --SET @StaffId=13323
		--SET @PrescriberId=13323
           SELECT      DISTINCT
                sscr.SureScriptsChangeRequestId ,
                sscr.SureScriptsIncomingMessageId ,
                sscr.StatusOfRequest ,
                sscr.RxReferenceNumber ,
                sscr.PrescriberOrderNumber ,
                sscr.SureScriptsPrescriberId ,
                sscr.PrescriberLastName ,
                sscr.PrescriberFirstName ,
                sscr.PrescriberMiddleName,
                sscr.PrescriberAddress1,
                sscr.PrescriberAddress2,
                sscr.PrescriberCity, 
                sscr.PrescriberState,
                sscr.PrescriberZip,
                sscr.PrescriberPhone,
                sscr.PrescriberFax,
                RTRIM(LTRIM(sscr.PrescriberLastName)) + ', '
                + RTRIM(LTRIM(sscr.PrescriberFirstName)) AS PrescriberName ,
                sscr.PrescriberId ,
                sscr.ClientLastName ,
                sscr.ClientFirstName ,
                RTRIM(LTRIM(sscr.ClientLastName)) + ', '
                + RTRIM(LTRIM(sscr.ClientFirstName)) AS PatientName ,
                sscr.ClientMiddleName,
                sscr.ClientAddress1,
                sscr.ClientAddress2,
                sscr.ClientCity,
                sscr.ClientState,
                sscr.ClientZip,
                sscr.ClientPhone,
                sscr.ClientFax,
                sscr.ClientSex ,
                sscr.ClientDOB ,
                sscr.ClientIdentifier ,
                sscr.ClientId ,
                sscr.SureScriptsPharmacyId ,
                sscr.PharmacyName ,
                sscr.PharmacyAddress ,
                sscr.PharmacyCity ,
                sscr.PharmacyState ,
                sscr.PharmacyZip,
                sscr.PharmacyPhoneNumber,
                sscr.PharmacyFaxNumber,
                sscr.PharmacyId ,
                sscr.DrugDescription ,
                sscr.DrugCode ,
                sscr.ClientMedicationScriptDrugStrengthId ,
                sscr.NumberOfDaysSupply ,
                sscr.RefillType ,
                sscr.NumberOfRefills ,
                sscr.RowIdentifier ,
                sscr.CreatedBy ,
                sscr.CreatedDate ,
                sscr.ModifiedBy ,
                sscr.ModifiedDate ,
                sscr.RecordDeleted ,
                sscr.DeletedDate ,
                sscr.DeletedBy ,
                cm.ClientMedicationId AS ClientMedicationId ,
                md.MedicationName AS MedicationName ,
                0 AS IsExistSureScriptRequestRefillId ,
                sscr.QuantityQualifier ,
                sscr.QuantityValue ,
                sscr.Substitutions ,
                sscr.Directions ,
                sscr.Note ,
                ISNULL(sscr.PotencyUnitCode,'C38046') AS PotencyUnitCode ,
				ISNULL(map2.SmartCareRxCode,'Unspecified') AS PotencyUnitCodeDesc  ,
                sscr.writtendate ,
				sscr.diagnosis1,
				sscr.diagnosis2,
				sscr.PriorAuthStatus,
				'' AS PriorAuthStatusValue,
				sscr.PriorAuthQualifier,
				'' AS PriorAuthQualifierValue,
				sscr.PriorAuthValue,
                 sscr.ClientLastName  AS SameLastName ,
                sscr.ClientFirstName AS SameFirstName ,
                CAST(sscr.QuantityValue AS VARCHAR) + ' x ' AS PharmacyText ,
                ISNULL(MDDrugs.DEACODE, '0') AS DrugCategory    ,
				LTRIM(RTRIM(ISNULL(gc.ExternalCode1, '0'))) AS ServiceLevel 
				,sscr.ChangeRequestType
				,sscr.PayerId
				,sscr.BINLocationNumber
				,sscr.PayerName
				,sc.SureScriptsChangeMedicationRequests
				,dbo.ssf_ReformatPharmacyFullName(SureScriptsPharmacyId) AS [PharmacyFullName]
        FROM    dbo.SureScriptsChangeRequests sscr
                JOIN Staff s ON s.StaffId = sscr.PrescriberId
                                AND ISNULL(sscr.RecordDeleted, 'N') = 'N'
                                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                LEFT JOIN ClientMedicationScriptDrugStrengths csds ON csds.ClientMedicationScriptDrugStrengthId = sscr.ClientMedicationScriptDrugStrengthId
                LEFT JOIN ClientMedications cm ON cm.ClientMedicationId = csds.ClientMedicationId        
--Added For Ref:Task No:3274     
                LEFT JOIN ClientMedicationInstructions ON ClientMedicationInstructions.ClientMedicationId = CM.ClientMedicationId
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
                LEFT JOIN ClientMedicationScripts cms ON cms.SureScriptsChangeRequestId = sscr.SureScriptsChangeRequestId
                left join Clients C ON C.ClientId = sscr.ClientId
				LEFT JOIN dbo.GlobalCodes gc ON ( gc.GlobalCodeId = s.SureScriptsServiceLevel
                                                  AND gc.Category = 'SURESCRIPTSLEVEL'
                                                  AND gc.Active = 'Y'
                                                  AND ISNULL(gc.RecordDeleted,
                                                             'N') = 'N'
                                                )
                LEFT JOIN SurescriptsCodes AS map ON map.Category = 'QUANTITYTYPE'
                                                     AND map.SurescriptsCode = sscr.QuantityQualifier
                                                     AND ISNULL(map.RecordDeleted,
                                                              'N') = 'N'
				LEFT JOIN SureScriptsCodes AS map2 ON(map2.Category = 'QuantityUnitOfMeasure' AND map2.SureScriptsCode=sscr.PotencyUnitCode)
				--LEFT JOIN SureScriptsCodes AS map3 ON(map3.Category = 'QuantityUnitOfMeasure' AND map3.SureScriptsCode=sscr.RequestedPotencyUnitCode)
				LEFT JOIN dbo.SurescriptsChangeDenials scd ON scd.SurescriptsChangeRequestId=sscr.SureScriptsChangeRequestId
			--	LEFT JOIN dbo.SureScriptsChangeMedicationRequests sscmr ON sscmr.SureScriptChangeRequestedId=sscr.SureScriptsChangeRequestId
				LEFT JOIN (SELECT DISTINCT ST2.SureScriptChangeRequestedId, 
  REPLACE(REPLACE(SUBSTRING(
      (
          SELECT ' <tr><td>' + ST1.RequestedDrugDescription + '</td></tr>' +
'<tr><td><b>Qty:</b>'+cast((convert (decimal(10,3), ST1.RequestedQuantityValue)) as varchar(15))+' '++' '+
'<b>Refills:</b>'+CONVERT(VARCHAR(25),isnull(ST1.RequestedNumberOfRefills,''))
+' '++' '+
+'<b>Days:</b>'+ISNULL(CONVERT(VARCHAR(25),ST1.RequestedNumberOfDaysSupply), '')+
+' '++' '+
+'<b>DAW:</b>'+CASE WHEN ST1.RequestedSubstitutions = '1' THEN 'Y'          
                             ELSE 'N'  END+
'</td></tr>' 
+'<tr><td>'+'<b>Potency:</b>'+ISNULL(map3.SmartCareRxCode,'Unspecified')+' '+'
<b>WrittenDate:</b>'+CONVERT(VARCHAR(8), ST1.RequestedWrittenDate, 1) + '</td></tr>'
+'<tr><td><b>Directions:</b>'+ST1.RequestedDirections + '</td></tr>' +
'<tr><td><b>Note:</b>'+ST1.RequestedNote + '</td></tr>'
          From dbo.SureScriptsChangeMedicationRequests ST1
		  LEFT  JOIN SureScriptsCodes AS map3 ON(map3.Category = 'QuantityUnitOfMeasure' AND map3.SureScriptsCode=ST1.RequestedPotencyUnitCode)
          Where ST1.SureScriptChangeRequestedId = ST2.SureScriptChangeRequestedId
          ORDER BY ST1.SureScriptChangeRequestedId
          For XML PATH ('')
      ), 2, 5000),'&lt;','<'),'&gt;','>') [SureScriptsChangeMedicationRequests]
From dbo.SureScriptsChangeMedicationRequests ST2) sc ON sc.SureScriptChangeRequestedId = sscr.SureScriptsChangeRequestId
        WHERE   (        
--   -- match on selected prescriber or all accessible prescribers        
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
                AND sscr.StatusOfRequest = 'C'
				AND cms.SureScriptsChangeRequestId IS NULL
                AND scd.SurescriptsChangeRequestId IS NULL
				AND sscr.SureScriptsChangeRequestId NOT IN(SELECT SureScriptsChangeRequestId FROM dbo.SureScriptsChangeApprovals)
        ORDER BY PatientName DESC        
        
        
        
    END TRY        
    BEGIN CATCH        
        DECLARE @err_msg NVARCHAR(4000);        
        DECLARE @err_severity INT ,
            @err_state INT;        
        
        SET @err_msg = 'ssp_SCGetChangeRequests: ' + ERROR_MESSAGE();        
        SET @err_severity = ERROR_SEVERITY();        
        SET @err_state = ERROR_STATE();        
        RAISERROR(@err_msg, @err_severity, @err_state);        
        
    END CATCH;




GO

