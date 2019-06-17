/****** Object:  StoredProcedure [dbo].[ssp_GetPrivacyAndSecurityMarkingsXMLString]    Script Date: 09/22/2017 18:46:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPrivacyAndSecurityMarkingsXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPrivacyAndSecurityMarkingsXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetPrivacyAndSecurityMarkingsXMLString]    Script Date: 09/22/2017 18:46:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [dbo].[ssp_GetPrivacyAndSecurityMarkingsXMLString] @ClientId INT = NULL    
 ,@Type VARCHAR(10) = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@FromDate DATETIME = NULL    
 ,@ToDate DATETIME = NULL   
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT
 -- =============================================                             
/*                  
 Author   Added Date   Reason   Task                  
 Vijay    09/10/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation    
*/   
AS  
BEGIN  
 DECLARE @DefaultComponentXML VARCHAR(MAX) = ''  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>
			<!-- 
				********************************************************
				Privacy and Security Markings Section
				********************************************************
			-->
			<section>
				<!-- Privacy Markings section template -->
				<templateId root="2.16.840.1.113883.3.3251.1.5"
					assigningAuthorityName="HL7 Security"/>
				<code code="57017-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
					displayName="Privacy policy Organization"/>
				<title>Security and Privacy Prohibitions</title>
				<text>
					Section Author:  Dr. ##FirstName## ##LastName##, ##AgencyName## <br/>
					PROHIBITION ON REDISCLOSURE OF CONFIDENTIAL INFORMATION:  <br/> ##PROHIBITIONONREDISCLOSURE##
				</text>
				<confidentialityCode code="R" codeSystem="2.16.840.1.113883.5.25" codeSystemName="HL7 Confidentiality"/>
				<author>

					<!-- Mandatory Document Author for DS4P-->
					<templateId root="2.16.840.1.113883.3.3251.1.2" assigningAuthorityName="HL7 Security"/>

					<time value="20150622"/>
					<assignedAuthor>
						<!-- Mandatory Document Provenance - assigned author for DS4P -->
						<templateId root="2.16.840.1.113883.3.3251.1.3" assigningAuthorityName="HL7 Security"/>

						<!-- auhorId -->
						<id extension="111111" root="2.16.840.1.113883.4.6"/>
						<code code="200000000X" codeSystem="2.16.840.1.113883.6.101" displayName="Allopathic &amp; Osteopathic Physicians"/>
						<addr>
							<streetAddressLine>##Address##</streetAddressLine>
							<city>##City##</city>
							<state>##State##</state>
							<postalCode>##ZipCode##</postalCode>
							<country>US</country>
						</addr>
						<telecom use="WP" value="tel:+1##Phone##"/>
						<assignedPerson>
							<!--  AuthorProviderName -->
							<name>
								<prefix>Dr.</prefix>
								<family>##LastName##</family>
								<given>##FirstName##</given>
							</name>
						</assignedPerson>
						<!-- added representedOrganization for CCD requirements when we do NOT have an assignedPerson -db -->
						<!-- Consol Continuity of Care Document (CCD) (V3) SHALL contain at least one [1..*] author, 
							where its type is Author (CONF:1198-9442) each SHALL contain exactly one [1..1] assignedAuthor,
							where  (CONF:1198-9443) assignedAuthor SHALL contain exactly one [1..1] assignedPerson and/or exactly one [1..1]
							representedOrganization (CONF:1198-8456) -->
						<representedOrganization>
							<id root="2.16.840.1.113883.19.5"/>
							<name>##AgencyName##</name>
						</representedOrganization>
					</assignedAuthor>
				</author>
				<entry typeCode="COMP">
					<!-- Privacy Marking Entry to indicate the precise/computable security obligations and refrains -->
					<templateId root="2.16.840.1.113883.3.3251.1.9" assigningAuthorityName="HL7 Security"/>
					<organizer classCode="CLUSTER" moodCode="EVN">
						<!-- Privacy Annotations are organized using template "2.16.840.1.113883.3.3251.1.4" -->
						<templateId root="2.16.840.1.113883.3.3251.1.4" assigningAuthorityName="HL7 Security"/>
						<statusCode code="active"/>
						<component typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<!-- Security Observation -->
								<templateId root="2.16.840.1.113883.3.445.21" assigningAuthorityName="HL7 CBCC"/>
								<!--  Confidentiality Code template -->
								<templateId root="2.16.840.1.113883.3.445.12" assigningAuthorityName="HL7 CBCC"/>
								<!-- Confidentiality Security Observation - the only mandatory element of a Privacy Annotation -->
								<!-- old invalid code -dbDS4P -->
								<!-- <code code="SECCLASSOBS" codeSystem="2.16.840.1.113883.1.11.20457" displayName="Security Classification" codeSystemName="HL7 SecurityObservationTypeCodeSystem"/> -->
								<!-- new corrected code -dbDS4P -->
								<code code="SECCLASSOBS" codeSystem="2.16.840.1.113883.1.11.20471" displayName="Security Category" codeSystemName="SecurityControlObservationValue"/>
								<!-- value set constrained to "2.16.840.1.113883.1.11.16926" -->
								<value xsi:type="CE" code="R" codeSystem="2.16.840.1.113883.5.1063" codeSystemName="SecurityObservationValueCodeSystem" displayName="##RESTRICTED##">
									<originalText>##RESTRICTED## Confidentiality</originalText>
								</value>
							</observation>
						</component>
						<component typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<!-- Security Observation -->
								<templateId root="2.16.840.1.113883.3.445.21" assigningAuthorityName="HL7 CBCC"/>
								<!--  Refrain Policy Code template -->
								<templateId root="2.16.840.1.113883.3.445.23" assigningAuthorityName="HL7 CBCC"/>
								<code code="SECCONOBS" codeSystem="2.16.840.1.113883.1.11.20457" displayName="Security Classification" codeSystemName="HL7 SecurityObservationTypeCodeSystem"/>
								<!-- Value set constraint "2.16.840.1.113883.1.11.20446" -->
								<!-- old invalid value -dbDS4P -->
								<!-- <value xsi:type="CE" code="NORDSLCD" codeSystem="2.16.840.1.113883.5.1063" codeSystemName="SecurityObservationValueCodeSystem" displayName="Prohibition on redisclosure without patient consent directive">
										<originalText>Prohibition on redisclosure without patient consent directive</originalText>
									</value>  -->
								<!-- new correct value -db -->
								<value xsi:type="CE" code="NORDSCLCD" codeSystem="2.16.840.1.113883.1.11.20471" codeSystemName="SecurityObservationValue" displayName="Prohibition on redisclosure without patient consent directive">
									<originalText>Prohibition on redisclosure without patient consent directive</originalText>
								</value>
							</observation>
						</component>
						<component typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<!-- Security Observation -->
								<templateId root="2.16.840.1.113883.3.445.21" assigningAuthorityName="HL7 CBCC"/>
								<!--  Purpose Of Use Code template -->
								<templateId root="2.16.840.1.113883.3.445.22" assigningAuthorityName="HL7 CBCC"/>
								<code code="SECCONOBS" codeSystem="2.16.840.1.113883.1.11.20457" displayName="Security Classification" codeSystemName="HL7 SecurityObservationTypeCodeSystem"/>
								<value xsi:type="CE" code="TREAT" codeSystem="2.16.840.1.113883.5.8" codeSystemName="ActReason" displayName="Treatment">
									<originalText>Information intended for treatment</originalText>
								</value>
							</observation>
						</component>
					</organizer>
				</entry>
			</section>
		</component>'  
		 				 				 
 DECLARE @finalEntry VARCHAR(MAX)
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [ClientId] INT
  ,[FirstName] varchar(20)             
  ,[LastName] varchar(30)            
  ,[AgencyName] varchar(250)            
  ,[Address]varchar(100)            
  ,[City] varchar(30)            
  ,[State] varchar(2)            
  ,[ZipCode] varchar(12)            
  ,[Phone] varchar(50)
  ,[ConfidentialityCode] varchar(100)
  ,[TextForConfidentialityCode] varchar(max)
  )
  		      
  
 INSERT INTO @tResults  
  EXEC ssp_GetPrivacyAndSecurityMarkings @ClientId  
   ,@Type   
   ,@DocumentVersionId   
   ,@FromDate   
   ,@ToDate   
  
 DECLARE @tFirstName varchar(20) = ''            
 DECLARE @tLastName varchar(30) = ''             
 DECLARE @tAgencyName varchar(250) = ''            
 DECLARE @tAddress varchar(100) = ''            
 DECLARE @tCity varchar(30) = ''            
 DECLARE @tState varchar(2) = ''         
 DECLARE @tZipCode varchar(12) = ''            
 DECLARE @tPhone varchar(50) = ''
 DECLARE @tConfidentialityCode varchar(100) = ''
 DECLARE @tTextForConfidentialityCode varchar(max) = ''
            
  
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [FirstName]            
	   ,[LastName]            
	   ,[AgencyName]            
	   ,[Address]            
	   ,[City]             
	   ,[State]             
	   ,[ZipCode]            
	   ,[Phone]
	   ,[ConfidentialityCode] 
	   ,[TextForConfidentialityCode] 
  FROM @tResults  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tFirstName            
	   ,@tLastName            
	   ,@tAgencyName
	   ,@tAddress
	   ,@tCity            
	   ,@tState    
	   ,@tZipCode            
	   ,@tPhone
	   ,@tConfidentialityCode
	   ,@tTextForConfidentialityCode 
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
  IF @tConfidentialityCode = 'Normal'
	  BEGIN
		SET @PLACEHOLDERXML = '';
	  END
  ELSE
	  BEGIN
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##FirstName##', ISNULL(@tFirstName, 'UNK'))  
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##LastName##', ISNULL(@tLastName, 'UNK'))  
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##AgencyName##', ISNULL(@tAgencyName, 'UNK'))  
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Address##', ISNULL(@tAddress, 'UNK'))  
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##City##', ISNULL(@tCity, 'UNK'))  
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##State##', ISNULL(@tState, 'UNK'))  
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ZipCode##', ISNULL(@tZipCode, 'UNK'))  
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Phone##', ISNULL(@tPhone, 'UNK'))
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##RESTRICTED##', ISNULL(@tConfidentialityCode, 'UNK'))
	   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##PROHIBITIONONREDISCLOSURE##', ISNULL(@tTextForConfidentialityCode, 'UNK'))
	   SET @loopCOUNT = @loopCOUNT + 1  
	  END
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tFirstName            
	   ,@tLastName            
	   ,@tAgencyName            
	   ,@tAddress            
	   ,@tCity            
	   ,@tState    
	   ,@tZipCode            
	   ,@tPhone
	   ,@tConfidentialityCode
	   ,@tTextForConfidentialityCode  
  END  
  
  CLOSE tCursor  
  
  DEALLOCATE tCursor  
  
  SET @OutputComponentXML = @PLACEHOLDERXML  
 END  
 ELSE  
 BEGIN  
  SET @OutputComponentXML = @DefaultComponentXML  
 END  
   
END  
  
GO