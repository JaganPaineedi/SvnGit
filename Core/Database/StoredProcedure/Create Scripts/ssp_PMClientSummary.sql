/****** Object:  StoredProcedure [dbo].[SSP_PMClientSummary]    Script Date: 12/18/2014 1:34:52 PM ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   OBJECT_ID = OBJECT_ID(N'[dbo].[SSP_PMClientSummary]')
                    AND TYPE IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[SSP_PMClientSummary]
GO


/****** Object:  StoredProcedure [dbo].[SSP_PMClientSummary]    Script Date: 12/18/2014 1:34:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_PMClientSummary]
	/* Param List */ @ClientId INT
AS /******************************************************************************                                                          
 **  File: dbo.ssp_PMClientSummary.prc                                                          
 **  Name: dbo.ssp_PMClientSummary                                                          
 **  Desc: This SP returns the client Summary information.                                                          
 **                                                           
**  This template can be customized:                                                          
 **                                                                         
**  Return values:                                                           
**                                                            
**  Called by:                                                              
**                                                                         
**  Parameters:                                                           
**  Input       Output                                                           
**     ----------      -----------                                                          
 **  ClientId      Client Summary                                                          
 **  Auth: Vitthal Shinde                                                          
 **  Date: 28-Jul-2006                                                           
*******************************************************************************                                                          
 **  Change History                                                           
*******************************************************************************                                                          
 **  Date:  Author:    Description:                                                          
 **  --------  --------    -------------------------------------------                                                          
 **                                                               
*******************************************************************************/
/*******************************************************************************                                                          
 **  Table 0 : Client Summary                 
 **		APR	  13 2010   Sahil Bhagat	Modified column CurrentVersion to CurrentDocumentVersionId    
 **		Nov   26 2010   Pradeep			Added CareManagementId in first select Statement as per task#103(Venture Support)                                                      
 **		Nov   21 2011   MSuma			Clean up, Removed * and modified Name        
 **		Nov	  24 2011   Ponnin Selvan   Added 'active and RecordDeleted' conditions for Programs and CoveragePlans 
 **     Aug   08 2013   Varun           Added code to display ICD codes as in SC ClientSummary
  **    Aug   09 2013   Varun           Added code to display DSM codes as in SC ClientSummary
        Oct   18 2013   Shruthi.S       Pulling entire SSN to display on mouseover.Ref #237 St.Joe-Support. 
  **    Jan   21 2014   Veena           Added code to display Description with ICD and DSM codes for AxisIandII and AxisIII Allegan Enhancements #2                                                                         
  **    Jan   22 2014   Veena           Added code to avoid showing Specification multiple times with ICD codes for  AxisIII 
  /*	12-May-2014		Ponnin			Added DoNotContact (DNC) text after the phone number if it is checked in Client information Detail page. */
  **	DEC-17-2014		dharvey			Added logic to eliminate Dx information if the DSM string is NULL
										Also changed DiagnosisDSMDescriptions to LEFT JOIN to display Dx codes to the user
										if a match is not available in that table so they can correct.
  **	2014-12-18		scooter			Revised @varDocumentId and @varDocumentVersionId logic to more correctly match ssp_SCClientSummaryInfo
  **    2015-01-23		Veena			Added conditon to display AXIS III KCMHSAS 3.5 Implementation: 213
  **	2015-03-27		NJain			Updated Axis V diagnosis logic to look at the same DocumentVersionId as other Axis
  **    2015-06-04      Basudev         Updated Store Procedure column STATUS to Status Task #399 Pines Support
  **    2015-07-28      pabitra         Added diagnosis details table Task -10
  **    2015-07-30      MD Khusro		Merged Bob Fagaly changes for Race column w.r.t #142 Core Bugs
  **    Aug   02 2015	Malathi Shiva	Included DSMV check changes 
  **	Sept  02 2015	Malathi Shiva	Added DSMNumber check since there were duplicate Descriptions with different DSMNumber.
  **    Sept  07 2015   Md Hussain K	Removed truncation of First Name of Primary Clinician w.r.t task #481 Core Bugs.
  /* 28/Sep/2015  Shankha			Changed the logic to return the Code Name for DiagnosisType instead of hard coded values*/
  /* 10/Dec/2015 Pavani                Added RuleOut to display Diagnosis w.r.t #792 Core Bugs*/
  **    26/SEP/2016     Akwinass        TOP 1 Condition implemented in sub query's to avoid error (Task #570 Key Point - Support Go Live)	
  10 Feb 2017 Vithobha  Added InternalCollections,ExternalCollections columns in Clients table, Renaissance - Dev Items #830 	
  15 Jan 2017 Himmat  Depend on ClientType settting EIN and SSN Number Core Bugs#2509 	
  
 *******************************************************************************/
    BEGIN
        BEGIN TRY
            SELECT  C.ClientId ,
                    C.comment ,
                    C.CareManagementId ,
                    CASE WHEN C.MiddleName IS NULL THEN RTRIM(C.LastName) + ', ' + RTRIM(C.FirstName)
                         ELSE RTRIM(C.LastName) + ', ' + RTRIM(C.FirstName) + ' ' + RTRIM(C.MiddleName)
                    END ClientName ,
                    ( SELECT    TOP 1 CodeName AS Status --26/SEP/2016     Akwinass
                      FROM      GlobalCodes
                      WHERE     GlobalCodeID IN ( SELECT    STATUS
                                                  FROM      ClientEpisodes
                                                  WHERE     clientid = C.ClientId
                                                            AND EpisodeNumber IN ( SELECT   MAX(EpisodeNumber) AS EpisodeNumber
                                                                                   FROM     ClientEpisodes
                                                                                   WHERE    ( RecordDeleted = 'N'
                                                                                              OR RecordDeleted IS NULL
                                                                                            )
                                                                                            AND clientid = C.ClientId )
                                                            AND ( RecordDeleted = 'N'
                                                                  OR RecordDeleted IS NULL
                                                                ) )
                    ) Status ,
                    CASE WHEN C.DOB IS NULL THEN NULL
                         ELSE C.DOB --DateDiff(Year,C.DOB,GETDATE())                                                           
                    END Age ,
                    CASE C.Sex
                      WHEN 'M' THEN 'Male'
                      WHEN 'F' THEN 'Female'
                      ELSE C.Sex
                    END Sex ,
                    CASE   -- Merged Bob Fagaly changes for Race column w.r.t #142 Core Bugs
						WHEN (
								SELECT COUNT(RaceId)
								FROM ClientRaces CR
								INNER JOIN dbo.GlobalCodes GC ON GC.GlobalCodeId = CR.RaceId
								WHERE ClientId = C.ClientId
									AND ISNULL(CR.RecordDeleted, 'N') = 'N'
									AND ISNULL(GC.RecordDeleted, 'N') = 'N'
								) = 0
							THEN NULL
						WHEN (
								SELECT COUNT(RaceId)
								FROM ClientRaces CR
								INNER JOIN dbo.GlobalCodes GC ON GC.GlobalCodeId = CR.RaceId
								WHERE ClientId = C.ClientId
									AND ISNULL(CR.RecordDeleted, 'N') = 'N'
									AND ISNULL(GC.RecordDeleted, 'N') = 'N'
								) > 1
							THEN 'Multi-Racial'
						ELSE (
								SELECT TOP 1 CodeName --26/SEP/2016     Akwinass
								FROM GlobalCodes
								WHERE (
										RecordDeleted = 'N'
										OR RecordDeleted IS NULL
										)
									AND GlobalCodeID IN (
										SELECT RaceId
										FROM ClientRaces
										WHERE (
												RecordDeleted = 'N'
												OR RecordDeleted IS NULL
												)
											AND Clientid = C.ClientId
										)
								)
					 END AS Race,
                    ( CASE WHEN ClientType = 'O' THEN EIN  
                           ELSE SSN  
                      END ) SSN ,
                    ( SELECT    CONVERT(VARCHAR, MAX(RegistrationDate), 101)
                      FROM      ClientEpisodes CE
                      WHERE     CE.clientid = C.ClientId
                                AND EpisodeNumber IN ( SELECT   MAX(CE.EpisodeNumber) AS EpisodeNumber
                                                       FROM     ClientEpisodes CE
                                                       WHERE    ( RecordDeleted = 'N'
                                                                  OR RecordDeleted IS NULL
                                                                )
                                                                AND CE.clientid = C.ClientId
                                                       GROUP BY CE.clientid )
                      GROUP BY  CE.clientid
                    ) RegistrationDate ,
                    PrimaryClinicianId ,
                    -- Modified by MD Hussain on 09/07/2015
                    ( SELECT    TOP 1 S.LastName + ', ' + S.FirstName --26/SEP/2016     Akwinass
                      FROM      Staff S
                      WHERE     ( RecordDeleted = 'N'
                                  OR RecordDeleted IS NULL
                                )
                                AND S.StaffId = C.PrimaryClinicianId
                    ) PrimaryClinician ,
                    ( SELECT    TOP 1 FeeArrangement --26/SEP/2016     Akwinass
                      FROM      ClientFinancialSummaryReports
                      WHERE     ( RecordDeleted = 'N'
                                  OR RecordDeleted IS NULL
                                )
                                AND ClientId = C.ClientId
                    ) FeeArrangement ,
                    CASE WHEN C.CurrentBalance <> 0 THEN '$' + CONVERT(VARCHAR, C.CurrentBalance, 20)
                         ELSE NULL
                    END AS CurrentBalance ,
                    ( SELECT    '$' + CONVERT(VARCHAR, SUM(Balance), 20) AS CurrentThirdPartyBalance
                      FROM      ClientCoveragePlans z
                                INNER JOIN Charges y ON z.ClientCoveragePlanId = y.ClientCoveragePlanId
                                INNER JOIN OpenCharges x ON ( y.ChargeId = x.ChargeId )
                      WHERE     z.ClientId = @ClientId
                                AND ISNULL(y.RecordDeleted, 'N') <> 'Y'
					--  Select '$' + Convert(Varchar,SUM(Balance),20) as CurrentThirdPartyBalance FROM Opencharges Where (RecordDeleted = 'N' OR RecordDeleted IS NULL) AND ChargeId In (Select ChargeId from Charges where (RecordDeleted = 'N' OR RecordDeleted IS NULL) AND Cli
					--e                                  
					--nt                                                             
					--CoveragePlanId in (select ClientCoveragePlanId from ClientCoveragePlans where (RecordDeleted = 'N' OR RecordDeleted IS NULL) AND ClientId = C.ClientId))                                                            
                    ) CurrentThirdPartyBalance ,
                    ( SELECT TOP 1
                                CASE WHEN z.Amount IS NOT NULL THEN '$' + CONVERT(VARCHAR, ABS(z.Amount), 20) + ' '
                                     ELSE ''
                                END + CASE WHEN z.ReferenceNumber IS NOT NULL THEN '#' + CONVERT(VARCHAR, z.ReferenceNumber, 20) + ' '
                                           ELSE ''
                                      END + CASE WHEN z.DateReceived IS NOT NULL THEN CONVERT(VARCHAR, z.DateReceived, 101)
                                                 ELSE ''
                                            END
                      FROM      Payments z
                      WHERE     z.ClientId = @ClientId
                                AND ISNULL(z.RecordDeleted, 'N') <> 'Y'
                      ORDER BY  paymentid DESC
					--  (                          
					--   Select * from Payments where ISNULL(RecordDeleted,'N') = 'N' AND Paymentid in (Select Max(paymentId) from arledger where ISNULL(RecordDeleted,'N') = 'N' AND ChargeId IN (select ChargeId From charges where ISNULL(RecordDeleted,'N') = 'N' AND ClientCo
					--v                                
					--er                                                            
					--agePlanId is null AND serviceId In(select ServiceId from services where ISNULL(RecordDeleted,'N') = 'N' AND clientId = @ClientId)))                                                            
					--  ) T           
                    ) AS LastClientPayment ,
                    ( SELECT TOP 1
                                CASE WHEN y.PayerId IS NOT NULL THEN x.PayerName
                                     ELSE RTRIM(v.DisplayAs)
                                END + ' ' + '$' + CONVERT(VARCHAR, ABS(z.Amount), 20) + ' ' + ISNULL('#' + y.ReferenceNumber, RTRIM('')) + ' ' + ISNULL(CONVERT(VARCHAR, y.DateReceived, 101), RTRIM(''))
                      FROM      ARLedger z
                                INNER JOIN Payments y ON ( z.PaymentId = y.PaymentId )
                                LEFT JOIN Payers x ON ( y.PayerId = x.PayerId )
                                LEFT JOIN CoveragePlans v ON ( v.CoveragePlanId = y.CoveragePlanId )
                      WHERE     z.LedgerType = 4202
                                AND z.ClientId = @ClientId
                                AND z.CoveragePlanId IS NOT NULL
                      ORDER BY  z.PostedDate DESC
					--         select 'abc'                                                   
					--   Case                                                            
					--    WHEN T.PayerId IS NOT NULL THEN (Select PayerName from Payer P Where p.payerID = T.PayerId)                                                            
					--    ELSE (Select DisplayAs From CoveragePlans CP Where CP.Coverageplanid = T.Coverageplanid)                                                            
					--   End + ' ' + Case when Amount is Not null then '$' + Convert(Varchar,Amount,20) + ' ' else '' end +                                                           
					--   case when ReferenceNumber is not null then '#' + Convert(Varchar,ReferenceNumber,20) + ' ' else '' end +                                                            
					--   case when DateReceived is not null then Convert(Varchar,DateReceived,101) else '' end                                                                
					--  (                                                            
					--   Select * from Payments where ISNULL(RecordDeleted,'N') = 'N' AND Paymentid in (Select Max(paymentid) from Payments where (RecordDeleted = 'N' OR RecordDeleted IS NULL) AND PaymentId IN (Select PaymentId from ArLedger where (RecordDeleted = 'N' OR Re 
					--c                      
					--or                                                            
					--dDeleted IS NULL) AND clientId = @ClientId AND PaymentId is Not NULL))            --  ) T                                                            
                    ) AS LastThirdPartyPayment ,
                    ( SELECT TOP 1
                                CONVERT(VARCHAR, DateOfService, 101) LastSeenOn
                      FROM      Services
                      WHERE     ClientId = @ClientId
                                AND ISNULL(RecordDeleted, 'N') <> 'Y'
                                AND STATUS IN ( 71, 75 )
                                AND Billable = 'Y'
                      ORDER BY  DateOfService DESC
                    ) AS LastSeenOn ,
                    ( SELECT TOP 1
                                y.DateOfService
                      FROM      Services y
                      WHERE     ISNULL(Y.RecordDeleted, 'N') <> 'Y'
                                AND y.ClientId = @ClientId
                                AND y.DateOfService >= GETDATE()
                                AND y.STATUS = 70
                      ORDER BY  y.DateOfService
					--  SELECT TOP 1 StartTime                                                             
					--  FROM Appointments         --  WHERE (RecordDeleted = 'N' OR RecordDeleted IS NULL)                                                             
					--  AND StartTime>=GETDATE()                                                             
					--  AND ServiceId IN ( SELECT ServiceId FROM Services S WHERE (RecordDeleted = 'N' OR RecordDeleted IS NULL) AND S.clientid = @ClientId )                                                            
                    ) AS NextScheduled
                    --10 Feb 2017 Vithobha
                     ,CASE WHEN C.InternalCollections = 'Y' THEN 'Yes'  
                     ELSE 'No'  
                     END AS InternalCollections
                     ,CASE WHEN C.ExternalCollections = 'Y' THEN 'Yes'  
                     ELSE 'No'  
                     END AS ExternalCollections
            FROM    Clients C
            WHERE   C.ClientId = @ClientId
			--AND                                       
			-- C.Active = 'Y'                                                            
                    AND ( C.RecordDeleted = 'N'
                          OR C.RecordDeleted IS NULL
                        )

		/*******************************************************************************                                                            
**  Table 01 : Last Third Party Payment                                                            
*******************************************************************************/
            SELECT TOP 1
                    y.PaymentId ,
                    y.FinancialActivityId ,
                    CASE WHEN y.PayerId IS NOT NULL THEN x.PayerName
                         ELSE RTRIM(v.DisplayAs)
                    END Payer ,
                    '$' + CONVERT(VARCHAR, ABS(z.Amount), 20) AS Amount ,
                    '#' + CONVERT(VARCHAR, y.ReferenceNumber, 20) AS ReferenceNumber ,
                    CONVERT(VARCHAR, y.DateReceived, 101) AS DateReceived1
            FROM    ARLedger z
                    INNER JOIN Payments y ON ( z.PaymentId = y.PaymentId )
                    LEFT JOIN Payers x ON ( y.PayerId = x.PayerId )
                    LEFT JOIN CoveragePlans v ON ( v.CoveragePlanId = y.CoveragePlanId )
            WHERE   z.LedgerType = 4202
                    AND z.ClientId = @ClientId
                    AND z.CoveragePlanId IS NOT NULL
            ORDER BY z.PostedDate DESC

		/*******************************************************************************                                                            
**  Table 02 : Last Client Payment                                                            
*******************************************************************************/
            SELECT TOP 1
                    z.Paymentid ,
                    z.FinancialActivityId ,
                    '$' + CONVERT(VARCHAR, ABS(z.Amount), 20) AS Amount ,
                    '#' + CONVERT(VARCHAR, z.ReferenceNumber, 20) AS ReferenceNumber ,
                    CONVERT(VARCHAR, z.DateReceived, 101) AS DateReceived
            FROM    Payments z
            WHERE   z.ClientId = @ClientId
                    AND ISNULL(z.RecordDeleted, 'N') <> 'Y'
            ORDER BY paymentid DESC

		--  order by cast(z.DateReceived as datetime)  desc                                                          
		/*******************************************************************************                        
**  Table 03 : CoveragePlans For Client                                                            
*******************************************************************************/
            SELECT TOP 4
                    a.ClientCoveragePlanId ,
                    RTRIM(b.DisplayAs) AS DisplayAs
            FROM    ClientCoveragePlans a
                    INNER JOIN CoveragePlans b ON ( a.CoveragePlanId = b.CoveragePlanId )
                    INNER JOIN clientcoveragehistory c ON ( a.clientcoverageplanId = c.clientcoverageplanId
                                                            AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                                                          )
            WHERE   ISNULL(a.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(b.RecordDeleted, 'N') = 'N'
                    AND b.Active = 'Y'
                    AND ( ( C.StartDate <= GETDATE()
                            AND C.EndDate >= GETDATE()
                          )
                          OR ( C.StartDate <= GETDATE()
                               AND C.EndDate IS NULL
                             )
                        )
                    AND a.ClientId = @ClientId
            ORDER BY C.COBOrder

		/*******************************************************************************                                                            
**  Table 04 : Programs For Client                                                            
*******************************************************************************/
            SELECT DISTINCT TOP 4
                    a.ClientProgramId ,
                    b.ProgramCode
            FROM    ClientPrograms a
                    INNER JOIN Programs b ON ( a.ProgramId = b.ProgramId )
            WHERE   ISNULL(a.RecordDeleted, 'N') <> 'Y'
                    AND a.ClientId = @ClientId
                    AND a.STATUS <> 5
                    AND ISNULL(b.RecordDeleted, 'N') = 'N'
                    AND b.Active = 'Y'

		/*******************************************************************************                                                            
**  Table 05 : Client Address                                                   
*******************************************************************************/
            SELECT  Address ,
                    City ,
                    STATE ,
                    Zip ,
                    Display
            FROM    ClientAddresses
            WHERE   ClientId = @ClientId
                    AND ( RecordDeleted = 'N'
                          OR RecordDeleted IS NULL
                        )
                    AND AddressType = 90

		/*******************************************************************************                                     
**  Table 06 : Client Phone                                                            
*******************************************************************************/
		/* Added DNC logic on 12-May-2014	by Ponnin */
            DECLARE @phoneNumber AS VARCHAR(200)

            SELECT  @phoneNumber = COALESCE(@phoneNumber + ', ', '') + CAST(PhoneNumber AS VARCHAR(50)) + CASE WHEN DoNotContact = 'Y' THEN ' (DNC)'
                                                                                                               ELSE ''
                                                                                                          END
            FROM    clientPhones
            WHERE   clientId = @ClientId
			/*and phonetype in(30,31) */
                    AND ISNULL(RecordDeleted, 'N') <> 'Y'
            ORDER BY ( CASE WHEN IsPrimary = 'Y' THEN 1
                            ELSE 0
                       END ) DESC

		--Ended Over here    
            SELECT  @phoneNumber AS PhoneNumber ,
                    @phoneNumber AS PhoneNumberText

		/*                                                           
SELECT                                                             
  PhoneNumber + case when  DoNotContact = 'Y' then ' (DNC)' else '' end + ' ' as   PhoneNumber,                                                            
  PhoneNumberText                                                        
FROM                           
  ClientPhones                                                             
WHERE                                                             
  (RecordDeleted ='N' OR RecordDeleted IS NULL)                                                            
AND                                                            
  ClientId = @ClientId    
  */
		--AND  PhoneType = 30                                                            
		/*******************************************************************************                                                            
**  Table 07 : Client Services Last Seen On (Date)                                  
*******************************************************************************/
		--SELECT Convert(Varchar,Max(DateOfService),101) FROM Services S WHERE (RecordDeleted = 'N' OR RecordDeleted IS NULL) AND S.ClientId = C.ClientId AND S.Status in (Select globalcodeId FROM globalcodes WHERE (RecordDeleted = 'N' OR RecordDeleted IS NULL)AN
		--D category like 'SERVICESTATUS%' AND (CodeName='Complete' OR CodeName='Show'))                                                            
            SELECT TOP 1
                    ServiceId ,
			--convert(datetime,Convert(Varchar,DateOfService,101))LastSeenOn                                                           
                    CONVERT(VARCHAR, DateOfService, 101) LastSeenOn
            FROM    Services
            WHERE   ClientId = @ClientId
                    AND ISNULL(RecordDeleted, 'N') <> 'Y'
                    AND STATUS IN ( 71, 75 )
                    AND Billable = 'Y'
            ORDER BY DateOfService DESC

		/*******************************************************************************                                                            
**  Table 08 : Next Scheduled on                        
*******************************************************************************/
            SELECT TOP 1
                    DateOfService AS NextScheduled ,
                    ServiceId
            FROM    Services
            WHERE   ClientId = @ClientId
                    AND ISNULL(RecordDeleted, 'N') <> 'Y'
                    AND STATUS = 70
                    AND DateOfService >= GETDATE()
            ORDER BY DateOfService

		/******************************************************************************                                                             
**      Table : 09 : First 10 Client Notes                                                            
******************************************************************************/
		--DECLARE @NoteType INT                                                            
		--DECLARE @Bitmap  VARCHAR(250)                                                  
		--DECLARE @BitmapNo INT                                                            
		--DECLARE @Counter INT                                                            
		--DECLARE @TempGroupId INT                                                            
		----Declare cursor                                                            
		--DECLARE NotesSelect CURSOR FAST_FORWARD FOR                                                             
		--SELECT                                                             
		--  CN.ClientId                                                            
		-- ,CN.NoteType                                                            
		-- ,GC.Bitmap                                                             
		--FROM                                                            
		-- ClientNotes CN LEFT OUTER JOIN GlobalCodes GC ON CN.NoteType=GC.GlobalCodeId                                                            
		--                                                             
		--WHERE                                                      
		-- GC.Category='ClientNoteType'                                                            
		--AND                                                            
		-- CN.ClientId = @ClientId                                                            
		--AND                                                            
		-- (CN.RecordDeleted = 'N' OR CN.RecordDeleted IS NULL) AND CN.Active='Y'                                                        
		--and (CN.StartDate <= Getdate() and isnull(CN.EndDate, DateAdd(yy, 1, GetDate())) >= GetDate()) --Modified to include only notes that are have been endated before today and active today AVOSS 7/26/2007               
		--OPEN NotesSelect                                                            
		--FETCH NotesSelect INTO @ClientId,@NoteType,@Bitmap                                                            
		--                                                            
		--SET @Counter=1                                                            
		--SET @TempGroupId=0                                                            
		--CREATE TABLE #TempClientNotes                                                            
		--(                                                            
		-- ClientId int,                                                            
		-- NoteType int,                                                     
		-- BitmapNo int,                                                            
		-- Bitmap1 varchar(50),                                                            
		-- Bitmap2 varchar(50),                                                            
		-- Bitmap3 varchar(50),                                                            
		-- Bitmap4 varchar(50),                                                            
		-- Bitmap5 varchar(50),                                                      
		-- Bitmap6 varchar(50),                                                            
		-- Bitmap7 varchar(50),                                                            
		-- Bitmap8 varchar(50),                                                            
		-- Bitmap9 varchar(50),                                                            
		-- Bitmap10 varchar(50)                              
		--)                                                            
		--                                                            
		--WHILE @@Fetch_Status = 0                         
		--BEGIN                                                              
		--                                                
		-- IF @TempGroupId=@ClientId                                                            
		-- BEGIN                                                            
		-- SET @Counter=@Counter + 1                                                            
		--  --call sp to find status of the groupservice                                                            
		-- END                                                            
		-- ELSE                                                            
		-- BEGIN                                                            
		--  SET @TempGroupId=@ClientId                                                            
		--  SET @Counter=1                   
		--  --Select @GroupId                                                            
		-- END                                                            
		-- IF @Counter=1                                                            
		-- BEGIN                                                            
		--                                                              
		--  INSERT INTO #TempClientNotes(ClientId , NoteType ,BitmapNo ,Bitmap1)                                                            
		--  VALUES(@ClientId, @NoteType,1, @Bitmap)                                                            
		-- END                                                            
		-- ELSE IF @Counter=2                                                            
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=2, Bitmap2=@Bitmap WHERE ClientId=@ClientId                      
		-- END                                 
		-- ELSE IF @Counter=3                                                            
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=3, Bitmap3=@Bitmap WHERE ClientId=@ClientId END                                                            
		-- ELSE IF @Counter=4                                                            
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=4, Bitmap4=@Bitmap WHERE ClientId=@ClientId                                                            
		-- END                                                            
		-- ELSE IF @Counter=5                                               
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=5, Bitmap5=@Bitmap WHERE ClientId=@ClientId                                                            
		-- END                         
		-- ELSE IF @Counter=6                                                            
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=6, Bitmap6=@Bitmap WHERE ClientId=@ClientId                                                            
		-- END                                                            
		-- ELSE IF @Counter=7                                                            
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=7, Bitmap7=@Bitmap WHERE ClientId=@ClientId                                                            
		-- END                                                            
		-- ELSE IF @Counter=8                                                            
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=8, Bitmap8=@Bitmap WHERE ClientId=@ClientId                                           
		-- END                                           
		-- ELSE IF @Counter=9                                                            
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=9, Bitmap9=@Bitmap WHERE ClientId=@ClientId                                                            
		-- END                                                            
		-- ELSE IF @Counter=10                                                    
		-- BEGIN                                                            
		--  UPDATE #TempClientNotes SET BitmapNo=10, Bitmap10=@Bitmap WHERE ClientId=@ClientId                     
		-- END                                                            
		--FETCH NEXT FROM NotesSelect INTO @ClientId,@NoteType,@Bitmap                                                            
		--                                                            
		--END                         
		--CLOSE NotesSelect                                                          
		--DEALLOCATE NotesSelect                                                            
		--                                                                
		--SELECT * FROM #TempClientNotes                                                     
		--DROP TABLE #TempClientNotes                                                                
		/******************************************************************************                                            
**      Table : 10 : First 10 Client Notes                                                            
******************************************************************************/
		--SELECT * FROM ClientNotes CN WHERE ISNULL(RecordDeleted,'N') = 'N'  AND Active = 'Y' AND ClientId = @ClientId                                                            
		--and (CN.StartDate <= Getdate() and isnull(CN.EndDate, DateAdd(yy, 1, GetDate())) >= GetDate())--Modified by Jaspreet on 31-Aug-2007 as per the temporary notes table above.                                                        
		--For AXIS                                                             
          
    
		--  scooter (2014-12-18):  changed logic to match logic from ssp_SCClientSummaryInfo
		--
		
          
		-- get the Program Name from the Program Tables                                                               
            SELECT  ProgramName
            FROM    Programs
            WHERE   ProgramId = ( SELECT TOP 1
                                            ProgramId
                                  FROM      ClientPrograms
                                  WHERE     clientid = @ClientId
                                            AND PrimaryAssignment = 'Y'
                                            AND ISNULL(RecordDeleted, 'N') = 'N'
                                )
                    AND ISNULL(RecordDeleted, 'N') = 'N'

         
		                                                                
		
/******************************************************************************                                                
**      Table  :   Dignosis Details  added  by Pabitra  on 28/7/2015
                                                                    
******************************************************************************/     
         DECLARE @varDocumentid INT    
         DECLARE @varVersion INT 
         DECLARE @DSM5DOC CHAR(1) 
         DECLARE @DocumentCodeId INT

        
	    SELECT TOP 1  
                @varDocumentId = D.DocumentId ,  
                @varVersion = D.CurrentDocumentVersionId ,
                @DSM5DOC=ISNULL(DC.DSMV,'N'),@DocumentCodeId = Dc.DocumentCodeId
        FROM    Documents D  
                INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeId = D.DocumentCodeId  
        WHERE   D.ClientId = @ClientId 
               -- AND d.DocumentCodeId in(5,1601) 
                AND D.[Status] = 22  
                AND ISNULL(D.RecordDeleted, 'N') = 'N'  
                AND Dc.DiagnosisDocument = 'Y'  
                AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'  
        ORDER BY D.EffectiveDate DESC ,  
                D.ModifiedDate DESC 
                
 IF EXISTS (select 1 from DiagnosesIandII where DocumentVersionId = @varVersion)
     BEGIN
		SET @DSM5DOC = 'N'
     END
     IF EXISTS (select 1 from DocumentDiagnosisCodes where DocumentVersionId = @varVersion)
     BEGIN
		SET @DSM5DOC = 'Y'
	 END
                     
if (@DSM5DOC = 'N')
begin
            DECLARE @DSMCode VARCHAR(MAX)

            SELECT  @DSMCode = CASE ISNULL(@DSMCode, '')
                                 WHEN '' THEN ''
                                 ELSE @DSMCode + ', '
                               END + CAST(LTRIM(RTRIM(DI.DSMCode)) AS VARCHAR(6)) + ' ' + ISNULL(DD.DSMDescription, '[Unable to find matching description for DSM Code]') + CASE DI.RuleOut
                                                                                                                                                                              WHEN 'Y' THEN ' R/O'
                                                                                                                                                                              ELSE ''
                                                                                                                                                                            END
            FROM    DiagnosesIandII AS DI
                    LEFT JOIN DiagnosisDSMDescriptions AS DD ON DI.DSMCode = DD.DSMCode AND DI.DSMNumber = DD.DSMNumber
            WHERE   DocumentVersionId = @varVersion
            ORDER BY CASE WHEN diagnosistype = 140 THEN 1
                          ELSE 2
                     END ,
                    CASE ISNULL(RuleOut, 'N')
                      WHEN 'Y' THEN 2
                      ELSE 1
                    END ,
                    DiagnosisOrder ASC

            SELECT 
                 --   CASE Diag.DiagnosisType WHEN 140 THEN 'Primary'
                 --   WHEN 141 THEN 'Principal'
                 --   WHEN 142 THEN 'Additional'
                 --ELSE  '' 
                 --END as DiagnosisType,
                 dbo.ssf_GetGlobalCodeNameById(Diag.DiagnosisType) as DiagnosisType,
                    Diag.DSMCode AS ICD9Code ,
                    '' as ICD10Code,
                    '' as DSMV,
                  --Modified by Pavani on 10/12/2015   
                  --Start
                    '' as 'R/O',
                  --End
                    ISNULL(DD.DSMDescription, '[Unable to find matching description for DSM Code]') + CASE Diag.RuleOut
                                                                                                                                                                              WHEN 'Y' THEN ' R/O'
                                                                                                                                                                              ELSE ''
                                                                                                                                                                            END  AS ICDDescription 
                                                                                                                                                                            ,@DocumentCodeId as DocumentCodeId
            FROM    DiagnosesIandII Diag
             LEFT JOIN DiagnosisDSMDescriptions AS DD ON Diag.DSMCode = DD.DSMCode AND Diag.DSMNumber = DD.DSMNumber
            WHERE   DocumentVersionId = @varVersion
                    AND ISNULL(Diag.RecordDeleted, 'N') <> 'Y'
                    AND @DSMCode IS NOT NULL
            ORDER BY CASE WHEN diagnosistype = 140 THEN 1
                          ELSE 2
                     END ,
                    CASE ISNULL(RuleOut, 'N')
                      WHEN 'Y' THEN 2
                      ELSE 1
                    END ,
                    DiagnosisOrder ASC
  
    end
    else
    begin
      SELECT       GC.Codename as DiagnosisType,DDC.ICD9Code, DDC.ICD10Code,
				 CASE ISNULL(ICD10.DSMVCode,'N') WHEN 'Y' THEN 'Yes'
                 ELSE  'No' 
                 END as DSMV,
                 --Modified by Pavani on 10/12/2015   
                 --Start
                 CASE ISNULL(DDC.RuleOut,'N') WHEN 'Y' THEN 'Yes' ELSE  ''
                 END as 'R/O',
                 --End
                  ICD10.ICDDescription,
                 @DocumentCodeId as DocumentCodeId
    FROM          DocumentDiagnosisCodes DDC 
      
      INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
                 INNER JOIN
                 GlobalCodes GC                   ON DDC.DiagnosisType = GC.GlobalCodeId
    WHERE       DDC.DocumentVersionId =   @varVersion    AND ISNULL(DDC.RecordDeleted,'N') <> 'Y'  
    end   
         
  -----End of Diagonisis--------
			    
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientSummary') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				, -- Message text.     
				16
				, -- Severity.     
				1 -- State.     
				);
        END CATCH

        RETURN
    END


