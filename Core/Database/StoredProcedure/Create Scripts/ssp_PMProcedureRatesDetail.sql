/****** Object:  StoredProcedure [dbo].[ssp_PMProcedureRatesDetail]    Script Date: 04/01/2014 16:41:49 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMProcedureRatesDetail]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMProcedureRatesDetail]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMProcedureRatesDetail]    Script Date: 04/01/2014 16:41:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMProcedureRatesDetail] @ProcedureCodeId INT
AS
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMProcedureRatesDetail
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return data for the procedure rate details page.
--
-- Author:  Girish Sanaba
-- Date:    19 May 2011
--
-- *****History****
-- Date					Author							History
-- 10 Jun 2011			MSuma							Included additonal check to filer only 
														for coverage plan Id as NULL in the Grid
-- 24 Aug 2011			Girish							Removed References to Rowidentifier and/or 
														ExternalReferenceId
-- 27 Aug 2011			Girish							Readded References to Rowidentifier 
-- 03 Oct 2011			MSuma							Modified DataType for ChargeType
-- 03 Jan 2011			MSuma							Included Active Check for Standard RAteId
-- 13 Jan 2011			MSuma							Degree and Staffs are retrieved from Application Shared Table-Deej
-- 24 Jan 2011			MSuma							Included RecordDeleted Check for ProcedureCodeProgram and Staff Credentials
-- 27 Jan 2012          Shruthi.S                       Included changes for inserting to programprocedures table
-- 12 Oct 2012			MSuma							Included Changes for custom Charge Types
-- 02 Dec 2013			John Sudhakar M					Changes to allow 4 decimals for Charge. 
-- 01 April 2014		Akwinass    					Included Procedure Code Type Columns BedProcedureCode and MedicationProcedureCode for task #979 in Philhaven - Customization Issues Tracking.
-- 18 April 2014		PPotnuru                        Commented  ISNULL(PR.BillingCodeModified, 'N') = 'N' in procedure rates select statement as need to update same record if he checks same coverageplan
-- 21 Apr 2014			Md Hussain Khusro				Added new table "ProcedureAddOnCodes" in the result set for task #1420 - Add On Codes
--														Engineering Improvement Initiatives- NBL(I)
-- 19 Oct 2015			Revathi							what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
--														why:task #609, Network180 Customization

-- 02 FEB 2016			Vamsi							what:Added condition to check clientid null or not
--														why:task #82, Woods - Environment Issues Tracking
-- 13 Sept 2016			Nandita							Added mobile column to Procedure code table
-- 03 JAN 2017          Pabitra                         What:Added Column DoesNotRequireBillingDiagnosis  to check if the procedure codes requires a diagnosis or not.(Removed the Commented Code)
--                                                     Why: Camino Support Go Live #201
-- 02/10/2017           jcarlson                        Keystone Customizations 69 - Increased the DisplayAs field to 75 characters
-- 06/03/2017           Lakshmi							Added RecordDeleted check to the tables, procedurerate prgarams,locations,place of services degrees,staff. Harbor Support - #1024
-- 03/07/2017			PradeepA						Added MobileAssociatedNoteId column for #2 Mobile.
-- 03/14/2017           MD Hussain K					Added two new columns "EDI837UnitsPerServiceUnit" and "EDI837UnitType" in the result set of ProcedureRates as it is added in table w.r.t Valley - Support Go Live #1117
-- 04 May 2017		Manjunath K						Added New Column AttendanceServiceProcedureCode for Woods Support Go Live #444 
-- 02/23/2017           jcarlson						Keystone Customizations 55 - Added Start and End Date to Program Procedures table
-- 21 Nov 2017          Ajay K Bangar                   Added two new columns "ExternalCode3" and "ExternalSource3" in ProcedureCodes table as it is requested in Meaningful Use - Stage 3: #66 
-- 24 Nov 2017          Akwinass                       Added two new column "AllowAttachmentsToService" in ProcedureCodes table (Task #589 in Engineering Improvement Initiatives- NBL(I))
-- 12 Jan 2018          Vijay                          Added RecordDeleted check for subquery(ProcedureRates table) (Task #19.14 in ARM-Enhancements)
-- Jan 24 2018			PradeepA					   Uncommented MobileAssociatedNoteId colum which is commented as part Keystone Customizations 55
-- 04/10/2017		    jcarlson					 Added logic to return ProcedureCodeCQMConfigurations data
--Dec/05/2018			Swatika						 What/Why:Added new column namely "RequireSignedNoteForNonBillableService" in ProcedureCodes table. Engineering Improvement Initiatives- NBL(I) #709
*********************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ProcedureCodeName VARCHAR(250)
		DECLARE @EnteredAs AS VARCHAR(30)
		DECLARE @DisplayAs AS VARCHAR(75)
		DECLARE @AllowDecimals CHAR(1)

		SELECT @ProcedureCodeName = ProcedureCodeName
			,@EnteredAs = CodeName
			,@AllowDecimals = AllowDecimals
			,@DisplayAs = DisplayAs
		FROM GlobalCodes
		INNER JOIN ProcedureCodes ON GlobalCodeId = EnteredAs
		WHERE ProcedureCodeId = @ProcedureCodeId

		--Procedure Code                                        	                     
		SELECT [ProcedureCodeId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[DisplayAs]
			,[ProcedureCodeName]
			,[Active]
			,[AllowDecimals]
			,[EnteredAs]
			,[NotBillable]
			,[DoesNotRequireStaffForService]
			,[NotOnCalendar]
			,[FaceToFace]
			,[GroupCode]
			,[MedicationCode]
			,[EndDateEqualsStartDate]
			,[RequiresTimeInTimeOut]
			,[RequiresSignedNote]
			,[AssociatedNoteId]
			,[MinUnits]
			,[MaxUnits]
			,[UnitIncrements]
			,[UnitsList]
			,[ExternalCode1]
			,[ExternalSource1]
			,[ExternalCode2]
			,[ExternalSource2]
			,[CreditPercentage]
			,[Category1]
			,[Category2]
			,[Category3]
			,[DisplayDocumentAsProcedureCode]
			,[AllowModifiersOnService]
			,[AllowAllPrograms]
			,[AllowAllLicensesDegrees]
			,@EnteredAs AS CodeName
			/*----01-April-2014----Akwinass----*/
			,[BedProcedureCode]
			,[MedicationProcedureCode] 
		/*---------------------------------*/
		,[Mobile]
		 ,[DoesNotRequireBillingDiagnosis] /*--03-JAN-2016--Pabitra--*/
		,[MobileAssociatedNoteId]
		,AttendanceServiceProcedureCode /*--04 May 2017 Manjunath K	--*/
		,ExternalCode3   /*--21 Nov 2017 Ajay	--*/
		,ExternalSource3 /*--21 Nov 2017 Ajay	--*/
		,AllowAttachmentsToService /*--24-NOV-2017--Akwinass--*/
		,RequireSignedNoteForNonBillableService /*--04-Dec-2018--Swatika--*/
		FROM ProcedureCodes
		WHERE ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		--Procedure Rates                      
		SELECT CASE PR.ChargeType
				WHEN '6761'
					THEN '0'
				WHEN '6762'
					THEN '1'
				WHEN '6763'
					THEN '2'
				ELSE '0'
				END AS ChargeTypeIndex
			,
			--Added by Revathi   19 Oct 2015                
			CASE 
		        WHEN ISNULL(PR.ClientId, '') <> ''-- Added by Vamsi 2 Feb 2016
			      THEN 
			        CASE 
					   WHEN ISNULL(C.ClientType, 'I') = 'I' 
						   THEN (ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''))
					     ELSE ISNULL(C.OrganizationName, '')
					    END
		          ELSE ''
		         END AS Clients
			,'$' + CONVERT(VARCHAR, PR.Amount, 2) + ' ' + CASE ChargeType
				WHEN '6761' -- 'P' 
					THEN ' Per ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, FromUnit, 1)
								ELSE CAST(CAST(ROUND(FromUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' ' + ISNULL(@EnteredAs, '')
				WHEN '6762' --'E'  
					THEN ' Exactly for ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, FromUnit, 1)
								ELSE CAST(CAST(ROUND(FromUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' ' + ISNULL(@EnteredAs, '')
				WHEN '6763' --'R' 
					THEN ' Range ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, FromUnit, 1)
								ELSE CAST(CAST(ROUND(FromUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' To ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, ToUnit, 1)
								ELSE CAST(CAST(ROUND(ToUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' ' + ISNULL(@EnteredAs, '')
				ELSE ''
				END AS Charge
			,CONVERT(VARCHAR, PR.FromDate, 101) AS RateFromDate
			,CONVERT(VARCHAR, PR.ToDate, 101) AS RateToDate
			,ISNULL(PR.BillingCode, '') + ' ' + ISNULL(PR.Modifier1, '') + ' ' + ISNULL(PR.Modifier2, '') + ' ' + ISNULL(PR.Modifier3, '') + ' ' + ISNULL(PR.Modifier4, '') AS BillingCodeModifiers
			,PR.ProcedureRateId
			,PR.CreatedBy
			,PR.CreatedDate
			,PR.ModifiedBy
			,PR.ModifiedDate
			,PR.RecordDeleted
			,PR.DeletedDate
			,PR.DeletedBy
			,PR.CoveragePlanId
			,PR.ProcedureCodeId
			,PR.FromDate
			,PR.ToDate
			,PR.Amount
			,PR.ChargeType
			,PR.FromUnit
			,PR.ToUnit
			,PR.ProgramGroupName
			,PR.LocationGroupName
			,PR.DegreeGroupName
			,PR.StaffGroupName
			,PR.ClientId
			,PR.Priority
			,PR.BillingCodeClaimUnits
			,PR.BillingCodeUnitType
			,PR.BillingCodeUnits
			,PR.BillingCode
			,PR.Modifier1
			,PR.Modifier2
			,PR.Modifier3
			,PR.Modifier4
			,PR.RevenueCode
			,PR.RevenueCodeDescription
			,PR.Advanced
			,PR.Comment
			,PR.StandardRateId
			,PR.BillingCodeModified
			,PR.NationalDrugCode
			,PR.ServiceAreaGroupName
			,PR.ClientWasPresent
			,PR.ModifierId1
			,PR.ModifierId2
			,PR.ModifierId3
			,PR.ModifierId4
			,ISNULL(M1.ModifierCode, '') + ISNULL(', ' + M2.ModifierCode, '') + ISNULL(', ' + M3.ModifierCode, '') + ISNULL(', ' + M4.ModifierCode, '') AS ModifierGroupName
			,PR.AddModifiersFromService
			,PR.PlaceOfServiceGroupName
			,@ProcedureCodeName AS ProcedureCodeName
			,@EnteredAs AS CodeName
			,@DisplayAs AS DisplayAs
			,PR.ModifierGroupName
			-- Added on 3/14/2017 by MD
			,PR.EDI837UnitsPerServiceUnit
			,PR.EDI837UnitType
			----------------------------
		FROM ProcedureRates PR
		LEFT JOIN Clients C ON PR.ClientID = C.ClientId
		LEFT JOIN Modifiers M1 ON PR.ModifierId1 = M1.ModifierId
		LEFT JOIN Modifiers M2 ON PR.ModifierId2 = M2.ModifierId
		LEFT JOIN Modifiers M3 ON PR.ModifierId3 = M3.ModifierId
		LEFT JOIN Modifiers M4 ON PR.ModifierId4 = M4.ModifierId
		WHERE PR.ProcedureCodeId = @ProcedureCodeId
			--AND ISNULL(PR.BillingCodeModified, 'N') = 'N'                    
			AND ISNULL(PR.RecordDeleted, 'N') = 'N'

		/*Select from ProcedureRateAdvancedBillingCode.*/
		SELECT PRB.ProcedureRateBillingCodeId
			,PRB.ProcedureRateId
			,PRB.FromUnit
			,PRB.ToUnit
			,PRB.BillingCode
			,PRB.Modifier1
			,PRB.Modifier2
			,PRB.Modifier3
			,PRB.Modifier4
			,PRB.RevenueCode
			,PRB.RevenueCodeDescription
			,PRB.Comment
			,PRB.CreatedBy
			,PRB.CreatedDate
			,PRB.ModifiedBy
			,PRB.ModifiedDate
			,PRB.RecordDeleted
			,PRB.DeletedDate
			,PRB.DeletedBy
			,PRB.AddModifiersFromService
			,ISNULL(PRB.BillingCode, '') + ' ' + ISNULL(PRB.Modifier1, '') + ' ' + ISNULL(PRB.Modifier2, '') AS BillingCodeModifier
			,@ProcedureCodeName AS ProcedureCodeName
			,@EnteredAs AS CodeName
			,@DisplayAs AS DisplayAs
		FROM ProcedureRateBillingCodes PRB
		  WHERE EXISTS (
				SELECT 1
				FROM ProcedureRates PR
				WHERE PR.ProcedureCodeID = @ProcedureCodeID
					AND PRB.ProcedureRateId = PR.ProcedureRateId
					AND ISNULL(PR.RecordDeleted, 'N') = 'N'
				)
				AND ISNULL(PRB.RecordDeleted, 'N') = 'N'
		        ORDER BY ProcedureRateBillingCodeID

		--Coverage Plan Rules
		SELECT DISTINCT CPR.[CoveragePlanRuleId]
			,CPR.[CreatedBy]
			,CPR.[CreatedDate]
			,CPR.[ModifiedBy]
			,CPR.[ModifiedDate]
			,CPR.[RecordDeleted]
			,CPR.[DeletedDate]
			,CPR.[DeletedBy]
			,CPR.[CoveragePlanId]
			,CPR.[RuleTypeId]
			,CPR.[RuleName]
			,CPR.[AppliesToAllProcedureCodes]
			,CPR.[AppliesToAllCoveragePlans]
			--,CPR.[AppliesToAllDiagnosisCodes]
			,CPR.[AppliesToAllStaff]
			,CPR.[AppliesToAllDSMCodes]
			,CPR.[AppliesToAllICD9Codes]
			,CPR.[AppliesToAllICD10Codes]
			,[RuleViolationAction]
		FROM CoveragePlanRules CPR
		INNER JOIN CoveragePlanRuleVariables CPRV ON CPR.CoveragePlanRuleId = CPRV.CoveragePlanRuleId
		WHERE CPR.CoveragePlanId IN (
				SELECT CoveragePlanId
				FROM CoveragePlans a
				WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
				)
			AND RuleTypeId = 4267
			AND ISNULL(CPR.RecordDeleted, 'N') = 'N'
			AND ISNULL(CPRV.RecordDeleted, 'N') = 'N'
			AND CPRV.ProcedureCodeID = @ProcedureCodeID

		--Coverage Plan Rule Variables                                                         
		SELECT [RuleVariableId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[CoveragePlanRuleId]
			,[ProcedureCodeId]
			,[CoveragePlanId]
			,[StaffId]
			,[DiagnosisCode]
			,[AppliesToAllProcedureCodes]
			,[AppliesToAllCoveragePlans]
			,[AppliesToAllDiagnosisCodes]
			,[AppliesToAllStaff]
			,[AppliesToAllDSMCodes]
			,[AppliesToAllICD9Codes]
			,[AppliesToAllICD10Codes]
			,[DiagnosisCodeType]
		FROM CoveragePlanRuleVariables
		WHERE ProcedureCodeID = @ProcedureCodeID
			AND CoveragePlanRuleId IN (
				SELECT CoveragePlanRuleId
				FROM CoveragePlanRules CPR
				INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CPR.CoveragePlanId
					AND CPR.RuleTypeId = 4267
					AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(RecordDeleted, 'N') = 'N'
			--Coverage Plans
			;

		WITH ds
		AS (
			SELECT CoveragePlanId
				,RTRIM(LTRIM(ISNULL(DisplayAs, ''))) + ', ' + RTRIM(LTRIM(ISNULL(Address, ''))) + ', ' + RTRIM(LTRIM(ISNULL(City, ''))) + ', ' + RTRIM(LTRIM(ISNULL([State], ''))) + ', ' + RTRIM(LTRIM(ISNULL(ZipCode, ''))) AS CoveragePlanName
				,CASE 
					WHEN CoveragePlanId IN (
							SELECT a.CoveragePlanId
							FROM CoveragePlans a
							INNER JOIN CoveragePlanRules B ON a.CoveragePlanId = B.CoveragePlanId
								AND ISNULL(a.RecordDeleted, 'N') = 'N'
							INNER JOIN CoveragePlanRuleVariables C ON B.CoveragePlanRuleId = c.CoveragePlanRuleId
							WHERE B.RuleTypeId = 4267
								AND ISNULL(B.RecordDeleted, 'N') = 'N'
								AND ISNULL(C.RecordDeleted, 'N') = 'N'
								AND C.ProcedureCodeId = @ProcedureCodeID
							)
						THEN 1
					WHEN CoveragePlanId IN (
							SELECT a.CoveragePlanId
							FROM CoveragePlans a
							INNER JOIN CoveragePlanRules B ON a.CoveragePlanId = B.CoveragePlanId
							WHERE B.RuleTypeId = 4267
								AND ISNULL(B.RecordDeleted, 'N') = 'N'
								AND B.AppliesToAllProcedureCodes = 'Y'
							)
						THEN 2
					ELSE 0
					END AS CheckState
			FROM CoveragePlans
			WHERE Active = 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'
			)
		SELECT CoveragePlanId
			,CoveragePlanName
			,CheckState
		FROM ds
		WHERE CheckState IN (
				1
				,2
				)
		ORDER BY CoveragePlanName
			,CoveragePlanId

		/*PRPrograms*/
		SELECT PP.ProcedureRateProgramId
			,PP.ProcedureRateId
			,PP.ProgramId
			,PP.RowIdentifier
			,PP.CreatedBy
			,PP.CreatedDate
			,PP.ModifiedBy
			,PP.ModifiedDate
			,PP.RecordDeleted
			,PP.DeletedDate
			,PP.DeletedBy
		FROM ProcedureRatePrograms PP
		  WHERE EXISTS (
				SELECT 1
				FROM ProcedureRates PR
				WHERE PR.ProcedureCodeID = @ProcedureCodeID
					AND PP.ProcedureRateId = PR.ProcedureRateId
					AND ISNULL(PR.RecordDeleted, 'N') = 'N'
				) AND ISNULL(PP.RecordDeleted, 'N') = 'N'
		
		/*PRLocation*/
		SELECT PL.ProcedureRateLocationId
			,PL.ProcedureRateId
			,PL.LocationId
			,PL.RowIdentifier
			,PL.CreatedBy
			,PL.CreatedDate
			,PL.ModifiedBy
			,PL.ModifiedDate
			,PL.RecordDeleted
			,PL.DeletedDate
			,PL.DeletedBy
		FROM ProcedureRateLocations PL
		  WHERE EXISTS (
				SELECT 1
				FROM ProcedureRates PR
				WHERE PR.ProcedureCodeID = @ProcedureCodeID
					AND PL.ProcedureRateId = PR.ProcedureRateId
					AND ISNULL(PR.RecordDeleted, 'N') = 'N'
				) AND ISNULL(PL.RecordDeleted, 'N') = 'N'
		
		/*PRDegree*/
		SELECT PD.ProcedureRateDegreeId
			,PD.ProcedureRateId
			,PD.Degree
			,PD.RowIdentifier
			,PD.CreatedBy
			,PD.CreatedDate
			,PD.ModifiedBy
			,PD.ModifiedDate
			,PD.RecordDeleted
			,PD.DeletedDate
			,PD.DeletedBy
		FROM ProcedureRateDegrees PD
		  WHERE EXISTS (
				SELECT 1
				FROM ProcedureRates PR
				WHERE PR.ProcedureCodeID = @ProcedureCodeID
					AND PD.ProcedureRateId = PR.ProcedureRateId
					AND ISNULL(PR.RecordDeleted, 'N') = 'N'
				) AND ISNULL(PD.RecordDeleted, 'N') = 'N'  
		
		/*PRStaff*/
		SELECT PS.ProcedureRateStaffId
			,PS.ProcedureRateId
			,PS.StaffId
			,PS.RowIdentifier
			,PS.CreatedBy
			,PS.CreatedDate
			,PS.ModifiedBy
			,PS.ModifiedDate
			,PS.RecordDeleted
			,PS.DeletedDate
			,PS.DeletedBy
		FROM ProcedureRateStaff PS
		  WHERE EXISTS (
				SELECT 1
				FROM ProcedureRates PR
				WHERE PR.ProcedureCodeID = @ProcedureCodeID
					AND PS.ProcedureRateId = PR.ProcedureRateId
					AND ISNULL(PR.RecordDeleted, 'N') = 'N'
				) AND ISNULL(PS.RecordDeleted, 'N') = 'N'  
		

		SELECT ProcedureRateId
			,'$' + CONVERT(VARCHAR, PR.Amount, 2) + ' ' + CASE ChargeType
				--DataType changes for ChargeType  
				WHEN '6761' -- 'P' 
					THEN ' Per ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, FromUnit, 1)
								ELSE CAST(CAST(ROUND(FromUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' ' + ISNULL(@EnteredAs, '')
				WHEN '6762' --'E' 
					THEN ' Exactly for ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, FromUnit, 1)
								ELSE CAST(CAST(ROUND(FromUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' ' + ISNULL(@EnteredAs, '')
				WHEN '6763' --'R' 
					THEN ' Range ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, FromUnit, 1)
								ELSE CAST(CAST(ROUND(FromUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' To ' + (
							CASE 
								WHEN @AllowDecimals = 'Y'
									THEN CONVERT(VARCHAR, ToUnit, 1)
								ELSE CAST(CAST(ROUND(ToUnit, 0) AS INT) AS VARCHAR)
								END
							) + ' ' + ISNULL(@EnteredAs, '')
				ELSE ''
				END AS Charge
		FROM ProcedureRates PR
		LEFT JOIN Clients C ON PR.ClientID = C.ClientId
		WHERE PR.ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(PR.BillingCodeModified, 'N') = 'N'
			AND ISNULL(PR.RecordDeleted, 'N') = 'N'
			AND CoveragePlanId IS NULL
			--Included Active Check
			AND PR.FromDate <= GETDATE()
			AND (
				PR.ToDate IS NULL
				OR PR.ToDate >= convert(DATETIME, convert(VARCHAR, GETDATE(), 101))
				)
		ORDER BY ProcedureRateId ASC


		SELECT PCP.[ProgramProcedureId]
			,PCP.[CreatedBy]
			,PCP.[CreatedDate]
			,PCP.[ModifiedBy]
			,PCP.[ModifiedDate]
			,PCP.[RecordDeleted]
			,PCP.[DeletedDate]
			,PCP.[DeletedBy]
			,PCP.[ProcedureCodeId]
			,PCP.[ProgramId]
			,PCP.[RowIdentifier]
			,CONVERT(VARCHAR(MAX),pcp.ProgramId) + ' - ' + P.ProgramCode AS ProgramName
			,pcp.StartDate
			,pcp.EndDate
		FROM ProcedureCOdes PC
		INNER JOIN ProgramProcedures PCP ON PC.ProcedureCodeId = PCP.ProcedureCodeId
		LEFT JOIN Programs P ON P.ProgramId = PCP.ProgramId
		WHERE PC.ProcedureCodeId = @ProcedureCodeId
			AND PC.Active = 'Y'
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND
			--Added by MSuma
			ISNULL(PCP.RecordDeleted, 'N') = 'N'

		--ProcedeureCodeStaffCredentials
		SELECT GC.GlobalCodeId
			,PC.ProcedureCodeId
			,GC.CodeName AS CodeName
			,PCS.[ProcedureCodeStaffCredentialId]
			,PCS.[CreatedBy]
			,PCS.[CreatedDate]
			,PCS.[ModifiedBy]
			,PCS.[ModifiedDate]
			,PCS.[RecordDeleted]
			,PCS.[DeletedDate]
			,PCS.[DeletedBy]
			,PCS.[ProcedureCodeId]
			,PCS.[DegreeLicenseType]
		FROM ProcedureCOdes PC
		INNER JOIN ProcedureCodeStaffCredentials PCS ON PC.ProcedureCodeId = PCS.ProcedureCodeId
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = PCS.DegreeLicenseType
		WHERE PC.ProcedureCodeId = @ProcedureCodeId
			AND PC.Active = 'Y'
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND GC.Active = 'Y'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND
			--Added by MSuma
			ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND ISNULL(PCS.RecordDeleted, 'N') = 'N'

		--General Modifiers
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
		WHERE PCM.ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(PCM.RecordDeleted, 'N') = 'N'
			AND ISNULL(M.RecordDeleted, 'N') = 'N'

		--	Place of Service
		SELECT PRS.[ProcedureRatePlacesOfServiceId]
			,PRS.[CreatedBy]
			,PRS.[CreatedDate]
			,PRS.[ModifiedBy]
			,PRS.[ModifiedDate]
			,PRS.[RecordDeleted]
			,PRS.[DeletedDate]
			,PRS.[DeletedBy]
			,PRS.[ProcedureRateId]
			,PRS.[PlaceOfServieId]
		FROM ProcedureRatePlacesOfServices PRS
		INNER JOIN ProcedureRates PR ON PRS.ProcedureRateId = PR.ProcedureRateId
			AND ISNULL(PR.RecordDeleted, 'N') = 'N'
			AND PR.ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(PRS.RecordDeleted, 'N') = 'N'  --Added by Lakshmi on 06/03/2017

		--Service Areas
		SELECT PRSA.[ProcedureRateServiceAreaId]
			,PRSA.[CreatedBy]
			,PRSA.[CreatedDate]
			,PRSA.[ModifiedBy]
			,PRSA.[ModifiedDate]
			,PRSA.[RecordDeleted]
			,PRSA.[DeletedDate]
			,PRSA.[DeletedBy]
			,PRSA.[ProcedureRateId]
			,PRSA.[ServiceAreaId]
		FROM ProcedureRateServiceAreas PRSA
		INNER JOIN ProcedureRates PR ON PR.ProcedureRateId = PRSA.ProcedureRateId
			AND ISNULL(PR.RecordDeleted, 'N') = 'N'
			AND PR.ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(PRSA.RecordDeleted, 'N') = 'N' --Added by Lakshmi on 06/03/2017

		-- Added by Md Hussain Khusro on 21/04/2014
		-- Add-On Procedure Codes  
		SELECT PAOC.[ProcedureAddOnCodeId]
			,PAOC.[CreatedBy]
			,PAOC.[CreatedDate]
			,PAOC.[ModifiedBy]
			,PAOC.[ModifiedDate]
			,PAOC.[RecordDeleted]
			,PAOC.[DeletedDate]
			,PAOC.[DeletedBy]
			,PAOC.[ProcedureCodeId]
			,PAOC.[AddOnProcedureCodeId]
			,PC.[ProcedureCodeName] AS ProcedureCodeName
		FROM ProcedureCodes PC
		INNER JOIN ProcedureAddOnCodes PAOC ON PC.ProcedureCodeId = PAOC.ProcedureCodeId
		WHERE PC.ProcedureCodeId = @ProcedureCodeId
			AND PC.Active = 'Y'
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND ISNULL(PAOC.RecordDeleted, 'N') = 'N'

	   SELECT 
			 a.ProcedureCodeCQMConfigurationId,
			 a.CreatedBy,
			 a.CreatedDate,
			 a.ModifiedBy,
			 a.ModifiedDate,
			 a.RecordDeleted,
			 a.DeletedBy,
			 a.DeletedDate,
			 a.ProcedureCodeId,
			 a.MeasureValueSetId,
			 mvs.MeasureId,
			 mvs.MeasureName,
			 mvs.CodeSystem,
			 mvs.Concept,
			 mvs.ConceptDescription
	   FROM ProcedureCodeCQMConfigurations AS a
	   JOIN CQMSolution.MeasureValueSet AS mvs ON a.MeasureValueSetId = mvs.MeasureValueSetId
	   WHERE isnull(a.RecordDeleted,'N')='N'
	   AND a.ProcedureCodeId = @ProcedureCodeId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMProcedureRatesDetail')
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

	RETURN
END
GO

