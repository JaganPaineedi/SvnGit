/****** Object:  StoredProcedure [dbo].[ssp_SCValidateUnitTypes]    Script Date: 1/28/2019 12:07:48 PM ******/
DROP PROCEDURE [dbo].[ssp_SCValidateUnitTypes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCValidateUnitTypes]    Script Date: 1/28/2019 12:07:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCValidateUnitTypes] 

	@AuthorizationCodeProcedureCodeIds VARCHAR(max) ,
    @AuthorizationCodeBillingCodeIds VARCHAR(max) ,
    @AuthorizationCodesUnitType INT  
    
AS
BEGIN
/********************************************************************************                              
-- Stored Procedure: dbo.ssp_SCValidateUnitTypes                                
--                              
-- Copyright: Streamline Healthcate Solutions                              
--                              
-- Purpose: Used by AuthorizationCodeDetails page 
-- To mapping unit types of Procedure codes and Billing codes with the unit type selected for the Auth Code.                            
--                              
-- Updates:                                                                                     
-- Date				Author			Purpose                              
-- 06.21.2016		Alok Kumar		Created for task#292 Engineering Improvement Initiatives- NBL(I).                                   
-- 30.Nov.2017      Aravind         Modified the Logic to Map Minutes,Hours,Encounters as per the requirement.
                                          1.For Minutes - mapping unittypes is Minutes,Hours
                                          2.For Hours - mapping unittypes is Minutes,Hours	
                                          3.For Encounters - mapping to all unittypes	
                                    Task #224 - Family & Children's Services - Support Go Live	
-- 28.Jan.2019		mraymond		Added mapping for Encounters unit type per Family & Children's Services - Support Go Live	#224														
******************************************************************************************************************/
	BEGIN TRY
		
	CREATE TABLE #ProcedureCodeIds (ProcedureCodeId INT)

	INSERT INTO #ProcedureCodeIds (ProcedureCodeId)
	SELECT *
	FROM dbo.fnSplit(@AuthorizationCodeProcedureCodeIds, ',')

	CREATE TABLE #BillingCodeIds (BillingCodeId INT)

	INSERT INTO #BillingCodeIds (BillingCodeId)
	SELECT *
	FROM dbo.fnSplit(@AuthorizationCodeBillingCodeIds, ',')
	
		
	SELECT TOP 1 1	--EnteredAs,*
	FROM ProcedureCodes PC
	INNER JOIN #ProcedureCodeIds PCI ON PC.ProcedureCodeId = PCI.ProcedureCodeId
		AND ISNULL(PC.Active, 'N') = 'Y'
	WHERE ISNULL(PC.RecordDeleted, 'N') = 'N'
		AND (
			(
				@AuthorizationCodesUnitType = 120		--Minutes (mapping unittypes is Minutes,Hours)
				AND (PC.EnteredAs <> 110)                
				AND (PC.EnteredAs <> 111)            
				)
			OR (
				@AuthorizationCodesUnitType = 121		--Hours  (mapping unittypes is Minutes,Hours)
				AND (PC.EnteredAs <> 111)
				AND (PC.EnteredAs <> 110)
				)
			OR (
				@AuthorizationCodesUnitType = 122		--Days
				AND (PC.EnteredAs <> 112)
				)
			OR (
				@AuthorizationCodesUnitType = 123		--Items
				AND (PC.EnteredAs <> 113)
				)
			OR (
				@AuthorizationCodesUnitType = 124		--Encounters (mapping to all unittypes)
				AND (
					PC.EnteredAs <> 110					--Minutes
					AND PC.EnteredAs <> 111				--Hours
					AND PC.EnteredAs <> 112             --Days
					AND PC.EnteredAs <> 113             --Items
					AND PC.EnteredAs <> 114             --mg 
					AND PC.EnteredAs <> 115             --Miles  
				    AND PC.EnteredAs <> 116             --Units
				    AND PC.EnteredAs <> 117             --Trips
				    AND PC.EnteredAs <> 118             --Injections
				    AND PC.EnteredAs <> 119			--Encounters -- added by mraymond 1/28/2019
					)
				)
			OR (
				@AuthorizationCodesUnitType = 125		--mg
				AND (PC.EnteredAs <> 114)
				)
			OR (
				@AuthorizationCodesUnitType = 126		--Miles
				AND (PC.EnteredAs <> 115)
				)
			OR (
				@AuthorizationCodesUnitType = 127		--Units
				AND (PC.EnteredAs <> 116)
				)
			OR (
				@AuthorizationCodesUnitType = 128		--Trips
				AND (PC.EnteredAs <> 117)
				)
			OR (
				@AuthorizationCodesUnitType = 129		--Injections
				AND (PC.EnteredAs <> 118)
				)
			OR (
				@AuthorizationCodesUnitType = 0			--Default if Auth Code unittype is not selected
				)
			)
	
	UNION

	SELECT TOP 1 1	--UnitType,*
	FROM BillingCodes BC
	INNER JOIN #BillingCodeIds BCI ON BC.BillingCodeId = BCI.BillingCodeId
		AND ISNULL(BC.Active, 'N') = 'Y'
	WHERE ISNULL(BC.RecordDeleted, 'N') = 'N'
		AND (
			(
				@AuthorizationCodesUnitType = 120		--Minutes (mapping unittypes is Minutes,Hours)
				AND (BC.UnitType <> 110)
				AND (BC.UnitType <> 111)
				)
			OR (
				@AuthorizationCodesUnitType = 121		--Hours (mapping unittypes is Minutes,Hours)
				AND (BC.UnitType <> 111)
				AND (BC.UnitType <> 110)
				)
			OR (
				@AuthorizationCodesUnitType = 122		--Days
				AND (BC.UnitType <> 112)
				)
			OR (
				@AuthorizationCodesUnitType = 123		--Items
				AND (BC.UnitType <> 113)
				)
			OR (
				@AuthorizationCodesUnitType = 124		--Encounters (mapping to all unittypes)
				AND (
					BC.UnitType <> 110					--Minutes
					AND BC.UnitType <> 111				--Hours
					AND BC.UnitType <> 112				--Days
					AND BC.UnitType <> 113				--Items
					AND BC.UnitType <> 114				--mg
					AND BC.UnitType <> 115				--Miles
					AND BC.UnitType <> 116				--Units
					AND BC.UnitType <> 117				--Trips
					AND BC.UnitType <> 118				--Injections
			
					)
				)
			OR (
				@AuthorizationCodesUnitType = 125		--mg
				AND (BC.UnitType <> 114)
				)
			OR (
				@AuthorizationCodesUnitType = 126		--Miles
				AND (BC.UnitType <> 115)
				)
			OR (
				@AuthorizationCodesUnitType = 127		--Units
				AND (BC.UnitType <> 116)
				)
			OR (
				@AuthorizationCodesUnitType = 128		--Trips
				AND (BC.UnitType <> 117)
				)
			OR (
				@AuthorizationCodesUnitType = 129		--Injections
				AND (BC.UnitType <> 118)
				)
			OR (
				@AuthorizationCodesUnitType = 0			--Default if Auth Code unittype is not selected
				)
			)
	
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCValidateUnitTypes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


