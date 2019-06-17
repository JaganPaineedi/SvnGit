/****** Object:  StoredProcedure [dbo].[scsp_SureScriptsScriptOutputWithScriptDrugId]   ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[scsp_SureScriptsScriptOutputWithScriptDrugId]')
					AND type IN ( N'P', N'PC' ) )
	DROP PROCEDURE dbo.scsp_SureScriptsScriptOutputWithScriptDrugId
GO

/****** Object:  StoredProcedure [dbo].[scsp_SureScriptsScriptOutputWithScriptDrugId]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[scsp_SureScriptsScriptOutputWithScriptDrugId]
    @ClientMedicationScriptId INT ,
    @PreviewData CHAR(1) ,-- Y/N
    @RefillResponseType CHAR(1) = NULL
AS /***************************************************

	06/05/2012	dharvey		Removed Max on instructions to prevent quantity error 
	06/08/2012	dharvey		Restored Max value, and added grouping columns to correct
							multiple instruction of the same strength.
	12/17/2012	dharvey		Added JOIN on StrengthId in @DrugInfo to prevent invalid dose
    05/16/2013  Kalpers     Added additional join criteria because there seems to be a problem
	                        when an order that was originally faxed is then refilled as a e-prescribed
    July 3 2013	CBlaine		Updated exception logic to log errors generated when creating script output 
							instead of allowing them to bubble up to the Surescripts windows service
	09/05/2013  Kalpers     Trimed up TextInstructions before appending to Instructions
	09/14/2013  Kalpers     Added the Reletes to message id
	09/16/2013  Kalpers     Added the PotencyUnitCode
	10/22/2013  Kalpers     Added the relate to message id to every selection
	07/15/2014  TRemisoski  Added workaround for refills calculated in script drug strengths incorrectly.  Grabbing from the ScriptDrugs records instead.  Will revert this change
	                        when the .NET code is fixed.
***************************************************/
    BEGIN TRY
	--BEGIN TRAN
        DECLARE @SurescriptsRefillRequestId INT
        DECLARE @SessionId VARCHAR(24)

        SELECT  @SessionId = SessionId
        FROM    ClientMedicationScriptsPreview
        WHERE   ClientMedicationScriptId = @ClientMedicationScriptId

        IF ISNULL(@RefillResponseType, 'Z') <> 'N' 
            BEGIN
                IF @PreviewData = 'Y' 
                    BEGIN
                        SELECT  @SurescriptsRefillRequestId = SurescriptsRefillRequestId
                        FROM    ClientMedicationScriptsPreview
                        WHERE   ClientMedicationScriptId = @ClientMedicationScriptId
                    END
                ELSE 
                    BEGIN
                        SELECT  @SurescriptsRefillRequestId = SurescriptsRefillRequestId
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
   			  EffectiveDate DATETIME

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
              PotencyUnitCode VARCHAR(35),
   			  EffectiveDate DATETIME

            )
        DECLARE @Instructions TABLE
            (
              ClientMedicationInstructionId INT ,
              StrengthId INT ,
              Quantity DECIMAL(10, 2) ,
              Unit type_GlobalCode ,
              Schedule type_GlobalCode
            )

	--
	-- If a result of a new Rx not associated with a refill request or denied with a new order to follow...
	--
        IF ( @SurescriptsRefillRequestId IS NULL )
            OR ( EXISTS ( SELECT    *
                          FROM      SureScriptsRefillRequests AS ssrr
                          WHERE     ssrr.SureScriptsRefillRequestId = @SurescriptsRefillRequestId
                                    AND ssrr.StatusOfRequest = 'N' ) ) 
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
                                        'SS'
                                        + CAST(cmsds.ClientMedicationScriptDrugStrengthId AS VARCHAR)
                                        + CASE WHEN ssrr.SureScriptsRefillRequestId IS NULL
                                               THEN ''
                                               ELSE '_'
                                                    + CAST(ssrr.SureScriptsRefillRequestId AS VARCHAR)
                                          END + '_'
                                        + REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 126),
                                                          ':', ''), '-', '') ,
                                        sInfo.ScriptNote ,
                                        cmsds.SpecialInstructions ,
                                        ISNULL(sInfo.Refills, 0)
                                        + CASE WHEN ISNULL(@RefillResponseType,
                                                           ' ') IN ( 'A', 'C' )
                                               THEN 1
                                               ELSE 0
                                          END ,
                                        sInfo.Pharmacy ,
                                        cmsds.PharmacyText ,
                                        sInfo.DispenseAsWritten ,
                                        GETDATE() ,-- per Surescripts, needs to be the current date regardless of what the user enters
                                        ssrr.RxReferenceNumber ,
                                        CASE WHEN ISNULL(ssrr.StatusOfRequest,
                                                         ' ') = 'R'
                                                  AND ISNULL(@RefillResponseType,
                                                             'Z') = 'N'
                                             THEN ISNULL(ssrd.DeniedMessageId,
                                                         ssim.SureScriptsMessageId)
                                             ELSE ssim.SureScriptsMessageId
                                        END ,
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
                                                              'N') <> 'Y'
                                               GROUP BY cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode
                                             ) AS sInfo ON sInfo.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                           AND sinfo.StrengthId = cmsds.StrengthId
                                        LEFT OUTER JOIN SureScriptsRefillRequests
                                        AS ssrr ON ssrr.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
                                        LEFT JOIN dbo.SureScriptsIncomingMessages ssim ON ( ssim.SureScriptsIncomingMessageId = ssrr.SureScriptsIncomingMessageId )
                                        LEFT JOIN dbo.SurescriptsRefillDenials ssrd ON ( ssrr.SureScriptsRefillRequestId = ssrd.SurescriptsRefillRequestId )
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
                                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
                                        AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                    END
                ELSE 
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
                                  PotencyUnitCode,
				    			  EffectiveDate
				                )
                                SELECT  cmsds.StrengthId ,
                                        'SS'
                                        + CAST(cmsds.ClientMedicationScriptDrugStrengthId AS VARCHAR)
                                        + CASE WHEN ssrr.SureScriptsRefillRequestId IS NULL
                                               THEN ''
                                               ELSE CAST(ssrr.SureScriptsRefillRequestId AS VARCHAR)
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
                                        CASE WHEN ISNULL(ssrr.StatusOfRequest,
                                                         ' ') = 'N'
                                             THEN ISNULL(ssrd.DeniedMessageId,
                                                         '')
                                             ELSE ssim.SureScriptsMessageId
                                        END ,
                                        sinfo.PotencyUnitCode,
										sInfo.StartDate
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
														, max(cmsd.StartDate) as StartDate
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
                                                              'N') <> 'Y'
                                               GROUP BY cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode
                                             ) AS sInfo ON sInfo.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                           AND sinfo.StrengthId = cmsds.StrengthId
                                        LEFT OUTER JOIN SureScriptsRefillRequests
                                        AS ssrr ON ssrr.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
                                        LEFT JOIN dbo.SureScriptsIncomingMessages ssim ON ( ssim.SureScriptsIncomingMessageId = ssrr.SureScriptsIncomingMessageId )
                                        LEFT JOIN dbo.SurescriptsRefillDenials ssrd ON ( ssrr.SureScriptsRefillRequestId = ssrd.SurescriptsRefillRequestId )
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
                                        AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
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
                          PotencyUnitCode ,
						  EffectiveDate 
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
                                CASE WHEN ISNULL(di.PotencyUnitCode,'') = '' THEN 'C38046' ELSE di.PotencyUnitCode end
                                , di.EffectiveDate
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
                                --LEFT JOIN surescriptscodes AS map2 ON ( mddfc.DosageFormCode = LTRIM(RTRIM(map2.SmartCareRxCode))
                                --                              AND map2.Category = 'PotencyUnitCode'
                                --                              )
            END
        ELSE 
            BEGIN
		-- @SurescriptsRefillRequestId is not null
                IF @PreviewData = 'Y' 
                    BEGIN
                        INSERT  INTO @ScriptOutput
                                ( ClientMedicationScriptId ,
                                  PON ,
                                  RxReferenceNumber ,
                                  DrugDescription ,
                                  SureScriptsQuantityQualifier ,
                                  SureScriptsQuantity ,
                                  ScriptInstructions ,
                                  ScriptNote ,
                                  DispenseAsWritten ,
                                  OrderDate ,
                                  Refills ,
                                  RelatesToMessageID ,
                                  PotencyUnitCode
				                )
                                SELECT  cms.ClientMedicationScriptId ,
                                        'SS'
                                        + CAST(cmsds.ClientMedicationScriptDrugStrengthId AS VARCHAR)
                                        + CASE WHEN rf.SureScriptsRefillRequestId IS NULL
                                               THEN ''
                                               ELSE CAST(rf.SureScriptsRefillRequestId AS VARCHAR)
                                          END + '_'
                                        + REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 126),
                                                          ':', ''), '-', '') ,
                                        rf.RxReferenceNumber ,
                                        rf.DispensedDrugDescription ,
                                        rf.DispensedQuantityQualifier ,
                                        rf.DispensedQuantityValue ,
                                        LTRIM(RTRIM(rf.DispensedDirections)) ,
                                        LTRIM(RTRIM(rf.DispensedNote)) ,
                                        CASE WHEN rf.DispensedSubstitutions IN (
                                                  1, 7 ) THEN 'Y'
                                             ELSE 'N'
                                        END ,
                                        GETDATE() ,--rf.CreatedDate,                                        
                                        ISNULL(sInfo.Refills, 0)
                                        + CASE WHEN ISNULL(@RefillResponseType,
                                                           ' ') IN ( 'A', 'C' )
                                               THEN 1
                                               ELSE 0
                                          END ,
                                        CASE WHEN ISNULL(rf.StatusOfRequest,
                                                         ' ') = 'N'
                                             THEN ISNULL(ssrd.DeniedMessageId,
                                                         '')
                                             ELSE ssim.SureScriptsMessageId
                                        END ,
                                        sInfo.PotencyUnitCode
                                FROM    ClientMedicationScriptsPreview AS cms
                                        JOIN SureScriptsRefillRequests AS rf ON rf.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
                                        LEFT JOIN dbo.SureScriptsIncomingMessages ssim ON ( ssim.SureScriptsIncomingMessageId = rf.SureScriptsIncomingMessageId )
                                        LEFT JOIN dbo.SurescriptsRefillDenials ssrd ON ( rf.SureScriptsRefillRequestId = ssrd.SurescriptsRefillRequestId )
                                        JOIN ClientMedicationScriptDrugStrengthsPreview
                                        AS cmsds ON cmsds.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                        JOIN ( SELECT   cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode ,
                                                        SUM(cmsd.Pharmacy) AS Pharmacy,
                                                        MAX(cmsd.Refills) as Refills
                                               FROM     ClientMedicationScriptDrugsPreview
                                                        AS cmsd
                                                        JOIN ClientMedicationInstructionsPreview
                                                        AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                               WHERE    cmsd.ClientMedicationScriptId = @ClientMedicationScriptId
                                                        AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y'
                                               GROUP BY cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode
                                             ) AS sInfo ON sInfo.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                           AND sinfo.StrengthId = cmsds.StrengthId
                                WHERE   cms.ClientMedicationScriptId = @ClientMedicationScriptId
                    END
                ELSE 
                    BEGIN
                        INSERT  INTO @ScriptOutput
                                ( ClientMedicationScriptId ,
                                  PON ,
                                  RxReferenceNumber ,
                                  DrugDescription ,
                                  SureScriptsQuantityQualifier ,
                                  SureScriptsQuantity ,
                                  ScriptInstructions ,
                                  ScriptNote ,
                                  DispenseAsWritten ,
                                  OrderDate ,
                                  Refills ,
                                  RelatesToMessageID ,
                                  PotencyUnitCode,
								  EffectiveDate
				                )
                                SELECT  cms.ClientMedicationScriptId ,
                                        'SS'
                                        + CAST(cmsds.ClientMedicationScriptDrugStrengthId AS VARCHAR)
                                        + CASE WHEN rf.SureScriptsRefillRequestId IS NULL
                                               THEN ''
                                               ELSE CAST(rf.SureScriptsRefillRequestId AS VARCHAR)
                                          END + '_'
                                        + REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 126),
                                                          ':', ''), '-', '') ,
                                        rf.RxReferenceNumber ,
                                        rf.DispensedDrugDescription ,
                                        rf.DispensedQuantityQualifier ,
                                        rf.DispensedQuantityValue ,
                                        LTRIM(RTRIM(rf.DispensedDirections)) ,
                                        LTRIM(RTRIM(rf.DispensedNote)) ,
                                        rf.DispensedSubstitutions ,
                                        GETDATE() ,--rf.CreatedDate,
                                        sInfo.Refills ,
                                        CASE WHEN ISNULL(rf.StatusOfRequest,
                                                         ' ') = 'N'
                                             THEN ISNULL(ssrd.DeniedMessageId,
                                                         '')
                                             ELSE ssim.SureScriptsMessageId
                                        END ,
                                        sInfo.PotencyUnitCode,
										sInfo.StartDate
                                FROM    ClientMedicationScripts AS cms
                                        JOIN SureScriptsRefillRequests AS rf ON rf.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
                                        LEFT JOIN dbo.SureScriptsIncomingMessages ssim ON ( ssim.SureScriptsIncomingMessageId = rf.SureScriptsIncomingMessageId )
                                        LEFT JOIN dbo.SurescriptsRefillDenials ssrd ON ( rf.SureScriptsRefillRequestId = ssrd.SurescriptsRefillRequestId )
                                        JOIN ClientMedicationScriptDrugStrengths
                                        AS cmsds ON cmsds.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                        JOIN ( SELECT   cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode ,
                                                        SUM(cmsd.Pharmacy) AS Pharmacy,
                                                        MAX(cmsd.Refills) as Refills,
														max(cmsd.StartDate) as StartDate
                                               FROM     ClientMedicationScriptDrugs
                                                        AS cmsd
                                                        JOIN ClientMedicationInstructions
                                                        AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                               WHERE    cmsd.ClientMedicationScriptId = @ClientMedicationScriptId
                                                        AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y'
                                               GROUP BY cmsd.ClientMedicationScriptId ,
                                                        cmi.StrengthId ,
                                                        cmi.PotencyUnitCode
                                             ) AS sInfo ON sInfo.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                           AND sinfo.StrengthId = cmsds.StrengthId
                                WHERE   cms.ClientMedicationScriptId = @ClientMedicationScriptId
                    END
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
                PotencyUnitCode ,
				EffectiveDate
        FROM    @ScriptOutput
		--COMMIT
    END TRY

    BEGIN CATCH
	--IF @@trancount > 0 
	--    ROLLBACK TRAN
        --DECLARE @errMessage NVARCHAR(4000)
        --SET @errMessage = ERROR_MESSAGE()
		--RAISERROR(@errMessage, 16, 1)  We don't want this to be thrown up the app because it kills all the e-scripts behind this one
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