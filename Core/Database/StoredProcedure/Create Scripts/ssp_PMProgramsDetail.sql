IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	OBJECT_ID = OBJECT_ID(N'[ssp_PMProgramsDetail]')
					AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 ) 
	DROP PROCEDURE [dbo].[ssp_PMProgramsDetail]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_PMProgramsDetail] @ProgramId INT
AS 
	BEGIN
/********************************************************************************                                                  
* Stored Procedure: ssp_PMProgramsDetail
*
* Copyright: Streamline Healthcate Solutions
*
* Purpose: Procedure to return data for the program details page.
*
* Author:  Girish Sanaba
* Date:    19 May 2011
*
*	Modified Date	Modified By		Modifications
*	08/24/2011		Girish			Removed References to Rowidentifier and/or ExternalReferenceId
*   08/27/2011		Girish			Readded References to Rowidentifier 
*   10/07/2011		Priyanka		Added select record from ProgramAvailabilityHistory   
*	12/09/2011		MSuma			Added  check for Client RecordDeleted in count
*   04/09/2012		Amit Kumar Srivastava		Added  CanNotBePrimaryAssignment Column, #15, Admin Program, Team Admin Details,(Development Phase III (Offshore))
*   09/13/2013		Jagan			Added 3 new Columns   
*	12/26/2013		Katta Sharath Kumar			Added New Column FacilityType With Ref To Task#139-Phillaven Development
*	07/14/2014		Akwinass        Added New Column AutomaticAttendanceForBedAssignment With Ref To Task#1537-Core Bugs
*	09/26/2014		Akwinass        Added New Column BedAdmissionRequiresOrder,BedDischargeRequiresOrder With Ref To Task#1205 - Philhaven - Customization Issues Tracking  
*	10/09/2014		Akwinass        Added New Column UseProblemListForDiagnosis,UseDiagnosisDocument,DiagnosisDocumentCategoryAll With Ref To Task#1419 - Engineering Improvement Initiatives- NBL(I) 
*	12/12/2014		Varun           Added New Column PrimaryCareProgram Ref To Task#172 - Primary Care - Summit Pointe 
*	03/22/2015		Vaibhav Khare	Added Three new column Programs table for Key Point - Customizations #321 
*	07/07/2015		Dhanil Manuel   ProgramStaff select logic changed : select Display as and added recoreddeleted condition task #1348 
*	09/13/2016		Nandita			Added mobile column to Programs table
*	02/23/2017		jcarlson		Keystone Customizations 55 - Added Start and End date to programprocedures table
*	03/17/2017		Akwinass		Pulling procedure codes where allow all program is selected (Task #96 MHP-Environment Issues) 
*	04/20/2017		jcarlson		Keystone Customizations 55 - Updated logic when setting ProgramProcedureId, incase no program procedure records exist
*	02/08/2017		Chethan N		What : Added new column 'SNOMEDCTCode' to Programs table.
									Why : Meaningful Use - Stage 3 task #70.
*	05/21/2018		Akwinass        Added New Column CreateServiceForDischargeDate to Programs table With Ref To Task#632-Comprehensive-Customizations		
*	07/09/2018		Neha            Added a new column TaxId to Programs table with Ref to #664 Engineering Improvement Initiatives- NBL(I)							
*********************************************************************************/


		BEGIN TRY
	
	--Programs by ProgramID    
			SELECT	P.[ProgramId],
					P.[CreatedBy],
					P.[CreatedDate],
					P.[ModifiedBy],
					P.[ModifiedDate],
					P.[RecordDeleted],
					P.[DeletedDate],
					P.[DeletedBy],
					P.[ProgramCode],
					P.[ProgramName],
					P.[Active],
					P.[ProgramType],
					P.[IntakePhone],
					P.[IntakePhoneText],
					P.[ProgramManager],
					P.[Capacity],
					P.[Comment],
					P.[Address],
					P.[City],
					P.[State],
					P.[ZipCode],
					P.[AddressDisplay],
					P.[NationalProviderId],
					P.[InpatientProgram],
					P.[ServiceAreaId],
					p.[ResidentialProgram],
					p.[AfterSchoolProgram],
					p.[ShowInWhiteBoard],
					p.[FacilityType],
					--14 July 2014  Akwinass
					p.[AutomaticAttendanceForBedAssignment],
					--26 SEP 2014  Akwinass
					p.[BedAdmissionRequiresOrder],
					p.[BedDischargeRequiresOrder],
					--09 OCT 2014  Akwinass
					p.[UseProblemListForDiagnosis],
					p.[UseDiagnosisDocument],
					p.[DiagnosisDocumentCategoryAll],
					( SELECT	COUNT(CP.ProgramID)
					  FROM		ClientPrograms CP
								JOIN Clients C ON C.ClientId = Cp.ClientId
												  AND ISNULL(c.RecordDeleted,
															 'N') = 'N'
					  WHERE		CP.ProgramId = @ProgramId
								AND CP.Status = 4
								AND ( CP.RecordDeleted = 'N'
									  OR CP.RecordDeleted IS NULL
									)
					) AS CurrentlyEnrolled,
					( SELECT	COUNT(CP.ProgramID)
					  FROM		ClientPrograms CP
								JOIN Clients C ON C.ClientId = Cp.ClientId
												  AND ISNULL(c.RecordDeleted,
															 'N') = 'N'
					  WHERE		CP.ProgramId = @ProgramId
								AND CP.Status = 1
								AND ISNULL(CP.RecordDeleted, 'N') = 'N'
					) AS Waiting,
					( SELECT	CodeName
					  FROM		GlobalCodes
					  WHERE		GlobalCodeId = ProgramType
					) AS [Type],
					S.LastName + ', ' + S.FirstName AS [Program Manager],
					P.[CanNotBePrimaryAssignment],
					P.[CustomField],
					P.[PrimaryCareProgram],
					P.MARClientOrderMedication,
					P.MARPrescribedMedication,
					P.MARNonOrderedMedication,
					P.TreatmentPlanCatalogId,
					P.Mobile,
					P.CreateServiceForDischargeDate, --05/21/2018		Akwinass
					p.TaxId,
					P.CQMCode,
					p.CQMCodeType
			FROM	Programs P
					LEFT JOIN Staff S ON P.ProgramManager = S.StaffId
			WHERE	ProgramId = @ProgramId      
	    
	     
			DECLARE @ProgramProcedureId INT
			SELECT @ProgramProcedureId = (MAX(ProcedureCodeId) + 10000) FROM ProgramProcedures
	     
	--ProgramProcedures by ProgramID
			
			SELECT	CAST(PP.ProcedureCodeId AS VARCHAR(8)) + ' - '
					+ PC.DisplayAs AS ProcedureCodeName,					
					PP.[ProgramProcedureId],
					PP.[ProgramId],
					PP.[ProcedureCodeId],
					PP.[RowIdentifier],
					PP.[CreatedBy],
					PP.[CreatedDate],
					PP.[ModifiedBy],
					PP.[ModifiedDate],
					PP.[RecordDeleted],
					PP.[DeletedDate],
					PP.[DeletedBy],
					pp.StartDate,
					pp.EndDate,
					-- 03/17/2017   Akwinass
					'N' AS AllowAllPrograms
			FROM	ProgramProcedures PP
					INNER JOIN ProcedureCodes PC ON pp.ProcedureCodeId = PC.ProcedureCodeId
			WHERE	PP.ProgramId = @ProgramId
					AND ISNULL(PC.RecordDeleted, 'N') = 'N' 
					AND ISNULL(pp.RecordDeleted,'N')='N'
					AND ISNULL(PC.AllowAllPrograms,'N') = 'N'
			-- 03/17/2017   Akwinass		
		    UNION
			SELECT CAST(PC.ProcedureCodeId AS VARCHAR(8)) + ' - '
					+ PC.DisplayAs AS ProcedureCodeName				
				,CAST((ISNULL(@ProgramProcedureId,99999999) + (ROW_NUMBER() OVER (ORDER BY PC.ProcedureCodeId))) AS INT) AS [ProgramProcedureId]
				,@ProgramId AS [ProgramId]
				,PC.ProcedureCodeId AS [ProcedureCodeId]
				,NULL AS [RowIdentifier]
				,SYSTEM_USER AS [CreatedBy]
				,GETDATE() AS [CreatedDate]
				,SYSTEM_USER AS [ModifiedBy]
				,GETDATE() AS [ModifiedDate]
				,NULL AS [RecordDeleted]
				,NULL AS [DeletedDate]
				,NULL AS [DeletedBy]
				,NULL AS StartDate
				,NULL AS EndDate
				,'Y' AS AllowAllPrograms
			FROM ProcedureCodes PC
			WHERE ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND ISNULL(PC.AllowAllPrograms,'N') = 'Y'		

			
	--AND    
	-- PC.Active='Y'      
	     
	--ProgramPlans by ProgramID     
			SELECT	CP.DisplayAs AS PlanName,
					PP.[ProgramPlanId],
					PP.[ProgramId],
					PP.[CoveragePlanId],
					PP.[RowIdentifier],
					PP.[CreatedBy],
					PP.[CreatedDate],
					PP.[ModifiedBy],
					PP.[ModifiedDate],
					PP.[RecordDeleted],
					PP.[DeletedDate],
					PP.[DeletedBy]
			FROM	ProgramPlans PP
					INNER JOIN CoveragePlans CP ON PP.CoveragePlanId = CP.CoveragePlanId
			WHERE	ProgramId = @ProgramId
					AND ( ISNULL(PP.RecordDeleted, 'N') = 'N' )
					AND ( ISNULL(CP.RecordDeleted, 'N') = 'N' )    
	--AND    
	-- CP.Active='Y'      
	    
	 
	--ProgramLocations by ProgramID    
			SELECT	L.LocationCode AS LocationName,
					PL.[ProgramLocationId],
					PL.[ProgramId],
					PL.[LocationId],
					PL.[RowIdentifier],
					PL.[CreatedBy],
					PL.[CreatedDate],
					PL.[ModifiedBy],
					PL.[ModifiedDate],
					PL.[RecordDeleted],
					PL.[DeletedDate],
					PL.[DeletedBy],
					L.LocationName
			FROM	ProgramLocations PL
					INNER JOIN Locations L ON PL.LocationId = L.LocationId
			WHERE	ProgramId = @ProgramId
					AND ( ISNULL(PL.RecordDeleted, 'N') = 'N' )
					AND ( ISNULL(L.RecordDeleted, 'N') = 'N' )    
	--AND    
	-- L.Active='Y'     

	--ProgramStaff    
			SELECT	S.StaffId,
					S.DisplayAs AS StaffName,
					CASE WHEN S.PrimaryProgramId = @ProgramId THEN 'Yes'
						 ELSE 'No'
					END AS [Primary]
			FROM	Staff S
					INNER JOIN StaffPrograms SP ON S.StaffId = SP.StaffId
			WHERE	S.Active = 'Y'
					AND ( S.RecordDeleted = 'N'
						  OR S.RecordDeleted IS NULL
						)
					and ISNULL(SP.RecordDeleted,'N') <> 'Y'
					AND SP.ProgramId = @ProgramId
			ORDER BY StaffName 
	
	 
 --ProgramAvailabilityHistory
			SELECT	PH.ProgramAvailabilityHistoryId,
					PH.[CreatedBy],
					PH.[CreatedDate],
					PH.[ModifiedBy],
					PH.[ModifiedDate],
					PH.[RecordDeleted],
					PH.[DeletedDate],
					PH.[DeletedBy],
					PH.ProgramId,
					PH.StartDate,
					PH.EndDate
			FROM	ProgramAvailabilityHistory PH
			WHERE	ProgramId = @ProgramId

-- ProgramDailyOccupancyRules
			SELECT	ProgramDailyOccupancyRuleId,
					CreatedBy,
					CreatedDate,
					ModifiedBy,
					ModifiedDate,
					RecordDeleted,
					DeletedBy,
					DeletedDate,
					ProgramId,
					EffectiveFrom,
					EffectiveTo,
					DailyOccupancy,
					Monday,
					Tuesday,
					Wednesday,
					Thursday,
					Friday,
					Saturday,
					Sunday,
					SUBSTRING(CASE Monday
								WHEN 'Y' THEN 'M,'
								ELSE ''
							  END + CASE Tuesday
									  WHEN 'Y' THEN 'T,'
									  ELSE ''
									END + CASE Wednesday
											WHEN 'Y' THEN 'W,'
											ELSE ''
										  END + CASE Thursday
												  WHEN 'Y' THEN 'Th,'
												  ELSE ''
												END + CASE Friday
														WHEN 'Y' THEN 'F,'
														ELSE ''
													  END
							  + CASE Saturday
								  WHEN 'Y' THEN 'S,'
								  ELSE ''
								END + CASE Sunday
										WHEN 'Y' THEN 'Su,'
										ELSE ''
									  END, 1,
							  CASE WHEN SIGN(LEN(CASE Monday
												   WHEN 'Y' THEN 'M,'
												   ELSE ''
												 END + CASE Tuesday
														 WHEN 'Y' THEN 'T,'
														 ELSE ''
													   END
												 + CASE Wednesday
													 WHEN 'Y' THEN 'W,'
													 ELSE ''
												   END + CASE Thursday
														   WHEN 'Y' THEN 'Th,'
														   ELSE ''
														 END
												 + CASE Friday
													 WHEN 'Y' THEN 'F,'
													 ELSE ''
												   END + CASE Saturday
														   WHEN 'Y' THEN 'S,'
														   ELSE ''
														 END
												 + CASE Sunday
													 WHEN 'Y' THEN 'Su,'
													 ELSE ''
												   END) - 1) = -1 THEN 0
								   ELSE LEN(CASE Monday
											  WHEN 'Y' THEN 'M,'
											  ELSE ''
											END + CASE Tuesday
													WHEN 'Y' THEN 'T,'
													ELSE ''
												  END + CASE Wednesday
														  WHEN 'Y' THEN 'W,'
														  ELSE ''
														END
											+ CASE Thursday
												WHEN 'Y' THEN 'Th,'
												ELSE ''
											  END + CASE Friday
													  WHEN 'Y' THEN 'F,'
													  ELSE ''
													END + CASE Saturday
															WHEN 'Y' THEN 'S,'
															ELSE ''
														  END
											+ CASE Sunday
												WHEN 'Y' THEN 'Su,'
												ELSE ''
											  END) - 1
							  END) AS WeekDays
			FROM	dbo.ProgramDailyOccupancyRules AS por
			WHERE	ProgramId = @ProgramId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			ORDER BY EffectiveFrom,
					EffectiveTo
					
			SELECT PDC.ProgramDiagnosisCategoryId
				,PDC.CreatedBy
				,PDC.CreatedDate
				,PDC.ModifiedBy
				,PDC.ModifiedDate
				,PDC.RecordDeleted
				,PDC.DeletedDate
				,PDC.DeletedBy
				,PDC.ProgramId
				,PDC.DiagnosisCategory
				,GC.CodeName AS DiagnosisCategoryName
			FROM ProgramDiagnosisCategories PDC
			LEFT JOIN GlobalCodes GC ON PDC.DiagnosisCategory = GC.GlobalCodeId
				AND ISNULL(PDC.RecordDeleted, 'N') = 'N'
			WHERE ProgramId = @ProgramId
			
			Select TreatmentPlanCatalogId,
					CreatedBy,
					CreatedDate,
					ModifiedBy,
					ModifiedDate,
					RecordDeleted,
					DeletedBy,
					DeletedDate,
					CatalogName,
					Priority 
			from TreatmentPlanCatalogs
	
	   
		END TRY
              
		BEGIN CATCH
			DECLARE @Error VARCHAR(8000)

			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMProgramsDetail') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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