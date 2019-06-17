IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_GetSureScriptsMedicationHistoryRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_GetSureScriptsMedicationHistoryRequest]
GO

-- =============================================
-- Author:		Wasif Butt
-- Create date: Oct 10, 2014
-- Description:	Retrieves data for Medication History Request
-- Date			Modified By			Purpose
-- 10/15/2014	Wasif Butt			
-- 1/12/2015	Wasif Butt		Added check for missing address from eligibility response
-- 1/28/2015	Wasif Butt		Fixed the length of patientId field
-- 2/05/2015	Wasif Butt		Patient consent logic.
-- 1/26/2017	Wasif Butt		Limit to clients with valid consent to check medication history
-- =============================================
CREATE PROCEDURE [dbo].[ssp_GetSureScriptsMedicationHistoryRequest]
AS 
	BEGIN
  
		DECLARE	@TodaysDate DATETIME = GETDATE();
		DECLARE	@MessageIdSegment VARCHAR(14) = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(14), @TodaysDate, 120),
															  '-', ''), ':',
															  ''), ' ', '');
		DECLARE	@EffectiveDateStart VARCHAR(10) = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(10), DATEADD(YY,
															  -2, @TodaysDate), 120),
															  '-', ''), ':',
															  ''), ' ', '');
		DECLARE	@EffectiveDateEnd VARCHAR(10) = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(10), @TodaysDate, 120),
															  '-', ''), ':',
															  ''), ' ', '');
		-- Y= Consent Given, N= No Consent, P= Only history that the prescriber provided, 
		-- X= Parent Guardian consent, Z same as X but only for prescriber
		DECLARE	@Consent VARCHAR(1) = 'Y'; 


		WITH	responses
				  AS ( SELECT	SureScriptsEligibilityResponseId,
								ClientId,
								ResponseDate,
								SegmentControlNumber,
								CAST(clientid AS VARCHAR(30))
								+ @MessageIdSegment AS messageid,
								CAST(ResponseMessage AS XML) AS response,
								CAST(SegmentControlNumber AS INT) AS segmentcontrolnumbervalue
					   FROM		SureScriptsEligibilityResponse as sser
					   WHERE	status = 1
								AND ResponseDate > DATEADD(dd, -3, GETDATE())
								and isnull(sser.RecordDeleted, 'N') = 'N'
								and not exists (
								select 1 from dbo.SureScriptsMedicationHistoryResponse as ssmhr where ClientId = sser.ClientId and isnull(ssmhr.RecordDeleted, 'N') = 'N' and Status = 1 and ResponseDate > dateadd(dd,-3,getdate())
								)
								and exists (
								select 1 from dbo.MedicationHistoryRequestConsents as mhrc where mhrc.ClientId = sser.ClientId and isnull(mhrc.RecordDeleted, 'N') = 'N' and mhrc.StartDate is not null and getdate() between mhrc.StartDate and mhrc.EndDate
								)
					 ) ,
				responsewithclientphone
				  AS ( SELECT	SureScriptsEligibilityResponseId,
								r.ClientId,
								ResponseDate,
								SegmentControlNumber,
								messageid,
								response,
								segmentcontrolnumbervalue,
								ISNULL(PhoneNumberText,
									   REPLACE(REPLACE(REPLACE(REPLACE(PhoneNumber,
															  '-', ''), '(',
															  ''), ')', ''),
											   ' ', '')) AS PatientPhone,
								ROW_NUMBER() OVER ( PARTITION BY SureScriptsEligibilityResponseId ORDER BY SureScriptsEligibilityResponseId ) AS rowid
					   FROM		responses r
								LEFT JOIN dbo.ClientPhones cp ON ( r.clientid = cp.clientid
															  AND ISNULL(cp.RecordDeleted,
															  'N') = 'N'
															  AND ISNULL(IsPrimary,
															  'N') = 'Y'
															  )
					 ) ,
				responserows
				  AS ( SELECT	SureScriptsEligibilityResponseId,
								ClientId,
								ResponseDate,
								SegmentControlNumber,
								segmentcontrolnumbervalue,
								SUBSTRING(messageid, 1, 35) AS messageid,
								CASE WHEN response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]') = 1
									 THEN response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]',
														 'varchar(20)')
									 ELSE response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/payerid[1]',
														 'varchar(20)')
								END AS ParticipantId,
								CASE WHEN response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]') = 1
									 THEN response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]',
														 'varchar(20)')
									 ELSE response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/payerid[1]',
														 'varchar(20)')
								END AS PBMID,
								CASE WHEN response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]') = 1
									 THEN response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]',
														 'varchar(35)')
									 ELSE response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/organizationname[1]',
														 'varchar(35)')
								END AS PBMName,
								response.value('/eligibilityresponse[1]/infosource[1]/interchangecontrolnumber[1]', 'varchar(9)') AS InterchangeControlNumber,
								response.value('/eligibilityresponse[1]/inforeceiver[1]/providerid[1]',
											   'varchar(10)') AS PrescriberNPI,
								response.value('/eligibilityresponse[1]/inforeceiver[1]/provider[1]/last[1]',
											   'varchar(60)') AS PrescriberLastName,
								response.value('/eligibilityresponse[1]/inforeceiver[1]/provider[1]/first[1]',
											   'varchar(35)') AS PrescriberFirstName,
								response.value('/eligibilityresponse[1]/inforeceiver[1]/provider[1]/middle[1]',
											   'varchar(25)') AS PrescriberMiddle,
								response.value('/eligibilityresponse[1]/inforeceiver[1]/provider[1]/suffix[1]',
											   'varchar(10)') AS PrescriberSuffix,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/SubscriberRelationship[1]/Relationship[1]/@code',
											   'varchar(2)') AS PatientRelationshipCode,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/last[1]',
											   'varchar(35)') AS PatientLastName,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/first[1]',
											   'varchar(35)') AS PatientFirstName,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/middle[1]',
											   'varchar(35)') AS PatientMiddleName,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/suffix[1]',
											   'varchar(35)') AS PatientSuffix,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/sex[1]',
											   'varchar(1)') AS PatientGender,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/date-of-birth[1]',
											   'varchar(8)') AS PatientDOB,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/address[1]',
											   'varchar(35)') AS PatientAddress,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/city[1]',
											   'varchar(35)') AS PatientCity,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/state[1]',
											   'varchar(35)') AS PatientState,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/zip[1]',
											   'varchar(35)') AS PatientZipcode,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientid[1]',
											   'varchar(80)') AS PatientId,
								PatientPhone,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/subscriberadditionalid[referenceidentificationtype[@qualifier="HJ"]][1]/referenceidentification[1]',
											   'varchar(35)') AS CardHolderId,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/subscriberadditionalid[referenceidentificationtype[@qualifier="HJ"]][1]/identityname[1]',
											   'varchar(35)') AS CardHolderName,
								response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="6P"]]/referenceidentification').value('referenceidentification[1]',
															  'varchar(35)') AS GroupId,
								@EffectiveDateStart AS EffectiveDateStart,
								@EffectiveDateEnd AS EffectiveDateEnd,
								@Consent AS Consent
					   FROM		responsewithclientphone
					   WHERE	response.exist('/eligibilityresponse[@type="271"]') = 1
								AND response.exist('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/info[@code="1"]') = 1
								AND rowid = 1
					 )
			SELECT	SureScriptsEligibilityResponseId,
					r.ClientId,
					ResponseDate,
					SegmentControlNumber,
					segmentcontrolnumbervalue,
					messageid,
					ParticipantId,
					PBMID,
					InterchangeControlNumber,
					PBMName,
					PrescriberNPI,
					ISNULL(PrescriberLastName, '') AS PrescriberLastName,
					ISNULL(PrescriberFirstName, '') AS PrescriberFirstName,
					ISNULL(PrescriberMiddle, '') AS PrescriberMiddle,
					ISNULL(PrescriberSuffix, '') AS PrescriberSuffix,
					ISNULL(PatientRelationshipCode, '') AS PatientRelationshipCode,
					ISNULL(PatientLastName, '') AS PatientLastName,
					ISNULL(PatientFirstName, '') AS PatientFirstName,
					ISNULL(PatientMiddleName, '') AS PatientMiddleName,
					ISNULL(PatientSuffix, '') AS PatientSuffix,
					ISNULL(PatientGender, 'U') AS PatientGender,
					PatientDOB,
					ISNULL(PatientAddress, ca.Address) AS PatientAddress,
					ISNULL(PatientCity, '') AS PatientCity,
					ISNULL(PatientState, '') AS PatientState,
					ISNULL(PatientZipcode, '') AS PatientZipcode,
					PatientId,
					ISNULL(PatientPhone, '') AS PatientPhone,
					ISNULL(CardHolderId, '') AS CardHolderId,
					ISNULL(CardHolderName, '') AS CardHolderName,
					GroupId,
					EffectiveDateStart,
					EffectiveDateEnd,
					Consent,
					SUBSTRING(REPLACE(REPLACE(AgencyName, '&', 'And'), '\r\n',
									  ' '), 1, 35) AS ClinicName,
					SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(a.Address, ':',
															  ' '), '''', ' '),
											  '/', ' '), '+', ' '), 1, 35) AS ClinicAddress,
					SUBSTRING(a.City, 1, 35) AS ClinicCity,
					a.State AS ClinicState,
					ZipCode AS ClinicZipCode,
					ISNULL(ProviderId, '') AS ClinicProviderId,
					NationalProviderId AS ClinicNPI,
					REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(MainPhone, ''), ' ',
													''), '-', ''), '(', ''),
							')', '') AS ClinicPhoneNumber,
					REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(FaxNumber, ''), ' ',
													''), '-', ''), '(', ''),
							')', '') AS ClinicFaxNumber
			FROM	responserows AS r left join dbo.ClientAddresses as ca on ca.ClientId = r.clientid left join dbo.MedicationHistoryRequestConsents as mhrc on r.ClientId = mhrc.ClientId
					CROSS JOIN ( SELECT TOP ( 1 )
										AgencyName,
										AbbreviatedAgencyName,
										Address,
										City,
										State,
										ZipCode,
										ProviderId,
										NationalProviderId,
										MainPhone,
										FaxNumber
								 FROM	agency
							   ) AS a							   					
			where mhrc.StartDate is not null and getdate() between mhrc.StartDate and mhrc.EndDate
			ORDER BY clientid,
					ResponseDate,
					SegmentControlNumber
	END

GO
