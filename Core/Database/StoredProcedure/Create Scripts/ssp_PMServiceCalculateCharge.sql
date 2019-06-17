
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMServiceCalculateCharge]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMServiceCalculateCharge]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMServiceCalculateCharge]    Script Date: 10/21/2015 15:10:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_PMServiceCalculateCharge] @ClientId INT
	,@DateOfService DATETIME
	,@ClinicianId INT
	,@ProcedureCodeId INT
	,@Units DECIMAL(18, 2)
	,@ProgramId INT
	,@LocationId INT
	,@ProcedureRateId INT OUTPUT
	,@Charge MONEY OUTPUT
	,@ModifierId1 INT=NULL
	,@ModifierId2 INT=NULL
	,@ModifierId3 INT=NULL
	,@ModifierId4 INT=NULL
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_PMServiceCalculateCharge                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   *//* Input Parameters:           */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date  Author   Purpose                              */
/*  9/25/06  JHB    Created                               */
/*  9/28/2011 Priyanka  Modified   ProcedureRates.ChargeType datatype goes to type_GlobalCode  */
/*  10/12/2012 MSuma   Modified   Calculte Charge for custom Type        */
/*  02/14/2013 AmitSr   Modified   #8, Spenddown - Spenddown charge is associating to services,     
In the set up for spenddown, the users have set up a spenddown rate (actual rate + 10%) for procedure codes using the spenddown service area.  
 They also have set up the actual rate of the service.  The charge associated to a service entered is the spenddown charge, it should be the actual charge.    
    
Per the SRS the spenddown charge is only to be used to apply the charge amount on the customer spenddown page for spenddown charges tracking.
 The actual rate should still be associated to the service and be billed as the actual service amount.     
    
See attached for example - client 622 service for MI Case Management in train system.  */
-- 4/26/2013 JHB	Added support for $0 charge in case of custom rate type      
--06.May.2014		Venkatesh	Convert into the decimal fro task #1440 in corebugs
-- 2014.06.02		T.Remisoski Integrate matching to ProcedureRateServiceAreas (changes merged on 04.09.2015 by Khusro w.r.t Core Bugs #54)
-- JUN-28-2014		dharvey		Re-merged scsp_PMServiceOverrideCharge logic
-- 12/09/2014		NJain		Added Place of Service Procedure Rates logic
-- 2015.10.21		T.Remisoski	Corrected issue with left join on ProcedureRateServiceAreas related to spend down code
-- 12/6/2015		NJain		Added logic to look up POS for the Location when POS on the service is NULL
--12/9/2015         Revathi     what:Moving SSP CalculateCharge logic to ssf_PMServiceCalculateCharge as per Tom comments
--                              why: centralize rate calculation code
--12/10/2015		Revathi		what:Removed RemoveTimeStamp condition as per Slavik's Comments
--								why:task #863 Woods Customisation
--12/June/2016      Gautam      What: Added code to get the ProcedureRateId if modifiers exists in Procedure Rate . also added 4 new input parameters ModifierId 
--								Why: The existing code is not actually using modifiers to find a rate,Camino - Environment Issues Tracking, #86 
--08/March/2016     Arjun K R   Added 4 new parameters to scsp_PMServiceOverrideCharge stored procedure.
-- 06/27/2018		MD			Added logic to calculate charge only for the Billable Procedure Codes w.r.t KCMHSAS - Support #1075
/*********************************************************************/
-- Added by MD on 06/27/2018  
IF EXISTS(SELECT 1 FROM ProcedureCodes WHERE ProcedureCodeId=@ProcedureCodeId AND ISNULL(NotBillable,'N')='Y' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
 SELECT  @ProcedureRateId = NULL 
		,@Charge = NULL
END
ELSE
BEGIN
--Determine ServiceId
-- Get Service Info
	SELECT TOP 1 @ProcedureRateId = ProcedureRateId
		,@Charge = Charge
	FROM [dbo].ssf_PMServiceCalculateCharge(@ClientId, @DateOfService, @ClinicianId, @ProcedureCodeId, @Units, @ProgramId, @LocationId
											,@ModifierId1,@ModifierId2,@ModifierId3,@ModifierId4) --12/June/2016      Gautam

	-- DJH 12.10.2012 Call custom procedure if Procedure code requires CPT Code handling
	DECLARE @ProcedureRateIdOverride INT
		,@ChargeOverride MONEY

	-- DJH JUL-1-2014 - added existence check on SCSP 
	IF OBJECT_ID('dbo.scsp_PMServiceOverrideCharge', 'P') IS NOT NULL
	BEGIN
		DECLARE @ServiceId INT

		IF (SELECT COUNT(*)
			 FROM Services
			 WHERE ClientId = @ClientId
					AND DateOfService = @DateOfService
					AND ClinicianId = @ClinicianId
					AND ProcedureCodeId = @ProcedureCodeId
					AND Unit = @Units
					AND ProgramId = @ProgramId
					AND LocationId = @LocationId
					AND [Status] IN (70,71,75)
					AND ISNULL(RecordDeleted, 'N') = 'N'
				) = 1
		BEGIN
			SELECT @ServiceId = ServiceId
			FROM Services
			WHERE ClientId = @ClientId
				AND DateOfService = @DateOfService
				AND ClinicianId = @ClinicianId
				AND ProcedureCodeId = @ProcedureCodeId
				AND Unit = @Units
				AND ProgramId = @ProgramId
				AND LocationId = @LocationId
				AND [Status] IN (70,71,75)
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		--Modified on08/March/2016 by Arjun K R
		EXEC scsp_PMServiceOverrideCharge @ServiceId = @ServiceId
			,@ProcedureRateId = @ProcedureRateIdOverride OUTPUT
			,@Charge = @ChargeOverride OUTPUT,@ModifierId1=@ModifierId1,@ModifierId2=@ModifierId2,@ModifierId3=@ModifierId3,@ModifierId4=@ModifierId4
	END

	SELECT @ProcedureRateId = ISNULL(@ProcedureRateIdOverride, @ProcedureRateId)
		,@Charge = ISNULL(@ChargeOverride, @Charge)
END
RETURN
GO



