
/****** Object:  StoredProcedure [dbo].[ssp_RDLRevenueReport]    Script Date: 29-10-2018 11:59:55 ******/
DROP PROCEDURE [dbo].[ssp_RDLRevenueReport]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLRevenueReport]    Script Date: 29-10-2018 11:59:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_RDLRevenueReport] @DateOfServiceFrom DATE  
 ,@DateOfServiceTo DATE  
 ,@DateOfServiceCreatedFrom DATE  
 ,@DateOfServiceCreatedTo DATE  
 ,@Programs VARCHAR(MAX)  
 ,@Plans VARCHAR(MAX)  
 ,@ProcedureCodeId VARCHAR(max)  
 ,@GlobalCodeId INT  
 /*********************************************************************/  
 /* Stored Procedure: dbo.[ssp_RDLRevenueReport]                   */  
 /* Copyright: 2013 Streamline Healthcare Solutions,  LLC             */  
 /* Creation Date:    04/12/2013                                      */  
 /*                                                                   */  
 /* Purpose: Generate Report for a list of all charges with complete  */  
 /*    status to make entries in the Clients GL             */  
 /*                                                                   */  
 /*                                                                   */  
 /* Parameters:                                                    */  
 /*  @DateOfServiceFrom Date,                                     */  
 /*  @DateOfServiceTo Date,                                       */  
 /*  @DateOfServiceCreatedFrom Date,                              */  
 /*  @DateOfServiceCreatedTo Date,                                */  
 /*  @Programs INT,                                               */  
 /*  @Plans INT                                                   */  
 /*                                                                   */  
 /* Data Modifications:                                               */  
 /*                                                                   */  
 /*                                                                   */  
 /*  Date        Author              Purpose                          */  
 /* 04/12/2013  Robert Caffrey      Creation                         */  
 /*  08/26/2013  Robert Caffrey      Modified to make standard        */  
 /*  09/11/2013  Matt Lightner       Modified to look at CoveragePlanId        */  
 /*  10/26/2016  jcarlson    added logic to show ICD10 Diagnosis if there is no DSM Diagnosis    
        added in missing balance, current charge and original charge fields    
        Converted to core, ssp from csp    
        removed use of csf in select statement, changed to using for xml path    
        changed program name to program code per streamline conventions    
        changed location name to use location code per streamline conventions    
        changed clinician name to use Staff.DisplayAs per streamline conventions*/  
    /*  03/31/2016  Gautam    Created temp table and later updated temp table ServiceErrorsString & ChargeErrorsString value  
         Why : XML processing was taking more for each row of data,Woods - Support Go Live #345,Revenue Report - Times out when run from the UI */   
 /* 11/22/2017 MJensen  Moved diagnosis code & cob 1 selection to separate sql statement due to duplicates */  
 /* 02/19/2018 MJensen  Changed program, procedure and coverage plan parameters to be multi-select  FCS Enhancements #209 */
 /* Msood 07/12/2018  What: Changed the logic to display the all Services without creating Charges 
					  Why: Family & Children's Services - Support Go Live #324 */
  
 /*********************************************************************/  
AS  
BEGIN  
BEGIN TRY  
--03/31/2016  Gautam    
CREATE TABLE #TempRdlRevenueReport (  
 ServiceId INT  
 ,ProgramCode VARCHAR(100)  
 ,ClientName VARCHAR(100)  
 ,ClientId INT  
 ,DOB DATETIME  
 ,ProcedureName VARCHAR(150)  
 ,BillingDiagnosis1 VARCHAR(20)  
 ,BillingDiagnosis2 VARCHAR(20)  
 ,BillingDiagnosis3 VARCHAR(20)  
 ,CPTCode VARCHAR(100)  
 ,DateOfService DATETIME  
 ,Units DECIMAL(18, 2)  
 ,AmountPaid MONEY  
 ,AmountAdjusted MONEY  
 ,AmountTransferred MONEY  
 ,ClinicianDisplayAs VARCHAR(60)  
 ,LocationCode VARCHAR(30)  
 ,CodeName VARCHAR(250)  
 ,CoveragePlanDisplayAs VARCHAR(100)  
 ,Cob1DisplayAs VARCHAR(100)  
 ,ServiceErrorsString VARCHAR(max)  
 ,ChargeErrorString VARCHAR(max)  
 ,OriginalCharge MONEY  
 ,CurrentCharge MONEY  
 ,Balance MONEY  
 ,ChargeId INT  
 ,ProgramId INT  
 )  
  
INSERT INTO #TempRdlRevenueReport (  
 ServiceId  
 ,ClientName  
 ,ClientId   ,DOB  
 ,ProcedureName  
 ,CPTCode  
 ,DateOfService  
 ,Units  
 ,AmountPaid  
 ,AmountAdjusted  
 ,AmountTransferred  
 ,ClinicianDisplayAs  
 ,LocationCode  
 ,CodeName  
 ,CoveragePlanDisplayAs  
 ,OriginalCharge  
 ,CurrentCharge  
 ,Balance  
 ,ChargeId  
 ,ProgramId  
 )  
SELECT s.ServiceId  
 ,ISNULL(cl.FirstName, ' ') + '  ' + ISNULL(cl.LastName, ' ') AS 'Client Name'  
 ,s.ClientId AS [Client ID]  
 ,cl.DOB AS [DOB]  
 ,pc.DisplayAs AS [Procedure Name]  
 ,ISNULL(c.BillingCode, '') + COALESCE(':' + c.Modifier1, '') + COALESCE(':' + c.Modifier2, '') + COALESCE(':' + c.Modifier3, '') + COALESCE(':' + c.Modifier4, '') AS 'CPT Code'  
 ,s.DateOfService AS [Date Of Service]  
 ,c.Units AS [Units]  
 ,ISNULL(ar.Amount, 0) AS [Amount Paid]  
 ,ISNULL(aradj.Amount, 0) AS [Amount Adjusted]  
 ,ISNULL(artr.Amount, 0) AS [Amount Transferred]  
 ,st.DisplayAs AS [Clinician Name]  
 ,l.LocationCode AS [Location]  
 ,gl.CodeName AS [Status]  
 ,cp.DisplayAs AS [Charge Coverage Plan]  
 ,ISNULL(s.Charge, 0) AS Original_Charge  
 ,ISNULL(ISNULL(archg.Amount, 0) + ISNULL(artr.Amount, 0), 0) AS Current_Charge  
 ,ISNULL(oc.Balance, 0) AS Balance  
 ,c.ChargeId AS ChargeID  
 ,s.ProgramId  
 -- Msood
FROM Services s  
LEFT JOIN  Charges c  ON s.ServiceId = c.ServiceId AND ISNULL(c.RecordDeleted, 'N') <> 'Y'    
LEFT JOIN dbo.OpenCharges AS oc ON c.ChargeId = oc.ChargeId  
JOIN Clients cl ON cl.ClientId = s.ClientId  
JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId  
JOIN Staff st ON st.StaffId = s.ClinicianId  
JOIN Locations l ON l.LocationId = s.LocationId  
JOIN GlobalCodes gl ON gl.GlobalCodeId = s.STATUS  
LEFT JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId  
-- Msood
AND ccp.CoveragePlanId IN (SELECT item FROM dbo.fnSplit(@Plans,','))  

LEFT JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId  
LEFT JOIN (  
 SELECT ChargeId  
  ,SUM(Amount) AS Amount  
 FROM dbo.ARLedger AS arCharges  
 WHERE arCharges.LedgerType = 4201 -- charge    
  AND ISNULL(RecordDeleted, 'N') <> 'Y'  
 GROUP BY ChargeId  
 ) AS archg ON archg.ChargeId = c.ChargeId  
LEFT JOIN (  
 SELECT ChargeId  
  ,SUM(Amount) AS Amount  
 FROM dbo.ARLedger AS arPayments  
 WHERE arPayments.LedgerType = 4202 -- payment    
  AND ISNULL(RecordDeleted, 'N') <> 'Y'  
 GROUP BY ChargeId  
 ) AS ar ON ar.ChargeId = c.ChargeId  
LEFT JOIN (  
 SELECT ChargeId  
  ,SUM(Amount) AS Amount  
 FROM dbo.ARLedger AS arAdjustments  
 WHERE arAdjustments.LedgerType = 4203 -- adjustment    
  AND ISNULL(RecordDeleted, 'N') <> 'Y'  
 GROUP BY ChargeId  
 ) AS aradj ON aradj.ChargeId = c.ChargeId  
LEFT JOIN (  
 SELECT ChargeId  
  ,SUM(Amount) AS Amount  
 FROM dbo.ARLedger AS arTransfers  
 WHERE arTransfers.LedgerType = 4204 -- transfer    
  AND ISNULL(RecordDeleted, 'N') <> 'Y'  
 GROUP BY ChargeId  
 ) AS artr ON artr.ChargeId = c.ChargeId  
WHERE   
  ISNULL(s.RecordDeleted, 'N') <> 'Y'  
 AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'  
 AND ISNULL(st.RecordDeleted, 'N') <> 'Y'  
 AND ISNULL(gl.RecordDeleted, 'N') <> 'Y'  
 AND DATEDIFF(DAY, s.DateOfService, @DateOfServiceFrom) <= 0  
 AND DATEDIFF(DAY, s.DateOfService, @DateOfServiceTo) >= 0  
 AND DATEDIFF(DAY, s.CreatedDate, @DateOfServiceCreatedFrom) <= 0  
 AND DATEDIFF(DAY, s.CreatedDate, @DateOfServiceCreatedTo) >= 0  
 AND s.ProgramId IN (SELECT item FROM dbo.fnSplit(@Programs,','))  
 AND s.ProcedureCodeId IN (SELECT item FROM dbo.fnSplit(@ProcedureCodeId,','))    
 AND (  
  @GlobalCodeId IS NULL  
  OR @GlobalCodeId = s.STATUS  
  )  
 --AND ccp.CoveragePlanId IN (SELECT item FROM dbo.fnSplit(@Plans,','))  
       
  
  
--03/31/2016  Gautam    
UPDATE T  
SET T.ServiceErrorsString = (  
  SELECT STUFF((  
     SELECT ': ' + se.ErrorMessage  
     FROM dbo.ServiceErrors AS se  
     WHERE T.ServiceId = se.ServiceId  
      AND ISNULL(se.RecordDeleted, 'N') = 'N'  
     FOR XML PATH  
      ,TYPE  
     ).value('.[1]', 'varchar(max)'), 1, 1, '') --handle character encoding    
  )  
 ,ChargeErrorString = (  
  SELECT STUFF((  
     SELECT ': ' + ce.ErrorDescription  
     FROM dbo.ChargeErrors AS ce  
     WHERE ce.ChargeId = T.ChargeId  
      AND ISNULL(ce.RecordDeleted, 'N') = 'N'  
     FOR XML PATH  
      ,TYPE  
     ).value('.[1]', 'varchar(max)'), 1, 1, '') --handle character encoding    
  )  
FROM #TempRdlRevenueReport T  
  
-- Billing Diagnosis 11/22/2017  
UPDATE T  
SET T.BillingDiagnosis1 = sd.ICD10Code  
 ,T.BillingDiagnosis2 = sd2.ICD10Code  
 ,T.BillingDiagnosis3 = sd3.ICD10Code  
FROM #TempRdlRevenueReport T  
LEFT JOIN ServiceDiagnosis sd ON sd.ServiceId = T.ServiceId  
 AND sd.[Order] = 1  
 AND ISNULL(sd.RecordDeleted, 'N') <> 'Y'  
LEFT JOIN ServiceDiagnosis sd2 ON sd2.ServiceId = t.ServiceId  
 AND sd2.[Order] = 2  
 AND ISNULL(sd.RecordDeleted, 'N') <> 'Y'  
LEFT JOIN ServiceDiagnosis sd3 ON sd3.ServiceId = sd.ServiceId  
 AND sd3.[Order] = 3  
 AND ISNULL(sd.RecordDeleted, 'N') <> 'Y'  
  
-- COB order 1 11/22/2017  
UPDATE T  
SET Cob1DisplayAs = cp.DisplayAs  
 ,ProgramCode = p.ProgramCode  
FROM #TempRdlRevenueReport T  
JOIN programs p ON p.ProgramId = T.ProgramId  
LEFT JOIN ClientCoveragePlans ccp ON ccp.ClientId = T.ClientId  
LEFT JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId  
JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId  
WHERE CAST(cch.StartDate AS DATE) <= t.DateOfService  
 AND (  
  cch.EndDate IS NULL  
  OR CAST(cch.EndDate AS DATE) >= t.DateOfService  
  )  
 AND cch.COBOrder = 1  
 AND cch.ServiceAreaId = p.ServiceAreaId  
 AND ISNULL(p.RecordDeleted, 'N') <> 'Y'  
  
SELECT ServiceId  
 ,ProgramCode AS [Program Name]  
 ,ClientName AS 'Client Name'  
 ,ClientId AS [Client ID]  
 ,DOB  
 ,ProcedureName AS [Procedure Name]  
 ,BillingDiagnosis1 AS [BillingDiagnosis1]  
 ,BillingDiagnosis2 AS [BillingDiagnosis2]  
 ,BillingDiagnosis3 AS [BillingDiagnosis3]  
 ,CPTCode AS 'CPT Code'  
 ,DateOfService AS [Date Of Service]  
 ,Units  
 ,AmountPaid AS [Amount Paid]  
 ,AmountAdjusted AS [Amount Adjusted]  
 ,AmountTransferred AS [Amount Transferred]  
 ,ClinicianDisplayAs AS [Clinician Name]  
 ,LocationCode AS [Location]  
 ,CodeName AS [Status]  
 ,CoveragePlanDisplayAs AS [Charge Coverage Plan]  
 ,Cob1DisplayAs AS [COB Order=1]  
 ,ServiceErrorsString  
 ,ChargeErrorString  
 ,OriginalCharge AS Original_Charge  
 ,CurrentCharge AS Current_Charge  
 ,Balance AS Balance  
 ,ChargeId AS ChargeID  
FROM #TempRdlRevenueReport  
ORDER BY ClientId  
END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(max)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLRevenueReport') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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
GO


