/****** Object:  StoredProcedure [dbo].[ssp_GetImmunizationsXMLString]    Script Date: 09/22/2017 18:03:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetImmunizationsXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetImmunizationsXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetImmunizationsXMLString]    Script Date: 09/22/2017 18:03:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetImmunizationsXMLString] @ClientId INT = NULL    
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
		<!-- *** Immunizations Section (entries required) (V2) *** -->
		<templateId root="2.16.840.1.113883.10.20.22.2.2.1" extension="2014-06-09"/>
		<templateId root="2.16.840.1.113883.10.20.22.2.2.1"/>
		<code code="11369-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of immunizations"/>
		<title>IMMUNIZATIONS</title>
		<text>No known immunization history</text>
		<entry typeCode="DRIV">
			<!-- using negationInd="true" to signify that there are no known immunizations -->
			<substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="true">
				<!-- ** Immunization Activity (V3) ** -->
				<templateId root="2.16.840.1.113883.10.20.22.4.52" extension="2015-08-01"/>
				<templateId root="2.16.840.1.113883.10.20.22.4.52"/>
				<id root="de10790f-1496-4729-8fe6-f1b87b6219f7"/>
				<statusCode code="active"/>
				<effectiveTime nullFlavor="NA"/>
				<routeCode nullFlavor="NA"/>
				<consumable>
					<manufacturedProduct classCode="MANU">
						<!-- ** Immunization Medication Information (V2) ** -->
						<templateId root="2.16.840.1.113883.10.20.22.4.54" extension="2014-06-09"/>
						<templateId root="2.16.840.1.113883.10.20.22.4.54"/>
						<manufacturedMaterial>
							<!-- there is no generic vaccine code and no known recommended way to do this -   
							leaving generic flu for now just as an example. Not sure if it makes more sense to apply a nullFlavor? -db -->
							<code nullFlavor="OTH">
								<!-- Optional original text -->
								<originalText>Vaccination</originalText>
								<translation code="71181003" displayName="vaccine"
								codeSystem="2.16.840.1.113883.6.96"
								codeSystemName="SNOMED-CT"/>
							</code>
							<!-- NA since there is no immunization data -db -->
							<lotNumberText nullFlavor="NA"/>
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
		<templateId root="2.16.840.1.113883.10.20.22.2.2.1"/>
		<!-- Entries Required -->
		<!--  ********  Immunizations section template   ******** -->
		<code code="11369-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of immunizations"/>
		<title>IMMUNIZATIONS</title>
		<text>
			<content ID="immunSect"/>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Vaccine</th>
						<th>Date</th>
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
				<content ID="immun_##ID##"/>##Vaccine##  
           </td>  
           <td>##Date##</td>  
           <td>##Status##</td>  
        </tr>'  
 DECLARE @finalTR VARCHAR(MAX) 
 SET @finalTR = ''  
  
 DECLARE @entryXML VARCHAR(MAX) =   
		'<entry typeCode="DRIV">  
              <substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="false">  
                 <templateId root="2.16.840.1.113883.10.20.22.4.52"/>  
                 <!--  ********   Immunization activity template    ******** -->  
				 <id root="e6f1ba43-c0ed-4b9b-9f12-f435d8ad8f92"/>  
                 <text>  
                    <reference value="#immun_##ID##"/>  
                 </text>  
                 <statusCode code="completed"/>  
                 <effectiveTime xsi:type="IVL_TS" value="##DATE##"/>  
                 <routeCode code="##RouteCode##" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="National Cancer Institute (NCI) Thesaurus" displayName="##RouteCodeName##"/>  
                 <doseQuantity value="##Amount##" unit="mcg"/>  
                 <consumable>  
                    <manufacturedProduct classCode="MANU">  
                       <templateId root="2.16.840.1.113883.10.20.22.4.54"/>  
                       <!--  ********   Immunization Medication Information    ******** -->  
                       <manufacturedMaterial>  
						<!--updated code and codeSystem as per CONF:9007 -db -->  
						<!-- code may need to be updated to 149 -->  
                          <code code="##CVXCode##" codeSystem="2.16.840.1.113883.12.292" displayName="##Vaccine##" codeSystemName="CVX">  
                             <originalText>##Vaccine##</originalText>  
                             <translation code="##CVXCode##" displayName="##Vaccine##" codeSystemName="CVX" codeSystem="2.16.840.1.113883.6.59"/>  
                          </code>  
                       </manufacturedMaterial>  
                       <manufacturerOrganization>  
                          <name>##Manufacturer##</name>  
                       </manufacturerOrganization>  
                    </manufacturedProduct>  
                 </consumable>                  
              </substanceAdministration>  
           </entry>'  
             
    --<entryRelationship typeCode="SUBJ" inversionInd="true">  
                 --   <act classCode="ACT" moodCode="INT">  
                 --      <templateId root="2.16.840.1.113883.10.20.22.4.20"/>  
                 --      <!-- ** Instructions Template ** -->  
                 --      <code xsi:type="CE" code="171044003" codeSystem="2.16.840.1.113883.6.96" displayName="immunization education"/>  
                 --      <text><reference value="#immunSect_##ID##"/>Possible flu-like symptoms for three days.</text>  
                 --      <statusCode code="completed"/>  
                 --   </act>  
                 --</entryRelationship>  
 DECLARE @finalEntry VARCHAR(MAX)  
  
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [ClientId] INT  
  ,[VaccineName] VARCHAR(250)  
  ,[Amount] VARCHAR(250)  
  ,[CVXCode] VARCHAR(25)  
  ,[Date] DATETIME  
  ,[Manufacturer] VARCHAR(250)  
  ,[LotNumber] VARCHAR(25)  
  ,[Status] VARCHAR(100)  
  ,[Note] VARCHAR(max)  
  ,[RouteCodeName] VARCHAR(250)  
  ,[RouteCode] VARCHAR(25)  
  )  
  
 INSERT INTO @tResults  
  EXEC ssp_GetImmunizations NULL  
   ,@Type   
   ,@DocumentVersionId   
   ,@FromDate   
   ,@ToDate  
   ,NULL  
  
 DECLARE @tVaccineName VARCHAR(250) = ''   
 DECLARE @tAmount VARCHAR(250) = ''  
 DECLARE @tCVXCode VARCHAR(25) = ''   
 DECLARE @tManufacturer VARCHAR(250) = ''   
 DECLARE @tLotNumber VARCHAR(25) = ''   
 DECLARE @tStatus VARCHAR(100) = ''  
 DECLARE @tNote VARCHAR(max) = ''   
 DECLARE @tDate VARCHAR(100) = ''  
 DECLARE @tRouteCodeName VARCHAR(250) = ''  
 DECLARE @tRouteCode VARCHAR(25) = ''  
  
    
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [VaccineName]  
   ,[Amount]  
   ,[CVXCode]  
   ,[Date]  
   ,[Manufacturer]  
   ,[LotNumber]  
   ,[Status]  
   ,[Note]  
   ,[RouteCodeName]  
   ,[RouteCode]  
  FROM @tResults  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tVaccineName  
   ,@tAmount  
   ,@tCVXCode  
   ,@tDate  
   ,@tManufacturer  
   ,@tLotNumber  
   ,@tStatus  
   ,@tNote   
   ,@tRouteCodeName  
   ,@tRouteCode   
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalTR = @finalTR + @trXML  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalTR = REPLACE(@finalTR, '##ID##', @loopCOUNT)  
   SET @finalTR = REPLACE(@finalTR, '##Vaccine##', ISNULL(@tVaccineName, 'UNK'))  
   SET @finalTR = REPLACE(@finalTR, '##DATE##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @finalTR = REPLACE(@finalTR, '##STATUS##', ISNULL(@tStatus, 'UNK'))     
     
   SET @finalEntry = REPLACE(@finalEntry, '##ID##', @loopCOUNT)   
   SET @finalEntry = REPLACE(@finalEntry, '##Vaccine##', ISNULL(@tVaccineName, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Amount##', ISNULL(@tAmount, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##CVXCode##', ISNULL(@tCVXCode, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##DATE##', convert(VARCHAR(max), convert(DATETIME, @tDATE), 112))  
   SET @finalEntry = REPLACE(@finalEntry, '##Manufacturer##', ISNULL(@tManufacturer, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##LotNumber##', ISNULL(@tLotNumber, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##STATUS##', ISNULL(@tStatus, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##Note##', ISNULL(@tNote, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##RouteCodeName##', ISNULL(@tRouteCodeName, 'UNK'))  
   SET @finalEntry = REPLACE(@finalEntry, '##RouteCode##', ISNULL(@tRouteCode, 'UNK'))  
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalTR  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tVaccineName  
    ,@tAmount  
    ,@tCVXCode  
    ,@tDate  
    ,@tManufacturer  
    ,@tLotNumber  
    ,@tStatus  
    ,@tNote   
    ,@tRouteCodeName  
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


