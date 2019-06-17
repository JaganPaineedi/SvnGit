IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'csp_RDLRxMedErrorsDetail')
                    AND type IN ( N'P' , N'PC' ) ) 
    BEGIN 
        DROP PROCEDURE csp_RDLRxMedErrorsDetail
    END
go  
CREATE PROC csp_RDLRxMedErrorsDetail
    @startDate DATETIME
  , @Status INT -- -1 both, 1 success, 2 error
  , @OrderMethod INT -- -1 both, 1 Fax, 2 Electronic
AS 
    BEGIN
        SET NOCOUNT ON;
 	
 	--Electronic Errors
        DECLARE @Results TABLE
            (
              CreatedDate DATE
            , StatusDescription VARCHAR(MAX)
            , Meaning VARCHAR(MAX)
            , Prescriber VARCHAR(MAX)
            , ClientId INT
            , ClientName VARCHAR(MAX)
            , MedicationName VARCHAR(MAX)
            , DateRequested DATE
            , OrderMethod varCHAR(max)
            , StatusDate DATETIME 
            )
        INSERT  INTO @Results
                ( CreatedDate
                , StatusDescription
                , Meaning
                , Prescriber
                , ClientId
                , ClientName
                , MedicationName
                , DateRequested
                , OrderMethod
                , StatusDate
 	           )
                SELECT  CAST(cmsa.CreatedDate AS DATE) AS CreatedDate
                      , cmsa.StatusDescription
                      , CASE WHEN cmsa.StatusDescription LIKE '%Success%'
                                  OR cmsa.StatusDescription LIKE '%Mailbox%'
                                  OR cmsa.StatusDescription LIKE '%Pending%' THEN 'Success'
                             ELSE 'Error'
                        END AS 'Meaning'
                      , cms.OrderingPrescriberName
                      , cms.ClientId
                      , c.LastName + ', ' + c.FirstName
                      , mdmn.MedicationName
                      , cms.OrderDate
                      , 'Electronic'
                      , cmsa.FaxStatusDate
                FROM    dbo.ClientMedicationScriptActivities AS cmsa
                JOIN    ClientMedicationScripts cms ON cmsa.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                       AND cms.OrderingMethod = 'E'
                                                       AND ISNULL(cms.RecordDeleted , 'N') = 'N'
                JOIN    ClientMedicationScriptDrugs cmsd ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                            AND ISNULL(cmsd.RecordDeleted , 'N') = 'N'
                JOIN    ClientMedicationInstructions cmi ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                                            AND ISNULL(cmi.RecordDeleted , 'N') = 'N'
                JOIN    ClientMedications cm ON cmi.ClientMedicationId = cm.ClientMedicationId
                                                AND ISNULL(cm.RecordDeleted , 'N') = 'N'
                JOIN    MDMedicationNames mdmn ON cm.MedicationNameId = mdmn.MedicationNameId
                                                  AND ISNULL(mdmn.RecordDeleted , 'N') = 'N'
                JOIN    Clients c ON cms.ClientId = c.ClientId
                                     AND ISNULL(c.RecordDeleted , 'N') = 'N'
                WHERE   cmsa.Method = 'E'
                        AND cmsa.SureScriptsOutgoingMessageId IS NOT NULL
                        AND CAST(cmsa.CreatedDate AS DATE) >= CAST(@startDate AS DATE)
                ORDER BY CAST(cmsa.CreatedDate AS DATE)
                
                --Fax Errors
                INSERT INTO @Results
                (
                CreatedDate
                , StatusDescription
                , Meaning
                , Prescriber
                , ClientId
                , ClientName
                , MedicationName
                , DateRequested
                , OrderMethod
                , StatusDate
                )
			 SELECT  CAST(cmsa.CreatedDate AS DATE) AS CreatedDate
                      , cmsa.StatusDescription
                      , CASE WHEN cmsa.[Status] in (5563,5562,5561) THEN 'Success'
					    --WHEN cmsa.[Status] = 5564 THEN 'Error'
					    --WHEN cmsa.[Status] = 5562 THEN 'Pending'
					    --WHEN cmsa.[Status] = 5561 THEN 'In Queue'
					    ELSE 'Error'
                        END AS 'Meaning'
                      , cms.OrderingPrescriberName
                      , cms.ClientId
                      , c.LastName + ', ' + c.FirstName
                      , mdmn.MedicationName
                      , cms.OrderDate
                      , 'Fax'
                      , cmsa.FaxStatusDate
                FROM    dbo.ClientMedicationScriptActivities AS cmsa
                JOIN    ClientMedicationScripts cms ON cmsa.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                       AND ISNULL(cms.RecordDeleted , 'N') = 'N'
               JOIN    ClientMedicationScriptDrugs cmsd ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                            AND ISNULL(cmsd.RecordDeleted , 'N') = 'N'
               JOIN    ClientMedicationInstructions cmi ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                                          AND ISNULL(cmi.RecordDeleted , 'N') = 'N'
               JOIN    ClientMedications cm ON cmi.ClientMedicationId = cm.ClientMedicationId
                                                AND ISNULL(cm.RecordDeleted , 'N') = 'N'
               JOIN    MDMedicationNames mdmn ON cm.MedicationNameId = mdmn.MedicationNameId
                                                  AND ISNULL(mdmn.RecordDeleted , 'N') = 'N'
               LEFT JOIN    Clients c ON cms.ClientId = c.ClientId
                                     AND ISNULL(c.RecordDeleted , 'N') = 'N'
                WHERE   cmsa.Method = 'F'
                    AND CAST(cmsa.CreatedDate AS DATE) >= CAST(@startDate AS DATE)
                ORDER BY CAST(cmsa.CreatedDate AS DATE)
    
        SELECT DISTINCT --one script record for each status
                r.CreatedDate
              , r.StatusDescription
              , r.Meaning
              , r.Prescriber
              , r.ClientId
              , r.ClientName
              , r.MedicationName
              , r.DateRequested
              , r.OrderMethod
              , r.StatusDate
        FROM    @Results r
        WHERE   ( @Status = -1
                  OR ( @Status = 1
                       AND r.Meaning = 'Success'
                     )
                  OR ( @Status = 2
                       AND r.Meaning = 'Error'
                     )
                )
                AND 
                (
                @OrderMethod = -1
				OR (
				    @OrderMethod = 1 AND r.OrderMethod = 'Fax'
				   )
				OR (
				@OrderMethod = 2 AND r.OrderMethod = 'Electronic'
				   )
                )
    
        SET NOCOUNT OFF;
    END
 go