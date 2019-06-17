IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[scsp_SureScriptsScriptOutputApprovedWithChange]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE scsp_SureScriptsScriptOutputApprovedWithChange;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[scsp_SureScriptsScriptOutputApprovedWithChange]
    @ClientMedicationScriptId INT ,
    @PreviewData CHAR(1) ,-- Y/N
    @RefillResponseType CHAR(1) = NULL
AS /*****************************************************************************************************/
      
---Copyright: 2011 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : Pranay

---Purpose:To get the ApprovedWithChanges change request

---Return:Change List Medication Order

---Called by:Windows Service
---Log:
--	Date                     Author                             Purpose

--11/14/2017              PranayB                         Added Strength and Days w.r.t MU
/*****************************************************************************************************/
    BEGIN TRY
	--BEGIN TRAN
        DECLARE @SurescriptsChangeRequestId INT
        DECLARE @SessionId VARCHAR(24)

        SELECT  @SessionId = SessionId
        FROM    ClientMedicationScriptsPreview
        WHERE   ClientMedicationScriptId = @ClientMedicationScriptId

        IF ISNULL(@RefillResponseType, 'Z') <> 'N' 
            BEGIN
                IF @PreviewData = 'Y' 
                    BEGIN
                        SELECT  @SurescriptsChangeRequestId = SurescriptsChangeRequestId
                        FROM    ClientMedicationScriptsPreview
                        WHERE   ClientMedicationScriptId = @ClientMedicationScriptId
                    END
                ELSE 
                    BEGIN
                        SELECT  @SurescriptsChangeRequestId = SurescriptsChangeRequestId
                        FROM    ClientMedicationScripts
                        WHERE   ClientMedicationScriptId = @ClientMedicationScriptId
                    END
            END

			
        DECLARE @ScriptOutput TABLE
            (
              ClientMedicationScriptId INT ,
              PON VARCHAR(35) ,
              RxReferenceNumber VARCHAR(35) ,
              DrugDescription VARCHAR(250) ,
              SureScriptsQuantityQualifier VARCHAR(3) ,
              SureScriptsQuantity DECIMAL(29, 14) ,
              TotalDaysInScript INT ,
              ScriptInstructions VARCHAR(MAX) ,-- VARCHAR(140) ,
              ScriptNote VARCHAR(MAX) ,--VARCHAR(210) ,
              Refills INT ,
              DispenseAsWritten CHAR(1) ,-- Y/N
              OrderDate DATETIME ,
              NDC VARCHAR(35) ,
              RelatesToMessageID VARCHAR(35) ,
              PotencyUnitCode VARCHAR(35),
			  Strength VARCHAR(25)
            )
        DECLARE @DrugInfo TABLE
            (
              StrengthId INT ,
              PON VARCHAR(35) ,
              ScriptNote VARCHAR(MAX) ,-- VARCHAR(210) ,
              TextInstructions VARCHAR(2000) ,
              Refills INT ,
              Pharmacy DECIMAL(10, 2) ,
              PharmacyText VARCHAR(100) ,
              Days INT ,
              DispenseAsWritten CHAR(1) ,
              OrderDate DATETIME ,
              RxReferenceNumber VARCHAR(35) ,
              NDC VARCHAR(35) ,
              RelatesToMessageID VARCHAR(35) ,
              PotencyUnitCode VARCHAR(35)
            )
        DECLARE @Instructions TABLE
            (
              ClientMedicationInstructionId INT ,
              StrengthId INT ,
              Quantity DECIMAL(10, 2) ,
              Unit type_GlobalCode ,
              Schedule type_GlobalCode
            )


		IF  EXISTS ( SELECT    *
                         FROM      SureScriptsChangeRequests AS ssrr
                          WHERE     ssrr.SureScriptsChangeRequestId = @SurescriptsChangeRequestId
                                    AND ssrr.StatusOfRequest = 'C' ) 
            BEGIN       
                IF @PreviewData = 'Y' 
                    BEGIN
                        INSERT  INTO @DrugInfo
                                ( StrengthId ,
                                  PON ,
                                  ScriptNote ,
                                  TextInstructions ,
                                  Refills ,
                                  Pharmacy ,
                                  PharmacyText ,
                                  DispenseAsWritten ,
                                  OrderDate ,
                                  RxReferenceNumber ,
                                  RelatesToMessageID ,
                                  PotencyUnitCode
				                )
                                SELECT  cmsds.StrengthId ,
                                        'CHRES'
                                        + CAST(cmsds.ClientMedicationScriptDrugStrengthId AS VARCHAR)
                                        + CASE WHEN ssrr.SureScriptsChangeRequestId IS NULL
                                               THEN ''
                                               ELSE '_'
                                                    + CAST(ssrr.SureScriptsChangeRequestId AS VARCHAR)
                                          END + '_'
                                        + REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 126),
                                                          ':', ''), '-', '') ,
                                        sInfo.ScriptNote ,
                                        cmsds.SpecialInstructions ,
                                        ISNULL(sInfo.Refills, 0),
                                        sInfo.Pharmacy ,
                                        cmsds.PharmacyText ,
                                        sInfo.DispenseAsWritten ,
                                        GETDATE() ,-- per Surescripts, needs to be the current date regardless of what the user enters
                                        ssrr.RxReferenceNumber ,
                                        --CASE WHEN ISNULL(ssrr.StatusOfRequest,
                                        --                 ' ') = 'R'
                                        --          AND ISNULL(@RefillResponseType,
                                        --                     'Z') = 'N'
                                        --     THEN ISNULL(ssrd.DeniedMessageId,
                                        --                 ssim.SureScriptsMessageId)
                                              ssim.SureScriptsMessageId
                                        ,
                                        sinfo.PotencyUnitCode
                                FROM    ClientMedicationScriptsPreview AS cms
                                        JOIN ClientMedicationScriptDrugStrengthsPreview
                                        AS cmsds ON cmsds.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                        JOIN ( SELECT   cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode ,
                                                        SUM(cmsd.Pharmacy) AS Pharmacy ,
                                                        MAX(cm.DAW) AS DispenseAsWritten ,
                                                        MAX(CASE
                                                              WHEN ISNULL(cm.IncludeCommentOnPrescription,
                                                              'N') = 'Y'
                                                              THEN cm.Comments
                                                              ELSE NULL
                                                            END) AS ScriptNote,
                                                        MAX(Refills) as Refills
                                               FROM     ClientMedicationScriptDrugsPreview
                                                        AS cmsd
                                                        JOIN ClientMedicationInstructionsPreview
                                                        AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                                        JOIN ClientMedicationsPreview
                                                        AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                               WHERE    cmsd.ClientMedicationScriptId = @ClientMedicationScriptId
                                                        AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cm.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                                               GROUP BY cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode
                                             ) AS sInfo ON sInfo.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                           AND sinfo.StrengthId = cmsds.StrengthId
                                        LEFT OUTER JOIN SureScriptsChangeRequests
                                        AS ssrr ON ssrr.SureScriptsChangeRequestId = cms.SureScriptsChangeRequestId
                                        LEFT JOIN dbo.SureScriptsIncomingMessages ssim ON ( ssim.SureScriptsIncomingMessageId = ssrr.SureScriptsIncomingMessageId )
                                        LEFT JOIN dbo.SurescriptsChangeDenials ssrd ON ( ssrr.SureScriptsChangeRequestId = ssrd.SurescriptsChangeRequestId )
                                WHERE   cms.ClientMedicationScriptId = @ClientMedicationScriptId
                                        AND ISNULL(cmsds.RecordDeleted, 'N') <> 'Y'
                                        AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'

                        INSERT  INTO @Instructions
                                ( ClientMedicationInstructionId ,
                                  StrengthId ,
                                  Quantity ,
                                  Unit ,
                                  Schedule
				                )
                                SELECT  cmi.ClientMedicationInstructionId ,
                                        cmi.StrengthId ,
                                        cmi.Quantity ,
                                        cmi.Unit ,
                                        cmi.Schedule
                                FROM    ClientMedicationInstructionsPreview AS cmi /* DJH - Removed LEFT JOIN to prevent multiple instructions */
                                        JOIN ClientMedicationScriptDrugsPreview
                                        AS cmsd ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                                   AND cmsd.ClientMedicationScriptId = @ClientMedicationScriptId
                                        JOIN dbo.ClientMedicationScriptDrugStrengthsPreview
                                        AS cmsds ON ( cmsds.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                      AND cmsds.StrengthId = cmi.StrengthId
                                                    )
                                WHERE   cmi.SessionId = @SessionId
                                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                    END
                ELSE 
                    BEGIN
                 ---START To Get DRUG CATEGORY  
				    DECLARE @MedicationNameId INT;
                    DECLARE @OrderingMethod CHAR(1);
					DECLARE @TotalDays INT;
                    SELECT TOP 1
                            @MedicationNameId = MedName.MedicationNameId ,
                            @OrderingMethod = cms.OrderingMethod,
							@TotalDays=cmsd.Days
                    FROM    ClientMedicationScripts AS cms
                            JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                              AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                                              AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                                            AND ISNULL(cm.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
                                                              AND ISNULL(MedName.RecordDeleted,
                                                              'N') <> 'Y'
                    WHERE   @ClientMedicationScriptId = cms.ClientMedicationScriptId
                            AND ISNULL(cms.RecordDeleted, 'N') <> 'Y';

                    DECLARE @DrugCategory INT;
                    SELECT TOP 1
                            @DrugCategory = d.DEACode
                    FROM    MDMedications AS m
                            LEFT JOIN MDDrugs AS d ON d.ClinicalFormulationId = m.ClinicalFormulationId
                            LEFT JOIN MDMedications mdMed ON m.MedicationId = mdMed.MedicationId
                            LEFT JOIN MDMedicationNames mdMedNames ON mdMedNames.MedicationNameId = mdMed.MedicationNameId
                    WHERE   m.MedicationNameId = @MedicationNameId;
                    DECLARE @IsControlledDrug dbo.type_YOrN;
				---END TO GET DRUG CATEGORY
                        INSERT  INTO @DrugInfo
                                ( StrengthId ,
                                  PON ,
                                  ScriptNote ,
                                  TextInstructions ,
                                  Refills ,
                                  Pharmacy ,
                                  PharmacyText ,
                                  DispenseAsWritten ,
                                  OrderDate ,
                                  RxReferenceNumber ,
                                  RelatesToMessageID ,
                                  PotencyUnitCode
				                )
                                SELECT  cmsds.StrengthId ,
                                        'CHRES'
                                        + CAST(cmsds.ClientMedicationScriptDrugStrengthId AS VARCHAR)
                                        + CASE WHEN ssrr.SureScriptsChangeRequestId IS NULL
                                               THEN ''
                                               ELSE CAST(ssrr.SureScriptsChangeRequestId AS VARCHAR)
                                          END + '_'
                                        + REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 126),
                                                          ':', ''), '-', '') ,
                                        sInfo.ScriptNote ,
                                        cmsds.SpecialInstructions ,
                                        sInfo.Refills ,
                                        sInfo.Pharmacy ,
                                        cmsds.PharmacyText ,
                                        sInfo.DispenseAsWritten ,
                                        GETDATE() ,--cms.OrderDate, 
                                        ssrr.RxReferenceNumber ,
                                        --CASE WHEN ISNULL(ssrr.StatusOfRequest,
                                        --                 ' ') = 'N'
                                        --     THEN ISNULL(ssrd.DeniedMessageId,
                                        --                 '')
                                        --     ELSE ssim.SureScriptsMessageId
                                        --END ,
										ssim.SureScriptsMessageId,
                                        sinfo.PotencyUnitCode
                                FROM    ClientMedicationScripts AS cms
                                        JOIN ClientMedicationScriptDrugStrengths
                                        AS cmsds ON cmsds.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                        JOIN ( SELECT   cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode ,
                                                        SUM(cmsd.Pharmacy) AS Pharmacy ,
                                                        MAX(cm.DAW) AS DispenseAsWritten ,
                                                        MAX(CASE
                                                              WHEN ISNULL(cm.IncludeCommentOnPrescription,
                                                              'N') = 'Y'
                                                              THEN cm.Comments
                                                              ELSE NULL
                                                            END) AS ScriptNote,
                                                        MAX(cmsd.Refills) as Refills
                                               FROM     ClientMedicationScriptDrugs
                                                        AS cmsd
                                                        JOIN ClientMedicationInstructions
                                                        AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                                        JOIN ClientMedications
                                                        AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                               WHERE    cmsd.ClientMedicationScriptId = @ClientMedicationScriptId
                                                        AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cm.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                                               GROUP BY cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode
                                             ) AS sInfo ON sInfo.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                           AND sinfo.StrengthId = cmsds.StrengthId
                                        LEFT OUTER JOIN SureScriptsChangeRequests
                                        AS ssrr ON ssrr.SureScriptsChangeRequestId = cms.SureScriptsChangeRequestId
                                        LEFT JOIN dbo.SureScriptsIncomingMessages ssim ON ( ssim.SureScriptsIncomingMessageId = ssrr.SureScriptsIncomingMessageId )
                                        LEFT JOIN dbo.SurescriptsChangeDenials ssrd ON ( ssrr.SureScriptsChangeRequestId = ssrd.SurescriptsChangeRequestId )
                                WHERE   cms.ClientMedicationScriptId = @ClientMedicationScriptId
                                        AND ISNULL(cmsds.RecordDeleted, 'N') <> 'Y'
                                        AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'

                        INSERT  INTO @Instructions
                                ( ClientMedicationInstructionId ,
                                  StrengthId ,
                                  Quantity ,
                                  Unit ,
                                  Schedule
				                )
                                SELECT  cmi.ClientMedicationInstructionId ,
                                        cmi.StrengthId ,
                                        cmi.Quantity ,
                                        cmi.Unit ,
                                        cmi.Schedule
                                FROM    ClientMedicationInstructions AS cmi
                                        JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                        JOIN dbo.ClientMedicationScriptDrugStrengths
                                        AS cmsds ON ( cmsds.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                      AND cmsds.StrengthId = cmi.StrengthId
                                                    )
                                WHERE   cmsd.ClientMedicationScriptId = @ClientMedicationScriptId
                                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
                                        AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                                ORDER BY cmi.ClientMedicationInstructionId ASC
                    END

		--
		-- get a representative NDC number
		--
                DECLARE @NDC VARCHAR(35)

                SELECT TOP 1
                        @NDC = mdd.NationalDrugCode
                FROM    @DrugInfo AS d
                        JOIN MDMedications AS mdm ON mdm.MedicationId = d.StrengthId
                        JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                WHERE   mdd.ObsoleteDate IS NULL
                        AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y'
                ORDER BY mdd.NationalDrugCode

                UPDATE  @DrugInfo
                SET     NDC = @NDC

                DECLARE @sig VARCHAR(140)
                DECLARE @Quantity DECIMAL(10, 2) ,
                    @Units VARCHAR(250) ,
                    @Schedule VARCHAR(250)

		-- build the instruction string
                DECLARE cInstructions CURSOR
                FOR
                    SELECT  Quantity ,
                            gcUnit.CodeName ,
                            gcSchedule.CodeName
                    FROM    @Instructions AS i
                            LEFT JOIN GlobalCodes AS gcUnit ON gcUnit.GlobalCodeId = i.Unit
                            LEFT JOIN GlobalCodes AS gcSchedule ON gcSchedule.GlobalCodeId = i.Schedule
                    ORDER BY i.ClientMedicationInstructionId

                DECLARE @firstTime INT

                SET @firstTime = 1
                SET @sig = ''

                OPEN cInstructions

                FETCH cInstructions
		INTO @Quantity, @Units, @Schedule

                WHILE @@fetch_status = 0 
                    BEGIN
                        IF @firstTime = 0 
                            SET @sig = @sig + '; '
                        ELSE 
                            SET @firstTime = 0

                        SET @sig = @sig
                            + dbo.ssf_ConvertDecimalToVarchar(@Quantity)
                            + CASE WHEN @Units IS NOT NULL
                                   THEN ' (' + @Units + ')'
                                   ELSE ''
                              END + CASE WHEN @Schedule IS NOT NULL
                                         THEN ' ' + @Schedule
                                         ELSE ''
                                    END

                        FETCH cInstructions
			INTO @Quantity, @Units, @Schedule
                    END

                CLOSE cInstructions

                DEALLOCATE cInstructions

				
		-- get the drug description
                INSERT  INTO @ScriptOutput
                        ( ClientMedicationScriptId ,
                          DrugDescription ,
                          SureScriptsQuantity ,
                          SureScriptsQuantityQualifier ,
                          ScriptInstructions ,
                          ScriptNote ,
                          Refills ,
                          DispenseAsWritten ,
                          OrderDate ,
                          PON ,
                          RxReferenceNumber ,
                          NDC ,
                          RelatesToMessageID ,
                          PotencyUnitCode,
						  Strength
						  ,TotalDaysInScript
			            )
                        SELECT  @ClientMedicationScriptId ,
                                mdm.MedicationDescription ,
                                CASE WHEN di.PharmacyText IS NOT NULL
                                     THEN dbo.ssf_SureScriptsQuantityFromPharmacyText(di.PharmacyText)
                                     ELSE di.Pharmacy
                                END ,
                                ISNULL(map.SurescriptsCode, '00') ,
                                LTRIM(RTRIM(ISNULL(@sig, '')
                                            + CASE WHEN @sig IS NOT NULL
                                                   THEN '; '
                                                   ELSE ''
                                              END
                                            + LTRIM(RTRIM(ISNULL(di.TextInstructions,
                                                              ''))))) ,
                                LTRIM(RTRIM(di.ScriptNote)) ,
                                di.Refills ,
                                di.DispenseAsWritten ,
                                di.OrderDate ,
                                di.PON ,
                                di.RxReferenceNumber ,
                                di.NDC ,
                                di.RelatesToMessageID ,
                                CASE WHEN ISNULL(di.PotencyUnitCode,'') = '' THEN 'C38046' ELSE di.PotencyUnitCode END
								,Mdm.Strength
								,@TotalDays
                        FROM    MDMedications AS mdm
                                JOIN MDMedicationNames AS mdmn ON mdmn.MedicationNameId = mdm.MedicationNameId
                                JOIN @DrugInfo AS di ON di.StrengthId = mdm.MedicationId
                                LEFT JOIN MDClinicalFormulations AS mdcf ON mdcf.ClinicalformulationId = mdm.ClinicalformulationId
                                LEFT JOIN MDDosageFormCodes AS mddfc ON mddfc.DosageFormCodeId = mdcf.DosageFormCodeId
                                LEFT JOIN SureScriptsCodes AS map ON ( ( di.PharmacyText IS NULL
                                                              AND map.Category = 'DOSAGEFORM'
                                                              AND map.SmartCareRxCode = mddfc.DosageFormCode
                                                              )
                                                              OR ( di.PharmacyText IS NOT NULL
                                                              AND map.Category = 'PACKAGEDESCRIPTION'
                                                              AND map.SmartCareRxCode = dbo.ssf_SureScriptsPackageDescriptionFromPharmacyText(di.PharmacyText)
                                                              )
                                                              )
                               
            END
 

        SELECT  ClientMedicationScriptId ,
                PON ,
                RxReferenceNumber ,
                DrugDescription ,
                SureScriptsQuantityQualifier ,
                SureScriptsQuantity ,
                TotalDaysInScript ,
                ScriptInstructions ,
                ScriptNote ,
                refills ,
                DispenseAsWritten ,
                OrderDate ,
                NDC ,
                RelatesToMessageID ,
                PotencyUnitCode,
				@DrugCategory AS DrugCategory,
				Strength
        FROM    @ScriptOutput
		--COMMIT
    END TRY

    BEGIN CATCH
	
        DECLARE @VerboseInfo NVARCHAR(4000)
        SET @VerboseInfo = 'Error occurred in object "' + ERROR_PROCEDURE()
            + '" at line number ' + ERROR_LINE() + '.  Severity: '
            + ERROR_SEVERITY() + ' State: ' + ERROR_STATE() + ' :: '
            + 'ClientMedicationScriptId=' + @ClientMedicationScriptId

        INSERT  INTO dbo.ErrorLog
                ( ErrorMessage ,
                  VerboseInfo ,
                  DataSetInfo ,
                  ErrorType ,
                  CreatedBy ,
                  CreatedDate
		        )
        VALUES  ( ERROR_MESSAGE() , -- ErrorMessage - text
                  @VerboseInfo , -- VerboseInfo - text
                  '' , -- DataSetInfo - text
                  'Surescripts' , -- ErrorType - varchar(50)
                  SYSTEM_USER , -- CreatedBy - type_CurrentUser
                  CURRENT_TIMESTAMP  -- CreatedDate - type_CurrentDatetime
		        )
    END CATCH




GO

