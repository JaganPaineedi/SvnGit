/****** Object:  StoredProcedure [dbo].[ssp_SCAuthorizationCodeDetails]    Script Date: 05/26/2016 10:45:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCAuthorizationCodeDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCAuthorizationCodeDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCAuthorizationCodeDetails]    Script Date: 05/26/2016 10:45:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCAuthorizationCodeDetails] @Authcodeid INT
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_SCAuthorizationCodeDetails    */
	/* Copyright: 2006 Streamlin Healthcare Solutions           */
	/* Creation Date:  21/12/2006                                    */
	/*                                                                   */
	/* Purpose: Gets List of  data show in AuthorizationCodeDetails  page*/
	/*                                                                   */
	/* Input Parameters: */
	/*                                                                   */
	/* Output Parameters:                                */
	/*                                                                   */
	/* Return:   */
	/*                                                                   */
	/* Called By: */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/*   Updates:                                                          */
	/*       Date              Author                  Purpose                                    */
	/* 21/12/2006    Sandeep Trivedi           Created            
/* 25 Aug,2010 25 Aug,2010 remove active check*/                          */
	/* 27/4/2011    Maninder					MODIFIED                    */
	-- 11/01/2012   MSuma						Commented ExternalReferenceId and rowidentifier due to datamodel change
	-- 06/16/2012   Pralyankar Kumar Singh		Added missing fields in the select list to remove concurrency issue.
	-- 03/14/2014   N Kiran Kumar Check if records deleted for ProcedureCodes table was missing when inner join is made with AuthorizationCodeProcedureCodes table
	-- 07/08/2015   Bernardin                   Commentted ProcedureCodes and BillingCodes selection to improve the performance
	-- 25/05/2016   Akwinass					Included Category1,Category2,Category3 columns in AuthorizationCodes (Task #418.03 Thresholds - Support)
	/*********************************************************************/
	--For Procedures Code    
	--  SELECT  '' as DeleteButton, '0' as CheckBox, ProcedureCodeId,      
	--           DisplayAs,      
	--           ProcedureCodeName,      
	--           Active,      
	--           EnteredAs,      
	--           FaceToFace,      
	--           GroupCode,      
	--           CreditPercentage,      
	--           --ExternalReferenceId,      
	--           CreatedBy,      
	--           CreatedDate,      
	--           ModifiedBy,      
	--           ModifiedDate,      
	--           RecordDeleted,      
	--           DeletedDate,      
	--           DeletedBy,
	--           ProcedureCodes.AllowDecimals,
	--           ProcedureCodes.AssociatedNoteId,
	--           ProcedureCodes.Category1,      
	--           ProcedureCodes.Category2,
	--           ProcedureCodes.Category3,
	--           ProcedureCodes.DisplayDocumentAsProcedureCode,
	--           ProcedureCodes.DoesNotRequireStaffForService,
	--           ProcedureCodes.EndDateEqualsStartDate,
	--           ProcedureCodes.ExternalCode1,
	--           ProcedureCodes.ExternalCode2,
	--           ProcedureCodes.ExternalSource1,
	--           ProcedureCodes.ExternalSource2,
	--           ProcedureCodes.MaxUnits,
	--           ProcedureCodes.MedicationCode,
	--           ProcedureCodes.MinUnits,
	--           ProcedureCodes.NotBillable,
	--           ProcedureCodes.NotOnCalendar,
	--           ProcedureCodes.RequiresSignedNote,
	--           ProcedureCodes.RequiresTimeInTimeOut,
	--           ProcedureCodes.UnitIncrements,
	--           ProcedureCodes.UnitsList
	--           --ProcedureCodes.RowIdentifier
	--      FROM ProcedureCodes where Active='Y'  and isNull(RecordDeleted,'N')<>'Y' order by ProcedureCodeName      
	--  --Checking For Errors      
	--  If (@@error!=0)      
	--  Begin      
	--   RAISERROR  20006   'ssp_SCAuthorizationCodeDetails: An Error Occured'       
	--   Return      
	--   End               
	----For Billing Codes          
	-- SELECT  '' as DeleteButton, '0' as CheckBox, BillingCodeId,    
	--           BillingCode,    
	--           CodeName,    
	--           Active,    
	--           CreatedBy,    
	--           CreatedDate,    
	--           ModifiedBy,    
	--           ModifiedDate,    
	--           RecordDeleted,    
	--           DeletedDate,    
	--           DeletedBy,
	--           BillingCodes.Units,
	--           BillingCodes.UnitType,
	--           BillingCodes.ReportingUnitType,
	--           HospitalCode,
	--           ExcludeDischargeDay,
	--           NoRateCode,
	--           ExternalCode1,
	--           ExternalSource1,
	--           ExternalCode2,
	--           ExternalSource2,
	--           UnlimitedDailyUnits,
	--           DailyUnits,
	--           UnlimitedWeeklyUnits,
	--           WeeklyUnits,
	--           UnlimitedMonthlyUnits,
	--           MonthlyUnits,
	--           UnlimitedYearlyUnits,
	--           YearlyUnits,
	--           ExceedLimitAction,
	--           ServiceEndDateEqualsStartDate,
	--           AllInsurers,
	--           ValidAllPlans,
	--           AuthorizationRequired,
	--           RowIdentifier,
	--           ReportingUnits
	--      FROM BillingCodes where Active='Y'  and isNull(RecordDeleted,'N')<>'Y' order by CodeName    
	BEGIN TRY
		--for AuthorizationCodes  
		SELECT AuthorizationCodeId
			,AuthorizationCodeName
			,DisplayAs
			,Active
			,Units
			,UnitType
			,ProcedureCodeGroupName
			,BillingCodeGroupName
			----- Addedmissing fields in the Select list. --------
			,[ClinicianMustSpecifyBillingCode]
			,[UMMustSpecifyBillingCode]
			,[DefaultBillingCodeId]
			,[DefaultModifier1]
			,[DefaultModifier2]
			,[DefaultModifier3]
			,[DefaultModifier4]
			,[Internal]
			,[External]
			-- 25/05/2016   Akwinass
			,[Category1]
			,[Category2]
			,[Category3]
			-------------------------------------
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM AuthorizationCodes
		WHERE (AuthorizationCodeId = @Authcodeid)
			AND (ISNULL(RecordDeleted, 'N') <> 'Y') -- Commented on 25 Aug,2010AND  Active='Y'   
			--For AuthorizationCodeBillingCodes  
			-- Orignal select * from AuthorizationCodeBillingCodes where AuthorizationCodeId=@Authcodeid and isNull(RecordDeleted,'N')<>'Y'  

		SELECT BC.CodeName AS CodeText
			,ABC.AuthorizationCodeBillingCodeId
			,ABC.AuthorizationCodeId
			,ABC.BillingCodeId
			,ABC.RowIdentifier
			,ABC.CreatedBy
			,ABC.CreatedDate
			,ABC.ModifiedBy
			,ABC.ModifiedDate
			,ABC.RecordDeleted
			,ABC.DeletedDate
			,ABC.DeletedBy
		FROM AuthorizationCodeBillingCodes AS ABC
		INNER JOIN BillingCodes AS BC ON ABC.BillingCodeId = BC.BillingCodeId
		WHERE (ABC.AuthorizationCodeId = @Authcodeid)
			AND (ISNULL(ABC.RecordDeleted, 'N') <> 'Y')
			AND Active = 'Y'

		--For AuthorizationCodeProcedureCodes  
		--select * from AuthorizationCodeProcedureCodes where AuthorizationCodeId=@Authcodeid  and IsNull(RecordDeleted,'N')<>'Y'  
		--Orignal select * from AuthorizationCodeProcedureCodes inner join ProcedureCodes on AuthorizationCodeProcedureCodes.ProcedureCodeId = ProcedureCodes.ProcedureCodeId  where AuthorizationCodeId=@Authcodeid  and IsNull(RecordDeleted,'N')<>'Y'  
		SELECT PC.DisplayAs AS CodeText
			,APC.AuthorizationCodeProcedureCodeId
			,APC.AuthorizationCodeId
			,APC.ProcedureCodeId
			,APC.RowIdentifier
			,APC.CreatedBy
			,APC.CreatedDate
			,APC.ModifiedBy
			,APC.ModifiedDate
			,APC.RecordDeleted
			,APC.DeletedDate
			,APC.DeletedBy
		FROM AuthorizationCodeProcedureCodes AS APC
		INNER JOIN ProcedureCodes AS PC ON APC.ProcedureCodeId = PC.ProcedureCodeId
		WHERE (APC.AuthorizationCodeId = @Authcodeid)
			AND (ISNULL(PC.RecordDeleted, 'N') <> 'Y')
			AND (ISNULL(APC.RecordDeleted, 'N') <> 'Y')
			AND Active = 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCAuthorizationCodeDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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