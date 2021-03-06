/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentJobCoachingRequest]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentJobCoachingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentJobCoachingRequest]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentJobCoachingRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE  [dbo].[csp_InitCustomDocumentJobCoachingRequest]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
AS

SELECT	TOP 1 ''CustomDocumentJobCoachingRequest'' AS TableName,
		-1 AS ''DocumentVersionId'',
		'''' as CreatedBy,
		getdate() as CreatedDate,
		'''' as ModifiedBy,
		getdate() as ModifiedDate,
		
		C.LastName,
		C.FirstName,
		C.DOB,
		
		CA.Address,
		CA.City,
		CA.State,
		RTRIM(CA.Zip) AS ''Zip'',

		Coalesce(CP.PhoneNumber, CP2.PhoneNumber, CP3.PhoneNumber) AS ''PhoneNumber'',

		CC.FirstName + '' '' + CC.LastName AS ''LegalGuardian'',
		
		dbo.csf_GetGlobalCodeNameById(CE.ReferralType) AS ''ReferralSource''

FROM		Clients C
LEFT JOIN	ClientAddresses CA
ON			C.ClientId = CA.ClientId
LEFT JOIN	ClientPhones CP
ON			C.ClientId = CP.ClientId
AND			CP.PhoneType = 30	-- Home Phone 1
LEFT JOIN	ClientPhones CP2
ON			C.ClientId = CP2.ClientId
AND			CP.PhoneType = 32	-- Home Phone 2
LEFT JOIN	ClientPhones CP3
ON			C.ClientId = CP3.ClientId
AND			CP3.PhoneType NOT IN (''30'', ''32'')	-- Home Phone 1 and 2
AND			CP3.PhoneType = (SELECT MIN(CP4.PhoneType) FROM ClientPhones CP4 WHERE CP3.ClientId = CP4.ClientId AND CP4.PhoneType NOT IN (''30'', ''32''))	-- Home Phone 1 and 2
LEFT JOIN	ClientContacts CC
ON			C.ClientId = CC.ClientId
AND			CC.Guardian = ''Y''
LEFT JOIN	ClientEpisodes CE
ON			C.ClientId = CE.ClientId
AND			C.CurrentEpisodeNumber = CE.EpisodeNumber
						
WHERE	@ClientID = C.ClientId
' 
END
GO
