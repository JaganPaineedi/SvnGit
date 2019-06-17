
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetImmunizationsComponentXMLString]    Script Date: 06/09/2015 00:51:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetImmunizationsComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetImmunizationsComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetImmunizationsComponentXMLString]    Script Date: 06/09/2015 00:51:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
-- =============================================          
-- Author:  Chethan N          
-- Create date: Nov 10, 2014         
-- Description: Retrieves CCD Component XML for History of Present Illness       
/*          
 Author   Modified Date   Reason          
 Chethan N        11/10/2014              Initial    
          
*/    
CREATE PROCEDURE [dbo].[ssp_GetImmunizationsComponentXMLString] @ServiceId INT = NULL    
 ,@ClientId INT = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT     
AS    
BEGIN    
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @DEFAULTCOMPONENTXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX)   
 
 SET @DEFAULTCOMPONENTXML='<component>
        <section>
          <templateId root="2.16.840.1.113883.10.20.22.2.2.1"/>
          <id root="2.201" extension="Immunizations"/>
          <code code="11369-6" displayName="HISTORY OF IMMUNIZATIONS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
          <title>Immunizations</title>
          <text>
            <table border="1" width="100%">
              <thead>
                <tr>
                  <th>Vaccine</th>
                  <th>Date</th>
                  <th>Status</th>
                  <th>Comments</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>
                    <content ID="Immunization_0" xmlns="urn:hl7-org:v3">No Information Available</content>
                  </td>
                  <td></td>
                  <td></td>
                  <td>
                    <content ID="ImmunizationComments_0" xmlns="urn:hl7-org:v3"></content>
                  </td>
                </tr>
              </tbody>
            </table>
          </text>
          <entry>
				<substanceAdministration moodCode="EVN" classCode="SBADM" negationInd="true">
					<!-- Immunization Activity entry template -->
					<templateId root="2.16.840.1.113883.10.20.22.4.52"/>
					<id nullFlavor="NI"/>
					<statusCode code="completed"/>
					<effectiveTime  nullFlavor="NI"/>
					<consumable>
						<manufacturedProduct classCode="MANU">
							<!-- Immunization Medication Information template -->
							<templateId root="2.16.840.1.113883.10.20.22.4.54"/>
							<manufacturedMaterial>
								<code nullFlavor="NI">
									<originalText>
										<reference value="#immunization1"/>
									</originalText>
								</code>
							</manufacturedMaterial>
						</manufacturedProduct>
					</consumable>
				</substanceAdministration>
			</entry>
        </section>
      </component>' 
    
 SET @PLACEHOLDERXML = '<component><section><templateId root="2.16.840.1.113883.10.20.22.2.2.1"/>    
 <id root="2.201" extension="Immunizations"/>    
 <code code="11369-6" displayName="HISTORY OF IMMUNIZATIONS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
 <title>Immunizations</title><text><table border="1" width="100%"><thead><tr><th>Vaccine</th><th>Date</th><th>Status</th>    
 <th>Comments</th></tr></thead><tbody>###TRSECTION###</tbody></table></text>###ENTRYSECTION###</section></component>'    
    
 DECLARE @TRXML VARCHAR(max)    
    
 SET @TRXML = '<tr><td><content ID="Immunization_#XXX#" xmlns="urn:hl7-org:v3">###VACCINE###</content></td>    
 <td>###AdministratedDateTime###</td><td>###STATUS###</td><td>    
 <content ID="ImmunizationComments_#XXX#" xmlns="urn:hl7-org:v3">###Commets###</content></td></tr>'    
    
 DECLARE @ENTRYSECTIONXML VARCHAR(max)    
    
 SET @ENTRYSECTIONXML ='<entry typeCode="DRIV"><substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="false">    
 <templateId root="2.16.840.1.113883.10.20.22.4.52"/><id root="45d0cab8-881c-43e5-84e6-450a16fed1b7"/>    
 <code code="IMMUNIZ" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode"/><text>    
 <reference value="#Immunization_#XXX#"/></text><statusCode code="completed"/><effectiveTime value="20120806"/>    
 <doseQuantity nullFlavor="UNK"/><consumable typeCode="CSM"><manufacturedProduct classCode="MANU">    
 <templateId root="2.16.840.1.113883.10.20.22.4.54"/><manufacturedMaterial>    
 <code code="###CVXCODE###" displayName="###VACCINE###" codeSystem="2.16.840.1.113883.12.292" codeSystemName="CVX">    
 <originalText><reference value="#Immunization_#XXX#"/></originalText></code><lotNumberText>90390</lotNumberText>    
 </manufacturedMaterial><manufacturerOrganization classCode="ORG"><name>###Manufacture###</name></manufacturerOrganization>    
 </manufacturedProduct></consumable><performer><assignedEntity>    
 <id root="2.401" extension="f3fdfa1a-6d4b-4ecd-889b-fe6e7798425e"/><addr nullFlavor="UNK"/><telecom nullFlavor="UNK"/>    
 <assignedPerson><name><family>Security</family><given>Admin</given></name></assignedPerson></assignedEntity></performer>    
 <entryRelationship typeCode="SUBJ"><observation classCode="OBS" moodCode="EVN">    
 <templateId root="2.16.840.1.113883.10.20.1.46"/>    
 <code code="30973-2" displayName="DOSE NUMBER" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
 <statusCode code="completed"/><value xsi:type="INT" value="999"/></observation></entryRelationship>    
 <entryRelationship typeCode="SUBJ"><act classCode="ACT" moodCode="EVN"><templateId root="2.16.840.1.113883.10.20.1.40"/>    
 <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>    
 <code code="48767-8" displayName="ANNOTATION COMMENT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/><text>    
 <reference value="#ImmunizationComments_#XXX#"/></text><statusCode code="completed"/></act></entryRelationship>    
 <entryRelationship typeCode="REFR"><observation classCode="OBS" moodCode="EVN">    
 <templateId root="2.16.840.1.113883.10.20.1.47"/>    
 <code code="33999-4" displayName="STATUS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
 <statusCode code="completed"/>    
 <value code="39252100" displayName="Prior History" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" xsi:type="CE"/>    
 </observation></entryRelationship><entryRelationship typeCode="REFR"><act classCode="ACT" moodCode="EVN">    
 <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/><id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>    
 <code nullFlavor="UNK"/></act></entryRelationship></substanceAdministration></entry>'    
    
 DECLARE @FINALTRXML VARCHAR(max)    
    
 SET @FINALTRXML = ''    
    
 DECLARE @FINALENTRYSECTIONXML VARCHAR(max)    
    
 SET @FINALENTRYSECTIONXML = ''    
    
 DECLARE @tvaccine VARCHAR(MAX)    
 DECLARE @tAdministratedDateTime VARCHAR(max)    
 DECLARE @tStatus VARCHAR(max)    
 DECLARE @tCommets VARCHAR(max)    
 DECLARE @tManufacture VARCHAR(max)    
 DECLARE @tCVXCode VARCHAR(20)    
 DECLARE @loopcount int    
 SET @loopcount=0    
 
    
 CREATE TABLE #TempImmunization (    
  vaccine VARCHAR(max)    
  ,AdministratedDateTime VARCHAR(max)    
  ,AdministeredAmount VARCHAR(max)    
  ,Manufacture VARCHAR(max)    
  ,STATUS VARCHAR(max)    
  ,Comment VARCHAR(max)
  ,CVXCode VARCHAR(20)    
  )    
    
  
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO #TempImmunization    
  EXEC ssp_RDLClinicalSummaryImmunization NULL    
   ,@ClientId    
   ,@DocumentVersionId    
 END  
 ELSE  
 BEGIN  
     INSERT INTO #TempImmunization    
  EXEC ssp_RDLClinicalSummaryImmunization @ServiceId    
   ,@ClientId    
   ,@DocumentVersionId    
 END   
 
 IF EXISTS(SELECT * FROM #TempImmunization)
 BEGIN   
 DECLARE tCursor CURSOR FAST_FORWARD    
 FOR    
 SELECT vaccine    
  ,AdministratedDateTime    
  ,Comment    
  ,STATUS    
  ,Manufacture
  ,CVXCOde    
 FROM #TempImmunization TI    
    
 OPEN tCursor    
    
 FETCH NEXT    
 FROM tCursor    
 INTO @tvaccine    
  ,@tAdministratedDateTime    
  ,@tCommets    
  ,@tStatus    
  ,@tManufacture
  ,@tCVXCode    
    
 WHILE (@@FETCH_STATUS = 0)    
 BEGIN 
 print  @tCVXCode  
  SET @FINALTRXML = @FINALTRXML + @TRXML    
  SET @FINALTRXML = REPLACE(@FINALTRXML, '#XXX#', @loopcount)    
  SET @FINALTRXML = REPLACE(@FINALTRXML, '###VACCINE###', @tvaccine)    
  SET @FINALTRXML = REPLACE(@FINALTRXML, '###AdministratedDateTime###', @tAdministratedDateTime)    
  SET @FINALTRXML = REPLACE(@FINALTRXML, '###Commets###', @tCommets)    
  SET @FINALTRXML = REPLACE(@FINALTRXML, '###STATUS###', @tStatus)    
  SET @FINALENTRYSECTIONXML = @FINALENTRYSECTIONXML + @ENTRYSECTIONXML    
  SET @FINALENTRYSECTIONXML = REPLACE(@FINALENTRYSECTIONXML, '#XXX#', @loopcount)    
  SET @FINALENTRYSECTIONXML = REPLACE(@FINALENTRYSECTIONXML, '###VACCINE###', @tvaccine)    
  SET @FINALENTRYSECTIONXML = REPLACE(@FINALENTRYSECTIONXML, '###Manufacture###', @tManufacture)    
  SET @FINALENTRYSECTIONXML = REPLACE(@FINALENTRYSECTIONXML, '###CVXCODE###', @tCVXCode)    
  SET @loopcount=@loopcount+1    
  FETCH NEXT    
  FROM tCursor    
  INTO @tvaccine    
   ,@tAdministratedDateTime    
   ,@tCommets    
   ,@tStatus    
   ,@tManufacture
   ,@tCVXCode    
 END  
 
 CLOSE tCursor    
    
 DEALLOCATE tCursor    
    
 SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###TRSECTION###', @FINALTRXML)    
 SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @FINALENTRYSECTIONXML)    
    
 SET @OutputComponentXML =  @FinalComponentXML 
 --SELECT @FinalComponentXML   
 END 
 ELSE
 BEGIN
 SET @OutputComponentXML=@DEFAULTCOMPONENTXML
 --SELECT @DEFAULTCOMPONENTXML
 END
END 
GO

