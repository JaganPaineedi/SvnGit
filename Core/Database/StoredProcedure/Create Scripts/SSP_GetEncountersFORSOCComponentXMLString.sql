
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetEncountersFORSOCComponentXMLString]    Script Date: 06/09/2015 00:51:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetEncountersFORSOCComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetEncountersFORSOCComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetEncountersFORSOCComponentXMLString]    Script Date: 06/09/2015 00:51:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
-- =======================================================    
-- Author:  Naveen P    
-- Create Date: Nov 07, 2014    
-- Description: Retrieves CCD Component XML for Encounters    
/*    
 Author          Modified Date           Reason    
 Naveen P        11/04/2014              Initial    
*/    
-- =======================================================    
    
CREATE PROCEDURE [dbo].[ssp_GetEncountersFORSOCComponentXMLString]        
    @ServiceId INT = NULL,      
    @ClientId INT  = NULL,      
    @DocumentVersionId INT = NULL,      
    @OutputComponentXML VARCHAR(MAX) OUTPUT       
AS       
BEGIN      
DECLARE @DefaultComponentXML VARCHAR(MAX)='<component>    
   <section>    
    <templateId root="2.16.840.1.113883.10.20.22.2.22"/>    
    <id root="2.201" extension="Encounters"/>    
    <code code="46240-8" displayName="HISTORY OF ENCOUNTERS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
    <title>Encounter Diagnosis</title>    
    <text>    
     <table border="1" width="100%">    
      <thead>    
       <tr>    
        <th>Encounter</th>    
        <th>Clinician</th>    
        <th>Diagnosis</th>    
        <th>Date</th>    
       </tr>    
      </thead>    
      <tbody><tr><td colspan="4">No Information Available</td></tr></tbody>    
     </table>    
    </text>    
        
   </section>    
  </component>'  
 DECLARE @ComponentXMLTemplate VARCHAR(MAX) =     
  '<component>    
   <section>    
    <templateId root="2.16.840.1.113883.10.20.22.2.22"/>    
    <id root="2.201" extension="Encounters"/>    
    <code code="46240-8" displayName="HISTORY OF ENCOUNTERS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
    <title>Encounter Diagnosis</title>    
    <text>    
     <table border="1" width="100%">    
      <thead>    
       <tr>    
        <th>Encounter</th>    
        <th>Clinician</th>    
        <th>Diagnosis</th>    
        <th>Date</th>    
       </tr>    
      </thead>    
      <tbody>###TBodyRows###</tbody>    
     </table>    
    </text>    
    ###Entries###    
   </section>    
  </component>'    
    
 DECLARE @RowXMLTemplate VARCHAR(MAX) =     
  '<tr>    
   <td>    
    <content ID="Encounter_###Ctr###" xmlns="urn:hl7-org:v3">###Encounter###</content>    
   </td>    
   <td>###Clinician###</td>    
   <td>###Diagnosis###</td>    
   <td>###DateOfService###</td>    
  </tr>'    
    
 DECLARE @EntryXMLTemplate VARCHAR(MAX) =    
  '<entry>    
   <encounter classCode="ENC" moodCode="EVN">    
    <templateId root="2.16.840.1.113883.10.20.22.4.49"/>    
    <id root="2.201" extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c"/>    
    <code nullFlavor="UNK">    
     <originalText>    
      <reference value="#Encounter_###Ctr###"/>    
     </originalText>    
    </code>    
    <text>    
     <reference value="#Encounter_###Ctr###"/>    
    </text>    
    <effectiveTime>    
     <low value="20120806"/>    
     <high value="20120806"/>    
    </effectiveTime>    
    <performer>    
     <assignedEntity classCode="ASSIGNED">    
      <id extension="e163b5c3-83a9-4937-b0e4-ce773eb3f8e4" root="2.201"/>    
      <addr>    
       <streetAddressLine>1002 Healthcare Dr</streetAddressLine>    
       <city>Beaverton</city>    
       <state>OR</state>    
       <postalCode>97005</postalCode>    
       <country nullFlavor="UNK"/>    
      </addr>    
      <telecom use="WP" value="tel:+1-5555551002"/>    
      <assignedPerson>    
       <name>    
        <family>Seven</family>    
        <given>Henry</given>    
        <given>L</given>    
       </name>    
      </assignedPerson>    
      <representedOrganization>    
       <id root="2.201" extension="0001"/>    
       <id root="2.16.840.1.113883.4.6" extension="1234567893"/>    
       <name>NEXTGEN Medical Practice (Horsham)</name>    
       <telecom use="WP" value="tel:+1-2156577010"/>    
       <addr>    
        <streetAddressLine>795 Horsham Road</streetAddressLine>    
        <city>Horsham</city>    
        <state>PA</state>    
        <postalCode>19044</postalCode>    
       </addr>    
   </representedOrganization>    
     </assignedEntity>    
    </performer>    
    <participant typeCode="LOC">    
     <participantRole classCode="SDLOC">    
      <templateId root="2.16.840.1.113883.10.20.22.4.32"/>    
      <id extension="635dc59b-e421-4aeb-9cc8-11c36cf1d6ed" root="2.201"/>    
      <code nullFlavor="UNK"/>    
      <addr>    
       <streetAddressLine>1002 Healthcare Dr</streetAddressLine>    
       <city>Beaverton</city>    
       <state>OR</state>    
       <postalCode>97005</postalCode>    
      </addr>    
      <telecom use="WP" nullFlavor="UNK"/>    
      <playingEntity classCode="PLC">    
       <name>Get Well Clinic</name>    
      </playingEntity>    
     </participantRole>    
    </participant>    
    <entryRelationship typeCode="RSON">    
     <observation classCode="OBS" moodCode="EVN">    
      <templateId root="2.16.840.1.113883.10.20.22.4.19"/>    
      <id nullFlavor="NA"/>    
      <code code="409586006" displayName="Complaint" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>    
      <statusCode code="completed"/>    
      <effectiveTime value="20130125"/>    
      <value nullFlavor="UNK" xsi:type="CD">    
       <originalText>    
        <reference value="#Encounter_###Ctr###"/>    
       </originalText>    
      </value>    
     </observation>    
    </entryRelationship>    
    <entryRelationship typeCode="SUBJ">    
     <act classCode="ACT" moodCode="EVN">    
      <templateId root="2.16.840.1.113883.10.20.22.4.80"/>    
      <code code="29308-4" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" xsi:type="CE"/>    
      <entryRelationship typeCode="SUBJ">    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.4"/>    
        <id nullFlavor="UNK"/>    
        <code code="282291009" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>    
        <statusCode code="completed"/>    
        <effectiveTime>    
         <low value="20130125"/>    
        </effectiveTime>    
        <value nullFlavor="OTH" xsi:type="CD">    
         <translation code="799.02" displayName="Hypoxemia" codeSystem="2.16.840.1.113883.6.103" codeSystemName="ICD-9-CM"/>    
        </value>    
       </observation>    
      </entryRelationship>    
     </act>    
    </entryRelationship>    
    <entryRelationship typeCode="SUBJ">    
     <act classCode="ACT" moodCode="EVN">    
      <templateId root="2.16.840.1.113883.10.20.22.4.80"/>    
      <code code="29308-4" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" xsi:type="CE"/>    
      <entryRelationship typeCode="SUBJ">    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.4"/>    
        <id nullFlavor="UNK"/>    
        <code code="282291009" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>    
        <statusCode code="completed"/>    
        <effectiveTime>    
         <low value="20130125"/>    
        </effectiveTime>    
        <value nullFlavor="OTH" xsi:type="CD">    
         <translation code="486" displayName="Community acquired pneumonia" codeSystem="2.16.840.1.113883.6.103" codeSystemName="ICD-9-CM"/>    
        </value>    
       </observation>    
      </entryRelationship>    
     </act>    
    </entryRelationship>    
    <entryRelationship typeCode="SUBJ">    
     <act classCode="ACT" moodCode="EVN">    
      <templateId root="2.16.840.1.113883.10.20.22.4.80"/>    
      <code code="29308-4" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" xsi:type="CE"/>    
      <entryRelationship typeCode="SUBJ">    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.4"/>    
        <id nullFlavor="UNK"/>    
        <code code="282291009" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>    
        <statusCode code="completed"/>    
        <effectiveTime>    
         <low value="20130125"/>    
        </effectiveTime>    
        <value nullFlavor="OTH" xsi:type="CD">    
         <translation code="493.90" displayName="Asthma" codeSystem="2.16.840.1.113883.6.103" codeSystemName="ICD-9-CM"/>    
        </value>    
       </observation>    
      </entryRelationship>    
     </act>    
    </entryRelationship>    
   </encounter>    
  </entry>'    
    
 CREATE TABLE #EncountersTempTbl (       
  Description varchar(max)    
  ,BillingCodeModifiers varchar(max)    
  ,DateOfService varchar(max)    
  ,Diagnosis varchar(max)    
  ,Clinician varchar(max)    
 )    
    
 IF @ServiceId IS NULL    
 BEGIN    
  INSERT INTO #EncountersTempTbl    
  EXEC ssp_RDLClinicalSummaryProceduresFORSOC NULL    
   ,@ClientId    
   ,@DocumentVersionId    
 END    
 ELSE    
 BEGIN    
  INSERT INTO #EncountersTempTbl     
  EXEC ssp_RDLClinicalSummaryProceduresFORSOC @ServiceId, @ClientId, @DocumentVersionId    
 END    
 IF EXISTS(select * from #EncountersTempTbl)  
 BEGIN    
 DECLARE #EncountersCursor CURSOR FAST_FORWARD    
 FOR    
  SELECT  Description + (Case WHEN BillingCodeModifiers = '' THEN '' ELSE  ', ' + BillingCodeModifiers END) as Encounter,    
    Clinician,    
    Diagnosis,    
    DateOfService    
  FROM    #EncountersTempTbl    
    
 DECLARE @Encounter varchar(max)    
 DECLARE @Clinician varchar(max)    
 DECLARE @Diagnosis varchar(max)    
 DECLARE @DateOfService varchar(max)    
    
 OPEN #EncountersCursor    
 FETCH #EncountersCursor INTO @Encounter, @Clinician, @Diagnosis, @DateOfService    
    
 DECLARE @RowCounter int = 0    
 DECLARE @RowsXML varchar(max) = ''    
 DECLARE @EntriesXML varchar(max) = ''    
     
 WHILE @@fetch_status = 0    
  BEGIN    
   DECLARE @RowXML varchar(max) = @RowXMLTemplate    
   SET @RowXML = Replace(@RowXML, '###Ctr###', @RowCounter)    
   SET @RowXML = Replace(@RowXML, '###Encounter###', LTrim(RTrim(IsNull(@Encounter, ''))))    
   SET @RowXML = Replace(@RowXML, '###Clinician###', LTrim(RTrim(IsNull(@Clinician, ''))))    
   SET @RowXML = Replace(@RowXML, '###Diagnosis###', LTrim(RTrim(IsNull(@Diagnosis, ''))))    
   SET @RowXML = Replace(@RowXML, '###DateOfService###', ISNULL(CONVERT(VARCHAR(12), @DateOfService, 101), '')) 
   
   DECLARE @EntryXML varchar(max) = Replace(@EntryXMLTemplate, '###Ctr###', @RowCounter)    
       
   SET @RowsXML = @RowsXML + @RowXML    
   SET @EntriesXML = @EntriesXML + @EntryXML    
       
   SET @RowCounter = @RowCounter + 1    
   FETCH #EncountersCursor INTO @Encounter, @Clinician, @Diagnosis, @DateOfService    
  END    
    
 CLOSE #EncountersCursor    
 DEALLOCATE #EncountersCursor    
 DROP TABLE #EncountersTempTbl    
    
 DECLARE @ComponentXML VARCHAR(MAX)    
 SET @ComponentXML = Replace(@ComponentXMLTemplate, '###TBodyRows###', @RowsXML)    
 SET @ComponentXML = Replace(@ComponentXML, '###Entries###', @EntriesXML)    
    
 SET @OutputComponentXML =  @ComponentXML     
 END  
 ELSE  
 BEGIN  
 SET @OutputComponentXML =@DefaultComponentXML  
 END    
END 
GO

