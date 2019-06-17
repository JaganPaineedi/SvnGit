IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsGetApprovedWithChangesRefillRequests]') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.ssp_SureScriptsGetApprovedWithChangesRefillRequests
go 

CREATE PROCEDURE [dbo].[ssp_SureScriptsGetApprovedWithChangesRefillRequests]
AS /*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetApprovedWithChangesRefillRequests

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Get refill request responses that have been approved (with changes) but not sent to Surescripts yet.

Input Parameters: None

Output Parameters:

Return:
	Data table with format as required by windows service

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created.
	09/16/2013 - kalpers added PotencyUnitCode
	09/21/2013 - kalpers added the relatestomessageid
	01/24/2018 - Pranay  Added @tempRESPONSE_XML AspenPointe Task#686
*/
/*****************************************************************************************************/
    BEGIN TRY

        DECLARE @STATUSPENDING INT ,
            @STATUSINQUEUE INT
        SET @STATUSPENDING = 5562
        SET @STATUSINQUEUE = 5561
		DECLARE @tempRESPONSE_XML XML
        BEGIN TRAN

        DECLARE @results TABLE
            (
              ClientMedicationScriptActivityId INT ,
              NOTE VARCHAR(210) ,                     -- NOTE ADDED FOR THIS MEDICATION
              REFILL_QUANTITY INT ,                   -- REFILL QUANTITY
              PON VARCHAR(50) ,                       -- Prescriber order number
              RESPONSE_XML type_Comment2 ,            -- The xml of the original refill request
              WRITTEN_DATE VARCHAR(10),                -- date approval was made
			  RelatesToMessageID VARCHAR(35),
			  PotencyUnitCode VARCHAR(35)
            )

        DECLARE @ScriptOutput TABLE
            (
              ClientMedicationScriptId INT ,
              PON VARCHAR(35) ,
              RxReferenceNumber VARCHAR(35) ,
              DrugDescription VARCHAR(250) ,
              SureScriptsQuantityQualifier VARCHAR(3) ,
              SureScriptsQuantity DECIMAL(29, 14) ,
              TotalDaysInScript INT ,
              ScriptInstructions VARCHAR(140) ,
              ScriptNote VARCHAR(210) ,
              Refills INT ,
              DispenseAsWritten CHAR(1) , -- Y/N
              OrderDate DATETIME ,
              NDC VARCHAR(35),
			  RelatesToMessageID VARCHAR(35),
			  PotencyUnitCode VARCHAR(35)
            )

-- map the script output to activities
        DECLARE @ScriptActivityMap TABLE
            (
              ClientMedicationScriptId INT ,
              ClientMedicationScriptActivityId INT
            )


        DECLARE @currScriptId INT ,
            @currScriptActivityId INT ,
            @currLocationId INT


        DECLARE currScripts CURSOR fast_forward
        FOR
            SELECT  cmsa.ClientMedicationScriptId ,
                    cmsa.ClientMedicationScriptActivityId ,
                    cms.LocationId
            FROM    ClientMedicationScriptActivities AS cmsa
                    JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                    JOIN SureScriptsRefillRequests AS ssrr ON ssrr.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
            WHERE   cmsa.Method = 'E'
                    AND cmsa.Status = @STATUSINQUEUE
                    AND cms.SurescriptsRefillRequestId IS NOT NULL
                    AND ssrr.StatusOfRequest = 'C'
                    AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(ssrr.RecordDeleted, 'N') <> 'Y'
            ORDER BY cmsa.ClientMedicationScriptActivityId  -- FIFO



        OPEN currScripts

        FETCH currScripts INTO @currScriptId, @currScriptActivityId,
            @currLocationid

        WHILE @@fetch_status = 0 
            BEGIN
   
                INSERT  INTO @ScriptOutput
                        ( ClientMedicationScriptId ,
                          PON ,
                          RxReferenceNumber ,
                          DrugDescription ,
                          SureScriptsQuantityQualifier ,
                          SureScriptsQuantity ,
                          TotalDaysInScript ,
                          ScriptInstructions ,
                          ScriptNote ,
                          Refills ,
                          DispenseAsWritten ,
                          OrderDate ,
                          NDC,
						  RelatesToMessageID,
						  PotencyUnitCode
                        )
                        EXEC scsp_SureScriptsScriptOutput @ClientMedicationScriptId = @currScriptId,
                            @PreviewData = 'N'

                UPDATE  ClientMedicationScriptActivities
                SET     Status = @STATUSPENDING
                WHERE   ClientMedicationScriptActivityId = @currScriptActivityId

                INSERT  INTO @ScriptActivityMap
                        ( ClientMedicationScriptId ,
                          ClientMedicationScriptActivityId
                        )
                VALUES  ( @currScriptId ,
                          @currScriptActivityId
                        )

                FETCH currScripts INTO @currScriptId, @currScriptActivityId,
                    @currLocationid

            END

        CLOSE currScripts

        DEALLOCATE currScripts

-- create a results record for every drug strength
        INSERT  INTO @results
                ( ClientMedicationScriptActivityId ,
                  NOTE ,
                  REFILL_QUANTITY ,
                  PON ,
                  WRITTEN_DATE,
				  RelatesToMessageID,
				  PotencyUnitCode
                )
                SELECT  map.ClientMedicationScriptActivityId ,
                        NULL ,
                        ISNULL(so.Refills, 0) + 1 ,
                        so.PON ,
                        dbo.ssf_SureScriptsFormatDate(so.OrderDate),
						so.RelatesToMessageID,
						so.PotencyUnitCode
                FROM    @ScriptOutput AS so
                        JOIN @ScriptActivityMap AS map ON map.ClientMedicationScriptId = so.ClientMedicationScriptId	

        --UPDATE  r
        SELECT @tempRESPONSE_XML = ssim.MessageText
        FROM    ClientMedicationScriptActivities AS cmsa
                JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                JOIN SureScriptsRefillRequests AS ssrr ON ssrr.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
                JOIN SureScriptsIncomingMessages AS ssim ON ssim.SureScriptsIncomingMessageId = ssrr.SureScriptsIncomingMessageId
                JOIN @results AS r ON r.ClientMedicationScriptActivityId = cmsa.ClientMedicationScriptActivityId
				
         IF @tempRESPONSE_XML is not null
			 BEGIN
		      	   SET @tempRESPONSE_XML.modify(' declare default element namespace "http://www.ncpdp.org/schema/SCRIPT"; 
                delete /Message/Body/RefillRequest/MedicationDispensed/SoldDate
                ') 
		     END 
        UPDATE @results SET RESPONSE_XML= CAST(@tempRESPONSE_XML AS VARCHAR(max))
        SELECT  *
        FROM    @results

        COMMIT TRAN

    END TRY
    BEGIN CATCH

        IF @@trancount > 0 
            ROLLBACK TRAN

        DECLARE @errMessage NVARCHAR(4000)
        SET @errMessage = ERROR_MESSAGE()

        RAISERROR(@errMessage, 16, 1)
    END CATCH

