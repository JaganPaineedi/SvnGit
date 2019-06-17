/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsReceiveRxRefillRequest]    Script Date: 9/13/2013 4:05:01 PM ******/
DROP PROCEDURE [dbo].[ssp_SureScriptsReceiveRxRefillRequest]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsReceiveRxRefillRequest]    Script Date: 9/13/2013 4:05:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SureScriptsReceiveRxRefillRequest]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetApprovedRefillRequests

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Receive new refill request from Surescripts.

Output Parameters:

Return:
	None

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created.
	Sept 13, 2013 - added Dispensed columns to the SureScriptsRefillRequests table
	9/17/2013 - Kalpers added PotencyUnitCode for prescribed and dispensed
	9/25/2013 - Kalpers added additional parameters and added code to retrieve pharmacy address information
	10/21/2013 - Kalpers added code to link client and medication when the PON is found
	10/24/2013 - Kalpers when PON number is not linked, link to Patient First, Last and birthdate
	08/28/2017- PranayB Added ORDER BY ISNULL(MasterRecord,'N') DESC w.r.t task 428 Aspen Point
	09/07/2017 -PranayB Added cast  @ReceivedDate to 19 w.r.t task 414 Aspeen point 
	09/12/2018- Pranay B Added Case statements for getting the ClientID and conditional check on @PRESCRIBERORDERNUMBER w.r.t AP 884
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
	@DISPENSEDDRUGDESCRIPTION VARCHAR(105) ,
	@DISPENSEDDRUGSTRENGTH VARCHAR(35) ,
	@DISPENSEDDRUGSTRENGTHUNIT VARCHAR(35) ,
	@DISPENSEDQUANTITYQUALIFIER VARCHAR(35) ,
	@DISPENSEDQUANTITYVALUE VARCHAR(35) ,
	@DISPENSEDDAYSSUPPLY VARCHAR(35) ,
	@DISPENSEDPOTENCYUNITCODE VARCHAR(35) ,
	@DISPENSEDDIRECTIONS VARCHAR(140) ,
	@DISPENSEDNOTE VARCHAR(210) ,
	@DISPENSEDSUBSTITUTIONS VARCHAR(35) ,
	@DISPENSEDREFILLQUALIFIER VARCHAR(35) ,
	@DISPENSEDREFILLQUANTITY VARCHAR(35) ,
	@DISPENSEDWRITTENDATE DATETIME ,
	@DISPENSEDDIAGNOSIS1 VARCHAR(100) ,
	@DISPENSEDDIAGNOSIS2 VARCHAR(100) ,
	@DISPENSEDPRIORAUTHQUALIFIER VARCHAR(2) ,
	@DISPENSEDPRIORAUTHVALUE VARCHAR(35) ,
	@DISPENSEDPRIORAUTHSTATUS VARCHAR(1) ,
	@REQUESTXML VARCHAR(MAX)
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
FROM Staff AS s
CROSS JOIN agency a
WHERE s.SureScriptsPrescriberId + SureScriptsLocationId = @SPIID

BEGIN TRAN

DECLARE @localtime DATETIME
DECLARE @RECEIVEDDATETIME DateTime
SET @RECEIVEDDATETIME = CASE
	when len(@RECEIVEDTIME) > 19
	THEN CAST (SUBSTRING ( @RECEIVEDTIME ,1 , 19 )+'Z' AS DATETIME)
	else CAST (@RECEIVEDTIME AS DATETIME)
END

SET @localtime = DATEADD(hour, DATEDIFF(hour, GETUTCDATE(), GETDATE()), CAST(@RECEIVEDDATETIME AS DATETIME))

INSERT  INTO SureScriptsIncomingMessages (
	SureScriptsMessageId ,
	MessageType ,
	ReceivedDateTime ,
	MessageText
)
VALUES  (
	@MESSAGEID ,
	'REFILLREQ' ,
	@localtime ,
	@REQUESTXML
)

SET @incomingMessageId = @@identity

INSERT INTO SureScriptsRefillRequests (
	SureScriptsIncomingMessageId ,
	StatusOfRequest ,
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
VALUES (
	@incomingMessageId ,
	'R' ,
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
	CASE 
		WHEN LEN(LTRIM(RTRIM(@REFILLQUALIFIER))) = 0
		THEN 'R'
		ELSE @REFILLQUALIFIER
	END ,
	CASE 
		WHEN LEN(LTRIM(RTRIM(@REFILLQUANTITY))) = 0 
		THEN 0
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
	CASE
		WHEN LEN(LTRIM(RTRIM(@DISPENSEDREFILLQUALIFIER))) = 0
		THEN 'R'
		ELSE @DISPENSEDREFILLQUALIFIER
	END ,
	CASE
		WHEN LEN(LTRIM(RTRIM(@DISPENSEDREFILLQUANTITY))) = 0
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
	@DISPENSEDWRITTENDATE ,
	@DISPENSEDDIAGNOSIS1 ,
	@DISPENSEDDIAGNOSIS2 ,
	@DISPENSEDPRIORAUTHQUALIFIER ,
	@DISPENSEDPRIORAUTHVALUE ,
	@DISPENSEDPRIORAUTHSTATUS 
)

SET @newRefillRequestId = @@identity

UPDATE a
SET PharmacyName = p.PharmacyName ,
	PharmacyAddress = p.Address ,
	PharmacyCity = p.City ,
	PharmacyState = p.State ,
	PharmacyZip = p.ZipCode ,
	PharmacyPhoneNumber = dbo.csf_RDLSureScriptsFormatPhone(p.PhoneNumber) ,
	PharmacyFaxNumber = dbo.csf_RDLSureScriptsFormatPhone(p.FaxNumber) ,
	PharmacyId = p.PharmacyId
FROM SureScriptsRefillRequests AS a
CROSS JOIN Pharmacies AS p
WHERE a.SureScriptsRefillRequestId = @newRefillRequestId
	AND p.SureScriptsPharmacyIdentifier = @NCPDPID

-- using the @PRESCRIBERORDERNUMBER, find the client id and medication information

DECLARE @ClientId INT = NULL
DECLARE @ClientMedicationScriptDrugStrengthId INT = NULL 

IF(ISNULL(@PRESCRIBERORDERNUMBER,'')!='')
BEGIN
	SELECT @ClientId = ClientId ,
		@ClientMedicationScriptDrugStrengthId = ClientMedicationScriptDrugStrengthId
	FROM clientmedicationscripts a
	JOIN dbo.ClientMedicationScriptDrugStrengths b ON ( a.ClientMedicationScriptId = b.ClientMedicationScriptId )
	WHERE a.ClientMedicationScriptId IN (
		SELECT  ClientMedicationScriptId
		FROM    ClientMedicationScriptActivities
		WHERE   PrescriberOrderNumber = @PRESCRIBERORDERNUMBER
	)
END

IF ( @ClientId IS NOT NULL
	AND @ClientMedicationScriptDrugStrengthId IS NOT NULL
	AND EXISTS (
		SELECT    clientid
		FROM      clients
		WHERE     ClientId = @ClientId
			AND FirstName = LTRIM(RTRIM(@PATIENTFIRSTNAME))
			AND LastName = LTRIM(RTRIM(@PATIENTLASTNAME))
			AND CAST(DOB AS DATE) = CAST(@PATIENTDOB AS DATE)
	)
)
BEGIN

	UPDATE a
	SET clientid = @ClientId ,
		ClientMedicationScriptDrugStrengthId = @ClientMedicationScriptDrugStrengthId
	FROM dbo.SureScriptsRefillRequests a
	WHERE a.SureScriptsRefillRequestId = @newRefillRequestId
END

ELSE
BEGIN
	--re-initialize clientid because it might have
	--	an Id from the previous query
	set @ClientId = null
	SELECT TOP 1 @ClientId = clientid
	FROM clients
	WHERE LastName = LTRIM(RTRIM(@PATIENTLASTNAME))
		AND CAST(DOB AS DATE) = CAST(@PATIENTDOB AS DATE)
		AND 0 = CASE
				WHEN CHARINDEX(' ', @PATIENTFIRSTNAME) > 0
					AND FirstName = LTRIM(RTRIM(SUBSTRING(@PATIENTFIRSTNAME, 1, CHARINDEX(' ', @PATIENTFIRSTNAME)))) 
				THEN 0

				WHEN (FirstName = LTRIM(RTRIM(@PATIENTFIRSTNAME)))
				THEN 0
				ELSE 1
			END

	ORDER BY ISNULL(MasterRecord,'N') DESC

	IF (@ClientId IS NOT NULL)
	BEGIN 
		UPDATE  a
		SET clientid = @ClientId 
		FROM dbo.SureScriptsRefillRequests a
		WHERE a.SureScriptsRefillRequestId = @newRefillRequestId
	END
END

COMMIT TRAN

END TRY

BEGIN CATCH

	IF @@trancount > 0 
		ROLLBACK TRAN

	DECLARE @ErrorMessage NVARCHAR(4000)
	SET @ErrorMessage = ERROR_MESSAGE()

	INSERT INTO ErrorLog
		( ErrorMessage, ErrorType )
	VALUES ( @ErrorMessage, 'SureScripts' )

	RAISERROR(@ErrorMessage, 16, 1)

END CATCH


GO