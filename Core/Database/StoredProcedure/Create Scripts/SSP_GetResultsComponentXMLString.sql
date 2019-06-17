
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetResultsComponentXMLString]    Script Date: 06/09/2015 00:53:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetResultsComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetResultsComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetResultsComponentXMLString]    Script Date: 06/09/2015 00:53:01 ******/
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
CREATE PROCEDURE [dbo].[ssp_GetResultsComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @DefaultComponentXML VARCHAR(MAX) = 
		' <component>  
        <section>  
          <templateId root="2.16.840.1.113883.10.20.22.2.3.1"/>  
          <id root="2.201" extension="Results"/>  
          <code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <title>Results</title>  
          <text>  
            <table border="1" width="100%">  
              <thead>  
                <tr>  
                  <th>Test Name</th>  
                  <th>Date and Time</th>  
                  <th>Element</th>  
                  <th>Result</th>  
                  <th>LOINC/SNOMED</th>  
                  <th>Flag</th>  
                </tr>  
              </thead>  
              <tbody>  
                <tr>  
                  <td colspan="6">  
                    <content ID="ResultDescription_0" xmlns="urn:hl7-org:v3">No Information Available</content>  
                  </td>  
                </tr>  
               </tbody>  
            </table>  
          </text>  
          <entry typeCode="DRIV">  
            <organizer classCode="BATTERY" moodCode="EVN">  
              <templateId root="2.16.840.1.113883.10.20.22.4.1"/>  
              <id nullFlavor="UNK"/>  
              <code nullFlavor="UNK"/>  
              <statusCode code="completed"/>  
              <effectiveTime nullFlavor="UNK"/>  
              <component>  
                <observation classCode="OBS" moodCode="EVN">  
                  <templateId root="2.16.840.1.113883.10.20.22.4.2"/>  
                  <id nullFlavor="UNK"/>  
                  <code code="UNK" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
                  <text>  
                    <reference value="#ResultDescription_0"/>  
                  </text>  
                  <statusCode code="completed"/>  
                  <effectiveTime nullFlavor="UNK"/>  
                  <value xsi:type="PQ" nullFlavor="UNK" unit="UNK"/>  
                </observation>  
              </component>  
            </organizer>  
          </entry></section>  
      </component>'
	DECLARE @FinalComponentXML VARCHAR(MAX)
	DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>    
    <section>    
     <templateId root="2.16.840.1.113883.10.20.22.2.3.1"/>    
     <id root="2.201" extension="Results"/>    
     <code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
     <title>Results</title>    
     <text>    
      <table border="1" width="100%">    
       <thead>    
        <tr>    
         <th>Test Name</th>    
         <th>Date and Time</th>    
         <th>Element</th>    
         <th>Result</th>    
         <th>LOINC/SNOMED</th>    
         <th>Flag</th>    
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
          <content ID="ResultDescription_##ID##" xmlns="urn:hl7-org:v3">##TestName##</content>    
         </td>    
         <td>##Date##</td>    
         <td>##Measure##</td>    
         <td>##Units##</td>    
         <td>##Range##</td>    
         <td>##Flag##</td>    
        </tr>'
	DECLARE @finalTR VARCHAR(MAX)

	SET @finalTR = ''

	DECLARE @entryXML VARCHAR(MAX) = 
		'<entry typeCode="DRIV">    
      <organizer classCode="BATTERY" moodCode="EVN">    
       <templateId root="2.16.840.1.113883.10.20.22.4.1"/>    
       <id nullFlavor="UNK"/>    
       <code nullFlavor="UNK"/>    
       <statusCode code="completed"/>    
       <effectiveTime value="###RESULTDATE###"/>    
       <component>    
        <observation classCode="OBS" moodCode="EVN">    
         <templateId root="2.16.840.1.113883.10.20.22.4.2"/>    
         <id nullFlavor="UNK"/>    
         <code code="###LOINCCODE###" displayName="###NAME###" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
         <text>    
          <reference value="#ResultDescription_##ID##"/>    
         </text>    
         <statusCode code="completed"/>    
         <effectiveTime value="###RESULTDATE###"/>    
         <value xsi:type="PQ" value="###RESULTVALUE###" unit="###RESULTUNIT###"/>
         <interpretationCode code="###INTERORETCODE###" codeSystem="2.16.840.1.113883.5.83"/>
         <methodCode/>
         <targetSiteCode/>    
        </observation>    
       </component>    
      </organizer>    
     </entry>'
	DECLARE @finalEntry VARCHAR(MAX)

	SET @finalEntry = ''

	DECLARE @loopCOUNT INT = 0
	DECLARE @tResults TABLE (
		[OrderName] VARCHAR(max)
		,[OrderDate] DATETIME
		,[TestDate] DATETIME
		,[OrderingPhysician] VARCHAR(200)
		,[LOINC] VARCHAR(100)
		,[Element] VARCHAR(max)
		,[Result] VARCHAR(100)
		,[Flag] VARCHAR(200)
		)

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryTestReviewed NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryTestReviewed @ServiceId
			,@ClientId
			,@DocumentVersionId
	END

	DECLARE @tOrderName VARCHAR(MAX)
	DECLARE @tTestDate DATETIME
	DECLARE @tLOINC VARCHAR(100)
	DECLARE @tElement VARCHAR(max)
	DECLARE @tResult VARCHAR(100)
	DECLARE @tFlag VARCHAR(200)

	IF EXISTS (
			SELECT *
			FROM @tResults
			)
	BEGIN
		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT [OrderName]
			,[TestDate]
			,[Element]
			,[Result]
			,[LOINC]
			,[Flag]
		FROM @tResults TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @tOrderName
			,@tTestDate
			,@tElement
			,@tResult
			,@tLOINC
			,@tFlag

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @finalTR = LTRIM(RTRIM(@finalTR)) + LTRIM(RTRIM(@trXML))
			SET @finalEntry = @finalEntry + @entryXML
			SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)
			SET @finalTR = REPLACE(@finalTR, '##TestName##', ISNULL(@tOrderName, ''))
			SET @finalTR = REPLACE(@finalTR, '##Date##', ISNULL(@tTestDate, ''))
			SET @finalTR = REPLACE(@finalTR, '##Measure##', ISNULL(@tElement, ''))
			SET @finalTR = REPLACE(@finalTR, '##Units##', ISNULL(@tResult, ''))
			SET @finalTR = REPLACE(@finalTR, '##Range##', ISNULL(@tLOINC, ''))
			SET @finalTR = REPLACE(@finalTR, '##Flag##', ISNULL(@tFlag, ''))
			SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)
			SET @finalEntry = REPLACE(@finalEntry, '###LOINCCODE###', @tLOINC)
			SET @finalEntry = REPLACE(@finalEntry, '###RESULTVALUE###', ISNULL(@tResult, 'UNK'))
			SET @finalEntry = REPLACE(@finalEntry, '###RESULTDATE###', convert(VARCHAR(max), convert(DATETIME, @tTestDate), 112))

			IF @tResult LIKE '%10^3/ul%'
				SET @finalEntry = REPLACE(@finalEntry, '###RESULTUNIT###', '10^3/ul')
			ELSE IF @tResult LIKE '%mg/dl%'
				SET @finalEntry = REPLACE(@finalEntry, '###RESULTUNIT###', 'mg/dl')
			ELSE
				SET @finalEntry = REPLACE(@finalEntry, '###RESULTUNIT###', 'UNK')

			SET @finalEntry = REPLACE(@finalEntry, '###NAME###', @tOrderName)

			IF @tFlag = 'Low'
				SET @finalEntry = REPLACE(@finalEntry, '###INTERORETCODE###', 'L')
			ELSE IF @tFlag = 'Normal'
				SET @finalEntry = REPLACE(@finalEntry, '###INTERORETCODE###', 'N')
			ELSE IF @tFlag = 'High'
				SET @finalEntry = REPLACE(@finalEntry, '###INTERORETCODE###', 'H')
			ELSE
				SET @finalEntry = REPLACE(@finalEntry, '###INTERORETCODE###', 'UNK')

			PRINT @finalEntry

			SET @loopCOUNT = @loopCOUNT + 1

			FETCH NEXT
			FROM tCursor
			INTO @tOrderName
				,@tTestDate
				,@tElement
				,@tResult
				,@tLOINC
				,@tFlag
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

