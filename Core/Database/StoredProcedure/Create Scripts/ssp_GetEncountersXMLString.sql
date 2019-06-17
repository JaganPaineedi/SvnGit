/****** Object:  StoredProcedure [dbo].[ssp_GetEncountersXMLString]    Script Date: 09/22/2017 17:59:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetEncountersXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetEncountersXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetEncountersXMLString]    Script Date: 09/22/2017 17:59:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_GetEncountersXMLString] @ClientId INT = NULL      
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
 DECLARE @DefaultComponentXML VARCHAR(MAX) =     
	  '<component>
		<section nullFlavor="NI">
			<!-- *** Encounters section (entries required) (V3) *** -->
			<templateId root="2.16.840.1.113883.10.20.22.2.22.1" extension="2015-08-01"/>
			<templateId root="2.16.840.1.113883.10.20.22.2.22.1"/>
			<code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of encounters"/>
			<title>ENCOUNTERS</title>
			<text>No Encounters</text>
		</section>
	</component>'    
 DECLARE @FinalComponentXML VARCHAR(MAX)    
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>
		<section>
			<templateId root="2.16.840.1.113883.10.20.22.2.22.1"/>
			<!-- Encounters Section - required entries -->
			<code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of encounters"/>
			<title>ENCOUNTERS</title>
			<text>
				<table border="1" width="100%">
					<thead>
						<tr>
							<th>Encounter</th>
							<th>Performer</th>
							<th>Location</th>
							<th>Date</th>
						</tr>
					</thead>
					<tbody>
						###TRSECTION###
					</tbody>
				</table>
			</text>
			###ENTRYSECTION###
		</section>
	</component>'    
 DECLARE @trXML VARCHAR(MAX) = '<tr>    
                           <td> <content ID="Encounter_##ID##"/> ##SNOMEDCTDescription##</td>    
                           <td>Dr ##FirstName## ##LastName##</td>    
                           <td>##AgencyName##</td>    
                           <td>##Date##</td>    
                        </tr>'    
 DECLARE @finalTR VARCHAR(MAX)    
 SET @finalTR = ''    
    
 DECLARE @entryXML VARCHAR(MAX) =     
  '<entry typeCode="DRIV">
	<encounter classCode="ENC" moodCode="EVN">
		<templateId root="2.16.840.1.113883.10.20.22.4.49"/>
		<!-- Encounter Activities -->
		<!--  ********  Encounter activity template   ******** -->
		<id root="2a620155-9d11-439e-92b3-5d9815ff4de8"/>
		<code code="99212" displayName="Outpatient Visit" codeSystemName="CPT" codeSystem="2.16.840.1.113883.6.12" codeSystemVersion="4">
			<originalText>
				Outpatient Visit<reference value="#Encounter_##ID##"/>
			</originalText>
		</code>
		<effectiveTime value="##Date##"/>
		<performer>
			<assignedEntity>
				<id root="2a620155-9d11-439e-92a3-5d9815ff4de8"/>
				<code code="59058001" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="General Physician"/>
			</assignedEntity>
		</performer>
		<participant typeCode="LOC">
			<participantRole classCode="SDLOC">
				<templateId root="2.16.840.1.113883.10.20.22.4.32"/>
				<!-- Service Delivery Location template -->
				<code code="##LocationCode##" codeSystem="2.16.840.1.113883.6.259" codeSystemName="HealthcareServiceLocation" displayName="##LocationName##"/>
				<addr>
					<streetAddressLine>##Address##</streetAddressLine>
					<city>##City##</city>
					<state>##State##</state>
					<postalCode>##ZipCode##</postalCode>
					<country>US</country>
				</addr>
				<telecom nullFlavor="UNK"/>
				<playingEntity classCode="PLC">
					<name>##AgencyName##</name>
				</playingEntity>
			</participantRole>
		</participant>
		<entryRelationship typeCode="RSON">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.22.4.19"/>
				<id root="db734647-fc99-424c-a864-7e3cda82e703" extension="45665"/>
				<code code="404684003" displayName="Finding" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
				<statusCode code="completed"/>
				<effectiveTime>
					<low value="##Date##"/>
				</effectiveTime>
				<value xsi:type="CD" code="##SNOMEDCTCode##" displayName="##SNOMEDCTDescription##" codeSystem="2.16.840.1.113883.6.96"/>
			</observation>
		</entryRelationship>
		<entryRelationship typeCode="SUBJ" inversionInd="false">
			<act classCode="ACT" moodCode="EVN">
				<!--Encounter diagnosis act -->
				<templateId root="2.16.840.1.113883.10.20.22.4.80"/>
				<id root="5a784260-6856-4f38-9638-80c751aff2fb"/>
				<code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS"/>
				<statusCode code="active"/>
				<effectiveTime>
					<low value="##Date##"/>
				</effectiveTime>
				<entryRelationship typeCode="SUBJ" inversionInd="false">
					<observation classCode="OBS" moodCode="EVN" negationInd="false">
						<templateId root="2.16.840.1.113883.10.20.22.4.4"/>
						<!-- Problem Observation -->
						<id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
						<code code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
						<statusCode code="completed"/>
						<effectiveTime>
							<low value="##Date##"/>
						</effectiveTime>
						<value xsi:type="CD" code="##SNOMEDCTCode##" codeSystem="2.16.840.1.113883.6.96" displayName="##SNOMEDCTDescription##"/>
					</observation>
				</entryRelationship>
			</act>
		</entryRelationship>
	</encounter>
</entry>'    
 DECLARE @finalEntry VARCHAR(MAX)    
 SET @finalEntry = ''    
    
 DECLARE @loopCOUNT INT = 0    
 DECLARE @tResults TABLE (    
  [ClientId] INT    
  ,[Date] DATETIME    
  ,[SNOMEDCTCode] VARCHAR(25)    
  ,[SNOMEDCTDescription] VARCHAR(max)    
  ,[FirstName] varchar(20)     
  ,[LastName] varchar(30)    
  ,[AgencyName] varchar(250)    
  ,[Address]varchar(100)    
  ,[City] varchar(30)    
  ,[State] varchar(2)    
  ,[ZipCode] varchar(12)    
  ,[LocationCode] varchar(30)    
  ,[LocationName] varchar(100)    
  --,[LOINCCode] varchar(25)    
  --,[CodeName] varchar(250)    
  )    
    
 INSERT INTO @tResults    
  EXEC ssp_GetMostRecentEncounters NULL    
   ,@Type     
   ,@DocumentVersionId     
   ,@FromDate     
   ,@ToDate    
   ,NULL    
    
 DECLARE @tDate VARCHAR(100) = ''    
 DECLARE @tSNOMEDCTCode VARCHAR(25) = ''    
 DECLARE @tSNOMEDCTDescription VARCHAR(max) = ''    
 DECLARE @tFirstName varchar(20) = ''    
 DECLARE @tLastName varchar(30) = ''     
 DECLARE @tAgencyName varchar(250) = ''    
 DECLARE @tAddress varchar(100) = ''    
 DECLARE @tCity varchar(30) = ''    
 DECLARE @tState varchar(2) = ''    
 DECLARE @tZipCode varchar(12) = ''    
 DECLARE @tLocationCode varchar(30) = ''    
 DECLARE @tLocationName varchar(100) = ''    
--DECLARE @tLOINCCode varchar(25) = ''    
 --DECLARE @tCodeName varchar(250) = ''    
       
 IF EXISTS (    
   SELECT *    
   FROM @tResults    
   )    
 BEGIN    
  DECLARE tCursor CURSOR FAST_FORWARD    
  FOR    
  SELECT [Date]    
   ,[SNOMEDCTCode]    
   ,[SNOMEDCTDescription]    
   ,[FirstName]    
   ,[LastName]    
   ,[AgencyName]    
   ,[Address]    
   ,[City]     
   ,[State]     
   ,[ZipCode]    
   ,[LocationCode]    
   ,[LocationName]     
   --,[LOINCCode]    
   --,[CodeName]    
  FROM @tResults TDS    
    
  OPEN tCursor    
    
  FETCH NEXT    
  FROM tCursor    
  INTO @tDate    
   ,@tSNOMEDCTCode    
   ,@tSNOMEDCTDescription    
   ,@tFirstName    
   ,@tLastName    
   ,@tAgencyName    
   ,@tAddress    
   ,@tCity    
   ,@tState    
   ,@tZipCode    
   ,@tLocationCode    
   ,@tLocationName    
   --,@tLOINCCode    
   --,@tCodeName      
    
  WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
   SET @finalTR = @finalTR + @trXML    
   SET @finalEntry = @finalEntry + @entryXML    
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)    
   SET @finalTR = REPLACE(@finalTR, '##SNOMEDCTDescription##', ISNULL(@tSNOMEDCTDescription, 'UNK'))    
   SET @finalTR = REPLACE(@finalTR, '##FirstName##', ISNULL(@tFirstName, 'UNK'))    
   SET @finalTR = REPLACE(@finalTR, '##LastName##', ISNULL(@tLastName, 'UNK'))    
   SET @finalTR = REPLACE(@finalTR, '##Date##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))
   SET @finalTR = REPLACE(@finalTR, '##AgencyName##', ISNULL(@tAgencyName, 'UNK'))     
          
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)    
   SET @finalEntry = REPLACE(@finalEntry, '##Date##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))    
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCTCode##', ISNULL(@tSNOMEDCTCode, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCTDescription##', ISNULL(@tSNOMEDCTDescription, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##FirstName##', ISNULL(@tFirstName, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##LastName##', ISNULL(@tLastName, 'UNK'))       
   SET @finalEntry = REPLACE(@finalEntry, '##AgencyName##', ISNULL(@tAgencyName, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##Address##', ISNULL(@tAddress, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##City##', ISNULL(@tCity, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##State##', ISNULL(@tState, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##ZipCode##', ISNULL(@tZipCode, 'UNK'))       
   SET @finalEntry = REPLACE(@finalEntry, '##LocationCode##', ISNULL(@tLocationCode, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##LocationName##', ISNULL(@tLocationName, 'UNK'))    
     
       
   SET @loopCOUNT = @loopCOUNT + 1    
    
   PRINT @finalTR    
   PRINT @finalEntry    
    
   FETCH NEXT    
   FROM tCursor    
   INTO @tDate    
    ,@tSNOMEDCTCode    
    ,@tSNOMEDCTDescription    
    ,@tFirstName    
    ,@tLastName    
    ,@tAgencyName    
    ,@tAddress    
    ,@tCity    
    ,@tState    
    ,@tZipCode    
    ,@tLocationCode    
    ,@tLocationName    
    --,@tLOINCCode    
    --,@tCodeName    
  END    
    
  CLOSE tCursor    
    
  DEALLOCATE tCursor    
    
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###TRSECTION###', @finalTR)    
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @finalEntry)    
  SET @OutputComponentXML = @FinalComponentXML    
 END    
 ELSE    
 BEGIN    
  SET @OutputComponentXML = @DefaultComponentXML    
 END    
   
END    
GO


