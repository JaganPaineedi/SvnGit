
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetProblemsComponentXMLString]    Script Date: 06/09/2015 00:52:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetProblemsComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetProblemsComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetProblemsComponentXMLString]    Script Date: 06/09/2015 00:52:23 ******/
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
CREATE PROCEDURE [dbo].[ssp_GetProblemsComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @DefaultComponentXML VARCHAR(MAX) = 
		'<component>    
        <section>    
          <templateId root="2.16.840.1.113883.10.20.22.2.5.1"/>    
          <id root="2.201" extension="Problems"/>    
          <code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
          <title>Problems</title>    
          <text>    
            <table border="1" width="100%">    
              <thead>    
                <tr>    
                  <th>Condition</th>    
                  <th>Effective Dates</th>    
                  <th>Clinical Status</th>    
                </tr>    
              </thead>    
              <tbody>    
                <tr>    
                  <td colspan="3">    
                    <content ID="ProblemName_Diagnosis0" xmlns="urn:hl7-org:v3">No Information Available</content>    
                  </td>          
                </tr>                                   
              </tbody>    
            </table>    
          </text>    
          <entry typeCode="DRIV">
				<act classCode="ACT" moodCode="EVN">
					<templateId root="2.16.840.1.113883.10.20.22.4.3"></templateId>
					<id nullFlavor="NI"></id>
					<code code="CONC" codeSystem="2.16.840.1.113883.5.6"></code>
					<statusCode code="active"></statusCode>
					<effectiveTime>
						<low value="20140212130357"></low>
					</effectiveTime>
					<entryRelationship typeCode="SUBJ" inversionInd="false">
						<observation classCode="OBS" moodCode="EVN">
							<templateId root="2.16.840.1.113883.10.20.22.4.4"></templateId>
							<id nullFlavor="NI"></id>
							<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"></code>
							<text mediaType="text/plain">
								<reference value="#ProblemName_Diagnosis0"></reference>
							</text>
							<statusCode code="completed"></statusCode>
							<effectiveTime>
								<low value="20140212130357"></low>
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
     <templateId root="2.16.840.1.113883.10.20.22.2.5.1"/>    
     <id root="2.201" extension="Problems"/>    
     <code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
     <title>Problems</title>    
     <text>    
      <table border="1" width="100%">    
       <thead>    
        <tr>    
         <th>Condition</th>    
         <th>Effective Dates</th>    
         <th>Clinical Status</th>    
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
          <content ID="ProblemName_Diagnosis##ID##" xmlns="urn:hl7-org:v3">##Condition##</content>    
         </td>    
         <td>##EffectiveDate##</td>    
         <td>    
          <content ID="ProblemStatus_Diagnosis##ID##" xmlns="urn:hl7-org:v3">##ClinicalStatus##</content>    
         </td>    
        </tr>'
	DECLARE @finalTR VARCHAR(MAX)

	SET @finalTR = ''

	DECLARE @entryXML VARCHAR(MAX) = 
		'<entry typeCode="DRIV">    
      <act classCode="ACT" moodCode="EVN">    
       <templateId root="2.16.840.1.113883.10.20.22.4.3"/>    
       <id nullFlavor="NA"/>    
       <code code="CONC" codeSystem="2.16.840.1.113883.5.6"/>    
       <statusCode code="active"/>    
       <effectiveTime>    
        <low value="##EFFECTIVEDATE##"/>    
       </effectiveTime>    
       <entryRelationship typeCode="SUBJ">    
        <observation classCode="OBS" moodCode="EVN">    
         <templateId root="2.16.840.1.113883.10.20.22.4.4"/>    
         <id nullFlavor="UNK"/>    
         <code code="##SNOMED##" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>    
         <text>    
          <reference value="#ProblemName_Diagnosis##ID##"/>    
         </text>    
         <statusCode code="completed"/>    
         <effectiveTime>    
          <low value="##EFFECTIVEDATE##"/>    
         </effectiveTime>            
         <value xsi:type="CD" code="##SNOMED##" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="##Condition##">
			<translation code="##ICD##" displayName="##Condition##" codeSystem="2.16.840.1.113883.6.103" codeSystemName="##ICD9OR10##" />
		 </value>	
         <entryRelationship typeCode="REFR">    
          <act classCode="ACT" moodCode="EVN">    
           <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/>    
           <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>    
           <code nullFlavor="UNK"/>    
          </act>    
         </entryRelationship>    
        </observation>    
       </entryRelationship>    
      </act>    
     </entry>'
	DECLARE @finalEntry VARCHAR(MAX)

	SET @finalEntry = ''

	DECLARE @loopCOUNT INT = 0
	DECLARE @tResults TABLE (
		[ClientId] INT
		,[ClientName] VARCHAR(100)
		,[EffectiveDate] DATETIME
		,[SignatureDate] DATETIME
		,[ICD9Code] VARCHAR(max)
		,[ICD9Desc] VARCHAR(max)
		,[ICD10Code] VARCHAR(max)
		,[ICD10Desc] VARCHAR(max)
		,[SNOMEDCodeICD9] VARCHAR(max)
		,[SNOMEDCodeICD10] VARCHAR(max)
		,[Active] VARCHAR(100)
		,[EndDate] DATETIME
		,[Status] VARCHAR(100)
		,[Descri] VARCHAR(max)
		,[StartDate] DATETIME
		)

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryDiagnosis NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO @tResults
		EXEC ssp_RDLClinicalSummaryDiagnosis @ServiceId
			,@ClientId
			,@DocumentVersionId
	END

	DECLARE @tICD9Desc VARCHAR(MAX)
	DECLARE @tEffectiveDate DATETIME
	DECLARE @tStatus VARCHAR(100)
	DECLARE @tICD10Desc VARCHAR(MAX)
	DECLARE @SNOMEDCodeICD10 VARCHAR(MAX)
	DECLARE @tICD10Code VARCHAR(MAX)
	DECLARE @tICD9Code VARCHAR(MAX)

	IF EXISTS (
			SELECT *
			FROM @tResults
			)
	BEGIN
		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT [ICD9Desc]
			,ICD10Desc
			,[StartDate]
			,[Status]
			,[SNOMEDCodeICD10]
			,[ICD10Code]
			,[ICD9Code]
		FROM @tResults TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @tICD9Desc
			,@tICD10Desc
			,@tEffectiveDate
			,@tStatus
			,@SNOMEDCodeICD10
			,@tICD10Code
			,@tICD9Code

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @finalTR = @finalTR + @trXML
			SET @finalEntry = @finalEntry + @entryXML
			SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)

			--SET @finalTR=REPLACE(@finalTR,'##Condition##',ISNULL(@tICD9Desc,''))   
			IF ISNULL(@tICD10Desc, '') <> ''
			BEGIN
				SET @finalTR = REPLACE(@finalTR, '##Condition##', LTRIM(RTRIM(replace(@tICD10Desc,CHAR(13), ''))))
				SET @finalEntry = REPLACE(@finalEntry, '##Condition##', LTRIM(RTRIM(replace(@tICD10Desc,CHAR(13), ''))))
				SET @finalEntry = REPLACE(@finalEntry, '##ICD##', @tICD10Code)
				SET @finalEntry = REPLACE(@finalEntry, '##ICD9OR10##', 'ICD-10-CM')
				
			END
			ELSE IF ISNULL(@tICD9Desc, '') <> ''
			BEGIN
				SET @finalTR = REPLACE(@finalTR, '##Condition##', LTRIM(RTRIM(replace(@tICD9Desc,CHAR(13), ''))))
				SET @finalEntry = REPLACE(@finalEntry, '##Condition##', LTRIM(RTRIM(replace(@tICD9Desc,CHAR(13), ''))))
				SET @finalEntry = REPLACE(@finalEntry, '##ICD##', @tICD9Code)
				SET @finalEntry = REPLACE(@finalEntry, '##ICD9OR10##', 'ICD-9-CM')
			END

			SET @finalTR = REPLACE(@finalTR, '##EffectiveDate##', ISNULL(@tEffectiveDate, ''))
			
			IF ISNULL(@tStatus, '') <> ''
			BEGIN
				IF @SNOMEDCodeICD10 = '49436004'
					SET @finalTR = REPLACE(@finalTR, '##ClinicalStatus##', 'Resolved')
				ELSE
					SET @finalTR = REPLACE(@finalTR, '##ClinicalStatus##', ISNULL(@tStatus, ''))
				
			END
			
			SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)

			IF ISNULL(@tICD10Desc, '') <> ''
			BEGIN
				SET @finalEntry = REPLACE(@finalEntry, '##Condition##', LTRIM(RTRIM(replace(@tICD10Desc,CHAR(13), ''))))
			END
			ELSE IF ISNULL(@tICD9Desc, '') <> ''
			BEGIN
				SET @finalEntry = REPLACE(@finalEntry, '##Condition##', LTRIM(RTRIM(replace(@tICD9Desc,CHAR(13), ''))))
			END
			
			IF CHARINDEX(' ', ISNULL(@SNOMEDCodeICD10, '')) > 0
			BEGIN
				PRINT LEFT(@SNOMEDCodeICD10, CHARINDEX(' ', @SNOMEDCodeICD10))

				SET @finalEntry = REPLACE(@finalEntry, '##SNOMED##', LEFT(@SNOMEDCodeICD10, CHARINDEX(' ', @SNOMEDCodeICD10)))
			END
			ELSE
			BEGIN
				SET @finalEntry = REPLACE(@finalEntry, '##SNOMED##', isNull(@SNOMEDCodeICD10, ''))
			END
			
			SET @finalEntry = REPLACE(@finalEntry, '##EFFECTIVEDATE##', convert(VARCHAR(max), convert(DATETIME, @tEffectiveDate), 112))
			SET @loopCOUNT = @loopCOUNT + 1

			FETCH NEXT
			FROM tCursor
			INTO @tICD9Desc
				,@tICD10Desc
				,@tEffectiveDate
				,@tStatus
				,@SNOMEDCodeICD10
				,@tICD10Code
				,@tICD9Code
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

