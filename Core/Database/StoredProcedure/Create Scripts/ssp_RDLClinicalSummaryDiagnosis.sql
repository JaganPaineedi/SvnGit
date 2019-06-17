
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryDiagnosis]
GO




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
  
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryDiagnosis] 
  @ServiceId INT = NULL  
 ,@ClientId INT  
 ,@DocumentVersionId INT = NULL  
AS  
/******************************************************************************                        
**  File: ssp_RDLClinicalSummaryDiagnosis.sql       
**  Name: ssp_RDLClinicalSummaryDiagnosis       
**  Desc: Provides general client information for the Clinical Summary and CCR/CCD       
**                         
**  Return values:                         
**                          
**  Called by:                            
**                                       
**  Parameters:                         
**  Input      Output                         
**  ServiceId      -----------                         
**                         
**  Created By:  Veena S Mani       
**  Date:    Feb 24 2014       
*******************************************************************************                        
**  Change History                         
*******************************************************************************                        
**  Date:  Author:    Description:                         
**  -------- --------   -------------------------------------------          
**  02/05/2014  Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18          
**  19/05/2014 Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.              
**  10/07/2014  Veena               added distinct to avoid duplicates  and update axis to Null in case of Client Problems.                   
**  16/07/2014  Veena S Mani        Added  RecordDeleted check      
** 03/09/2014 Revathi    what:check RecordDeleted      
         why:task#36 MeaningfulUse        
-- OCT-08-2014  Akwinass             Removed join for 'DiagnosisCode1,DiagnosisNumber1,DiagnosisCode2,DiagnosisNumber2,DiagnosisCode3,DiagnosisNumber3' from Services table and modified the logic using ServiceDiagnosis table (Task #134 in Engineering Impro
  
    
vement Initiatives- NBL(I))                
** 05/11/2014   Veena S Mani         Added the new diagnosis logic Ref:csp_MeaningfulUseReportDiagnosisHistory       
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */  
*******************************************************************************/  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from       
 -- interfering with SELECT statements.       
 SET NOCOUNT ON;  
  
 DECLARE @LatestICD10DocumentVersionID INT  
 DECLARE @StartDate DATETIME  
 DECLARE @EndDate DATETIME  
  
 SET @LatestICD10DocumentVersionID = (  
   SELECT TOP 1 CurrentDocumentVersionId  
   FROM Documents a  
   INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid  
   WHERE a.ClientId = @ClientID  
    AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))  
    AND a.STATUS = 22  
    AND Dc.DiagnosisDocument = 'Y'  
    AND a.DocumentCodeId = 1601  
    AND isNull(a.RecordDeleted, 'N') <> 'Y'  
    AND isNull(Dc.RecordDeleted, 'N') <> 'Y'  
   ORDER BY a.EffectiveDate DESC  
    ,a.ModifiedDate DESC  
   )  
  
 SELECT @StartDate = (  
   SELECT MIN(a.EffectiveDate)  
   FROM Documents a  
   INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid  
   WHERE a.ClientId = @ClientID  
    AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))  
    AND a.STATUS = 22  
    AND Dc.DiagnosisDocument = 'Y'  
    AND a.DocumentCodeId = 1601  
    AND isNull(a.RecordDeleted, 'N') <> 'Y'  
    AND isNull(Dc.RecordDeleted, 'N') <> 'Y'  
   )  
  
 SELECT @EndDate = (  
   SELECT MAX(a.EffectiveDate)  
   FROM Documents a  
   INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid  
   WHERE a.ClientId = @ClientID  
    AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))  
    AND a.STATUS = 22  
    AND Dc.DiagnosisDocument = 'Y'  
    AND a.DocumentCodeId = 1601  
    AND isNull(a.RecordDeleted, 'N') <> 'Y'  
    AND isNull(Dc.RecordDeleted, 'N') <> 'Y'  
   )  
  
 BEGIN TRY  
  DECLARE @IsProgressNote CHAR(1);  
  
  WITH ClientDiagnoses  
  AS (  
   SELECT DISTINCT a.ClientId  
  	-- Modified by   Revathi   20 Oct 2015
    ,case when  ISNULL(a.ClientType,'I')='I' then ISNULL(a.FirstName,'') + ' ' + ISNULL(a.LastName,'') else ISNULL(a.OrganizationName,'') end   AS ClientName  
    ,b.EffectiveDate  
    ,ds.SignatureDate  
    ,c.ICD9Code  
    ,  
    --REPLACE(( SELECT DISTINCT      
    --                    ICD9Codes.ICDDescription + CHAR(13) + CHAR(10)      
    --          FROM      dbo.DiagnosisICDCodes ICD9Codes      
    --          WHERE     ICD9Codes.ICDCode = c.ICD9Code      
    --        FOR      
    --          XML PATH('')      
    --        ), '&#x0D;', CHAR(13) + CHAR(10)) AS ICD9Desc ,      
    REPLACE((  
      SELECT DISTINCT ICD9Codes.ICDDescription + CHAR(13) + CHAR(10)  
      FROM dbo.DiagnosisICD10Codes ICD9Codes  
      INNER JOIN DiagnosisICD10ICD9Mapping ICD9MAP ON ICD9MAP.ICD10CodeId = ICD9Codes.ICD10CodeId  
      WHERE ICD9MAP.ICD9Code = c.ICD9Code  
      --AND ISNULL(ICD9MAP.RecordDeleted,'N')='N'  
      --AND ISNULL(ICD9Codes.RecordDeleted,'N')='N'  
      FOR XML PATH('')  
      ), '&#x0D;', CHAR(13) + CHAR(10)) AS ICD9Desc  
    ,c.ICD10Code  
    ,  
    --REPLACE((  
    --  SELECT DISTINCT ICD10Codes.ICDDescription + CHAR(13) + CHAR(10)  
    --  FROM dbo.DiagnosisICD10Codes ICD10Codes  
    --  WHERE ICD10Codes.ICD10Code = c.ICD10Code  
    --  FOR XML PATH('')  
    --  ), '&#x0D;', CHAR(13) + CHAR(10)) AS ICD10Desc  
    SNOMEDCTDescription As ICD10Desc  
    ,REPLACE((  
      SELECT DISTINCT e.SNOMEDCTCode + CHAR(13) + CHAR(10)  
      FROM dbo.ICD9SNOMEDCTMapping d  
      INNER JOIN dbo.SNOMEDCTCodes e ON e.SNOMEDCTCodeId = d.SNOMEDCTCodeId  
      WHERE d.ICD9Code = c.ICD9Code  
     -- AND ISNULL(e.RecordDeleted,'N')='N'  
     -- AND ISNULL(d.RecordDeleted,'N')='N'  
      FOR XML PATH('')  
      ), '&#x0D;', '  ') AS SNOMEDCodeICD9  
    ,  
    --e.SNOMEDCTDescription AS SNOMEDDescICD9 ,      
    --REPLACE(( SELECT DISTINCT      
    --                    g.SNOMEDCTCode + CHAR(13) + CHAR(10)      
    --          FROM      dbo.ICD10SNOMEDCTMapping f      
    --                    JOIN dbo.SNOMEDCTCodes g ON g.SNOMEDCTCodeId = f.SNOMEDCTCodeId      
    --          WHERE     f.ICD10CodeId = c.ICD10Code      
    --        FOR      
    --          XML PATH('')      
    --        ), '&#x0D;', '  ') AS SNOMEDCodeICD10 ,    
    c.SNOMEDCODE AS SNOMEDCodeICD10  
    ,  
    --g.SNOMEDCTDescription AS SNOMEDDescICD10 ,      
    'Y' AS ACTIVE  
    ,'12/31/2199' AS EndDate  
   FROM Clients a  
   INNER JOIN Documents b ON b.ClientId = a.ClientId  
    AND ISNULL(a.RecordDeleted, 'N') = 'N'  
    AND ISNULL(b.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.DocumentVersions dv ON dv.DocumentId = b.DocumentId  
    AND ISNULL(dv.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.DocumentDiagnosisCodes c ON c.DocumentVersionId = b.CurrentDocumentVersionId  
    AND ISNULL(c.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.DocumentSignatures ds ON ds.SignedDocumentVersionId = dv.DocumentVersionId  
    AND ISNULL(ds.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.SNOMEDCTCodes  s ON s.SNOMEDCTCode = c.SNOMEDCODE  
    --AND ISNULL(s.RecordDeleted, 'N') = 'N'  
      
   WHERE b.STATUS = 22  
    AND a.ClientId = @ClientId  
    --AND        
    --c.DocumentVersionId = @LatestICD10DocumentVersionID        
    AND CAST(b.EffectiveDate AS DATE) BETWEEN CAST(@StartDate AS DATE)  
     AND CAST(@EndDate AS DATE)  
   )  
  SELECT *  
  INTO #ClientDiagnoses  
  FROM ClientDiagnoses  
  ORDER BY SignatureDate ASC  
  
  /*   
        ---COMMENTED OUT FOR DATA PORATBILITY  
          
        DECLARE @I DATETIME -- Current Diagnosis      
        DECLARE @J DATETIME -- Previous Diagnosis      
        DECLARE @K DATETIME -- Next Diagnosis      
         
        SELECT  @I = MIN(SignatureDate)      
        FROM    #ClientDiagnoses      
         
        WHILE @I <= ( SELECT    MAX(SignatureDate)      
                      FROM      #ClientDiagnoses      
                    )      
            BEGIN      
          
   -- Select the immediate next diagnosis docuent      
                SELECT  @K = MIN(SignatureDate)      
                FROM    #ClientDiagnoses      
                WHERE   SignatureDate > @I      
          
          
    -- Now Compare diagnosis between @I and @K and Update @I as Active/Inactive          
                IF @K IS NOT NULL      
                    BEGIN      
                          
                        
                        UPDATE  a      
                        SET     Active = 'N' ,      
                                EndDate = ISNULL(CONVERT(VARCHAR, ( SELECT DISTINCT      
                                                                            EffectiveDate      
                                                                    FROM    #ClientDiagnoses      
                                                                    WHERE   SignatureDate = @K      
                                                                  ), 101), '12/31/2199')      
                             
                          
                        FROM    #ClientDiagnoses a      
                        WHERE   a.SignatureDate = @I      
                                AND ( LTRIM(RTRIM(ISNULL(a.ICD9Code, ''))) NOT IN ( SELECT DISTINCT      
                                                                                            LTRIM(RTRIM(ISNULL(ICD9Code, '')))      
                                                                                    FROM    #ClientDiagnoses      
                                                                                    WHERE   SignatureDate = @K )      
                                      OR LTRIM(RTRIM(ISNULL(a.ICD10Code, ''))) NOT IN ( SELECT DISTINCT      
                             LTRIM(RTRIM(ISNULL(ICD10Code, '')))      
                                                                                        FROM    #ClientDiagnoses      
                                                                                        WHERE   SignatureDate = @K )      
                                    )                  
                              
                              
                        -- Update the Prior actives      
                        select * from #ClientDiagnoses      
      UPDATE  a      
                        SET     Active = 'N' ,      
                                EndDate = b.EndDate      
                        FROM    #ClientDiagnoses a      
                                JOIN #ClientDiagnoses b ON ( LTRIM(RTRIM(ISNULL(a.ICD9Code, ''))) = LTRIM(RTRIM(ISNULL(b.ICD9Code, '')))      
                                                             OR LTRIM(RTRIM(ISNULL(a.ICD10Code, ''))) = LTRIM(RTRIM(ISNULL(b.ICD10Code, '')))      
                                                           )      
                        WHERE   a.ACTIVE = 'Y'      
                                AND a.SignatureDate < b.SignatureDate      
                                AND b.SignatureDate = @I      
                                AND b.ACTIVE = 'N'      
                              
                    END      
          
    -- Get the next diagnosis document       
                SELECT  @J = @I      
         
                SELECT  @I = MIN(SignatureDate)      
                FROM    #ClientDiagnoses      
                WHERE   SignatureDate > @J      
         
         
            END      
       */  
  --select * from #ClientDiagnoses      
  --SPECIAL CODE FOR DATA PORATBILITY  
  UPDATE a  
  SET Active = 'N'  
  -- EndDate = b.EndDate      
  FROM #ClientDiagnoses a  
  WHERE A.ICD9CODE IN( '462','486', '574.21','')  
  
  --select * from #ClientDiagnoses  
  SELECT TOP 8 ClientId  
   ,ClientName  
   ,MIN(EffectiveDate) AS EffectiveDate  
   ,MIN(SignatureDate) AS SignatureDate  
   ,ICD9Code  
   ,ICD9Desc  
   ,ICD10Code  
   ,ICD10Desc  
   ,SNOMEDCodeICD9  
   ,  
   --SNOMEDDescICD9 ,      
   SNOMEDCodeICD10  
   ,  
   --SNOMEDDescICD10 ,      
   ACTIVE  
   ,CONVERT(VARCHAR, EndDate, 101) AS EndDate  
   ,CASE   
    WHEN ACTIVE = 'Y'  
     THEN 'Active'  
    ELSE 'Resolved'  
    END AS STATUS  
   ,CASE   
    WHEN isnull(ICD10Desc, '') <> ''  
     THEN ICD10Desc  
    ELSE ICD9Desc  
    END AS Descri  
   ,CONVERT(VARCHAR, MIN(EffectiveDate), 101) AS StartDate  
  FROM #ClientDiagnoses  
  WHERE ACTIVE = 'Y'  
  GROUP BY ClientId  
   ,ClientName  
   ,ICD9Code  
   ,ICD9Desc  
   ,ICD10Code  
   ,ICD10Desc  
   ,SNOMEDCodeICD9  
   ,  
   --SNOMEDDescICD9 ,      
   SNOMEDCodeICD10  
   ,  
   --SNOMEDDescICD10 ,      
   ACTIVE  
   ,EndDate  
  ORDER BY EffectiveDate DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
  + CONVERT(VARCHAR(4000), Error_message()) + '*****' 
  + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_RDLClinicalSummaryDiagnosis')
   + '*****' + CONVERT(VARCHAR, Error_line())
    + '*****' + CONVERT(VARCHAR, Error_severity())
     + '*****' + CONVERT(VARCHAR, Error_state())  
  
  RAISERROR (  
    @Error  
    ,  
    -- Message text.                                                                      
    16  
    ,  
    -- Severity.                                                             
    1  
    -- State.                                                          
    );  
 END CATCH  
END  
  