IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsReceiveRxfillRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SureScriptsReceiveRxfillRequest]
GO

Create PROCEDURE [dbo].[ssp_SureScriptsReceiveRxfillRequest]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsReceiveRxfillRequest

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  

Purpose:
	Receive new fill messages from Surescripts.

Output Parameters:

Return:
	None

Calls:

Called by:
	Surescripts Client Windows Service

Log:
  Created. with reference to ssp_SureScriptsGetApprovedRefillRequests
Date                         Name                                         Purpose




*/
/*****************************************************************************************************/
    @MESSAGEID VARCHAR(35) ,
    @RECEIVEDTIME VARCHAR(35) ,
    @NCPDPID VARCHAR(35) ,
    @SPIID VARCHAR(35) ,
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
    @DISPENSEDDRUGDESCRIPTION VARCHAR(105)=null ,
    @DISPENSEDDRUGSTRENGTH VARCHAR(35)=null ,
    @DISPENSEDDRUGSTRENGTHUNIT VARCHAR(35) =null,
    @DISPENSEDQUANTITYQUALIFIER VARCHAR(35) =null,
    @DISPENSEDQUANTITYVALUE VARCHAR(35) =null,
    @DISPENSEDDAYSSUPPLY VARCHAR(35) =null,
    @DISPENSEDPOTENCYUNITCODE VARCHAR(35) =null,
    @DISPENSEDDIRECTIONS VARCHAR(140) =null,
    @DISPENSEDNOTE VARCHAR(210) =null,
    @DISPENSEDSUBSTITUTIONS VARCHAR(35)=null ,
    @DISPENSEDREFILLQUALIFIER VARCHAR(35)= null ,
    @DISPENSEDREFILLQUANTITY VARCHAR(35)= null ,
    @DISPENSEDWRITTENDATE DATETIME =NULL   ,
    @DISPENSEDDIAGNOSIS1 VARCHAR(100) =null,
    @DISPENSEDDIAGNOSIS2 VARCHAR(100) =null ,
    @DISPENSEDPRIORAUTHQUALIFIER VARCHAR(2)= null ,
    @DISPENSEDPRIORAUTHVALUE VARCHAR(35) =null,
    @DISPENSEDPRIORAUTHSTATUS VARCHAR(1) =null ,
	@FILLNOTE VARCHAR(210),
	@FILLSTATUS VARCHAR(35),
    @REQUESTXML VARCHAR(MAX)
AS 
    BEGIN TRY
	    
		DECLARE @FillStatusCodeId INT 
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

		--SELECT @FillStatusCodeId= g.GlobalCodeId FROM GlobalCodes g WHERE Category='RxFill' AND code=@FILLSTATUS AND ISNULL(g.RecordDeleted,'N')!='Y'

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
                  'FILLREQ' ,
                  @localtime ,
                  @REQUESTXML
                )

        SET @incomingMessageId = @@identity

        INSERT  INTO SureScriptsfillRequests
                ( SureScriptsIncomingMessageId ,
                  StatusOfRequest ,
				  FillStatus,
				  FillNote,
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
                  DispensedDrugDescription ,
                  DispensedNumberOfDaysSupply ,
                  DispensedRefillType ,
                  DispensedNumberOfRefills ,
                  DispensedQuantityQualifier ,
                  DispensedQuantityValue ,
                  DispensedPotencyUnitCode ,
                  DispensedSubstitutions ,
                  DispensedDirections ,
                  DispensedNote ,
                  DispensedWrittenDate ,
                  DispensedDiagnosis1 ,
                  DispensedDiagnosis2 ,
                  DispensedPriorAuthQualifier ,
                  DispensedPriorAuthValue ,
                  DispensedPriorAuthStatus
                )
        VALUES  ( @incomingMessageId ,
                  'F' ,
				  @FILLSTATUS,
				  @FILLNOTE,
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
                  CAST(@DAYSSUPPLY AS INT) ,
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
                  @DISPENSEDDRUGDESCRIPTION ,
                  CAST(@DISPENSEDDAYSSUPPLY AS INT) ,
                  CASE WHEN LEN(LTRIM(RTRIM(@DISPENSEDREFILLQUALIFIER))) = 0
                       THEN 'R'
                       ELSE @DISPENSEDREFILLQUALIFIER
                  END ,
                  CASE WHEN LEN(LTRIM(RTRIM(@DISPENSEDREFILLQUANTITY))) = 0
                       THEN 0
                       ELSE CAST(@DISPENSEDREFILLQUANTITY AS INT)
                  END ,
                  @DISPENSEDQUANTITYQUALIFIER ,
                  CAST(@DISPENSEDQUANTITYVALUE AS DECIMAL(29, 14)) ,
                  @DISPENSEDPOTENCYUNITCODE , --ISNULL(@DISPENSEDPOTENCYUNITCODE_Desc,
                         --@DISPENSEDPOTENCYUNITCODE) ,
                  @DISPENSEDSUBSTITUTIONS ,
                  @DISPENSEDDIRECTIONS ,
                  @DISPENSEDNOTE ,
                  CASE WHEN ISNULL(@DISPENSEDWRITTENDATE,'')='' THEN NULL ELSE @DISPENSEDWRITTENDATE END,
                  @DISPENSEDDIAGNOSIS1 ,
                  @DISPENSEDDIAGNOSIS2 ,
                  @DISPENSEDPRIORAUTHQUALIFIER ,
                  @DISPENSEDPRIORAUTHVALUE ,
                  @DISPENSEDPRIORAUTHSTATUS 
                )

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
        FROM    SureScriptsfillRequests AS a
                CROSS JOIN Pharmacies AS p
        WHERE   a.SureScriptsfillRequestId = @newRefillRequestId
                AND p.SureScriptsPharmacyIdentifier = @NCPDPID

		-- using the @PRESCRIBERORDERNUMBER, find the client id and medication information

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
                                    AND FirstName = LTRIM(RTRIM(@PATIENTFIRSTNAME))
                                    AND LastName = LTRIM(RTRIM(@PATIENTLASTNAME))
                                    AND CAST(DOB AS DATE) = CAST(@PATIENTDOB AS DATE) )
           ) 
            BEGIN 
                UPDATE  a
                SET     clientid = @ClientId ,
                        ClientMedicationScriptDrugStrengthId = @ClientMedicationScriptDrugStrengthId
                FROM    dbo.SureScriptsfillRequests a
                WHERE   a.SureScriptsfillRequestId = @newRefillRequestId
            END       
			ELSE 
			BEGIN 
				SELECT @ClientId = clientid
                          FROM      clients
                          WHERE     FirstName = LTRIM(RTRIM(@PATIENTFIRSTNAME))
                                    AND LastName = LTRIM(RTRIM(@PATIENTLASTNAME))
                                    AND CAST(DOB AS DATE) = CAST(@PATIENTDOB AS DATE)
				IF (@ClientId IS NOT NULL)
				BEGIN 
					UPDATE  a
					SET     clientid = @ClientId 
					FROM    dbo.SureScriptsfillRequests a
					WHERE   a.SureScriptsfillRequestId = @newRefillRequestId
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
        VALUES  ( @ErrorMessage, 'SureScriptsFillRequest' )

        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH







GO

