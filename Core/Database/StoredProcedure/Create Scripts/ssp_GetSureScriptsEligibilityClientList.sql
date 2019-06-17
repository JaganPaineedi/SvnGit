/****** Object:  StoredProcedure [dbo].[ssp_GetSureScriptsEligibilityClientList]    Script Date: 10/24/2014 1:53:54 PM ******/
DROP PROCEDURE [dbo].[ssp_GetSureScriptsEligibilityClientList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSureScriptsEligibilityClientList]    Script Date: 10/24/2014 1:53:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kneale Alpers
-- Create date: November 12, 2013
-- Description:	Retrieves a list of patients and their doctors information for Eligibility 
-- Date				Modified By			Description
-- 12/28/2015		Wasif Butt			NPI required for Eligibility request. Filter servives where clinician doesn't have NPI.
-- 6/1/2017			Wasif Butt			Eligibility can only run for medication encounter i.e the service is scheduled with a Prescriber
-- =============================================
CREATE PROCEDURE [dbo].[ssp_GetSureScriptsEligibilityClientList]
AS 
	BEGIN
		SET NOCOUNT ON;

		WITH	ClientServices
				  AS ( SELECT	s.ClientId,
								s.ClinicianId,
								s.DateOfService
					   FROM		Services AS s
								join dbo.Staff as s2 on s2.StaffId = s.ClinicianId
					   WHERE	ISNULL(s.RecordDeleted, 'N') <> 'Y'
								AND s.status = 70
								and s2.Prescriber = 'Y'
								and s2.SureScriptsPrescriberId is not null
								AND s.DateOfService BETWEEN CAST(DATEADD(mi,
															  -75, GETDATE()) AS DATE)
													AND		DATEADD(dd, 3,
															  GETDATE())
					 ) ,
				ClientsEligibiltyRequired
				  AS ( SELECT	cs.clientid,
								cs.ClinicianId,
								cs.DateOfService,
								ROW_NUMBER() OVER ( PARTITION BY cs.ClientId ORDER BY cs.ClientId, cs.DateOfService, cs.ClinicianId ) AS rowid
					   FROM		ClientServices cs
								LEFT JOIN dbo.SureScriptsEligibilityResponse sser ON ( cs.ClientId = sser.ClientId
															  AND sser.ResponseDate BETWEEN DATEADD(dd,
															  -3, GETDATE())
															  AND
															  DATEADD(hh, 1,
															  GETDATE())
															  AND sser.Status <> 0
															  )
					   WHERE	sser.SureScriptsEligibilityResponseId IS NULL
					 ) ,
				ClientsEligibiltyRequiredWithAddressInformation
				  AS ( SELECT	c.clientid,
								ISNULL(s.lastname, '') AS PhysicainLastName,
								ISNULL(s.firstname, '') AS PhysicainFirstName,
								ISNULL(s.MiddleName, '') AS PhysicainMiddleName,
								ISNULL(s.SigningSuffix, '') AS PhysicainNameSuffix,
								ISNULL(s.NationalProviderId, '') AS NPI,
								ISNULL(c.LastName, '') AS PatientLastName,
								ISNULL(c.firstname, '') AS PatientFirstName,
								ISNULL(c.MiddleName, '') AS PatientMiddleName,
								ISNULL(c.Suffix, '') AS PatientNameSuffix,
								dbo.ssf_SureScriptsAddressElement(caddr.Address,
															  1, 'Y') AS PatientAddressLine1,
								dbo.ssf_SureScriptsAddressElement(caddr.Address,
															  2, 'Y') AS PatientAddressLine2,
								ISNULL(caddr.City, '') AS PatientCity,
								ISNULL(caddr.State, '') AS PatientState,
								case when caddr.Zip is null or len(caddr.Zip) < 5 then '' when len(caddr.Zip) > 5 then substring(caddr.Zip, 1, 5) else caddr.Zip end AS PatientPostal, 
								'' AS PatientCountryCode,
								ISNULL(c.Sex, '') AS PatientNameGender,
								REPLACE(dbo.ssf_SureScriptsFormatDate(c.DOB),
										'-', '') AS PatientDOB,
								ROW_NUMBER() OVER ( PARTITION BY c.clientid ORDER BY c.clientid, caddr.ClientAddressId DESC ) AS rowid
					   FROM		ClientsEligibiltyRequired cer
								JOIN Clients c ON ( cer.ClientId = c.ClientId )
								JOIN staff s ON ( cer.ClinicianId = s.staffid and s.NationalProviderId is not null)
								LEFT JOIN ClientAddresses AS caddr ON ( cer.ClientId = caddr.ClientId
															  AND caddr.AddressType = 90
															  AND ISNULL(caddr.RecordDeleted,
															  'N') <> 'Y'
															  )
					   WHERE	cer.rowid = 1
					 )
			SELECT	clientid,
					PhysicainLastName,
					PhysicainFirstName,
					PhysicainMiddleName,
					PhysicainNameSuffix,
					NPI,
					PatientLastName,
					PatientFirstName,
					PatientMiddleName,
					PatientNameSuffix,
					PatientAddressLine1,
					PatientAddressLine2,
					PatientCity,
					PatientState,
					PatientPostal,
					PatientCountryCode,
					PatientNameGender,
					PatientDOB
			FROM	ClientsEligibiltyRequiredWithAddressInformation
			WHERE	rowid = 1


	
	END
	

GO


