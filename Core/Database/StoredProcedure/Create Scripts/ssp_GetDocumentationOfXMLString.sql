/****** Object:  StoredProcedure [dbo].[ssp_GetDocumentationOfXMLString]    Script Date: 09/22/2017 17:56:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDocumentationOfXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDocumentationOfXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetDocumentationOfXMLString]    Script Date: 09/22/2017 17:56:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
CREATE PROCEDURE [dbo].[ssp_GetDocumentationOfXMLString] @ClientId INT = NULL          
 ,@Type VARCHAR(10) = NULL          
 ,@DocumentVersionId INT = NULL          
 ,@FromDate DATETIME = NULL          
 ,@ToDate DATETIME = NULL         
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT        
 -- =============================================                                     
/*                          
 Author   Added Date   Reason   Task                          
 Gautam   05/09/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation            
*/       
AS        
BEGIN        
 DECLARE @DefaultComponentXML VARCHAR(MAX) =         
    '<documentationOf typeCode="DOC">
		<serviceEvent classCode="PCPR">
			<code code="233604007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Pnuemonia"/>
			<effectiveTime>
				<low value="201208060028+0500"/>
				<high value="201208060058+0500"/>
			</effectiveTime>
			<performer typeCode="PRF">
				<functionCode code="PP" displayName="Primary Care Provider" codeSystem="2.16.840.1.113883.12.443" codeSystemName="Provider Role">
					<originalText>Primary Care Provider</originalText>
				</functionCode>
				<time>
					<low value="201208060028+0500"/>
					<high value="201208060058+0500"/>
				</time>
				<assignedEntity>
					<id extension="PseudoMD-1" root="2.16.840.1.113883.4.6"/>
					<code code="200000000X" displayName="Allopathic and Osteopathic Physicians" codeSystemName="Provider Codes" codeSystem="2.16.840.1.113883.6.101"/>
					<addr>
						<streetAddressLine>1002 Healthcare Dr</streetAddressLine>
						<city>Portland</city>
						<state>OR</state>
						<postalCode>97266</postalCode>
						<country>US</country>
					</addr>
					<telecom value="tel:+1-555-555-5000" use="WP"/>
					<assignedPerson>
						<name>
							<prefix>Dr.</prefix>
							<given>Henry</given>
							<family>Seven</family>
						</name>
					</assignedPerson>
					<representedOrganization>
						<id root="2.16.840.1.113883.19.5.9999.1393"/>
						<name>Get Well Clinic</name>
						<telecom value="tel:+1-555-555-5000" use="WP"/>
						<addr>
							<streetAddressLine>1002 Healthcare Drive </streetAddressLine>
							<city>Portland</city>
							<state>OR</state>
							<postalCode>97266</postalCode>
							<country>US</country>
						</addr>
					</representedOrganization>
				</assignedEntity>
			</performer>
		</serviceEvent>
	</documentationOf>'        
 DECLARE @FinalComponentXML VARCHAR(MAX)        
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<documentationOf typeCode="DOC">      
     ###ServiceEventText###      
     </documentationOf>'        
         
 DECLARE @entryXML VARCHAR(MAX) =    
	 '<serviceEvent classCode="PCPR">
		<code code="##SNOMEDCTCode##" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="##SNOMEDDesc##"/>
		<effectiveTime>
			<low value="##EffectiveDate##"/>
			<high value="##EffectiveDate##"/>
		</effectiveTime>
		<performer typeCode="PRF">
			<functionCode code="PP" displayName="Primary Care Provider" codeSystem="2.16.840.1.113883.12.443" codeSystemName="Provider Role">
				<originalText>Primary Care Provider</originalText>
			</functionCode>
			<time>
				<low value="##EffectiveDate##"/>
				<high value="##EffectiveDate##"/>
			</time>
			<assignedEntity>
				<id extension="PseudoMD-1" root="2.16.840.1.113883.4.6"/>
				<code code="200000000X" displayName="Allopathic and Osteopathic Physicians" codeSystemName="Provider Codes" codeSystem="2.16.840.1.113883.6.101"/>
				<addr>
					<streetAddressLine>##Address##</streetAddressLine>
					<city>##City##</city>
					<state>##State##</state>
					<postalCode>##Zipcode##</postalCode>
					<country>US</country>
				</addr>
				<telecom value="tel:+1-##MainPhone##" use="WP"/>
				<assignedPerson>
					<name>
						<prefix>Dr.</prefix>
						<given>##FirstName##</given>
						<family>##LastName##</family>
					</name>
				</assignedPerson>
				<representedOrganization>
					<id root="2.16.840.1.113883.19.5.9999.1393"/>
					<name>##AgencyName##</name>
					<telecom value="tel:+1-##MainPhone##" use="WP"/>
					<addr>
						<streetAddressLine>##Address##</streetAddressLine>
						<city>##City##</city>
						<state>##State##</state>
						<postalCode>##Zipcode##</postalCode>
						<country>US</country>
					</addr>
				</representedOrganization>
			</assignedEntity>
		</performer>
	</serviceEvent>'   
        
 DECLARE @finalEntry VARCHAR(MAX)        
 SET @finalEntry = ''        
        
 DECLARE @loopCOUNT INT = 0        
 DECLARE @tResults TABLE (        
   ClientId int,      
   ICD9Code varchar(100),      
   ICD10Code varchar(100),      
   SNOMED varchar(20),      
   SNOMEDDesc varchar(max),      
   EffectiveDate datetime,      
   AgencyName varchar(250),      
   Address varchar(100),      
   City varchar(30),      
   State varchar(5),      
   ZipCode varchar(12),      
   LastName varchar(50),      
   FirstName varchar(30),      
   MainPhone varchar(100))      
        
 INSERT INTO @tResults        
  EXEC ssp_GetDocumentationOf @ClientId        
   ,@Type         
   ,@DocumentVersionId         
   ,@FromDate         
   ,@ToDate
       
 DECLARE @SNOMED varchar(20) = ''        
 DECLARE  @SNOMEDDesc varchar(max)= ''       
 DECLARE  @EffectiveDate datetime= ''       
 DECLARE   @AgencyName varchar(250)= ''       
 DECLARE   @Address varchar(100)= ''       
 DECLARE   @City varchar(30)= ''       
 DECLARE   @State varchar(5)= ''       
 DECLARE   @ZipCode varchar(12)= ''       
 DECLARE   @LastName varchar(50)= ''       
 DECLARE  @FirstName varchar(30)= ''       
 DECLARE  @MainPhone varchar(100)= ''      
         
 IF EXISTS (        
   SELECT *        
   FROM @tResults        
   )        
 BEGIN        
  DECLARE tCursor CURSOR FAST_FORWARD        
  FOR        
  SELECT SNOMED,SNOMEDDesc ,EffectiveDate , AgencyName,Address , City,State, ZipCode ,LastName,FirstName, MainPhone      
  FROM @tResults TDS        
        
  OPEN tCursor        
        
  FETCH NEXT        
  FROM tCursor        
  INTO @SNOMED,@SNOMEDDesc ,@EffectiveDate , @AgencyName,@Address , @City,@State, @ZipCode ,@LastName,@FirstName  ,@MainPhone      
        
  WHILE (@@FETCH_STATUS = 0)        
  BEGIN        
   SET @finalEntry = @finalEntry + @entryXML        
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCTCode##', ISNULL(@SNOMED, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDDesc##', ISNULL(@SNOMEDDesc, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##EffectiveDate##', ISNULL(@EffectiveDate, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##Address##', ISNULL(@Address, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##City##', ISNULL(@City, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##State##', ISNULL(@State, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##Zipcode##', ISNULL(@ZipCode, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##FirstName##', ISNULL(@FirstName, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##LastName##', ISNULL(@LastName, 'UNK'))        
   SET @finalEntry = REPLACE(@finalEntry, '##AgencyName##', ISNULL(@AgencyName, 'UNK'))           
   SET @finalEntry = REPLACE(@finalEntry, '##MainPhone##', ISNULL(@MainPhone, 'UNK'))           
   SET @loopCOUNT = @loopCOUNT + 1        
        
   PRINT @finalEntry        
        
   FETCH NEXT        
   FROM tCursor        
   INTO @SNOMED,@SNOMEDDesc ,@EffectiveDate , @AgencyName,@Address , @City,@State, @ZipCode ,@LastName,@FirstName  ,@MainPhone      
  END        
        
  CLOSE tCursor        
        
  DEALLOCATE tCursor       
        
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###ServiceEventText###', @finalEntry)        
  SET @OutputComponentXML = @FinalComponentXML        
 END        
       
END 
GO


