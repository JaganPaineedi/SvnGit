
/****** Object:  StoredProcedure [dbo].[ssp_CMCreateServicesFromClaims]    Script Date: 12/26/2016 11:32:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMCreateServicesFromClaims]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMCreateServicesFromClaims]
GO

CREATE PROCEDURE [dbo].[ssp_CMCreateServicesFromClaims] (
	@ClaimlineIds VARCHAR(max)
	,@CreatedBy VARCHAR(250)
	)
AS
/*************************************************************************/
/* Stored Procedure: dbo.ssp_CMCreateServicesFromClaims                  */
/* Copyright: 2005 Provider Claim Management System						 */
/* Creation Date:  25/03/2015											 */
/*                                                                       */
/* Purpose: retuns the details of claimlines fro PayClaims               */
/*                                                                       */
/* Input Parameters: @ClaimlineIds                                       */
/*																		 */
/* Output Parameters:													 */
/*                                                                       */
/* Return:                                                               */
/*                                                                       */
/* Called By:                                                            */
/*                                                                       */
/* Calls:                                                                */
/*                                                                       */
/* Data Modifications:                                                   */
/*                                                                       */
/* Updates:                                                              */
/* Date            Author				Purpose                          */
/* 25/03/2015      Shruthi.S            Use to create services from claimlines.Ref #605 Network 180 
   02/04/2015      Shruthi.S            Added Sites join instead of using mapping table.Ref #605 Network 180 Customizations.
   13/04/2015      Shruthi.S            Added distinct to avoid duplicate entries.Ref #605 Network 180 Customizations.
   21-04-2015      Shruthi.S            Added diagnosis creation logic.Ref #3 CEI-Customizations.*/
-- 22.Apr.2015	   Rohith Uppin			fnSplitCM Reverted back to fnSplit as Input parameter in fnSplit is modified to Max size. #571 CM to SC issues.
-- 03/14/2016	   Alok Kumar			Added one more parameter @ClinicianId for calling SCSP for the task#72 CEI - Support Go Live
-- 05.Apr.2016     Gautam               Added RecordDeleted check on BillingCodeModifiers table. why: Duplicate record created.Task #25,The ARC - Environment Issues Tracking
-- 20 April 2016	Rajesh		Added ClaimLineId to #NewlyAddedServices.Why : Task 32 : Arc environment tracking issue 
-- 11 May 2016	   Satheesh		Added ClaimLineId to #NewlyAddedServices.Why : Task 32 : Arc environment tracking issue 
-- 06/09/2016      MD Hussain	Replace 'StartTime' if null with 'FromDate' while creating service Why: Task 38 : Arc environment tracking issue  
-- 20/07/2016      Shruthi.S    Modified the logic to get unit type from ProcedureCodes.Ref : #235 CEI Go-Live Support.
-- 27/07/2016      Shivanand.S  Changed Billable to 'Y' as per the task AspenPointe-Environment Issues#38
-- 12/08/2016      Shruthi.S    Added conditions as in CEI Go-Live 72.Ref : #170 Aspen Pointe Env Issues.
--17/08/2016	   Suneel N		Ref : #170 Aspen Pointe Env Issues.
-- 24/09/2016     Rajesh 	Added a condition to check for start time and end time and also added added a error message	   
--							Arc Support Go Live -task 32 - Service From Claims:  Claims are not converting to services
--12/01/2016 Deej Changed the StartTime logic for taking DOS of service to FromDate + Time part of StartTime.
							--Why:ARC - Environment Issues Tracking  #40
--12/26/2016      Shankha      what:Included the tables Globalcodes and Locations in the select query to fix the Place of service issue.
--                             Why:Claim line is entered for place of service code that corresponds to one of the set up.
--                                 The service created from the claim will use the correct location that is associated to the same place of service code as the claim line.(Project:CEI support go live task 343)
-- 30-8-2017     Sanjay       What: I have added RecordDeleted check condition for ClaimLineServiceMappings
--                            WHY : AspenPointe - Support Go Live: #447
-- 12/22/2017    Hemant       What :Modified the UNIT Logic while the creation of the service from claim lines.
--                            Why:  Services - End Time Issues.Project: 	The Arc - Support Go Live #285  
--16/01/2018     Himmat      What:Added Record deleted and Error status <>Errror(76) Condition while deleting claimline from Temp Table
--                            Why:-As per CEI - Support Go Live#617
                        
/*************************************************************************/
BEGIN TRY
	CREATE TABLE #ClaimLines (ClaimLineId INT)

	INSERT INTO #ClaimLines (ClaimLineId)
	SELECT *
	FROM dbo.fnSplit(@ClaimLineIds, ',')

	--To get the default place of service
	DECLARE @DefaultLocation VARCHAR(100)

	SELECT @DefaultLocation = LocationId
	FROM Locations
	WHERE isnull(Defaultlocationforservicecreationfromclaims, 'N') = 'Y'

	---To get the default clinicianid for service creation
	DECLARE @ClinicianId INT

	SELECT @ClinicianId = value
	FROM SystemConfigurationKeys
	WHERE [key] = 'DefaultClinicianFromClaimToServiceCreation'

	---To remove claimlineid's for which already service is created.
	DELETE
	FROM #ClaimLines
	WHERE ClaimLineID IN (
			SELECT Cl.ClaimLineId
			FROM #ClaimLines CL
			JOIN ClaimLineServiceMappings CM ON CM.ClaimLineId = Cl.ClaimLineId
		    join Services SC on CM.ServiceId = sc.ServiceId where Sc.status <> 76 and ISNULL(SC.RecordDeleted, 'N') <> 'Y' AND ISNULL(CM.RecordDeleted, 'N') = 'N'---Added by Sanjay on 30-08-2017 
   
			)

	---Temp table to get the newly created serviceid's
	CREATE TABLE #NewlyAddedServices (
		ID INT Identity(1, 1)
		,ServiceId INT
		,ClaimLineId INT
		)

	--Temp table to insert the claimlineid's for mapping table
	CREATE TABLE #ClaimLineIdForMapping (
		ID INT Identity(1, 1)
		,ClaimLineId INT
		)
		
		

	---Logic to create service from claims----------
	--Custom logic to create service for CEI if scsp exist
	IF EXISTS (
			SELECT *
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CMCreateServicesFromClaims]')
				AND type IN (
					N'P'
					,N'PC'
					)
			)
	BEGIN
		INSERT INTO #NewlyAddedServices(ServiceId,ClaimLineId)  -- Added 21 apr 2016 rajesh
		EXEC scsp_CMCreateServicesFromClaims @DefaultLocation
			,@CreatedBy
			,@ClinicianId
	END
	ELSE
	BEGIN
		INSERT INTO Services (
			DateOfService
			,EndDateOfService  
			,[Status]
			,ProcedureCodeId
			,Unit
			,UnitType
			,LocationId
			,ClinicianId
			,CreatedBy
			,CreatedDate
			,Billable
			,ClientId
			,ProgramId
			,DeletedBy
			)
		OUTPUT INSERTED.ServiceId,INSERTED.DeletedBy
		INTO #NewlyAddedServices(ServiceId,ClaimLineId) --To insert into temp table newly added serviceid's
		SELECT DISTINCT 
		--ISNULL(CL.StartTime, CL.FromDate), -- Modified by MD Hussain on 6/9/2016
		--Modified By Deej--12/01/2016
		CAST(CL.FromDate AS DATETIME) + CAST(ISNULL(CL.StartTime, CL.FromDate) AS TIME) AS DateOfService,
		CAST(CL.ToDate AS DATETIME) + CAST(ISNULL(CL.EndTime, CL.ToDate) AS TIME) AS EndDateOfService
			,71
			,-- show status(service status)
			case when Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
	                                                        and BM.ProcedureCodeId is not null
															then BM.ProcedureCodeId   
														else  
														  case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														else
														case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BM.ProcedureCodeId is  null
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														 end end end ,
														 [dbo].[ssf_CMCalculateServiceUnits](CAST(CL.FromDate AS DATETIME) + CAST(ISNULL(CL.StartTime, CL.FromDate) AS TIME), CAST(CL.ToDate AS DATETIME) + CAST(ISNULL(CL.EndTime, CL.ToDate) AS TIME), CL.UNITS , BC.UnitType) AS Unit,  -- Hemant 12/22/2017
														 --BC.UNITS * CL.UNITS,
			 PC.EnteredAs
			,--unitype is units
			@DefaultLocation
			,--default location from location details
			CASE   
			  WHEN P.AssociatedClinicianId IS NULL  
			   THEN @ClinicianId  
			  ELSE P.AssociatedClinicianId  
			  END   
			,@CreatedBy
			,GETDATE()
			,'Y'--Changed to 'Y' as per the task AspenPointe-Environment Issues#38
			,-- Initially it will be set as not billable later it can be made as billable from service details.
			C.ClientId
			,S.ProgramId
			,Cl.ClaimLineId
		FROM Claims C
		JOIN ClaimLines CL ON C.ClaimId = CL.ClaimId
			AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
		JOIN #ClaimLines CT ON Cl.ClaimLineId = CT.ClaimLineId
			AND ISNULL(cl.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN BillingCodes BC ON Cl.BillingCodeId = BC.BillingCodeId
			AND ISNULL(BC.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN BillingCodeModifiers BM ON BM.BillingCodeId = Cl.BillingCodeId
			AND ISNULL(BM.RecordDeleted, 'N') <> 'Y'-- 05.Apr.2016     Gautam 
		JOIN Sites S ON S.SiteId = C.SiteId -- 17.Aug.2016	Suneel N
		left join Providers P on P.ProviderId = case when C.ClaimType= 2222 then S.ProviderId  else   
       case when cl.RenderingProviderId is null then S.ProviderId  else cl.RenderingProviderId  end  end AND ISNULL(P.RecordDeleted, 'N') <> 'Y'  
		left join ProcedureCodes PC on PC.ProcedureCodeId = case when Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
	                                                        and BM.ProcedureCodeId is not null
															then BM.ProcedureCodeId   
														else  
														  case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														else
														case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BM.ProcedureCodeId is  null
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														 end end end 
		WHERE (@ClinicianId IS NOT NULL OR P.AssociatedClinicianId IS NOT NULL OR CL.RenderingProviderId IS NOT NULL) 
			AND (
				BM.ProcedureCodeId IS NOT NULL
				OR BC.ProcedureCodeId IS NOT NULL
				)
			AND (S.ProgramId IS NOT NULL)
			
			and 3 <> case when Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
	                                                        and BM.ProcedureCodeId is not null
															then BM.ProcedureCodeId   
														else  
														  case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														else
														case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BM.ProcedureCodeId is  null
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														else
														3
														 end end end 
	END


	---Insert claimlineid's for which service is created into temp mapping table.
	IF EXISTS (
			SELECT *
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CMToInsertToClaimLineIdForMappingTable]')
				AND type IN (
					N'P'
					,N'PC'
					)
			)
	BEGIN
		INSERT INTO #ClaimLineIdForMapping(ClaimLineId)		-- Added 21 apr 2016 rajesh
		EXEC scsp_CMToInsertToClaimLineIdForMappingTable @ClinicianId
	END
	ELSE
	BEGIN
		INSERT INTO #ClaimLineIdForMapping (ClaimLineId)
		SELECT Cl.ClaimLineId
		FROM Claims C
		JOIN ClaimLines CL ON C.ClaimId = CL.ClaimId
			AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
		JOIN #ClaimLines CT ON Cl.ClaimLineId = CT.ClaimLineId
			AND ISNULL(cl.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN BillingCodes BC ON Cl.BillingCodeId = BC.BillingCodeId
			AND ISNULL(BC.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN BillingCodeModifiers BM ON BM.BillingCodeId = Cl.BillingCodeId
			AND ISNULL(BM.RecordDeleted, 'N') <> 'Y' -- 05.Apr.2016     Gautam 
		LEFT JOIN Sites S ON S.SiteId = C.SiteId
		WHERE @ClinicianId IS NOT NULL
			AND (
				BM.ProcedureCodeId IS NOT NULL
				OR BC.ProcedureCodeId IS NOT NULL
				)
			AND (S.ProgramId IS NOT NULL)
	END

	---Insert into Mapping table 'ClaimLineServiceMappings' ------
	INSERT INTO ClaimLineServiceMappings (
		ClaimLineId
		,ServiceId
		,CreatedBy
		,CreatedDate
		,RecordDeleted
		)
		SELECT NS.ClaimLineId
		,NS.ServiceId
		,@CreatedBy
		,GETDATE()
		,'N'
	FROM #NewlyAddedServices NS
	
	--SELECT CM.ClaimLineId
	--	,NS.ServiceId
	--	,@CreatedBy
	--	,GETDATE()
	--	,'N'
	--FROM #NewlyAddedServices NS
	--JOIN #ClaimLineIdForMapping CM ON CM.ID = NS.ID
	
	-- Assigning DeletedBy as Null
	UPDATE S SET S.DeletedBy = NULL
	FROM
	Services S JOIN #NewlyAddedServices NS ON S.ServiceId = NS.ServiceId

	---Logic to insert to ServiceDiagnosis table for Claimlines.D1,Claimlines.D2 and Claimlines.D3 for CEI-----
	IF EXISTS (
			SELECT *
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CMCreateServiceDiagnosisFromClaims]')
				AND type IN (
					N'P'
					,N'PC'
					)
			)
	BEGIN
		EXEC scsp_CMCreateServiceDiagnosisFromClaims @CreatedBy
			,@ClinicianId
	END

	--------------To update Claim Service errors table.If a service is created from claims--------------
	DELETE
	FROM ServiceClaimErrors
	WHERE ClaimLineID IN (
			SELECT Cl.ClaimLineId
			FROM ServiceClaimErrors CL
			JOIN ClaimLineServiceMappings CM ON CM.ClaimLineId = Cl.ClaimLineId
				AND ISNULL(CM.RecordDeleted, 'N') <> 'Y'
				AND ISNULL(CL.RecordDeleted, 'N') <> 'Y'
			)

	-------Deleted the claimlineid's from temp table which has errors in creating services.
	DELETE
	FROM #ClaimLines
	WHERE ClaimLineID IN (
			SELECT Cl.ClaimLineId
			FROM #ClaimLines CL
			JOIN ClaimLineServiceMappings CM ON CM.ClaimLineId = Cl.ClaimLineId
			)

	--Soft delete ServiceClaimErrors before inserting to avoid old warnings getting displayed.
	UPDATE SR
	SET SR.RecordDeleted = 'Y'
	FROM ServiceClaimErrors SR
	INNER JOIN #ClaimLines Cl ON Cl.ClaimLineId = SR.ClaimLineId

	---------To insert into ClaimLine Service errors table if anything missing while creating services from claim lines.
	--To check if clinicianid is null and insert into ServiceClaimErrors
	--Custom logic to insert into ServiceErrors for Clinician null CEI client.
	IF EXISTS (
			SELECT *
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CMToInsertToServiceClaimErrorsTable]')
				AND type IN (
					N'P'
					,N'PC'
					)
			)
	BEGIN
		EXEC scsp_CMToInsertToServiceClaimErrorsTable @CreatedBy
			,@ClinicianId
	END
	ELSE
	BEGIN
		INSERT INTO ServiceClaimErrors (
			CreatedBy
			,CreatedDate
			,RecordDeleted
			,ClaimLineId
			,ServiceCreationError
			)
		SELECT @CreatedBy
			,GETDATE()
			,'N'
			,CT.ClaimLineId
			,'Clinician is missing.Please update the default ClinicianID in systemconfiguration key.'
		FROM #ClaimLines CT
		JOIN ClaimLines CL ON CL.ClaimLineId = CT.ClaimLineId
			AND ISNULL(CL.RecordDeleted, 'N') <> 'Y'
		WHERE @ClinicianId IS NULL
	END

	---To check for Procedure Code missing and insert into ServiceClaimErrors
	INSERT INTO ServiceClaimErrors (
		CreatedBy
		,CreatedDate
		,RecordDeleted
		,ClaimLineId
		,ServiceCreationError
		)
	SELECT @CreatedBy
		,GETDATE()
		,'N'
		,CT.ClaimLineId
		,case when  Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
	                                                        and BM.ProcedureCodeId is null
	                                                        and BC.ProcedureCodeId is null
															then 'Procedure Code is missing.'   
														else  
														  case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BC.ProcedureCodeId is null
														then 'Procedure Code is missing.'
														 end end
	FROM #ClaimLines CT
	JOIN ClaimLines CL ON CL.ClaimLineId = CT.ClaimLineId
		AND ISNULL(CL.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN BillingCodes BC ON CL.BillingCodeId = BC.BillingCodeId
		AND ISNULL(BC.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN BillingCodeModifiers BM ON BM.BillingCodeId = CL.BillingCodeId
		AND ISNULL(BM.RecordDeleted, 'N') <> 'Y'-- 05.Apr.2016     Gautam 
		left join ProcedureCodes PC on PC.ProcedureCodeId = case when Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
	                                                        and BM.ProcedureCodeId is not null
															then BM.ProcedureCodeId   
														else  
														  case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														else
														case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BM.ProcedureCodeId is  null
															and BC.ProcedureCodeId is not null
														then BC.ProcedureCodeId 
														 end end end
	where 
	   3      <>                                  case when  Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) = Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) = Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) = Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) = Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
	                                                        and BM.ProcedureCodeId is null
	                                                        and BC.ProcedureCodeId is null
															then 1  
														else  
														  case when   
														    Ltrim(Rtrim(Isnull(Cl.Modifier1,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier1,''))) 
															and Ltrim(Rtrim(Isnull(Cl.Modifier2,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier2,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier3,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier3,'')))
															and Ltrim(Rtrim(Isnull(Cl.Modifier4,''))) <> Ltrim(Rtrim(Isnull(BM.Modifier4,'')))
															and BC.ProcedureCodeId is null
														then 2
														else
														     3
														 end end													 

	---To check for ProgramId missing and insert into ServiceClaimErrors
	INSERT INTO ServiceClaimErrors (
		CreatedBy
		,CreatedDate
		,RecordDeleted
		,ClaimLineId
		,ServiceCreationError
		)
	SELECT @CreatedBy
		,GETDATE()
		,'N'
		,CT.ClaimLineId
		,'Program is missing.'
	FROM Claims C
	JOIN ClaimLines CL ON C.ClaimId = Cl.ClaimId
		AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
	JOIN #ClaimLines CT ON CL.ClaimLineId = CT.ClaimLineId
		AND ISNULL(CL.RecordDeleted, 'N') <> 'Y'
	JOIN Sites S ON S.SiteId = C.SiteId
	WHERE S.ProgramId IS NULL
	
	---To check for Starttime and endtime missing and insert into ServiceClaimErrors  
	 INSERT INTO ServiceClaimErrors (  
	  CreatedBy  
	  ,CreatedDate  
	  ,RecordDeleted  
	  ,ClaimLineId  
	  ,ServiceCreationError  
	  )  
	 SELECT @CreatedBy  
	  ,GETDATE()  
	  ,'N'  
	  ,CT.ClaimLineId  
	  ,'Start time and End time missing.'  
	 FROM Claims C  
	 JOIN ClaimLines CL ON C.ClaimId = Cl.ClaimId  
	  AND ISNULL(C.RecordDeleted, 'N') <> 'Y'  
	 JOIN #ClaimLines CT ON CL.ClaimLineId = CT.ClaimLineId  
	  AND ISNULL(CL.RecordDeleted, 'N') <> 'Y'  
	 WHERE CASE WHEN CL.StartTime IS NULL THEN CL.FromDate ELSE CL.StartTime END IS NULL
		   AND CASE WHEN CL.EndTime IS NULL THEN CL.ToDate ELSE CL.EndTime END IS NULL
		   
	-- To Check for Service Location
	INSERT INTO ServiceClaimErrors (  
	  CreatedBy  
	  ,CreatedDate  
	  ,RecordDeleted  
	  ,ClaimLineId  
	  ,ServiceCreationError  
	  )  
	 SELECT @CreatedBy  
	  ,GETDATE()  
	  ,'N'  
	  ,CT.ClaimLineId  
	  ,'Place of Service is not mapped to any default Location.'  
	 FROM Claims C  
	 JOIN ClaimLines CL ON C.ClaimId = Cl.ClaimId  
	  AND ISNULL(C.RecordDeleted, 'N') <> 'Y'  
	 JOIN #ClaimLines CT ON CL.ClaimLineId = CT.ClaimLineId  
	  AND ISNULL(CL.RecordDeleted, 'N') <> 'Y' 
	 left join GlobalCodes G1 on CL.PlaceOfService  = G1.GlobalCodeId and G1.Category	 ='PCMPLACEOFSERVICE'  and ISNULL(G1.RecordDeleted,'N') <> 'Y'
	 left join GlobalCodes G2 on G1.ExternalCode1  = G2.ExternalCode1 and G2.Category = 'PLACEOFSERVICE' and ISNULL(G2.RecordDeleted,'N') <> 'Y'
	 left join Locations L on L.PlaceOfService = G2.GlobalCodeId and L.DefaultLocationForServiceCreationFromClaims = 'Y' and ISNULL(L.RecordDeleted,'N') <> 'Y'	  	 
	 WHERE L.LocationId is null 
		   
	SELECT 'Success'
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_CMCreateServicesFromClaims]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	--set @result=0                                                    
	RAISERROR (
			@Error
			,-- Message text.                                  
			16
			,-- Severity.                                  
			1 -- State.                                  
			);
END CATCH


GO


