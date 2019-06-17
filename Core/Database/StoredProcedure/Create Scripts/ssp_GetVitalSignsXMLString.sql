/****** Object:  StoredProcedure [dbo].[ssp_GetVitalSignsXMLString]    Script Date: 09/22/2017 18:17:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetVitalSignsXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetVitalSignsXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetVitalSignsXMLString]    Script Date: 09/22/2017 18:17:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetVitalSignsXMLString] @ClientId INT = NULL    
 ,@Type VARCHAR(10) = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@FromDate DATETIME = NULL    
 ,@ToDate DATETIME = NULL   
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT 
 -- =============================================                             
/*                  
 Author   Added Date   Reason   Task                  
 Vijay    05/09/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation    
*/  
AS  
BEGIN  
 DECLARE @DefaultComponentXML VARCHAR(MAX) =   
		'<component>
			<section nullFlavor="NI">
				<!-- Vitals Section (entries required) (V3) -->
				<templateId root="2.16.840.1.113883.10.20.22.2.4.1" extension="2015-08-01"/>
				<templateId root="2.16.840.1.113883.10.20.22.2.4.1"/>
				<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>
				<title>VITAL SIGNS</title>
				<text>No Vital Signs Information</text>
			</section>
		</component>'  
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>
		<section>
			<templateId root="2.16.840.1.113883.10.20.22.2.4.1"/>
			<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>
			<title>VITAL SIGNS</title>
			<text>
				<table border="1" width="100%">
					<thead>
						<tr>
							<th align="right">Date / Time: </th>
							###THSECTION###
						</tr>
					</thead>
					<tbody>
						###HEIGHTTRSECTION###
						###WEIGHTTRSECTION###
						###BPTRSECTION###
						###HEARTRATETRSECTION###
						###OXIMETRYTRSECTION###
						###TEMPERATURETRSECTION###
						###RESPIRATORYTRSECTION###
					</tbody>
				</table>
			</text>
			###ENTRYSECTION###
		</section>
	</component>'  
 DECLARE @thXML VARCHAR(MAX) = '<th>##RECORDDATE##</th>'  
         
 DECLARE @trHeightXML VARCHAR(MAX) = '<tr>  
                   <th align="left">Height</th>  
                   ###HEIGHTTDSECTION###    
                </tr>'  
                  
    DECLARE @trWeightXML VARCHAR(MAX) = '<tr>  
                   <th align="left">Weight</th>  
                   ###WEIGHTTDSECTION###    
                </tr>'  
                  
    DECLARE @trBPXML VARCHAR(MAX) = '<tr>  
                   <th align="left">Blood Pressure</th>  
                   ###BPTDSECTION###    
				</tr>'  
                   
    DECLARE @trHeartRateXML VARCHAR(MAX) = '<tr>  
				 <th align="left">Heart Rate</th>  
				 ###HEARTRATETDSECTION###    
				</tr>'  
                    
    DECLARE @trOximetryXML VARCHAR(MAX) = '<tr>  
				 <th align="left">O2 Percentage BldC Oximetry</th>  
				 ###OXIMETRYTDSECTION###  
				</tr>'  
                     
    DECLARE @trTemperatureXML VARCHAR(MAX) = '<tr>  
				 <th align="left">Body Temperature</th>  
				 ###TEMPERATURETDSECTION###  
				</tr>'  
                      
    DECLARE @trRespiratoryXML VARCHAR(MAX) = '<tr>  
				 <th align="left">Respiratory Rate</th>  
				 ###RESPIRATORYTDSECTION###  
				</tr>'  
              
	DECLARE @tdHeightXML VARCHAR(MAX) = '<td><content ID="vit_##ID##">##HEIGHT## ##HEIGHTUNIT##</content></td>'                        
	DECLARE @tdWeightXML VARCHAR(MAX) = '<td><content ID="vit_##ID##">##WEIGHT## ##WEIGHTUNIT##</content></td>'                             
    DECLARE @tdBPXML VARCHAR(MAX) = '<td><content ID="vit_##ID##">##BLOODPRESSURE## ##BPUNIT##</content></td>'        
    DECLARE @tdHeartRateXML VARCHAR(MAX) = '<td><content ID="vit_##ID##">##HEARTRATE## ##HEARTRATEUNIT##</content></td>'    
    DECLARE @tdOximetryXML VARCHAR(MAX) = '<td><content ID="vit_##ID##">##OXIMETRY## ##OXIMETRYUNIT##</content></td>'    
    DECLARE @tdTemperatureXML VARCHAR(MAX) = '<td><content ID="vit_##ID##">##TEMPERATURE## ##TEMPERATUREUNIT##</content></td>'    
    DECLARE @tdRespiratoryXML VARCHAR(MAX) = '<td><content ID="vit_##ID##">##RESPIRATORY## ##RESPIRATORYUNIT##</content></td>'                               
      
      
 DECLARE @finalTH VARCHAR(MAX)  
 SET @finalTH = ''  
   
 DECLARE @finalTDHeight VARCHAR(MAX)  
 SET @finalTDHeight = ''  
 DECLARE @finalTRHeight VARCHAR(MAX)  
 SET @finalTRHeight = ''  
 DECLARE @finalHeightComponent VARCHAR(MAX)  
 SET @finalHeightComponent = ''  
   
 DECLARE @finalTDWeight VARCHAR(MAX)  
 SET @finalTDWeight = ''  
 DECLARE @finalTRWeight VARCHAR(MAX)  
 SET @finalTRWeight = ''  
 DECLARE @finalWeightComponent VARCHAR(MAX)  
 SET @finalWeightComponent = ''  
   
 DECLARE @finalTDBP VARCHAR(MAX)  
 SET @finalTDBP = ''  
 DECLARE @finalTRBP VARCHAR(MAX)  
 SET @finalTRBP = ''  
 DECLARE @finalDiastolicComponent VARCHAR(MAX)  
 SET @finalDiastolicComponent = ''  
 DECLARE @finalSystolicComponent VARCHAR(MAX)  
 SET @finalSystolicComponent = ''  
   
 DECLARE @finalTDHeartRate VARCHAR(MAX)  
 SET @finalTDHeartRate = ''  
 DECLARE @finalTRHeartRate VARCHAR(MAX)  
 SET @finalTRHeartRate = ''  
 DECLARE @finalHeartRateComponent VARCHAR(MAX)  
 SET @finalHeartRateComponent = ''  
   
 DECLARE @finalTDOximetry VARCHAR(MAX)  
 SET @finalTDOximetry = ''  
 DECLARE @finalTROximetry VARCHAR(MAX)  
 SET @finalTROximetry = ''  
 DECLARE @finalOximetryComponent VARCHAR(MAX)  
 SET @finalOximetryComponent = ''  
   
 DECLARE @finalTDTemperature VARCHAR(MAX)  
 SET @finalTDTemperature = ''  
 DECLARE @finalTRTemperature VARCHAR(MAX)  
 SET @finalTRTemperature = ''  
 DECLARE @finalTemperatureComponent VARCHAR(MAX)  
 SET @finalTemperatureComponent = ''  
  
 DECLARE @finalTDRespiratory VARCHAR(MAX)  
 SET @finalTDRespiratory = ''  
 DECLARE @finalTRRespiratory VARCHAR(MAX)  
 SET @finalTRRespiratory = ''  
 DECLARE @finalRespiratoryComponent VARCHAR(MAX)  
 SET @finalRespiratoryComponent = ''  
    
   
 DECLARE @entryXML VARCHAR(MAX) =   
  '<entry typeCode="DRIV">  
    <organizer classCode="CLUSTER" moodCode="EVN">  
		<templateId root="2.16.840.1.113883.10.20.22.4.26"/>  
		<!-- Vital signs organizer template -->  
		<id root="c6f88320-67ad-11db-bd13-0800200c9a66"/>  
		<code code="46680005" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED -CT" displayName="Vital signs"/>  
		<statusCode code="completed"/>  
		<effectiveTime value="##RECORDDATE##"/>  
		###HEIGHTCOMPONENT###  
		###WEIGHTCOMPONENT###  
		###DIASTOLICCOMPONENT###  
		###SYSTOLICCOMPONENT###  
		###HEARTRATECOMPONENT###  
		###OXIMETRYCOMPONENT###  
		###TEMPERATURECOMPONENT###  
		###RESPIRATORYCOMPONENT###  
     </organizer>  
     </entry>'  
      
    DECLARE @HeightComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<!-- Vital Sign Observation template -->
				<id root="c6f88321-67ad-11db-bd13-0800200c9a66"/>
				<code code="##HEIGHTLOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Height"/>
				<text>
					<reference value="#vit_##ID##"/>
				</text>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##HEIGHT##" unit="##HEIGHTUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
      
    DECLARE @WeightComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<!-- Vital Sign Observation template -->
				<id root="c6f88321-67ad-11db-bd13-0800200c9a66"/>
				<code code="##WEIGHTLOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Patient Body Weight - Measured"/>
				<text>
					<reference value="#vit_##ID##"/>
				</text>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##WEIGHT##" unit="##WEIGHTUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
      
     DECLARE @DiastolicComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<!-- ** Vital sign observation ** -->
				<templateId root="2.16.840.1.113883.10.20.22.4.27" extension="2014-06-09"/>
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<id root="1c2748b7-e440-42ba-bc02-dde97d84a036"/>
				<code code="##DIASTOLICLOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP Diastolic"/>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##BPDIASTOLIC##" unit="##DIASTOLICUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
    DECLARE @SystolicComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<!-- Vital Sign Observation template -->
				<id root="c6f88321-67ad-11db-bd13-0800200c9a66"/>
				<code code="##SYSTOLICLOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Intravascular Systolic"/>
				<text>
					<reference value="#vit_##ID##"/>
				</text>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##BPSYSTOLIC##" unit="##SYSTOLICUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
    DECLARE @HeartRateComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<!-- ** Vital sign observation ** -->
				<templateId root="2.16.840.1.113883.10.20.22.4.27" extension="2014-06-09"/>
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<id root="a0e39c70-9675-4b2a-9838-cdf74200d8d5"/>
				<code code="##HEARTRATELOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart Rate"/>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##HEARTRATE##" unit="##HEARTRATEUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
   DECLARE @OximetryComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<!-- ** Vital sign observation ** -->
				<templateId root="2.16.840.1.113883.10.20.22.4.27" extension="2014-06-09"/>
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<id root="a0e39c70-9675-4b2a-9839-cdf74200d8d5"/>
				<code code="##OXIMETRYLOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="O2 % BldC Oximetry"/>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##OXIMETRY##" unit="##OXIMETRYUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
   DECLARE @TemperatureComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<!-- ** Vital sign observation ** -->
				<templateId root="2.16.840.1.113883.10.20.22.4.27" extension="2014-06-09"/>
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<id root="a0e39c70-9675-4b2a-9841-cdf74200d8d5"/>
				<code code="##TEMPERATURELOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body Temperature"/>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##TEMPERATURE##" unit="##TEMPERATUREUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
   DECLARE @RespiratoryComponentXML VARCHAR(MAX) = '<component>
			<observation classCode="OBS" moodCode="EVN">
				<!-- ** Vital sign observation ** -->
				<templateId root="2.16.840.1.113883.10.20.22.4.27" extension="2014-06-09"/>
				<templateId root="2.16.840.1.113883.10.20.22.4.27"/>
				<id root="a0e39c70-9675-4b2a-9842-cdf74200d8d5"/>
				<code code="##RESPIRATORYLOINC##" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Respiratory Rate"/>
				<statusCode code="completed"/>
				<effectiveTime value="##RECORDDATE##"/>
				<value xsi:type="PQ" value="##RESPIRATORY##" unit="##RESPIRATORYUNIT##"/>
				<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83"/>
			</observation>
		</component>'  
    
 DECLARE @finalEntry VARCHAR(MAX)  
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [SubTemplateName] VARCHAR(200)  
  ,[AttributeName] VARCHAR(200)  
  ,[Value] VARCHAR(250)  
  ,[AttributeValue] VARCHAR(200)  
  ,[RecordDate] DATETIME  
  ,[Normal] VARCHAR(50)  
  ,[Flag] VARCHAR(25)  
  ,[LOINCCode] VARCHAR(200)  
  ,[AttributeUnit] VARCHAR(250)  
  )  
    
 INSERT INTO @tResults  
  EXEC ssp_RDLClinicalSummaryVitals Null,Null, @DocumentVersionId  
  
 DECLARE @tSubTemplateName VARCHAR(200) = ''  
 DECLARE @tAttributeName VARCHAR(200) = ''  
 DECLARE @tValue VARCHAR(250) = ''  
 DECLARE @tAttributeValue VARCHAR(200) = ''  
 DECLARE @tRecordDate VARCHAR(100) = ''  
 DECLARE @tAttributeUnit VARCHAR(250) = ''  
    
 DECLARE @tDiastolic VARCHAR(50) = ''  
 DECLARE @tSystolic VARCHAR(50) = ''  
 DECLARE @tHeight VARCHAR(50) = ''  
 DECLARE @tWeight VARCHAR(50) = ''  
 DECLARE @tHeartRate VARCHAR(50) = ''  
 DECLARE @tOximetry VARCHAR(50) = ''  
 DECLARE @tTemperature VARCHAR(50) = ''  
 DECLARE @tRespiratory VARCHAR(50) = ''  
   
 DECLARE @tDiastolicLOINC VARCHAR(200) = ''  
 DECLARE @tSystolicLOINC VARCHAR(200) = ''  
 DECLARE @tHeightLOINC VARCHAR(200) = ''  
 DECLARE @tWeightLOINC VARCHAR(200) = ''  
 DECLARE @tHeartRateLOINC VARCHAR(200) = ''  
 DECLARE @tOximetryLOINC VARCHAR(200) = ''  
 DECLARE @tTemperatureLOINC VARCHAR(200) = ''  
 DECLARE @tRespiratoryLOINC VARCHAR(200) = ''  
   
 DECLARE @tDiastolicUnit VARCHAR(250) = ''  
 DECLARE @tSystolicUnit VARCHAR(250) = ''  
 DECLARE @tHeightUnit VARCHAR(250) = ''  
 DECLARE @tWeightUnit VARCHAR(250) = ''  
 DECLARE @tHeartRateUnit VARCHAR(250) = ''  
 DECLARE @tOximetryUnit VARCHAR(250) = ''  
 DECLARE @tTemperatureUnit VARCHAR(250) = ''  
 DECLARE @tRespiratoryUnit VARCHAR(250) = ''  
   
 DECLARE @tDiastolicFlag VARCHAR(10) = 'False'  
 DECLARE @tSystolicFlag VARCHAR(10) = 'False'  
 DECLARE @tHeightFlag VARCHAR(10) = 'False'  
 DECLARE @tWeightFlag VARCHAR(10) = 'False'  
 DECLARE @tHeartRateFlag VARCHAR(10) = 'False'  
 DECLARE @tOximetryFlag VARCHAR(10) = 'False'  
 DECLARE @tTemperatureFlag VARCHAR(10) = 'False'  
 DECLARE @tRespiratoryFlag VARCHAR(10) = 'False'   
   
--Converting rows to columns  
 DECLARE @tempResults TABLE (  
  [Diastolic] VARCHAR(200)  
  ,[Systolic] VARCHAR(200)  
  ,[Height] VARCHAR(50)  
  ,[Weight] VARCHAR(50)    
  ,[HeartRate] VARCHAR(50)  
  ,[Oximetry] VARCHAR(50)  
  ,[Temperature] VARCHAR(50)  
  ,[Respiratory] VARCHAR(50)  
    
  ,[DiastolicLOINC] VARCHAR(200)  
  ,[SystolicLOINC] VARCHAR(200)  
  ,[HeightLOINC] VARCHAR(200)  
  ,[WeightLOINC] VARCHAR(200)  
  ,[HeartRateLOINC] VARCHAR(200)  
  ,[OximetryLOINC] VARCHAR(200)  
  ,[TemperatureLOINC] VARCHAR(200)  
  ,[RespiratoryLOINC] VARCHAR(200)  
    
  ,[DiastolicUnit] VARCHAR(250)  
  ,[SystolicUnit] VARCHAR(250)  
  ,[HeightUnit] VARCHAR(250)  
  ,[WeightUnit] VARCHAR(250)  
  ,[HeartRateUnit] VARCHAR(250)  
  ,[OximetryUnit] VARCHAR(250)  
  ,[TemperatureUnit] VARCHAR(250)  
  ,[RespiratoryUnit] VARCHAR(250)  
  ,[RecordDate] DATETIME  
  )    
 INSERT INTO @tempResults   
 select  
   max(case when AttributeName = 'Diastolic' then AttributeValue end) Diastolic,  
   max(case when AttributeName = 'Systolic' then AttributeValue end) Systolic,  
   max(case when AttributeName = 'Height' then AttributeValue end) Height,  
   max(case when AttributeName = 'Weight' then AttributeValue end) [Weight],     
   max(case when AttributeName = 'Pulse' then AttributeValue end) [HeartRate],  
   max(case when AttributeName = 'Oximetry' then AttributeValue end) [Oximetry],  
   max(case when AttributeName = 'Temperature' then AttributeValue end) [Temperature],  
   max(case when AttributeName = 'Respiratory' then AttributeValue end) [Respiratory],  
     
   max(case when AttributeName = 'Diastolic' then LOINCCode end) DiastolicLOINC,  
   max(case when AttributeName = 'Systolic' then LOINCCode end) SystolicLOINC,  
   max(case when AttributeName = 'Height' then LOINCCode end) HeightLOINC,  
   max(case when AttributeName = 'Weight' then LOINCCode end) WeightLOINC,  
   max(case when AttributeName = 'Pulse' then LOINCCode end) [HeartRateLOINC],  
   max(case when AttributeName = 'Oximetry' then LOINCCode end) [OximetryLOINC],  
   max(case when AttributeName = 'Temperature' then LOINCCode end) [TemperatureLOINC],  
   max(case when AttributeName = 'Respiratory' then LOINCCode end) [RespiratoryLOINC],  
     
   max(case when AttributeName = 'Diastolic' then AttributeUnit end) DiastolicUnit,  
   max(case when AttributeName = 'Systolic' then AttributeUnit end) SystolicUnit,  
   max(case when AttributeName = 'Height' then AttributeUnit end) HeightUnit,  
   max(case when AttributeName = 'Weight' then AttributeUnit end) WeightUnit,  
   max(case when AttributeName = 'Pulse' then AttributeUnit end) [HeartRateUnit],  
   max(case when AttributeName = 'Oximetry' then AttributeUnit end) [OximetryUnit],  
   max(case when AttributeName = 'Temperature' then AttributeUnit end) [TemperatureUnit],  
   max(case when AttributeName = 'Respiratory' then AttributeUnit end) [RespiratoryUnit],  
   RecordDate     
 from @tResults group by RecordDate  
   
  
 IF EXISTS (  
   SELECT *  
   FROM @tempResults   
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [Diastolic]  
   ,[Systolic]  
   ,[Height]  
   ,[Weight]  
   ,[HeartRate]  
   ,[Oximetry]  
   ,[Temperature]  
   ,[Respiratory]  
   ,[DiastolicLOINC]  
   ,[SystolicLOINC]   
   ,[HeightLOINC]  
   ,[WeightLOINC]  
   ,[HeartRateLOINC]  
   ,[OximetryLOINC]  
   ,[TemperatureLOINC]  
   ,[RespiratoryLOINC]  
   ,[DiastolicUnit]  
   ,[SystolicUnit]   
   ,[HeightUnit]  
   ,[WeightUnit]  
   ,[HeartRateUnit]  
   ,[OximetryUnit]  
   ,[TemperatureUnit]  
   ,[RespiratoryUnit]  
   ,[RecordDate]  
  FROM @tempResults  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tDiastolic  
   ,@tSystolic  
   ,@tHeight  
   ,@tWeight  
   ,@tHeartRate  
   ,@tOximetry  
   ,@tTemperature  
   ,@tRespiratory     
   ,@tDiastolicLOINC  
   ,@tSystolicLOINC   
   ,@tHeightLOINC  
   ,@tWeightLOINC  
   ,@tHeartRateLOINC  
   ,@tOximetryLOINC  
   ,@tTemperatureLOINC  
   ,@tRespiratoryLOINC  
   ,@tDiastolicUnit  
   ,@tSystolicUnit   
   ,@tHeightUnit  
   ,@tWeightUnit  
   ,@tHeartRateUnit  
   ,@tOximetryUnit  
   ,@tTemperatureUnit  
   ,@tRespiratoryUnit  
   ,@tRecordDate     
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTH = @finalTH + @thXML   
       
   SET @finalEntry = @finalEntry + @entryXML     
   SET @finalTH = REPLACE(@finalTH, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
        
   SET @finalTDHeight = @finalTDHeight + @tdHeightXML  
   SET @finalTDHeight = REPLACE(@finalTDHeight, '##ID##', @loopCOUNT)  
   SET @finalTDHeight = REPLACE(@finalTDHeight, '##HEIGHT##', ISNULL(@tHeight, 'UNK'))  
   SET @finalTDHeight = REPLACE(@finalTDHeight, '##HEIGHTUNIT##', ISNULL(@tHeightUnit, 'UNK'))  
     
   SET @finalTDWeight = @finalTDWeight + @tdWeightXML  
   SET @finalTDWeight = REPLACE(@finalTDWeight, '##ID##', @loopCOUNT)  
   SET @finalTDWeight = REPLACE(@finalTDWeight, '##WEIGHT##', ISNULL(@tWeight, 'UNK'))  
   SET @finalTDWeight = REPLACE(@finalTDWeight, '##WEIGHTUNIT##', ISNULL(@tWeightUnit, 'UNK'))  
     
   SET @finalTDBP = @finalTDBP + @tdBPXML  
   SET @finalTDBP = REPLACE(@finalTDBP, '##ID##', @loopCOUNT)  
   SET @finalTDBP = REPLACE(@finalTDBP, '##BLOODPRESSURE##', ISNULL(@tDiastolic+'/'+@tSystolic, 'UNK'))  
   SET @finalTDBP = REPLACE(@finalTDBP, '##BPUNIT##', ISNULL(@tDiastolicUnit, 'UNK'))   
     
   SET @finalTDHeartRate = @finalTDHeartRate + @tdHeartRateXML  
   SET @finalTDHeartRate = REPLACE(@finalTDHeartRate, '##ID##', @loopCOUNT)  
   SET @finalTDHeartRate = REPLACE(@finalTDHeartRate, '##HEARTRATE##', ISNULL(@tHeartRate, 'UNK'))  
   SET @finalTDHeartRate = REPLACE(@finalTDHeartRate, '##HEARTRATEUNIT##', ISNULL(@tHeartRateUnit, 'UNK'))    
        
   SET @finalTDOximetry = @finalTDOximetry + @tdOximetryXML  
   SET @finalTDOximetry = REPLACE(@finalTDOximetry, '##ID##', @loopCOUNT)  
   SET @finalTDOximetry = REPLACE(@finalTDOximetry, '##OXIMETRY##', ISNULL(@tOximetry, 'UNK'))  
   SET @finalTDOximetry = REPLACE(@finalTDOximetry, '##OXIMETRYUNIT##', ISNULL(@tOximetryUnit, 'UNK'))    
        
   SET @finalTDTemperature = @finalTDTemperature + @tdTemperatureXML  
   SET @finalTDTemperature = REPLACE(@finalTDTemperature, '##ID##', @loopCOUNT)  
   SET @finalTDTemperature = REPLACE(@finalTDTemperature, '##TEMPERATURE##', ISNULL(@tTemperature, 'UNK'))  
   SET @finalTDTemperature = REPLACE(@finalTDTemperature, '##TEMPERATUREUNIT##', ISNULL(@tTemperatureUnit, 'UNK'))    
        
   SET @finalTDRespiratory = @finalTDRespiratory + @tdRespiratoryXML  
   SET @finalTDRespiratory = REPLACE(@finalTDRespiratory, '##ID##', @loopCOUNT)  
   SET @finalTDRespiratory = REPLACE(@finalTDRespiratory, '##RESPIRATORY##', ISNULL(@tRespiratory, 'UNK'))  
   SET @finalTDRespiratory = REPLACE(@finalTDRespiratory, '##RESPIRATORYUNIT##', ISNULL(@tRespiratoryUnit, 'UNK'))    
         
         
   SET @finalEntry = REPLACE(@finalEntry, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))   
   IF ISNULL(@tHeight, '') <> ''  
   BEGIN  
    SET @finalHeightComponent = @finalHeightComponent + @HeightComponentXML  
    SET @finalHeightComponent = REPLACE(@finalHeightComponent, '##ID##', @loopCOUNT)  
    SET @finalHeightComponent = REPLACE(@finalHeightComponent, '##HEIGHT##', ISNULL(@tHeight, 'UNK'))  
    SET @finalHeightComponent = REPLACE(@finalHeightComponent, '##HEIGHTLOINC##', ISNULL(@tHeightLOINC, 'UNK'))  
    SET @finalHeightComponent = REPLACE(@finalHeightComponent, '##HEIGHTUNIT##', ISNULL(@tHeightUnit, 'UNK'))  
    SET @finalHeightComponent = REPLACE(@finalHeightComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END  
     
   IF ISNULL(@tWeight, '') <> ''  
   BEGIN  
    SET @finalWeightComponent = @finalWeightComponent + @WeightComponentXML  
    SET @finalWeightComponent = REPLACE(@finalWeightComponent, '##ID##', @loopCOUNT)  
    SET @finalWeightComponent = REPLACE(@finalWeightComponent, '##WEIGHT##', ISNULL(@tWeight, 'UNK'))  
    SET @finalWeightComponent = REPLACE(@finalWeightComponent, '##WEIGHTLOINC##', ISNULL(@tWeightLOINC, 'UNK'))  
    SET @finalWeightComponent = REPLACE(@finalWeightComponent, '##WEIGHTUNIT##', ISNULL(@tWeightUnit, 'UNK'))  
    SET @finalWeightComponent = REPLACE(@finalWeightComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END  
     
   IF ISNULL(@tDiastolic, '') <> ''  
   BEGIN  
    SET @finalDiastolicComponent = @finalDiastolicComponent + @DiastolicComponentXML  
    SET @finalDiastolicComponent = REPLACE(@finalDiastolicComponent, '##ID##', @loopCOUNT)  
    SET @finalDiastolicComponent = REPLACE(@finalDiastolicComponent, '##BPDIASTOLIC##', ISNULL(@tDiastolic, 'UNK'))  
    SET @finalDiastolicComponent = REPLACE(@finalDiastolicComponent, '##DIASTOLICLOINC##', ISNULL(@tDiastolicLOINC, 'UNK'))  
    SET @finalDiastolicComponent = REPLACE(@finalDiastolicComponent, '##DIASTOLICUNIT##', ISNULL(@tDiastolicUnit, 'UNK'))  
    SET @finalDiastolicComponent = REPLACE(@finalDiastolicComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END  
     
   IF ISNULL(@tSystolic, '') <> ''  
   BEGIN  
    SET @finalSystolicComponent = @finalSystolicComponent + @SystolicComponentXML  
    SET @finalSystolicComponent = REPLACE(@finalSystolicComponent, '##ID##', @loopCOUNT)  
    SET @finalSystolicComponent = REPLACE(@finalSystolicComponent, '##BPSYSTOLIC##', ISNULL(@tSystolic, 'UNK'))  
    SET @finalSystolicComponent = REPLACE(@finalSystolicComponent, '##SYSTOLICLOINC##', ISNULL(@tSystolicLOINC, 'UNK'))  
    SET @finalSystolicComponent = REPLACE(@finalSystolicComponent, '##SYSTOLICUNIT##', ISNULL(@tSystolicUnit, 'UNK'))  
    SET @finalSystolicComponent = REPLACE(@finalSystolicComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END  
     
   IF ISNULL(@tHeartRate, '') <> ''  
   BEGIN  
    SET @finalHeartRateComponent = @finalHeartRateComponent + @HeartRateComponentXML  
    SET @finalHeartRateComponent = REPLACE(@finalHeartRateComponent, '##ID##', @loopCOUNT)  
    SET @finalHeartRateComponent = REPLACE(@finalHeartRateComponent, '##HEARTRATE##', ISNULL(@tHeartRate, 'UNK'))  
    SET @finalHeartRateComponent = REPLACE(@finalHeartRateComponent, '##HEARTRATELOINC##', ISNULL(@tHeartRateLOINC, 'UNK'))  
    SET @finalHeartRateComponent = REPLACE(@finalHeartRateComponent, '##HEARTRATEUNIT##', ISNULL(@tHeartRateUnit, 'UNK'))  
    SET @finalHeartRateComponent = REPLACE(@finalHeartRateComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END  
     
   IF ISNULL(@tOximetry, '') <> ''  
   BEGIN  
    SET @finalOximetryComponent = @finalOximetryComponent + @OximetryComponentXML  
    SET @finalOximetryComponent = REPLACE(@finalOximetryComponent, '##ID##', @loopCOUNT)  
    SET @finalOximetryComponent = REPLACE(@finalOximetryComponent, '##OXIMETRY##', ISNULL(@tOximetry, 'UNK'))  
    SET @finalOximetryComponent = REPLACE(@finalOximetryComponent, '##OXIMETRYLOINC##', ISNULL(@tOximetryLOINC, 'UNK'))  
    SET @finalOximetryComponent = REPLACE(@finalOximetryComponent, '##OXIMETRYUNIT##', ISNULL(@tOximetryUnit, 'UNK'))  
    SET @finalOximetryComponent = REPLACE(@finalOximetryComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END  
     
   IF ISNULL(@tTemperature, '') <> ''  
   BEGIN  
    SET @finalTemperatureComponent = @finalTemperatureComponent + @TemperatureComponentXML  
    SET @finalTemperatureComponent = REPLACE(@finalTemperatureComponent, '##ID##', @loopCOUNT)  
    SET @finalTemperatureComponent = REPLACE(@finalTemperatureComponent, '##TEMPERATURE##', ISNULL(@tTemperature, 'UNK'))  
    SET @finalTemperatureComponent = REPLACE(@finalTemperatureComponent, '##TEMPERATURELOINC##', ISNULL(@tTemperatureLOINC, 'UNK'))  
    SET @finalTemperatureComponent = REPLACE(@finalTemperatureComponent, '##TEMPERATUREUNIT##', ISNULL(@tTemperatureUnit, 'UNK'))  
    SET @finalTemperatureComponent = REPLACE(@finalTemperatureComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END  
     
   IF ISNULL(@tRespiratory, '') <> ''  
   BEGIN  
    SET @finalRespiratoryComponent = @finalRespiratoryComponent + @RespiratoryComponentXML  
    SET @finalRespiratoryComponent = REPLACE(@finalRespiratoryComponent, '##ID##', @loopCOUNT)  
    SET @finalRespiratoryComponent = REPLACE(@finalRespiratoryComponent, '##RESPIRATORY##', ISNULL(@tRespiratory, 'UNK'))  
    SET @finalRespiratoryComponent = REPLACE(@finalRespiratoryComponent, '##RESPIRATORYLOINC##', ISNULL(@tRespiratoryLOINC, 'UNK'))   
    SET @finalRespiratoryComponent = REPLACE(@finalRespiratoryComponent, '##RESPIRATORYUNIT##', ISNULL(@tRespiratoryUnit, 'UNK'))  
    SET @finalRespiratoryComponent = REPLACE(@finalRespiratoryComponent, '##RECORDDATE##', convert(VARCHAR(max), convert(DATETIME, @tRecordDate), 112))  
   END   
     
   SET @finalEntry = REPLACE(@finalEntry, '###HEIGHTCOMPONENT###', @finalHeightComponent)  
   SET @finalEntry = REPLACE(@finalEntry, '###WEIGHTCOMPONENT###', @finalWeightComponent)  
   SET @finalEntry = REPLACE(@finalEntry, '###DIASTOLICCOMPONENT###', @finalDiastolicComponent)  
   SET @finalEntry = REPLACE(@finalEntry, '###SYSTOLICCOMPONENT###', @finalSystolicComponent)  
   SET @finalEntry = REPLACE(@finalEntry, '###HEARTRATECOMPONENT###', @finalHeartRateComponent)  
   SET @finalEntry = REPLACE(@finalEntry, '###OXIMETRYCOMPONENT###', @finalOximetryComponent)  
   SET @finalEntry = REPLACE(@finalEntry, '###TEMPERATURECOMPONENT###', @finalTemperatureComponent)  
   SET @finalEntry = REPLACE(@finalEntry, '###RESPIRATORYCOMPONENT###', @finalRespiratoryComponent)  
        
   SET @finalHeightComponent = ''  
   SET @finalWeightComponent = ''  
   SET @finalDiastolicComponent = ''  
   SET @finalSystolicComponent = ''  
   SET @finalHeartRateComponent = ''  
   SET @finalOximetryComponent = ''  
   SET @finalOximetryComponent = ''     
   SET @finalTemperatureComponent = ''  
   SET @finalRespiratoryComponent = ''  
     
   SET @loopCOUNT = @loopCOUNT + 1  
  
    
   IF @tHeight is not null  
   BEGIN  
    SET @tHeightFlag = 'True'  
   END  
   IF @tWeight is not null  
   BEGIN  
    SET @tWeightFlag = 'True'  
   END  
   IF @tDiastolic is not null  
   BEGIN  
    SET @tDiastolicFlag = 'True'  
   END  
   IF @tSystolic is not null  
   BEGIN  
    SET @tSystolicFlag = 'True'  
   END  
   IF @tHeartRate is not null  
   BEGIN  
    SET @tHeartRateFlag = 'True'  
   END  
   IF @tOximetry is not null  
   BEGIN  
    SET @tOximetryFlag = 'True'  
   END  
   IF @tTemperature is not null  
   BEGIN  
    SET @tTemperatureFlag = 'True'  
   END  
   IF @tRespiratory is not null  
   BEGIN  
    SET @tRespiratoryFlag = 'True'  
   END    
     
   PRINT @finalTH  
   PRINT @finalTRHeight  
   PRINT @finalTRWeight  
   PRINT @finalTRBP  
   PRINT @finalTRHeartRate  
   PRINT @finalTROximetry  
   PRINT @finalTRTemperature  
   PRINT @finalTRRespiratory  
   PRINT @finalEntry     
    
   FETCH NEXT  
   FROM tCursor  
   INTO @tDiastolic  
    ,@tSystolic  
    ,@tHeight  
    ,@tWeight  
    ,@tHeartRate  
    ,@tOximetry  
    ,@tTemperature  
    ,@tRespiratory     
    ,@tDiastolicLOINC  
    ,@tSystolicLOINC   
    ,@tHeightLOINC  
    ,@tWeightLOINC  
    ,@tHeartRateLOINC  
    ,@tOximetryLOINC  
    ,@tTemperatureLOINC  
    ,@tRespiratoryLOINC  
    ,@tDiastolicUnit  
    ,@tSystolicUnit   
    ,@tHeightUnit  
    ,@tWeightUnit  
    ,@tHeartRateUnit  
    ,@tOximetryUnit  
    ,@tTemperatureUnit  
    ,@tRespiratoryUnit  
    ,@tRecordDate   
       
  END  
  
  CLOSE tCursor  
  
  DEALLOCATE tCursor  
     
    
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###THSECTION###', @finalTH)  
    
  IF @tHeightFlag = 'True'  
   BEGIN  
    SET @finalTRHeight = @finalTRHeight + @trHeightXML  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###HEIGHTTRSECTION###', @finalTRHeight)  
   END  
  ELSE  
   BEGIN  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###HEIGHTTRSECTION###', '')  
   END  
    
  IF @tWeightFlag = 'True'  
   BEGIN  
    SET @finalTRWeight = @finalTRWeight + @trWeightXML  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###WEIGHTTRSECTION###', @finalTRWeight)  
   END  
  ELSE  
   BEGIN  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###WEIGHTTRSECTION###', '')  
   END  
    
  IF @tSystolicFlag = 'True' OR @tDiastolicFlag='TRUE'  
   BEGIN  
    SET @finalTRBP = @finalTRBP + @trBPXML  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###BPTRSECTION###', @finalTRBP)  
   END  
  ELSE  
   BEGIN  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###BPTRSECTION###', '')  
   END  
       
  IF @tHeartRateFlag = 'True'  
   BEGIN  
    SET @finalTRHeartRate = @finalTRHeartRate + @trHeartRateXML  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###HEARTRATETRSECTION###', @finalTRHeartRate)  
   END    
  ELSE  
   BEGIN  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###HEARTRATETRSECTION###', '')  
   END  
    
  IF @tOximetryFlag = 'True'  
   BEGIN  
    SET @finalTROximetry = @finalTROximetry + @trOximetryXML  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###OXIMETRYTRSECTION###', @finalTROximetry)  
   END  
  ELSE  
   BEGIN  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###OXIMETRYTRSECTION###', '')  
   END  
    
  IF @tTemperatureFlag = 'True'  
   BEGIN  
    SET @finalTRTemperature = @finalTRTemperature + @trTemperatureXML  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###TEMPERATURETRSECTION###', @finalTRTemperature)  
   END  
  ELSE  
   BEGIN  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###TEMPERATURETRSECTION###', '')  
   END  
    
  IF @tRespiratoryFlag = 'True'  
   BEGIN  
    SET @finalTRRespiratory = @finalTRRespiratory + @trRespiratoryXML  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###RESPIRATORYTRSECTION###', @finalTRRespiratory)  
   END  
  ELSE  
   BEGIN  
    SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###RESPIRATORYTRSECTION###', '')  
   END  
         
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###HEIGHTTDSECTION###', @finalTDHeight)  
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###WEIGHTTDSECTION###', @finalTDWeight)  
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###BPTDSECTION###', @finalTDBP)      
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###HEARTRATETDSECTION### ', @finalTDHeartRate)  
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###OXIMETRYTDSECTION###', @finalTDOximetry)  
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###TEMPERATURETDSECTION###', @finalTDTemperature)    
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###RESPIRATORYTDSECTION###', @finalTDRespiratory)       
         
  SET @FinalComponentXML = REPLACE(@FinalComponentXML, '###ENTRYSECTION###', @finalEntry)  
  SET @OutputComponentXML = @FinalComponentXML  
 END  
 ELSE  
 BEGIN  
  SET @OutputComponentXML = @DefaultComponentXML  
 END  
 
END  
  
GO


