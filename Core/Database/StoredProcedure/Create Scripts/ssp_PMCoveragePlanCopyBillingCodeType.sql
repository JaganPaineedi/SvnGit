
/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanCopyBillingCodeType]    Script Date: 03/24/2017 15:39:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanCopyBillingCodeType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMCoveragePlanCopyBillingCodeType]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PMCoveragePlanCopyBillingCodeType]    Script Date: 03/24/2017 15:39:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMCoveragePlanCopyBillingCodeType] @CoveragePlanID INT
	,@OtherCoveragePlanId INT
	,@BillingCodeTemplate CHAR(2)
	,@ShowOnlyBillableProcedureCodes INT =1 
AS
/******************************************************************************      
**  File: dbo..ssp_PMCoveragePlanCopyBillingCodeType .prc      
**  Name: dbo.ssp_PMCoveragePlanCopyBillingCodeType       
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
**  Auth: Mary Suma  
**  Date: 05/12/2011      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:   Author:  Description:      
**  --------  --------    -------------------------------------------      
**  05/12/2011  MSuma  Added for Billing Code Template  
** 08/24/2011  MSuma  Removed RowIdentifier  
**  09/13/2011  MSuma  Included Transactions and Modified filter criteria  
**  09/20/2011  MSuma  Included Distinct  
**  10/10/2011  MSuma  Insert into Child tables  
**  03/23/2017  Gautam Added new parameter @ShowOnlyBillableProcedureCodes to select Billable Procedure code w.r.t Core Bugs #2366. 
*******************************************************************************/
DECLARE @PrimaryKeys TABLE (
	ProcedureRateId INT
	,StandardRateId INT
	)
DECLARE @BillingCodeType CHAR(1)

BEGIN
	BEGIN TRANSACTION InsertPlan

	--Table 2, Billing Code Template is 'S' 'Use Standard Template'  
	BEGIN
		IF (@BillingCodeTemplate = 'TO')
			SET @BillingCodeType = 'O'

		IF (@BillingCodeTemplate = 'TS')
			SET @BillingCodeType = 'S'

		INSERT INTO [ProcedureRates] (
			PR.[CreatedBy]
			,PR.[CreatedDate]
			,PR.[ModifiedBy]
			,PR.[ModifiedDate]
			,PR.[RecordDeleted]
			,PR.[DeletedDate]
			,PR.[DeletedBy]
			,PR.[CoveragePlanId]
			,[ProcedureCodeId]
			,[FromDate]
			,[ToDate]
			,[Amount]
			,[ChargeType]
			,[FromUnit]
			,[ToUnit]
			,[ProgramGroupName]
			,[LocationGroupName]
			,[DegreeGroupName]
			,[StaffGroupName]
			,PR.[ClientId]
			,[Priority]
			,[BillingCodeClaimUnits]
			,[BillingCodeUnitType]
			,[BillingCodeUnits]
			,[BillingCode]
			,[Modifier1]
			,[Modifier2]
			,[Modifier3]
			,[Modifier4]
			,[RevenueCode]
			,[RevenueCodeDescription]
			,[Advanced]
			,PR.[Comment]
			,[StandardRateId]
			,[BillingCodeModified]
			,[NationalDrugCode]
			,[ServiceAreaGroupName]
			,[ClientWasPresent]
			,[ModifierId1]
			,[ModifierId2]
			,[ModifierId3]
			,[ModifierId4]
			,[AddModifiersFromService]
			,[PlaceOfServiceGroupName]
			)
		OUTPUT INSERTED.ProcedureRateId
			,INSERTED.StandardRateId
		INTO @PrimaryKeys(ProcedureRateId, StandardRateId)
		SELECT DISTINCT PR.[CreatedBy]
			,PR.[CreatedDate]
			,PR.[ModifiedBy]
			,PR.[ModifiedDate]
			,PR.[RecordDeleted]
			,PR.[DeletedDate]
			,PR.[DeletedBy]
			,@CoveragePlanId
			,PC.[ProcedureCodeId]
			,[FromDate]
			,[ToDate]
			,[Amount]
			,[ChargeType]
			,[FromUnit]
			,[ToUnit]
			,[ProgramGroupName]
			,[LocationGroupName]
			,[DegreeGroupName]
			,[StaffGroupName]
			,PR.[ClientId]
			,[Priority]
			,[BillingCodeClaimUnits]
			,[BillingCodeUnitType]
			,[BillingCodeUnits]
			,[BillingCode]
			,[Modifier1]
			,[Modifier2]
			,[Modifier3]
			,[Modifier4]
			,[RevenueCode]
			,[RevenueCodeDescription]
			,[Advanced]
			,CONVERT(VARCHAR(MAX), PR.[Comment])
			,PR.ProcedureRateId
			,[BillingCodeModified]
			,[NationalDrugCode]
			,[ServiceAreaGroupName]
			,[ClientWasPresent]
			,[ModifierId1]
			,[ModifierId2]
			,[ModifierId3]
			,[ModifierId4]
			,[AddModifiersFromService]
			,[PlaceOfServiceGroupName]
		FROM ProcedureRates PR
		JOIN ProcedureCodes PC ON PR.ProcedureCodeId = PC.ProcedureCodeId
		LEFT JOIN Clients CL ON PR.ClientID = CL.ClientID
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = PC.EnteredAs
		LEFT JOIN ProcedureRateDegrees PRD ON PR.ProcedureRateId = PRD.ProcedureRateId
		LEFT JOIN ProcedureRatePrograms PRP ON PR.ProcedureRateId = PRP.ProcedureRateId
		LEFT JOIN ProcedureRateStaff PRS ON PR.ProcedureRateId = PRS.ProcedureRateId
		WHERE (ISNULL(PRS.RecordDeleted, 'N') = 'N')
			AND (
				PR.RecordDeleted = 'N'
				OR PR.RecordDeleted IS NULL
				)
			AND (ISNULL(PC.RecordDeleted, 'N') = 'N')
			--AND   StandardRateId IS NULL       
			AND PC.Active = 'Y'
			--Included by Suma As a part or CR on CoveragePlanRuleTypes  
			--  03/23/2017  Gautam
			AND ((@ShowOnlyBillableProcedureCodes=0 )
				or
				(@ShowOnlyBillableProcedureCodes=1 
			AND NOT EXISTS (
				SELECT *
				FROM CoveragePlanRules cpr
				LEFT JOIN CoveragePlanRuleVariables cprv ON cpr.CoveragePlanRuleId = cprv.CoveragePlanRuleId
					AND ISNULL(cprv.RecordDeleted, 'N') = 'N'
					AND ISNULL(CPRV.ProcedureCodeId, PC.ProcedureCodeId) = PC.ProcedureCodeId
				WHERE cpr.RuleTypeId = 4267 --Not billable to this plan  
					--AND (isnull(cpr.AppliesToAllProcedureCodes,'Y') = 'Y' OR ISNULL(cprv.AppliesToAllProcedureCodes,'Y') = 'Y')   
					AND cpr.CoveragePlanId = @CoveragePlanId
					AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
					AND PR.ProcedureCodeID = CPRV.ProcedureCodeId
				)))
			AND ISNULL(pr.CoveragePlanId, 0) IN (
				SELECT CASE 
						WHEN @BillingCodeType = 'S'
							THEN 0
						WHEN @BillingCodeType = 'T'
							THEN @CoveragePlanID
						WHEN @BillingCodeType = 'O'
							THEN @OtherCoveragePlanId
						END
				FROM CoveragePlans cp2
				WHERE cp2.CoveragePlanId = @CoveragePlanId
					AND ISNULL(cp2.RecordDeleted, 'N') = 'N'
				)

		IF @BillingCodeTemplate = 'TS'
			OR @BillingCodeTemplate = 'TO'
		BEGIN
			SET @BillingCodeTemplate = 'T'

			UPDATE CoveragePlans
			SET BillingCodeTemplate = @BillingCodeTemplate
			WHERE CoveragePlanId = @CoveragePlanID
		END

		INSERT INTO ProcedureRateBillingCodes (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ProcedureRateId
			,FromUnit
			,ToUnit
			,BillingCode
			,Modifier1
			,Modifier2
			,Modifier3
			,Modifier4
			,RevenueCode
			,RevenueCodeDescription
			,Comment
			,AddModifiersFromService
			)
		SELECT CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,PK.ProcedureRateId
			,FromUnit
			,ToUnit
			,BillingCode
			,Modifier1
			,Modifier2
			,Modifier3
			,Modifier4
			,RevenueCode
			,RevenueCodeDescription
			,Comment
			,AddModifiersFromService
		FROM ProcedureRateBillingCodes PRBC
		JOIN @PrimaryKeys PK ON PRBC.ProcedureRateId = PK.StandardRateId
		WHERE ISNULL(PRBC.RecordDeleted, 'N') = 'N'

		INSERT INTO ProcedureRateLocations (
			ProcedureRateId
			,LocationId
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			)
		SELECT PK.ProcedureRateId
			,LocationId
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM ProcedureRateLocations PRBC
		JOIN @PrimaryKeys PK ON PRBC.ProcedureRateId = PK.StandardRateId
		WHERE ISNULL(PRBC.RecordDeleted, 'N') = 'N'

		INSERT INTO ProcedureRateDegrees (
			ProcedureRateId
			,Degree
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			)
		SELECT PK.ProcedureRateId
			,Degree
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM ProcedureRateDegrees PRBC
		JOIN @PrimaryKeys PK ON PRBC.ProcedureRateId = PK.StandardRateId
		WHERE ISNULL(PRBC.RecordDeleted, 'N') = 'N'

		INSERT INTO ProcedureRatePlacesOfServices (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ProcedureRateId
			,PlaceOfServieId
			)
		SELECT CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,PK.ProcedureRateId
			,PlaceOfServieId
		FROM ProcedureRatePlacesOfServices PRBC
		JOIN @PrimaryKeys PK ON PRBC.ProcedureRateId = PK.StandardRateId
		WHERE ISNULL(PRBC.RecordDeleted, 'N') = 'N'

		INSERT INTO ProcedureRatePrograms (
			ProcedureRateId
			,ProgramId
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			)
		SELECT PK.ProcedureRateId
			,ProgramId
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM ProcedureRatePrograms PRBC
		JOIN @PrimaryKeys PK ON PRBC.ProcedureRateId = PK.StandardRateId
		WHERE ISNULL(PRBC.RecordDeleted, 'N') = 'N'

		INSERT INTO ProcedureRateServiceAreas (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ProcedureRateId
			,ServiceAreaId
			)
		SELECT CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,PK.ProcedureRateId
			,ServiceAreaId
		FROM ProcedureRateServiceAreas PRBC
		JOIN @PrimaryKeys PK ON PRBC.ProcedureRateId = PK.StandardRateId
		WHERE ISNULL(PRBC.RecordDeleted, 'N') = 'N'

		INSERT INTO ProcedureRateStaff (
			ProcedureRateId
			,StaffId
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			)
		SELECT PK.ProcedureRateId
			,StaffId
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM ProcedureRateStaff PRBC
		JOIN @PrimaryKeys PK ON PRBC.ProcedureRateId = PK.StandardRateId
		WHERE ISNULL(PRBC.RecordDeleted, 'N') = 'N'
	END

	IF @@ERROR = 0
	BEGIN
		COMMIT TRANSACTION InsertPlan
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION InsertPlan
	END
END

GO


