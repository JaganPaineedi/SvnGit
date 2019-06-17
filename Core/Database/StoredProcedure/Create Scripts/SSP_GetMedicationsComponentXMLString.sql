
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMedicationsComponentXMLString]    Script Date: 06/09/2015 00:52:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMedicationsComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMedicationsComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMedicationsComponentXMLString]    Script Date: 06/09/2015 00:52:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
-- =============================================                
-- Author:  Pradeep                
-- Create date: Nov 07, 2014               
-- Description: Retrieves CCD Component XML for History of Present Illness             
/*                
 Author   Modified Date   Reason                
 Shankha        11/04/2014              Initial          
                
*/  
CREATE PROCEDURE [dbo].[ssp_GetMedicationsComponentXMLString] @ServiceId INT = NULL  
 ,@ClientId INT = NULL  
 ,@DocumentVersionId INT = NULL  
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT  
AS  
BEGIN  
 DECLARE @DefaultComponentXML VARCHAR(MAX) =   
  '<component>    
        <section>    
          <templateId root="2.16.840.1.113883.10.20.22.2.1.1"/>    
          <id root="2.201" extension="Medications"/>    
          <code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
          <title>Medications</title>    
          <text>    
            <table border="1" width="100%">    
              <thead>    
                <tr>    
                  <th>Medication</th>    
                  <th>Instructions</th>    
                  <th>Dosage</th>    
                  <th>Effective Dates</th>    
                  <th>Status</th>    
                  <th>Comments</th>    
                </tr>    
              </thead>    
              <tbody>    
                <tr>    
                  <td>    
                    <content ID="MedicationName_0" xmlns="urn:hl7-org:v3">No Information Available</content>    
                  </td>    
                  <td>    
                    <content ID="MedicationSig_0" xmlns="urn:hl7-org:v3"></content>    
                  </td>    
                  <td>    
                    <content ID="MedicationDosage_0" xmlns="urn:hl7-org:v3"></content>    
                  </td>    
                  <td></td>    
                  <td></td>    
                  <td>    
                    <content ID="MedicationComment_0" xmlns="urn:hl7-org:v3"></content>    
                  </td>    
                </tr>                    
              </tbody>    
            </table>    
          </text>    
          <entry typeCode="DRIV" contextConductionInd="true">  
    <substanceAdministration classCode="SBADM" moodCode="EVN">  
     <templateId root="2.16.840.1.113883.10.20.22.4.16"></templateId>  
     <id nullFlavor="NI"></id>  
     <text>  
      <reference value="#MedicationName_0"></reference>  
     </text>  
     <statusCode code="completed"></statusCode>  
     <effectiveTime xsi:type="IVL_TS" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">  
      <low value="20140212130114"></low>  
      <high nullFlavor="UNK"></high>  
     </effectiveTime>  
     <consumable typeCode="CSM">  
      <manufacturedProduct classCode="MANU">  
       <templateId root="2.16.840.1.113883.10.20.22.4.23"></templateId>  
       <manufacturedMaterial classCode="MMAT" determinerCode="KIND">  
        <code nullFlavor="UNK">  
         <originalText>No medication data is applicable</originalText>  
        </code>  
       </manufacturedMaterial>  
      </manufacturedProduct>  
     </consumable>  
    </substanceAdministration>  
   </entry>            
        </section>    
      </component>'  
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>          
    <section>          
     <templateId root="2.16.840.1.113883.10.20.22.2.1.1"/>          
     <id root="2.201" extension="Medications"/>          
     <code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>          
     <title>Medications</title>          
     <text>          
      <table border="1" width="100%">          
       <thead>          
        <tr>          
         <th>Medication</th>          
         <th>Instructions</th>          
         <th>Dosage</th>          
         <th>Effective Dates</th>          
         <th>Status</th>          
   <th>Comments</th>          
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
         <td>          
          <content ID="MedicationName_##ID##" xmlns="urn:hl7-org:v3">##MedName##</content>          
         </td>          
         <td>          
          <content ID="MedicationSig_##ID##" xmlns="urn:hl7-org:v3">##Strength##</content>          
         </td>          
         <td>          
          <content ID="MedicationDosage_##ID##" xmlns="urn:hl7-org:v3">##Quantity##</content>          
         </td>          
         <td>##StartDate##</td>          
         <td>##Status##</td>          
         <td>          
          <content ID="MedicationComment_##ID##" xmlns="urn:hl7-org:v3">##Inst##</content>          
         </td>          
        </tr>'  
 DECLARE @finalTR VARCHAR(MAX)  
  
 SET @finalTR = ''  
 --<routeCode code="###ROUTECODE###" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI Thesaurus" displayName="###ROUTEDISPLAY###"/>  
 -- place before doseQuantity 
 DECLARE @entryXML VARCHAR(MAX) =   
  '<entry typeCode="DRIV">          
      <substanceAdministration classCode="SBADM" moodCode="INT">          
       <templateId root="2.16.840.1.113883.10.20.22.4.16"/>          
       <id root="d71fb70d-2667-4059-9f13-ed333992e426"/>          
       <text>          
        <reference value="#MedicationSig_##ID##"/>  
        ##Inst##          
       </text>          
       <statusCode code="active"/>          
       <effectiveTime xsi:type="IVL_TS">          
        <low value="##StartDate##"/>          
        <high value="##EndDate##"/>          
       </effectiveTime>          
       <effectiveTime institutionSpecified="true" operator="A" xsi:type="PIVL_TS">          
        <period value="##PERIOD##" unit="h"/>          
       </effectiveTime>          
       <doseQuantity value="##Quantity##" unit="##UNIT##"/>          
       <administrationUnitCode nullFlavor="UNK"/>          
       <consumable>          
        <manufacturedProduct classCode="MANU">          
         <templateId root="2.16.840.1.113883.10.20.22.4.23"/>          
         <manufacturedMaterial>          
          <code code="##RxNormCode##" displayName="##MedName##" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm">          
           <originalText>##SCHEDULE##<reference value="#MedicationName_##ID##"/>          
           </originalText>          
           </code>          
          <name>##MedName##</name>          
         </manufacturedMaterial>          
        </manufacturedProduct>          
       </consumable>  
    <informant>  
            <assignedEntity>  
              <id root="2.16.840.1.113883.4.6" extension="1104152198"/>  
              <addr>  
                <streetAddressLine>1002 Healthcare Dr</streetAddressLine>  
                <city>Beaverton</city>  
                <state>OR</state>  
                <postalCode>97005</postalCode>  
              </addr>  
              <telecom use="WP" value="tel:+1-5555551009"/>  
              <telecom use="PG" value="tel:+1-6158686465"/>  
              <telecom use="WP" value="fax:+1-Getwell"/>  
              <telecom value="mailto:admin@getwellclinic.com"/>  
              <assignedPerson>  
                <name>  
                  <prefix>Dr.</prefix>  
                  <family>##FIRSTNAME##</family>  
                  <given>##LASTNAME##</given>  
                </name>  
              </assignedPerson>  
              <representedOrganization>  
                <id root="2.201" extension="0001"/>  
                <id root="2.16.840.1.113883.4.6" extension="1234567893"/>  
                <name>Get Well Clinic</name>  
                <telecom use="WP" value="tel:+1-2156577010"/>  
                <addr>  
                  <streetAddressLine>1002 Healthcare Dr</streetAddressLine>  
                  <city>Portland</city>  
                  <state>OR</state>  
                  <postalCode>97005</postalCode>  
                </addr>  
              </representedOrganization>  
            </assignedEntity>  
          </informant>                
       </substanceAdministration>          
     </entry>'  
 DECLARE @finalEntry VARCHAR(MAX)  
  
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [MedicationName] VARCHAR(max)  
  ,[PrescriberName] VARCHAR(max)  
  ,[SOURCE] VARCHAR(100)  
  ,[LastOrdered] DATETIME  
  ,[MedicationStartDate] DATETIME  
  ,[MedicationEndDate] DATETIME  
  ,[Script] VARCHAR(100)  
  ,[Instructions] VARCHAR(max)  
  ,[MedicationStatus] VARCHAR(100)  
  ,[Quantity] DECIMAL  
  ,[Strength] VARCHAR(100)  
  ,[StrengthId] INT  
  ,[NormCode] INT  
  ,PrescriberId INT  
  ,Unit VARCHAR(255)  
  ,Schedule VARCHAR(255)  
  )  
 /* 
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryCurrentMedication NULL  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 ELSE  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryCurrentMedication @ServiceId  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
  */
 DECLARE @tMedName VARCHAR(MAX)  
 DECLARE @tStrength VARCHAR(MAX)  
 DECLARE @tQuantity VARCHAR(100)  
 DECLARE @tStartDate DATETIME  
 DECLARE @tEndDate DATETIME  
 DECLARE @tStatus VARCHAR(100)  
 DECLARE @tInstructions VARCHAR(100)  
 DECLARE @tNormCode VARCHAR(100)  
 DECLARE @tRoute VARCHAR(100)  
 DECLARE @tFirstName VARCHAR(100)  
 DECLARE @tLastName VARCHAR(100)  
 DECLARE @tUnit VARCHAR(255)  
 DECLARE @tSchedule VARCHAR(255)  
  
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [MedicationName]  
   ,TDS.[Strength]  
   ,[Quantity]  
   ,[MedicationStartDate]  
   ,[MedicationEndDate]  
   ,[MedicationStatus]  
   ,[Instructions]  
   ,[NormCode]  
   ,MR.RouteDescription AS [Route]  
   ,S.FIRSTNAME  
   ,S.LASTNAME  
   ,[Unit]  
   ,[Schedule]  
  FROM @tResults TDS  
  INNER JOIN MDMedications MD ON (  
    MD.MedicationID = TDS.StrengthId  
    AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'  
    )  
  INNER JOIN MDRoutes MR ON (  
    MD.RouteID = MR.RouteID  
    AND ISNULL(MR.RecordDeleted, 'N') <> 'Y'  
    )  
  INNER JOIN STAFF S ON (  
    S.STAFFID = TDS.PrescriberId  
    AND ISNULL(S.RecordDeleted, 'N') <> 'Y'  
    )  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tMedName  
   ,@tStrength  
   ,@tQuantity  
   ,@tStartDate  
   ,@tEndDate  
   ,@tStatus  
   ,@tInstructions  
   ,@tNormCode  
   ,@tRoute  
   ,@tFirstName  
   ,@tLastName  
   ,@tUnit  
   ,@tSchedule  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTR = @finalTR + @trXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)  
   SET @finalTR = REPLACE(@finalTR, '##MedName##', isNULL(@tMedName, ''))  
   SET @finalTR = REPLACE(@finalTR, '##Strength##', isNULL(@tStrength, ''))  
   SET @finalTR = REPLACE(@finalTR, '##Quantity##', isNULL(@tQuantity, ''))  
   SET @finalTR = REPLACE(@finalTR, '##StartDate##', ISNULL(CONVERT(VARCHAR(12), @tStartDate, 107), ''))  
   SET @finalTR = REPLACE(@finalTR, '##Status##', isNULL(@tStatus, ''))  
   SET @finalTR = REPLACE(@finalTR, '##Inst##', isNULL(@tInstructions, ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##RxNormCode##', @tNormCode)  
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)  
   SET @finalEntry = REPLACE(@finalEntry, '##MedName##', isNULL(@tMedName, ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##StartDate##', isNULL(replace(replace(replace(CONVERT(VARCHAR(19), @tStartDate, 126), '-', ''), 'T', ''), ':', ''), ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##EndDate##', isNULL(replace(replace(replace(CONVERT(VARCHAR(19), @tEndDate, 126), '-', ''), 'T', ''), ':', ''), ''))  
   SET @finalEntry = REPLACE(@finalEntry, '###ROUTEDISPLAY###', isNULL(@tRoute, ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##Inst##', isNULL(@tInstructions, ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##FIRSTNAME##', isNULL(@tFirstName, ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##LASTNAME##', isNULL(@tLastName, ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##Quantity##', isNULL(@tQuantity, ''))  
   SET @finalEntry = REPLACE(@finalEntry, '##UNIT##', isNULL(LTRIM(RTRIM(@tUnit)), 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##SCHEDULE##', isNULL(LTRIM(RTRIM(@tSchedule)), 'UNK'))  
  
   IF @tInstructions LIKE '%4 times daily%'  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '##PERIOD##', '6')  
   END  
   ELSE IF @tInstructions LIKE '%each Daily%'  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '##PERIOD##', '24')  
   END  
   ELSE IF @tInstructions LIKE '%every 12 hours%'  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '##PERIOD##', '12')  
   END  
   ELSE  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '##PERIOD##', '24')  
   END  
  
   IF @tRoute = 'Oral'  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '###ROUTECODE###', 'C38288')  
   END  
   ELSE IF @tRoute = 'Intravenous'  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '###ROUTECODE###', 'C38276')  
   END  
   ELSE IF @tRoute = 'Inhalation'  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '###ROUTECODE###', 'C38216')  
   END 
   ELSE IF @tRoute = 'Subcutaneous'  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '###ROUTECODE###', 'C49226')  
   END   
   ELSE  
   BEGIN  
    SET @finalEntry = REPLACE(@finalEntry, '###ROUTECODE###', '')  
   END  
  
   SET @loopCOUNT = @loopCOUNT + 1  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tMedName  
    ,@tStrength  
    ,@tQuantity  
    ,@tStartDate  
    ,@tEndDate  
    ,@tStatus  
    ,@tInstructions  
    ,@tNormCode  
    ,@tRoute  
    ,@tFirstName  
    ,@tLastName  
   ,@tUnit  
   ,@tSchedule  
  
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

