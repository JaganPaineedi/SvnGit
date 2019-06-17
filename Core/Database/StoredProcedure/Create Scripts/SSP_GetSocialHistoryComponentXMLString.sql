
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSocialHistoryComponentXMLString]    Script Date: 06/09/2015 00:53:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSocialHistoryComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSocialHistoryComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSocialHistoryComponentXMLString]    Script Date: 06/09/2015 00:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
-- =============================================        
-- Author:  Pradeep        
-- Create date: Nov 07, 2014       
-- Description: Retrieves CCD Component XML for Social Smoking Status  
/*        
 Author   Modified Date   Reason        
 Shankha        11/04/2014              Initial  
        
*/  
CREATE PROCEDURE [dbo].[ssp_GetSocialHistoryComponentXMLString]   
  @ServiceId INT = NULL  
 ,@ClientId INT = NULL  
 ,@DocumentVersionId INT = NULL  
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT  
AS  
BEGIN  
DECLARE @DefaultComponentXML VARCHAR(MAX)='<component>
        <section>
          <templateId root="2.16.840.1.113883.10.20.22.2.17"/>
          <id root="2.201" extension="SocialHistory"/>
          <code code="29762-2" displayName="SOCIAL HISTORY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
          <title>Social History</title>
          <text>
            <table border="1" width="100%">
              <thead>
                <tr>
                  <th>Description</th>
                  <th>Quantity</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan="3">
                    <content ID="SocialHistorySmoking_0" xmlns="urn:hl7-org:v3">No Information Available</content>
                  </td>                  
                </tr>
              </tbody>
            </table>
          </text>
          <entry>
            <observation classCode="OBS" moodCode="EVN">
              <templateId root="2.16.840.1.113883.10.20.22.4.78"/>
              <code code="ASSERTION" displayName="Assertion" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode" />
              <text>
                <reference value="#SocialHistorySmoking_0"/>
              </text>
              <statusCode code="completed"/>
              <effectiveTime>
                <low nullFlavor="UNK" />
              </effectiveTime>
              <value code="266927001" displayName="Unknown if ever smoked" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" xsi:type="CD" />
            </observation>
          </entry>
        </section>
      </component>
'
 DECLARE @COMPONENTXML VARCHAR(MAX) = '<component>    
   <section>    
    <templateId root="2.16.840.1.113883.10.20.22.2.17"/>    
    <id root="2.201" extension="SocialHistory"/>    
    <code code="29762-2" displayName="SOCIAL HISTORY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
    <title>Social History</title>    
    <text>    
     <table border="1" width="100%">    
      <thead>    
       <tr>    
        <th>Description</th>    
        <th>Quantity</th>  
        <th>Date</th>  
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
 DECLARE @ENTRYXMLTEMPLATE VARCHAR(MAX) = '<entry>    
   <observation classCode="OBS" moodCode="EVN">    
    <templateId root="2.16.840.1.113883.10.20.22.4.78"/>    
    <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>    
    <text>    
     <reference value="#SocialHistorySmoking_###ID###"/>    
    </text>    
    <statusCode code="completed"/>    
    <effectiveTime>    
     <low value="###SMOKINGSTATUSDATE###"/>    
    </effectiveTime>    
    <value code="###SNOMEDCODE###" displayName="###SMOKINGSTATUS###" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" xsi:type="CD"/>    
   </observation>    
  </entry>'  
    
 DECLARE @tResults TABLE (  
 SmokingStatus VARCHAR(max),  
 SmokingDate DATETIME,  
 SNOMEDCODE VARCHAR(max)  
 )  
   
 IF @ServiceId IS NULL  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummarySmoking NULL  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
 ELSE  
 BEGIN  
  INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummarySmoking @ServiceId  
   ,@ClientId  
   ,@DocumentVersionId  
 END  
   
 DECLARE @tSmokingStatus VARCHAR(MAX)  
 DECLARE @tSmokingDate DATETIME  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @SNOMEDCODE VARCHAR(MAX)
 
 IF EXISTS(select * from @tResults)
 BEGIN
 DECLARE tCursor CURSOR FAST_FORWARD  
 FOR  
 SELECT SmokingStatus,  
     SmokingDate,
     SNOMEDCODE   
 FROM @tResults TDS  
  
 OPEN tCursor  
  
 FETCH NEXT  
 FROM tCursor  
 INTO @tSmokingStatus,  
   @tSmokingDate,
   @SNOMEDCODE  
     
 WHILE (@@FETCH_STATUS = 0)  
 BEGIN  
  SET @TRXML = @TRXML + '<tr>'  
  SET @TRXML = @TRXML + '<td><content ID="SocialHistorySmoking_'+ Convert(varchar(2), @loopCOUNT) + '" xmlns="urn:hl7-org:v3">Smoking Status</content></td>'  
  SET @TRXML = @TRXML + '<td>' + isnull(@tSmokingStatus,'') + '</td>'  
  SET @TRXML = @TRXML + '<td>' + ISNULL(CONVERT(VARCHAR(12), @tSmokingDate, 107), '') + '</td>'   
  SET @TRXML = @TRXML + '</tr>'  
    
  SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###SMOKINGSTATUS###', isNull(@tSmokingStatus,''))    
  SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###SMOKINGSTATUSDATE###', ISNULL(CONVERT(VARCHAR(12), @tSmokingDate, 112), ''))  
  SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###ID###', @loopCOUNT)  
  SET @ENTRYXMLTEMPLATE =  REPLACE(@ENTRYXMLTEMPLATE, '###SNOMEDCODE###', @SNOMEDCODE)  
  
      
  SET @ENTRYXML = @ENTRYXML + @ENTRYXMLTEMPLATE  
    
  SET @loopCOUNT = @loopCOUNT + 1  
    
  FETCH NEXT  
  FROM tCursor  
  INTO @tSmokingStatus,  
    @tSmokingDate,
    @SNOMEDCODE    
  
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

