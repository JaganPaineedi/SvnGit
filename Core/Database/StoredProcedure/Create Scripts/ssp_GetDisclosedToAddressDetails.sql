IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDisclosedToAddressDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetDisclosedToAddressDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetDisclosedToAddressDetails] @ClientId INT
	,@DisclosedToIdType VARCHAR(10)
	,@DisclosedToId INT
	/********************************************************************************                                        
-- Stored Procedure: dbo.[ssp_GetDisclosedToAddressDetails]                  
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
--                                        
-- Purpose: used by  Disclosure detail page to get the DisclosedTo Name,Address,Fax Details                                        
--                                        
-- Updates:                                                                                               
-- Date        Author      Purpose                                        
-- OCT/12/2015  Hemant      Added select query for ClientInformationReleases to retrieve the ReleaseToName data. 
-- Nov/10/2015  Hemant      Added logic to handle the contacts duplicated data                                   
-- Mar/1/2016   Basudev		Added code To display fax details task 613.3 Network 180 Environment Issues Tracking
-- Mar/31/2016  Lakshmi     Checking isnull condtion to the coloumns city,state and zip code, for Network 180 custamizations #613.8                            
*********************************************************************************/
AS
BEGIN
	DECLARE @stateAbbr VARCHAR(2)
	DECLARE @StateFIPS VARCHAR(2)

	IF (@DisclosedToIdType = 'C')
	BEGIN
		SELECT top 1 CC.ListAs AS 'Name'
			,CCA.[Address] + ' ' + isnull(CCA.City,'') + CASE -- Added by Lakshmi 31/03/2016
				WHEN isnull(City,'') <> ''
					THEN ', '
				ELSE ''
				END + isnull(CCA.[State],'') + ' ' + isnull(CCA.Zip,'') AS 'Address'
			,CASE 
				WHEN dbo.ssf_GetGlobalCodeNameById(CCP.PhoneType) = 'Fax'
					THEN CCP.PhoneNumber
				ELSE ''
				END AS 'Fax'
		FROM ClientContacts AS CC
		LEFT JOIN ClientContactAddresses AS CCA ON CCA.ClientContactId = CC.ClientContactId
		LEFT JOIN ClientContactPhones AS CCP ON CCP.ClientContactId = CC.ClientContactId
		and CCP.PhoneType =36
		WHERE CC.ClientId = @ClientId
			AND CC.ClientContactId = @DisclosedToId
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			order by CCP.PhoneNumber
	END
	ELSE IF (@DisclosedToIdType = 'E')
	BEGIN
		SET @StateFIPS = (
				SELECT [State]
				FROM ExternalReferralProviders
				WHERE ExternalReferralProviderId = @DisclosedToId
				)
		SET @stateAbbr = (
				SELECT StateAbbreviation
				FROM States
				WHERE StateFIPS = @StateFIPS
				)

		SELECT top 1 ISNULL(LastName, '') + CASE 
				WHEN LastName <> ''
					THEN ', '
				ELSE ''
				END + ISNULL(FirstName, NAME) AS 'Name'
			,ISNULL([Address], '') + CASE 
				WHEN [Address2] <> ''
					THEN ', '
				ELSE ''
				END + (
				ISNULL([Address2], '') + ' ' + ISNULL(City, '') + CASE 
					WHEN @stateAbbr <> ''
						OR ZipCode <> ''
						THEN ', '
					ELSE ''
					END + ISNULL(@stateAbbr, '') + ' ' + ISNULL(ZipCode, '')
				) AS 'Address'
			,Fax
		FROM ExternalReferralProviders
		WHERE ExternalReferralProviderId = @DisclosedToId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END
	ELSE IF (@DisclosedToIdType = 'CIR') -- BEGIN OCT/12/2015  Hemant
	BEGIN
DECLARE @ClientContactId INT

SELECT @ClientContactId = ClientContactId
FROM ClientContacts
WHERE ClientContactId = (
		SELECT ReleaseToId
		FROM ClientInformationReleases
		WHERE ClientInformationReleaseId = @DisclosedToId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)

IF EXISTS (
		SELECT 1
		FROM ClientContacts
		WHERE ClientContactId = @ClientContactId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	SELECT TOP 1 CC.ListAs AS 'Name'
		,CCA.[Address] + ' ' + isnull(CCA.City,'') + CASE 
			WHEN isnull(City,'') <> ''
				THEN ', '
			ELSE ''
			END + isnull(CCA.[State],'') + ' ' + isnull(CCA.Zip,'') AS 'Address'
		,CASE 
			WHEN dbo.ssf_GetGlobalCodeNameById(CCP.PhoneType) = 'Fax'
				THEN CCP.PhoneNumber
			ELSE ''
			END AS 'Fax'
	FROM ClientContacts AS CC
	LEFT JOIN ClientContactAddresses AS CCA ON CCA.ClientContactId = CC.ClientContactId
	LEFT JOIN ClientContactPhones AS CCP ON CCP.ClientContactId = CC.ClientContactId
	and CCP.PhoneType =36
	WHERE CC.ClientId = @ClientId
		AND CC.ClientContactId = @ClientContactId
		AND ISNULL(CC.RecordDeleted, 'N') = 'N'
		order by CCP.PhoneNumber
END
ELSE
BEGIN
	SELECT TOP 1 ReleaseToName AS 'Name'
		,'' AS 'Address'
		,'' AS 'FAX'
	FROM ClientInformationReleases
	WHERE ClientInformationReleaseId = @DisclosedToId
		AND ISNULL(RecordDeleted, 'N') = 'N'
END
	END -- END OCT/12/2015  Hemant
END