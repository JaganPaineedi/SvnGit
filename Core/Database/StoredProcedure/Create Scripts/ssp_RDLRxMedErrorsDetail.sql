IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_RDLRxMedErrorsDetail')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN 
        DROP PROCEDURE dbo.ssp_RDLRxMedErrorsDetail;
    END;
GO  
CREATE PROC ssp_RDLRxMedErrorsDetail
    @startDate DATETIME
  , @Status INT -- -1 both, 1 success, 2 error
  , @OrderMethod INT -- -1 both, 1 Fax, 2 Electronic
AS /******************************************************************************
**		File: Core\RDL\Core\Modules\RxMedicationErrors\Database\Stored Procedures\ssp_RDLRxMedErrorsDetail
**		Name: ssp_RDLRxMedErrorsDetail
**		Desc: sp for report RxMedError.rdl located: Core\RDL\Core\Modules\RxMedicationErrors\Reports\RxMedicationErrors
**
**		Auth: jcarlson
**		Date: 3/22/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      3/22/2018       jcarlson                converted to Core
												added logic to log error along with input parameter values
*******************************************************************************/

    SET NOCOUNT ON;
    BEGIN TRY
 	
 	--Electronic Errors
        DECLARE @Results TABLE (
              CreatedDate DATE
            , StatusDescription VARCHAR(MAX)
            , Meaning VARCHAR(MAX)
            , Pharmacy VARCHAR(MAX)
            , PharmacyPhone VARCHAR(MAX)
            , Prescriber VARCHAR(MAX)
            , ClientId INT
            , ClientName VARCHAR(MAX)
            , MedicationName VARCHAR(MAX)
            , DateRequested DATE
            , OrderMethod VARCHAR(MAX)
            , StatusDate DATETIME
            );
        INSERT  INTO @Results ( CreatedDate, StatusDescription, Meaning, Pharmacy, PharmacyPhone, Prescriber, ClientId, ClientName, MedicationName,
                                DateRequested, OrderMethod, StatusDate )
        SELECT  CAST(cmsa.CreatedDate AS DATE) AS CreatedDate, cmsa.StatusDescription, CASE WHEN cmsa.StatusDescription LIKE '%Success%'
                                                                                                 OR cmsa.StatusDescription LIKE '%Mailbox%'
                                                                                                 OR cmsa.StatusDescription LIKE '%Pending%' THEN 'Success'
                                                                                            ELSE 'Error'
                                                                                       END AS 'Meaning', p.PharmacyName, p.PhoneNumber,
                cms.OrderingPrescriberName, cms.ClientId, c.LastName + ', ' + c.FirstName, mdmn.MedicationName + ' ' + mdm.StrengthDescription, cms.OrderDate,
                'Electronic', cmsa.FaxStatusDate
        FROM    dbo.ClientMedicationScriptActivities AS cmsa
        JOIN    dbo.ClientMedicationScripts cms ON cmsa.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                   AND cms.OrderingMethod = 'E'
                                                   AND ISNULL(cms.RecordDeleted, 'N') = 'N'
        JOIN    dbo.ClientMedicationScriptDrugs cmsd ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                        AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
        JOIN    dbo.ClientMedicationInstructions cmi ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                                        AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
        JOIN    dbo.MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
        JOIN    dbo.ClientMedications cm ON cmi.ClientMedicationId = cm.ClientMedicationId
                                            AND ISNULL(cm.RecordDeleted, 'N') = 'N'
        JOIN    dbo.MDMedicationNames mdmn ON cm.MedicationNameId = mdmn.MedicationNameId
                                              AND ISNULL(mdmn.RecordDeleted, 'N') = 'N'
        JOIN    dbo.Clients c ON cms.ClientId = c.ClientId
                                 AND ISNULL(c.RecordDeleted, 'N') = 'N'
        JOIN    dbo.Pharmacies p ON cms.PharmacyId = p.PharmacyId
                                    AND ISNULL(p.RecordDeleted, 'N') = 'N'
        WHERE   cmsa.Method = 'E'
                AND cmsa.SureScriptsOutgoingMessageId IS NOT NULL
                AND CAST(cmsa.CreatedDate AS DATE) >= CAST(@startDate AS DATE)
        ORDER BY CAST(cmsa.CreatedDate AS DATE);
                
        --Fax Errors
        INSERT  INTO @Results ( CreatedDate, StatusDescription, Meaning, Pharmacy, PharmacyPhone, Prescriber, ClientId, ClientName, MedicationName,
                                DateRequested, OrderMethod, StatusDate )
        SELECT  CAST(cmsa.CreatedDate AS DATE) AS CreatedDate, cmsa.StatusDescription, CASE WHEN cmsa.Status IN ( 5563, 5562, 5561 ) THEN 'Success'
					    --WHEN cmsa.[Status] = 5564 THEN 'Error'
					    --WHEN cmsa.[Status] = 5562 THEN 'Pending'
					    --WHEN cmsa.[Status] = 5561 THEN 'In Queue'
                                                                                            ELSE 'Error'
                                                                                       END AS 'Meaning', p.PharmacyName, p.PhoneNumber,
                cms.OrderingPrescriberName, cms.ClientId, c.LastName + ', ' + c.FirstName, mdmn.MedicationName + ' ' + mdm.StrengthDescription, cms.OrderDate,
                'Fax', cmsa.FaxStatusDate
        FROM    dbo.ClientMedicationScriptActivities AS cmsa
        JOIN    dbo.ClientMedicationScripts cms ON cmsa.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                   AND ISNULL(cms.RecordDeleted, 'N') = 'N'
        JOIN    dbo.ClientMedicationScriptDrugs cmsd ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                        AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
        JOIN    dbo.ClientMedicationInstructions cmi ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                                        AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
        JOIN    dbo.MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
        JOIN    dbo.ClientMedications cm ON cmi.ClientMedicationId = cm.ClientMedicationId
                                            AND ISNULL(cm.RecordDeleted, 'N') = 'N'
        JOIN    dbo.MDMedicationNames mdmn ON cm.MedicationNameId = mdmn.MedicationNameId
                                              AND ISNULL(mdmn.RecordDeleted, 'N') = 'N'
        LEFT JOIN dbo.Clients c ON cms.ClientId = c.ClientId
                                   AND ISNULL(c.RecordDeleted, 'N') = 'N'
        JOIN    dbo.Pharmacies p ON cms.PharmacyId = p.PharmacyId
                                    AND ISNULL(p.RecordDeleted, 'N') = 'N'
        WHERE   cmsa.Method = 'F'
                AND CAST(cmsa.CreatedDate AS DATE) >= CAST(@startDate AS DATE)
        ORDER BY CAST(cmsa.CreatedDate AS DATE);
    
        SELECT DISTINCT --one script record for each status
                r.CreatedDate, r.StatusDescription, r.Meaning, r.Pharmacy, dbo.csf_RDLSureScriptsFormatPhone(r.PharmacyPhone) AS PharmacyPhone, r.Prescriber,
                r.ClientId, r.ClientName, r.MedicationName, r.DateRequested, r.OrderMethod, r.StatusDate
        FROM    @Results r
        WHERE   ( @Status = -1
                  OR ( @Status = 1
                       AND r.Meaning = 'Success'
                     )
                  OR ( @Status = 2
                       AND r.Meaning = 'Error'
                     )
                )
                AND ( @OrderMethod = -1
                      OR ( @OrderMethod = 1
                           AND r.OrderMethod = 'Fax'
                         )
                      OR ( @OrderMethod = 2
                           AND r.OrderMethod = 'Electronic'
                         )
                    );
    
    END TRY
    BEGIN CATCH

        DECLARE @error VARCHAR(MAX);
        DECLARE @errorDate DATETIME = GETDATE();
        DECLARE @verboseInfo VARCHAR(MAX);

        SELECT  @error = ERROR_MESSAGE() + CHAR(10) + CHAR(13) + ERROR_LINE();
        SELECT  @verboseInfo = 'Parameters:' + CHAR(10) + CHAR(13) + '@startDate: ' + CONVERT(VARCHAR(MAX), @startDate) + CHAR(10) + CHAR(13) + '@Status: '
                + CONVERT(VARCHAR(MAX), @Status) + ' (' + CASE WHEN @Status = -1 THEN 'Both'
                                                               WHEN @Status = 1 THEN 'Success'
                                                               WHEN @Status = 2 THEN 'Error'
                                                               ELSE 'Unknown'
                                                          END + ')' + CHAR(10) + CHAR(13) + '@OrderMethod: ' + CONVERT(VARCHAR(MAX), @OrderMethod) + ' ('
                + CASE WHEN @OrderMethod = -1 THEN 'Both'
                       WHEN @OrderMethod = 1 THEN 'Fax'
                       WHEN @OrderMethod = 2 THEN 'Electronic'
                       ELSE 'Unknown'
                  END + ')';
	

        EXEC dbo.ssp_SCLogError @ErrorMessage = @error, -- text
            @VerboseInfo = @VerboseInfo, -- text
            @ErrorType = 'Error', -- varchar(50)
            @CreatedBy = 'ssp_RDLRxMedErrorsDetail', -- varchar(30)
            @CreatedDate = @errorDate, -- datetime
            @DatasetInfo = ''; -- text
	
    END CATCH;
    SET NOCOUNT OFF;
 GO