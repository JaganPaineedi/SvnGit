IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_ValidateChangeMedicationScript ]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_ValidateChangeMedicationScript;
GO

CREATE PROCEDURE ssp_ValidateChangeMedicationScript
    @ClientMedicationScriptId int ,
    @SureScriptsChangeRequestId int ,
    @Status varchar(10) OUTPUT
AS /*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_ValidateChangeMedicationScript

Copyright: 2017 Streamline Healthcare Solutions, LLC

Creation Date:  Oct 20 2017

Purpose:
	To Compare both PrescibedMedication and ChangeMedication

Output Parameters: @Status


Called by: Application

Log:
Date                Author                           Descriptions

*/
/*****************************************************************************************************/
    DECLARE @ScriptOutput TABLE
        (
          ClientMedicationScriptId INT ,
          PON VARCHAR(35) ,
          RxReferenceNumber VARCHAR(35) ,
          DrugDescription VARCHAR(250) ,
          SureScriptsQuantityQualifier VARCHAR(3) ,
          SureScriptsQuantity DECIMAL(29, 14) ,
          TotalDaysInScript INT ,
          ScriptInstructions VARCHAR(max) ,
          ScriptNote VARCHAR(max) ,
          Refills INT ,
          DispenseAsWritten CHAR(1) , -- Y/N
          OrderDate DATETIME ,
          NDC VARCHAR(35) ,
          RelatesToMessageID VARCHAR(35) ,
          PotencyUnitCode VARCHAR(35)
        )

    BEGIN TRY 

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
                  NDC ,
                  RelatesToMessageID ,
                  PotencyUnitCode 
                )
                EXEC scsp_SureScriptsScriptOutput @ClientMedicationScriptId,
                    'Y'
        IF exists ( SELECT  sa.RequestedDrugDescription ,
                            sa.RequestedNumberOfDaysSupply ,
                            sa.RequestedNumberOfRefills ,
                            sa.RequestedQuantityValue
                    FROM    SureScriptsChangeMedicationRequests sa
                            JOIN @ScriptOutput so ON so.DrugDescription = sa.RequestedDrugDescription  --- Only three Properties are compared since Number of days are not sent in the SureScipts 
                                                     AND so.Refills = sa.RequestedNumberOfRefills     
                                                     AND sa.RequestedQuantityValue = so.SureScriptsQuantity
                    where   sa.SureScriptChangeRequestedId = @SureScriptsChangeRequestId )
            BEGIN 
			  SET @Status='Valid'
            END 
       ELSE 
	     BEGIN
		     SET @Status='InValid'
		 END	

    END TRY
    BEGIN CATCH
        IF @@trancount > 0
            ROLLBACK TRAN
        DECLARE @errMessage NVARCHAR(4000)
        SET @errMessage = ERROR_MESSAGE()
        RAISERROR(@errMessage, 16, 1)
    END CATCH
Go