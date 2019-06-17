
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetProceduresComponentXMLString]    Script Date: 06/09/2015 00:52:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetProceduresComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetProceduresComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetProceduresComponentXMLString]    Script Date: 06/09/2015 00:52:33 ******/
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
CREATE PROCEDURE [dbo].[ssp_GetProceduresComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @DefaultComponentXML VARCHAR(MAX) = 
		'<component>
        <section>
          <templateId root="2.16.840.1.113883.10.20.22.2.7.1"/>
          <id root="2.201" extension="Procedures"/>
          <code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
          <title>Procedures</title>
          <text>
            <table border="1" width="100%">
              <thead>
                <tr>
                  <th>Procedure</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan="2">
                    <content ID="ProcedureDescription_0" xmlns="urn:hl7-org:v3">No Information Available</content>
                  </td>                  
                </tr>
              </tbody>
            </table>
          </text>
          <entry>
				<procedure classCode="PROC" moodCode="EVN" negationInd="true">
					<templateId root="2.16.840.1.113883.10.20.22.4.14"/>
					<id extension="1898101" root="1.3.6.1.4.1.22812.3.99930.3.4.7"/>
					<code nullFlavor="UNK"/>
					<statusCode code="active"/>
					<effectiveTime>
						<low nullFlavor="UNK"/>
					</effectiveTime>
				</procedure>
		  </entry>
        </section>
      </component>'
	DECLARE @FinalComponentXML VARCHAR(MAX)
	DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>  
    <section>  
     <templateId root="2.16.840.1.113883.10.20.22.2.7.1"/>  
     <id root="2.201" extension="Procedures"/>  
     <code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
     <title>Procedures</title>  
     <text>  
      <table border="1" width="100%">  
       <thead>  
        <tr>  
         <th>Procedure</th>  
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
         <td>  
          <content ID="ProcedureDescription_##ID##" xmlns="urn:hl7-org:v3">##ProcDesc##</content>  
         </td>  
         <td>##ProcDate##</td>  
        </tr>'
	DECLARE @finalTR VARCHAR(MAX)

	SET @finalTR = ''

	DECLARE @entryXML VARCHAR(MAX) = '<entry typeCode="DRIV">  
      <procedure classCode="PROC" moodCode="EVN">  
       <templateId root="2.16.840.1.113883.10.20.22.4.14"/>  
       <id root="2.201" extension="8e4b2fcb-13e8-4ce6-8737-61c3c9c328ec"/>  
       <code code="##SNOMEDCODE##" codeSystem="2.16.840.1.113883.6.96" displayName="##ProcDesc##" codeSystemName="SNOMED-CT">
        <originalText>  
         <reference value="#ProcedureDescription_##ID##"/>  
        </originalText>          
       </code>  
       <statusCode code="completed"/>  
       <effectiveTime>  
        <low value="##ProcDate##"/>  
        <high value="##ProcDate##"/>  
       </effectiveTime>  
       <entryRelationship typeCode="COMP" inversionInd="true">  
        <encounter classCode="ENC" moodCode="EVN">  
         <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>  
         <code nullFlavor="UNK"/>  
        </encounter>  
       </entryRelationship>  
      </procedure>  
     </entry>'
	DECLARE @finalEntry VARCHAR(MAX)

	SET @finalEntry = ''

	DECLARE @loopCOUNT INT = 0
	DECLARE @tResults TABLE (
		[BillingCodeModifiers] VARCHAR(100)
		,[ServiceDate] DATETIME
		,[Description] VARCHAR(max)
		)

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLSummaryOfCareProcedures NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLSummaryOfCareProcedures @ServiceId
			,@ClientId
			,@DocumentVersionId
	END

	DECLARE @tProcDesc VARCHAR(MAX)
	DECLARE @tProcDate DATETIME
	DECLARE @BillingCodeModifiers VARCHAR(MAX)

	IF EXISTS (
			SELECT *
			FROM @tResults
			)
	BEGIN
		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT [Description]
			,[ServiceDate]
			,BillingCodeModifiers
		FROM @tResults TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @tProcDesc
			,@tProcDate
			,@BillingCodeModifiers

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			PRINT @tProcDate
			SET @finalTR = @finalTR + @trXML
			SET @finalEntry = @finalEntry + @entryXML
			SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)
			SET @finalTR = REPLACE(@finalTR, '##ProcDesc##', @tProcDesc)
			SET @finalTR = REPLACE(@finalTR, '##ProcDate##', CONVERT(VARCHAR(12), @tProcDate, 107))
			SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)
			SET @finalEntry = REPLACE(@finalEntry, '##ProcDesc##', @tProcDesc)
			SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCODE##', @BillingCodeModifiers)
			SET @finalEntry = REPLACE(@finalEntry, '##ProcDate##', CONVERT(VARCHAR(12), @tProcDate, 112))
			
			SET @loopCOUNT = @loopCOUNT + 1

			FETCH NEXT
			FROM tCursor
			INTO @tProcDesc
				,@tProcDate
				,@BillingCodeModifiers
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

