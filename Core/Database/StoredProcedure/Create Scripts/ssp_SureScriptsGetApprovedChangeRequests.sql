IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsGetApprovedChangeRequests]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SureScriptsGetApprovedChangeRequests;
GO



SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ssp_SureScriptsGetApprovedChangeRequests]
AS /*****************************************************************************************************/
      
---Copyright: 2011 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : PranayB

---Purpose:To get the ApprovedWithChanges change request

---Return:Change List Medication Order

---Called by:Windows Service
---Log:
--	Date                     Author                             Purpose

--11/14/2017               Pranay                            Added Strength w.r.t Mu
--09/06/2018              PranayB                             Refactoring 
/*****************************************************************************************************/
     BEGIN TRY

        DECLARE @STATUSPENDING INT ,
            @STATUSINQUEUE INT
        SET @STATUSPENDING = 5562
        SET @STATUSINQUEUE = 5561

        BEGIN TRAN

        DECLARE @results TABLE
            (
              ClientMedicationScriptActivityId INT ,
              NOTE VARCHAR(210) ,                     -- NOTE ADDED FOR THIS MEDICATION
              REFILL_QUANTITY INT ,                   -- REFILL QUANTITY
              PON VARCHAR(50) ,                       -- Prescriber order number
              RESPONSE_XML type_Comment2 ,            -- The xml of the original refill request
              WRITTEN_DATE VARCHAR(10),                -- Date the approval was made
			  RelatesToMessageID VARCHAR(35),
			  PotencyUnitCode VARCHAR(35),
			  ProductCodeQualifier VARCHAR(35),
			  CodeListQualifier VARCHAR(35),
			   UnitSourceCode VARCHAR(35),
			   ProductCode VARCHAR(35),
			   DrugDescription VARCHAR(250),
			   SureScriptsQuantityQualifier VARCHAR(35),
			   SureScriptsQuantity VARCHAR(25),
			   TotalNumberofDays VARCHAR(35),
			    ScriptInstructions VARCHAR(210),
				ScriptNote VARCHAR(210),
				Refills VARCHAR(35)
				,DrugCategory INT
                ,Strength VARCHAR(25)
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
			  PotencyUnitCode VARCHAR(35),
			  DrugCategory INT
              ,Strength VARCHAR(25)
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


        DECLARE currChangedScripts CURSOR fast_forward
        FOR
            SELECT  cmsa.ClientMedicationScriptId ,
                    cmsa.ClientMedicationScriptActivityId ,
                    cms.LocationId
            FROM    ClientMedicationScriptActivities AS cmsa
                    JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                    JOIN SureScriptsChangeRequests AS ssrr ON ssrr.SureScriptsChangeRequestId = cms.SureScriptsChangeRequestId
            WHERE   cmsa.Method = 'E'
                    AND cmsa.Status =   @STATUSINQUEUE
                    AND cms.SurescriptsChangeRequestId IS NOT NULL
                    AND ssrr.StatusOfRequest = 'C'
					AND cms.ScriptEventType='A' ---Added in the .cs code
                    AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(ssrr.RecordDeleted, 'N') <> 'Y'
            ORDER BY cmsa.ClientMedicationScriptActivityId  -- FIFO



        OPEN currChangedScripts

        FETCH currChangedScripts INTO @currScriptId, @currScriptActivityId,
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
						  PotencyUnitCode,
						  DrugCategory
						  ,Strength
                        )
                        EXEC scsp_SureScriptsScriptOutputApprovedWithChange @ClientMedicationScriptId = @currScriptId,
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

                FETCH currChangedScripts INTO @currScriptId, @currScriptActivityId,
                    @currLocationid

            END

        CLOSE currChangedScripts

        DEALLOCATE currChangedScripts

 DECLARE @tempRESPONSE_XML XML
-- create a results record for every drug strength
        INSERT  INTO @results
                ( ClientMedicationScriptActivityId ,
                  NOTE ,
                  REFILL_QUANTITY ,
                  PON ,
                  WRITTEN_DATE,
				  RelatesToMessageID,
				  PotencyUnitCode,
				  ProductCodeQualifier,
				  CodeListQualifier,
				  UnitSourceCode,
				  ProductCode,
				  DrugDescription,
				  SureScriptsQuantityQualifier,
				  SureScriptsQuantity,
				  TotalNumberofDays,
				  ScriptInstructions,
				  ScriptNote,
				  Refills
				  ,DrugCategory
				  ,Strength
                )
                SELECT  map.ClientMedicationScriptActivityId ,
                        so.DispenseAsWritten ,
                        ISNULL(so.Refills, 0) ,
                        so.PON ,
                        dbo.ssf_SureScriptsFormatDate(so.OrderDate),
						so.RelatesToMessageID,
						so.PotencyUnitCode,
						CASE WHEN so.NDC IS NOT NULL THEN 'ND'
							 ELSE NULL
						END AS ProductCodeQualifier, 
						CONVERT(VARCHAR(25),'38') AS CodeListQualifier ,
						'AC' AS UnitSourceCode
						,so.NDC
						,so.DrugDescription
						,so.SureScriptsQuantityQualifier
						,CONVERT(VARCHAR(25), CONVERT(FLOAT, so.SureScriptsQuantity), 128)--so.SureScriptsQuantity --<Quantity>
						,so.TotalDaysInScript
						,so.ScriptInstructions
						,dbo.ssf_SurescriptsXMLCharReplace(so.ScriptNote, 70) as ScriptNote
						,so.Refills
						,so.DrugCategory
						,so.Strength
                FROM    @ScriptOutput AS so
                        JOIN @ScriptActivityMap AS map ON map.ClientMedicationScriptId = so.ClientMedicationScriptId	

            
                SELECT @tempRESPONSE_XML= ssim.MessageText FROM    ClientMedicationScriptActivities AS cmsa
                JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
               --Not sure if i need to add column in the surescritpstable
			    JOIN SureScriptsChangeRequests AS ssrr ON ssrr.SureScriptsChangeRequestId = cms.SureScriptsChangeRequestId
                JOIN SureScriptsIncomingMessages AS ssim ON ssim.SureScriptsIncomingMessageId = ssrr.SureScriptsIncomingMessageId
                JOIN @results AS r ON r.ClientMedicationScriptActivityId = cmsa.ClientMedicationScriptActivityId
               	IF @tempRESPONSE_XML IS NOT NULL
			     BEGIN
			         SET @tempRESPONSE_XML.modify(' declare default element namespace "http://www.ncpdp.org/schema/SCRIPT"; 
                delete /Message/Body/RxChangeRequest/MedicationRequested
                ')  
				end
  UPDATE  @results
     -- SET     RESPONSE_XML = REPLACE(CAST(@tempRESPONSE_XML AS VARCHAR(max)),'MedicationRequested','MedicationPrescribed') 
	 SET RESPONSE_XML= CAST(@tempRESPONSE_XML AS VARCHAR(max))
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











GO
