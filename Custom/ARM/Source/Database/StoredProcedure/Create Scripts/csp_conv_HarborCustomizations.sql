/****** Object:  StoredProcedure [dbo].[csp_conv_HarborCustomizations]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_HarborCustomizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_HarborCustomizations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_HarborCustomizations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE procedure [dbo].[csp_conv_HarborCustomizations]
as

DECLARE @Today DATETIME
SET @Today = GETDATE()

DECLARE @By VARCHAR(10)
SET @By = ''EAP Update''

DECLARE @EAPReg INT, @EAPSub INT 
SELECT @EAPReg = 1839, @EAPSub = 1840





update systemconfigurations set OrganizationName = ''Harbor''
if @@error <> 0 goto ERROR


--Inactivate procedures per harbor --av
UPDATE pc 
SET Active = ''N''
FROM CustomInactiveProcedureCodes c 
JOIN dbo.ProcedureCodes pc ON pc.ProcedureCodeId = c.ProcedureCodeId
WHERE pc.Active <> ''N''
if @@error <> 0 goto ERROR

UPDATE pc 
SET Active = ''N''
FROM CustomInactiveProcedureCodes c 
JOIN dbo.ProcedureCodes pc ON pc.DisplayAs = c.DisplayAs
WHERE pc.Active <> ''N''
if @@error <> 0 goto ERROR



--EAP Coverage Changes
BEGIN TRAN

SELECT  ccp.[ClientId] ,
        ccp.[CoveragePlanId] ,
        ISNULL([InsuredId],''.'') AS InsuredId,
        [GroupNumber] ,
        [GroupName] ,
        [ClientIsSubscriber] ,
        [SubscriberContactId] ,
        [CopayCollectUpfront] ,
        [Deductible] ,
        [ClientHasMonthlyDeductible] ,
        [PlanContactPhone] ,
        [LastVerified] ,
        [VerifiedBy] ,
        [MedicareSecondaryInsuranceType] ,
        CONVERT(VARCHAR(max),ccp.[Comment]) AS comment,
        [AuthorizationRequiredOverride] ,
        [NoAuthorizationRequiredOverride] ,
        cch.ClientCoverageHistoryId ,
        cch.COBOrder ,
        cch.ServiceAreaId ,
        @Today AS Date ,
        CASE p.PayerType
          WHEN 20458 THEN @EAPReg
          ELSE @EAPSub
        END AS NewPlan
INTO #Updates 
FROM    dbo.ClientCoverageHistory cch
        JOIN dbo.ClientCoveragePlans ccp ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                            AND cch.StartDate < @Today
                                            AND ( cch.EndDate > @Today
                                                  OR cch.EndDate IS NULL
                                                )
        JOIN dbo.CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId
        JOIN dbo.Payers p ON cp.PayerId = p.PayerId
                             AND p.PayerType IN ( 20459, 20458 )
WHERE   ISNULL(cch.RecordDeleted, ''N'') <> ''Y''
--IS This required? 
AND cp.DisplayAs <> ''EapMEDICARE02''


--End Date Coverage
UPDATE cch 
	SET EndDate = @Today, ModifiedBy=@By, ModifiedDate=@Today 
FROM #Updates u 
JOIN dbo.ClientCoverageHistory cch ON u.ClientCoverageHistoryId = cch.ClientCoverageHistoryId

--Insert New Plan
INSERT INTO ClientCoveragePlans
           (
            [ClientId]
           ,[CoveragePlanId]
           ,[InsuredId]
           ,[GroupNumber]
           ,[GroupName]
           ,[ClientIsSubscriber]
           ,[SubscriberContactId]
           ,[CopayCollectUpfront]
           ,[Deductible]
           ,[ClientHasMonthlyDeductible]
           ,[PlanContactPhone]
           ,[LastVerified]
           ,[VerifiedBy]
           ,[MedicareSecondaryInsuranceType]
           ,[Comment]
           ,[AuthorizationRequiredOverride]
           ,[NoAuthorizationRequiredOverride]
           ,CreatedBy
           ,CreatedDate
           )

SELECT DISTINCT
		[ClientId] ,
		NewPlan,
        [InsuredId] ,
        [GroupNumber] ,
        [GroupName] ,
        [ClientIsSubscriber] ,
        [SubscriberContactId] ,
        [CopayCollectUpfront] ,
        [Deductible] ,
        [ClientHasMonthlyDeductible] ,
        [PlanContactPhone] ,
        [LastVerified] ,
        [VerifiedBy] ,
        [MedicareSecondaryInsuranceType] ,
        CONVERT(VARCHAR(MAX),[Comment]) AS Comment ,
        [AuthorizationRequiredOverride] ,
        [NoAuthorizationRequiredOverride],
        @By,
        @Today 
FROM #Updates u
             
--Insert New Coverage History
INSERT INTO dbo.ClientCoverageHistory
        ( CreatedBy ,
          CreatedDate ,
          ClientCoveragePlanId ,
          StartDate ,
          COBOrder ,
          ServiceAreaId
        )

SELECT
@By
,@Today
,ccp.ClientCoveragePlanId
,u.Date
,u.COBOrder
,u.ServiceAreaId
FROM #Updates u 
JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientId = u.ClientId
	AND ccp.CreatedBy = @By


--Inactivate EAP Plans
UPDATE cp 
	SET Active = ''N''
FROM dbo.CoveragePlans cp  
JOIN dbo.Payers p ON cp.PayerId = p.PayerId AND p.PayerType IN ( 20459, 20458 )
WHERE cp.CoveragePlanId NOT IN ( 1840,1839 )
AND cp.Active = ''Y''
--AVOSS do we need to do this?
AND cp.DisplayAs <> ''EapMEDICARE02''

DROP TABLE #Updates

COMMIT
if @@error <> 0 goto ERROR



UPDATE pc 
	SET Active = ''N''
FROM procedureCodes pc 
WHERE ProcedureCodeName LIKE ''Do not use%''
IF @@ERROR <> 0 GOTO ERROR


--Update rate service area group name

UPDATE pr 
SET  ServiceAreaGroupName = sa.ServiceAreaName
FROM procedureCodes pc 
JOIN procedureRates pr ON pr.ProcedureCodeId = pc.ProcedureCodeId AND ISNULL(pr.RecordDeleted,''N'') <> ''Y'' 
JOIN dbo.ProcedureRateServiceAreas pcsa ON pcsa.ProcedureRateId = pr.ProcedureRateId AND ISNULL(pcsa.RecordDeleted,''N'') <> ''Y''
JOIN dbo.ServiceAreas sa ON sa.ServiceAreaId = pcsa.ServiceAreaId AND ISNULL(sa.RecordDeleted,''N'') <> ''Y''
WHERE  ISNULL(pc.RecordDeleted,''N'') <> ''Y''
AND NOT EXISTS ( SELECT 1 FROM dbo.ProcedureRateServiceAreas prs2 WHERE prs2.ProcedureRateId = pr.ProcedureRateId
	AND ISNULL(prs2.RecordDeleted,''N'') <> ''Y'' 
	AND prs2.ServiceAreaId <> pcsa.ServiceAreaId )
AND ISNULL(pr.ServiceAreaGroupName,'''')=''''

UPDATE pr 
SET  ServiceAreaGroupName = ''Multiple''
FROM procedureCodes pc 
JOIN procedureRates pr ON pr.ProcedureCodeId = pc.ProcedureCodeId AND ISNULL(pr.RecordDeleted,''N'') <> ''Y'' 
JOIN dbo.ProcedureRateServiceAreas pcsa ON pcsa.ProcedureRateId = pr.ProcedureRateId AND ISNULL(pcsa.RecordDeleted,''N'') <> ''Y''
JOIN dbo.ServiceAreas sa ON sa.ServiceAreaId = pcsa.ServiceAreaId AND ISNULL(sa.RecordDeleted,''N'') <> ''Y''
WHERE  ISNULL(pc.RecordDeleted,''N'') <> ''Y''
AND EXISTS ( SELECT 1 FROM dbo.ProcedureRateServiceAreas prs2 WHERE prs2.ProcedureRateId = pr.ProcedureRateId
	AND ISNULL(prs2.RecordDeleted,''N'') <> ''Y'' 
	AND prs2.ServiceAreaId <> pcsa.ServiceAreaId )
AND ISNULL(pr.ServiceAreaGroupName,'''')=''''
IF @@ERROR <> 0 GOTO ERROR

--06.19.2012	avoss	
--CSP Procedure Changes
UPDATE pc 
	SET DisplayAs = ''CSP - Face to Face'', ProcedureCodeName = ''CSP - Face to Face''
FROM ProcedureCodes pc 
WHERE procedurecodeId = 76
IF @@ERROR <> 0 GOTO ERROR

UPDATE s 
	SET ProcedureCodeId = 76
FROM services s 
WHERE s.STATUS IN ( 70, 71 ) --sheduled show
AND s.ProcedureCodeId IN ( 75 , 77 , 78 ,  83 ) 
IF @@ERROR <> 0 GOTO ERROR

--Deactivate IP Admit
UPDATE pc 
	SET Active = ''N''
FROM ProcedureCodes pc 
WHERE procedurecodeId = 83
and active=''Y''
IF @@ERROR <> 0 GOTO ERROR

--Change Telephone
UPDATE pc 
	SET DisplayAs = ''CSP - Telephone'', ProcedureCodeName = ''CSP - Telephone''
FROM ProcedureCodes pc 
WHERE procedurecodeId = 80
IF @@ERROR <> 0 GOTO ERROR

UPDATE s 
	SET ProcedureCodeId = 80
FROM services s 
WHERE s.STATUS IN ( 70, 71 ) --sheduled show
AND s.ProcedureCodeId IN ( 79,81,82 ) 
IF @@ERROR <> 0 GOTO ERROR


--Inactivate per mary pat 06.19.2012
UPDATE p 
	SET Active = ''N''
FROM programs p 
WHERE ProgramName = ''EAP (Employee Assistance Program)''
OR ProgramId = 21

IF @@ERROR <> 0 GOTO ERROR


---Insert CoveragePlanRules for Authorizations
Insert into CoveragePlanRules 
(CoveragePlanId, RuleTypeId,RuleName,AppliesToAllProcedureCodes, RuleViolationAction, createdby, createdDate, modifiedby,modifieddate)


SELECT cp.CoveragePlanId,
4264,''Authorization is required'',''Y'',-1,''avoss'',getdate(),''avoss'',getdate()
FROM dbo.Cstm_Conv_Map_CoveragePlans c 
JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = c.CoveragePlanId
JOIN Psych..Coverage_Plan pcp ON pcp.coverage_plan_id = c.coverage_plan_id
WHERE pcp.auth_req = ''Y''
AND NOT EXISTS ( SELECT 1 FROM CoveragePlanRules cpr where cpr.CoveragePlanId = cp.CoveragePlanId
	AND cpr.RuleTypeId = 4264 AND ISNULL(cpr.RecordDeleted,''N'')<>''Y'' )
IF @@ERROR <> 0 GOTO ERROR


UPDATE cp 
SET ClaimFilingIndicatorCode = 4784
FROM dbo.CoveragePlans cp 
LEFT JOIN globalCodes gc ON gc.GlobalCodeId = cp.ClaimFilingIndicatorCode
JOIN dbo.Payers p ON p.PayerId =cp.PayerId
JOIN GlobalCodes gc2 ON gc2.GlobalCodeId = p.PayerType
WHERE ISNULL(cp.RecordDeleted,''N'') <> ''Y''
AND gc2.CodeName = ''COMMERCIAL INSURANCE''
AND cp.ClaimFilingIndicatorCode IS NULL






UPDATE a 
	SET EndDate = ''1/1/2999''
FROM authorizations a 
WHERE a.Units = 999999999.00
AND EndDate IS NULL


UPDATE cp
	SET PaperClaimFormatId = 1002
FROM coveragePlans cp 
WHERE PayerId IN ( 138 )  --Corporate
AND ISNULL(PaperClaimFormatId,0) <> 1002

/*
--
-- Fiscal Years and Accounting Periods
--    

declare @StartDate datetime
declare @Month int

set @StartDate = ''10/1/1997''

while @StartDate <= ''10/1/2012''
begin
  insert into FiscalYears (
         FiscalYear,
         StartDate,
         EndDate)
  select year(@StartDate) + 1,
         @StartDate,
         dateadd(dd, -1, dateadd(mm, 12, @StartDate))

  set @Month = 1

  while @Month <= 12
  begin

    insert into AccountingPeriods (
           FiscalYear,
           SequenceNumber,
           StartDate,
           EndDate,
           Description,
           OpenPeriod)
    select year(@StartDate) + 1,
           @Month, 
           dateadd(mm, @Month - 1, @StartDate),
           dateadd(dd, -1, dateadd(mm, @Month, @StartDate)),
           datename(mm, dateadd(mm, @Month - 1, @StartDate)),
           case when year(@StartDate) + 1 >= 2006 then ''Y'' else ''N'' end
    
   set @Month = @Month + 1 
  end  


  set @StartDate = dateadd(mm, 12, @StartDate)
end



if @@error <> 0 goto error
*/


return 

error:

raiserror 50010 ''csp_conv_HarborCustomizations Failed''






' 
END
GO
