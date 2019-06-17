/****** Object:  StoredProcedure [dbo].[ssp_GetRecordTargetXMLString]    Script Date: 09/24/2017 12:55:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetRecordTargetXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetRecordTargetXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetRecordTargetXMLString]    Script Date: 09/24/2017 12:55:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetRecordTargetXMLString] @ClientId INT = NULL                  
 ,@Type VARCHAR(10) = NULL                  
 ,@DocumentVersionId INT = NULL                  
 ,@FromDate DATETIME = NULL                  
 ,@ToDate DATETIME = NULL                 
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT                
-- =============================================                                           
/*                                
 Author   Added Date   Reason   Task      
 Vijay    05/09/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation                      
*/               
AS                
BEGIN               
            
 DECLARE @DefaultComponentXML VARCHAR(MAX) = ''                
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<!-- CONF 5254 -->
	<title>##AgencyName##: Health Summary</title>

	<!-- CONF 5256 -->
	<effectiveTime value="'+ convert(VARCHAR(10), GETDATE(), 112) +'"/>

	<!-- 5259 -->
	<confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25"/>

	<!-- 5372 -->
	<languageCode code="en-US"/>

	<!-- CONF 5266 -->
	<recordTarget>

		<!-- CONF 5267 -->
		<patientRole>

			<!-- CONF 5268-->
			<id extension="1" root="2.16.840.1.113883.4.6"/>
			<!-- Fake ID using HL7 example OID. -->

			<!-- Patient SSN recorded as an ID -->
			<id extension="##SSN##" root="2.16.840.1.113883.4.1"/>

			<!-- CONF 5271 -->
			<addr use="HP">
				<!-- HP is "primary home" from codeSystem 2.16.840.1.113883.5.1119 -->
				<streetAddressLine>##ClientAddressLine##</streetAddressLine>
				<city>##ClientCity##</city>
				<state>##ClientState##</state>
				<postalCode>##ClientZip##</postalCode>
				<country>US</country>
				<!-- US is "United States" from ISO 3166-1 Country Codes: 1.0.3166.1 -->
			</addr>

			<!-- CONF 5280 -->
			<telecom value="tel:##ClientPhoneNumber##" use="HP"/>
			<!-- HP is "primary home" from HL7 AddressUse 2.16.840.1.113883.5.1119 -->

			<!-- CONF 5283 -->
			<patient>

				<!-- CONF 5284 -->
				<name use="L">
					<!-- L is "Legal" from HL7 EntityNameUse 2.16.840.1.113883.5.45 -->
					<given>##ClientFirstName##</given>
					<given>##ClientMiddleName##</given>
					<!-- CL is "Call me" from HL7 EntityNamePartQualifier 2.16.840.1.113883.5.43 -->
					<family>##ClientLastName##</family>
				</name>
				<administrativeGenderCode code="##GenderCode##" codeSystem="2.16.840.1.113883.5.1" displayName="##Gender##"/>
				<birthTime value="##BirthDate##"/>

				<maritalStatusCode code="##ClientMaritalStatusCode##" displayName="##ClientMaritalStatus##" codeSystem="2.16.840.1.113883.5.2" codeSystemName="MaritalStatusCode"/>
				<religiousAffiliationCode code="1013" displayName="Christian (non-Catholic, non-specific)" codeSystemName="HL7 Religious Affiliation " codeSystem="2.16.840.1.113883.5.1076"/>

				<!-- Need to Fix the Race Code to be from the OMB Standards -->
				<raceCode code="##MoreGranularRaceCode##" displayName="##Race##" codeSystem="2.16.840.1.113883.6.238" codeSystemName="CDC - Race and EthnicityForCCDS"/>
				<ethnicGroupCode code="##EthnicityCodeForCCDS##" displayName="##EthnicityForCCDS##" codeSystem="2.16.840.1.113883.6.238" codeSystemName="CDC - Race and EthnicityForCCDS"/>

				###GUARDIAN###

				<birthplace>
					<place>
						<addr>
							<city>##ClientCity##</city>
							<state>##ClientState##</state>
							<postalCode>##ClientZip##</postalCode>
							<country>US</country>
						</addr>
					</place>
				</birthplace>

				<!-- FIX  the Code System to be 639.2 -->
				<languageCommunication>
					<languageCode code="##LanguageCode##"/>
					<modeCode code="ESP" displayName="Expressed spoken" codeSystem="2.16.840.1.113883.5.60" codeSystemName="LanguageAbilityMode"/>
					<preferenceInd value="true"/>
				</languageCommunication>
			</patient>
			<providerOrganization>
				<id root="1.1.1.1.1.1.1.1.4"/>
				<name>##AgencyName##</name>
				<telecom use="WP" value="tel: ##Phone##"/>
				<addr>
					<streetAddressLine>##Address##</streetAddressLine>
					<city>##City##</city>
					<state>##State##</state>
					<postalCode>##ZipCode##</postalCode>
					<country>US</country>
				</addr>
			</providerOrganization>
		</patientRole>
	</recordTarget>'
                 
 DECLARE @entryXML VARCHAR(MAX) = '<guardian>
		<code code="##RelationshipCode##" displayName="##Relationship##" codeSystem="2.16.840.1.113883.5.111" codeSystemName="HL7 Role code"/>
		<addr use="HP">
			<!-- HP is "primary home" from codeSystem 2.16.840.1.113883.5.1119 -->
			<streetAddressLine>##GuardianAddress##</streetAddressLine>
			<city>##GuardianCity##</city>
			<state>##GuardianState##</state>
			<postalCode>##GuardianZip##</postalCode>
			<country>US</country>
			<!-- US is "United States" from ISO 3166-1 Country Codes: 1.0.3166.1 -->
		</addr>
		<telecom value="tel:##GuardianPhone##" use="HP"/>
		<guardianPerson>
			<name>
				<given>##GuardianFirstName##</given>
				<family>##GuardianLastName##</family>
			</name>
		</guardianPerson>
	</guardian>'
 DECLARE @GUARDIANXML VARCHAR(MAX)                
 SET @GUARDIANXML = ''                
                 
 DECLARE @loopCOUNT INT = 0                
 DECLARE @tResults TABLE (                
  [ClientId] INT                
  ,[ClientName]   varchar(max)                
  ,[PreviousName]   varchar(max)                
  ,[Race]  varchar(max)                
  ,[RaceForCCDS] varchar(max)                
  ,[MoreGranularRaceCode] varchar(max)                
  ,[MoreGranularRaceCodeForCCDS] varchar(max)                 
  ,[Ethnicity]  varchar(max)                
  ,[EthnicityForCCDS]  varchar(max)                
  ,[EthnicityCodeForCCDS]  varchar(max)                
  ,[CommunicationLanguage] varchar(250)                
  ,[ClientAddress] varchar(150)                
  ,[Active] varchar(10)                
  ,[PhoneNumber] varchar(80)                
  ,[Gender] varchar(10)                
  ,[BirthDate] DATETIME                 
  ,[SSN]  varchar(25)                
  ,[LanguageCode] varchar(25)                
  ,[ClientFirstName] varchar(30)                
  ,[ClientMiddleName] varchar(30)                
  ,[ClientLastName] varchar(50)                   
  ,[GenderCode] varchar(10)                  
  ,[ClientMaritalStatus] varchar(250)                
  ,[ClientMaritalStatusCode] varchar(10)                
  ,[ClientAddressLine] varchar(150)                
  ,[ClientCity] varchar(50)                
  ,[ClientState] varchar(2)                
  ,[ClientZip] varchar(25)                
  ,[ClientPhoneNumber] varchar(80)                
  ,[AgencyName] varchar(250)                
  ,[AgencyAddress]varchar(150)                
  ,[AgencyCity] varchar(30)                
  ,[AgencyState] varchar(2)                
  ,[AgencyZipCode] varchar(12)                
  ,[AgencyPhone] varchar(50)                
  ,[AgencyDate] DATETIME                   
  )                
                
 INSERT INTO @tResults                
  EXEC ssp_GetPatientDemographicDetails Null                
   ,@Type                 
   ,@DocumentVersionId                 
   ,@FromDate                 
   ,@ToDate                
   ,Null
                   
 DECLARE @tSSN varchar(25) = ''                
 DECLARE @tRaceForCCDS varchar(max) = ''                
 DECLARE @tMoreGranularRaceCodeForCCDS varchar(max) = ''                 
 DECLARE @tEthnicityForCCDS varchar(max) = ''                 
 DECLARE @tEthnicityCodeForCCDS varchar(max) = ''                 
 DECLARE @tLanguageCode varchar(25) = ''                
 DECLARE @tClientFirstName varchar(30) = ''                
 DECLARE @tClientMiddleName varchar(30) = ''                
 DECLARE @tClientLastName varchar(50) = ''                
 DECLARE @tClientAddressLine varchar(150) = ''                
 DECLARE @tBirthDate varchar(100) = ''                
 DECLARE @tGenderCode varchar(10) = ''                
 DECLARE @tGender varchar(10) = ''                 
 DECLARE @tClientMaritalStatus varchar(250) = ''                
 DECLARE @tClientMaritalStatusCode varchar(10) = ''                
 DECLARE @tClientCity varchar(50) = ''                
 DECLARE @tClientState varchar(2) = ''                
 DECLARE @tClientZip varchar(25) = ''                
 DECLARE @tClientPhoneNumber varchar(80) = ''                
 DECLARE @tAgencyName varchar(250) = ''                
 DECLARE @tAgencyAddress varchar(150) = ''                
 DECLARE @tAgencyCity varchar(30) = ''                
 DECLARE @tAgencyState varchar(2) = ''                
 DECLARE @tAgencyZipCode varchar(12) = ''                
 DECLARE @tAgencyPhone varchar(50) = ''                
 DECLARE @tAgencyDate varchar(100) = ''                
                  
 IF EXISTS (                
   SELECT *                
   FROM @tResults                
   )                
	 BEGIN                
	  DECLARE tCursor CURSOR FAST_FORWARD                
	  FOR                
	  SELECT [SSN]                
	   ,[RaceForCCDS]                
	   ,[MoreGranularRaceCodeForCCDS]                
	   ,[EthnicityForCCDS]                
	   ,[EthnicityCodeForCCDS]                
	   ,[LanguageCode]                
	   ,[ClientFirstName]                
	   ,[ClientMiddleName]                
	   ,[ClientLastName]                
	   ,[BirthDate]                
	   ,[GenderCode]                
	   ,[Gender]                
	   ,[ClientMaritalStatus]                
	   ,[ClientMaritalStatusCode]                
	   ,[ClientAddressLine]                
	   ,[ClientCity]                
	   ,[ClientState]                
	   ,[ClientZip]                
	   ,[ClientPhoneNumber]                  
	   ,[AgencyName]                
	   ,[AgencyAddress]                
	   ,[AgencyCity]                 
	   ,[AgencyState]                 
	   ,[AgencyZipCode]                
	   ,[AgencyPhone]                
	   ,[AgencyDate]                
	  FROM @tResults TDS                
	                
	  OPEN tCursor                
	                
	  FETCH NEXT                
	  FROM tCursor                
	  INTO @tSSN                
	   ,@tRaceForCCDS                
	   ,@tMoreGranularRaceCodeForCCDS                
	   ,@tEthnicityForCCDS                
	   ,@tEthnicityCodeForCCDS                
	   ,@tLanguageCode                
	   ,@tClientFirstName                
	   ,@tClientMiddleName                
	   ,@tClientLastName                
	   ,@tBirthDate                
	   ,@tGenderCode                
	   ,@tGender                
	   ,@tClientMaritalStatus                
	   ,@tClientMaritalStatusCode                
	   ,@tClientAddressLine                
	   ,@tClientCity                
	   ,@tClientState                
	   ,@tClientZip                
	   ,@tClientPhoneNumber                
	   ,@tAgencyName                
	   ,@tAgencyAddress                
	   ,@tAgencyCity                
	   ,@tAgencyState                
	   ,@tAgencyZipCode                
	   ,@tAgencyPhone                
	   ,@tAgencyDate                
	                      
	  WHILE (@@FETCH_STATUS = 0)                
	  BEGIN                
	
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Race##', ISNULL(@tRaceForCCDS, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##MoreGranularRaceCode##', ISNULL(@tMoreGranularRaceCodeForCCDS, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##EthnicityForCCDS##', ISNULL(@tEthnicityForCCDS, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##EthnicityCodeForCCDS##', ISNULL(@tEthnicityCodeForCCDS, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##SSN##', ISNULL(@tSSN, 'UNK'))        
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##LanguageCode##', ISNULL(@tLanguageCode, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientFirstName##', ISNULL(@tClientFirstName, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientMiddleName##', ISNULL(@tClientMiddleName, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientLastName##', ISNULL(@tClientLastName, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##BirthDate##', convert(VARCHAR(max), convert(DATETIME, @tBirthDate), 112))    
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##GenderCode##', ISNULL(@tGenderCode, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Gender##', ISNULL(@tGender, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientMaritalStatus##', ISNULL(@tClientMaritalStatus, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientMaritalStatusCode##', ISNULL(@tClientMaritalStatusCode, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientAddressLine##', ISNULL(@tClientAddressLine, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientCity##', ISNULL(@tClientCity, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientState##', ISNULL(@tClientState, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientZip##', ISNULL(@tClientZip, 'UNK'))                 
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ClientPhoneNumber##', ISNULL(@tClientPhoneNumber, 'UNK'))                      
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##AgencyName##', ISNULL(@tAgencyName, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Address##', ISNULL(@tAgencyAddress, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##City##', ISNULL(@tAgencyCity, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##State##', ISNULL(@tAgencyState, 'UNK'))               
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ZipCode##', ISNULL(@tAgencyZipCode, 'UNK'))                
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Phone##', ISNULL(@tAgencyPhone, 'UNK'))                
	                  
	   SET @loopCOUNT = @loopCOUNT + 1                
	                
	   --PRINT @PLACEHOLDERXML                
	                
	   FETCH NEXT                
	   FROM tCursor                
	   INTO @tSSN                
		,@tRaceForCCDS                
		,@tMoreGranularRaceCodeForCCDS                
		,@tEthnicityForCCDS                
		,@tEthnicityCodeForCCDS                
		,@tLanguageCode                
		,@tClientFirstName                
		,@tClientMiddleName                
		,@tClientLastName                
		,@tBirthDate                
		,@tGenderCode                
		,@tGender                
		,@tClientMaritalStatus                
		,@tClientMaritalStatusCode                
		,@tClientAddressLine                
		,@tClientCity                
		,@tClientState                
		,@tClientZip                
		,@tClientPhoneNumber                 
		,@tAgencyName                
		,@tAgencyAddress                
		,@tAgencyCity                
		,@tAgencyState                
		,@tAgencyZipCode                
		,@tAgencyPhone                
		,@tAgencyDate                
	                   
	  END                
	                
	  CLOSE tCursor                
	                
	  DEALLOCATE tCursor                
	 END
  ELSE                
	BEGIN                
	 SET @PLACEHOLDERXML = @DefaultComponentXML
	END                
--Gurdian#####################################
 SET @loopCOUNT = 0                
 DECLARE @tempResults TABLE (                
  [ClientId] INT                
  ,[Relationship] varchar(250)                
  ,[RelationshipCode] varchar(50)                
  ,[GuardianAddress] varchar(150)                
  ,[GuardianCity] varchar(50)                
  ,[GuardianState] varchar(2)                
  ,[GuardianZip] varchar(25)                
  ,[GuardianPhone] varchar(80)                
  ,[GuardianFirstName] varchar(30)                
  ,[GuardianLastName] varchar(50)                    
  )                
                                
 INSERT INTO @tempResults                  
  EXEC ssp_GetGuardian @ClientId                
   ,@Type                 
   ,@DocumentVersionId                 
   ,@FromDate                 
   ,@ToDate
                      
 DECLARE @tRelationship varchar(250) = ''                
 DECLARE @tRelationshipCode varchar(50) = ''                
 DECLARE @tGuardianAddress varchar(150) = ''                
 DECLARE @tGuardianCity varchar(50) = ''      
 DECLARE @tGuardianState varchar(2) = ''                
 DECLARE @tGuardianZip varchar(25) = ''                
 DECLARE @tGuardianPhone varchar(80) = ''                
 DECLARE @tGuardianFirstName varchar(30) = ''                
 DECLARE @tGuardianLastName varchar(50) = ''                
                 
 IF EXISTS (                
   SELECT *                
   FROM @tempResults                
   )                
 BEGIN                
  DECLARE tCursor CURSOR FAST_FORWARD                
  FOR                
  SELECT [Relationship]                
   ,[RelationshipCode]                
   ,[GuardianAddress]                
   ,[GuardianCity]                
   ,[GuardianState]                
   ,[GuardianZip]                
   ,[GuardianPhone]                
   ,[GuardianFirstName]                
   ,[GuardianLastName]                
  FROM @tempResults                
                
  OPEN tCursor                
                
  FETCH NEXT                
  FROM tCursor                
  INTO @tRelationship                
   ,@tRelationshipCode                
   ,@tGuardianAddress                
   ,@tGuardianCity                
   ,@tGuardianState                
   ,@tGuardianZip                
   ,@tGuardianPhone                
   ,@tGuardianFirstName                
   ,@tGuardianLastName                
                   
  WHILE (@@FETCH_STATUS = 0)                
  BEGIN                
   SET @GUARDIANXML = @GUARDIANXML + @entryXML                
   --SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##ID##', @loopCOUNT)               
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##Relationship##', ISNULL(@tRelationship, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##RelationshipCode##', ISNULL(@tRelationshipCode, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##GuardianAddress##', ISNULL(@tGuardianAddress, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##GuardianCity##', ISNULL(@tGuardianCity, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##GuardianState##', ISNULL(@tGuardianState, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##GuardianZip##', ISNULL(@tGuardianZip, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##GuardianPhone##', ISNULL(@tGuardianPhone, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##GuardianFirstName##', ISNULL(@tGuardianFirstName, 'UNK'))                
   SET @GUARDIANXML = REPLACE(@GUARDIANXML, '##GuardianLastName##', ISNULL(@tGuardianLastName, 'UNK'))                
                   
   SET @loopCOUNT = @loopCOUNT + 1                
                
   PRINT @GUARDIANXML                
                
   FETCH NEXT                
   FROM tCursor                
   INTO @tRelationship                
    ,@tRelationshipCode                
    ,@tGuardianAddress                
    ,@tGuardianCity                
    ,@tGuardianState                
    ,@tGuardianZip                
    ,@tGuardianPhone                
    ,@tGuardianFirstName          
    ,@tGuardianLastName                
  END                
                
  CLOSE tCursor                
                
  DEALLOCATE tCursor                
--##############################################################################
  SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '###GUARDIAN###', @GUARDIANXML)                
  SET @OutputComponentXML = @PLACEHOLDERXML                
 END                
 ELSE                
 BEGIN                
  SET @OutputComponentXML = @DefaultComponentXML                
 END                

END 
GO
