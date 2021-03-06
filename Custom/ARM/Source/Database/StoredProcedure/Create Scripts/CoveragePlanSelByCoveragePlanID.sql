/****** Object:  StoredProcedure [dbo].[CoveragePlanSelByCoveragePlanID]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanSelByCoveragePlanID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CoveragePlanSelByCoveragePlanID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanSelByCoveragePlanID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[CoveragePlanSelByCoveragePlanID]        
 /* Param List */        
  @CoveragePlanID INT        
AS    
/******************************************************************************        
**  File: dbo.CoveragePlanSelByCoveragePlanID.prc        
**  Name: dbo.CoveragePlanSelByCoveragePlanID        
**  Desc:         
**        
**  This template can be customized:        
**                      
**  Return values:        
**         
**  Called by:           
**                      
**  Parameters:        
**  Input       Output        
**     ----------       -----------        
**        
**  Auth: Shamala        
**  Date:         
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:  Author:    Description:        
**  --------  --------    -------------------------------------------        
**    7-June-2006 Vitthal    Adde Payer Name to the Coverage plan table query        
**    8-November-2006 Vikrant Modified to get "DSMNumber" in table 14     
**    Nov.27-2006 Balvinder Have Separated the Eligible Clients Logic for Plan Details  
**    22/Jan/09 Rohit Verma Added new field ''NationalDrugCode''  
*******************************************************************************/        
/*Table #0*/        
SELECT             
   [CoveragePlanId], [CoveragePlanName], [DisplayAs], cp.[Active], [InformationComplete], [AddressHeading], [Address], [City], [State], [ZipCode], [AddressDisplay], Cp.[PayerId], [Capitated], [ContactName], [ContactPhone], [ContactFax],      
 [BillingCodeTemplate], [UseBillingCodesFrom], [UseStandardRules], [MedicaidPlan], [MedicarePlan], [ElectronicVerification], [Comment], [BillingDiagnosisType], [PaperClaimFormatId], [ElectronicClaimFormatId], [CombineClaimsAtPayerLevel], [ProviderIdType],
  
 [ProviderId], [ClaimFilingIndicatorCode],       
[ElectronicClaimsPayerId], [ElectronicClaimsOfficeNumber], Cp.[RowIdentifier], Cp.[CreatedBy], Cp.[CreatedDate], Cp.[ModifiedBy], Cp.[ModifiedDate], Cp.[RecordDeleted], Cp.[DeletedDate], Cp.[DeletedBy]         
  ,P.PayerName        
FROM                 
   CoveragePlans AS CP        
  ,Payers P --changed Payer to Payers on date 18-Oct-2006 -- changed Payers to Payer on date 30 Oct 2006        
          
WHERE         
   CP.CoveragePlanID = @CoveragePlanID        
  AND         
   CP.PayerId = P.PayerID        
  AND        
   ISNULL(CP.RecordDeleted, ''N'') = ''N''        
        
/*Table #1*/        
SELECT         
  1 AS DeleteButton        
  ,PC.ProcedureCodeid        
  ,PC.DisplayAs        
  ,PC.ProcedureCodeName, [NationalDrugCode] --
  ,''$'' + Convert(VARCHAR,PR.Amount,1) + CASE PR.Chargetype         
     WHEN ''P'' THEN '' Per ''  --Per        
     WHEN ''E'' THEN '' For ''  --Exact        
    END as ChargeTemplate        
  ,''$'' + CASE PC.AllowDecimals        
   WHEN ''Y'' THEN Convert(VARCHAR,PR.Amount,1) + '' '' --CAST(PR.Amount AS VARCHAR(10)) + '' ''        
   ELSE LEFT(Convert(VARCHAR,PR.Amount,1),CHARINDEX(''.'',Convert(VARCHAR,PR.Amount,1))-1) + '' '' END + '' '' --CAST(PR.Amount AS VARCHAR(10)) + '' ''        
   + CASE PR.Chargetype         
     WHEN ''P'' THEN ''Per '' + CAST(PR.FromUnit AS VARCHAR(20))  --Per        
     WHEN ''R'' THEN CAST(PR.FromUnit AS VARCHAR(20)) + '' to '' + CAST(PR.ToUnit AS VARCHAR(20)) --Range        
     WHEN ''E'' THEN ''for '' + CAST(PR.FromUnit AS VARCHAR(20)) --Exact        
   END  + '' '' + GC.CodeName  AS Charge--Unit        
  ,PC.Active        
  ,GC.CodeName AS EnteredAs         
  ,CL.LastName + '', '' + CL.FirstName AS Client        
  ,CASE PR.Advanced        
    WHEN ''Y'' THEN ''Varies''        
    ELSE PR.BillingCode        
  END AS BillingCodeName          
  ,[ProcedureRateId], [CoveragePlanId], PR.[ProcedureCodeId], [FromDate], [ToDate], [Amount], [ChargeType], [FromUnit], [ToUnit], [ProgramGroupName], [LocationGroupName], [DegreeGroupName], [StaffGroupName], PR.[ClientId], [Priority],
 [BillingCodeClaimUnits],       
[BillingCodeUnitType], [BillingCodeUnits], [BillingCode], [Modifier1], [Modifier2], [Modifier3], [Modifier4], [RevenueCode], [RevenueCodeDescription], [Advanced], PR.[Comment], [StandardRateId], [BillingCodeModified], PR.[RowIdentifier],       
PR.[CreatedBy], PR.[CreatedDate], PR.[ModifiedBy], PR.[ModifiedDate], PR.[RecordDeleted], PR.[DeletedDate], PR.[DeletedBy]         
  ,Convert(VARCHAR(10),PR.FromDate,101) AS FromDt--PR.FromDate        
  ,Convert(VARCHAR(10),PR.ToDate,101) AS ToDt--PR.ToDate          
 FROM         
  ProcedureRates PR         
 JOIN       
  ProcedureCodes PC         
 ON         
  PR.ProcedureCodeId = PC.ProcedureCodeId         
 LEFT JOIN Clients CL         
  ON  PR.ClientID = CL.ClientID         
 --LEFT JOIN ProcedureRateBillingCodes PRBC         
 -- ON PR.ProcedureRateID = PRBC.ProcedureRateID        
 LEFT JOIN GlobalCodes GC        
  ON GC.GlobalCodeId=PC.EnteredAs        
 WHERE        
 (PR.RecordDeleted = ''N'' OR PR.RecordDeleted IS NULL)        
 AND        
  ISNULL(PC.RecordDeleted,''N'') = ''N''        
 AND         
   CoveragePlanId IS NULL          
 AND         
   StandardRateId IS NULL          
 AND        
   BillingCodeModified IS NULL         
  --AND        
  -- PC.Active = ''Y''        
         
 OR        
 CoveragePlanId IN        
 (        
  SELECT         
   CoveragePlanId         
  FROM         
   CoveragePlans         
  WHERE         
           
   ISNULL(RecordDeleted, ''N'') = ''N''        
   AND        
   ISNULL(Active, ''Y'') = ''Y''        
 )        
ORDER BY PC.DisplayAs        
        
         
/*Table #2*/         
/*Locations for rates in plan*/        
SELECT         
 [ProcedureRateLocationId], [ProcedureRateId], [LocationId], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]         
FROM         
 ProcedureRateLocations        
WHERE         
 procedurerateid         
 IN         
 (          
  (        
  SELECT         
   DISTINCT ProcedureRateID         
  FROM         
   procedurerates         
  WHERE         
   /*BillingCodeModified = ''Y''         
   AND */        
   ISNULL(RecordDeleted, ''N'') = ''N''        
   AND         
   CoveragePlanID = @CoveragePlanID        
  )        
  UNION         
  (        
  SELECT         
   DISTINCT ProcedureRateId         
  FROM         
   ProcedureRates        
  WHERE         
   CoveragePlanID IS NULL        
  )        
 )        
         
ORDER BY ProcedureRateLocationID        
/*Table #3*/        
/*Programs for rates in plan*/        
SELECT         
 [ProcedureRateProgramId], [ProcedureRateId], [ProgramId], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]         
FROM         
 ProcedureRatePrograms        
WHERE         
 procedurerateid         
 IN         
 (          
  (        
  SELECT         
   DISTINCT ProcedureRateID         
  FROM         
   procedurerates         
  WHERE         
   /*BillingCodeModified = ''Y''         
   AND */        
   ISNULL(RecordDeleted, ''N'') = ''N''        
   AND         
   CoveragePlanID = @CoveragePlanID        
  )        
  UNION         
  (        
  SELECT         
   DISTINCT ProcedureRateId         
  FROM         
   ProcedureRates        
  WHERE         
   CoveragePlanID IS NULL        
  )        
 )        
         
ORDER BY ProcedureRateProgramID        
         
         
/*Table #4*/        
/*Degree for rates in plan*/        
SELECT         
 [ProcedureRateDegreeId], [ProcedureRateId], [Degree], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]         
FROM         
 ProcedureRateDegrees        
WHERE         
 procedurerateid         
 IN         
 (          
  (        
  SELECT         
   DISTINCT ProcedureRateID         
  FROM         
   procedurerates         
  WHERE         
   /*BillingCodeModified = ''Y''         
   AND */        
   ISNULL(RecordDeleted, ''N'') = ''N''        
   AND         
   CoveragePlanID = @CoveragePlanID        
  )        
  UNION         
  (        
  SELECT         
   DISTINCT ProcedureRateId         
  FROM         
   ProcedureRates        
  WHERE         
   CoveragePlanID IS NULL        
  )        
 )        
         
ORDER BY ProcedureRateDegreeID        
/*Table #5*/        
/*Staff for rates in plan*/        
SELECT         
 [ProcedureRateStaffId], [ProcedureRateId], [StaffId], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]         
FROM         
 ProcedureRateStaff        
WHERE         
 procedurerateid         
 IN         
 (        
  (        
  SELECT         
   DISTINCT ProcedureRateID         
  FROM         
   procedurerates         
  WHERE         
   /*BillingCodeModified = ''Y''         
   AND */        
   ISNULL(RecordDeleted, ''N'') = ''N''        
   AND         
   CoveragePlanID = @CoveragePlanID        
  )        
  UNION         
  (        
  SELECT         
   DISTINCT ProcedureRateId         
  FROM         
   ProcedureRates        
  WHERE         
   CoveragePlanID IS NULL        
  )        
 )        
          
ORDER BY ProcedureRateStaffID        
/*Table #6*/        
/*Client for rates in plan*/        
SELECT         
 0 AS Extra,        
 PR.ProcedureRateId,        
 PR.ClientID          
FROM         
 ProcedureRates PR        
WHERE         
 procedurerateid         
 IN         
 (         
  (        
  SELECT         
   DISTINCT ProcedureRateID         
  FROM         
   procedurerates         
  WHERE         
  /* BillingCodeModified = ''Y''         
   AND */        
   ISNULL(RecordDeleted, ''N'') = ''N''        
   AND         
   CoveragePlanID = @CoveragePlanID        
  )        
  UNION         
  (        
  SELECT         
   DISTINCT ProcedureRateId         
  FROM         
   ProcedureRates        
  WHERE         
   CoveragePlanID IS NULL        
  )        
 )        
        
          
/*Table #7*/        
/*Select Locations from ExcpectedPayemnt*/        
        
SELECT         
 [ExpectedPaymentLocationId], [ExpectedPaymentId], [LocationId], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]         
FROM         
 ExpectedPaymentLocations        
WHERE         
 ExpectedPaymentId         
 IN         
 (        
  SELECT         
   ExpectedPaymentId         
  FROM        
   ExpectedPayment          
  WHERE        
   CoveragePlanID IN        
   (        
   SELECT         
    DISTINCT CoveragePlanID        
   FROM        
    ExpectedPayment        
   WHERE        
    ISNULL(RecordDeleted , ''N'')= ''N''         
   )        
  AND         
   ISNULL(RecordDeleted, ''N'') = ''N''        
 )        
ORDER BY ExpectedPaymentLocationId        
          
/*Table #8*/        
/*Select Program from ExcpectedPayemnt*/        
        
SELECT         
 [ExpectedPaymentProgramId], [ExpectedPaymentId], [ProgramId], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]         
FROM         
 ExpectedPaymentPrograms        
WHERE         
 ExpectedPaymentId         
 IN         
 (        
  SELECT         
   ExpectedPaymentId         
  FROM        
   ExpectedPayment          
  WHERE        
   CoveragePlanID IN        
   (        
   SELECT         
    DISTINCT CoveragePlanID        
   FROM        
    ExpectedPayment        
   WHERE        
    ISNULL(RecordDeleted , ''N'')= ''N''         
   )        
  AND         
   ISNULL(RecordDeleted, ''N'') = ''N''        
 )        
        
 ORDER BY ExpectedPaymentProgramID        
          
/*Table #9*/        
/*Select Degree from ExcpectedPayemnt*/        
        
SELECT         
 [ExpectedPaymentDegreeId], [ExpectedPaymentId], [Degree], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]          
FROM         
 ExpectedPaymentDegrees        
WHERE         
 ExpectedPaymentId         
 IN         
 (        
  SELECT         
   ExpectedPaymentId         
  FROM        
   ExpectedPayment          
  WHERE        
   CoveragePlanID IN        
   (        
   SELECT         
    DISTINCT CoveragePlanID        
   FROM        
    ExpectedPayment        
   WHERE        
    ISNULL(RecordDeleted , ''N'')= ''N''         
   )        
  AND         
   ISNULL(RecordDeleted, ''N'') = ''N''        
 )        
 ORDER BY ExpectedPaymentDegreeID        
          
/*Table #10*/        
/*Select Staff from ExcpectedPayemnt*/        
        
SELECT         
 [ExpectedPaymentStaffId], [ExpectedPaymentId], [StaffId], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]         
FROM         
 ExpectedPaymentStaff        
WHERE         
 ExpectedPaymentId         
 IN         
 (        
  SELECT         
   ExpectedPaymentId         
  FROM        
   ExpectedPayment          
  WHERE        
   CoveragePlanID IN        
   (        
   SELECT         
    DISTINCT CoveragePlanID        
   FROM        
    ExpectedPayment        
   WHERE        
    ISNULL(RecordDeleted , ''N'')= ''N''         
   )        
  AND         
   ISNULL(RecordDeleted, ''N'') = ''N''        
 )        
          
 ORDER BY ExpectedPaymentStaffID        
         
         
/*Table #11*/        
/*Select Client from ExcpectedPayemnt*/         
SELECT         
 0 AS Extra,        
 ExpectedPaymentId,        
 ClientID          
FROM         
 ExpectedPayment        
WHERE         
 ExpectedPaymentId         
 IN         
 (        
  SELECT         
   ExpectedPaymentId         
  FROM        
   ExpectedPayment          
  WHERE        
   CoveragePlanID IN        
   (        
   SELECT         
    DISTINCT CoveragePlanID        
   FROM        
    ExpectedPayment        
   WHERE        
    ISNULL(RecordDeleted , ''N'')= ''N''         
   )        
          
  AND         
   ISNULL(RecordDeleted, ''N'') = ''N''        
 )        
 AND         
  ISNULL(RecordDeleted, ''N'')=''N''        
          
/*Table #12*/        
/*Select from ExpectedPayment these records will display on the Payment tab of the Plan Page.*/          
SELECT            
 1 DeleteButton,        
 ''N'' AS RadioButton,        
 C.LastName + '', '' + C.FirstName AS Client,        
 PC.DisplayAs,        
 CONVERT(VARCHAR, EP.FromDate, 101) AS PayFromDate,        
 CONVERT(VARCHAR, EP.ToDate, 101) AS PayToDate,        
 --''$'' + ISNULL(CAST(EP.Payment AS VARCHAR), '''') + ''/$'' + ISNULL(CAST(EP.AdjustMent AS VARCHAR), '''') +        
 ''$'' + CASE PC.AllowDecimals        
   WHEN ''Y'' THEN Convert(VARCHAR,EP.Payment,1) + '' ''        
-- Commented by Sukhbir to handle nulls   ELSE LEFT(Convert(VARCHAR,EP.Payment,1),CHARINDEX(''.'',Convert(VARCHAR,EP.Payment,1))-1) + '' '' END + ''/$'' + CASE PC.AllowDecimals        
   ELSE IsNull(LEFT(Convert(VARCHAR,EP.Payment,1),CHARINDEX(''.'',Convert(VARCHAR,EP.Payment,1))-1) ,'''') + '' '' END + ''/$'' + CASE PC.AllowDecimals        
   WHEN ''Y'' THEN Convert(VARCHAR,EP.AdjustMent,1) + '' ''        
-- Commented by Sukhbir to handle nulls      ELSE LEFT(Convert(VARCHAR,EP.AdjustMent,1),CHARINDEX(''.'',Convert(VARCHAR,EP.AdjustMent,1))-1) + '' '' END +        
   ELSE IsNull(LEFT(Convert(VARCHAR,EP.AdjustMent,1),CHARINDEX(''.'',Convert(VARCHAR,EP.AdjustMent,1))-1) ,'''')+ '' '' END +        
 CASE ChargeType         
   WHEN ''P'' THEN '' Per '' + CAST(FromUnit AS VARCHAR)+ '' ''+ ISNULL( (SELECT CodeName FROM GlobalCodes WHERE GlobalCodeID = PC.EnteredAs), '''')        
   WHEN ''E'' THEN '' Exactly for '' + CAST(FromUnit AS VARCHAR)+ '' ''+ ISNULL( (SELECT CodeName FROM GlobalCodes WHERE GlobalCodeID = PC.EnteredAs), '''')        
-- Commented by Sukhbir to handle nulls    WHEN ''R'' THEN '' From '' + CAST(FromUnit AS VARCHAR)+ '' To '' + CAST(ToUnit AS VARCHAR) +  '' ''+ ISNULL( (SELECT CodeName FROM GlobalCodes WHERE GlobalCodeID = PC.EnteredAs), '''')        
  WHEN ''R'' THEN '' From '' + CAST(FromUnit AS VARCHAR)+ '' To '' + IsNull(CAST(ToUnit AS VARCHAR),'''') +  '' ''+ ISNULL( (SELECT CodeName FROM GlobalCodes WHERE GlobalCodeID = PC.EnteredAs), '''')        
 END        
 AS PaymentAdjustment,        
 [ExpectedPaymentId], [CoveragePlanId], EP.[ProcedureCodeId], [FromDate], [ToDate], [ChargeType], [FromUnit], [ToUnit], [Payment], [Adjustment], [ProgramGroupName], [LocationGroupName], [DegreeGroupName], [StaffGroupName], EP.[ClientId], [Priority],      
 
EP.[RowIdentifier], EP.[CreatedBy], EP.[CreatedDate], EP.[ModifiedBy], EP.[ModifiedDate], EP.[RecordDeleted], EP.[DeletedDate], EP.[DeletedBy]        
 ,Convert(VARCHAR(10),EP.FromDate,101) AS FromDt--PR.FromDate        
 ,Convert(VARCHAR(10),EP.ToDate,101) AS ToDt--PR.ToDate          
FROM        
  ExpectedPayment EP        
 LEFT JOIN        
  Clients C        
 ON        
  (EP.ClientID = C.ClientID)         
 LEFT JOIN        
  ProcedureCodes PC        
 ON        
  PC.ProcedureCodeID = EP.ProcedureCodeID        
WHERE        
 (        
 (EP.CoveragePlanId = @CoveragePlanID)        
 OR        
 EP.CoveragePlanId IN        
  (        
  SELECT         
   DISTINCT CoveragePlanID        
   FROM        
   ExpectedPayment        
  WHERE        
   ISNULL(RecordDeleted , ''N'')= ''N''         
  )        
 )        
 AND         
 ISNULL(EP.RecordDeleted , ''N'')= ''N''        
 AND         
 ISNULL(C.RecordDeleted, ''N'') = ''N''        
         
 ORDER BY EP.ExpectedPaymentId        
         
/*Table #13*/        
/*Coverage Plan Rule*/        
SELECT          
 ''N'' AS RadioButton,        
 1 AS DeleteButton,        
 GC.CodeName AS RuleTypeName,        
 CPR.[CoveragePlanRuleId], [CoveragePlanId], CPR.[RuleTypeId], [RuleName], CPR.[RuleViolationAction], CPR.[RowIdentifier], CPR.[CreatedBy], CPR.[CreatedDate], CPR.[ModifiedBy], CPR.[ModifiedDate], CPR.[RecordDeleted], CPR.[DeletedDate], CPR.[DeletedBy]   
  
   
      
 ,Convert(VARCHAR(10),CPR.CreatedDate,101) AS CreatedDt--PR.FromDate        
FROM        
  CoveragePlanRules CPR         
 LEFT JOIN        
  GlobalCodes GC        
 ON         
  CPR.RuleTypeId = GC.GlobalCodeId        
WHERE          
 ISNULL(CPR.RecordDeleted, ''N'') = ''N''        
 AND        
 (CPR.CoveragePlanId = @CoveragePlanID)        
 ORDER BY CPR.CoveragePlanRuleID        
         
         
/*Table #14*/        
/*CoveragePlanRuleVariables*/        
        
SELECT             
 1 DeleteButton,        
 ''N'' RadioButton,        
 ISNULL(PC.DisplayAs, ''N'') AS ProcedureCode,        
 CP.CoveragePlanName AS CoveragePlanName,        
 ST.LastName + '', '' + ST.FirstName as StaffName,         
 CPR.[RuleVariableId], CPR.[CoveragePlanRuleId], CPR.[ProcedureCodeId], CPR.[CoveragePlanId], CPR.[StaffId], CPR.[DSMCode], CPR.[RowIdentifier], CPR.[CreatedBy], CPR.[CreatedDate], CPR.[ModifiedBy], CPR.[ModifiedDate], CPR.[RecordDeleted], 
CPR.[DeletedDate],       
CPR.[DeletedBy], 1 as [DSMNumber]    --Modified by Sukhbir Singh    
,Case when CPR.ProcedureCodeId is null and CPR.StaffId IS not Null Then ''Y'' Else ''N'' End As SelectAllCodes    
FROM                 
     CoveragePlanRuleVariables CPR        
     LEFT JOIN        
        CoveragePlans CP        
        ON         
        CPR.CoveragePlanId = CP.CoveragePlanId         
    LEFT JOIN        
        ProcedureCodes PC        
        ON         
        CPR.ProcedureCodeId = PC.ProcedureCodeId        
  LEFT JOIN         
        Staff ST        
        on        
        CPR.StaffId = ST.StaffId        
/* -- Commented by Sukhbir Singh    
 LEFT JOIN      
 DiagnosisDSMDescriptions DSM      
 on       
 CPR.DSMCOde=DSM.DSMCOde      
  */              
WHERE           
 CPR.CoveragePlanRuleId in        
 (        
  SELECT         
   CoveragePlanRuleId        
  FROM          
   CoveragePlanRules        
  WHERE         
   CoveragePlanID = @CoveragePlanID ANd ISNULL(recorddeleted, ''N'') = ''N''        
 )   --and CPR.ProcedureCodeId is not null --Code added by kuldeep ref task 420    
           
/*Table #15*/        
/*CoveragePlanRuleLimits*/        
SELECT          
 1 DeleteButton,        
 ''N'' RadioButton,        
 GC.CodeName AS LimitTypeName,        
 PC.DisplayAs As ProcedureCode,        
 '''' AS Per,        
 CPL.[RuleLimitId], CPL.[CoveragePlanRuleId], CPL.[ProcedureCodeId], CPL.[LimitType], [Daily], [Weekly], [Monthly], [Yearly], CPL.[RowIdentifier], CPL.[CreatedBy], CPL.[CreatedDate], CPL.[ModifiedBy], CPL.[ModifiedDate], CPL.[RecordDeleted],
 CPL.[DeletedDate], CPL.[DeletedBy]         
FROM        
   CoveragePlanRuleLimits CPL         
   LEFT JOIN        
   GlobalCodes GC         
   ON         
   CPL.LimitType = GC.GlobalCodeId        
   LEFT JOIN        
   ProcedureCodes PC        
   ON        
   PC.ProcedureCodeId = CPL.ProcedureCodeID        
WHERE        
 CPL.CoveragePlanRuleId         
 IN        
 (        
  SELECT         
   CoveragePlanRuleId        
  FROM        
   CoveragePlanRules        
  WHERE        
   CoveragePlanID = @CoveragePlanID        
   ANd         
   ISNULL(RecordDeleted, ''N'') = ''N''        
           
 )        
         
          
        
/*Table #16*/        
/*Advancedbilling code for rates*/        
SELECT         
 1 AS DeleteButton,        
 ''N'' AS RadioButton,        
 '''' AS Type,        
 pb.BillingCode + '' '' + ISNULL(pb.Modifier1, '''') + '' '' + ISNULL(pb.Modifier2, '''') AS CodeModifire,        
 pb.[ProcedureRateBillingCodeId], pb.[ProcedureRateId], pb.[FromUnit], pb.[ToUnit], pb.[BillingCode], pb.[Modifier1], pb.[Modifier2], pb.[Modifier3], pb.[Modifier4], pb.[RevenueCode], pb.[RevenueCodeDescription], pb.[Comment], pb.[RowIdentifier], 
pb.[CreatedBy], pb.[CreatedDate], pb.[ModifiedBy], pb.[ModifiedDate], pb.[RecordDeleted], pb.[DeletedDate], pb.[DeletedBy]         
FROM         
 ProcedureRateBillingCodes pb            
Left Join ProcedureRates pr        
on         
 pb.procedurerateid = pr.ProcedureRateID        
and        
 ISNULL(pr.BillingCodeModified, ''N'') = ''N''          
AND         
 ISNULL(pr.RecordDeleted, ''N'') = ''N''        
where         
 ISNULL(pb.RecordDeleted, ''N'') = ''N''        
order by pb.ProcedureRateBillingCodeId        
        
          
/* Commented By Balvinder on Nov.27 Task 93    
Eligible Clients*/        
/*Table #17*/        
/*    
SELECT             
 C.ClientID,        
 C.LastName + '', '' + C.FirstName AS ClientName,         
 1 AS PlanID,        
 CCP.ClientCoveragePlanId,        
 CCP.InsuredId,         
 CCH.COBOrder,         
 C.DOB,        
 CASE WHEN C.DOB IS NOT NULL THEN DATEDIFF(YEAR,C.DOB,GETDATE()) ELSE NULL END AS Age,         
 C.Sex,        
 GC.CodeName AS Race,        
 CAST(CONVERT(VARCHAR, CCH.StartDate, 101) AS DATETIME) AS StartDate,        
 CAST(CONVERT(VARCHAR, CCH.EndDate, 101) AS DATETIME) AS EndDate        
FROM                 
 ClientCoverageHistory CCH        
LEFT JOIN         
 ClientCoveragePlans CCP        
 ON         
 CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId         
LEFT JOIN        
 Clients C        
 ON         
 CCP.ClientId = C.ClientId         
--Join with ClientRaces and GlobalCodes for selecting Race field    
LEFT JOIN        
 ClientRaces CR        
 ON         
 C.ClientID = CR.ClientID        
LEFT JOIN        
 GlobalCodes GC        
 ON         
 CR.RaceId = GC.GlobalcodeID        
        
 WHERE        
  CCH.ClientCoveragePlanId         
  IN         
  (        
   SELECT        
    ClientCoveragePlanId          
   FROM          
    ClientCoveragePlans         
   WHERE         
    CoveragePlanId = @CoveragePlanID        
  )        
  AND        
  C.Active=''Y''        
  AND        
  ISNULL(CCH.RecordDeleted, ''N'') = ''N''          
  AND        
  ISNULL(CCP.RecordDeleted, ''N'') = ''N''         
  AND        
  ISNULL(C.RecordDeleted, ''N'') = ''N''        
Order by ClientName    
    
End of Balvinder''s Modification    
 */    
    
    ' 
END
GO
