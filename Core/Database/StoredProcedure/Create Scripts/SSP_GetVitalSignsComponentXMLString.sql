
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetVitalSignsComponentXMLString]    Script Date: 06/09/2015 00:53:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetVitalSignsComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetVitalSignsComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetVitalSignsComponentXMLString]    Script Date: 06/09/2015 00:53:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================          
-- Author:  Naveen P.          
-- Create date: Nov 07, 2014         
-- Description: Retrieves CCD Component XML for Vitals    
/*          
 Author   Modified Date   Reason          
 Naveen        11/07/2014              Initial    
*/
-- =============================================           
CREATE PROCEDURE [dbo].[ssp_GetVitalSignsComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @ComponentXMLTemplate VARCHAR(MAX) = '<component>    
   <section>    
    <templateId root="2.16.840.1.113883.10.20.22.2.4.1"/>    
    <id root="2.201" extension="VitalSigns"/>    
    <code code="8716-3" displayName="PHYSICAL FINDINGS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
    <title>Vital Signs</title>    
    <text>    
     <table border="1" width="100%">    
      <thead>    
       <tr>    
        <th>Date / Time:</th>    
        <th>Height</th>    
        <th>Weight</th>    
        <th>BMI</th>    
        <th>Pulse Rate</th>    
        <th>Blood Pressure</th>    
        <th>Temperature</th>    
        <th>Respiratory Rate</th>    
        <th>Body Surface Area</th>    
        <th>Head Circumference</th>    
       </tr>    
      </thead>    
      <tbody>###TBodyRows###</tbody>    
     </table>    
    </text>    
    ###Entries###    
   </section>    
  </component>'
	DECLARE @DEFAULTCOMPONENTXML VARCHAR(MAX) = 
		'<component>
        <section>
          <templateId root="2.16.840.1.113883.10.20.22.2.4.1"/>
          <id root="2.201" extension="VitalSigns"/>
          <code code="8716-3" displayName="PHYSICAL FINDINGS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
          <title>Vital Signs</title>
          <text>
            <table border="1" width="100%">
              <thead>
                <tr>
                  <th>Date / Time:</th>
                  <th>Height</th>
                  <th>Weight</th>
                  <th>BMI</th>
                  <th>Pulse Rate</th>
                  <th>Blood Pressure</th>
                  <th>Temperature</th>
                  <th>Respiratory Rate</th>
                  <th>Body Surface Area</th>
                  <th>Head Circumference</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan="10">
                    <content ID="VitalSigns_1" xmlns="urn:hl7-org:v3">No Information Available</content>
                  </td>                  
                </tr>
              </tbody>
            </table>
          </text>
          <entry typeCode="DRIV" contextConductionInd="true">
			<organizer classCode="CLUSTER" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.22.4.26"></templateId>
				<id nullFlavor="UNK"></id>
				<code code="46680005" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED" displayName="vital signs"></code>
				<statusCode code="completed"></statusCode>
				<effectiveTime>
					<low nullFlavor="UNK"/>
				</effectiveTime>
				<component>
					<observation classCode="OBS" moodCode="EVN">
						<templateId root="2.16.840.1.113883.10.20.22.4.27"></templateId>
						<id nullFlavor="UNK"></id>
						<code nullFlavor="UNK">
							<originalText>No Information Available</originalText>
						</code>
						<text mediaType="text/plain">
							<reference value="#VitalSigns_1"></reference>
						</text>
						<statusCode code="completed"></statusCode>
						<effectiveTime>
							<low nullFlavor="UNK"/>
						</effectiveTime>
						<value xsi:type="PQ" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" nullFlavor="NAV"></value>
					</observation>
				</component>
			</organizer>
          </entry>
        </section>
      </component>'
	DECLARE @RowXMLTemplate VARCHAR(MAX) = '<tr>    
   <td>###HealthRecordDate###</td>    
   <td>    
    <content ID="VitalSignsHeight_0" xmlns="urn:hl7-org:v3">###Height### in</content>    
   </td>    
   <td>    
    <content ID="VitalSignsWeight_0" xmlns="urn:hl7-org:v3">###Weight### lbs</content>    
   </td>    
   <td>    
    <content ID="VitalSignsBmi_0" xmlns="urn:hl7-org:v3">###BMI###</content>    
   </td>    
   <td/>    
   <td>    
    <content ID="VitalSignsBloodPressure_0" xmlns="urn:hl7-org:v3">###SystolicBloodPressure### / ###DiastolicBloodPressure### mm[Hg]</content>    
   </td>    
   <td/>    
   <td/>    
   <td/>    
   <td/>    
  </tr>'
	DECLARE @EntryXMLTemplate VARCHAR(MAX) = 
		'<entry typeCode="DRIV">    
     <organizer classCode="CLUSTER" moodCode="EVN">    
      <templateId root="2.16.840.1.113883.10.20.22.4.26"/>    
      <id nullFlavor="UNK"/>    
      <code code="46680005" displayName="Vital signs" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>    
      <statusCode code="completed"/>    
      <effectiveTime value="20120806"/>    
      <component>    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.27"/>    
        <id nullFlavor="UNK"/>    
        <code code="8302-2" displayName="Body Height (Measured)" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
        <text>    
         <reference value="#VitalSignsHeight_0"/>    
        </text>    
        <statusCode code="completed"/>    
        <effectiveTime value="20120806"/>    
        <value xsi:type="PQ" value="###Height###" unit="[in_us]"/>    
        <entryRelationship typeCode="REFR">    
         <act classCode="ACT" moodCode="EVN">    
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/>    
          <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>    
          <code nullFlavor="UNK"/>    
         </act>    
        </entryRelationship>    
       </observation>    
      </component>    
      <component>    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.27"/>    
        <id nullFlavor="UNK"/>    
        <code code="3141-9" displayName="Body Weight (Measured)" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
        <text>    
         <reference value="#VitalSignsWeight_0"/>    
        </text>    
        <statusCode code="completed"/>    
        <effectiveTime value="20120806"/>    
        <value xsi:type="PQ" value="###Weight###" unit="[lb_av]"/>    
        <entryRelationship typeCode="REFR">    
         <act classCode="ACT" moodCode="EVN">    
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/>    
          <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>    
          <code nullFlavor="UNK"/>    
         </act>    
        </entryRelationship>    
       </observation>    
      </component>    
      <component>    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.27"/>    
        <id nullFlavor="UNK"/>    
        <code code="8480-6" displayName="Intravascular Systolic" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
        <text>    
         <reference value="#VitalSignsBloodPressure_0"/>    
        </text>    
        <statusCode code="completed"/>    
        <effectiveTime value="20120806"/>    
        <value xsi:type="PQ" value="###SystolicBloodPressure###" unit="mm[Hg]"/>    
        <entryRelationship typeCode="REFR">    
         <act classCode="ACT" moodCode="EVN">    
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/>    
          <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>    
          <code nullFlavor="UNK"/>    
         </act>    
        </entryRelationship>    
       </observation>    
      </component>    
      <component>    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.27"/>    
        <id nullFlavor="UNK"/>    
        <code code="8462-4" displayName="Intravascular Diastolic" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
        <text>    
         <reference value="#VitalSignsBloodPressure_0"/>    
        </text>    
        <statusCode code="completed"/>    
        <effectiveTime value="20120806"/>    
        <value xsi:type="PQ" value="###DiastolicBloodPressure###" unit="mm[Hg]"/>    
        <entryRelationship typeCode="REFR">    
         <act classCode="ACT" moodCode="EVN">    
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/>    
          <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>    
          <code nullFlavor="UNK"/>    
         </act>    
        </entryRelationship>    
       </observation>    
      </component>    
      <component>    
       <observation classCode="OBS" moodCode="EVN">    
        <templateId root="2.16.840.1.113883.10.20.22.4.27"/>    
        <id nullFlavor="UNK"/>    
        <code code="39156-5" displayName="BMI (Body Mass Index)" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
        <text>    
         <reference value="#VitalSignsBmi_0"/>    
        </text>    
        <statusCode code="completed"/>    
        <effectiveTime value="20120806"/>    
        <value xsi:type="PQ" value="###BMI###"/>    
        <entryRelationship typeCode="REFR">    
         <act classCode="ACT" moodCode="EVN">    
          <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.4.1"/>    
          <id extension="a778b36c-2a08-4f41-bc2a-3f29293c4e3c" root="2.201"/>    
          <code nullFlavor="UNK"/>    
         </act>    
        </entryRelationship>    
       </observation>    
      </component>    
     </organizer>    
    </entry>'

	CREATE TABLE #TempVitalSigns (
		HealthDataTemplateId INT
		,HealthdataSubtemplateId INT
		,HealthdataAttributeid INT
		,SubTemplateName VARCHAR(max)
		,AttributeName VARCHAR(max)
		,Value VARCHAR(max)
		,AttributeValue VARCHAR(max)
		,HealthRecordDate DATETIME
		,ClientHealthdataAttributeId INT
		,Datatype INT
		,RecordDate VARCHAR(max)
		,Normal VARCHAR(max)
		,Flag VARCHAR(max)
		,GraphCriteriaid INT
		,OrderInFlowSheet INT
		,EntryDisplayOrder INT
		)

	DECLARE @AttributeName VARCHAR(max)
	DECLARE @AttributeValue VARCHAR(max)
	DECLARE @HealthRecordDate DATETIME
	DECLARE @Height VARCHAR(max)
	DECLARE @Weight VARCHAR(max)
	DECLARE @BMI VARCHAR(max)
	DECLARE @SystolicBloodPressure VARCHAR(max)
	DECLARE @DiastolicBloodPressure VARCHAR(max)
	DECLARE @RecordDate VARCHAR(max)

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO #TempVitalSigns
		EXEC ssp_RDLClinicalSummaryVitals NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO #TempVitalSigns
		EXEC ssp_RDLClinicalSummaryVitals @ServiceId
			,@ClientId
			,@DocumentVersionId
	END

	IF EXISTS (
			SELECT *
			FROM #TempVitalSigns
			)
	BEGIN
		DECLARE #VitalSignsCursor CURSOR FAST_FORWARD
		FOR
		SELECT AttributeName
			,AttributeValue
			,HealthRecordDate
		FROM #TempVitalSigns

		OPEN #VitalSignsCursor

		FETCH #VitalSignsCursor
		INTO @AttributeName
			,@AttributeValue
			,@HealthRecordDate

		WHILE @@fetch_status = 0
		BEGIN
			IF @AttributeName = 'Height'
			BEGIN
				SET @Height = @AttributeValue

				PRINT '@Height: ' + @Height
			END

			IF @AttributeName = 'Weight'
			BEGIN
				SET @Weight = @AttributeValue

				PRINT '@Weight: ' + @Weight
			END

			IF @AttributeName = 'CalculatedBMI'
			BEGIN
				SET @BMI = @AttributeValue

				PRINT '@BMI: ' + @BMI
			END

			IF @AttributeName = 'Systolic'
			BEGIN
				SET @SystolicBloodPressure = @AttributeValue

				PRINT '@SystolicBloodPressure: ' + @SystolicBloodPressure
			END

			IF @AttributeName = 'Diastolic'
			BEGIN
				SET @DiastolicBloodPressure = @AttributeValue

				PRINT '@DiastolicBloodPressure: ' + @DiastolicBloodPressure
			END

			SET @RecordDate = Convert(VARCHAR(25), @HealthRecordDate, 120)

			PRINT '@RecordDate: ' + @RecordDate

			FETCH #VitalSignsCursor
			INTO @AttributeName
				,@AttributeValue
				,@HealthRecordDate
		END

		-- SELECT * FROM #TempVitalSigns    
		-- SELECT @Height Height, @Weight Weight, @BMI BMI, @SystolicBloodPressure Systolic, @DiastolicBloodPressure Diastolic, @RecordDate HealthRecordDate    
		CLOSE #VitalSignsCursor

		DEALLOCATE #VitalSignsCursor

		DROP TABLE #TempVitalSigns

		DECLARE @RowsXML VARCHAR(MAX)

		SET @RowsXML = Replace(@RowXMLTemplate, '###HealthRecordDate###', @RecordDate)
		SET @RowsXML = Replace(@RowsXML, '###Height###', @Height)
		SET @RowsXML = Replace(@RowsXML, '###Weight###', @Weight)
		SET @RowsXML = Replace(@RowsXML, '###BMI###', @BMI)
		SET @RowsXML = Replace(@RowsXML, '###SystolicBloodPressure###', @SystolicBloodPressure)
		SET @RowsXML = Replace(@RowsXML, '###DiastolicBloodPressure###', @DiastolicBloodPressure)

		DECLARE @EntriesXML VARCHAR(MAX)

		SET @EntriesXML = Replace(@EntryXMLTemplate, '###Height###', @Height)
		SET @EntriesXML = Replace(@EntriesXML, '###Weight###', @Weight)
		SET @EntriesXML = Replace(@EntriesXML, '###BMI###', @BMI)
		SET @EntriesXML = Replace(@EntriesXML, '###SystolicBloodPressure###', @SystolicBloodPressure)
		SET @EntriesXML = Replace(@EntriesXML, '###DiastolicBloodPressure###', @DiastolicBloodPressure)

		DECLARE @ComponentXML VARCHAR(MAX)

		SET @ComponentXML = Replace(@ComponentXMLTemplate, '###TBodyRows###', @RowsXML)
		SET @ComponentXML = Replace(@ComponentXML, '###Entries###', @EntriesXML)
		SET @OutputComponentXML = @ComponentXML
	END
	ELSE
	BEGIN
		SET @OutputComponentXML = @DEFAULTCOMPONENTXML
	END
END

GO

