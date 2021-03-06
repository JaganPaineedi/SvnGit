/****** Object:  StoredProcedure [dbo].[csp_SubReportVisitTicket]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportVisitTicket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportVisitTicket]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportVisitTicket]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE PROCEDURE [dbo].[csp_SubReportVisitTicket](    
 @ClientId int,    
 @ServiceId int,    
 @StaffId int    
)    
AS    
BEGIN    
    
--DECLARE @ServiceId int    
DECLARE @LastServiceId int    
DECLARE @ProcedureCodeId int    
DECLARE @CurrentThirdPartyBalance varchar(20)    
DECLARE @Coverages varchar(max)    
DECLARE @ClientPhones varchar(500)    
    
SET @Coverages = ''''    
    
--Concatenate Phone Numbers    
Select @ClientPhones = b.Phones    
From (    
 Select b1.ClientId, (    
  Select Coalesce(PhoneNumber,'''') + ''~''    
  From ClientPhones b2    
  Where b2.ClientId = b1.ClientId    
  And IsNull(b2.RecordDeleted,''N'') = ''N''    
  AND IsNull(b2.DoNotContact,''N'') <> ''Y''    
  Order By case when isPrimary = ''Y'' then 0 else 1 end, PhoneNumber    
  For Xml Path('''')    
  ) as Phones    
 From ClientPhones b1    
 Where IsNull(b1.RecordDeleted,''N'') = ''N''    
 AND IsNULL(b1.DoNotContact,''N'') <> ''Y''    
 Group By ClientId    
 ) b     
WHERE b.ClientId = @ClientId    
    
  /*  
SELECT TOP 1 /*@ServiceId=s.ServiceId,*/ @ProcedureCodeId=s.ProcedureCodeId    
FROM Services s    
WHERE s.ClientId = @ClientId AND    
      s.Status = 71 AND    
      ISNULL(s.RecordDeleted,''N'') = ''N''    
ORDER BY s.DateOfService DESC    
*/  
    
-- Get last service    
SELECT TOP 1 @LastServiceId=s.ServiceId    
FROM Services s    
WHERE s.ClientId = @ClientId AND    
   s.Status in (71, 75) AND    
   s.ServiceId <> @ServiceId AND    
      ISNULL(s.RecordDeleted,''N'') = ''N''    
ORDER BY s.DateOfService DESC    
    
-- Get ins. balance    
SELECT @CurrentThirdPartyBalance = ''$'' + Convert(Varchar,SUM(Balance),20)                                                             
FROM ClientCoveragePlans z                                                            
JOIN Charges y ON z.ClientCoveragePlanId = y.ClientCoveragePlanId                                                            
JOIN OpenCharges x ON (y.ChargeId = x.ChargeId)                                                            
WHERE z.ClientId = @ClientId and     
      ISNULL(y.RecordDeleted,''N'') <> ''Y''    
          
-- Get coverages    
DECLARE @TempCoverages TABLE(    
 COBOrder int,  
 CoveragePlanName varchar(250),    
 InsuredId varchar(35),    
 DisplayAs varchar(20)    
)    
    
INSERT INTO @TempCoverages(    
 COBOrder,  
 CoveragePlanName,    
 InsuredId,    
 DisplayAs    
)    
SELECT DISTINCT cch.COBOrder,cp.CoveragePlanName, isnull(ccp.InsuredId,''''), cp.DisplayAs  
FROM Services s  
JOIN Programs p on p.ProgramId = s.ProgramId  
JOIN ClientCoveragePlans ccp ON ccp.ClientId = s.ClientId  
JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId   
 AND cch.ServiceAreaId = p.ServiceAreaId  
JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId   
WHERE s.ServiceId = @ServiceId  
AND (cch.EndDate > s.DateOfService OR    
       cch.EndDate IS NULL) AND    
      ISNULL(cch.RecordDeleted,''N'') = ''N'' AND    
      ISNULL(ccp.RecordDeleted,''N'') = ''N''    
          
SELECT @Coverages = @Coverages + (CoveragePlanName + ''<BR>ID # '' + InsuredId + ''<BR>Group # '' + DisplayAs + ''<BR><BR>'')    
FROM @TempCoverages    
ORDER BY COBOrder  
  
-- result set    
SELECT c.ClientId,    
       c.FirstName + '' '' + c.LastName AS ClientName,    
       c.DOB,    
       s.FirstName + '' '' + s.LastName AS PrimaryClinician,    
       CASE WHEN CHARINDEX(''!!!'',Convert(varchar(max),c.Comment)) <> 0 THEN     
   REPLACE(LEFT(Convert(varchar(max),c.Comment),CHARINDEX(''!!!'',Convert(varchar(max),c.Comment))-1),Char(13),'''')     
       ELSE c.Comment END as Remarks,    
       --REPLACE(REPLACE(CAST(c.Comment AS VARCHAR(MAX)), CHAR(13), ''''), CHAR(10), '''') AS Remarks2,    
       pc.DisplayAs AS [Procedure],    
       svc.Unit AS Duration,    
       svc.DateOfService,    
       l.LocationCode AS Location,    
       p.ProgramCode AS Program,    
       svc2.DateOfService AS LastDateOfService,    
       s2.FirstName + '' '' + s2.LastName AS LastStaffSeen,    
       c.Email,    
       ResponsibleName = COALESCE(cc.FirstName + '' '' + cc.LastName,c.FirstName + '' '' + c.LastName,''''),    
       ResponsibleAddress = COALESCE(cca.Display,ca.Display,''''),    
       ResponsiblePhone = COALESCE(ccp.PhoneNumber,Replace(@ClientPhones,''~'',CHAR(13)+CHAR(10)),''''),    
       ISNULL(''$'' + CONVERT(VARCHAR, CurrentBalance),0) AS CurrentBalance,    
       pmt.Amount AS LastPayment,    
       pmt.DateReceived AS LastPaymentDate,    
       @CurrentThirdPartyBalance as CurrentThirdPartyBalance,    
       svc.Charge,    
       svc.Billable,    
       svc.AuthorizationsApproved,    
       svc.AuthorizationsNeeded,    
       svc.AuthorizationsRequested,    
       chg.ClientCopay,    
       chg.RevenueCode,    
       ccp2.Deductible,    
       a.AuthorizationNumber,    
       a.StartDate AS AuthStartDate,    
       a.EndDate AS AuthEndDate,    
       s3.FirstName + '' '' + s3.LastName AS StaffName,    
       @Coverages AS Coverages,    
       Replace(@ClientPhones,''~'',CHAR(13)+CHAR(10)) AS ClientPhones,    
       CASE WHEN CHARINDEX(''!!!'',Convert(varchar(max),svc.Comment)) <> 0 THEN     
   LEFT(Convert(varchar(max),svc.Comment),CHARINDEX(''!!!'',Convert(varchar(max),svc.Comment))-1)     
       ELSE svc.Comment END as Comments     
FROM Clients c    
LEFT JOIN Services svc ON svc.ServiceId = @ServiceId    
LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = svc.ProcedureCodeId    
LEFT JOIN Services svc2 ON svc2.ServiceId = @LastServiceId    
LEFT JOIN Locations l ON l.LocationId = svc.LocationId    
LEFT JOIN Programs P ON p.ProgramId = svc.ProgramId    
LEFT JOIN Staff s ON s.StaffId = svc.ClinicianId    
LEFT JOIN Staff s2 ON s2.StaffId = svc2.ClinicianId    
LEFT JOIN ClientContacts cc ON cc.ClientId = @ClientId AND cc.FinanciallyResponsible = ''Y'' AND ISNULL(cc.RecordDeleted,''N'') = ''N''    
LEFT JOIN ClientContactAddresses cca ON cca.ClientContactId = cc.ClientContactId AND ISNULL(cca.RecordDeleted,''N'') = ''N''    
LEFT JOIN ClientContactPhones ccp ON ccp.ClientContactId = cc.ClientContactId AND ISNULL(ccp.RecordDeleted,''N'') = ''N''    
LEFT JOIN Payments pmt ON pmt.ClientId = @ClientId AND ISNULL(pmt.RecordDeleted,''N'') = ''N''    
LEFT JOIN Charges chg ON chg.ServiceId = svc.ServiceId AND ISNULL(chg.RecordDeleted,''N'') = ''N''    
LEFT JOIN ClientCoveragePlans ccp2 ON ccp2.ClientCoveragePlanId = chg.ClientCoveragePlanId AND ISNULL(ccp2.RecordDeleted,''N'') = ''N''    
LEFT JOIN ServiceAuthorizations sa ON sa.ServiceId = svc.ServiceId AND ISNULL(sa.RecordDeleted,''N'') = ''N''    
LEFT JOIN Authorizations a on a.AuthorizationId = sa.AuthorizationId AND ISNULL(a.RecordDeleted,''N'') = ''N''    
LEFT JOIN Staff s3 ON s3.StaffId = @StaffId    
LEFT JOIN ClientAddresses ca ON ca.ClientId = c.ClientId AND IsNull(ca.Billing,''N'') = ''Y''    
WHERE c.ClientId = @ClientId    
 AND ISNULL(c.RecordDeleted,''N'') = ''N''    
 AND ISNULL(pc.RecordDeleted,''N'') = ''N''    
 AND ISNULL(svc.RecordDeleted,''N'') = ''N''    
 AND ISNULL(svc2.RecordDeleted,''N'') = ''N''    
 AND ISNULL(l.RecordDeleted,''N'') = ''N''    
 AND ISNULL(p.RecordDeleted,''N'') = ''N''    
 AND ISNULL(s2.RecordDeleted,''N'') = ''N''    
 AND ISNULL(cc.RecordDeleted,''N'') = ''N''    
 AND ISNULL(cca.RecordDeleted,''N'') = ''N''    
 AND ISNULL(ccp.RecordDeleted,''N'') = ''N''    
 AND ISNULL(pmt.RecordDeleted,''N'') = ''N''    
 AND ISNULL(chg.RecordDeleted,''N'') = ''N''    
 AND ISNULL(ccp2.RecordDeleted,''N'') = ''N''    
 AND ISNULL(sa.RecordDeleted,''N'') = ''N''    
 AND ISNULL(a.RecordDeleted,''N'') = ''N''    
 AND ISNULL(s3.RecordDeleted,''N'') = ''N''    
ORDER BY svc.DateofService    
    
END    ' 
END
GO
