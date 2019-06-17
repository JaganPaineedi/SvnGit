/****** Object:  StoredProcedure [dbo].[ssp_SCClientSummaryInfo]    Script Date: 08/25/2015 13:43:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCClientSummaryInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCClientSummaryInfo]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCClientSummaryInfo]    Script Date: 08/25/2015 13:43:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCClientSummaryInfo]  
    @ClientId INT ,  
    @ClinicianId INT  
AS /**********************************************************************/    
/* Stored Procedure: dbo.ssp_ClientSummaryInfoTest              */    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */    
/* Creation Date:    18/08/2009                      */    
/*                                                                   */    
/* Purpose:It is used in client Summary Page Information from various tables     */    
/*                                                                   */    
/* Input Parameters: @ClientId, @ClinicianId                */    
/*                                                                   */    
/* Output Parameters:   None                               */    
/*                                                                   */    
/* Return:  0=success, otherwise an error number                     */    
/*                                                                   */    
/* Called By:                                                        */    
/*                                                                   */    
/* Calls:                                                            */    
/*                                                                   */    
/* Data Modifications:                                               */    
/*                                                                   */    
/* Updates:                                                          */    
/*  Date     Author       Purpose                                    */    
/*18/08/2009  Anuj        Created                                    */    
/*13/11/2009  Ankesh      Modified    
/*16/11/2009  Anuj      Modified*/                                          */    
/* 25 Feb 2010 Pradeep   Made changes in "For Next Scheduled" select Statement to convert date in MM/dd/yyy*/    
/*20/05/2010   Mahesh   get service id to open service note page from   client summary page on last seen on & next scheduled links    
 1/3/2011 avoss corrected Logic for determining "NotePlan" data, Added New assessment documentCodeId for presenting problem,    
  corrected logic for determining most recent diagnosis document, corrected ordering of DSM codes, corrected issue    
      with complete DSM code not being displayed, Corrected Last seen on date logic,  Corrected most recent Axis V logic    
*/    
/* 1/12/2011 Himanshu Chetal Added a column CareManagementId in the columns retrieved from the clients table */    
/* 03-Feb-2012 Rakesh Garg   Changes the name in order Lastname, FirstName for ClientContacts w.rf to task 664 in SC web phaseII bugs/Features */    
  
/*22/06/2012  Rohit Katoch      ref:task#1292 in threshold bugs and features.   */       
/* 23 May 2012 Rahul Aneja Changed The Sequence Appropriate according to the Data service table List*/    
/* 09 AGU 2012 Jagdeep Hundal  Modify for getting latest diagnosis*/    
/* 01-08-2013 Kalpers  -  Added flag called CanViewService to indicate if the next scheduled service can be clicked on */   
/* 01-09-2013 Kalpers -   Commented out call to scsp_SCClientSummaryInfoPresentingProblem because it is not in the list of tables     */  
/*20-Feb-2013 dharvey(Merge by vikesh) took out the convert on next scheduled service and changed to dbo.removetimestame(getdate())   */  
/*27-Feb-2013 Robert(Merge by Sudhirsi) Romoved conversion of 'dateofService' to varhcar datatype as per task 256 in Venture Region Support.line No 440*/  
/*Oct   18 2013   Shruthi.S       Pulling entire SSN to display on mouseover.Ref #237 St.Joe-Support.  */  
/*26 November 2013  Aravind      Uncommented the call to scsp_SCClientSummaryInfoPresentingProblem - #247 - Core Bugs */
/* Jan   21 2014   Veena           Added code to display Description with ICD and DSM codes for AxisIandII and AxisIII  Allegan Enhancements #2*/  
/* Jan   22 2014   Veena           Added code to avoid showing Specification multiple times with ICD codes for  AxisIII */  
/* Feb   26 2014   Manju P         Added ISNULL condition checking for Axis 111 What/Why : Philhaven - Customization Issues Tracking Task #1005 SC-Axis III Diagnosis does not appear on Client Summary Page */  
/*		12-May-2014		Ponnin			Added DoNotContact (DNC) text after the phone number if it is checked in Client information Detail page. */
/*		08-JUL-2014		PPOTNURU		Added RecordDeleted check for staff, as it is retrieving record deleted staff */
/*	10/10/2014	JSchultz			Match on DSM Number along with DocumentVersionId	*/
/*	02/09/2015	NJain				Removed Use Test Smartcare from the top
									Added RecordDeleted check on DiagnosesIandII table   */
/*  28/07/2015  Pabitra				Added Diagnosis,Last Third Party Payment  ,Last Client Payment tables */
/*  30/07/2015  MD Khusro			Merged Bob Fagaly changes for Race column w.r.t #142 Core Bugs */                           
/* 20/Aug/2015	Malathi Shiva		Included DSMV check changes */     
/* 02/Sept/2015	Malathi Shiva		Added DSMNumber check since there were duplicate Descriptions with different DSMNumber.*/  
/* 22/Sept/2015	Chethan N			What : Added order by clause to DocumentDiagnosisCodes to display primary diagnosis in the first position.
									Why : Philhaven-Support task #33 */      
/* 28/Sep/2015  Shankha			    Changed the logic to return the Code Name for DiagnosisType instead of hard coded values*/	
/* 10/Dec/2015	Pavani              Added RuleOut to display Diagnosis w.r.t #792 Core Bugs*/
/* 17/Jun/2016	Shivnand            ClientSearch By OrganizationName,Network 180 Environment Issues Tracking #629*/	
/* 10/Nov/2016	Ajay				What: Added Primary PhysicianName and PrimaryPhysicianId. Key Point is asking to have the primary physician from Client Information general tab added as a value that shows in the Client Summary screen. Engineering Improvement Initiatives- NBL(I): Task# 376
/* 01/Feb/2017	Prateek				What: Added condition so the diagnosis information is displayed in Client Summary w.r.t. Van Buren Support 483  */ 
   10 Feb 2017 Vithobha   Added InternalCollections,ExternalCollections columns in Clients table, Renaissance - Dev Items #830 
/* 4/13/2017   MD		  Added active check condition for ClientContacts table w.r.t Valley - Support Go Live #1150.1  */
--  11/Dec/2017		Sunil.Dasari   What:Added one more extra case condition to Client Sex Field to get Unknown as Sex Value.
								   Why:Client Summary: Sex is displayed as blank if it is set as 'Unknown' in client information demographic
									Core Bugs - #2457 	
15 Jan 2017 Himmat					Depend on ClientType settting EIN and SSN Number Core Bugs#2509 
20 Feb 2017 RK						MHP-Customizations - Task 121 -  Client Hover: Enhancements being requested    
04 Dec 2018 Ponnin					Added Active check to display Active staff of Primary Clinician and Primary Physician from Staff table. AHN-Support Go Live #424
								
 */						  											  						
/*********************************************************************/    
    
    BEGIN    
    -- Clients  
        DECLARE @later DATETIME    
        SELECT  @later = GETDATE()    
--Added by anuj on 21Nov,2009    
        DECLARE @phoneNumber AS VARCHAR(200)   
          /* Added DNC logic on 12-May-2014	by Ponnin */ 
        SELECT  @phoneNumber = COALESCE(@phoneNumber + ', ','') + CAST(PhoneNumber AS varchar(50))  + case when DoNotContact = 'Y' then ' (DNC)' else '' end  
        FROM    clientPhones  
        WHERE   clientId = @ClientId   
/*and phonetype in(30,31) */  
                AND ISNULL(RecordDeleted, 'N') <> 'Y'  
        ORDER BY ( CASE WHEN IsPrimary = 'Y' THEN 1  
                        ELSE 0  
                   END ) DESC  
--Ended Over here    
    
--get the Details of the client  (--CONVERT(varchar(10),DATEDIFF(year,  C.dob, getdate())) +' Year'  as Age)    
        SELECT  DISTINCT  
                --( C.LastName + ', ' + C.FirstName ) AS Name , 
                case when  ISNULL(C.ClientType,'I')='I' then RTRIM(ISNULL(C.LastName,'')) + ', ' + RTRIM(ISNULL(C.FirstName,'')) else RTRIM(ISNULL(C.OrganizationName,'')) end  AS Name, 
                CONVERT(VARCHAR(10), C.dob, 101) AS DOB ,  
                CAST(DATEDIFF(yy, C.DOB, @later)  
                - CASE WHEN @later >= DATEADD(yy, DATEDIFF(yy, C.DOB, @later),  
                                              C.DOB) THEN 0  
                       ELSE 1  
                  END AS VARCHAR(10)) + ' Year' AS Age ,  
                CASE WHEN C.Sex = 'F' THEN 'Female'  
                     WHEN C.Sex = 'M' THEN 'Male' 
                     WHEN C.Sex = 'U' THEN 'Unknown'  
                     ELSE ''  
                END AS Sex ,  
                CASE 
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
							SELECT CodeName
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
				END AS CodeName,  
                (CASE WHEN C.ClientType = 'O' THEN C.EIN  
                           ELSE C.SSN  
                      END)  SSN ,  
                S.StaffId ,  
                ( S.LastName + ', ' + S.FirstName ) AS ClinicianName , 
                ( S1.LastName + ', ' + S1.FirstName ) AS PhysicianName , --Added by Ajay
                 S1.StaffId,                                    --Added by Ajay
                @phoneNumber AS PhoneNumber ,  
                C.ClientId ,    
--Modified By Anuj on 16Nov,2009    
                CA.ClientAddressId ,  
                CA.AddressType ,  
                CA.[Address] ,  
                CA.City ,  
                CA.[State] ,  
                CA.[Zip] ,  
                CA.Display ,  
                CA.Billing ,  
                CA.RecordDeleted ,    
--Changes Ended Over here    
--CA.*,    
                dbo.getFeeArrangement(@ClientId) AS FeeArrangement ,  
                C.CareManagementId 
                --10 Feb 2017 Vithobha
                ,CASE WHEN C.InternalCollections = 'Y' THEN 'Yes'  
                     ELSE 'No'  
                     END AS InternalCollections
                ,CASE WHEN C.ExternalCollections = 'Y' THEN 'Yes'  
                     ELSE 'No'  
                     END AS ExternalCollections
        FROM    Clients C  
                LEFT JOIN ClientRaces CR ON CR.Clientid = C.ClientId  
                                            AND ISNULL(CR.RecordDeleted, 'N') = 'N'  
                --LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CR.RaceId  
                LEFT JOIN Staff S ON S.StaffId = C.PrimaryClinicianId AND ISNULL(S.RecordDeleted, 'N') <> 'Y'  AND S.Active = 'Y'
                LEFT JOIN Staff S1 ON S1.StaffId = C.PrimaryPhysicianId AND ISNULL(S1.RecordDeleted, 'N') <> 'Y'  AND S1.Active = 'Y' --Added by Ajay
                LEFT JOIN ClientAddresses CA ON C.ClientId = CA.ClientId  
                                                AND CA.Addresstype = 90  
                                                AND ISNULL(CA.RecordDeleted,  
                                                           'N') = 'N'  
        WHERE   ISNULL(C.RecordDeleted, 'N') <> 'Y'  
                AND C.ClientId = @ClientId    
    
--get the phone number of the client    
--select top 2  PhoneNumber from clientPhones where clientId=@ClientId and phonetype in(30,31)  and isNull(RecordDeleted,'N')<>'Y' order by phonetype    
    
--get the Notes Plan Data From Notes    
--***************************************************************    
-- Notes  
        EXEC scsp_SCClientSummaryInfoNote @ClientId  
  
    
--***************************************************************    
    
--get the Presenting Problem from the client(Incomplete)    
        DECLARE @ExistDocCodeID INT    
        SET @ExistDocCodeID = 0    
        SELECT  @ExistDocCodeID = MAX(DocumentCodeId)  
        FROM    Documents d                                                 --select * from documentcodes where documentName like '%ass%'    
        WHERE   ClientId = @ClientId  
                AND documentCodeId IN ( 101, 349, 1469 )  
                AND ISNULL(RecordDeleted, 'N') = 'N'  
                AND d.status = 22    
    
  --Blank  
--Presenting Problem is not filled out on Summary Page --av    
        SELECT  '' ,  
                1 ,  
                1 ,  
                1    
    
--Changes end over here    
-- CLient Contacts    
--Get the Emergency Phone numbers    
--Changes the name in order Lastname,FirstName for ClientContacts w.rf to task 664 in SC web phaseII bugs/Features    
        SELECT  ( CC.LastName + ', ' + CC.Firstname + ' ' + CCP.PhoneNumber ) AS Name  
        FROM    Clients C  
                INNER JOIN ClientContacts CC ON C.ClientID = CC.ClientID  
                LEFT OUTER JOIN ClientContactPhones CCP ON CC.ClientContactID = CCP.ClientContactID  AND ISNULL(CCP.RecordDeleted, 'N') = 'N' 
        WHERE   C.ClientID = @ClientId  
                AND CC.EmergencyContact = 'Y'  
                AND ISNULL(cc.RecordDeleted, 'N') <> 'Y'   
                AND ISNULL(C.RecordDeleted, 'N') = 'N'    
				AND ISNULL(CC.Active,'Y') = 'Y'  -- Added by MD on 4/13/2017 (Null record is considered as Active to handle old data)
  
    
    
        SELECT TOP 1  
                GC.CodeName ,  
                CONVERT(VARCHAR(10), CEP.RegistrationDate, 101) AS RegistrationDate  
        FROM    ClientEpisodes CEP  
                JOIN Globalcodes GC ON CEP.[Status] = GC.GlobalCodeId  
        WHERE   CEP.Clientid = @ClientId  
                AND ISNULL(CEP.RecordDeleted, 'N') = 'N'  
        ORDER BY CEP.EpisodeNumber DESC    
    
        SELECT TOP 1  
                CONVERT(VARCHAR(10), S.DateOfService, 101) AS DateOfService ,  
                S.ServiceID AS [LastSeenOnServiceId] ,  
                D.DocumentId AS [LastSeenOnDocumentId]/*Modification End on  20 May, 2010,Purpose : get service id to open service note page from   client summary page on last seen on & next scheduled links(**/  
        FROM    [Services] S -- changed to a LEFT JOIN by TER 05/19/2012    
                LEFT JOIN Documents D ON ( S.ServiceId = D.ServiceId  
                                           AND ISNULL(D.RecordDeleted, 'N') = 'N'  
                                         )  
        WHERE   S.clientid = @ClientId  
                AND CONVERT(VARCHAR(10), S.dateOfService, 101) <= GETDATE()    
--and convert(varchar(10),S.dateOfService,101)<=Convert(varchar(10),getDate(),101)    
                AND S.[Status] IN ( 71, 75 )  
                AND ISNULL(S.RecordDeleted, 'N') = 'N'    
/* and not exists    
(select * from Services  b    
where b.clientid=@ClientId    
and convert(varchar(10),b.dateOfService,101)<=Convert(varchar(10),getDate(),101)    
and b.Status in (71, 75)    
and b.DateOfService > a.DateOfService and IsNull(b.RecordDeleted,'N')='N') */  
        ORDER BY s.DateOfService DESC    
--order by D.modifieddate desc    
    
    
    
    
/*For Next Scheduled*/    
        SELECT TOP 1  
                CONVERT(VARCHAR(10), s.DateOfService, 101) AS DateOfService ,  
                d.Documentid [ServiceNoteDocumentID] ,  
                s.ServiceId [ServiceId] /*Modification End on  20 May, 2010,Purpose : get service id to open service note page from   client summary page on last seen on & next scheduled links(**/ ,  
                CASE WHEN ( d.AuthorId = @ClinicianId  
                            OR -- Current staff is an author                          
                            EXISTS ( SELECT *  
                                     FROM   StaffProxies a  
                                     WHERE  a.ProxyForStaffId = d.AuthorId  
                                            AND a.StaffId = @ClinicianId  
                                            AND ISNULL(a.RecordDeleted, 'N') <> 'Y' )  
                            OR -- Current staff is Proxy  
                            d.ProxyId = @ClinicianId  
                            OR  -- Current staff is a proxy                          
                            d.Status IN ( 22, 23 )  
                            OR  -- Document is in the final status: Signed or Cancelled                          
                            d.DocumentShared = 'Y'  
                          ) -- Document is shared     
                          THEN 'Y'  
                     ELSE 'N'  
                END AS CanViewService  
        FROM    [services] s  
		LEFT JOIN documents d ON d.serviceid = s.Serviceid  
			AND ISNULL(d.RecordDeleted, 'N') = 'N'  
        WHERE   s.[status] = 70  
                AND s.clientid = @ClientId  
           --     AND CONVERT(VARCHAR(10), s.DateOfService, 101) >= CONVERT(VARCHAR(10), GETDATE(), 101)  
     AND s.DateOfService > GETDATE()   --Robert 27/02/2012 Task #256 in Venture Region Support.  
                AND dbo.RemoveTimeStamp(s.DateOfService)>=dbo.RemoveTimeStamp(GETDATE()) --dharvey 12/06/2012   
                AND ISNULL(s.RecordDeleted, 'N') = 'N'  
        ORDER BY s.DateOfService    
    
/*----Changed The Sequence Appropriate according to the Data service table List-----------------------*/    
----------------Added By Ashwani Kumar Angrish on 10 Jan 2011--------------------------------------------    
----------------Changed for Harbor by Tom on 19 May 2011-------------------------------------------------    
    
        -- #KA 01092013 Commented out because it is not in the list of tables   
   EXEC scsp_SCClientSummaryInfoPresentingProblem @ClientId    
    
----------------End for Harbor by Tom on 19 May 2011-------------------------------------------------    
    
--Rohit changes end here  
    
-- get the Program Name from the Program Tables    
    
        SELECT  ProgramName  
        FROM    Programs  
        WHERE   ProgramId = ( SELECT TOP 1  
                                        ProgramId  
                              FROM      ClientPrograms  
                              WHERE     clientid = @ClientId  
                                        AND PrimaryAssignment = 'Y'  
                                        AND Status <> 5  
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
                INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = D.DocumentCodeid  
        WHERE   D.ClientId = @ClientId 
               -- AND d.DocumentCodeId in(5,1601) 
                AND D.[Status] = 22  
                AND ISNULL(D.RecordDeleted, 'N') = 'N'  
                AND Dc.DiagnosisDocument = 'Y'  
                AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'  
                AND ((exists(select 1 from DiagnosesIandII where DocumentVersionId =D.CurrentDocumentVersionId)) -- Added by Prateek 02/01/2017
                   or
                    (exists(select 1 from DocumentDiagnosisCodes where DocumentVersionId =D.CurrentDocumentVersionId)))
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
                  ICD10.ICDDescription
                 ,@DocumentCodeId as DocumentCodeId
    FROM          DocumentDiagnosisCodes DDC 
      
      INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
                 INNER JOIN
                 GlobalCodes GC                   ON DDC.DiagnosisType = GC.GlobalCodeId
    WHERE       DDC.DocumentVersionId =   @varVersion    AND ISNULL(DDC.RecordDeleted,'N') <> 'Y'
    ORDER BY CASE WHEN DDC.DiagnosisType = 140 THEN 1  
                          ELSE 2  
                     END ,
                    DiagnosisOrder ASC  
    end   
           
         
  -----End of Diagonisis--------
  /*******************************************************************************                                                   
**  Table : Last Third Party Payment                                                                  
*******************************************************************************/                                                                 
Select  top 1                             
  y.PaymentId,                                                                  
  y.FinancialActivityId,                                                                  
  case when y.PayerId is not null then x.PayerName else RTRIM(v.DisplayAs) end Payer,                                                                  
  '$' + Convert(Varchar,abs(z.Amount),20) as Amount,'#' + Convert(Varchar,y.ReferenceNumber,20) as ReferenceNumber,                             
  Convert(Varchar,y.DateReceived,101) As DateReceived1                                                                  
  FROM ARLedger z                                                                  
  JOIN Payments y ON (z.PaymentId = y.PaymentId)                                                                  
  LEFT JOIN Payers x ON (y.PayerId = x.PayerId)                                                                  
  LEFT JOIN CoveragePlans v ON (v.CoveragePlanId = y.CoveragePlanId)                                              
  where z.LedgerType = 4202                   
  and z.ClientId = @ClientId                                                                  
  and z.CoveragePlanId is not null                                                                  
  order by z.PostedDate desc                                                                  
                                                                  
                                        
/*******************************************************************************                                                                  
**  Table  : Last Client Payment                                                                  
*******************************************************************************/                                                                  
Select top 1                                  
 z.Paymentid,                                                                   
 z.FinancialActivityId,                                           
 '$' + Convert(Varchar,abs(z.Amount),20) as Amount,                                                                  
 '#' + Convert(Varchar,z.ReferenceNumber,20) as ReferenceNumber,                                                                  
 Convert(Varchar,z.DateReceived,101) As DateReceived                                                     
  FROM Payments z                                         
  where z.ClientId = @ClientId                                                                  
  and isnull(z.RecordDeleted,'N') <> 'Y'                                      
  order by  paymentid  desc                                                                 
--  order by cast(z.DateReceived as datetime)  desc    

 /******************************************************************************    
 Table for guardian Info for given client    
 Added for     
 What: Client Hover: Enhancements being requested    
 Why: MHP-Customizations - Task 121     
 ******************************************************************************/   
     ----Guardion-----------------------------        
    DECLARE @Gaurdian VARCHAR(MAX)           
    SET @Gaurdian = ''        
    SELECT   @Gaurdian = @Gaurdian + ( CC.LastName + ' ' + CC.Firstname   )  + ', '        
    FROM    Clients C 
    LEFT OUTER JOIN ClientContacts CC ON C.ClientID = CC.ClientID                
    WHERE   C.ClientID = @ClientId   
     AND CC.guardian = 'Y'           
     AND ISNULL(cc.RecordDeleted, 'N') <> 'Y'               
     AND ISNULL(C.RecordDeleted, 'N') = 'N'                
    AND ISNULL(CC.Active,'Y') = 'Y' ORDER BY C.ClientId      
           
    SET @Gaurdian = SUBSTRING(@Gaurdian, 0, LEN(@Gaurdian))    
    SELECT  @Gaurdian AS NAME  
    ----End Guardion-----------------------------                                                                 
    
        IF ( @@error != 0 )   
            BEGIN    
                RAISERROR ('Client Summary: An Error Occured ' ,16,1)   
                RETURN(1)    
            END    
        RETURN(0)    
    END    
GO


