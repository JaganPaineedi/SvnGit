/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanDetailOnLoadData]    Script Date: 12/09/2013 18:49:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanDetailOnLoadData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMCoveragePlanDetailOnLoadData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanDetailOnLoadData]    Script Date: 12/09/2013 18:49:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMCoveragePlanDetailOnLoadData] @CoveragePlanId INT
	,@BillingCodeTemplate CHAR(1)
	,@ProcedureRateId INT
	,@ShowOnlyBillableProcedureCodes INT
AS
/****************************************************************************** 
		** File: ssp_PMCoveragePlanDetailOnLoadData.sql
		[ssp_PMCoveragePlanDetailOnLoadData] 303,'T',
		** Name: ssp_PMCoveragePlanDetailOnLoadData
		** Desc:  
		** 
		** 
		** This template can be customized: 
		** 
		** Return values: Drop down values for Plan Details General Tab
		** 
		** Called by: 
		** 
		** Parameters: 
		** Input			Output 
		** ----------		----------- 
		** CoveragePlanId	Dropdown values for General Tab
		** Auth: Mary Suma
		** Date: 12/05/2011
		******************************************************************************* 
		** Change History 
		******************************************************************************* 
		** Date: 			Author: 			Description: 
		** 12/05/2011		Mary Suma			Procedure to retrieve drop down values in General Tab
		-------- 			-------- 			--------------- 
		** 16/08/2011		Mary Suma			Modified Subquery to Join and included CR Changes for Templates
		** 24/08/2011		Mary Suma			Fixed CoveragePlanRuleVariables and Limits
		** 25/08/2011		Mary Suma			Removed RowIdentifier from CoveragePlanRuleLimits,added DSM Description
		-- 27 Aug 2011		Girish				Readded References to Rowidentifier 
		** 13 Sep 2011		MSuma				Included PlaceOfService
		** 14 Sep 2011		MSuma				Included NotNull columns int the select ,Rowid for CoveragePlanClaimFormats
		** 20 Sep 2011		MSuma				Modified RowIdentifier from CoveragePlanRuleLimits- 
		** 27 Sep 2011		MSuma				Modified for Billing Codes 
		** 12 Oct 2011		MSuma				To retrieve Amount for Linked CoveragePlans
		** 31 Oct 2011		MSuma				Included CoveragePlanRuleTypes
		** 21 Nov 2011		Pradeep				DSMDescription from CoveragePlanRuleVariable is formatted.
		** 09 Dec 2011		MSuma				Added BillingCOdeTemplate as S for Null values
		** 13 Dec 2011		MSuma				Revoked the changes done for Null BillingCOdeTemplate values 
		** 27 Feb 2012		MSuma				Included RecordDeleted Check on ProcedureRateServiceArea
		** 18 May 2012      Shruthi.S           ElectronicEligibilityVerificationPayerId is added in the select
		** 09 Dec 2013      Akwinass.D          Phillhaven Development Task #122 - Plan Detail Changes
		                                        (Organization Section in Coverage Plan table select query Included.)
		**17 Feb 2014		Ponnin				Included new column 'ExcludeFromReallocationIfChargeExists' in CoveragePlans table. Why : Thresholds - Enhancements Task #12.
		** 20 Mar 2014      Md Hussain K        Included two new columns in 'ExpectedPayment' table & one new table 'ExpectedPaymentProcedureCodes' in the result set for Task# 161 Philhaven Development
		** 04-Apr-2014    John Sudhakar M		Added new parameters @ProcedureCodeId and @ShowBillableProcedureCodesOnly(Engineering Improvement Initiatives #1430)
		** 03-Jun-2014	  Ponnin				Added a Column 'PlanDoesNotAllowClaimResubmission' in CoveragePlans Table. Why : Task #167 of Core bugs.
		** 06-Jun-2014	  Ponnin				Returning first match of DSMCode records for CoveragePlanRuleVariable table (To avoid duplicate records). Returning first DSMdescription based on Javed email as, 'I do know if we need to add the DSMNumber to the table. Typically, the diagnosis rule does not depend on the description, just on the specific diagnosis code.
												In this case, if we are returning the record, just return the first match for the description (it does not matter which one)'. Why : Task #167 of Core bugs.
		** 12-Jun-2014    Ponnin				Removed Hardcoded Why : Task #167 of Core bugs.		
		** 12-Jun-2014    Ponnin				RecordDeleted condition is added for ProcedureCodes and Staff table on getting CoveragePlanRuleVariable table.	 Why : Task #167 of Core bugs.					
		** 21-Oct-2014    Anto  				Added the two new columns from coverage palans table  .	 Why : Task #9 	System Improvements.		
		** 01-06-2015     Shruthi.S             Added new field COBPriority in CoveragePlans .Ref #2 CEI -Cusotmizations.	
	    ** 19-08-2015     Aravind               Uncommented COBPriority Column in CoveragePlans Table
												Why :CEI - Environment Issues Tracking: #2.01 Plans - Cannot save COB Priority field and error  on save
         ** 24-08-2015     Vamsi                Uncommented SendAllowedAmountOnClaims,AddOnChargesOption, Column in CoveragePlans Table
												Why :Valley Client Acceptance Testing Issues: #343 Plan Details - Error on save																					
		/* 19 Oct 2015	   Revathi 				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
												why:task #609, Network180 Customization */	
		** 19 Nov 2015	   Pradeep				What : ExpectedPaymentDegrees is selected with @CoveragePlanId And removed LinkedProcedureRates for Performance improvement.
												Why : Harbor Support #788 
		   04 Fab 2016     Ajay					What: Added "Allowed Amount Percentage" field in "Plan Detail - Payment Adjustments"  for this I have modified stored procedure "ssp_PMCoveragePlanDetailOnLoadData", Data Set "DataSetPlanDetails", Design page, and also added a column "AllowedAmountPercentage" in "ExpectedPayment" table.
												Why: "Allowed Amount Percentage"  this field was missing.
												(Core Bugs: Task# 2012)
-- 05 May 2016			Vamsi							what:Added condition to check clientid null or not
--														why:task #94, Key Point - Support Go Live
     ** 15 June 2016    K.Soujanya              What:Added condition for sorting the list by Billing Code,CEI - Support Go Live #128     
     ** 08-Jul-2016       Anto  				Added a column "ERProcessingTemplateId" in Coverageplans table.	Why : Task #204 Engineering Improvement Initiatives- NBL(I).
     ** 21-SEP-2016       Akwinass  			What: Added a columns "Adjustment","AllowedAmountAdjustmentCode" in Coverageplans table and "AllowedAmountAdjustmentCode" in ExpectedPayment table.	
												Why : Task #337 Engineering Improvement Initiatives- NBL(I).
	 ** 28-JUNE-2016	Suneel N				What: Added column "DegreeId", "DegreeName", "AppliesToAllDegrees" in CoveragePlanRuleVariables table.
												Why : #98 MHP-Implementation
	** 08-FEB-2018	 Vandana Ojha				What: Added column "ProgramId", "ProgramName", "AppliesToAllPrograms" in CoveragePlanRuleVariables table.
												Why : #133 Texas Customizations		
	** 11-Nov-2017	    Ajay   				    What: Added column "DaysToRetroBill", "ReallocationStartDate", "ReallocationEndDate" in CoveragePlans table.
												Why : Valley-Enhancements Task#978											
		*******************************************************************************/
BEGIN
	BEGIN TRY
		--Table 1  Values to Load General Tab
		SELECT [CoveragePlanId]
			,[CoveragePlanName]
			,[DisplayAs]
			,cp.[Active]
			,[InformationComplete]
			,[AddressHeading]
			,[Address]
			,[City]
			,[State]
			,[ZipCode]
			,[AddressDisplay]
			,Cp.[PayerId]
			,[Capitated]
			,[ContactName]
			,[ContactPhone]
			,[ContactFax]
			,
			--ISNULL(BillingCodeTemplate,'S') As BillingCodeTemplate, 
			BillingCodeTemplate
			,[UseBillingCodesFrom]
			,[UseStandardRules]
			,[MedicaidPlan]
			,[MedicarePlan]
			,[ElectronicVerification]
			,[Comment]
			,[BillingDiagnosisType]
			,[PaperClaimFormatId]
			,[ElectronicClaimFormatId]
			,[CombineClaimsAtPayerLevel]
			,[ProviderIdType]
			,[ProviderId]
			,[ClaimFilingIndicatorCode]
			,[ElectronicClaimsPayerId]
			,[ElectronicClaimsOfficeNumber]
			,Cp.[CreatedBy]
			,Cp.[CreatedDate]
			,Cp.[ModifiedBy]
			,Cp.[ModifiedDate]
			,Cp.[RecordDeleted]
			,Cp.[DeletedDate]
			,Cp.[DeletedBy]
			,P.PayerName
			,Cp.BillingRulesTemplate
			,Cp.UseBillingRulesTemplateId
			,Cp.ExpectedPaymentTemplate
			,Cp.UseExpectedPaymentTemplateId
			,GC.CodeName AS PayerType
			,CP.ElectronicEligibilityVerificationPayerId
			,
			-- 09 Dec 2013      Akwinass.D          Phillhaven Development Task #122 - Plan Detail Changes
			--(Organization Section in Coverage Plan table select query Included.)
			CP.OrganizationName
			,CP.OrganizationContactName
			,CP.OrganizationTelephone
			,CP.OrganizationFax
			,CP.OrganizationClaimAddress
			,CP.OrganizationEmailAddress
			,CP.OrganizationCommentText
			,CP.ExcludeFromReallocationIfChargeExists
			,CP.PlanDoesNotAllowClaimResubmission
			,CP.ThirdPartyPlan
			,CP.SendAllowedAmountOnClaims
			,CP.AddOnChargesOption
			,CP.COBPriority
			,CP.ICD10StartDate
			,CP.ERProcessingTemplateId
			-- 21-SEP-2016       Akwinass
			,CP.Adjustment
			,CP.AllowedAmountAdjustmentCode
			-- 11-Nov-2017       Ajay
			,CP.DaysToRetroBill   
			,CP.ReallocationStartDate
			,CP.ReallocationEndDate
		FROM CoveragePlans AS CP
		INNER JOIN Payers P ON CP.PayerId = P.PayerID
		INNER JOIN GLobalCOdes GC ON GC.GlobalCodeId = P.PayerType
		WHERE CP.CoveragePlanID = @CoveragePlanID
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND GC.Active = 'Y'

		--AND CP.Active = 'Y'
		--Table 5 Procedure Rate Degree Popup
		SELECT - 1 AS Degree
			,'' AS CodeName
			,'' AS RecordDeleted
			,'N' AS Active
			,- 1 AS ProcedureRateDegreeId
			,NEWID() AS RowIdentifier
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS ProcedureRateId
			,'N' AS RecordDeleted
			,GETDATE() AS DeletedDate
			,'' AS DeletedBy
		FROM GlobalCodes
		WHERE GlobalCodeId = - 1

		--SELECT             
		--	   GlobalCodeId AS Degree          
		--	  ,CodeName          
		--	  ,PRD.RecordDeleted          
		--	  ,Active  
		--	  ,ProcedureRateDegreeId
		--	  ,PRD.RowIdentifier
		--	  ,PRD.CreatedBy
		--	  ,PRD.CreatedDate
		--	  ,PRD.ModifiedBy
		--	  ,PRD.ModifiedDate
		--	  ,PRD.ProcedureRateId
		--	  ,PRD.RecordDeleted
		--	  ,PRD.DeletedDate
		--	  ,PRD.DeletedBy
		--FROM          
		--	 GlobalCodes      GC   
		--	 JOIN ProcedureRateDegrees PRD         
		--ON 
		--	GC.GlobalCodeId = PRD.Degree
		--WHERE         
		-- ISNULL(GC.RecordDeleted, 'N') ='N'       
		--AND           
		-- (Category = 'DEGREE')          
		--AND  Active = 'Y'  
		--AND  ISNULL(PRD.RecordDeleted, 'N') ='N'  
		/**********************************************************************************************          
		   Table No.:6 ProcedureRate Programs Popup :           
	**********************************************************************************************/
		SELECT - 1 AS ProgramId
			,'' AS ProgramName
			,'0' AS StaffProgramId
			,'Y' AS Active
			,GETDATE() AS ModifiedDate
			,- 1 AS ProcedureRateProgramId
			,- 1 AS ProcedureRateId
			--,PRP.ProgramId
			,NEWID() AS RowIdentifier
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			--,PRP.RowIdentifier
			,'' AS DeletedBy
			,'N' AS RecordDeleted
			,GETDATE() AS DeletedDate
		FROM Programs
		WHERE ProgramId = - 1

		--SELECT            
		--	     prp.ProgramId           
		--	    ,ProgramName          
		--	    ,'0' AS StaffProgramId          
		--	    ,Active         
		--	    ,PRP.ModifiedDate
		--		,PRP.ProcedureRateProgramId
		--		,PRP.ProcedureRateId
		--		--,PRP.ProgramId
		--		,PRP.RowIdentifier
		--		,PRP.CreatedBy
		--		,PRP.CreatedDate
		--		,PRP.ModifiedBy 
		--		--,PRP.RowIdentifier
		--		,PRP.DeletedBy
		--		,PRP.RecordDeleted
		--		,PRP.DeletedDate
		--FROM          
		--	 Programs   P         
		--	 JOIN ProcedureRatePrograms    PRP  
		--ON ISNULL(P.RecordDeleted, 'N') ='N'     
		--WHERE 
		--	P.ProgramID = PRP.ProgramId AND
		--	--PRP.ProcedureRateId =   @ProcedureRateId   and
		--	ISNULL(PRP.RecordDeleted, 'N') ='N'  
		/**********************************************************************************************          
		   Table No.:7 ProcedureRate Locations Popup :           
	  **********************************************************************************************/
		SELECT - 1 AS LocationId
			,'' AS LocationName
			,'Y' AS RecordDeleted
			,'Y' AS Active
			,- 1 AS ProcedureRateLocationId
			,- 1 AS ProcedureRateId
			,NEWID() AS RowIdentifier
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,GETDATE() AS DeletedDate
			,'' AS DeletedBy
		FROM Locations
		WHERE LocationId = - 1;

		--SELECT            
		--	  PRL.LocationId           
		--	  ,L.LocationName          
		--	  ,PRL.RecordDeleted          
		--	  ,Active
		--	  ,PRL.ProcedureRateLocationId
		--	,PRL.ProcedureRateId
		--	,PRL.RowIdentifier
		--	,PRL.CreatedBy
		--	,PRL.CreatedDate
		--	,PRL.ModifiedBy
		--	,PRL.ModifiedDate 
		--	,PRL.DeletedDate  
		--	,PRL.DeletedBy       
		--FROM          
		--	 Locations   L         
		--	 JOIN ProcedureRateLocations        PRL  
		--ON          
		--	L.LocationId = PRL.LocationId
		--WHERE        
		--	 ISNULL(L.RecordDeleted, 'N') ='N'     AND
		--	 --PRL.ProcedureRateId =   @ProcedureRateId   and
		--	 ISNULL(PRL.RecordDeleted, 'N') ='N'  
		/**********************************************************************************************          
		   Table No.:8 Table Name : ProcedureRateStaff          
	**********************************************************************************************/
		--IF @BillingCodeTemplate <> 'S'          
		--	BEGIN          
		--	SELECT DISTINCT          
		--	  S.StaffId          
		--	 ,S.LastName + ', ' + S.FirstName AS StaffName   
		--	 ,PRS.ProcedureRateStaffId
		--	,PRS.ProcedureRateId
		--	,PRS.StaffId
		--	,PRS.RowIdentifier
		--	,PRS.CreatedBy
		--	,PRS.CreatedDate
		--	,PRS.ModifiedBy
		--	,PRS.ModifiedDate
		--	,PRS.RecordDeleted
		--	,PRS.DeletedDate       
		--	FROM          
		--	 Staff S    
		--	LEFT JOIN ProcedureRateStaff PRS ON  S.StaffId = PRS.StaffId 
		--	LEFT JOIN ProcedureRates PR ON PR.ProcedureRateId = PRS.ProcedureRateId    
		--	WHERE          
		--	 ISNULL(S.RecordDeleted, 'N') = 'N'          
		--	AND            
		--	 PR.CoveragePlanId =(CASE WHEN @BillingCodeTemplate='O' THEN (SELECT UseBillingCodesFrom FROM COVERAGEPLANS WHERE CoveragePlanId = @CoveragePlanID) ELSE @CoveragePlanID END)          
		--	AND ISNULL(PR.RecordDeleted, 'N') ='N'    
		--	AND  ISNULL(PRS.RecordDeleted, 'N') ='N'  
		--	ORDER BY StaffName           
		--END          
		--ELSE          
		--BEGIN          
		--	SELECT DISTINCT          
		--	  S.StaffId          
		--	 ,S.LastName + ', ' + S.FirstName AS StaffName  
		--	 ,PRS.ProcedureRateStaffId
		--	,PRS.ProcedureRateId
		--	,PRS.StaffId
		--	,PRS.RowIdentifier
		--	,PRS.CreatedBy
		--	,PRS.CreatedDate
		--	,PRS.ModifiedBy
		--	,PRS.ModifiedDate 
		--	,PRS.RecordDeleted
		--	,PRS.DeletedDate             
		--	FROM          
		--	 Staff S          
		--	LEFT JOIN ProcedureRateStaff PRS ON  S.StaffId = PRS.StaffId 
		--	LEFT JOIN ProcedureRates PR ON PR.ProcedureRateId = PRS.ProcedureRateId    
		--	WHERE           
		--	ISNULL(S.RecordDeleted, 'N') = 'N'       AND    
		--	CoveragePlanId IS NULL   AND       
		--	StandardRateId IS NULL   AND   
		--	BillingCodeModified IS NULL   AND
		--	ISNULL(PR.RecordDeleted, 'N') ='N'    AND
		--	ISNULL(PRS.RecordDeleted, 'N') ='N'   
		--	ORDER BY StaffName           
		--END     
		SELECT - 1 AS ProcedureRateStaffId
			,- 1 AS ProcedureRateId
			,- 1 AS StaffId
			,NEWID() AS RowIdentifier
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,'Y' AS RecordDeleted
			,GETDATE() AS DeletedDate
			,'' AS DeletedBy
		FROM ProcedureRateStaff
		WHERE ProcedureRateStaffId = - 1

		--	SELECT  PS.ProcedureRateStaffId
		--     ,PS.ProcedureRateId
		--     ,PS.StaffId
		--     ,PS.RowIdentifier
		--     ,PS.CreatedBy
		--     ,PS.CreatedDate
		--     ,PS.ModifiedBy
		--     ,PS.ModifiedDate
		--     ,PS.RecordDeleted
		--     ,PS.DeletedDate
		--     ,PS.DeletedBy
		--FROM ProcedureRateStaff PS
		--WHERE EXISTS (SELECT *
		--				FROM ProcedureRates PR
		--				WHERE 
		--				--PR.ProcedureCodeID = @ProcedureCodeID AND
		--				 PS.ProcedureRateId = PR.ProcedureRateId
		--			 )	
		--			AND ISNULL(PS.RecordDeleted,'N')='N'     
		/**********************************************************************************************          
			   Table No.:9 Table Name : ProcedureRates Clients          
		**********************************************************************************************/
		SELECT - 1 AS ClientId
			,'' AS ClientName
		FROM Clients
		WHERE ClientId = - 1

		--IF @BillingCodeTemplate = 'S'          
		--BEGIN          
		--	SELECT DISTINCT          
		--	  C.ClientId          
		--	 ,C.LastName + ', ' + C.FirstName AS ClientName          
		--	FROM         
		--	 Clients C    
		--	 LEFT JOIN ProcedureRates PR ON
		--	 PR.ClientId = C.ClientId       
		--	WHERE           
		--		 ISNULL(C.RecordDeleted, 'N') = 'N' AND
		--		 PR.CoveragePlanId IS NULL  AND     
		--		 PR.StandardRateId IS NULL  AND 
		--		 PR.BillingCodeModified IS NULL    AND       
		--		 ISNULL(PR.RecordDeleted, 'N') ='N' 
		--	 ORDER BY ClientName           
		--END          
		--ELSE          
		--BEGIN          
		--	SELECT DISTINCT          
		--	  C.ClientId          
		--	 ,C.LastName + ', ' + C.FirstName AS ClientName          
		--	FROM          
		--	 Clients C  
		--	 LEFT JOIN ProcedureRates PR ON
		--	 PR.ClientId = C.ClientId           
		--	WHERE           
		--		ISNULL(C.RecordDeleted, 'N') = 'N' AND       
		--		PR.CoveragePlanId = (CASE WHEN @BillingCodeTemplate='O' THEN (SELECT UseBillingCodesFrom FROM COVERAGEPLANS WHERE CoveragePlanId = @CoveragePlanID) ELSE @CoveragePlanID END)          
		--	ORDER BY ClientName    
		--END
		/********************************************************************************/
		--Table 10 CoveragePlanRule -- 
		/********************************************************************************/
		SELECT 'N' AS RadioButton
			,1 AS DeleteButton
			,GC.CodeName AS RuleTypeName
			,CPR.[CoveragePlanRuleId]
			,[CoveragePlanId]
			,CPR.[RuleTypeId]
			,[RuleName]
			,CPR.[RuleViolationAction]
			,CPR.[CreatedBy]
			,
			--CPR.[CreatedDate], 
			CPR.[ModifiedBy]
			,CPR.[ModifiedDate]
			,CPR.[RecordDeleted]
			,CPR.[DeletedDate]
			,CPR.[DeletedBy]
			,Convert(VARCHAR(10), CPR.CreatedDate, 101) AS CreatedDt --PR.FromDate   
			,CPR.AppliesToAllProcedureCodes
			,CPR.AppliesToAllCoveragePlans
			--,CPR.AppliesToAllDiagnosisCodes  
			,CPR.AppliesToAllICD9Codes
			,CPR.AppliesToAllICD10Codes
			,CPR.AppliesToAllStaff
			,CPR.AppliesToAllDSMCodes
			,CPR.CoveragePlanRuleId
			,CPR.ModifiedBy
			,CPR.ModifiedDate
			,CPR.CreatedBy
			,CPR.CreatedDate
			,CPR.CoveragePlanId
			,CPR.AppliesToAllLocations
		FROM CoveragePlanRules CPR
		LEFT JOIN GlobalCodes GC ON CPR.RuleTypeId = GC.GlobalCodeId
		WHERE ISNULL(CPR.RecordDeleted, 'N') = 'N'
			AND CPR.CoveragePlanId = @CoveragePlanID
		ORDER BY CPR.CoveragePlanRuleID

		/********************************************************************************/
		/*Table #11  CoveragePlanRuleVariables*/
		/********************************************************************************/
		SELECT FinalData.ProcedureCode
			,FinalData.CoveragePlanName
			,FinalData.StaffName
			,FinalData.[ProcedureCodeId]
			,FinalData.[CoveragePlanId]
			,FinalData.[StaffId]
			,FinalData.[DiagnosisCode]
			,FinalData.[RecordDeleted]
			,FinalData.[DeletedDate]
			,FinalData.[DeletedBy]
			,FinalData.DSMDescription
			,FinalData.SelectAllCodes AS SelectAllCodes
			,FinalData.AppliesToAllProcedureCodes
			,FinalData.AppliesToAllCoveragePlans
			,FinalData.AppliesToAllDiagnosisCodes
			,FinalData.AppliesToAllStaff
			,FinalData.AppliesToAllDSMCodes
			,FinalData.RuleVariableId
			,FinalData.CreatedBy
			,FinalData.CreatedDate
			,FinalData.ModifiedBy
			,FinalData.ModifiedDate
			,FinalData.CoveragePlanRuleId
			,FinalData.DiagnosisCodeType
			,FinalData.AppliesToAllICD9Codes
			,FinalData.AppliesToAllICD10Codes
			,FinalData.[DegreeId]
			,FinalData.DegreeName
			,FinalData.AppliesToAllDegrees
			,FinalData.LocationId
			,FinalData.Location
			,FinalData.AppliesToAllLocations
			,FinalData.ProgramId            ---Texas Customizations #133
			,FinalData.ProgramName
			,FinalData.AppliesToAllPrograms
		FROM (
			SELECT ISNULL(PC.DisplayAs, 'N') AS ProcedureCode
				,CP.DisplayAs AS CoveragePlanName
				,ST.LastName + ', ' + ST.FirstName AS StaffName
				,CPRV.[ProcedureCodeId]
				,CPRV.[CoveragePlanId]
				,CPRV.[StaffId]
				,CPRV.[DiagnosisCode]
				,CPRV.[RecordDeleted]
				,CPRV.[DeletedDate]
				,CPRV.[DeletedBy]
				,CPRV.[DiagnosisCode] + ':' + DCD.DSMDescription AS DSMDescription
				,CASE 
					WHEN CPRV.ProcedureCodeId IS NULL
						AND CPRV.StaffId IS NOT NULL
						THEN 'Y'
					ELSE 'N'
					END AS SelectAllCodes
				,CPRV.AppliesToAllProcedureCodes
				,CPRV.AppliesToAllCoveragePlans
				,CPRV.AppliesToAllDiagnosisCodes
				,CPRV.AppliesToAllStaff
				,CPRV.AppliesToAllDSMCodes
				,CPRV.RuleVariableId
				,CPRV.CreatedBy
				,CPRV.CreatedDate
				,CPRV.ModifiedBy
				,CPRV.ModifiedDate
				,CPRV.CoveragePlanRuleId
				,CPRV.DiagnosisCodeType
				,CPRV.AppliesToAllICD9Codes
				,CPRV.AppliesToAllICD10Codes
				,CPRV.DegreeId
				,CPRV.LocationId
				,CPRV.AppliesToAllLocations 
				,L.LocationName As Location    ------for Locations
				,GC1.CodeName AS DegreeName
				,CPRV.AppliesToAllDegrees
				,CPRV.ProgramId
				,P.ProgramName AS ProgramName
				,CPRV.AppliesToAllPrograms
				,ROW_NUMBER() OVER (
					PARTITION BY CPRV.[DiagnosisCode]
					,CPRV.RuleVariableId ORDER BY CPRV.[DiagnosisCode] ASC
					) AS RankNo
			--,DENSE_RANK() OVER CPRV.[DSMCode] (ORDER BY CPRV.[DSMCode]) as RankNo
			FROM CoveragePlanRuleVariables CPRV
			INNER JOIN CoveragePlanRules CPR ON cpr.CoveragePlanRuleId = CPRV.CoveragePlanRuleId
			LEFT JOIN CoveragePlans CP ON CPRV.CoveragePlanId = CP.CoveragePlanId
			LEFT JOIN ProcedureCodes PC ON CPRV.ProcedureCodeId = PC.ProcedureCodeId
			LEFT JOIN Staff ST ON CPRV.StaffId = ST.StaffId
			LEFT JOIN GlobalCodes GC1 ON CPRV.DegreeId = GC1.GlobalCodeId
			LEFT JOIN Programs P ON CPRV.ProgramId=P.ProgramId
			LEFT JOIN DiagnosisDSMCodes DC ON CPRV.DiagnosisCode = DC.DSMCode
			LEFT JOIN DiagnosisDSMDescriptions DCD ON DC.DSMCode = DCD.DSMCode
			LEFT JOIN Locations L ON CPRV.LocationId = L.LocationId --- For locations
			WHERE ISNULL(CPRV.RecordDeleted, 'N') = 'N'
				AND CPR.CoveragePlanId = @CoveragePlanId
				AND (
					(
						@ShowOnlyBillableProcedureCodes = 1
						AND cpr.RuleTypeId = 4267
						)
					OR @ShowOnlyBillableProcedureCodes = 0
					)
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				AND ISNULL(PC.RecordDeleted, 'N') = 'N'
				AND ISNULL(ST.RecordDeleted, 'N') = 'N'
				AND ISNULL(CPR.RecordDeleted, 'N') = 'N'
				AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
				AND ISNULL(L.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
			) FinalData
		WHERE FinalData.RankNo = 1

		/*Table #12*/
		/*CoveragePlanRuleLimits*/
		SELECT GC.CodeName AS LimitTypeName
			,PC.DisplayAs AS ProcedureCode
			,'' AS Per
			,[Daily]
			,[Weekly]
			,[Monthly]
			,[Yearly]
			,CPL.[RecordDeleted]
			,CPL.[DeletedDate]
			,CPL.[DeletedBy]
			,CPL.RuleLimitId
			,CPL.CoveragePlanRuleId
			,CPL.ProcedureCodeId
			,CPL.LimitType
			,CPL.RowIdentifier
			,CPL.CreatedBy
			,CPL.CreatedDate
			,CPL.ModifiedBy
			,CPL.ModifiedDate
		FROM CoveragePlanRuleLimits CPL
		INNER JOIN CoveragePlanRules CR ON CPL.CoveragePlanRuleId = CR.CoveragePlanRuleId
		LEFT JOIN GlobalCodes GC ON CPL.LimitType = GC.GlobalCodeId
		LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = CPL.ProcedureCodeID
		WHERE ISNULL(CPL.RecordDeleted, 'N') = 'N'
			AND CR.CoveragePlanID = @CoveragePlanID
			AND ISNULL(CR.RecordDeleted, 'N') = 'N'

		/***********************************************************/
		--Table 13 Grid values in Expected Payment
		/***********************************************************/
		SELECT EP.ExpectedPaymentId AS ExpectedPaymentNo
			,EP.BillingCode
			,
			--Added by Revathi  19 Oct 2015   			
			CASE 
		        WHEN ISNULL(EP.ClientId, 0) <> 0-- Added by Vamsi 5 May 2016
			      THEN
			CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END
		          ELSE ''
				END AS Client
			,CONVERT(VARCHAR, EP.FromDate, 101) AS PayFromDate
			,CONVERT(VARCHAR, EP.ToDate, 101) AS PayToDate
			,'$' + IsNull(LEFT(Convert(VARCHAR, EP.Payment, 1), CHARINDEX('.', Convert(VARCHAR, EP.Payment, 1)) - 1), '') + ' ' + '/$' + IsNull(LEFT(Convert(VARCHAR, EP.AllowedAmount, 1), CHARINDEX('.', Convert(VARCHAR, EP.AllowedAmount, 1)) - 1), '') + ' ' AS PaymentAdjustment
			,[ExpectedPaymentId]
			,[CoveragePlanId]
			,[FromDate]
			,[ToDate]
			,[Payment]
			,AllowedAmount
			,[ProgramGroupName]
			,[LocationGroupName]
			,[DegreeGroupName]
			,[StaffGroupName]
			,EP.[ClientId]
			,[Priority]
			,EP.[CreatedBy]
			,EP.[CreatedDate]
			,EP.[ModifiedBy]
			,EP.[ModifiedDate]
			,EP.[RecordDeleted]
			,EP.[DeletedDate]
			,EP.[DeletedBy]
			,Convert(VARCHAR(10), EP.FromDate, 101) AS FromDt
			,Convert(VARCHAR(10), EP.ToDate, 101) AS ToDt
			,--PR.ToDate     
			EP.[Modifier1]
			,EP.[Modifier2]
			,EP.[Modifier3]
			,EP.[Modifier4]
			,EP.[RevenueCode]
			,EP.[PlaceOfServiceGroupName]
			,EP.[PaymentPercentage]
			,EP.[ProcedureCodeGroupName]
			,-- Added by Md Hussain K
			EP.[ClientWasPresent]
			,EP.[ServiceAreaGroupName]
			,ISNULL(EP.BillingCode, '') + ' ' + ISNULL(EP.Modifier1, '') + ' ' + ISNULL(EP.Modifier2, '') + ' ' + ISNULL(EP.Modifier3, '') + ' ' + ISNULL(EP.Modifier4, '') AS BillingCodeModifiers
			,EP.AllowedAmountPercentage   -- Added By Ajay: Project: Core Bugs:#2012
			,EP.AllowedAmountAdjustmentCode -- 21-SEP-2016       Akwinass
			,GC.CodeName AS AllowedAmountAdjustmentCodeText
		FROM ExpectedPayment EP
		LEFT JOIN Clients C ON (EP.ClientID = C.ClientID)
		LEFT JOIN GlobalCodes GC ON EP.AllowedAmountAdjustmentCode = GC.GlobalCodeId AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		WHERE EP.CoveragePlanId = @CoveragePlanId
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N' ORDER BY ISNULL(EP.BillingCode, '') + ' ' + ISNULL(EP.Modifier1, '') + ' ' + ISNULL(EP.Modifier2, '') + ' ' + ISNULL(EP.Modifier3, '') + ' ' + ISNULL(EP.Modifier4, '') + ' ' + ISNULL(EP.RevenueCode,'')

		/*Table 14*/
		/*Select Locations from ExcpectedPayemnt*/
		SELECT EPL.[ExpectedPaymentLocationId]
			,EPL.[ExpectedPaymentId]
			,EPL.[LocationId]
			,EPL.[CreatedBy]
			,EPL.[CreatedDate]
			,EPL.[ModifiedBy]
			,EPL.[ModifiedDate]
			,EPL.[RecordDeleted]
			,EPL.[DeletedDate]
			,EPL.[DeletedBy]
		FROM ExpectedPayment EP
		INNER JOIN ExpectedPaymentLocations EPL ON EPL.ExpectedPaymentId = EP.ExpectedPaymentId
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
			AND ISNULL(EPL.RecordDeleted, 'N') = 'N'
			AND EP.CoveragePlanId = @CoveragePlanId
		ORDER BY EPL.ExpectedPaymentLocationId

		/*Table #15*/
		/*Select Program from ExcpectedPayemnt*/
		SELECT EPP.[ExpectedPaymentProgramId]
			,EPP.[ExpectedPaymentId]
			,EPP.[ProgramId]
			,EPP.[CreatedBy]
			,EPP.[CreatedDate]
			,EPP.[ModifiedBy]
			,EPP.[ModifiedDate]
			,EPP.[RecordDeleted]
			,EPP.[DeletedDate]
			,EPP.[DeletedBy]
		FROM ExpectedPaymentPrograms EPP
		INNER JOIN ExpectedPayment EP ON EPP.ExpectedPaymentId = EP.ExpectedPaymentId
			AND EP.CoveragePlanId = @CoveragePlanId
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
			AND ISNULL(EPP.RecordDeleted, 'N') = 'N'
		ORDER BY EPP.ExpectedPaymentProgramID

		/*Table #16*/
		/*Select Degree from ExcpectedPayemnt*/
		SELECT EPD.[ExpectedPaymentDegreeId]
			,EPD.[ExpectedPaymentId]
			,EPD.[Degree]
			,EPD.[CreatedBy]
			,EPD.[CreatedDate]
			,EPD.[ModifiedBy]
			,EPD.[ModifiedDate]
			,EPD.[RecordDeleted]
			,EPD.[DeletedDate]
			,EPD.[DeletedBy]
		FROM ExpectedPaymentDegrees EPD
		INNER JOIN ExpectedPayment EP ON EPD.ExpectedPaymentId = EP.ExpectedPaymentId
			AND EP.CoveragePlanId = @CoveragePlanId
			AND ISNULL(EPD.RecordDeleted, 'N') = 'N'
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
		ORDER BY ExpectedPaymentDegreeID

		/*Table #17*/
		/*Select Staff from ExcpectedPayment*/
		SELECT EPS.[ExpectedPaymentStaffId]
			,EPS.[ExpectedPaymentId]
			,EPS.[StaffId]
			,EPS.[CreatedBy]
			,EPS.[CreatedDate]
			,EPS.[ModifiedBy]
			,EPS.[ModifiedDate]
			,EPS.[RecordDeleted]
			,EPS.[DeletedDate]
			,EPS.[DeletedBy]
		FROM ExpectedPaymentStaff EPS
		INNER JOIN ExpectedPayment EP ON EPS.ExpectedPaymentId = EP.ExpectedPaymentId
			AND EP.CoveragePlanId = @CoveragePlanId
			AND ISNULL(EPS.RecordDeleted, 'N') = 'N'
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
		ORDER BY ExpectedPaymentStaffID

		/*Table #18*/
		/*Select Client from ExcpectedPayemnt*/
		SELECT EP.ExpectedPaymentId
			,EP.ClientId
		FROM ExpectedPayment EP
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND EP.CoveragePlanId = @CoveragePlanId

		--Table 19 ServiceArea for CoveragePlans
		SELECT CPSA.CoveragePlanServiceAreaId
			,CPSA.CreatedBy
			,CPSA.CreatedDate
			,CPSA.ModifiedBy
			,CPSA.ModifiedDate
			,CPSA.RecordDeleted
			,CPSA.DeletedDate
			,CPSA.DeletedBy
			,CPSA.CoveragePlanId
			,CPSA.ServiceAreaId
			,SA.ServiceAreaName
		FROM CoveragePlanServiceAreas CPSA
		LEFT JOIN ServiceAreas SA ON CPSA.ServiceAreaId = SA.ServiceAreaId
		WHERE CPSA.CoveragePlanId = @CoveragePlanId
			AND ISNULL(SA.RecordDeleted, 'N') = 'N'

		--Table 20 Expected Payment Service Area
		SELECT EP.[ExpectedPaymentId]
			,EPSA.ServiceAreaId
			,EP.ServiceAreaGroupName
			,EPSA.[CreatedDate]
			,EPSA.[ModifiedBy]
			,EPSA.[ModifiedDate]
			,EPSA.[RecordDeleted]
			,EPSA.[DeletedDate]
			,EPSA.[DeletedBy]
			,EPSA.ExpectedPaymentServiceAreaId
			,EPSA.CreatedBy
		FROM ExpectedPaymentServiceAreas EPSA
		INNER JOIN ExpectedPayment EP ON EPSA.ExpectedPaymentId = EP.ExpectedPaymentId
		--JOIN ServiceAreas SA ON EPSA.ServiceAreaId = EP
		WHERE EP.CoveragePlanId = @CoveragePlanId
			AND ISNULL(EPSA.RecordDeleted, 'N') = 'N'
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
		ORDER BY ExpectedPaymentServiceAreaId

		--Table 21 Expected Payment Place of Service
		SELECT EPPL.ExpectedPaymentPlaceOfServiceId
			,EPPL.[CreatedBy]
			,EPPL.[CreatedDate]
			,EPPL.[ModifiedBy]
			,EPPL.[ModifiedDate]
			,EPPL.[RecordDeleted]
			,EPPL.[DeletedDate]
			,EPPL.[DeletedBy]
			,EPPL.PlaceOfService
			,EPPL.ExpectedPaymentId
		FROM dbo.ExpectedPaymentPlaceOfServices EPPL
		INNER JOIN ExpectedPayment EP ON EPPL.ExpectedPaymentId = EP.ExpectedPaymentId
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = EPPL.PlaceOfService
		WHERE ISNULL(EP.RecordDeleted, 'N') = 'N'
			AND ISNULL(EPPL.RecordDeleted, 'N') = 'N'
			AND EP.CoveragePlanId = @CoveragePlanId

		--Table 22 Add Billing Code Modifiers
		SELECT PCM.[ProcedureCodeModifierId]
			,PCM.[CreatedBy]
			,PCM.[CreatedDate]
			,PCM.[ModifiedBy]
			,PCM.[ModifiedDate]
			,PCM.[RecordDeleted]
			,PCM.[DeletedDate]
			,PCM.[DeletedBy]
			,PCM.[ProcedureCodeId]
			,PCM.[ModifierId]
			,PCM.[DefaultOnService]
			,M.ModifierCode
			,M.SortOrder
			,CASE PCM.[DefaultOnService]
				WHEN 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS DefaultonServiceText
		FROM ProcedureCodeModifiers PCM
		INNER JOIN Modifiers M ON PCM.ModifierId = M.ModifierId
		WHERE ISNULL(PCM.RecordDeleted, 'N') = 'N'
			AND ISNULL(M.RecordDeleted, 'N') = 'N'

		--Table 23 	Add Billing Code ProcedureRate Place of Service
		SELECT - 1 AS [ProcedureRatePlacesOfServiceId]
			,'' AS [CreatedBy]
			,GETDATE() AS [CreatedDate]
			,'' [ModifiedBy]
			,GETDATE() AS [ModifiedDate]
			,'Y' AS [RecordDeleted]
			,GETDATE() AS [DeletedDate]
			,'' AS [DeletedBy]
			,- 1 AS [ProcedureRateId]
			,- 1 AS [PlaceOfServieId]
		FROM ProcedureRatePlacesOfServices
		WHERE ProcedureRatePlacesOfServiceId = - 1

		--SELECT 
		--	   PRS.[ProcedureRatePlacesOfServiceId]
		--	  ,PRS.[CreatedBy]
		--	  ,PRS.[CreatedDate]
		--	  ,PRS.[ModifiedBy]
		--	  ,PRS.[ModifiedDate]
		--	  ,PRS.[RecordDeleted]
		--	  ,PRS.[DeletedDate]
		--	  ,PRS.[DeletedBy]
		--	  ,PRS.[ProcedureRateId]
		--	  ,PRS.[PlaceOfServieId]
		--FROM 
		--ProcedureRatePlacesOfServices PRS JOIN ProcedureRates PR
		--ON PRS.ProcedureRateId = PR.ProcedureRateId AND
		--ISNULL(PR.RecordDeleted, 'N') = 'N' 
		-- WHERE  ISNULL(PRS.RecordDeleted,  'N') = 'N'
		--Table 24 	Add Billing Code ProcedureRate ServiceAreas
		SELECT - 1 AS [ProcedureRateServiceAreaId]
			,'' AS [CreatedBy]
			,GETDATE() [CreatedDate]
			,'' AS [ModifiedBy]
			,GETDATE() AS [ModifiedDate]
			,'Y' AS [RecordDeleted]
			,GETDATE() AS [DeletedDate]
			,'' AS [DeletedBy]
			,- 1 AS [ProcedureRateId]
			,- 1 AS [ServiceAreaId]
		FROM ProcedureRateServiceAreas
		WHERE ProcedureRateServiceAreaId = - 1;

		--  SELECT 
		--	   PRSA.[ProcedureRateServiceAreaId]
		--	  ,PRSA.[CreatedBy]
		--	  ,PRSA.[CreatedDate]
		--	  ,PRSA.[ModifiedBy]
		--	  ,PRSA.[ModifiedDate]
		--	  ,PRSA.[RecordDeleted]
		--	  ,PRSA.[DeletedDate]
		--	  ,PRSA.[DeletedBy]
		--	  ,PRSA.[ProcedureRateId]
		--	  ,PRSA.[ServiceAreaId] 
		--FROM 
		--ProcedureRateServiceAreas PRSA JOIN ProcedureRates PR ON
		--PR.ProcedureRateId = PRSA.ProcedureRateId AND
		--ISNULL(PR.RecordDeleted, 'N') = 'N'
		--WHERE  ISNULL(PRSA.RecordDeleted,  'N') = 'N'
		--To retrieve Amount for Linked CoveragePlans
		--SELECT ProcedureCodeId
		--	,ProcedureRateId
		--	,Amount
		--FROM ProcedureRates
		--WHERE IsNULL(RecordDeleted, 'N') = 'N'
		--	AND StandardRateID IS NULL
		--	AND CoveragePlanId IS NULL

		---Table procedureratesbillingcode added to manage procedureratesbillingcode advanced ------Verify
		/*Select from ProcedureRateAdvancedBillingCode.  
  SELECT 
		  -1 AS ProcedureRateBillingCodeId  
		  ,-1 AS ProcedureRateId  
		  ,0.00 AS FromUnit  
		  ,0.00 AS ToUnit  
		  ,'' AS BillingCode  
		  ,'' AS Modifier1  
		  ,'' AS Modifier2  
		  ,'' AS Modifier3  
		  ,'' AS Modifier4  
		  ,'' AS RevenueCode  
		  ,'' AS RevenueCodeDescription  
		  ,'' AS Comment  
		  ,'' AS CreatedBy  
		  ,GETDATE() AS CreatedDate  
		  ,'' AS ModifiedBy  
		  ,GETDATE() AS  ModifiedDate  
		  ,'Y' AS RecordDeleted  
		  ,GETDATE() DeletedDate  
		  ,'' AS DeletedBy  
		  ,'Y' AS AddModifiersFromService  
		  ,''  AS BillingCodeModifier 
  FROM ProcedureRateBillingCodes
  WHERE ProcedureRateBillingCodeId=-1
  */
		--Added by Md Hussain Khusro on 20/03/2014                          
		SELECT EPP.[ExpectedPaymentProcedureCodeId]
			,EPP.[CreatedBy]
			,EPP.[CreatedDate]
			,EPP.[ModifiedBy]
			,EPP.[ModifiedDate]
			,EPP.[RecordDeleted]
			,EPP.[DeletedDate]
			,EPP.[DeletedBy]
			,EPP.[ExpectedPaymentId]
			,EPP.[ProcedureCodeId]
		FROM ExpectedPaymentProcedureCodes EPP
		INNER JOIN ExpectedPayment EP ON EPP.ExpectedPaymentId = EP.ExpectedPaymentId
			AND EP.CoveragePlanId = @CoveragePlanId
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
			AND ISNULL(EPP.RecordDeleted, 'N') = 'N'
		ORDER BY EPP.ExpectedPaymentProcedureCodeId
			--SELECT PRB.ProcedureRateBillingCodeId  
			--     ,PRB.ProcedureRateId  
			--     ,PRB.FromUnit  
			--     ,PRB.ToUnit  
			--     ,PRB.BillingCode  
			--     ,PRB.Modifier1  
			--     ,PRB.Modifier2  
			--     ,PRB.Modifier3  
			--     ,PRB.Modifier4  
			--     ,PRB.RevenueCode  
			--     ,PRB.RevenueCodeDescription  
			--     ,PRB.Comment  
			--     ,PRB.CreatedBy  
			--     ,PRB.CreatedDate  
			--     ,PRB.ModifiedBy  
			--     ,PRB.ModifiedDate  
			--     ,PRB.RecordDeleted  
			--     ,PRB.DeletedDate  
			--     ,PRB.DeletedBy  
			--     ,PRB.AddModifiersFromService  
			--     ,ISNULL(PRB.BillingCode, '') + ' ' + ISNULL(PRB.Modifier1, '')+ ' ' + ISNULL(PRB.Modifier2, '')   AS BillingCodeModifier 
			----@ProcedureCodeName AS ProcedureCodeName,  
			----@EnteredAs AS CodeName,  
			----@DisplayAs AS DisplayAs     
			-- FROM ProcedureRateBillingCodes PRB JOIN ProcedureRates PR       
			-- ON   PRB.ProcedureRateId = PR.ProcedureRateId  
			--WHERE ISNULL(PRB.recordDeleted,'N')= 'N'
			--AND  ISNULL(PR.recordDeleted,'N')= 'N'		
			--AND PR.ProcedureRateId = @ProcedureRateId		
			--CoveragePlanRuleTypes
			--SELECT
			--	 RuleTypeId
			--	CreatedBy,
			--	CreatedDate,
			--	ModifiedBy,
			--	ModifiedDate,
			--	RecordDeleted,
			--	DeletedDate,
			--	DeletedBy,
			--	RuleTypeName,
			--	RuleVariesBy
			--FROM 
			--	CoveragePlanRuleTypes                                         
			--WHERE IsNULL(RecordDeleted,'N')='N' 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
		 + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMCoveragePlanDetailOnLoadData')
		  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
		  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())
		   + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
GO

