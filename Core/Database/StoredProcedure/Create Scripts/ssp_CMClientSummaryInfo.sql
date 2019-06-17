/****** Object:  StoredProcedure [dbo].[ssp_CMClientSummaryInfo]    Script Date: 05/06/2014 11:48:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMClientSummaryInfo]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CMClientSummaryInfo]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMARDetails]    Script Date: 05/06/2014  11:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMClientSummaryInfo] @ClientId INT
	,@ClinicianId INT
AS
/**************************************************************************************  
** Stored Procedure: dbo.ssp_SCClientSummaryInfo      
** Copyright: 2005 Streamline Healthcare Solutions,  LLC  
** Creation Date:    05 June 2014  
** SP reference taken from SC ClientSummary screen and added CM info to this  
**   
** Purpose:It is used in CM client Summary Page Information from various tables  
**  
** Updates  
****************************************************************************************  
** Date			Author			Purpose  
****************************************************************************************  
** Modified by SuryaBalan Task 48 CM to SC Project, Added Spouse, EmergencyContact tables
-- 10.Jan.2015	Rohith			Staff Permission added for Claims & Events table. Task#491 CM to SC issues tracking.   
/*   21 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */  
--  11/Dec/2017		Sunil.Dasari   What:Added one more extra case condition to Client Sex Field to get Unknown as Sex Value.
								   Why:Client Summary: Sex is displayed as blank if it is set as 'Unknown' in client information demographic
									Core Bugs - #2457
--2nd January 2018   Manjunath K   Using @ClinicianId parameter instead of HardCoded StaffId. For Core Bugs 2477
****************************************************************************************/
DECLARE @MasterClientId INT

SELECT @MasterClientId = MasterClientId
FROM ProviderClients
INNER JOIN Clients ON Clients.ClientId = ProviderClients.ClientId
WHERE ProviderClients.ClientId = @ClientId
	AND isnull(ProviderClients.RecordDeleted, 'N') = 'N'

IF @MasterClientId IS NULL
	SET @MasterClientId = @ClientId

--Insurer table Starts-----
DECLARE @Insurers TABLE (INSURERID INT)

		INSERT INTO @Insurers (INSURERID)
		SELECT i.INSURERID
		FROM INSURERS i
		CROSS JOIN STAFF S
		WHERE S.STAFFID = @ClinicianId    --2nd January 2018   Manjunath K
			AND S.AllInsurers = 'Y'
			AND Isnull(i.RECORDDELETED, 'N') = 'N'
		
		UNION
		
		SELECT i.INSURERID
		FROM INSURERS i
		INNER JOIN STAFFINSURERS SI ON SI.INSURERID = i.INSURERID
		WHERE SI.STAFFID = @ClinicianId
			AND Isnull(i.RECORDDELETED, 'N') = 'N'
			AND Isnull(SI.RECORDDELETED, 'N') = 'N'
-- Insurer Table Ends------


---Provider Table starts
	DECLARE @Providers TABLE (ProviderId INT, ProviderType CHAR(1), ProviderName VARCHAR(100), FirstName VARCHAR(30))

		INSERT INTO @Providers (ProviderId, ProviderType, ProviderName, FirstName)
		SELECT P.ProviderId, P.ProviderType, P.ProviderName, P.FirstName
		FROM Providers P
		CROSS JOIN STAFF S
		WHERE S.STAFFID = @ClinicianId
			AND S.AllProviders = 'Y'
			AND Isnull(P.RECORDDELETED, 'N') = 'N'
		
		UNION
		
		SELECT P.ProviderId, P.ProviderType, P.ProviderName, P.FirstName
		FROM Providers P
		INNER JOIN StaffProviders SP ON SP.ProviderId = P.ProviderId
		WHERE SP.STAFFID = @ClinicianId
			AND Isnull(P.RECORDDELETED, 'N') = 'N'
			AND Isnull(SP.RECORDDELETED, 'N') = 'N'
-- Provider Table Ends

BEGIN
	BEGIN TRY
		-- Clients        
		DECLARE @later DATETIME

		SELECT @later = GETDATE()

		DECLARE @phoneNumber AS VARCHAR(200)

		SELECT @phoneNumber = COALESCE(@phoneNumber + ', ', '') + CAST(PhoneNumber AS VARCHAR(50)) + CASE 
				WHEN DoNotContact = 'Y'
					THEN ' (DNC)'
				ELSE ''
				END
		FROM clientPhones
		WHERE clientId = @ClientId
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
		ORDER BY (
				CASE 
					WHEN IsPrimary = 'Y'
						THEN 1
					ELSE 0
					END
				) DESC

		--get the Details of the client  (--CONVERT(varchar(10),DATEDIFF(year,  C.dob, getdate())) +' Year'  as Age)          
		SELECT DISTINCT   --Added by Revathi 21.Oct.2015
		(case when  ISNULL(C.ClientType,'I')='I' 
							then
									ISNULL(C.LastName,'')+', '+ ISNULL(C.FirstName,'')
							else	ISNULL(C.OrganizationName,'') end)  AS NAME
			,CONVERT(VARCHAR(10), C.dob, 101) AS DOB
			,CAST(DATEDIFF(yy, C.DOB, @later) - CASE 
					WHEN @later >= DATEADD(yy, DATEDIFF(yy, C.DOB, @later), C.DOB)
						THEN 0
					ELSE 1
					END AS VARCHAR(10)) + ' Year' AS Age
			,CASE 
				WHEN C.Sex = 'F'
					THEN 'Female'
				WHEN C.Sex = 'M'
					THEN 'Male'  
				ELSE ''
				END AS Sex
			,CASE 
				WHEN (
						SELECT COUNT(ClientId)
						FROM ClientRaces
						WHERE ClientRaces.ClientId = @ClientId
							AND ISNULL(ClientRaces.RecordDeleted, 'N') = 'N'
						) > 1
					THEN 'Multi-Racial'
				ELSE LTRIM(RTRIM(GC.CodeName))
				END AS CodeName
				--Added by Revathi 12.Oct.2015
			, (case when  ISNULL(C.ClientType,'I')='I' 
							then C.SSN else	C.EIN end) as SSN 
			,S.StaffId
			,(S.LastName + ', ' + S.FirstName) AS ClinicianName
			,@phoneNumber AS PhoneNumber
			,C.ClientId
			,CA.ClientAddressId
			,CA.AddressType
			,CA.[Address]
			,CA.City
			,CA.[State]
			,CA.[Zip]
			,CA.Display
			,CA.Billing
			,CA.RecordDeleted
			,dbo.getFeeArrangement(@ClientId) AS FeeArrangement
			,C.CareManagementId
		FROM Clients C
		LEFT JOIN ClientRaces CR ON CR.Clientid = C.ClientId
			AND ISNULL(CR.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CR.RaceId
		LEFT JOIN Staff S ON S.StaffId = C.PrimaryClinicianId
		LEFT JOIN ClientAddresses CA ON C.ClientId = CA.ClientId
			AND CA.Addresstype = 90
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(C.RecordDeleted, 'N') <> 'Y'
			AND C.ClientId = @ClientId

		--***************************************************************          
		------------------------- Notes  --------------------------------------------      
		EXEC scsp_SCClientSummaryInfoNote @ClientId

		-------------------------END of Notes  --------------------------------------------      
		--***************************************************************          
		--get the Presenting Problem from the client(Incomplete)          
		DECLARE @ExistDocCodeID INT

		SET @ExistDocCodeID = 0

		SELECT @ExistDocCodeID = MAX(DocumentCodeId)
		FROM Documents d
		WHERE ClientId = @ClientId
			AND documentCodeId IN (
				101
				,349
				,1469
				)
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND d.STATUS = 22

		--------------------Blank  -----------------------------------------------      
		SELECT ''
			,1
			,1
			,1

		--------------------END of Blank  -----------------------------------------------                
		----------------------------ClientContacts----------------------         
		SELECT (CC.LastName + ', ' + CC.Firstname + ' ' + CCP.PhoneNumber) AS NAME
		FROM Clients C
		INNER JOIN ClientContacts CC ON C.ClientID = CC.ClientID
		LEFT JOIN ClientContactPhones CCP ON CC.ClientContactID = CCP.ClientContactID
		WHERE C.ClientID = @ClientId
			AND CC.EmergencyContact = 'Y'
			AND ISNULL(cc.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'

		----------------------------END of ClientContacts----------------------          
		-----------------ClientEpisodes---------------------------------------      
		SELECT TOP 1 GC.CodeName
			,CONVERT(VARCHAR(10), CEP.RegistrationDate, 101) AS RegistrationDate
		FROM ClientEpisodes CEP
		INNER JOIN Globalcodes GC ON CEP.[Status] = GC.GlobalCodeId
		WHERE CEP.Clientid = @ClientId
			AND ISNULL(CEP.RecordDeleted, 'N') = 'N'
		ORDER BY CEP.EpisodeNumber DESC

		-----------------END of ClientEpisodes---------------------------------------      
		--------------------------Services-------------------------------------------------      
		SELECT TOP 1 CONVERT(VARCHAR(10), S.DateOfService, 101) AS DateOfService
			,S.ServiceID AS [LastSeenOnServiceId]
			,D.DocumentId AS [LastSeenOnDocumentId]
		FROM [Services] S
		LEFT JOIN Documents D ON (
				S.ServiceId = D.ServiceId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
				)
		WHERE S.clientid = @ClientId
			AND CONVERT(VARCHAR(10), S.dateOfService, 101) <= GETDATE()
			AND S.[Status] IN (
				71
				,75
				)
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		ORDER BY s.DateOfService DESC

		--------------------------END of Services-------------------------------------------------      
		--------------------------Services2-------------------------------------------------      
		SELECT TOP 1 CONVERT(VARCHAR(10), s.DateOfService, 101) AS DateOfService
			,d.Documentid [ServiceNoteDocumentID]
			,s.ServiceId [ServiceId]
			,CASE 
				WHEN (
						d.AuthorId = @ClinicianId
						OR -- Current staff is an author                                
						EXISTS (
							SELECT *
							FROM StaffProxies a
							WHERE a.ProxyForStaffId = d.AuthorId
								AND a.StaffId = @ClinicianId
								AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
							)
						OR -- Current staff is Proxy        
						d.ProxyId = @ClinicianId
						OR -- Current staff is a proxy                                
						d.STATUS IN (
							22
							,23
							)
						OR -- Document is in the final status: Signed or Cancelled                                
						d.DocumentShared = 'Y'
						) -- Document is shared           
					THEN 'Y'
				ELSE 'N'
				END AS CanViewService
		FROM [services] s
		INNER JOIN documents d ON d.serviceid = s.Serviceid
			AND ISNULL(d.RecordDeleted, 'N') = 'N'
		WHERE s.[status] = 70
			AND s.clientid = @ClientId
			AND s.DateOfService > GETDATE()
			AND dbo.RemoveTimeStamp(s.DateOfService) >= dbo.RemoveTimeStamp(GETDATE())
			AND ISNULL(s.RecordDeleted, 'N') = 'N'
		ORDER BY s.DateOfService

		--------------------------END of Services2-------------------------------------------------        
		/*----Changed The Sequence Appropriate according to the Data service table List-----------------------*/
		--------------------HRMAssessment-----------------------------------       
		EXEC scsp_SCClientSummaryInfoPresentingProblem @ClientId

		--------------------END of HRMAssessment-----------------------------------       
		----------------End for Harbor by Tom on 19 May 2011-------------------------------------------------            
		---------------------Programs------------------------------------------------            
		SELECT ProgramName
		FROM Programs
		WHERE ProgramId = (
				SELECT TOP 1 ProgramId
				FROM ClientPrograms
				WHERE clientid = @ClientId
					AND PrimaryAssignment = 'Y'
					AND STATUS <> 5
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(RecordDeleted, 'N') = 'N'

		------------------------END of Programs------------------------------------------------          
		----------------------------------Client Notes ------------------------------------------------       
		SELECT 'test' AS test --SC ClientSummary SP does not have any logic to get Client Notes information. So here client notes section with select statement.      

		--------------------------------END of Client notes---------------------------------------------------          
		--------------------------------Emergency Contact---------------------------------------------    
		SELECT TOP 1 cc.LastName + ', ' + cc.Firstname AS EmergencyContact
			,ccp.PhoneNumber
			,cc.ClientContactId
		FROM Clients c
		INNER JOIN ClientContacts cc ON cc.ClientId = c.ClientId
		LEFT JOIN ClientContactPhones ccp ON ccp.ClientContactId = cc.ClientContactId
			AND isnull(ccp.RecordDeleted, 'N') <> 'Y'
		WHERE c.ClientId = @MasterClientId
			AND cc.EmergencyContact = 'Y'
			AND isnull(cc.RecordDeleted, 'N') <> 'Y'
		ORDER BY CASE 
				WHEN ccp.PhoneType IN (
						30
						,32
						)
					THEN 1
				WHEN ccp.PhoneType IN (
						34
						,35
						)
					THEN 2
				WHEN ccp.PhoneType IN (
						31
						,33
						)
					THEN 3
				WHEN ccp.PhoneType = 37
					THEN 4
				WHEN ccp.PhoneType = 38
					THEN 5
				WHEN ccp.PhoneType = 36
					THEN 6
				ELSE 7
				END
			,cc.ClientContactId

		----------------------------------END of Emergency Contact ----------------------     
		-- ------------------------Spouse Table------------------------------------------------------                                                    
		SELECT TOP 1 cc.LastName + ', ' + cc.Firstname AS Spouse
			,ccp.PhoneNumber
			,cc.ClientContactId
		FROM Clients c
		INNER JOIN ClientContacts cc ON cc.ClientId = c.ClientId
		LEFT JOIN ClientContactPhones ccp ON ccp.ClientContactId = cc.ClientContactId
			AND isnull(ccp.RecordDeleted, 'N') <> 'Y'
		WHERE c.ClientId = @MasterClientId
			AND cc.Relationship IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent('XRelationshipSpouse')
				) --(10127, 10106)                
			AND isnull(cc.RecordDeleted, 'N') <> 'Y'
		ORDER BY CASE 
				WHEN ccp.PhoneType IN (
						30
						,32
						)
					THEN 1
				WHEN ccp.PhoneType IN (
						34
						,35
						)
					THEN 2
				WHEN ccp.PhoneType IN (
						31
						,33
						)
					THEN 3
				WHEN ccp.PhoneType = 37
					THEN 4
				WHEN ccp.PhoneType = 38
					THEN 5
				WHEN ccp.PhoneType = 36
					THEN 6
				ELSE 7
				END
			,cc.ClientContactId

		-- ------------------------END of Spouse Table------------------------------------------------------         
		------------------------ Primary Care Physician Table  --------------------------------------------------                                                  
		SELECT TOP 1 cc.LastName + ', ' + cc.Firstname AS PrimaryCarePhysician
			,ccp.PhoneNumber
			,cc.ClientContactId
		FROM Clients c
		INNER JOIN ClientContacts cc ON cc.ClientId = c.ClientId
		LEFT JOIN ClientContactPhones ccp ON ccp.ClientContactId = cc.ClientContactId
			AND isnull(ccp.RecordDeleted, 'N') = 'N'
		WHERE c.ClientId = @MasterClientId
			AND cc.Relationship IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent('XRelationshipPrimareCarePhysician')
				) --(10116)                
			AND isnull(cc.RecordDeleted, 'N') = 'N'
		ORDER BY CASE 
				WHEN ccp.PhoneType IN (
						30
						,32
						)
					THEN 1
				WHEN ccp.PhoneType IN (
						34
						,35
						)
					THEN 2
				WHEN ccp.PhoneType IN (
						31
						,33
						)
					THEN 3
				WHEN ccp.PhoneType = 37
					THEN 4
				WHEN ccp.PhoneType = 38
					THEN 5
				WHEN ccp.PhoneType = 36
					THEN 6
				ELSE 7
				END
			,cc.ClientContactId

		------------------------ END of Primary Care Physician Table  --------------------------------------------------       
		--------------------------------InpatientCaseManagerName Starts--------------------------------      
		SELECT s.DisplayAs AS InpatientCaseManagerName
			,s.StaffId
		FROM CLIENTS C
		INNER JOIN STAFF S ON S.STAFFID = c.INPATIENTCASEMANAGER
		INNER JOIN STAFFROLES SR ON SR.STAFFID = S.STAFFID
		WHERE c.CLIENTID = @ClientId
			AND SR.ROLEID = 2444
			AND Isnull(S.RECORDDELETED, 'N') <> 'Y'
			AND Isnull(SR.RECORDDELETED, 'N') <> 'Y'

		--------------------------------InpatientCaseManagerName Ends----------------------------------       
		-------------------------------- Special Rates table ------------------------------------------       
		SELECT DISTINCT c.CONTRACTID
			,c.CONTRACTNAME AS SpecialRate
		FROM CONTRACTS C
		INNER JOIN CONTRACTRATES cr ON cr.CONTRACTID = c.CONTRACTID
		WHERE cr.CLIENTID = @ClientId
			AND Isnull(cr.RECORDDELETED, 'N') = 'N'
			AND Isnull(c.RECORDDELETED, 'N') = 'N'
			AND Isnull(cr.STARTDATE, c.STARTDATE) <= Getdate()
			AND Dateadd(dd, 1, Isnull(cr.ENDDATE, c.ENDDATE)) > Getdate()

		-------------------------------- Special Rates Ends ------------------------------------------       
		-------------------------------- Claims Rates table ------------------------------------------
		SELECT TOP 10 cl.CLAIMLINEID
			,cl.TODATE
			,convert(VARCHAR, cl.ToDate, 101) + ' ' + isnull(CASE cm.ClaimType
					WHEN 2222
						THEN cl.RevenueCode
					ELSE isnull(bc.BillingCode, cl.ProcedureCode)
					END, '') + ' ' + p.ProviderName + CASE 
				WHEN p.ProviderType = 'I'
					THEN ', ' + isnull(p.FirstName, '')
				ELSE ''
				END + '  $' + convert(VARCHAR, cl.ClaimedAmount) + ' ' + gcs.CodeName AS CLAIMLINE
		FROM Claims cm
		INNER JOIN Clients c ON c.ClientId = cm.ClientId
		INNER JOIN ClaimLines cl ON cl.ClaimId = cm.ClaimId
		INNER JOIN Sites s ON s.SiteId = cm.SiteId
		INNER JOIN @Providers p ON p.ProviderId = s.ProviderId	
		INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = cl.STATUS
		LEFT JOIN BillingCodes bc ON bc.BillingCodeId = cl.BillingCodeId
		WHERE isnull(cm.RecordDeleted, 'N') = 'N'
			AND isnull(cl.RecordDeleted, 'N') = 'N'
			AND c.CLIENTID = @ClientId
		ORDER BY cl.TODATE DESC
			,cl.CLAIMLINEID

		-------------------------------- Claims Rates end ------------------------------------------       
		-------------------------------- Providers Rates table ------------------------------------------       
		SELECT p.PROVIDERID
			,p.PROVIDERNAME
		FROM (
			SELECT TOP 3 p.PROVIDERID
				,Max(p.PROVIDERNAME + CASE 
						WHEN p.PROVIDERTYPE = 'I'
							THEN ', ' + Isnull(p.FIRSTNAME, '')
						ELSE ''
						END) AS ProviderName
				,Max(cl.TODATE) AS LastDateOfService
			FROM CLAIMS cm
			INNER JOIN CLIENTS c ON c.CLIENTID = cm.CLIENTID
			INNER JOIN CLAIMLINES cl ON cl.CLAIMID = cm.CLAIMID
			INNER JOIN SITES s ON s.SITEID = cm.SITEID
			INNER JOIN PROVIDERS p ON p.PROVIDERID = s.PROVIDERID
			WHERE C.CLIENTID = @ClientId
				AND Isnull(cm.RECORDDELETED, 'N') = 'N'
				AND Isnull(cl.RECORDDELETED, 'N') = 'N'
				AND Datediff(dd, cl.TODATE, Getdate()) <= 60
			GROUP BY p.PROVIDERID
			ORDER BY LASTDATEOFSERVICE
				,PROVIDERNAME
			) AS p

		-------------------------------- Providers Rates Ends ------------------------------------------       
		-------------------------------- Events Rates table ------------------------------------------       
		SELECT TOP 10 substring(CONVERT(VARCHAR(10), e.EVENTDATETIME, 101) + ' ' + et.EVENTNAME + ' ' + Isnull(s.DISPLAYAS, '') + ' ' + gcs.CODENAME, 1, 60) AS EventDetail
			,et.EVENTNAME
			,e.EVENTID
			,e.EVENTTYPEID
			,sc.SCREENID
			,d.DOCUMENTID
			,et.ASSOCIATEDDOCUMENTCODEID
			,CanEdit = CASE 
				WHEN D.STATUS NOT IN (
						22
						,23
						)
					THEN CASE 
							WHEN D.AUTHORID = @ClinicianId
								THEN 'Y'
							ELSE CASE 
									WHEN D.PROXYID = @ClinicianId
										THEN 'Y'
									ELSE CASE 
											WHEN D.DOCUMENTSHARED = 'Y'
												THEN 'Y'
											ELSE 'N'
											END
									END
							END
				ELSE 'Y'
				END
		FROM EVENTS e
		INNER JOIN CLIENTS c ON c.CLIENTID = e.CLIENTID
		INNER JOIN EVENTTYPES et ON et.EVENTTYPEID = e.EVENTTYPEID
		LEFT JOIN STAFF S ON S.STAFFID = e.STAFFID
		LEFT JOIN SCREENS sc ON sc.DOCUMENTCODEID = et.ASSOCIATEDDOCUMENTCODEID
			AND Isnull(sc.RECORDDELETED, 'N') = 'N'
			AND SC.SCREENTYPE <> 5761 -- Not get detail type      
		LEFT JOIN GLOBALCODES gcs ON gcs.GLOBALCODEID = e.STATUS
		LEFT JOIN DOCUMENTS d ON d.EVENTID = e.EVENTID
			AND Isnull(d.RECORDDELETED, 'N') = 'N'
		INNER JOIN DOCUMENTCODES dc ON d.DOCUMENTCODEID = dc.DOCUMENTCODEID
		WHERE Isnull(e.RECORDDELETED, 'N') = 'N'
			AND C.ClientId = @ClientId
			AND EXISTS (select * from @Insurers INS where INS.InsurerId = e.InsurerId OR e.InsurerId IS NULL)
			AND EXISTS (select * from @Providers PD where PD.ProviderId = e.ProviderId OR e.ProviderId IS NULL)
		ORDER BY e.EVENTDATETIME DESC
			,e.EVENTID

		-------------------------------- Events Rates end ------------------------------------------      
		-------------------------------- Insurers Rates table ----------------------------------------
		SELECT i.INSURERNAME
			,i.INSURERID
			,SYSTEMDATABASEID
		FROM INSURERS i
		INNER JOIN @Insurers ui ON ui.INSURERID = i.INSURERID
		WHERE EXISTS (
				SELECT 1
				FROM CLIENTPLANS cp
				INNER JOIN CLIENTS c ON c.CLIENTID = cp.CLIENTID
				INNER JOIN INSURERPLANS ip ON ip.INSURERPLANID = cp.INSURERPLANID
				WHERE C.CLIENTID = @ClientId
					AND ip.INSURERID = i.INSURERID
					AND cp.ACTIVE = 'Y'
					AND cp.EFFECTIVEFROM <= Getdate()
					AND (
						Dateadd(dd, 1, cp.EFFECTIVETO) > Getdate()
						OR cp.EFFECTIVETO IS NULL
						)
					AND Isnull(cp.RECORDDELETED, 'N') = 'N'
					AND Isnull(ip.RECORDDELETED, 'N') = 'N'
				)
		ORDER BY i.INSURERNAME
			-------------------------------- Insurers Rates end ------------------------------------------            
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMClientSummaryInfo') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                    
				16
				,-- Severity.                    
				1 -- State.                    
				);
	END CATCH
END
