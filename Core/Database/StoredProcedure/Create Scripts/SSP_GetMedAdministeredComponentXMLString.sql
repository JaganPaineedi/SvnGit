
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMedAdministeredComponentXMLString]    Script Date: 06/09/2015 00:51:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMedAdministeredComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMedAdministeredComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMedAdministeredComponentXMLString]    Script Date: 06/09/2015 00:51:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================        
-- Author:  Pradeep        
-- Create date: Nov 07, 2014       
-- Description: Retrieves CCD Component XML for Medications Administered   
/*        
 Author   Modified Date   Reason        
 Shankha        11/04/2014              Initial  
        
*/  
CREATE PROCEDURE [dbo].[ssp_GetMedAdministeredComponentXMLString]   
  @ServiceId INT = NULL  
 ,@ClientId INT = NULL  
 ,@DocumentVersionId INT = NULL  
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT  
AS  
BEGIN  
DECLARE @DefaultComponentXML VARCHAR(MAX)=' <component>
        <section>
          <templateId root="2.16.840.1.113883.10.20.22.2.38"/>
          <id root="2.201" extension="CcdaMedicationsAdministered"/>
          <code code="29549-3" displayName="MEDICATION ADMINISTERED" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
          <title>Medications Administered</title>
          <text>
            <table border="1" width="100%">
              <thead>
                <tr>
                  <th>Drug Name</th>
                  <th>Dose</th>
                  <th>Strength</th>
                  <th>Comments</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan="4">
                    <content ID="MedicationsAdministeredName_0" xmlns="urn:hl7-org:v3">No Information available</content>
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
						<reference value="#MedicationsAdministeredName_0"></reference>
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
 DECLARE @COMPONENTXML VARCHAR(MAX) = '<component>  
 <section>  
  <templateId root="2.16.840.1.113883.10.20.22.2.38"/>  
  <id root="2.201" extension="CcdaMedicationsAdministered"/>  
  <code code="29549-3" displayName="MEDICATION ADMINISTERED" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
  <title>Medications Administered</title>  
  <text>  
   <table border="1" width="100%">  
    <thead>  
     <tr>  
      <th>Drug Name</th>  
      <th>Dose</th>  
      <th>Strength</th>  
      <th>Comments</th>  
     </tr>  
    </thead>  
    <tbody>###tr###</tbody>  
   </table>  
  </text>  
  ###ENTRY###  
 </section>  
</component>'  
 DECLARE @TRXML VARCHAR(MAX) = ''  
 DECLARE @ENTRYXML VARCHAR(MAX) = ''  
 DECLARE @ENTRYXMLTEMPLATE VARCHAR(MAX) = '<entry typeCode="DRIV">  
   <substanceAdministration classCode="SBADM" moodCode="INT">  
    <templateId root="2.16.840.1.113883.10.20.22.4.16"/>  
    <id root="b2111894-1eed-4b94-b7f2-01b4fbe93284"/>  
    <text>  
     <!--<reference value="#MedicationsAdministeredSig_###ID###"/>-->  
    </text>  
    <statusCode code="completed"/>  
    <effectiveTime xsi:type="IVL_TS">  
     <low value="###MEDICATIONADMINISTEREDDATE###"/>  
     <high value="###MEDICATIONADMINISTEREDDATE###"/>  
    </effectiveTime>  
    <doseQuantity nullFlavor="UNK"/>  
    <administrationUnitCode nullFlavor="UNK"/>  
    <consumable>  
     <manufacturedProduct classCode="MANU">  
      <templateId root="2.16.840.1.113883.10.20.22.4.23"/>  
      <manufacturedMaterial>  
       <code code="##RxNormCode##" displayName="###DRUGNAME###" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm">  
        <originalText>  
         <reference value="#MedicationsAdministeredName_###ID###"/>  
        </originalText>  
        <translation code="54868564600" displayName="###DRUGNAME###" codeSystem="2.16.840.1.113883.6.69" codeSystemName="NDC"/>  
       </code>  
       <name>###DRUGNAME###</name>  
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
        <family>Security</family>  
        <given>Admin</given>  
       </name>  
      </assignedPerson>  
      <representedOrganization>  
       <id root="2.201" extension="0001"/>  
       <id root="2.16.840.1.113883.4.6" extension="1234567893"/>  
       <name>Get Well Clinic</name>  
       <telecom use="WP" value="tel:+1-6302342233"/>  
       <addr>  
        <streetAddressLine>1002 Healthcare Dr.</streetAddressLine>  
        <city>Portland</city>  
        <state>Oreagon</state>  
        <postalCode>97005</postalCode>  
       </addr>  
      </representedOrganization>  
     </assignedEntity>  
    </informant>  
    <entryRelationship typeCode="SUBJ">  
     <act classCode="ACT" moodCode="EVN">  
      <templateId root="2.16.840.1.113883.10.20.1.40"/>  
      <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>  
      <code code="48767-8" displayName="ANNOTATION COMMENT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
      <text>  
       <reference value="#MedicationsAdministeredComment_###ID###"/>  
      </text>  
      <statusCode code="completed"/>  
     </act>  
    </entryRelationship>  
    <entryRelationship typeCode="REFR">  
     <act classCode="ACT" moodCode="EVN">  
      <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/>  
      <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>  
      <code nullFlavor="UNK"/>  
     </act>  
    </entryRelationship>  
   </substanceAdministration>  
  </entry>'  
 DECLARE @tResults TABLE (  
 CCDDrugName VARCHAR(max),  
 CCDDrugDose VARCHAR(max),  
 CCDDrugStrength VARCHAR(max),  
 CCDDrugComment VARCHAR(max),  
 CCDCreatedDate DATETIME  
 )  
  
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryMedicationAdministrated NULL  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
    ELSE  
    BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryMedicationAdministrated @ServiceId  
   ,@ClientId  
   ,@DocumentVersionId  
    END  
   
 DECLARE @tDrugName VARCHAR(MAX)  
 DECLARE @tDrugDose VARCHAR(MAX)  
 DECLARE @tDrugStrength VARCHAR(MAX)  
 DECLARE @tDrugComment VARCHAR(MAX)  
 DECLARE @tDrugCreatedDate DATETIME  
 DECLARE @loopCOUNT INT = 0  
  IF EXISTS(select * from @tResults)
  BEGIN
 DECLARE tCursor CURSOR FAST_FORWARD  
 FOR  
 SELECT CCDDrugName,  
     CCDDrugDose,  
     CCDDrugStrength,  
     CCDDrugComment,  
     CCDCreatedDate  
 FROM @tResults TDS  
  
 OPEN tCursor  
  
 FETCH NEXT  
 FROM tCursor  
 INTO @tDrugName,  
   @tDrugDose,  
   @tDrugStrength,  
   @tDrugComment,  
   @tDrugCreatedDate  
  
 WHILE (@@FETCH_STATUS = 0)  
 BEGIN  
  SET @TRXML = @TRXML + '<tr>'  
  SET @TRXML = @TRXML + '<td><content ID="MedicationsAdministeredName_'+ Convert(varchar(2), @loopCOUNT) + '" xmlns="urn:hl7-org:v3">' + isnull(@tDrugName,'') + '</content></td>'  
  SET @TRXML = @TRXML + '<td><content ID="MedicationsAdministeredDose_'+ Convert(varchar(2), @loopCOUNT)+ '" xmlns="urn:hl7-org:v3">' + isnull(@tDrugDose,'') + '</content></td>'  
  SET @TRXML = @TRXML + '<td><content ID="MedicationsAdministeredStrenth_'+ Convert(varchar(2), @loopCOUNT) + '" xmlns="urn:hl7-org:v3">' + isnull(@tDrugStrength,'') + '</content></td>'  
  SET @TRXML = @TRXML + '<td><content ID="MedicationsAdministeredComment_'+ Convert(varchar(2), @loopCOUNT) + '" xmlns="urn:hl7-org:v3">' + isnull(@tDrugComment,'') + '</content></td>'  
  SET @TRXML = @TRXML + '</tr>'  
    
  SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###DRUGNAME###', @tDrugName) 
  IF(@tDrugName='Abilify')
    SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###RxNormCode###', '352307') 
  IF(@tDrugName='Adderall')
    SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###RxNormCode###', '1170620') 
  IF(@tDrugName='Buspar')
    SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###RxNormCode###', '1827') 
  IF(@tDrugName='Citalopram')
    SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###RxNormCode###', '2556') 
  IF(@tDrugName='Adderall XR')
    SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###RxNormCode###', '861224') 
  IF(@tDrugName='Albuterol Sulfate')
    SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###RxNormCode###', '836286') 

  SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###MEDICATIONADMINISTEREDDATE###', ISNULL(CONVERT(VARCHAR(25), @tDrugCreatedDate, 112), ''))  
  SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###ID###', @loopCOUNT)  
      
  SET @ENTRYXML = @ENTRYXML + @ENTRYXMLTEMPLATE  
    
  SET @loopCOUNT = @loopCOUNT + 1  
    
  FETCH NEXT  
  FROM tCursor  
  INTO @tDrugName,  
    @tDrugDose,  
    @tDrugStrength,  
    @tDrugComment,  
    @tDrugCreatedDate  
 END  
  
 CLOSE tCursor  
 DEALLOCATE tCursor  
   
 SET @COMPONENTXML = REPLACE(@COMPONENTXML , '###tr###', @TRXML)  
 SET @COMPONENTXML = REPLACE(@COMPONENTXML , '###ENTRY###', @ENTRYXML)  
   
 SET @OutputComponentXML =  @COMPONENTXML 
 END
 ELSE
	BEGIN
	SET @OutputComponentXML =@DefaultComponentXML
	END 
END  


GO

