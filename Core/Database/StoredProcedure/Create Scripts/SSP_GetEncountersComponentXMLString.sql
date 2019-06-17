
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetEncountersComponentXMLString]    Script Date: 06/09/2015 00:51:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetEncountersComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetEncountersComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetEncountersComponentXMLString]    Script Date: 06/09/2015 00:51:00 ******/
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
    
CREATE PROCEDURE [dbo].[ssp_GetEncountersComponentXMLString]        
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
    <title>Encounters</title>    
    <text>    
     <table border="1" width="100%">    
      <thead>    
       <tr>    
        <th>Encounter</th>    
        <th>Location</th>    
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
    <title>Encounters</title>    
    <text>    
     <table border="1" width="100%">    
      <thead>    
       <tr>    
        <th>Encounter</th>    
        <th>Location</th>    
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
   <td>###Diagnosis###</td>    
   <td>###Location###</td>    
   <td>###DateOfService###</td>    
  </tr>'    
    
 DECLARE @EntryXMLTemplate VARCHAR(MAX) =    
  '<entry>    
   <encounter classCode="ENC" moodCode="EVN">    
    <templateId root="2.16.840.1.113883.10.20.22.4.49"/>    
    <id root="2.201" extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c"/>    
    <code nullFlavor="UNK">    
     <originalText>    
      <reference value="#Encounter_###Ctr###"/> ###Encounter###   
     </originalText>    
    </code>    
    <text>    
     ###Diagnosis###   
    </text>    
    <effectiveTime>    
     <low value="###DateOfService###"/>    
     <high value="###DateOfService###"/>    
    </effectiveTime>    
    <entryRelationship typeCode="RSON">    
     <observation classCode="OBS" moodCode="EVN">    
      <templateId root="2.16.840.1.113883.10.20.22.4.19"/>    
      <id nullFlavor="NA"/>    
      <code code="###SNOMEDCODE###" displayName="Finding" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>    
      <statusCode code="completed"/>    
      <effectiveTime value="###DateOfService###"/>    
      <value xsi:type="CD" code="###SNOMEDCODE###" displayName="###SNOMEDDESC###" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>            
     </observation>    
    </entryRelationship>
    <entryRelationship typeCode="SUBJ" inversionInd="false">
        <act classCode="ACT" moodCode="EVN">                           
           <templateId root="2.16.840.1.113883.10.20.22.4.80"/>                           
           <id root="5a784260-6856-4f38-9638-80c751aff2fb"/>
           <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1"  codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS"/>
           <statusCode code="active"/>
           <effectiveTime>
              <low value="###DateOfService###"/>
           </effectiveTime>
           <entryRelationship typeCode="SUBJ" inversionInd="false">
              <observation classCode="OBS" moodCode="EVN" negationInd="false">
                 <templateId root="2.16.840.1.113883.10.20.22.4.4"/>
                 <id root="ab1791b0-5c71-11db-b0de-0800200c9a66"/>
                 <code code="409586006" codeSystem="2.16.840.1.113883.6.96" displayName="Complaint"/>
                 <statusCode code="completed"/>
                 <effectiveTime>
                    <low value="###DateOfService###"/>
                 </effectiveTime>
                 <value xsi:type="CD" code="###SNOMEDCODE###" displayName="###SNOMEDDESC###" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
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
  ,Location varchar(max)
  ,SNOMEDCTCode VARCHAR(MAX)
  ,SNOMEDCTDescription VARCHAR(MAX)      
 )    
  
/*  
 IF @ServiceId IS NULL    
 BEGIN    
  INSERT INTO #EncountersTempTbl    
  EXEC ssp_RDLClinicalSummaryProcedures NULL    
   ,@ClientId    
   ,@DocumentVersionId    
 END    
 ELSE    
 BEGIN    
  INSERT INTO #EncountersTempTbl     
  EXEC ssp_RDLClinicalSummaryProcedures @ServiceId, @ClientId, @DocumentVersionId    
 END  
 */
 
 IF EXISTS(select * from #EncountersTempTbl)  
 BEGIN    
 DECLARE #EncountersCursor CURSOR FAST_FORWARD    
 FOR    
  SELECT  [Description] as Encounter,    
    Diagnosis,    
    Location,    
    DateOfService,
    SNOMEDCTCode,
    SNOMEDCTDescription    
  FROM    #EncountersTempTbl    
    
 DECLARE @Encounter varchar(max)    
 DECLARE @Diagnosis varchar(max)    
 DECLARE @Location varchar(max)    
 DECLARE @DateOfService varchar(max)    
 DECLARE @SNOMEDCODE varchar(max)
 DECLARE @SNOMEDDESC VARCHAR(MAX)
    
 OPEN #EncountersCursor    
 FETCH #EncountersCursor INTO @Encounter, @Diagnosis, @Location, @DateOfService, @SNOMEDCODE , @SNOMEDDESC   
    
 DECLARE @RowCounter int = 0    
 DECLARE @RowsXML varchar(max) = ''    
 DECLARE @EntriesXML varchar(max) = ''    
     
 WHILE @@fetch_status = 0    
  BEGIN    
   DECLARE @RowXML varchar(max) = @RowXMLTemplate    
   SET @RowXML = Replace(@RowXML, '###Ctr###', @RowCounter)    
   SET @RowXML = Replace(@RowXML, '###Encounter###', LTrim(RTrim(IsNull(@Encounter, ''))))    
   SET @RowXML = Replace(@RowXML, '###Diagnosis###', LTrim(RTrim(IsNull(@Diagnosis, ''))))    
   SET @RowXML = Replace(@RowXML, '###Location###', LTrim(RTrim(IsNull(@Location, ''))))    
   SET @RowXML = Replace(@RowXML, '###DateOfService###', LTrim(RTrim(IsNull(@DateOfService, ''))))    
       
   DECLARE @EntryXML varchar(max) = Replace(@EntryXMLTemplate, '###Ctr###', @RowCounter)    
       
   SET @EntryXML = Replace(@EntryXML, '###DateOfService###', convert(varchar(max),convert(datetime, @DateOfService),112))    
   SET @EntryXML = Replace(@EntryXML, '###Diagnosis###', LTrim(RTrim(IsNull(@Diagnosis, ''))))  
   
   SET @SNOMEDCODE = ISNULL(@SNOMEDCODE,'UNK')  
   IF @SNOMEDCODE = '' SET @SNOMEDCODE = 'UNK'
   
   SET @SNOMEDDESC = ISNULL(@SNOMEDDESC,'UNK')  
   IF @SNOMEDDESC = '' SET @SNOMEDDESC = 'UNK'
     
   SET @EntryXML = Replace(@EntryXML, '###SNOMEDCODE###', LTrim(RTrim(IsNull(@SNOMEDCODE,'UNK'))))    
   SET @EntryXML = Replace(@EntryXML, '###SNOMEDDESC###', LTrim(RTrim(IsNull(@SNOMEDDESC,'UNK'))))    
   SET @EntryXML = Replace(@EntryXML, '###Encounter###', LTrim(RTrim(IsNull(@Encounter, ''))))     
       
   SET @RowsXML = @RowsXML + @RowXML    
   SET @EntriesXML = @EntriesXML + @EntryXML    
       
   SET @RowCounter = @RowCounter + 1    
   FETCH #EncountersCursor INTO @Encounter, @Diagnosis, @Location, @DateOfService, @SNOMEDCODE , @SNOMEDDESC
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

