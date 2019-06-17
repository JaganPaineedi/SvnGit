IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsReceiveRxChangeRequest]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SureScriptsReceiveRxChangeRequest;
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[ssp_SureScriptsReceiveRxChangeRequest]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetApprovedRefillRequests

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2017.10.18

Purpose:
	Receive new refill request from Surescripts.

Output Parameters:

Return:
	None

Calls:

Called by:
	Surescripts Client Windows Service

Log:

Date                           Name                 Reason
11/09/2017                    PranayB          Added     LEFT(LTRIM(RTRIM(@PATIENTFIRSTNAME)),30),LEFT(LTRIM(RTRIM(@PATIENTLASTNAME)),30)  
*/
/*****************************************************************************************************/
    @MESSAGEID VARCHAR(35) ,
    @RECEIVEDTIME VARCHAR(35) ,
    @NCPDPID VARCHAR(35) ,
    @SPIID VARCHAR(35) ,
	@ChangeRequestType VARCHAR(2),
    @RXREFERENCENUMBER VARCHAR(35) ,
    @PRESCRIBERORDERNUMBER VARCHAR(35) ,
    @FILEID VARCHAR(35) ,
    @PATIENTLASTNAME VARCHAR(35) ,
    @PATIENTFIRSTNAME VARCHAR(35) ,
    @PATIENTMIDDLENAME VARCHAR(35) ,
    @PATIENTADDRESS1 type_Address ,
    @PATIENTADDRESS2 type_Address ,
    @PATIENTCITY VARCHAR(35) ,
    @PATIENTSTATE type_State ,
    @PATIENTZIPCODE type_ZipCode ,
    @PATIENTPHONE type_PhoneNumber ,
    @PATIENTGENDER VARCHAR(35) ,
    @PATIENTDOB VARCHAR(35) ,
    @DRUGDESCRIPTION VARCHAR(105) ,
    @DRUGSTRENGTH VARCHAR(35) ,
    @DRUGSTRENGTHUNIT VARCHAR(35) ,
    @QUANTITYQUALIFIER VARCHAR(35) ,
    @QUANTITYVALUE VARCHAR(35) ,
    @POTENCYUNITCODE VARCHAR(35) ,
    @DAYSSUPPLY VARCHAR(35) ,
    @DIRECTIONS VARCHAR(140) ,
    @NOTE VARCHAR(210) ,
    @SUBSTITUTIONS VARCHAR(35) ,
    @REFILLQUALIFIER VARCHAR(35) ,
    @REFILLQUANTITY VARCHAR(35) ,
    @WRITTENDATE DATETIME ,
    @DIAGNOSIS1 VARCHAR(100) ,
    @DIAGNOSIS2 VARCHAR(100) ,
    @PRIORAUTHQUALIFIER VARCHAR(2) ,
    @PRIORAUTHVALUE VARCHAR(35) ,
    @PRIORAUTHSTATUS VARCHAR(1) ,
	@PRODUCTCODE VARCHAR(100),
	@PRODUCTCODEQUALIFIER VARCHAR(100),
     @BINLocationNumber VARCHAR(35),
     @PAYERID VARCHAR(35),
     @PAYERNAME VARCHAR(35),
     @CARDHOLDERID VARCHAR(35),
     @CARDHOLDERLASTNAME VARCHAR(35),
     @CARDHOLDERFIRSTNAME VARCHAR(35),
     @GROUPID VARCHAR(35),
     @REQUESTXML VARCHAR(MAX)
	,@SureScriptChangeRequestId INT  output
AS 
    BEGIN TRY

        DECLARE @incomingMessageId INT ,
            @newRefillRequestId INT
        DECLARE @PrescriberFirstName type_FirstName ,
            @PrescriberLastName type_LastName ,
            @PrescriberMiddleName type_MiddleName ,
            @PrescriberStaffId INT ,
            @PrescriberPhone type_PhoneNumber ,
            @PrescriberFax type_PhoneNumber ,
            @PrescriberAddress1 type_Address ,
            @PrescriberCity type_City ,
            @PrescriberState type_State ,
            @PrescriberZip type_ZipCode

        SELECT TOP ( 1 )
                @PrescriberFirstName = s.FirstName ,
                @PrescriberMiddleName = s.MiddleName ,
                @PrescriberLastName = s.LastName ,
                @PrescriberStaffId = s.StaffId ,
                @PrescriberPhone = s.PhoneNumber ,
                @PrescriberFax = s.FaxNumber ,
                @PrescriberAddress1 = a.Address ,
                @PrescriberCity = a.City ,
                @PrescriberState = a.State ,
                @PrescriberZip = a.ZipCode
        FROM    Staff AS s
                CROSS JOIN agency a
        WHERE   s.SureScriptsPrescriberId + SureScriptsLocationId = @SPIID

        BEGIN TRAN

        DECLARE @localtime DATETIME
        SET @RECEIVEDTIME = REPLACE(@RECEIVEDTIME, 'Z', '')

        SET @localtime = DATEADD(hour, DATEDIFF(hour, GETUTCDATE(), GETDATE()),
                                 CAST(@RECEIVEDTIME AS DATETIME))

        INSERT  INTO SureScriptsIncomingMessages
                ( SureScriptsMessageId ,
                  MessageType ,
                  ReceivedDateTime ,
                  MessageText
                )
        VALUES  ( @MESSAGEID ,
                  'CHANGEREQ' ,
                  @localtime ,
                  @REQUESTXML
                )

        SET @incomingMessageId = @@identity

        INSERT  INTO SureScriptsChangeRequests
                ( SureScriptsIncomingMessageId ,
                  StatusOfRequest ,
				  ChangeRequestType,
                  RxReferenceNumber ,
                  PrescriberOrderNumber ,
                  SureScriptsPrescriberId ,
                  PrescriberLastName ,
                  PrescriberFirstName ,
                  PrescriberMiddleName ,
                  PrescriberId ,
                  PrescriberAddress1 ,
                  PrescriberAddress2 ,
                  PrescriberCity ,
                  PrescriberState ,
                  PrescriberZip ,
                  PrescriberPhone ,
                  PrescriberFax ,
                  ClientLastName ,
                  ClientFirstName ,
                  ClientMiddleName ,
                  ClientSex ,
                  ClientDOB ,
                  ClientAddress1 ,
                  ClientAddress2 ,
                  ClientCity ,
                  ClientState ,
                  ClientZip ,
                  ClientPhone ,
                  ClientIdentifier ,
                  SureScriptsPharmacyId ,
                  DrugDescription ,
                  NumberOfDaysSupply ,
                  RefillType ,
                  NumberOfRefills ,
                  QuantityQualifier ,
                  QuantityValue ,
                  PotencyUnitCode ,
                  Substitutions ,
                  Directions ,
                  Note ,
                  WrittenDate ,
                  Diagnosis1 ,
                  Diagnosis2 ,
                  PriorAuthQualifier ,
                  PriorAuthValue ,
                  PriorAuthStatus ,
				  ProductCode,
				  ProductCodeQualifier,
				  BINLocationNumber,
                  PayerId,
                  PayerName,
                  CardHolderId,
                  CardHolderLastName,
                  CardHolderFirstName,
                  GroupId
                )
        VALUES  ( @incomingMessageId ,
                  'C' ,
			      @ChangeRequestType,
                  @RXREFERENCENUMBER ,
                  @PRESCRIBERORDERNUMBER ,
                  @SPIID ,

                  ISNULL(@PrescriberLastName, 'Not Found') ,
                  ISNULL(@PrescriberFirstName, 'Not Found') ,
                  ISNULL(@PrescriberMiddleName, '') ,
                  @PrescriberStaffId ,
                  @PrescriberAddress1 ,
                  '' ,
                  @PrescriberCity ,
                  @PrescriberState ,
                  @PrescriberZip ,
                  @PrescriberPhone ,
                  @PrescriberFax ,
                  @PATIENTLASTNAME ,
                  @PATIENTFIRSTNAME ,
                  @PATIENTMIDDLENAME ,
                  @PATIENTGENDER ,
                  CAST(@PATIENTDOB AS DATETIME) ,
                  @PATIENTADDRESS1 ,
                  @PATIENTADDRESS2 ,
                  @PATIENTCITY ,
                  @PATIENTSTATE ,
                  @PATIENTZIPCODE ,
                  dbo.csf_RDLSureScriptsFormatPhone(@PATIENTPHONE) ,
                  @FILEID ,
                  @NCPDPID ,
                  @DRUGDESCRIPTION ,
                  case when ISNULL(@DAYSSUPPLY,'')=''  then null else cast(@DAYSSUPPLY AS INT) end ,
                  CASE WHEN LEN(LTRIM(RTRIM(@REFILLQUALIFIER))) = 0 THEN 'R'
                       ELSE @REFILLQUALIFIER
                  END ,
                  CASE WHEN LEN(LTRIM(RTRIM(@REFILLQUANTITY))) = 0 THEN 0
                       ELSE CAST(@REFILLQUANTITY AS INT)
                  END ,
                  @QUANTITYQUALIFIER ,
                  CAST(@QUANTITYVALUE AS DECIMAL(29, 14)) ,
                  @POTENCYUNITCODE , --ISNULL(@POTENCYUNITCODE_Desc, @POTENCYUNITCODE) ,
                  @SUBSTITUTIONS ,
                  @DIRECTIONS ,
                  @NOTE ,
                  @WRITTENDATE ,
                  @DIAGNOSIS1 ,
                  @DIAGNOSIS2 ,
                  @PRIORAUTHQUALIFIER ,
                  @PRIORAUTHVALUE ,
                  @PRIORAUTHSTATUS ,
				  @PRODUCTCODE,
				  @PRODUCTCODEQUALIFIER,
				  @BINLocationNumber ,
                  @PAYERID ,
                  @PAYERNAME ,
                  @CARDHOLDERID ,
                  @CARDHOLDERLASTNAME ,
                  @CARDHOLDERFIRSTNAME ,
                  @GROUPID
                )
        SELECT @SureScriptChangeRequestId = SCOPE_IDENTITY() 
        SET @newRefillRequestId = @@identity

        UPDATE  a
        SET     PharmacyName = p.PharmacyName ,
                PharmacyAddress = p.Address ,
                PharmacyCity = p.City ,
                PharmacyState = p.State ,
                PharmacyZip = p.ZipCode ,
                PharmacyPhoneNumber = dbo.csf_RDLSureScriptsFormatPhone(p.PhoneNumber) ,
                PharmacyFaxNumber = dbo.csf_RDLSureScriptsFormatPhone(p.FaxNumber) ,
                PharmacyId = p.PharmacyId
        FROM    SureScriptsChangeRequests AS a
                CROSS JOIN Pharmacies AS p
        WHERE   a.SureScriptsChangeRequestId = @newRefillRequestId
                AND p.SureScriptsPharmacyIdentifier = @NCPDPID

		---- using the @PRESCRIBERORDERNUMBER, find the client id and medication information

        DECLARE @ClientId INT = NULL
        DECLARE @ClientMedicationScriptDrugStrengthId INT = NULL 
		
        SELECT  @ClientId = ClientId ,
                @ClientMedicationScriptDrugStrengthId = ClientMedicationScriptDrugStrengthId
        FROM    clientmedicationscripts a
                JOIN dbo.ClientMedicationScriptDrugStrengths b ON ( a.ClientMedicationScriptId = b.ClientMedicationScriptId )
        WHERE   a.ClientMedicationScriptId IN (
                SELECT  ClientMedicationScriptId
                FROM    ClientMedicationScriptActivities
                WHERE   PrescriberOrderNumber = @PRESCRIBERORDERNUMBER )      

        IF ( @ClientId IS NOT NULL
             AND @ClientMedicationScriptDrugStrengthId IS NOT NULL
             AND EXISTS ( SELECT    clientid
                          FROM      clients
                          WHERE     ClientId = @ClientId
                                    AND FirstName = LEFT(LTRIM(RTRIM(@PATIENTFIRSTNAME)),30)
                                    AND LastName = LEFT(LTRIM(RTRIM(@PATIENTLASTNAME)),30)
                                    AND CAST(DOB AS DATE) = CAST(@PATIENTDOB AS DATE) )
           ) 
            BEGIN 
                UPDATE  a
                SET     clientid = @ClientId ,
                        ClientMedicationScriptDrugStrengthId = @ClientMedicationScriptDrugStrengthId
                FROM    dbo.SureScriptsChangeRequests a
                WHERE   a.SureScriptsChangeRequestId = @newRefillRequestId
            END       
			ELSE 
			BEGIN 
				SELECT @ClientId = clientid
                          FROM      clients
                          WHERE     FirstName = LEFT(LTRIM(RTRIM(@PATIENTFIRSTNAME)),30)
                                    AND LastName =LEFT(LTRIM(RTRIM(@PATIENTLASTNAME)),30)
                                    AND CAST(DOB AS DATE) = CAST(@PATIENTDOB AS DATE)
				IF (@ClientId IS NOT NULL)
				BEGIN 
					UPDATE  a
					SET     clientid = @ClientId 
					FROM    dbo.SureScriptsChangeRequests a
					WHERE   a.SureScriptsChangeRequestId = @newRefillRequestId
				END 
			END 

        COMMIT TRAN

   

    END TRY
    BEGIN CATCH

        IF @@trancount > 0 
            ROLLBACK TRAN

        DECLARE @ErrorMessage NVARCHAR(4000)
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT  INTO ErrorLog
                ( ErrorMessage, ErrorType )
        VALUES  ( @ErrorMessage, 'SureScripts' )

        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH









GO

