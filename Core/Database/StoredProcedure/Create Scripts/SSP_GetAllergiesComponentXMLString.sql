
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAllergiesComponentXMLString]    Script Date: 06/09/2015 00:49:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllergiesComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAllergiesComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAllergiesComponentXMLString]    Script Date: 06/09/2015 00:49:42 ******/
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
CREATE PROCEDURE [dbo].[ssp_GetAllergiesComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @DefaultComponentXML VARCHAR(MAX) = 
		'<component>    
        <section>    
          <templateId root="2.16.840.1.113883.10.20.22.2.6"/>    
          <templateId root="2.16.840.1.113883.10.20.22.2.6.1"/>    
          <id root="2.201" extension="Alerts"/>    
          <code code="48765-2" displayName="ALLERGIES, ADVERSE REACTIONS, ALERTS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
          <title>Allergies, Adverse Reactions, Alerts</title>    
          <text>    
            <table border="1" width="100%">    
              <thead>    
                <tr>    
                  <th>Substance</th>    
                  <th>Reaction</th>    
                  <th>Severity</th>    
                  <th>Status</th>    
                </tr>    
              </thead>    
              <tbody>    
                <tr>    
                  <td>    
                    <content ID="AllergyDescription_0" xmlns="urn:hl7-org:v3">No Information Available</content>    
                  </td>    
                  <td>    
                    <content ID="AllergyReaction_0" xmlns="urn:hl7-org:v3"></content>    
                  </td>    
                  <td></td>    
                  <td>    
                    <content ID="AllergyStatus_0" xmlns="urn:hl7-org:v3"></content>    
                  </td>    
                </tr>    
              </tbody>    
            </table>    
          </text>    
    <entry typeCode="DRIV">  
   <act classCode="ACT" moodCode="EVN">  
     <templateId root="2.16.840.1.113883.10.20.22.4.30"></templateId>  
     <id root="1.3.6.1.4.1.16517" extension="1"></id>  
     <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts"></code>  
     <statusCode code="active"></statusCode>  
     <effectiveTime>  
    <low nullFlavor="UNK"/>  
     </effectiveTime>  
     <entryRelationship typeCode="SUBJ">  
    <observation nullFlavor="NASK" classCode="OBS" moodCode="EVN">  
      <templateId root="2.16.840.1.113883.10.20.22.4.7"></templateId>  
      <id root="1.3.6.1.4.1.16517" extension="1"></id>  
      <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode"></code>  
      <statusCode code="completed"></statusCode>  
      <effectiveTime>  
     <low nullFlavor="UNK"/>  
      </effectiveTime>  
      <value xsi:type="CD" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" nullFlavor="UNK"></value>  
    </observation>      
     </entryRelationship>  
   </act>  
    </entry>  
        </section>    
      </component>'
	DECLARE @FinalComponentXML VARCHAR(MAX)
	DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>          
 <section>          
  <templateId root="2.16.840.1.113883.10.20.22.2.6"/>          
  <templateId root="2.16.840.1.113883.10.20.22.2.6.1"/>          
  <id root="2.201" extension="Alerts"/>          
  <code code="48765-2" displayName="ALLERGIES, ADVERSE REACTIONS, ALERTS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>          
  <title>Allergies, Adverse Reactions, Alerts</title>          
  <text>          
   <table border="1" width="100%">          
    <thead>          
     <tr>          
      <th>Description</th>          
      <th>Comments</th>          
      <th>RxNorm</th>          
      <th>Status</th>          
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
          <content ID="AllergyDescription_##ID##" xmlns="urn:hl7-org:v3">##Desc##</content>          
         </td>          
         <td>          
          <content ID="AllergyReaction_##ID##" xmlns="urn:hl7-org:v3">##Comments##</content>          
         </td>          
         <td>##RXNORMCODE##</td>          
         <td>##STATUS##</td>          
        </tr>'
	DECLARE @finalTR VARCHAR(MAX)

	SET @finalTR = ''

	DECLARE @entryXML VARCHAR(MAX) = 
		'<entry typeCode="DRIV">          
      <act classCode="ACT" moodCode="EVN">          
       <templateId root="2.16.840.1.113883.10.20.22.4.30"/>          
       <id root="69724b9d-5e77-402f-a5b6-3379dde3e8a9"/>          
       <code code="48765-2" displayName="ALLERGIES, ADVERSE REACTIONS, ALERTS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>          
       <statusCode code="active"/>          
       <effectiveTime>          
        <low value="##DATE##"/>          
       </effectiveTime>          
       <entryRelationship typeCode="SUBJ">          
        <observation classCode="OBS" moodCode="EVN">          
         <templateId root="2.16.840.1.113883.10.20.22.4.7"/>          
         <id root="69724b9d-5e77-402f-a5b6-3379dde3e8a9"/>          
         <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>          
         <statusCode code="completed"/>          
         <effectiveTime>          
          <low value="##DATE##"/>          
         </effectiveTime>          
         <value code="416098002" displayName="drug allergy" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" xsi:type="CD"/>          
         <participant typeCode="CSM">          
          <participantRole classCode="MANU">          
           <playingEntity classCode="MMAT">          
            <code code="##RxNormCode##" displayName="##Desc##" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm">          
             <originalText>          
              <reference value="#AllergyDescription_##ID##"/>          
             </originalText>  
             </code>          
            <name>##Desc##</name>          
           </playingEntity>          
          </participantRole>          
         </participant>          
         <entryRelationship typeCode="MFST" inversionInd="true">          
          <observation classCode="OBS" moodCode="EVN">          
           <templateId root="2.16.840.1.113883.10.20.22.4.9"/>          
           <id root="69724b9d-5e77-402f-a5b6-3379dde3e8a9"/>          
           <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>          
           <text>          
            <reference value="#AllergyReaction_##ID##"/>          
           </text>          
           <statusCode code="completed"/>          
           <effectiveTime>          
            <low value="##DATE##"/>          
           </effectiveTime>          
           <value xsi:type="CD" nullFlavor="UNK">          
            <originalText>          
             <reference value="#AllergyReaction_##ID##"/>##Comments##          
            </originalText>          
           </value>          
          </observation>          
         </entryRelationship>                          
        </observation>          
       </entryRelationship>          
      </act>          
     </entry>'
	DECLARE @finalEntry VARCHAR(MAX)

	SET @finalEntry = ''

	DECLARE @loopCOUNT INT = 0
	DECLARE @tResults TABLE (
		[Description] VARCHAR(max)
		,[Comments] VARCHAR(max)
		,[Allergy] VARCHAR(100)
		,[Status] VARCHAR(100)
		,[SNOMEDCode] INT
		,[Date] DATETIME
		,[NormCode] INT
		,[NationalDrugCode] VARCHAR(100)
		,[DisplayTable] INT
		)

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryAllergies NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryAllergies @ServiceId
			,@ClientId
			,@DocumentVersionId
	END

	DECLARE @tDescription VARCHAR(MAX) = ''
	DECLARE @tComments VARCHAR(MAX) = ''
	DECLARE @tStatus VARCHAR(100) = ''
	DECLARE @RxNormCode VARCHAR(100) = ''
	DECLARE @tDate VARCHAR(100) = ''

	IF EXISTS (
			SELECT *
			FROM @tResults
			)
	BEGIN
		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT [Description]
			,[Comments]
			,[Status]
			,[NormCode]
			,[Date]
		FROM @tResults TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @tDescription
			,@tComments
			,@tStatus
			,@RxNormCode
			,@tDate

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @finalTR = @finalTR + @trXML
			SET @finalEntry = @finalEntry + @entryXML
			SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)
			SET @finalTR = REPLACE(@finalTR, '##Desc##', ISNULL(@tDescription, 'UNK'))
			SET @finalTR = REPLACE(@finalTR, '##Comments##', ISNULL(@tComments, 'UNK'))
			SET @finalTR = REPLACE(@finalTR, '##RXNORMCODE##', ISNULL(@RxNormCode, 'UNK'))
			
			IF ISNULL(@RxNormCode, '') <> ''
			BEGIN
				IF @RxNormCode = '2002'
					SET @finalTR = REPLACE(@finalTR, '##STATUS##', 'INACTIVE')
				ELSE
					SET @finalTR = REPLACE(@finalTR, '##STATUS##', 'ACTIVE')
			END	
						
			SET @finalEntry = REPLACE(@finalEntry, '##RxNormCode##', ISNULL(@RxNormCode, 'UNK'))
			SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)
			SET @finalEntry = REPLACE(@finalEntry, '##Desc##', ISNULL(@tDescription, 'UNK'))
			SET @finalEntry = REPLACE(@finalEntry, '##RXNORMCODE##', ISNULL(@RxNormCode, 'UNK'))
			SET @finalEntry = REPLACE(@finalEntry, '##DATE##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))
			SET @finalEntry = REPLACE(@finalEntry, '##Comments##', ISNULL(@tComments, 'UNK'))
			SET @loopCOUNT = @loopCOUNT + 1

			PRINT @finalTR
			PRINT @finalEntry

			FETCH NEXT
			FROM tCursor
			INTO @tDescription
				,@tComments
				,@tStatus
				,@RxNormCode
				,@tDate
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

