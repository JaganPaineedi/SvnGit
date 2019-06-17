if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_SCGetRefillRequests]')
                    and type in ( N'P', N'PC' ) ) 
    drop procedure [dbo].ssp_SCGetRefillRequests
GO

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

      
create PROCEDURE [dbo].[ssp_SCGetRefillRequests]    --92,0    
    @StaffId INT ,
    @PrescriberId INT
AS 
    BEGIN TRY        
/*********************************************************************/        
/* Stored Procedure: dbo.ssp_SCGetRefillRequests      */        
        
/* Copyright: 2005 Provider Claim Management System      */        
        
/* Creation Date:  30th Jan 2010                */        
/*                                                                   */        
/* Purpose: Gets Prescriber proxies staff        */        
/*                                                                   */        
/* Input Parameters: None  @CurrentLoginUser                         */        
/*                                                                   */        
/* Output Parameters:             */        
/*                                                                   */        
/* Return:                */        
/*                                                                   */        
/* Called By:               */        
/*                  */        
/*                                                                   */        
/* Calls:                                                            */        
/*                                                                   */        
/* Data Modifications:                                               */        
/*                                                                   */        
/*   Updates:                                                        */        
/*       Date              Author                  Purpose           */        
/*  30th Jan2010      Chandan Srivastava           Created           */        
/*    28th Dec 2010   Priya                        Modified              */  
/*   9 March 2011     Pradeep                      Modified as per task#3325*/     
/*   Sept 13, 2013    Kalpers    Added new columns for the SureScriptsRefillRequests */ 
/*   November 1, 2013    Kneale              Added the service level  */
/*   March 2, 2018    Wasif              Added PharmacyFullName */
/*   March 20,2018    PranayBodhu        Added RxRequestsListDuration w.r.t CEI - Support Go Live: #924*/
/*   April 01,2018    PranayBodhu        Removed  ssf_ReformatPharmacyFullName call. why-Causing performance issue. 
     11 Dec 2018      Jyothi             What/Why:Journey-Support Go Live-#1566 - If Client doesn't have access to client,respective client records will not show.
  */
/*********************************************************************/        
      DECLARE @ListViewDuration INT= 90;
      SELECT    @ListViewDuration = ABS(CONVERT(INT, Value))
      FROM      SystemConfigurationKeys
      WHERE     [Key] = 'RxRequestsListDuration'
                AND ISNULL(RecordDeleted, 'N') = 'N'
                AND ISNUMERIC(Value) = 1; 
        SELECT      DISTINCT
                ssrr.SureScriptsRefillRequestId ,
                ssrr.SureScriptsIncomingMessageId ,
                ssrr.StatusOfRequest ,
                ssrr.RxReferenceNumber ,
                ssrr.PrescriberOrderNumber ,
                ssrr.SureScriptsPrescriberId ,
                ssrr.PrescriberLastName ,
                ssrr.PrescriberFirstName ,
                ssrr.PrescriberMiddleName,
                ssrr.PrescriberAddress1,
                ssrr.PrescriberAddress2,
                ssrr.PrescriberCity, 
                ssrr.PrescriberState,
                ssrr.PrescriberZip,
                ssrr.PrescriberPhone,
                ssrr.PrescriberFax,
                RTRIM(LTRIM(ssrr.PrescriberLastName)) + ', '
                + RTRIM(LTRIM(ssrr.PrescriberFirstName)) AS PrescriberName ,
                ssrr.PrescriberId ,
                ssrr.ClientLastName ,
                ssrr.ClientFirstName ,
                RTRIM(LTRIM(ssrr.ClientLastName)) + ', '
                + RTRIM(LTRIM(ssrr.ClientFirstName)) AS PatientName ,
                ssrr.ClientMiddleName,
                ssrr.ClientAddress1,
                ssrr.ClientAddress2,
                ssrr.ClientCity,
                ssrr.ClientState,
                ssrr.ClientZip,
                ssrr.ClientPhone,
                ssrr.ClientFax,
                ssrr.ClientSex ,
                ssrr.ClientDOB ,
                ssrr.ClientIdentifier ,
                ssrr.ClientId ,
                ssrr.SureScriptsPharmacyId ,
                ssrr.PharmacyName ,
                ssrr.PharmacyAddress ,
                ssrr.PharmacyCity ,
                ssrr.PharmacyState ,
                ssrr.PharmacyZip,
                ssrr.PharmacyPhoneNumber,
                ssrr.PharmacyFaxNumber,
                ssrr.PharmacyId ,
                ssrr.DrugDescription ,
                ssrr.DrugCode ,
                ssrr.ClientMedicationScriptDrugStrengthId ,
                ssrr.NumberOfDaysSupply ,
                ssrr.RefillType ,
                ssrr.NumberOfRefills ,
                ssrr.RowIdentifier ,
                ssrr.CreatedBy ,
                ssrr.CreatedDate ,
                ssrr.ModifiedBy ,
                ssrr.ModifiedDate ,
                ssrr.RecordDeleted ,
                ssrr.DeletedDate ,
                ssrr.DeletedBy ,
                cm.ClientMedicationId ,
                md.MedicationName ,
                CASE WHEN cms.SureScriptsRefillRequestId IS NOT NULL THEN 0
                     ELSE 1
                END AS IsExistSureScriptRequestRefillId ,
                ssrr.QuantityQualifier ,
                ssrr.QuantityValue ,
                ssrr.Substitutions ,
                ssrr.Directions ,
                ssrr.Note ,
                ISNULL(ssrr.PotencyUnitCode,'C38046') AS PotencyUnitCode ,
				ISNULL(map2.SmartCareRxCode,'Unspecified') AS PotencyUnitCodeDesc ,
                ssrr.writtendate ,
				ssrr.diagnosis1,
				ssrr.diagnosis2,
				ssrr.PriorAuthStatus,
				'' AS PriorAuthStatusValue,
				ssrr.PriorAuthQualifier,
				'' AS PriorAuthQualifierValue,
				ssrr.PriorAuthValue,
                CASE WHEN C.LastName <> ssrr.ClientLastName THEN C.LastName
                     ELSE '0'
                END AS SameLastName ,
                CASE WHEN C.FirstName <> ssrr.ClientFirstName THEN C.FirstName
                     ELSE '0'
                END AS SameFirstName ,
                CAST(ssrr.QuantityValue AS VARCHAR) + ' x '
                + ISNULL(map.SmartCareRxCode, '') AS PharmacyText ,
                ISNULL(MDDrugs.DEACODE, '0') AS DrugCategory ,
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
                ISNULL(ssrr.DispensedPotencyUnitCode,'C38046') AS DispensedPotencyUnitCode ,
				ISNULL(map3.SmartCareRxCode,'Unspecified') as DispensedPotencyUnitCodeDesc ,
                ssrr.dispensedwrittendate,
				ssrr.DispensedDiagnosis1,
				ssrr.DispensedDiagnosis2,
				ssrr.DispensedPriorAuthStatus,
				'' AS DispensedPriorAuthStatusValue,
				ssrr.dispensedPriorAuthQualifier,
				'' AS DispensedPriorAuthQualifierValue,
				ssrr.DispensedPriorAuthValue,
				LTRIM(RTRIM(ISNULL(gc.ExternalCode1, '0'))) AS ServiceLevel
				, LEFT(p.PharmacyName
                                     + CASE WHEN p.SureScriptsPharmacyIdentifier IS NOT NULL
                                            THEN ISNULL(' - '
                                                        + CASE
                                                              WHEN LTRIM(p.City) = ''
                                                              THEN NULL
                                                              ELSE p.City
                                                          END + ', '
                                                        + CASE
                                                              WHEN LTRIM(p.State) = ''
                                                              THEN NULL
                                                              ELSE p.State
                                                          END, '')
                                                 + ISNULL(' - '
                                                          + CASE
                                                              WHEN LTRIM(p.Address) = ''
                                                              THEN NULL 
												--DJH 10.14.2012 removed line feed and carriage return
                                                              ELSE REPLACE(REPLACE(REPLACE(LTRIM(p.Address),
                                                              CHAR(13), '~'),
                                                              CHAR(10), '~'),
                                                              '~', ' ')
                                                            END, '')
                                            ELSE ''
                                       END, 100) AS PharmacyFullName
        FROM    SureScriptsRefillRequests ssrr
                JOIN Staff s ON s.StaffId = ssrr.PrescriberId
                                AND ISNULL(ssrr.RecordDeleted, 'N') = 'N'
                                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                LEFT JOIN ClientMedicationScriptDrugStrengths csds ON csds.ClientMedicationScriptDrugStrengthId = ssrr.ClientMedicationScriptDrugStrengthId
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
                LEFT JOIN ClientMedicationScripts cms ON cms.SureScriptsRefillRequestId = ssrr.SureScriptsRefillRequestId
                left join Clients C ON C.ClientId = ssrr.ClientId
                LEFT JOIN StaffClients sc on sc.StaffId = @PrescriberId 
                                  and sc.ClientId = ssrr.ClientId 
				LEFT JOIN dbo.GlobalCodes gc ON ( gc.GlobalCodeId = s.SureScriptsServiceLevel
                                                  AND gc.Category = 'SURESCRIPTSLEVEL'
                                                  AND gc.Active = 'Y'
                                                  AND ISNULL(gc.RecordDeleted,
                                                             'N') = 'N'
                                                )
                LEFT JOIN SurescriptsCodes AS map ON map.Category = 'QUANTITYTYPE'
                                                     AND map.SurescriptsCode = ssrr.QuantityQualifier
                                                     AND ISNULL(map.RecordDeleted,
                                                              'N') = 'N'
				LEFT JOIN SureScriptsCodes AS map2 ON(map2.Category = 'QuantityUnitOfMeasure' AND map2.SureScriptsCode=ssrr.PotencyUnitCode)
				LEFT JOIN SureScriptsCodes AS map3 ON(map3.Category = 'QuantityUnitOfMeasure' AND map3.SureScriptsCode=ssrr.DispensedPotencyUnitCode)
				LEFT JOIN dbo.Pharmacies p ON p.SureScriptsPharmacyIdentifier=ssrr.SureScriptsPharmacyId
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
                AND ssrr.StatusOfRequest = 'R'
			    AND
				CONVERT(DATE,ssrr.CreatedDate) >= CONVERT(DATE,DATEADD(dd,-@ListViewDuration, GETDATE()))
        ORDER BY PatientName DESC        
        
        
        
        
    END TRY        
    BEGIN CATCH        
        DECLARE @err_msg NVARCHAR(4000)        
        DECLARE @err_severity INT ,
            @err_state INT        
        
        SET @err_msg = 'ssp_SCGetRefillRequests: ' + ERROR_MESSAGE()        
        SET @err_severity = ERROR_SEVERITY()        
        SET @err_state = ERROR_STATE()        
        RAISERROR(@err_msg, @err_severity, @err_state)        
        
    END CATCH




GO

