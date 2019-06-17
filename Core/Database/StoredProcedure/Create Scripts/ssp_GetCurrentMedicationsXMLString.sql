/****** Object:  StoredProcedure [dbo].[ssp_GetCurrentMedicationsXMLString]    Script Date: 09/22/2017 17:53:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCurrentMedicationsXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetCurrentMedicationsXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetCurrentMedicationsXMLString]    Script Date: 09/22/2017 17:53:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetCurrentMedicationsXMLString] @ClientId INT = NULL    
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
		<section>
			<!-- *** Medications Section (entries required) (V2) *** -->
			<templateId root="2.16.840.1.113883.10.20.22.2.1.1" extension="2014-06-09"/>
			<templateId root="2.16.840.1.113883.10.20.22.2.1.1"/>
			<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF MEDICATION USE"/>
			<title>MEDICATIONS</title>
			<text>No known Medications</text>
			<entry>
				<!-- Act.actionNegationInd -->
				<substanceAdministration moodCode="EVN" classCode="SBADM" negationInd="true">
					<!-- ** Medication Activity (V2) ** -->
					<templateId root="2.16.840.1.113883.10.20.22.4.16" extension="2014-06-09"/>
					<templateId root="2.16.840.1.113883.10.20.22.4.16"/>
					<id root="cdbd33f0-6cde-12db-9fe1-0800200c9a66"/>
					<statusCode code="active"/>
					<effectiveTime nullFlavor="NA"/>
					<doseQuantity nullFlavor="NA"/>
					<consumable>
						<manufacturedProduct classCode="MANU">
							<!-- ** Medication information ** -->
							<templateId root="2.16.840.1.113883.10.20.22.4.23" extension="2014-06-09"/>
							<templateId root="2.16.840.1.113883.10.20.22.4.23"/>
							<manufacturedMaterial>
								<code nullFlavor="OTH" codeSystem="2.16.840.1.113883.6.88">
									<translation code="410942007" displayName="drug or medication" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT"/>
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
			<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF MEDICATION USE"/>
			<title>Medications</title>
			<text>
				<table border="1" width="100%">
					<thead>
						<tr>
							<th>Medication</th>
							<th>Directions</th>
							<th>Start Date</th>
							<th>Status</th>
							<th>Indications</th>
							<th>Fill Instructions</th>
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
       <td><content ID="Med_##ID##">##Medication##</content></td>  
       <td>##Instructions##</td>  
       <td>##StartDate##</td>  
       <td>##Status##</td>  
       <td>##SNOMEDCTDescription## (##SNOMEDCTCode## SNOMED CT)</td>  
       <td><content ID="FillIns">##FillInstructions##</content></td>  
    </tr>'  
 DECLARE @finalTR VARCHAR(MAX)  
 SET @finalTR = ''  
  
 DECLARE @entryXML VARCHAR(MAX) =   
		'<entry typeCode="DRIV">
			<substanceAdministration classCode="SBADM" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.22.4.16"/>
				<!-- ** MEDICATION ACTIVITY -->
				<id root="cdbd33f0-6cde-11db-9fe1-0800200c9a66"/>
				<text>
					<reference value="#Med_##ID##"/>##Instructions##
				</text>
				<statusCode code="##Status##"/>
				<effectiveTime xsi:type="IVL_TS">
					<low nullFlavor="UNK"/>
					<high value="##StartDate##"/>
				</effectiveTime>
				<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
					<period value="##ExternalCode1##" unit="h"/>
				</effectiveTime>
				<routeCode code="##RouteCode##" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI Thesaurus" displayName="##Route##"/>
				<doseQuantity value="##Dose##" unit="##DoseUnit##"/>
				<rateQuantity value="90" unit="ml/min"/>
				<administrationUnitCode code="C42944" displayName="INHALANT" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI Thesaurus"/>
				<consumable>
					<manufacturedProduct classCode="MANU">
						<templateId root="2.16.840.1.113883.10.20.22.4.23"/>
						<id root="2a620155-9d11-439e-92b3-5d9815ff4ee8"/>
						<manufacturedMaterial>
							<code code="##RxNormCode##" codeSystem="2.16.840.1.113883.6.88" displayName="##Medication##">
								<originalText>
									<reference value="#Med_##ID##"/>
								</originalText>
							</code>
						</manufacturedMaterial>
						<manufacturerOrganization>
							<name>##AgencyName##</name>
						</manufacturerOrganization>
					</manufacturedProduct>
				</consumable>
				<performer>
					<assignedEntity>
						<id nullFlavor="NI"/>
						<addr nullFlavor="UNK"/>
						<telecom nullFlavor="UNK"/>
						<representedOrganization>
							<id root="2.16.840.1.113883.19.5.9999.1393"/>
							<name>Get Well Clinic</name>
							<telecom nullFlavor="UNK"/>
							<addr nullFlavor="UNK"/>
						</representedOrganization>
					</assignedEntity>
				</performer>
				<participant typeCode="CSM">
					<participantRole classCode="MANU">
						<templateId root="2.16.840.1.113883.10.20.22.4.24"/>
						<code code="412307009" displayName="drug vehicle" codeSystem="2.16.840.1.113883.6.96"/>
						<playingEntity classCode="MMAT">
							<code code="##RxNormCode##" displayName="##Medication##" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm"/>
							<name>##Medication##</name>
						</playingEntity>
					</participantRole>
				</participant>
				<entryRelationship typeCode="RSON">
					<observation classCode="OBS" moodCode="EVN">
						<templateId root="2.16.840.1.113883.10.20.22.4.19"/>
						<id root="db734647-fc99-424c-a864-7e3cda82e703" extension="45665"/>
						<code code="404684003" displayName="Finding" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
						<statusCode code="##Status##"/>
						<effectiveTime>
							<low nullFlavor="UNK" />
							<high value="##StartDate##"/>
						</effectiveTime>
						<value xsi:type="CD" code="##SNOMEDCTCode##" displayName="##SNOMEDCTDescription##" codeSystem="2.16.840.1.113883.6.96"/>
					</observation>
				</entryRelationship>
				<entryRelationship typeCode="REFR">
					<supply classCode="SPLY" moodCode="INT">
						<templateId root="2.16.840.1.113883.10.20.22.4.17"/>
						<id nullFlavor="NI"/>
						<statusCode code="##Status##"/>
						<effectiveTime xsi:type="IVL_TS">
							<low nullFlavor="UNK"/>
							<high value="##StartDate##"/>
						</effectiveTime>
						<repeatNumber value="##ID##"/>
						<quantity value="75"/>
						<product>
							<manufacturedProduct classCode="MANU">
								<templateId root="2.16.840.1.113883.10.20.22.4.23"/>
								<id root="2a620155-9d11-439e-92b3-5d9815ff4ee8"/>
								<manufacturedMaterial>
									<code code="##RxNormCode##" codeSystem="2.16.840.1.113883.6.88" displayName="##Medication##">
										<originalText>
											<reference value="#Med_##ID##"/>
										</originalText>
									</code>
								</manufacturedMaterial>
								<manufacturerOrganization>
									<name>##AgencyName##</name>
								</manufacturerOrganization>
							</manufacturedProduct>
						</product>
						<performer>
							<assignedEntity>
								<id extension="2981823" root="2.16.840.1.113883.19.5.9999.456"/>
								<addr>
									<streetAddressLine>##Address##</streetAddressLine>
									<city>##City##</city>
									<state>##State##</state>
									<postalCode>##ZipCode##</postalCode>
									<country>US</country>
								</addr>
							</assignedEntity>
						</performer>
						<author>
							<time nullFlavor="UNK"/>
							<assignedAuthor>
								<id root="2a620155-9d11-439e-92b3-5d9815fe4de8"/>
								<addr nullFlavor="UNK"/>
								<telecom nullFlavor="UNK"/>
								<assignedPerson>
									<name>
										<prefix>Dr.</prefix>
										<given>##FirstName##</given>
										<family>##LastName##</family>
									</name>
								</assignedPerson>
							</assignedAuthor>
						</author>
					</supply>
				</entryRelationship>
				<entryRelationship typeCode="REFR">
					<supply classCode="SPLY" moodCode="EVN">
						<templateId root="2.16.840.1.113883.10.20.22.4.18"/>
						<!-- ** Medication Dispense Template ** -->
						<id root="1.2.3.4.56789.1" extension="cb734647-fc99-424c-a864-7e3cda82e704"/>
						<statusCode code="##Status##"/>
						<effectiveTime value="##StartDate##"/>
						<repeatNumber value="##ID##"/>
						<product>
							<manufacturedProduct classCode="MANU">
								<templateId root="2.16.840.1.113883.10.20.22.4.23"/>
								<id root="2a620155-9d11-439e-92b3-5d9815ff4ee8"/>
								<manufacturedMaterial>
									<code code="##RxNormCode##" codeSystem="2.16.840.1.113883.6.88" displayName="##Medication##">
										<originalText>
											<reference value="#Med_##ID##"/>
										</originalText>
									</code>
								</manufacturedMaterial>
								<manufacturerOrganization>
									<name>##AgencyName##</name>
								</manufacturerOrganization>
							</manufacturedProduct>
						</product>
						<performer>
							<time nullFlavor="UNK"/>
							<assignedEntity>
								<id root="2.16.840.1.113883.19.5.9999.456" extension="2981823"/>
								<addr>
									<streetAddressLine>##Address##</streetAddressLine>
									<city>##City##</city>
									<state>##State##</state>
									<postalCode>##ZipCode##</postalCode>
									<country>US</country>
								</addr>
								<telecom nullFlavor="UNK"/>
								<assignedPerson>
									<name>
										<prefix>Dr.</prefix>
										<given>##FirstName##</given>
										<family>##LastName##</family>
									</name>
								</assignedPerson>
								<representedOrganization>
									<id root="2.16.840.1.113883.19.5.9999.1393"/>
									<name>Get Well Clinic</name>
									<telecom nullFlavor="UNK"/>
									<addr nullFlavor="UNK"/>
								</representedOrganization>
							</assignedEntity>
						</performer>
					</supply>
				</entryRelationship>
			</substanceAdministration>
		</entry>'  
 DECLARE @finalEntry VARCHAR(MAX)  
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [ClientId] INT  
  ,[Medication] VARCHAR(100)  
  ,[Strength] VARCHAR(250)  
  ,[Dose] INT  
  ,[DoseUnit] VARCHAR(250)  
  ,[Route] VARCHAR(100)  
  ,[Instructions] VARCHAR(max)  
  ,[FillInstructions] VARCHAR(max)  
  ,[StartDate] DATETIME  
  ,[EndDate] DATETIME  
  ,[Prescriber] VARCHAR(100)  
  ,[Status] VARCHAR(250)  
  ,[RXNormcode] VARCHAR(500)  
  ,[SNOMEDCTCode] VARCHAR(25)  
  ,[SNOMEDCTDescription] VARCHAR(max)  
  ,[FirstName] varchar(20)   
  ,[LastName] varchar(30)  
  ,[AgencyName] varchar(250)  
  ,[Address]varchar(100)  
  ,[City] varchar(30)  
  ,[State] varchar(2)  
  ,[ZipCode] varchar(12)  
  ,[ExternalCode1] varchar(25)  
  ,[RouteCode]varchar(10)  
   )  
         
  
 INSERT INTO @tResults  
  EXEC ssp_GetCurrentMedications NULL  
   ,@Type   
   ,@DocumentVersionId   
   ,@FromDate   
   ,@ToDate  
   ,NULL 
  
 DECLARE @tMedication VARCHAR(100) = ''  
 DECLARE @tStrength VARCHAR(250) = ''  
 DECLARE @tDose INT = 0  
 DECLARE @tDoseUnit VARCHAR(250) = ''  
 DECLARE @tRoute VARCHAR(100) = ''  
 DECLARE @tInstructions VARCHAR(max) = ''  
 DECLARE @tFillInstructions VARCHAR(max) = ''  
 DECLARE @tStartDate VARCHAR(100) = ''  
 DECLARE @tEndDate VARCHAR(100) = ''  
 DECLARE @tPrescriber VARCHAR(100) = ''  
 DECLARE @tStatus VARCHAR(100) = ''  
 DECLARE @tRXNormcode VARCHAR(500) = ''  
 DECLARE @tSNOMEDCTCode VARCHAR(25) = ''  
 DECLARE @tSNOMEDCTDescription VARCHAR(max) = ''  
 DECLARE @tFirstName varchar(20) = ''  
 DECLARE @tLastName varchar(30) = ''   
 DECLARE @tAgencyName varchar(250) = ''  
 DECLARE @tAddress varchar(100) = ''  
 DECLARE @tCity varchar(30) = ''  
 DECLARE @tState varchar(2) = ''  
 DECLARE @tZipCode varchar(12) = ''  
 DECLARE @tExternalCode1 varchar(25) = ''  
 DECLARE @tRouteCode varchar(10) = ''  
    
          
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [Medication]  
   ,[Strength]  
   ,[Dose]  
   ,[DoseUnit]  
   ,[Route]   
   ,[Instructions]  
   ,[FillInstructions]  
   ,[StartDate]  
   ,[EndDate]  
   ,[Prescriber]  
   ,[Status]  
   ,[RXNormcode]  
   ,[SNOMEDCTCode]  
   ,[SNOMEDCTDescription]  
   ,[FirstName]  
   ,[LastName]  
   ,[AgencyName]  
   ,[Address]  
   ,[City]   
   ,[State]   
   ,[ZipCode]   
   ,[ExternalCode1]     
   ,[RouteCode]  
  FROM @tResults  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tMedication  
   ,@tStrength  
   ,@tDose  
   ,@tDoseUnit  
   ,@tRoute  
   ,@tInstructions   
   ,@tFillInstructions  
   ,@tStartDate  
   ,@tEndDate  
   ,@tPrescriber  
   ,@tStatus  
   ,@tRXNormcode  
   ,@tSNOMEDCTCode  
   ,@tSNOMEDCTDescription  
   ,@tFirstName  
   ,@tLastName  
   ,@tAgencyName  
   ,@tAddress  
   ,@tCity  
   ,@tState  
   ,@tZipCode  
   ,@tExternalCode1  
   ,@tRouteCode  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTR = @finalTR + @trXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)  
   SET @finalTR = REPLACE(@finalTR, '##Medication##', ISNULL(@tMedication, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Strength##', ISNULL(@tStrength, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Dose##', ISNULL(@tDose, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##DoseUnit##', ISNULL(@tDoseUnit, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Route##', ISNULL(@tRoute, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Instructions##', ISNULL(@tInstructions, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##FillInstructions##', ISNULL(@tFillInstructions, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##StartDate##', convert(VARCHAR(max), convert(DATETIME, @tStartDate), 112))  
   SET @finalTR = REPLACE(@finalTR, '##EndDate##', convert(VARCHAR(max), convert(DATETIME, @tEndDate), 112))  
   SET @finalTR = REPLACE(@finalTR, '##Prescriber##', ISNULL(@tPrescriber, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##Status##', ISNULL(@tStatus, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##RxNormCode##', ISNULL(@tRxNormCode, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##SNOMEDCTCode##', ISNULL(@tSNOMEDCTCode, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##SNOMEDCTDescription##', ISNULL(@tSNOMEDCTDescription, 'UNK'))  
     
        
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)   
   SET @finalEntry = REPLACE(@finalEntry, '##Medication##', ISNULL(@tMedication, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Strength##', ISNULL(@tStrength, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Dose##', ISNULL(@tDose, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##DoseUnit##', ISNULL(@tDoseUnit, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Route##', ISNULL(@tRoute, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Instructions##', ISNULL(@tInstructions, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##FillInstructions##', ISNULL(@tFillInstructions, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##StartDate##', convert(VARCHAR(max), convert(DATETIME, @tStartDate), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##EndDate##', convert(VARCHAR(max), convert(DATETIME, @tEndDate), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##Prescriber##', ISNULL(@tPrescriber, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Status##', ISNULL(@tStatus, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##RxNormCode##', ISNULL(@tRxNormCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCTCode##', ISNULL(@tSNOMEDCTCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCTDescription##', ISNULL(@tSNOMEDCTDescription, 'UNK'))   
   SET @finalEntry = REPLACE(@finalEntry, '##FirstName##', ISNULL(@tFirstName, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##LastName##', ISNULL(@tLastName, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##AgencyName##', ISNULL(@tAgencyName, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Address##', ISNULL(@tAddress, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##City##', ISNULL(@tCity, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##State##', ISNULL(@tState, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##ZipCode##', ISNULL(@tZipCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##ExternalCode1##', ISNULL(@tExternalCode1, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##RouteCode##', ISNULL(@tRouteCode, 'UNK'))  
     
      
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalTR  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tMedication  
    ,@tStrength  
    ,@tDose  
    ,@tDoseUnit  
    ,@tRoute  
    ,@tInstructions   
    ,@tFillInstructions  
    ,@tStartDate  
    ,@tEndDate  
    ,@tPrescriber  
    ,@tStatus  
    ,@tRXNormcode  
    ,@tSNOMEDCTCode  
    ,@tSNOMEDCTDescription  
    ,@tFirstName  
    ,@tLastName  
    ,@tAgencyName  
    ,@tAddress  
    ,@tCity  
    ,@tState  
    ,@tZipCode  
    ,@tExternalCode1  
    ,@tRouteCode  
  
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


