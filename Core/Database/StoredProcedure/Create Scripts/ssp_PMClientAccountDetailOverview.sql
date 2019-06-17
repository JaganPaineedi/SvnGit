/****** Object:  StoredProcedure [dbo].[ssp_PMClientAccountDetailOverview]    Script Date: 08/26/2013 15:57:10 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PMClientAccountDetailOverview]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_PMClientAccountDetailOverview]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMClientAccountDetailOverview]    Script Date: 08/26/2013 15:57:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMClientAccountDetailOverview] @ClientID INT
AS /******************************************************************************              
**  File: dbo.ssp_PMClientAccountDetailOverview.prc              
**  Name: Stored_Procedure_Name              
**  Desc:               
**              
**  This template can be customized:              
**                            
**  Return values:              
**               
**  Called by:                 
**                            
**  Parameters:              
**  Input                
**              ----------               
**              
**  Auth:               
**  Date:               
*******************************************************************************              
**  Change History              
*******************************************************************************              
** Date: Author:  Description:              
** -------- -------- -------------------------------------------              
** 02/10/2007   Mary Suma       
-- 24 Aug 2011 Girish Removed References to Rowidentifier and/or ExternalReferenceId  
-- 27 Aug 2011 Girish Readded References to Rowidentifier and ExternalReferenceId          
-- 10 Sep 2011 Included Try Catch Block
-- 16 Feb 2012	Added 'ClientInfoTabIndex' column as per task #244 of Kalamazoo Bugs by Varinder Verma
-- 04 Sep 2012 Added 'CLIENTID' for Thresholds  3.5 x second table
-- 08 Aug 2013 Added CC.Active check for task# #167 of Threshold support by Dhanil Manuel
-- 26 Aug 2013 - T.Remisoski - Fixed change made by task #167
-- 16 Oct 2015		Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.         
--									why:task #609, Network180 Customization
-- 18 DEc 2015		Basudev Sahu			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.         
--									why:task #609, Network180 Customization
-- 14 Dec 2015 - Venkatesh -  Added Internalcollections and PaymentArrangmentAmount as per task #936.2
-- 7/21/2016	NJain		Updated to display both positive and negative 3rd party balances. Earlier it was only displaying positive balances
-- 1/21/2017	NJain		Updated Charges.Flagged to ISNULL(Charges.Flagged, 'N') in the 3rd party information logic to correct grouping issues. Bradford SGL #301
-- 10 Feb 2017	Vithobha		Added InternalCollections,ExternalCollections columns in Clients table, Renaissance - Dev Items #830
-- 02 Mar 2017	NJain		Added a call to calculate client balance ssp, so the CurrentBalance amount in Clients table is updated when this screen loads
-- 09 AUG 2018  Vinay K S   Added Financial summary data as per task #14 	Bradford - Enhancements
-- 20-SEP-2018  Tim         Added record deleted condition for Table 05 (Task #326 Texas Go Live Build Issues) 
*******************************************************************************/              
              
/******************************************************************************              
** Table : 00 Client Information              
******************************************************************************/              
    BEGIN

        BEGIN TRY
        
        
			EXEC dbo.ssp_SCCalculateClientBalance @ClientId 
			
			
			
            DECLARE @UnpaidServices MONEY              
            DECLARE @UnpostedAmount MONEY 
			
            DECLARE @CollectionId INT             
            DECLARE @PaymentPlanAmount VARCHAR(100)
            
            DECLARE @Episode VARCHAR(150)
            DECLARE @Program VARCHAR(150)
            DECLARE @LastSeen VARCHAR(150)
             
            SELECT TOP 1
                    @PaymentPlanAmount = ( CAST(PaymentPlanAmount AS VARCHAR(100)) + ' per ' + dbo.ssf_GetGlobalCodeNameById(CO.PaymentFrequency) ) ,
                    @CollectionId = CollectionId
            FROM    Collections CO
                    JOIN globalcodes gc ON gc.globalcodeid = co.collectionstatus
                                           AND gc.code NOT IN ( 'STECA', 'R' )
            WHERE   CO.ClientId = @ClientID
            ORDER BY CO.CollectionId DESC  
 
            SELECT  @UnpostedAmount = SUM(UnpostedAmount)
            FROM    Payments
            WHERE   ClientId = @ClientID
                    AND ISNULL(RecordDeleted, 'N') = 'N'
            GROUP BY ClientId              
              
            SELECT  C.CLIENTID ,
                    CASE -- Added by Revathi 16 Oct 2015
                         WHEN ISNULL(C.ClientType, 'I') = 'I' THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
                         ELSE ISNULL(C.OrganizationName, '')
                    END AS ClientName ,
                    CASE C.FinanciallyResponsible
                      WHEN 'N' THEN CC.LastName + ', ' + CC.FirstName
                      ELSE CASE WHEN ISNULL(C.ClientType, 'I') = 'I' THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
                                ELSE ISNULL(C.OrganizationName, '')
                           END
                    END AS FinRespName ,
                    CC.ClientContactId AS ClientContactId ,
                    ISNULL('$' + CONVERT(VARCHAR, CurrentBalance), 0) AS CurrentBalance ,
                    ISNULL('$' + CONVERT(VARCHAR, @UnpostedAmount), 0) AS UnpostedAmount ,
                    '$' + CONVERT(VARCHAR, ( ISNULL(c.CurrentBalance, 0) + ISNULL(@UnpostedAmount, 0) )) AS UnpaidServices ,
                    CONVERT(VARCHAR, LastStatementDate, 101) AS LastStatementDate ,
                    DoNotSendStatement ,
                    DoNotSendStatementReason ,
                    InformationComplete ,
                    AccountingNotes ,
                    CASE C.FinanciallyResponsible
                      WHEN 'Y' THEN 0
                      ELSE 3
                    END AS ClientInfoTabIndex ,
                    CASE WHEN EXISTS ( SELECT   1
                                       FROM     Collections CO
                                                JOIN globalcodes gc ON gc.globalcodeid = co.collectionstatus
                                                                       AND gc.code NOT IN ( 'STECA', 'R' )
                                       WHERE    CO.ClientId = c.ClientId
                                                AND ISNULL(CO.RecordDeleted, 'N') = 'N' ) THEN 'Yes'
                         ELSE 'No'
                    END InternalCollection ,
                    ISNULL('$' + CONVERT(VARCHAR, @PaymentPlanAmount), 0) AS PaymentArrangmentAmount ,
                    @CollectionId AS CollectionId,
                    CASE C.ACTIVE WHEN 'Y' THEN 'Active' ELSE 'Inactive' END AS ClientActive 
            
                    
            FROM    Clients C
                    LEFT JOIN ClientContacts CC ON CC.FinanciallyResponsible = 'Y'
                                                   AND C.CLIENTID = cc.ClientID
                                                   AND ISNULL(cc.RecordDeleted, 'N') = 'N'
                                               -- 26.08.2013 - T.Remisoski - moved from WHERE clause to JOIN so client would still be returned when no records returned by the JOIN
                                               -- (also, should verify with Product Management that the contaction should be hidden when Active = 'N')
                                                   AND ISNULL(CC.Active, 'N') = 'Y'
            WHERE   C.CLIENTID = @ClientID
                    AND ISNULL(C.RecordDeleted, 'N') = 'N'     
              
              
           

           
              
--/******************************************************************************              
--** Table :02 All Client Notes Information              
        
--******************************************************************************/               
--SELECT                   
--  CN.ClientId ,CN.NoteType, CN.Note ,GC.Bitmap,GC.CodeName,GC.GlobalCodeId                 
--FROM                   
-- ClientNotes CN LEFT OUTER JOIN GlobalCodes GC ON CN.NoteType=GC.GlobalCodeId                  
                   
--WHERE                   
-- GC.Category='ClientNoteType'                  
--AND                  
-- CN.ClientId = @ClientId                  
--AND                  
-- (CN.RecordDeleted = 'N' OR CN.RecordDeleted IS NULL) AND CN.Active='Y'                  
--AND (convert(datetime,convert(varchar(10),CN.StartDate,101)) <= convert(datetime, convert(varchar(10),Getdate(),101)) and isnull(CN.EndDate, convert(datetime,convert(varchar(10),DateAdd(yy, 1, GetDate()),101)))
-- >= convert(datetime,convert(varchar(10),Getdate(),101))  )             

/******************************************************************************              
**Table : 03 Client Row. Used to update information on the Client Account overview page.              
******************************************************************************/               
            SELECT  ClientId ,
                    CreatedBy ,
                    CreatedDate ,
                    ModifiedBy ,
                    ModifiedDate ,
                    RecordDeleted ,
                    DeletedDate ,
                    DeletedBy ,
                    ExternalClientId ,
                    Active ,
                    MRN ,
                    LastName ,
                    FirstName ,
                    MiddleName ,
                    Prefix ,
                    Suffix ,
                    SSN ,
                    Sex ,
                    DOB ,
                    PrimaryClinicianId ,
                    CountyOfResidence ,
                    CountyOfTreatment ,
                    CorrectionStatus ,
                    Email ,
                    Comment ,
                    LivingArrangement ,
                    NumberOfBeds ,
                    MinimumWage ,
                    FinanciallyResponsible ,
                    AnnualHouseholdIncome ,
                    NumberOfDependents ,
                    MaritalStatus ,
                    EmploymentStatus ,
                    EmploymentInformation ,
                    MilitaryStatus ,
                    EducationalStatus ,
                    DoesNotSpeakEnglish ,
                    PrimaryLanguage ,
                    CurrentEpisodeNumber ,
                    AssignedAdminStaffId ,
                    InpatientCaseManager ,
                    InformationComplete ,
                    PrimaryProgramId ,
                    LastNameSoundex ,
                    FirstNameSoundex ,
                    CurrentBalance ,
                    CareManagementId ,
                    HispanicOrigin ,
                    DeceasedOn ,
                    LastStatementDate ,
                    LastPaymentId ,
                    LastClientStatementId ,
                    DoNotSendStatement ,
                    DoNotSendStatementReason ,
                    AccountingNotes ,
                    MasterRecord ,
                    ProviderPrimaryClinicianId ,
                    RowIdentifier ,
                    ExternalReferenceId ,
                    DoNotOverwritePlan ,
                    Disposition ,
                    NoKnownAllergies,
                    -- 10 Feb 2017	Vithobha
                    InternalCollections,
					ExternalCollections
            FROM    CLIENTS
            WHERE   ( RECORDDELETED = 'N'
                      OR RECORDDELETED IS NULL
                    )              
--AND              
--  ACTIVE = 'Y'              
                    AND CLIENTID = @ClientID              
                
/******************************************************************************              
**Table : 04 Fee Arrangement              
******************************************************************************/               
              
            SELECT  CONVERT(VARCHAR, StartDate, 101) + ' To ' + CONVERT(VARCHAR, EndDate, 101) + CHAR(10) + Description AS FeeArragnement
            FROM    ClientFeeArrangements
            WHERE   ClientId = @ClientID
                    AND ( RecorDDeleted IS NULL
                          OR RecordDeleted = 'N'
                        )              
                
/******************************************************************************              
**Table 05 :3'rd Party Information              
******************************************************************************/               
              
            
            SELECT  CH.clientCoveragePlanId ,
                    CP.CoveragePlanId ,
                    RTRIM(Cp.DisplayAs) + ' ' + ISNULL(InsuredId, '') AS CoveragePlanName ,
                    SUM(AR.AMOUNT) AS Balance ,
                    SUM(CASE WHEN ch.LastBilledDate IS NULL THEN AR.Amount
                             ELSE 0
                        END) AS UnBilledAmt ,
                    SUM(CASE WHEN DATEDIFF(day, CH.LastBilledDate, GETDATE()) >= 90 THEN AR.AMOUNT
                             ELSE 0
                        END) AS NinetyDays ,
                    CASE WHEN ISNULL(CH.Flagged, 'N') = 'Y' THEN COUNT(ISNULL(CH.Flagged, 'N'))
                         ELSE NULL
                    END AS Flagged
            FROM    Services S
                    LEFT JOIN Charges CH ON S.ServiceId = CH.ServiceId AND ISNULL(CH.recorddeleted, 'N') = 'N' -- Tim 20-SEP-2018
                    LEFT JOIN ClientCoveragePlans CCP ON CH.clientCoveragePlanId = CCP.clientCoveragePlanId AND ISNULL(CCP.Recorddeleted, 'N') = 'N' -- Tim 20-SEP-2018
                    LEFT JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
                    LEFT JOIN ARLedger AR ON CH.ChargeId = AR.ChargeId AND ISNULL(AR.Recorddeleted, 'N') = 'N' -- Tim 20-SEP-2018
            WHERE   S.Clientid = @ClientID
                    AND CH.clientCoveragePlanId IS NOT NULL
                    AND ( s.RecordDeleted IS NULL
                          OR s.RecordDeleted = 'N'
                        )
            GROUP BY CH.clientCoveragePlanId ,
                    ISNULL(CH.Flagged, 'N') ,
                    CP.DisplayAs ,
                    CCP.InsuredId ,
                    CP.CoveragePlanId
            HAVING  SUM(AR.Amount) <> 0         
              
--Table 06 Send Statements

            SELECT  DoNotSendStatement
            FROM    Clients
            WHERE   ClientId = @ClientId
                    AND ( Clients.RecordDeleted = 'N'
                          OR Clients.RecordDeleted IS NULL
                        )  

--Table 06 Information Complete

            SELECT  InformationComplete
            FROM    Clients
            WHERE   ClientId = @ClientId
                    AND ( Clients.RecordDeleted = 'N'
                          OR Clients.RecordDeleted IS NULL
                        )  
	
	--Table 07 ClientCoveragePlans
	
            SELECT  CCP.clientCoveragePlanId AS clientCoveragePlanId ,
                    RTRIM(Cp.DisplayAs) + ' ' + ISNULL(InsuredId, '') AS DisplayAs         
		--CCP.CoveragePlanId AS CoveragePlanId,
		--CP.DisplayAs AS DisplayAs
            FROM    ClientCoveragePlans CCP
                    JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
                                             AND CCP.ClientId = @ClientID
                                             AND ( CP.RecordDeleted IS NULL
                                                   OR CCP.RecordDeleted = 'N'
                                                 )
                                             AND CP.Active = 'Y'
            ORDER BY CP.DisplayAs
--Table Financial Summary start-----------------------------------------------------            
--AUG 2018  Vinay K S			
SET @Episode=(SELECT TOP 1 'Episode '+ISNULL(Convert(VARCHAR(10),Episodenumber),'')+' '
+ISNULL(CONVERT(VARCHAR, RegistrationDate, 101),'')
+CASE WHEN DischargeDate IS NULL THEN '' ELSE ' - ' END
+ISNULL(CONVERT(VARCHAR, DischargeDate, 101),'') AS Episode  
            FROM ClientEpisodes 
            WHERE clientid = @ClientID and ISNULL(RecordDeleted,'N')='N'
            ORDER BY Episodenumber DESC) 
            
SET @Program=(SELECT TOP 1 P.ProgramName+' '
+ISNULL(convert(VARCHAR, CP.EnrolledDate, 101),'')
+CASE WHEN DischargedDate IS NULL THEN '' ELSE ' - ' END
+ISNULL(CONVERT(VARCHAR, DischargedDate, 101),'') AS Program
			FROM ClientPrograms CP
			INNER JOIN Programs P
			ON P.ProgramId=CP.ProgramId
			WHERE CP.clientid = @ClientID 
			AND ISNULL(CP.RecordDeleted,'N')='N' 
			AND ISNULL(P.RecordDeleted,'N')='N'
			ORDER BY CP.EnrolledDate desc) 
			
SET @LastSeen=(SELECT TOP 1 ISNULL(convert(VARCHAR, DateOfService ,101),'') AS LastDateOfService
			FROM Services 
			WHERE clientid=@ClientID AND Status='71' AND ISNULL(RecordDeleted, 'N') = 'N' 
			ORDER BY DateOfService DESC)
			
			
SELECT @Episode AS ClientEpisode
	,@Program AS Program
	,@LastSeen AS LastSeen			
				
			SELECT CP.DisplayAs+' -  Auth #:'
			+ISNULL(A.AuthorizationNumber,'')
			+' - Auth Code:'+ISNULL(AC.AuthorizationCodeName,'')
			+'('+ISNULL(CONVERT(VARCHAR(10),CONVERT(INT,A.TotalUnits)),'')+' Units) '
			+CASE   
			WHEN A.StartDate IS NOT NULL  
			 THEN ISNULL(CONVERT(VARCHAR,A.StartDate,101),'')  
			ELSE ISNULL(CONVERT(VARCHAR,A.StartDateRequested,101),'')  
			END  
			+CASE WHEN A.EndDate IS NULL THEN '' ELSE ' - ' END
		    +CASE   
			WHEN A.EndDate IS NOT NULL
			 THEN ISNULL(CONVERT(VARCHAR,A.EndDate,101),'')  
			ELSE ISNULL(CONVERT(VARCHAR,A.EndDateRequested,101),'')  
			END 
		    AS ClientAuths
			FROM Authorizations A
			INNER JOIN AuthorizationDocuments AD ON A.AuthorizationDocumentid=AD.AuthorizationDocumentid
			INNER JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanid=AD.ClientCoveragePlanid
			INNER JOIN CoveragePlans CP ON CP.CoveragePlanId=CCP.CoveragePlanId
			INNER JOIN AuthorizationCodes AC ON AC.AuthorizationCodeId=A.AuthorizationCodeId
			WHERE ClientId=@ClientID 
			AND ((A.StartDate IS NULL OR CAST(A.StartDate AS DATE) <=CAST(GETDATE() AS DATE))
			AND  (A.EndDate IS NULL OR CAST(A.EndDate AS DATE) >=CAST(GETDATE() AS DATE)))
					AND  A.Status in (305,4243)
					AND ISNULL(CCP.RecordDeleted, 'N') = 'N'  
					AND ISNULL(AD.RecordDeleted, 'N') = 'N'  
					AND ISNULL(A.RecordDeleted, 'N') = 'N'
					
			ORDER BY A.AuthorizationId DESC
			
			select 'Auth #:'+ISNULL(PA.AuthorizationNumber,'')
			+' - Auth Code: '+ISNULL(BC.CodeName,'')
			+'('+ISNULL(CONVERT(VARCHAR(10),CONVERT(INT,PA.TotalUnitsApproved)),'')+' Units)'
			+CASE   
			WHEN PA.StartDate IS NOT NULL
			 THEN ISNULL(CONVERT(VARCHAR,PA.StartDate,101),'')  
			ELSE ISNULL(CONVERT(VARCHAR,PA.StartDateRequested,101),'')  
			END 
			+CASE WHEN PA.EndDate IS NULL THEN '' ELSE ' - ' END
			+CASE   
			WHEN PA.EndDate IS NOT NULL
			 THEN ISNULL(CONVERT(VARCHAR,PA.EndDate,101),'')  
			ELSE ISNULL(CONVERT(VARCHAR,PA.EndDateRequested,101),'')  
			END
			AS ClientAuths
			FROM ProviderAuthorizations PA
			INNER JOIN ProviderAuthorizationDocuments PAD ON PAD.ProviderAuthorizationDocumentId=PA.ProviderAuthorizationDocumentId
			INNER JOIN BillingCodes BC ON BC.BillingCodeId=PA.BillingCodeId
			WHERE PA.ClientId=@ClientID
			AND ((PA.StartDate IS NULL OR CAST(PA.StartDate AS DATE) >=CAST(GETDATE() AS DATE))
			AND  (PA.EndDate IS NULL OR CAST(PA.EndDate AS DATE) <=CAST(GETDATE() AS DATE)))
		    AND PA.Status in (2042,2048)
			AND ISNULL(PA.RecordDeleted, 'N') = 'N'  
			AND ISNULL(PAD.RecordDeleted, 'N') = 'N' 
			AND PA.Active='Y'
			ORDER BY PA.ProviderAuthorizationID DESC								
			
			SELECT  RANK() OVER ( ORDER BY CCH.StartDate, CCH.EndDate, CCH.ServiceAreaId ) AS GroupNumber ,  
            CASE WHEN CAST(CONVERT(VARCHAR(10), CCH.StartDate, 101) AS DATETIME) <= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME)  
                 AND CAST(ISNULL(CONVERT(VARCHAR(10), EndDate, 101), '01/01/2070') AS DATETIME) >= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME) THEN 'C'  
                 ELSE 'P'END AS CurrentFlag ,                    
            CP.DisplayAs AS PlanName ,    
            CP.DisplayAs+' - '+CONVERT(VARCHAR, CCH.StartDate, 101)
            +CASE WHEN CCH.EndDate IS NULL THEN '' ELSE ' - ' END
            +ISNULL(CONVERT(VARCHAR, CCH.EndDate, 101), ' ') AS ClientPlans             
            FROM    ClientCoveragePlans CCP  
                    INNER JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId  
                    INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId  
            WHERE   CCP.ClientId = @ClientID  
                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'  
                    AND ISNULL(CCH.RecordDeleted, 'N') = 'N'  
                    AND ISNULL(CP.RecordDeleted, 'N') = 'N'  
            ORDER BY CurrentFlag,
					GroupNumber DESC ,  
                    ServiceAreaId DESC ,  
                    CCH.COBOrder ASC ,  
                    PlanName 
            
--Table Financial Summary End-----------------------------------------------------      
            
            
        END TRY
              
        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientAccountDetailOverview') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
        END CATCH 
        RETURN

    END


GO


