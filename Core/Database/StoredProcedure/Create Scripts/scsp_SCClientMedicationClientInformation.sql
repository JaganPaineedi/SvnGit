

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[scsp_SCClientMedicationClientInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [scsp_SCClientMedicationClientInformation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCClientMedicationClientInformation] ( @ClientId INT )  
AS /******************************************************************************                          
                          
** File: Order Pages                          
                          
** Name: scsp_SCClientMedicationClientInformation  245                        
                          
** Desc: The stored procedure will return client information in HTML format.                           
                          
** This template can be customized:                          
                          
** Return values: HTML text                          
                          
**                           
                          
** Called by:  ssp_SCClientMedicationSummaryInfo                          
                          
** Parameters:                          
                          
** Input Output                          
                          
** ---------- -----------                          
                          
** @ClientId INT,                          
                          
** Auth: Rohit Verma                          
                          
** Date: Dec 02, 2008                           
                          
*******************************************************************************                          
                          
** Change History                          
                          
*******************************************************************************                          
                          
** Date: Author: Description:                          
                          
** -------- -------- -------------------------------------------                          
** 21Feb2010 Loveena Task#2896 1.9.8.9 Patient Overview Edit - Widen Client Name          
** 7/19/2011 Kneale Added the NoKnownAllergies Flag     
** March 5, 2012 Kneale Alpers added a check for record deleted for clientraces                       
** 2/1/2013  Kneale Added cursor to load Axis III description           
** 9/11/2013 dknewtson renamed a csp called by this procedure to a scsp.   
** 11/8/2013 Chuck Added HasNoMedications field            
** 1/28/2014    Kalpers Added Eligibility  
** 1/24/2014    Kalpers added Eligibility Response
** 1/26/2014    Kalpers	added code to break the eligibility response xml into table rows
** 2/20/2014    Kalpers added code to generate the FormularyRequest
** 10/17/2014	Wasif	fixed the formulary xml elements to proper varchar length
** 10/24/2014	Wasif	Merging formulary changes
** 01/12/2015	Wasif	Demographic check in system from eligibility response
** 01/28/2015	Wasif	Only check demographics if eligibility response was sucessful and had data
** 20/July/2015	Malathi Shiva		Included ICD 10 changes
** 07/Aug/2015	Malathi Shiva	WRT Summit Pointe- Support 567, Data model change from  DocumentDiagnosisCodes.DSMVCodeId to DocumentDiagnosisCodes.ICD10CodeId, Patient Summary was not loading the data
** 11/Aug/2015  Malathi Shiva   WRT Core Bugs 1862, Displayed the latest signed Diagnosis document, If there is no ICD10 diagnosis it takes from Axis I/II
** 8/21/2015	Wasif	Adding DOB demographics check
** 8/24/2015	Wasif	Formulary Merge
** 10/27/2015   Malathi Shiva Added TOP 1 to get the latest DocumentVersionId since the diagnosis document can be created from multiple documents
** 10/Nov/15	Vithobha Added ClientRaces.RaceId IS NOT NULL check, Philhaven - Customization Issues Tracking: #1452 RX-Race mismatch  
** 01/07/2016	Wasif	Engineering Improvement Initiatives- NBL(I) > Tasks#276 > Drug Formulary - System Config
** 15/Feb/2015	Malathi Shiva When we modify an existing Diagnosis document, It was not pulling the latest Diagnosis into Patient summary because the latest version Id would be lesser but the modified date will be latest, Added Order By to get the latest DocumentVersionId by ModifiedDate which was existing in SC - Client Summary sp
** 3/Mar/2016	Malathi Shiva Camino - Customization: Task# 50 - Diagnosis label is modified, Race/Sex fields are removed, Client's Primary Coverage Plan/ Client Primary Pharmacy is added
** 11/Mar/2016	Malathi Shiva Changed to DisplayAs instead of CoveragePlanName because the name is too big to be displayed in the Patient Summary      
** 11/Mar/2016	Malathi Shiva RecordDeleted check is added to ClientPharmacies table to get the Client's Latest Pharmacy   
** 25/May/2016	Malathi Shiva Modified Races to display "Multi Race" Pines - Support: Task# 654
** 31/May/2017	Wasif Butt	Modified to display most recently available Eligibility, Medication History and Formulary data and not limited to 72 hours.
** 11/July/2017	K.Soujanya	Modified to display all 3 ClientPharmacies in the Patient Summary  ref to Network180-Enhancements #79
/* 12/OCT/2017  Himmat   Keypoint SGL- Current documentversion not same in RX and SC */
/* 21/NOV/2017  Nandita   Harbor Support- Current documentversion not same in RX and SC*/
/* 18/June/2018	Vithobha	Corrected the logic to get the ResponseMessage from SureScriptsMedicationHistoryResponse for Key Point - Support Go Live: #1307*/ 
/* 24/July/2018	Malathi Shiva Narx Scores and Narx Alert message is implemented as part of Multi-Customer Project: #2 */ 
/* 30/July/2018	Anto    Modified the sp to concat ScoreType and ScoreValue making it compatible with 2008 SQL Server database - Multi-Customer Project: #2 */ 
/* 23/Jan/2019  PranayB  Changed Order by 1 to Oder by PMPAuditTrailId w.r.t  Allegan SGL- 1525 */
*******************************************************************************/                          
               
    BEGIN     
    BEGIN TRY                     
                          
        DECLARE @ClientName VARCHAR(30)                          
        DECLARE @Dob DATETIME                          
        DECLARE @Sex VARCHAR(1)                          
        DECLARE @Race VARCHAR(4000) 
        DECLARE @ClientPharmacy VARCHAR(1000)--Increased length --11/July/2017  K.Soujanya                         
        DECLARE @ClientPrimaryPlan VARCHAR(250)                           
--declare @Diagnosis varchar(4000)                          
        DECLARE @AxisIII NVARCHAR(4000)    
        DECLARE @ICD10 NVARCHAR(4000)                           
        DECLARE @LastMedicationVisit VARCHAR(1000)                          
        DECLARE @NextMedicationVisit VARCHAR(1000)                 
        DECLARE @AxisI NVARCHAR(4000)                
        DECLARE @AxisII NVARCHAR(4000)         
        DECLARE @NoKnownAllergies CHAR(1)      
        DECLARE @HasNoMedications CHAR(1)               
 --Added bt Loveena in ref to Task#3265  
        DECLARE @ClientInformationLabel VARCHAR(2000)       
        --DECLARE @Races VARCHAR(2000)  
                          
        SET @ClientName = ''                          
        SET @Dob = ''                          
        SET @Sex = ''                          
        SET @Race = '' 
        SET @ClientPharmacy = ''                      
        SET @ClientPrimaryPlan = ''                 
--set @Diagnosis =''                           
        SET @AxisIII = ''      
        SET @ICD10 = ''                          
        SET @LastMedicationVisit = ''                           
        SET @NextMedicationVisit = ''                 
        SET @AxisI = ''                
        SET @AxisII = ''                         
                          
        SELECT  @ClientName = LEFT(clients.LastName + ', ' + clients.FirstName,  
                                   35) ,              
         --        + CASE WHEN clients.ExternalClientId IS NOT NULL  
             --          THEN ' (' + clients.ExternalClientId + ')'  
              --         ELSE ''  
              --    END ,  
                @Dob = clients.dob ,  
                @Sex = clients.Sex ,  
                @Race = CASE WHEN ( SELECT  COUNT(ClientId)  
                                    FROM    ClientRaces  
                                    WHERE   ClientRaces.ClientId = @ClientId  
									AND ClientRaces.RaceId IS NOT NULL  
                                            AND ISNULL(ClientRaces.RecordDeleted,  
                                                       'N') = 'N'  
                                  ) > 1 THEN 'Multi-Racial'  
                             ELSE LEFT(LTRIM(RTRIM(gc.CodeName)), 20)  
                        END ,  
                @NoKnownAllergies = ISNULL(clients.NoKnownAllergies, 'N') ,  
                @HasNoMedications = ISNULL(clients.HasNoMedications, 'N')  
        FROM    Clients clients  
                LEFT JOIN ClientRaces CR ON CR.Clientid = clients.ClientId  
                                            AND ISNULL(CR.RecordDeleted, 'N') = 'N'  
                LEFT JOIN GlobalCodes gc ON gc.GlobalCodeID = CR.RaceId  
                LEFT JOIN Staff staff ON staff.StaffId = clients.PrimaryClinicianId  
                LEFT JOIN ClientAddresses clientAdd ON clients.ClientId = clientAdd.ClientId  
                                                       AND clientAdd.Addresstype = 90  
                                                       AND ISNULL(clientAdd.RecordDeleted,  
                                                              'N') = 'N'  
        WHERE   ISNULL(clients.RecordDeleted, 'N') <> 'Y'  
                AND clients.ClientId = @ClientId     
                
        SELECT TOP 1 @ClientPrimaryPlan = DisplayAs
		FROM Clients C LEFT JOIN
		(
			SELECT CCH.COBOrder,CCP.ClientId, CP.CoveragePlanName,CP.DisplayAs,CCH.StartDate,CCH.EndDate FROM
			ClientCoveragePlans CCP 
			INNER JOIN ClientCoverageHistory CCH ON cch.ClientCoveragePlanId=CCP.ClientCoveragePlanId AND ISNULL(CCP.RecordDeleted,'N')<>'Y' 
			INNER JOIN CoveragePlans CP ON CP.CoveragePlanId=ccp.CoveragePlanId AND ISNULL(CCH.RecordDeleted,'N')<>'Y'
			where (CCH.EndDate >= GETDATE() OR CCH.EndDate ='' OR  CCH.EndDate IS NULL)  
		) T ON C.ClientId= t.ClientId
		WHERE c.ClientId=@ClientId AND ISNULL(C.RecordDeleted,'N')<>'Y'
		AND C.Active='Y'
		ORDER BY COBOrder,StartDate ASC   
		 --25-May-2017  K.Soujanya
         --Starts
		SET @ClientPharmacy = (SELECT ISNULL(STUFF((SELECT top 3 '<br><span style="padding-left:64px"></span>' + ISNULL(P.[PharmacyName], '')
		FROM	[Pharmacies] AS P
				JOIN dbo.ClientPharmacies AS CP ON CP.PharmacyId = P.PharmacyId
		WHERE	ISNULL(P.RecordDeleted, 'N') = 'N' AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				AND CP.ClientId = @ClientId ORDER BY CP.SequenceNumber ASC
				 FOR XML PATH('')
             ,type ).value('.', 'nvarchar(max)'), 1, 43, ''), '') )
         --End				
                          
                          
--/******************************Get Diagnosis Info***********************************start/                          
/*for calculate maximum documenid and version for diagnosis*/                                     
--***************************************************************                                                   
--Modified in ref to DataModel Changes                    
--declare @DocumentId int, @Version int                    
        DECLARE @varCurrentDocumentVersionid INT  
        DECLARE @DSM5DOC CHAR(1) 
          
--select @Documentid = docs1.DocumentId, @Version = docs1.CurrentVersion                                                  
        SELECT  TOP 1 @varCurrentDocumentVersionid = docs1.CurrentDocumentVersionId ,@DSM5DOC=ISNULL(DC.DSMV,'N') 
        FROM    Documents docs1 
        INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = docs1.DocumentCodeid
        INNER JOIN DocumentDiagnosis AS DDC ON docs1.CurrentDocumentVersionId = DDC.DocumentVersionId     
    
        WHERE   docs1.ClientId = @ClientId  
                --AND docs1.DocumentCodeId in (5,1601)
                AND docs1.Status = 22  
                AND ISNULL(docs1.RecordDeleted, 'N') = 'N' 
                AND Dc.DiagnosisDocument = 'Y'  
                AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                AND ISNULL(DDC.RecordDeleted,'N')<>'Y' 
                AND NOT EXISTS ( SELECT *  
                                 FROM   Documents docs2  
                                 INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = docs2.DocumentCodeid
                                 INNER JOIN DocumentDiagnosis AS DDC ON docs2.CurrentDocumentVersionId = DDC.DocumentVersionId     
     
                                 WHERE  docs2.ClientId = @ClientId  
                                        --AND docs2.DocumentCodeId in (5,1601)
                                        AND docs2.Status = 22 
                                        AND Dc.DiagnosisDocument = 'Y'  
										AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y' 
                                        AND docs2.EffectiveDate > docs1.EffectiveDate  
                                        AND ISNULL(docs2.RecordDeleted, 'N') = 'N' 
                                        AND ISNULL(DDC.RecordDeleted,'N')<>'Y'
                                        ) 
                                               
          ORDER BY docs1.EffectiveDate DESC ,  
				docs1.ModifiedDate DESC       
                                        
     IF EXISTS (select 1 from DiagnosesIandII where DocumentVersionId = @varCurrentDocumentVersionid)
     BEGIN
		SET @DSM5DOC = 'N'
     END
     IF EXISTS (select 1 from DocumentDiagnosisCodes where DocumentVersionId = @varCurrentDocumentVersionid)
     BEGIN
		SET @DSM5DOC = 'Y'
	 END                                          
                    
-- Axis I                    
        DECLARE @dxDesc VARCHAR(1000)                    
-- build the @AxisI string                    
        DECLARE cDiag CURSOR  
        FOR  
           SELECT  DSMDescription FROM (
			SELECT  dsc.DSMCode  
                    + CASE WHEN ISNULL(dx.RuleOut, 'N') = 'Y' THEN ' (R/O)'  
                           ELSE ''  
                      END + ' - ' + dsc.DSMDescription AS DSMDescription , dx.DiagnosisOrder 
            FROM    DiagnosesIandII AS dx  
                    JOIN DiagnosisDSMDescriptions AS dsc ON dsc.DSMCode = dx.DSMCode  
                                                            AND dsc.DSMNumber = dx.DSMNumber  
            WHERE   dx.DocumentVersionId = @varCurrentDocumentVersionid  
                    AND dx.Axis in( 1, 2)  
                    AND ISNULL(dx.RecordDeleted, 'N') <> 'Y'  
			UNION            
            SELECT  CASE WHEN dsc.ICDDescription IS NOT NULL  
                         THEN dsc.ICDCode + ' - ' + dsc.ICDDescription  
                              + '<br>'  
                         ELSE ''  
                    END as DSMDescription, 100
            FROM    DiagnosesIIICodes AS dx  
                    LEFT OUTER JOIN DiagnosisICDCodes AS dsc ON dsc.ICDCode = dx.ICDCode  
            WHERE   dx.DocumentVersionId = @varCurrentDocumentVersionid 

		 ) result
		ORDER BY DiagnosisOrder                 
                    
                    
        OPEN cDiag                    
        FETCH cDiag INTO @dxDesc                    
                    
        WHILE @@fetch_status = 0   
            BEGIN                    
                SET @AxisI = @AxisI + @dxDesc + '<br>'                    
                FETCH cDiag INTO @dxDesc                    
                    
            END                    
                    
        CLOSE cDiag                    
        DEALLOCATE cDiag                    
                
-- ICD 10               
        DECLARE @dxDescICD10 VARCHAR(MAX)  
        SET @ICD10 = ''  
        DECLARE cDiagICD10 CURSOR  
        FOR  
            SELECT  CASE WHEN DSM.ICDDescription IS NOT NULL  
                         THEN D.ICD10Code + ' - ' + DSM.ICDDescription  
                              + '<br>'  
                         ELSE ''  
                    END  
            FROM    DocumentDiagnosisCodes AS D 
            INNER JOIN DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId
            WHERE (D.DocumentVersionId = @varCurrentdocumentVersionId) AND (ISNULL(D.RecordDeleted, 'N') = 'N')                
                          
        OPEN cDiagICD10  
        FETCH cDiagICD10 INTO @dxDescICD10  
        WHILE @@FETCH_STATUS = 0   
            BEGIN   
                SET @ICD10 = @ICD10 + @dxDescICD10  
                FETCH cDiagICD10 INTO @dxDescICD10  
            END           
        CLOSE cDiagICD10  
        DEALLOCATE cDiagICD10   
                                  
-- Get last/next Medication visits                    
        EXEC scsp_MMGetLastNextMedicationVisits @ClientId,  
            @LastMedicationVisit OUTPUT, @NextMedicationVisit OUTPUT                    
                
        declare @ClientDemographicsXML varchar(max)

        set @ClientDemographicsXML = ( select top 1
                                                firstname
                                              , middlename
                                              , lastname
                                              , dob
                                              , case when sex = 'M' then 'Male' when sex = 'F' then 'Female' when sex = 'U' then 'Unknown' end sex 
                                              , suffix
                                              , address
                                              , city
                                              , state
                                              , zip
                                       from     clients
                                                join clientaddresses on clients.clientid = clientaddresses.clientid
                                       where    addresstype = 90
                                                and clients.clientid = @ClientId
                                     for
                                       xml auto
                                         , elements
                                     )

        declare @ClientEligibilityXML as nvarchar(max)
          , @responseEligibility varchar(max);
        with    responses
                  as ( select  ResponseMessage
                              , row_number() over ( order by cast(sser.segmentcontrolnumber as int) ) as rownumber
                              , cast(sser.segmentcontrolnumber as int) as segmentcontrolnumbervalue
                       from     dbo.SureScriptsEligibilityResponse as sser
                       where    sser.clientid = @ClientId
                                and sser.status <> 0
								and isnull(sser.RecordDeleted, 'N') = 'N'
								and not exists (select * from dbo.SureScriptsEligibilityResponse as sser2 where sser2.clientid = @ClientId
                                and sser2.status <> 0
								and isnull(sser2.RecordDeleted, 'N') = 'N' and sser2.SureScriptsEligibilityId > sser.SureScriptsEligibilityId)
                     ) ,
                response
                  as ( select   segmentcontrolnumbervalue
                              , rownumber
                              , ResponseMessage
                       from     responses
                       where    segmentcontrolnumbervalue = 1
                       union all
                       select   a.segmentcontrolnumbervalue
                              , a.rownumber
                              , b.ResponseMessage + a.ResponseMessage as ResponseMessage
                       from     responses a
                                join response b on ( a.rownumber = ( b.rownumber
                                                              + 1 ) )
                     )
            select top ( 1 )
                    @ClientEligibilityXML = '<eligibilityresponses>'
                    + ResponseMessage + '</eligibilityresponses>'
                  , @responseEligibility = ResponseMessage
            from    response
            order by rownumber desc
		           
        if @responseEligibility is not null 
            begin 
	--Check for demographic changes 

                declare @eligibilityXML xml = convert(xml, @ClientEligibilityXML)
                declare @eligibilityValue varchar(max)
                declare @demographicValue varchar(max)
                declare @modify varchar(max)
				declare @loop int = 0 
				

		select @loop = @eligibilityXML.value('count(eligibilityresponses/eligibilityresponse)', 'int')

		while @loop > 0
		begin

-- Check first name

                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/first)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/firstname)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/first/text())[1]
  with sql:variable("@modify") ')
                    end

-- Check last name

                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/last)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/lastname)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/last/text())[1]
  with sql:variable("@modify") ')
                    end

-- Check middle name

                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/middle)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/middlename)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/middle/text())[1]
  with sql:variable("@modify") ')
                    end



-- Check address
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/address)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/clientaddresses/address)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/address/text())[1]
  with sql:variable("@modify") ')
                    end

-- Check address 2
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/address2)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/clientaddresses/address2)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/address2/text())[1]
  with sql:variable("@modify") ')
                    end
                    
-- Check City
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/city)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/clientaddresses/city)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/city/text())[1]
  with sql:variable("@modify") ')
                    end

-- Check state
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/state)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/clientaddresses/state)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/state/text())[1]
  with sql:variable("@modify") ')
                    end

-- Check Zip
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/zip)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/clientaddresses/zip)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientaddress/zip/text())[1]
  with sql:variable("@modify") ')
                    end

-- Suffix
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/suffix)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/suffix)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/patientname/suffix/text())[1]
  with sql:variable("@modify") ')
                    end

-- Check gender
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/sex)[1]',
                                                              'varchar(max)')
                select  @demographicValue = convert(xml, @ClientDemographicsXML).value('(clients/sex)[1]',
                                                              'varchar(max)')

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/sex/text())[1]
  with sql:variable("@modify") ')
                    end


-- Check date of birth
                select  @eligibilityValue = @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/date-of-birth)[1]',
                                                              'varchar(max)')
                select  @demographicValue = left(replace(convert(xml, @ClientDemographicsXML).value('(clients/dob)[1]',
                                                              'varchar(max)'), '-', ''), 8)

                if isnull(@eligibilityValue, '') <> isnull(@demographicValue, '') 
                    begin 
                        set @modify = '*' + @eligibilityValue + '' 

                        set @eligibilityXML.modify('replace value of (eligibilityresponses/eligibilityresponse[sql:variable("@loop")]/subscriber/patient/date-of-birth/text())[1]
  with sql:variable("@modify") ')
                    end

set @loop = @loop - 1
end

                set @ClientEligibilityXML = convert(varchar(max), @eligibilityXML)

            end
/* 18 June 2018	Vithobha	Corrected the logic to get the ResponseMessage from SureScriptsMedicationHistoryResponse for Key Point - Support Go Live: #1307*/             
        declare @MedicationHistoryXML as nvarchar(max)
          , @responseHistory varchar(max);
        with    responses
                  as ( select  ssmhr.ResponseMessage
                              , row_number() over ( order by cast(ssmhr.segmentcontrolnumber as int) ) as rownumber
                              , cast(ssmhr.segmentcontrolnumber as int) as segmentcontrolnumbervalue
                       from     dbo.SureScriptsMedicationHistoryResponse ssmhr
                       where    ssmhr.clientid = @ClientId
                                and ssmhr.status <> 0
								and isnull(ssmhr.RecordDeleted, 'N') = 'N'
								and not exists (
								select * from dbo.SureScriptsMedicationHistoryResponse as ssmhr2 where ssmhr2.clientid = @ClientId
                                and ssmhr2.status <> 0
								and isnull(ssmhr2.RecordDeleted, 'N') = 'N'
								and convert(date, ssmhr.ResponseDate) < convert(date, ssmhr2.ResponseDate)
								)
                     ) ,
                response
                  as ( select   segmentcontrolnumbervalue
                              , rownumber
                              , ResponseMessage
                       from     responses
                       where    rownumber = 1
                       union all
                       select   a.segmentcontrolnumbervalue
                              , a.rownumber
                              , b.ResponseMessage + a.ResponseMessage as ResponseMessage
                       from     responses a
                                join response b on ( a.rownumber = ( b.rownumber
                                                              + 1 ) )
                     )
            select top ( 1 )
                    @MedicationHistoryXML = '<MedicationHistoryResponses>'
                    + ResponseMessage + '</MedicationHistoryResponses>'
                  , @responseHistory = ResponseMessage
            from    response
            order by rownumber desc


        if @responseHistory is not null 
            begin      

                declare @middlename xml
                select  @middlename = '<MiddleName>' + @eligibilityXML.value('(eligibilityresponses/eligibilityresponse[1]/subscriber/patient/patientname/middle)[1]',
                                                              'varchar(max)')
                        + '</MiddleName>'

                declare @xmlMedHistory xml = convert(xml, @MedicationHistoryXML)

                set @xmlMedHistory.modify('insert sql:variable("@middlename") as first into (MedicationHistoryResponses/MedicationHistory[1]/RxHistoryResponse[1]/Patient/Name)[1]')

                set @MedicationHistoryXML = convert(varchar(max), @xmlMedHistory)

            end
           
        DECLARE @ClientInfoHtml AS NVARCHAR(MAX)  
        
         if(@DSM5DOC = 'N')
        BEGIN  
				SELECT  @ClientInfoHtml = Value  
			FROM SystemConfigurationKeys WHERE [Key] = 'RXPatientSummaryTemplate'
        END     
        ELSE
        BEGIN
		SELECT  @ClientInfoHtml = Value  
			FROM SystemConfigurationKeys WHERE [Key] = 'RXPatientSummaryTemplateICD10'  
        END                  
                          
                    
                          
        IF ( @ClientInfoHtml IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkPatientNameText', '')                      
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkPatientNameText',  
                                          @ClientName)                            
                          
        IF ( @Dob IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkPatientDOBText', '')                                 
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkPatientDOBText',  
                                          CONVERT(VARCHAR(10), @dob, 101)  
                                          + ' ('  
                                          + CONVERT(VARCHAR(4), DATEDIFF("d",  
                                                              @dob, GETDATE())  
                                          / 365) + ')')                           
                          
        IF ( @ClientPrimaryPlan IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml, 'HyperLinkClientPrimaryPlanText',  
                                          '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml, 'HyperLinkClientPrimaryPlanText',  
                                          @ClientPrimaryPlan)                            
                          
        IF ( @ClientPharmacy IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml, 'HyperlinkClientPharmacyText',  
                                          '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                                      'HyperlinkClientPharmacyText',  
                                                      @ClientPharmacy)                          
                          
        IF ( @AxisI IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperlinkAxisIText', '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperlinkAxisIText', @AxisI)    
                                          
         
         DECLARE @CurrentDate VARCHAR(10)
         DECLARE @combinedScore VARCHAR(MAX)
         DECLARE @AlertFlag VARCHAR(MAX)
         
          SELECT TOP 1 @CurrentDate =  CONVERT(VARCHAR(10), PM.CreatedDate, 101)   
          FROM PMPAuditTrails PM	
          WHERE PM.ClientId = @ClientId AND ISNULL(Pm.RecordDeleted, 'N') = 'N' 
          ORDER BY pm.PMPAuditTrailId DESC
          
                 IF ( @CurrentDate IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkCurrentDate', '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkCurrentDate', 'Date: '+@CurrentDate)
                       
		 SELECT @combinedScore = COALESCE(@combinedScore + '        ', '      ') + isnull(CN.ScoreType,'') + ': ' + isnull(CAST(CN.ScoreValue AS VARCHAR),'')
		 FROM   ClientNarxScores CN 
         WHERE  CN.PMPAuditTrailId = 
         (SELECT TOP 1 PMPAuditTrailId FROM PMPAuditTrails	WHERE ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY PMPAuditTrailId DESC)
               IF ( @combinedScore IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkScores', '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkScores', @combinedScore)          
                                             
          
		 SELECT @AlertFlag = COALESCE(@AlertFlag, '') + CN.MessageText
		 FROM   ClientNarxMessages CN 
         WHERE  CN.PMPAuditTrailId = 
         (SELECT TOP 1 PMPAuditTrailId FROM PMPAuditTrails	WHERE ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY PMPAuditTrailId DESC)
                 AND MessageType = 'RedFlag'
                 AND ISNULL(CN.RecordDeleted, 'N') = 'N'
              IF ( @AlertFlag IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'AlertFlag', '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'AlertFlag', @AlertFlag)                                                                                  
             
                                          
               

  
       IF ( @ICD10 IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkICD10Text', '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkICD10Text', @ICD10)                            
                          
        IF ( @LastMedicationVisit IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkLastMedicationVisitText',  
                                          '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkLastMedicationVisitText',  
                                          @LastMedicationVisit)                            
                          
                          
        IF ( @NextMedicationVisit IS NULL )   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkNextMedicationVisitText',  
                                          '')                            
        ELSE   
            SET @ClientInfoHtml = REPLACE(@ClientInfoHtml,  
                                          'HyperLinkNextMedicationVisitText',  
                                          @NextMedicationVisit)                            
                          
        SELECT  @ClientInfoHtml AS ClientInformationHTMLOutput   
				, isnull(@ClientEligibilityXML, '') as CLientEligibilityXML
				, isnull(@MedicationHistoryXML, '') as MedicationHistoryXML  
				--, isnull(@ClientDemographicsXML, '') as ClientDemographicsXML  
				
--Added in ref to Task#3265                       
        SELECT  @ClientInformationLabel = ISNULL(LTRIM(RTRIM(c.LastName)), '')  
                + ', ' + ISNULL(LTRIM(RTRIM(c.FirstName)), '') + ' ('  
                + ISNULL(LTRIM(RTRIM(c.ExternalClientId)),  
                         CAST(c.ClientId AS VARCHAR)) + ')' + ', DOB: '  
                + ISNULL(CAST(DATEPART(month, c.DOB) AS VARCHAR) + '/'  
                         + CAST(DATEPART(day, c.DOB) AS VARCHAR) + '/'  
                         + CAST(DATEPART(year, c.DOB) AS VARCHAR), '')  
                + ', Sex: ' + ISNULL(c.Sex, 'U')  
        FROM    Clients AS c  
        WHERE   c.ClientId = @ClientId  

        IF @Race IS NOT NULL   
            SET @ClientInformationLabel = @ClientInformationLabel + ', Race: ' + @Race                  
          
     SELECT  @ClientName AS ClientName ,  
                @Dob AS Dob ,  
                @Sex AS Sex ,  
                @Race AS ClientRace ,  
                @ClientInformationLabel AS ClientInformationLabel ,  
                @NoKnownAllergies AS NoKnownAllergies ,  
                @HasNoMedications AS HasNoMedications;  
          
         declare @TodaysDate datetime = getdate();
		 
        with    responses
                  as ( 	select  sser.ClientId
                              , cast(ResponseMessage as xml) as response
                              , cast(segmentcontrolnumber as int) as segmentcontrolnumbervalue
                       from     dbo.SureScriptsEligibilityResponse as sser
                       where    sser.clientid = @ClientId
                                and sser.status <> 0
								and isnull(sser.RecordDeleted, 'N') = 'N'
								and isnull((select sck.Value from dbo.SystemConfigurationKeys as sck where sck.[Key] = 'RxEnableFormulary'), 'N') = 'Y'
								and not exists (select * from dbo.SureScriptsEligibilityResponse as sser2 where sser2.clientid = @ClientId
                                and sser2.status <> 0
								and isnull(sser2.RecordDeleted, 'N') = 'N' 
								and isnull((select sck.Value from dbo.SystemConfigurationKeys as sck where sck.[Key] = 'RxEnableFormulary'), 'N') = 'Y'
								and sser2.SureScriptsEligibilityId > sser.SureScriptsEligibilityId
								)

                     ) ,
                responserows
                  as ( select   segmentcontrolnumbervalue
                              , case when response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]') = 1
                                     then response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]',
                                                         'varchar(50)')
                                     else response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/payerid[1]',
                                                         'varchar(50)')
                                end as PARTICIPANT_ID
                              , case when response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]') = 1
                                     then response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]',
                                                         'varchar(50)')
                                     else response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/organizationname[1]',
                                                         'varchar(50)')
                                end as PBM_NAME
                              , response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="FO"]]/referenceidentification').value('referenceidentification[1]',
                                                              'varchar(100)') as FORMULARY_ID
                              , response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="CLI"]]/referenceidentification').value('referenceidentification[1]',
                                                              'varchar(100)') as COVERAGE_ID
                              , response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="IG"]]/referenceidentification').value('referenceidentification[1]',
                                                              'varchar(100)') as COPAY_ID
                              , response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="ALS"]]/referenceidentification').value('referenceidentification[1]',
                                                              'varchar(100)') as ALTERNATE_ID
                              , response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/plancoveragedescription').value('plancoveragedescription[1]',
                                                              'varchar(100)') as HEALTH_PLAN_ID
                              , response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="N6"]]/pcnnumber').value('referenceidentification[1]',
                                                              'varchar(100)') as PCN
                              , response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="N6"]]/referenceidentification').value('referenceidentification[1]',
                                                              'varchar(100)') as BIN
                              , response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientid[1]',
                                               'varchar(100)') as PP_UNIQUE_ID
                              , response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/date-of-birth[1]',
                                               'datetime') as DATE_OF_BIRTH
                              , response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/sex[1]',
                                               'char(1)') as GENDER
                       from     responses
                       where    response.exist('/eligibilityresponse[@type="271"]') = 1
                                and response.exist('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/info[@code="1"]') = 1
                                and clientid = @ClientId
                     ) ,
                formattedrows
                  as ( select   segmentcontrolnumbervalue
                              , DATE_OF_BIRTH
                              , GENDER
                              , cast('<Coverage><COVERAGE_REQ_ID>'
                                + cast(segmentcontrolnumbervalue as varchar(20))
                                + '</COVERAGE_REQ_ID><PARTICIPANT_ID>'
                                + isnull(PARTICIPANT_ID, '')
                                + '</PARTICIPANT_ID><PBM_NAME>'
                                + isnull(PBM_NAME, '')
                                + '</PBM_NAME><FORMULARY_ID>'
                                + isnull(FORMULARY_ID, '')
                                + '</FORMULARY_ID><COVERAGE_ID>'
                                + isnull(COVERAGE_ID, '')
                                + '</COVERAGE_ID><COPAY_ID>' + isnull(COPAY_ID,
                                                              '')
                                + '</COPAY_ID><ALTERNATE_ID>'
                                + isnull(ALTERNATE_ID, '')
                                + '</ALTERNATE_ID><HEALTH_PLAN_ID>'
                                + isnull(HEALTH_PLAN_ID, '')
                                + '</HEALTH_PLAN_ID><HEALTH_PLAN_NAME>'
                                + isnull(PBM_NAME, '') + ' - ' + isnull(HEALTH_PLAN_ID, '') 
                                + '</HEALTH_PLAN_NAME><PCN>' + isnull(PCN, '')
                                + '</PCN><BIN>' + isnull(BIN, '')
                                + '</BIN><PP_UNIQUE_ID>' + isnull(PP_UNIQUE_ID,
                                                              '')
                                + '</PP_UNIQUE_ID></Coverage>' as varchar(max)) as CoverageElement
                              , row_number() over ( order by segmentcontrolnumbervalue ) as rownumber
                       from     responserows
                     ) ,
                allrows
                  as ( select   segmentcontrolnumbervalue
                              , DATE_OF_BIRTH
                              , GENDER
                              , CoverageElement
                              , rownumber
                       from     formattedrows
                       where    segmentcontrolnumbervalue =  (select min(segmentcontrolnumbervalue) from formattedrows)
                       union all
                       select   a.segmentcontrolnumbervalue
                              , b.DATE_OF_BIRTH
                              , b.GENDER
                              , b.CoverageElement + a.CoverageElement as CoverageElement
                              , a.rownumber
                       from     formattedrows a
                                join allrows b on ( ( b.rownumber + 1 ) = a.rownumber )
                     )
            select top ( 1 )
                    '<FormularyRequest><ExternalMedicationNameId></ExternalMedicationNameId><ExternalMedicationId></ExternalMedicationId><GENDER>'
                    + isnull(GENDER, '') + '</GENDER><Date-Of-Birth>'
                    + convert(varchar(30), DATE_OF_BIRTH, 121)
                    + '</Date-Of-Birth>' + CoverageElement
                    + '</FormularyRequest>' as FormularyRequestXML
            from    allrows
            order by rownumber desc 

			
      --WITH    responses  
      --                AS ( SELECT   clientid ,  
      --                            CAST(ResponseMessage AS XML) AS response ,  
      --                              CAST(segmentcontrolnumber AS INT) AS segmentcontrolnumbervalue  
      --                     FROM     SureScriptsEligibilityResponse  
      --                     WHERE    ResponseDate BETWEEN DATEADD(hh, -72,  
      --                                                        GETDATE())  
      --                                           AND     GETDATE()  
      --                          --AND clientid = 62717  
      --                              AND status <> 0  
      --                   )  
      --      SELECT  CASE WHEN response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]') = 1  
      --                   THEN response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]',  
      --                                       'varchar(20)')  
      --                   ELSE response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/payerid[1]',  
      --                                       'varchar(20)')  
      --              END AS PARTICIPANT_ID ,  
      --              CASE WHEN response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]') = 1  
      --                   THEN response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]',  
      --                                       'varchar(20)')  
      --                   ELSE response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/organizationname[1]',  
      --                                       'varchar(20)')  
      --              END AS PBM_NAME ,  
      --              response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="FO"]]/referenceidentification').value('referenceidentification[1]',  
      --                                                        'varchar(10)') AS FORMULARY_ID ,  
      --              response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="CLI"]]/referenceidentification').value('referenceidentification[1]',  
      --                                                        'varchar(10)') AS COVERAGE_ID ,  
      --              response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="IG"]]/referenceidentification').value('referenceidentification[1]',  
      --                                                        'varchar(10)') AS COPAY_ID ,  
      --              response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="ALS"]]/referenceidentification').value('referenceidentification[1]',  
      --                                                        'varchar(10)') AS ALTERNATE_ID ,  
      --              response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/plancoveragedescription').value('plancoveragedescription[1]',  
      --                                                        'varchar(10)') AS HEALTH_PLAN_ID ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/last[1]',  
      --                             'varchar(50)') AS LAST_NAME ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/first[1]',  
      --                             'varchar(35)') AS FIRST_NAME ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/middle[1]',  
      --                             'varchar(35)') AS MIDDLE_NAME ,  
      --              '' AS SUFFIX ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/address[1]',  
      --                             'varchar(35)') AS ADDRESS1 ,  
      --              '' AS ADDRESS2 ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/city[1]',  
      --                             'varchar(35)') AS CITY ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/state[1]',  
      --                             'varchar(2)') AS STATE ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/zip[1]',  
      --                             'varchar(10)') AS ZIP ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/date-of-birth[1]',  
      --                             'datetime') AS DATE_OF_BIRTH ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/sex[1]',  
      --                             'char(1)') AS GENDER ,  
      --              response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="N6"]]/pcnnumber').value('referenceidentification[1]',  
      --                                                        'varchar(10)') AS PCN ,  
      --              response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="N6"]]/referenceidentification').value('referenceidentification[1]',  
      --                                                        'varchar(10)') AS BIN ,  
      --              response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientid[1]',  
      --                             'varchar(100)') AS PP_UNIQUE_ID  
      --      FROM    responses  
      --      WHERE   response.exist('/eligibilityresponse[@type="271"]') = 1  
      --              AND response.exist('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/info[@code="1"]') = 1  
      --              AND clientid = @ClientId  
  
   -- empty response query  
   --SELECT ''  
    
    
    END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'scsp_SCClientMedicationClientInformation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
        END CATCH
    END  