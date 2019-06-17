SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE [name] = 'ssp_SCExecuteElectronicEligibilityVerification'
		)
	DROP PROCEDURE ssp_SCExecuteElectronicEligibilityVerification
GO

CREATE PROCEDURE [dbo].[ssp_SCExecuteElectronicEligibilityVerification] @270input AS XML
AS
BEGIN
	----------------------------------------------------------------------	
	-- Stored Procedure: [ssp_SCGetElectronicEligibilityVerificationConfigurations]     
	-- Creation Date:  03/29/2012														
	-- Purpose: Perform 270/271 Eligibility. Stores the request and response in the db.
	-- Input Parameters: 
	--		@270input - The required 270 input attributes		
	-- Output Parameters:
	--		Request Response Id - Integer id where 270/271 request and response is stored
	--
	--  Example Usage:
	--  EXECUTE ssp_SCExecuteElectronicEligibilityVerification
	--  '<?xml version="1.0"?>
	--  <_270Object xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	--  <GediPayerId xmlns="http://tempuri.org/">17111</GediPayerId>
	--  <ProviderName xmlns="http://tempuri.org/">Tucciarone</ProviderName>
	--  <NPI xmlns="http://tempuri.org/">1952519001</NPI>
	--  <InsuredFirstName xmlns="http://tempuri.org/">Noreen</InsuredFirstName>
	--  <InsuredLastName xmlns="http://tempuri.org/">White</InsuredLastName>
	--  <InsuranceNumber xmlns="http://tempuri.org/">0000572642</InsuranceNumber>
	--  <InsuredDateOfBirth xmlns="http://tempuri.org/">1966-06-13T00:00:00</InsuredDateOfBirth>
	--  <InsuredGender xmlns="http://tempuri.org/">Female</InsuredGender>
	--  <DependantDateOfBirth xmlns="http://tempuri.org/">1966-06-13T00:00:00</DependantDateOfBirth>
	--  <DependantGender xmlns="http://tempuri.org/">Male</DependantGender>
	--  <DependantRelationship xmlns="http://tempuri.org/">SELF</DependantRelationship>
	--  <EligibilityStartDate xmlns="http://tempuri.org/">2012-03-01T00:00:00</EligibilityStartDate>
	--  <EligibilityEndDate xmlns="http://tempuri.org/">2012-03-30T00:00:00</EligibilityEndDate>
	--  </_270Object>
	--  '
	-- Modified By Pradeep to set configuration data of WebService.	
	-- Modified By Pradeep to Replace function added on InsuredSSN to replace '-' to ''. #1506 (Core Bugs)
	-- Modified By Pradeep to Append ServiceTypeCodes to 270 XML.
	-- Modifeid By Pradeep to Add scsf_GetProviderNameforEligibility function to modify the ProviderName.KCMHSAS 3.5 Implemenation (#223)
	-- Modified by Pradeep to Replaced scsf_GetProviderNameforEligibility function with scsp_Modify270XML to modify the 270 xml to customize. 
	-- Modified by Pradeep to Get the Eligibility Configirations based on the ElectronicPayerId.
	-- Modified By Pradeep to Clear the SubScriberInsuranceNumber based on configuration key 'CLEARMEDICAID'.
	-- Modified By Pradeep to override the Minimal data required logic based on configuration key 'SENDMINIMALINFORMATION'.
	-- Modified By Pradeep to check the ProviderName ends like EDIGateway. In this case send the minimal data while submitting the request. This was not working in case of MFSEDIGateway. MFS-SGL #202
	-- 03/12/2019		Vijay		What:"Electronic Payer" Dropdown is loading with ElectronicPayerId as a value but we are storing duplicate values in this ElectronicEligibilityVerificationPayers table - ElectronicPayerId column. 
	--								So we changed the code to get ElectronicEligibilityVerificationPayerId(PrimaryKey) as a dropdown value and ElectronicPayerId as a attribute.
	--								Why: Bradford - Support Go Live - #742
	-- 03/14/2019		PradeepA	What: Modified for capturing UserCode and ClientId. UserCode is to construct REF*JD segment which is required for TCPIP connector and ClientId for Constructing the Unique TRN segment for each request.
	--								Why: Renaissance - Current Project Tasks #22
	----------------------------------------------------------------------	
	DECLARE @271XMLOutput AS XML;
	DECLARE @RequestId INT
	DECLARE @BatchId INT
	DECLARE @ElectronicPayerId VARCHAR(25)
	DECLARE @SubscriberInsuredId VARCHAR(25)
	DECLARE @SubscriberFirstName type_FirstName
	DECLARE @SubscriberLastName type_LastName
	DECLARE @SubscriberSSN type_SSN
	DECLARE @SubscriberDOB DATETIME
	DECLARE @SubscriberSex type_Sex
	DECLARE @DependentRelationshipCode type_GlobalCode
	DECLARE @DependentFirstName type_FirstName
	DECLARE @DependentLastName type_LastName
	DECLARE @DependentDOB DATETIME
	DECLARE @DependentSex type_Sex
	DECLARE @DateOfServiceStart DATE
	DECLARE @DateOfServiceEnd DATE
	DECLARE @ServiceTypeCode VARCHAR(MAX)
	DECLARE @ClearMedicaid CHAR(1) = 'Y'
	DECLARE @SendMinimalInformation CHAR(1) = 'Y'
	DECLARE @ElectronicEligibilityVerificationPayerId INT
	DECLARE @IncludeUserCodeForTheseTCPIPEligibilityConnectors VARCHAR(100) = ''
	DECLARE @UserCode VARCHAR(30)
	DECLARE @ClientId INT
	
	SELECT @ClearMedicaid = dbo.ssf_GetSystemConfigurationKeyValue('CLEARMEDICAID')

	SELECT @SendMinimalInformation = dbo.ssf_GetSystemConfigurationKeyValue('SENDMINIMALINFORMATION')

	SELECT @IncludeUserCodeForTheseTCPIPEligibilityConnectors = dbo.ssf_GetSystemConfigurationKeyValue('IncludeUserCodeForTheseTCPIPEligibilityConnectors');

	CREATE TABLE #RequestId (RequestId INT);

	SELECT @ElectronicPayerId = T.item.value('declare namespace x="http://tempuri.org/";data((x:GediPayerId)[1])', 'varchar(25)')
		,@ElectronicEligibilityVerificationPayerId = T.item.value('declare namespace x="http://tempuri.org/";data((x:ElectronicEligibilityVerificationPayerId)[1])', 'INT')
		,@SubscriberInsuredId = T.item.value('declare namespace x="http://tempuri.org/";data((x:InsuranceNumber)[1])', 'varchar(25)')
		,@SubscriberFirstName = T.item.value('declare namespace x="http://tempuri.org/";data((x:InsuredFirstName)[1])', 'varchar(20)')
		,@SubscriberLastName = T.item.value('declare namespace x="http://tempuri.org/";data((x:InsuredLastName)[1])', 'varchar(30)')
		,@SubscriberSSN = REPLACE(T.item.value('declare namespace x="http://tempuri.org/";data((x:InsuredSSN)[1])', 'varchar(30)'), '-', '')
		,@SubscriberDOB = T.item.value('declare namespace x="http://tempuri.org/";data((x:InsuredDateOfBirth)[1])', 'datetimeoffset(4)')
		,@SubscriberSex = T.item.value('declare namespace x="http://tempuri.org/";data((x:InsuredGender)[1])', 'char(1)')
		,@DependentRelationshipCode = CASE T.item.value('declare namespace x="http://tempuri.org/";data((x:DependantRelationship)[1])', 'varchar(20)')
			WHEN 'Self'
				THEN 18
			ELSE 19
			END
		,@DependentFirstName = T.item.value('declare namespace x="http://tempuri.org/";data((x:DependantFirstName)[1])', 'varchar(30)')
		,@DependentLastName = T.item.value('declare namespace x="http://tempuri.org/";data((x:DependantLastName)[1])', 'varchar(30)')
		,@DependentDOB = T.item.value('declare namespace x="http://tempuri.org/";data((x:DependantDateOfBirth)[1])', 'datetimeoffset(4)')
		,@DependentSex = T.item.value('declare namespace x="http://tempuri.org/";data((x:DependantGender)[1])', 'char(1)')
		,@DateOfServiceStart = T.item.value('declare namespace x="http://tempuri.org/";data((x:EligibilityStartDate)[1])', 'datetimeoffset(4)')
		,@DateOfServiceEnd = T.item.value('declare namespace x="http://tempuri.org/";data((x:EligibilityEndDate)[1])', 'datetimeoffset(4)')
		,@UserCode = T.item.value('declare namespace x="http://tempuri.org/";data((x:UserCode)[1])', 'varchar(30)')
		,@ClientId = T.item.value('declare namespace x="http://tempuri.org/";data((x:TransactionSetControlId)[1])', 'int')

	FROM @270input.nodes('_270Object') AS T(Item)

	/* Remove SSN from 270 Request if invalid */
	IF dbo.ssf_IsValidSSN(@SubscriberSSN) = 0
	BEGIN
		SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:InsuredSSN/text()')
		SET @SubscriberSSN = NULL
	END

	/* Remove Medicaid from 270 Request if invalid */
	IF ISNULL(@ClearMedicaid, 'Y') = 'Y'
	BEGIN
		IF dbo.ssf_IsValidMedicaidId(@SubscriberInsuredId) = 0
			AND EXISTS (
				SELECT *
				FROM dbo.ElectronicEligibilityVerificationPayers
				WHERE ElectronicEligibilityVerificationPayerId = @ElectronicEligibilityVerificationPayerId
					AND ElectronicPayerName LIKE '%Medicaid%'
				)
		BEGIN
			SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:InsuranceNumber/text()')
			SET @SubscriberInsuredId = NULL
		END
	END

	/* Only send minimal information needed to perform 270 request. Remove name and SSN if insured id and DOB exists. If 
			edi gateway is the provider it automatically sends minimal information so then don't remove anything */
	IF ISNULL(@SendMinimalInformation, 'Y') = 'Y'
	BEGIN
		IF (
				SELECT @270input.exist('declare namespace x="http://tempuri.org/";.[/_270Object/x:InsuranceNumber/text() and /_270Object/x:InsuredDateOfBirth/text()]')
				) = 1
			AND NOT EXISTS (
				SELECT *
				FROM dbo.ElectronicEligibilityVerificationConfigurations
				WHERE ProviderName LIKE  '%edigateway'
				)
		BEGIN
			SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:InsuredFirstName/text()')
			SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:InsuredLastName/text()')
			SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:InsuredSSN/text()')
			SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:DependantFirstName/text()')
			SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:DependantLastName/text()')
			SET @SubscriberFirstName = NULL
			SET @SubscriberLastName = NULL
			SET @DependentFirstName = NULL
			SET @DependentLastName = NULL
			SET @SubscriberSSN = NULL
		END
	END

	INSERT INTO #RequestId
	EXECUTE @RequestId = [ssp_SCCreateElectronicEligibilityVerificationRequest] @BatchId
		,@ElectronicPayerId
		,@SubscriberInsuredId
		,@SubscriberFirstName
		,@SubscriberLastName
		,@SubscriberSSN
		,@SubscriberDOB
		,@SubscriberSex
		,@DependentRelationshipCode
		,@DependentFirstName
		,@DependentLastName
		,@DependentDOB
		,@DependentSex
		,@DateOfServiceStart
		,@DateOfServiceEnd
		,@ElectronicEligibilityVerificationPayerId
		,@UserCode
		,@ClientId

	DECLARE @GatewayType AS VARCHAR(100)
	DECLARE @ServiceUrl AS NVARCHAR(300)
	DECLARE @ReuestTimeOut AS INT
	DECLARE @ServiceKey AS NVARCHAR(100)
	DECLARE @ServiceSecret AS NVARCHAR(100)
     DECLARE @ExecuteRequestCLR CHAR(1) = 'Y'

	SELECT @ServiceUrl = WebServiceURL
		,@ReuestTimeOut = RequestTimeoutSeconds * 1000
		,@ServiceKey = WebServiceUserName
		,@ServiceSecret = WebServicePassword
		,@GatewayType = ProviderName
	FROM ElectronicEligibilityVerificationConfigurations EEC
	INNER JOIN ElectronicEligibilityVerificationPayers EEP ON EEP.ElectronicEligibilityVerificationConfigurationId = EEC.ElectronicEligibilityVerificationConfigurationId
	WHERE EEP.ElectronicEligibilityVerificationPayerId = @ElectronicEligibilityVerificationPayerId

	SELECT @ServiceTypeCode = ISNULL(EEVST.ServiceTypeCode, '')
	FROM ElectronicEligibilityVerificationServiceTypeCodes EEVST
	INNER JOIN ElectronicEligibilityVerificationPayers EEP ON EEP.ElectronicEligibilityVerificationPayerId = EEVST.ElectronicEligibilityVerificationPayerId
	WHERE EEP.ElectronicEligibilityVerificationPayerId = @ElectronicEligibilityVerificationPayerId

	SET @ServiceTypeCode = ISNULL(@ServiceTypeCode, '30') -- Default to 30 for 'Health Benefit Plan Coverage'

	IF (ISNULL(@ServiceTypeCode, '') != '')
	BEGIN
		DECLARE @ServiceTypeCodeText AS XML = '<ServiceTypeCodes xmlns="http://tempuri.org/">' + @ServiceTypeCode + '</ServiceTypeCodes>'

		SET @270input.modify('insert sql:variable("@ServiceTypeCodeText") as last into (/_270Object)[1]')
	END

	-- This code will clear the UserCode from the request which is not required for all the connectors. Configure it, if REF*JD*Usercode segment is required in the message.
	IF NOT EXISTS(Select 1 FROM dbo.SplitString(ISNULL(@IncludeUserCodeForTheseTCPIPEligibilityConnectors,'None'),',') WHERE Token = @GatewayType)
	BEGIN
		SET @270input.modify('declare namespace x="http://tempuri.org/";delete /_270Object/x:UserCode/text()')
	END

	-- Write Custom logic to modify 270 XML.
	EXEC dbo.scsp_Modify270XML @270input
		,@RequestId
		,@270input OUTPUT
          
  
     IF OBJECT_ID('scsp_IndividualRealtimeEligibilityCheck') IS NOT NULL 
        BEGIN
              EXEC scsp_IndividualRealtimeEligibilityCheck @ServiceURL, @ReuestTimeOut, @ServiceKey, @ServiceSecret,
                @GatewayType, @270input, @271XMLOutput OUTPUT, @ExecuteRequestCLR OUTPUT
        END            
      
     IF @ExecuteRequestCLR = 'Y' 
        BEGIN
              SELECT    @271XMLOutput = CAST([dbo].[IndividualRealtimeEligibilityCheck](@ServiceUrl, @ReuestTimeOut,
                                                                                        @ServiceKey, @ServiceSecret,
                                                                                        @GatewayType,
                                                                                        CAST(@270input AS NVARCHAR(MAX))) AS XML)
        END
     
	DECLARE @VerifiedOnDate DATETIME = GETDATE();
	DECLARE @VerifiedXMLResponse XML = @271XMLOutput.query('//Message/ResponseMessage/eligibilityresponses/eligibilityresponse');
	DECLARE @RequestReturnCode INT = 0;
	DECLARE @RequestErrorMessage VARCHAR(100);

	SELECT @RequestReturnCode = 1
		,@RequestErrorMessage = T.item.value('data((ResponseMessage/ErrorMessage)[1])', 'varchar(500)')
	FROM @271XMLOutput.nodes('//Message') AS T(Item)
	WHERE T.item.exist('.[ResponseMessage/ErrorMessage]') = 1

	INSERT INTO #RequestId
	EXECUTE [dbo].[ssp_SCUpdateElectronicEligibilityVerificationResponse] @RequestId
		,@VerifiedOnDate
		,@VerifiedXMLResponse
		,NULL
		,@RequestReturnCode
		,@RequestErrorMessage

	SELECT @RequestId AS ReturningId
		,@RequestReturnCode AS RequestReturnCode
		,@RequestErrorMessage AS RequestErrorMessage
END
GO


