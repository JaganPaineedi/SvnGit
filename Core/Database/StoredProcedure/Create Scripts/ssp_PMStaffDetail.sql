IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMStaffDetail]')
			AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
		)
	DROP PROCEDURE [dbo].[ssp_PMStaffDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMStaffDetail] @StaffId INT
AS
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMStaffDetail
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return data for the staff details page.
--
-- Author:  Girish Sanaba
-- Date:    12 May 2011
--
-- *****History****
-- 24 Aug 2011 Girish Removed References to Rowidentifier and/or ExternalReferenceId
-- 26 Aug 2011 Girish Commented Resultsets:StaffViews, ProgramViews, MultiStaffViews, MultiProgramViews
-- 19 Jan 2012 MSuma  UnCommented Resultsets:ProgramViews, MultiProgramViews

--19 Jan 2012 Shruthi.S added rowidentifier and modifiedby column 
--21 June 2012 PSelvan  For Ace Harbor Go Live Issues #1608
--9/Nov/2012	Mamta Gupta		Isnull Check is missing on FirstName, LastName and GlobalCode.CodeName. 
								Due to Isnull check missing error is occuring and staff name is null.
								Task No. 251, 3.x Issues
								4/Dec/2012Merged by sanjayb with respect to task#39 in Newaygo Implementation Task
-- 16 Dec 2013  Manju P   Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes     
--10-Sept 2014 Merging this SSP from 3.5x to 4.0x      

--17-Sept 2014 Task #53 CM to SC Project Added Providers and Insurers for which is associated with Staff    
-- 03/09/2015	NJain	  Added Distinct when getting data from StaffQuickActions   
-- 23 Mar 2015	Avi Goyal		What : Added StaffContractedRates
								Why :  Task # 1 Timesheet Functionality ; Project :  The ARC - Customizations                       
-- 07 Apr 2015	Avi Goyal		What : Added Priority to StaffContractedRates
								Why :  Task # 1 Timesheet Functionality ; Project :  The ARC - Customizations
-- 05 May 2016	Vithobha		Added PrescriberProxies table at the end  for EPCS: #5, Because respective changes are made in Proc/Prog/Locations/Proxy tab								
-- 01 Aug 2016	Vithobha		Added StateFIPS & PrimaryValue in StaffLicenseDegrees table, EPCS #6
 --03 OCT 2016   Pavani          Added StaffPrefernences table , Mobile Task#2  
 --11/04/2016   Rajesh S	    Added AdjustmentDate Column in the select statement of StaffTimeSheetAdjustments		
 --12/12/2016   Arjun K R       Added TreatmentTeamRole Column in the select statement of StaffPreferences.Task #447 AspenPointe Customizations.
 --20/01/2017    Basudev        What : Modified not to show up rendering provider by default
                                Why :  for CEI SGL   #364 AspenPointe Customizations.
-- 03/04/2017    jcarlson		Engineering Improvement Initiatives 493- New field: StreamlineStaff -- StaffPreferences table
-- 23/04/2017    sbhowmik		Network180 Support Go Live# 191 and 216
-- 16/11/2017	Suneel N		Added NotifyMeOfMyServices Column in the select statement of StaffPreferences.Task #1262 Harbor Enhancements.
-- 14/04/2018 Chita Ranjan Added select statement to get all details for Highly Qualified Teachers (Newly added tab). Task: PEP - Customizations #10005   
-- 10/07/2018   Swatika         Added select statement to get all Units. Task: Bradford - Enhancements #400.2 
-- 23/07/2018  Chita Ranjan     What: Changed SubCodeName to CodeName for CourseGroup column. Why: PEP - Customizations #10198

--16 Aug 2018 Vishnu Narayanan  What :Added StaffNotificationSubscriptions Table and added few columns to StaffPreferences Table 
                                Why: Mobile-Task#6  
--21 Sep 2018 Vishnu Narayanan  What :Added MobileDeviceRegistrationId and RegisteredForMobileNotificationsTimeStamp to StaffPrefernces
                                Why : Mobile - #6    
--10 Oct 2018 Vishnu Narayanan  Removed MobileDeviceRegistrationId,SubscribedForPushNotifications,SubscribedForSMSNotifications,SubscribedForEmailNotifications and
                                Added RegisteredForSMSNotifications and RegisteredForEmailNotifications to StaffPreferences for Mobile#6	
--15/Oct/2018 Swatika		    What/Why : Added new column namely "AlwaysDefaultCosigner" in "StaffPreferences" table as part of Renaissance - Dev Items Tasks #695	
--03/Dec/2018 Vishnu Narayanan  What/Why : Removed StaffNotificationSubscriptions Table for Mobile-#6.
                                						                            								  
*********************************************************************************/
BEGIN
	BEGIN TRY
	
		--Roles/Permissions
		EXEC ssp_SCGetRolePermissions @StaffId

		--Race Category
		SELECT SR.StaffRaceId
			,SR.StaffId
			,SR.RaceId
			,SR.RowIdentifier
			,SR.CreatedBy
			,SR.CreatedDate
			,SR.ModifiedBy
			,SR.ModifiedDate
			,SR.RecordDeleted
			,SR.DeletedDate
			,SR.DeletedBy
			,GlobalCodeId
			,CodeName
		FROM GlobalCodes AS GC
		INNER JOIN StaffRaces AS SR ON GC.GlobalcodeId = SR.RaceId
		WHERE ISNULL(SR.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			--AND
			-- GC.Active='Y'
			AND SR.StaffId = @StaffId
		ORDER BY CodeName

		--Language Category
		SELECT SL.StaffLanguageId
			,SL.StaffId
			,SL.LanguageId
			,SL.RowIdentifier
			,SL.CreatedBy
			,SL.CreatedDate
			,SL.ModifiedBy
			,SL.ModifiedDate
			,SL.RecordDeleted
			,SL.DeletedDate
			,SL.DeletedBy
			,GlobalCodeId
			,CodeName
		FROM GlobalCodes AS GC
		INNER JOIN StaffLanguages AS SL ON GC.GlobalcodeId = SL.LanguageId
		WHERE ISNULL(SL.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			--AND
			-- GC.Active='Y'
			AND SL.StaffId = @StaffId
		ORDER BY CodeName

		--StaffProcedures                                          
		SELECT convert(VARCHAR, SP.ProcedureCodeId) + ' - ' + PC.DisplayAs AS ProcedureName
			,SP.StaffProcedureId
			,SP.StaffId
			,SP.ProcedureCodeId
			,SP.RowIdentifier
			,SP.CreatedBy
			,SP.CreatedDate
			,SP.ModifiedBy
			,SP.ModifiedDate
			,SP.RecordDeleted
			,SP.DeletedDate
			,SP.DeletedBy
		FROM StaffProcedures SP
		INNER JOIN ProcedureCodes PC ON SP.ProcedureCodeId = PC.ProcedureCodeId
		WHERE SP.StaffID = @StaffID
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		ORDER BY ProcedureName

		--StaffPrograms                                            
		SELECT P.ProgramCode AS ProgramName
			,SP.StaffProgramId
			,SP.StaffId
			,SP.ProgramId
			,SP.RowIdentifier
			,SP.CreatedBy
			,SP.CreatedDate
			,SP.ModifiedBy
			,SP.ModifiedDate
			,SP.RecordDeleted
			,SP.DeletedDate
			,SP.DeletedBy
			,CASE (
					SELECT PrimaryProgramId
					FROM Staff
					WHERE StaffId = @StaffId
					)
				WHEN SP.ProgramId
					THEN 'True'
				ELSE 'False'
				END AS IsPrimaryProgram
		FROM StaffPrograms SP
		INNER JOIN Programs P ON SP.ProgramId = P.ProgramId
		WHERE SP.StaffID = @StaffID
			AND P.Active = 'Y'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
		ORDER BY ProgramName

		--StaffLocations                                          
		SELECT L.LocationCode AS LocationName
			,SL.StaffLocationsId
			,SL.StaffId
			,SL.LocationId
			,SL.PrescriptionPrinterLocationId
			,SL.ChartCopyPrinterDeviceLocationId
			,SL.RowIdentifier
			,SL.CreatedBy
			,SL.CreatedDate
			,SL.ModifiedBy
			,SL.ModifiedDate
			,SL.RecordDeleted
			,SL.DeletedDate
			,SL.DeletedBy
		FROM StaffLocations SL
		INNER JOIN Locations L ON SL.LocationId = L.LocationId
		WHERE SL.StaffID = @StaffID
			AND ISNULL(L.RecordDeleted, 'N') = 'N'
		ORDER BY LocationName

		--StaffProxy                                          
		SELECT CASE 
				--Task#251 Merged by sanjayb                                    
				--WHEN S.Degree IS NULL THEN S.LastName+ ', ' + S.FirstName                                          
				--ELSE S.LastName+ ', ' + S.FirstName + ' ' + GC.CodeNaME 
				WHEN S.Degree IS NULL
					THEN isnull(S.DisplayAs, '') --isnull(S.LastName,'')+ ', ' + isnull(S.FirstName,'')  
				ELSE isnull(S.DisplayAs, '') + ' ' + isnull(GC.CodeName, '') --isnull(S.LastName,'')+ ', ' + isnull(S.FirstName,'') + ' ' + isnull(GC.CodeName,'')   
					--Task#251 
				END AS StaffName
			,SP.StaffProxyId
			,SP.StaffId
			,SP.ProxyForStaffId
			,SP.RowIdentifier
			,SP.CreatedBy
			,SP.CreatedDate
			,SP.ModifiedBy
			,SP.ModifiedDate
			,SP.RecordDeleted
			,SP.DeletedDate
			,SP.DeletedBy
		FROM StaffProxies SP
		INNER JOIN Staff S ON S.StaffId = SP.ProxyForStaffId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.Degree
		WHERE SP.StaffID = @StaffID
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(SP.RecordDeleted, 'N') = 'N'
		ORDER BY StaffName

		--Productivity                         
		--Staff Salaries                                          
		SELECT GC.CodeName AS EmploymentTypeText
			,SS.StaffSalaryId
			,SS.StaffId
			,SS.StartDate
			,SS.EndDate
			,SS.Salary
			,SS.SalaryRate
			,SS.EmploymentType
			,SS.RowIdentifier
			,SS.CreatedBy
			,SS.CreatedDate
			,SS.ModifiedBy
			,SS.ModifiedDate
			,SS.RecordDeleted
			,SS.DeletedDate
			,SS.DeletedBy
		FROM StaffSalaries SS
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = SS.EmploymentType
		WHERE StaffId = @StaffID
			AND ISNULL(SS.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'

		--Staff Costs                                          
		SELECT StaffCostId
			,StaffId
			,CostYear
			,CostMonth
			,Cost
			,UseForward
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,CASE CAST(CostMonth AS VARCHAR)
				WHEN '10'
					THEN CAST(CostMonth AS VARCHAR) + '/' + CAST(CostYear AS VARCHAR(4))
				WHEN '11'
					THEN CAST(CostMonth AS VARCHAR) + '/' + CAST(CostYear AS VARCHAR(4))
				WHEN '12'
					THEN CAST(CostMonth AS VARCHAR) + '/' + CAST(CostYear AS VARCHAR(4))
				ELSE '0' + CAST(CostMonth AS VARCHAR) + '/' + CAST(CostYear AS VARCHAR(4))
				END AS MonthYear
		FROM StaffCosts
		WHERE StaffId = @StaffID
			AND ISNULL(RecordDeleted, 'N') = 'N'

		--StaffTargets                                          
		SELECT StaffTargetId
			,StaffId
			,TargetYear
			,TargetMonth
			,ProcedureCodeGroupName
			,UnitsOfService
			,Charges
			,PercentageOfCost
			,HoursOfDirectContact
			,Payments
			,UseForward
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,CASE CAST(TargetMonth AS VARCHAR)
				WHEN '10'
					THEN CAST(TargetMonth AS VARCHAR) + '/' + CAST(TargetYear AS VARCHAR(4))
				WHEN '11'
					THEN CAST(TargetMonth AS VARCHAR) + '/' + CAST(TargetYear AS VARCHAR(4))
				WHEN '12'
					THEN CAST(TargetMonth AS VARCHAR) + '/' + CAST(TargetYear AS VARCHAR(4))
				ELSE '0' + CAST(TargetMonth AS VARCHAR) + '/' + CAST(TargetYear AS VARCHAR(4))
				END AS MonthYear
		FROM StaffTargets
		WHERE StaffId = @StaffID
			AND RecordDeleted = 'N'
		ORDER BY StaffTargetId

		--StaffTargetProcedureCodes                                          
		SELECT SP.TargetProcedureCodeId
			,SP.StaffTargetId
			,SP.ProcedureCodeId
			,SP.RowIdentifier
			,SP.CreatedBy
			,SP.CreatedDate
			,SP.ModifiedBy
			,SP.ModifiedDate
			,SP.RecordDeleted
			,SP.DeletedDate
			,SP.DeletedBy
		FROM StaffTargetProcedureCodes SP
		INNER JOIN StaffTargets ST ON SP.StaffTargetId = ST.StaffTargetId
		WHERE (
				SP.RecordDeleted = 'N'
				OR SP.RecordDeleted IS NULL
				)
			AND (
				ST.RecordDeleted = 'N'
				OR ST.RecordDeleted IS NULL
				)
			AND ST.StaffId = @StaffID

		--Quick Action Order
		SELECT DISTINCT T.DisplayAs + ' - ' + S.ScreenName AS BannerScreen
			,SQ.StaffQuickActionId
			,SQ.StaffId
			,SQ.ScreenId
			,SQ.SortOrder
			--,SQ.RowIdentifier
			,SQ.CreatedBy
			,SQ.CreatedDate
			,SQ.ModifiedBy
			,SQ.ModifiedDate
			,SQ.RecordDeleted
			,SQ.DeletedDate
			,SQ.DeletedBy
		FROM StaffQuickActions SQ
		INNER JOIN Screens S ON S.ScreenId = SQ.ScreenId
		INNER JOIN Banners B ON S.ScreenId = B.ScreenId
		INNER JOIN Tabs T ON B.TabId = T.TabId
		WHERE SQ.StaffID = @StaffId
			AND ISNULL(SQ.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(B.RecordDeleted, 'N') = 'N'
			AND ISNULL(T.RecordDeleted, 'N') = 'N'
		ORDER BY SQ.SortOrder
			,BannerScreen

		--Staff Categories
		SELECT gc.CodeName
			,SC.StaffCategoryId
			,SC.CreatedBy
			,SC.CreatedDate
			,SC.ModifiedBy
			,SC.ModifiedDate
			,SC.RecordDeleted
			,SC.DeletedDate
			,SC.DeletedBy
			,SC.StaffId
			,SC.CategoryId
		FROM StaffCategories SC
		INNER JOIN GlobalCodes GC ON SC.CategoryId = GC.GlobalCodeId
		WHERE SC.StaffId = @StaffId
			AND ISNULL(SC.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		ORDER BY GC.CodeName

		--Staff Age Range Prefernces
		SELECT SA.StaffAgePreferenceId
			,SA.CreatedBy
			,SA.CreatedDate
			,SA.ModifiedBy
			,SA.ModifiedDate
			,SA.RecordDeleted
			,SA.DeletedDate
			,SA.DeletedBy
			,SA.StaffId
			,SA.FromAge
			,SA.ToAge
		FROM StaffAgePreferences SA
		WHERE SA.StaffId = @StaffId
			AND ISNULL(SA.RecordDeleted, 'N') = 'N'
		ORDER BY SA.FromAge
			,SA.ToAge

		--Staff Views
		--SELECT [MultiStaffViewId]
		--     ,[UserStaffId]
		--     ,[ViewName]
		--     ,[AllStaff]
		--     ,[CreatedBy]
		--     ,[CreatedDate]
		--     ,[ModifiedBy]
		--     ,[ModifiedDate]
		--     ,[RecordDeleted]
		--     ,[DeletedDate]
		--     ,[DeletedBy], 
		--AllStaff1 =                                    
		--  CASE AllStaff                                    
		-- WHEN 'Y' THEN 'All'                                    
		-- WHEN 'N' THEN 'Some'                                    
		--  END 
		--FROM MultiStaffViews 
		--WHERE UserStaffId=@StaffId                                     
		--AND ISNULL(RecordDeleted,'N') = 'N'
		--ORDER BY ViewName 
		--ProgramView 
		SELECT [ProgramViewId]
			,[UserStaffId]
			,[ViewName]
			,[AllPrograms]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,RowIdentifier
			,AllPrograms1 = CASE AllPrograms
				WHEN 'Y'
					THEN 'All'
				WHEN 'N'
					THEN 'Some'
				END
		FROM ProgramViews
		WHERE UserStaffId = @StaffId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		ORDER BY ViewName

		--Multi Program Views
		SELECT PVP.ProgramViewProgramId
			,PVP.ProgramViewId
			,PVP.ProgramId
			,PVP.RowIdentifier
			,PVP.CreatedBy
			,PVP.CreatedDate
			,PVP.ModifiedBy
			,PVP.ModifiedDate
			,PVP.RecordDeleted
			,PVP.DeletedDate
			,PVP.DeletedBy
			,PV.ViewName
		FROM ProgramViewPrograms PVP
		INNER JOIN ProgramViews PV ON PV.ProgramViewId = PVP.ProgramViewId
			AND PV.UserStaffId = @StaffId
		WHERE (
				PV.RecordDeleted = 'N'
				OR PV.RecordDeleted IS NULL
				)
			AND (
				PVP.RecordDeleted = 'N'
				OR PVP.RecordDeleted IS NULL
				)

		--Multi Staff View                                    
		--SELECT SVS.MultiStaffViewStaffId
		--     ,SVS.MultiStaffViewId
		--     ,SVS.StaffId
		--     --,SVS.RowIdentifier
		--     ,SVS.CreatedBy
		--     ,SVS.CreatedDate
		--     ,SVS.ModifiedBy
		--     ,SVS.ModifiedDate
		--     ,SVS.RecordDeleted
		--     ,SVS.DeletedDate
		--     ,SVS.DeletedBy
		--     ,SV.ViewName
		--FROM MultiStaffViewStaff SVS                                    
		--INNER JOIN                                     
		-- MultiStaffViews SV                                    
		--ON                                     
		-- SV.MultiStaffViewId = SVS.MultiStaffViewId                                    
		--WHERE                                    
		-- (SV.RecordDeleted = 'N' OR SV.RecordDeleted IS NULL)                                    
		--AND                                    
		-- (SVS.RecordDeleted = 'N' OR SVS.RecordDeleted IS NULL)                                    
		--AND      SV. UserStaffId=@StaffId          
		--LicenseDegrees
		SELECT SL.StaffLicenseDegreeId
			,SL.CreatedBy
			,SL.CreatedDate
			,SL.ModifiedBy
			,SL.ModifiedDate
			,SL.RecordDeleted
			,SL.DeletedDate
			,SL.DeletedBy
			,SL.StaffId
			,SL.LicenseTypeDegree
			,SL.LicenseNumber
			,SL.StartDate
			,SL.EndDate
			,SL.Billing
			,SL.Notes
			,CASE SL.Billing
				WHEN 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS BillingText
			,GC.CodeName AS LicenseTypeDegreeText
			-- 01 Aug 2016	Vithobha
			,SL.StateFIPS
			,SL.PrimaryValue
			,S.StateName AS StateFIPSText
			,CASE SL.PrimaryValue
				WHEN 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS PrimaryValueText
		FROM StaffLicenseDegrees SL
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = SL.LicenseTypeDegree
		LEFT JOIN States S ON S.StateAbbreviation = SL.StateFIPS
		WHERE SL.StaffID = @StaffID
			AND ISNULL(SL.RecordDeleted, 'N') = 'N'
			AND GC.Category = 'DEGREE'

		--Credentialing  
		SELECT SC.StaffCredentialingId
			,SC.CreatedBy
			,SC.CreatedDate
			,SC.ModifiedBy
			,SC.ModifiedDate
			,SC.RecordDeleted
			,SC.DeletedDate
			,SC.DeletedBy
			,SC.StaffId
			,SC.PayerOrCoveragePlan
			,SC.PayerId
			,SC.CoveragePlanId
			,SC.CredentialingType
			,SC.CredentialingStatus
			,SC.EffectiveFrom
			,SC.ExpirationDate
			,SC.ApplicationReceivedDate
			,SC.ApplicationSentDate
			,SC.DocumentationCompletedDate
			,SC.ApprovedDate
			,SC.NoticeReceivedDate
			,SC.Notes
			,CASE SC.PayerOrCoveragePlan
				WHEN 'C'
					THEN 'Coverage:' + CP.DisplayAs
				WHEN 'P'
					THEN 'Payor:' + P.PayerName
				END AS PayerOrCoveragePlanText
			,GC1.CodeName AS CredentialingTypeText
			,GC2.CodeName AS CredentialingStatusText
		FROM StaffCredentialing SC
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = SC.CredentialingType
			AND GC1.Category = 'CREDENTIALINGTYPE'
		LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = SC.CredentialingStatus
			AND GC2.Category = 'CREDENTIALINGSTATUS'
		LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = SC.CoveragePlanId
		LEFT JOIN Payers P ON P.PayerId = SC.PayerId
		WHERE SC.StaffID = @StaffID
			AND ISNULL(SC.RecordDeleted, 'N') = 'N'

		-------------------------------------------------------------------------------------------------------------------------------------------------------------    
		--This query will get all the records from Staff Insurers table for the selected Staff  [Added for Task #53 CM to SC Project]        
		SELECT StaffInsurers.StaffInsurerId
			,StaffInsurers.InsurerId
			,StaffInsurers.StaffId
			,StaffInsurers.CreatedBy
			,StaffInsurers.CreatedDate
			,StaffInsurers.ModifiedBy
			,StaffInsurers.ModifiedDate
			,StaffInsurers.RecordDeleted
			,StaffInsurers.DeletedDate
			,StaffInsurers.DeletedBy
		FROM StaffInsurers
		INNER JOIN Insurers ON StaffInsurers.InsurerId = Insurers.InsurerId
		WHERE (StaffInsurers.StaffId = @StaffID)
			AND (ISNULL(StaffInsurers.RecordDeleted, 'N') <> 'Y')
			AND (ISNULL(Insurers.RecordDeleted, 'N') <> 'Y')
			AND (Insurers.Active = 'Y')

		--------------------------------------------------------------------------------------------------------------------------------------------------------------
		--This temporary table is used to fill the Insurers grid in the Staff Details screen.  [Added for Task #53 CM to SC Project]                                                
		CREATE TABLE #Temp (
			Selected INT
			,InsurerID INT
			,InsurerName VARCHAR(100)
			,PrimaryInsurer INT
			,PrimaryColumn VARCHAR(10)
			)

		INSERT INTO #Temp
		SELECT '1'
			,InsurerID
			,InsurerName
			,'0'
			,'Primary'
		FROM Insurers
		WHERE isnull(RecordDeleted, 'N') <> 'Y'
			AND EXISTS (
				SELECT InsurerID
				FROM StaffInsurers
				WHERE StaffId = @StaffID
					AND isnull(RecordDeleted, 'N') <> 'Y'
					AND StaffInsurers.InsurerID = Insurers.InsurerId
				)
			AND Active = 'Y'
		
		UNION
		
		SELECT '0'
			,InsurerID
			,InsurerName
			,'0'
			,'Primary'
		FROM Insurers
		WHERE isnull(RecordDeleted, 'N') <> 'Y'
			AND NOT EXISTS (
				SELECT InsurerID
				FROM StaffInsurers
				WHERE StaffId = @StaffID
					AND isnull(RecordDeleted, 'N') <> 'Y'
					AND StaffInsurers.InsurerID = Insurers.InsurerId
				)
			AND Active = 'Y'

		--Checking For Errors                                  
		UPDATE #Temp
		SET PrimaryInsurer = '1'
		WHERE InsurerID = (
				SELECT PrimaryInsurerID
				FROM Staff
				WHERE StaffId = @StaffID
				)

		--Checking For Errors                                  
		SELECT *
		FROM #Temp
		ORDER BY InsurerName

		--Checking For Errors                                  
		--drop table #Temp                                              
		DELETE
		FROM #Temp

		---------------------------------------------------------------------------------------------------------------------------------------------
		--This query will get all the records from Staff Providers table for the selected Staff  [Added for Task #53 CM to SC Project]  
		SELECT SP.StaffProviderId
			,SP.ProviderId
			,SP.StaffId
			,SP.CreatedBy
			,SP.CreatedDate
			,SP.ModifiedBy
			,SP.ModifiedDate
			,SP.RecordDeleted
			,SP.DeletedDate
			,SP.DeletedBy
		FROM StaffProviders SP
		WHERE (SP.StaffId = @StaffID)
			AND (ISNULL(SP.RecordDeleted, 'N') = 'N')

		------------------------------------------------------------------------------------------------------------------------------------------
		--This temporary table is used to fill the Provider grid in the User Details screen.  [Added for Task #53 CM to SC Project]                                            
		CREATE TABLE #TempProvider (
			Selected INT
			,ProviderID INT
			,ProviderName VARCHAR(100)
			,PrimaryProvider INT
			,PrimaryColumn VARCHAR(10)
			,RecordDeleted CHAR(1)
			,RenderingProvider CHAR(1)
			)

		DECLARE @AllProvider CHAR(1)

		SELECT @AllProvider = ISNULL(AllProviders, 'N')
		FROM Staff
		WHERE StaffId = @StaffId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF (@AllProvider = 'N')
		BEGIN
			INSERT INTO #TempProvider
			SELECT '1'
				,ProviderID
				,ProviderName + CASE 
					WHEN ProviderType = 'I'
						THEN ', ' + isnull(FirstName, '')
					ELSE ''
					END
				,'0'
				,'Primary'
				,Isnull(RecordDeleted, 'N')
				,Isnull(RenderingProvider, 'N')
			FROM Providers
			WHERE isnull(RecordDeleted, 'N') <> 'Y'
				AND isnull(RenderingProvider, 'N') <> 'Y'
				AND UsesProviderAccess = 'Y'
				AND Active = 'Y'
				AND
				--20/01/2016    Basudev        What : Modified not to show up rendering provider by default                         
				EXISTS (
					SELECT ProviderID
					FROM StaffProviders
					WHERE StaffId = @StaffID
						AND isnull(RecordDeleted, 'N') <> 'Y'
						AND StaffProviders.ProviderID = providers.providerid
					)
			
			UNION
			
			--Select '0' ,ProviderID,ProviderName + case when ProviderType = 'I' then ', ' + isnull(FirstName, '') else '' end,'0','Primary',isnull(RecordDeleted,'N'),Isnull(RenderingProvider,'N') from Providers where isnull(RecordDeleted,'N')<>'Y' and isnull(RenderingProvider,'N')<>'Y' and UsesProviderAccess = 'Y' and Active = 'Y' and                           
			--   --20/01/2016    Basudev        What : Modified not to show up rendering provider by default
			--not exists (Select ProviderID from StaffProviders where StaffId=@StaffID  and isnull(RecordDeleted,'N')<>'Y'       
			--and StaffProviders.ProviderID=providers.providerid) 
			--union
			SELECT '1'
				,ProviderID
				,ProviderName + CASE 
					WHEN ProviderType = 'I'
						THEN ', ' + isnull(FirstName, '')
					ELSE ''
					END
				,'0'
				,'Primary'
				,isnull(RecordDeleted, 'N')
				,Isnull(RenderingProvider, 'N')
			FROM Providers
			WHERE isnull(RecordDeleted, 'N') <> 'Y'
				AND isnull(RenderingProvider, 'N') = 'Y'
				AND Active = 'Y'
				AND EXISTS (
					SELECT ProviderID
					FROM StaffProviders
					WHERE StaffId = @StaffID
						AND isnull(RecordDeleted, 'N') <> 'Y'
						AND StaffProviders.ProviderID = providers.providerid
					)

			-- union
			-- Select '0' ,ProviderID,ProviderName + case when ProviderType = 'I' then ', ' + isnull(FirstName, '') else '' end,'0','Primary',isnull(RecordDeleted,'N'),Isnull(RenderingProvider,'N') from Providers where isnull(RecordDeleted,'N')<>'Y' and isnull(RenderingProvider,'N') = 'Y'  and Active = 'Y'                            
			-- and not exists (Select ProviderID from StaffProviders where StaffId=@StaffID and isnull(RecordDeleted,'N')<>'Y'      
			--and StaffProviders.ProviderID=providers.providerid) 
			--20/01/2016    Basudev        What : Modified not to show up rendering provider by default
			--Checking For Errors                                
			UPDATE #TempProvider
			SET PrimaryProvider = '1'
			WHERE ProviderID = (
					SELECT PrimaryProviderId
					FROM Staff
					WHERE StaffId = @StaffID
					)
				--Checking For Errors                                  
		END

		SELECT *
		FROM #TempProvider
		ORDER BY ProviderName

		--Checking For Errors                                  
		--drop table #Temp                                              
		DELETE
		FROM #TempProvider

		--Checking For Errors                                  
		--If (@@error!=0)  Begin  RAISERROR  20006  'ssp_PMStaffDetail: An Error Occured'     Return  End   
		IF (@@error != 0)
		BEGIN
			RAISERROR (
					'ssp_PMStaffDetail: An Error Occured'
					,16
					,1
					)

			RETURN
		END

		--StaffContractedRates  
		SELECT SCR.StaffContractedRateId
			,SCR.CreatedBy
			,SCR.CreatedDate
			,SCR.ModifiedBy
			,SCR.ModifiedDate
			,SCR.RecordDeleted
			,SCR.DeletedBy
			,SCR.DeletedDate
			,SCR.StaffId
			,SCR.ProcedureCodeId
			,SCR.FromDate
			,SCR.ToDate
			,SCR.IsAllProcedureCode
			,SCR.Charge
			,SCR.ChargeType
			,SCR.FromUnit
			,SCR.ToUnit
			,SCR.UnitType
			,(
				CASE 
					WHEN ISNULL(SCR.ProcedureCodeId, 0) > 0
						THEN PC.ProcedureCodeName
					ELSE 'All Procedures'
					END
				) AS ProcedureCodeName
			--,'' As RateText		
			,'$' + CONVERT(VARCHAR, SCR.Charge, 2) + ' ' + (
				CASE dbo.ssf_GetGlobalCodeNameById(SCR.ChargeType)
					WHEN 'For exactly'
						THEN ' Exactly for ' + (
								CASE 
									WHEN PC.AllowDecimals = 'Y'
										THEN CONVERT(VARCHAR, SCR.FromUnit, 1)
									ELSE CAST(CAST(ROUND(SCR.FromUnit, 0) AS INT) AS VARCHAR)
									END
								) + ' ' + (
								CASE 
									WHEN ISNULL(SCR.ProcedureCodeId, 0) > 0
										THEN ISNULL(GC.CodeName, '')
									ELSE ''
									END
								)
					WHEN 'Range'
						THEN ' Range ' + (
								CASE 
									WHEN PC.AllowDecimals = 'Y'
										THEN CONVERT(VARCHAR, SCR.FromUnit, 1)
									ELSE CAST(CAST(ROUND(SCR.FromUnit, 0) AS INT) AS VARCHAR)
									END
								) + ' To ' + (
								CASE 
									WHEN PC.AllowDecimals = 'Y'
										THEN CONVERT(VARCHAR, SCR.ToUnit, 1)
									ELSE CAST(CAST(ROUND(SCR.ToUnit, 0) AS INT) AS VARCHAR)
									END
								) + ' ' + (
								CASE 
									WHEN ISNULL(SCR.ProcedureCodeId, 0) > 0
										THEN ISNULL(GC.CodeName, '')
									ELSE ''
									END
								)
					WHEN 'Per'
						THEN ' Per ' + (
								CASE 
									WHEN PC.AllowDecimals = 'Y'
										THEN CONVERT(VARCHAR, SCR.FromUnit, 1)
									ELSE CAST(CAST(ROUND(SCR.FromUnit, 0) AS INT) AS VARCHAR)
									END
								) + ' ' + (
								CASE 
									WHEN ISNULL(SCR.ProcedureCodeId, 0) > 0
										THEN ISNULL(GC.CodeName, '')
									ELSE ''
									END
								)
					ELSE ''
					END
				) AS RateText
			,SCR.Priority
		FROM StaffContractedRates SCR
		LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = SCR.ProcedureCodeId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = PC.EnteredAs
		WHERE SCR.StaffID = @StaffID
			AND ISNULL(SCR.RecordDeleted, 'N') = 'N'

		--StaffNotification  
		SELECT SN.StaffNotificationPreferenceAdditionalStaffId
			,SN.CreatedBy
			,SN.CreatedDate
			,SN.ModifiedBy
			,SN.ModifiedDate
			,SN.RecordDeleted
			,SN.DeletedDate
			,SN.DeletedBy
			,SN.StaffId
			,SN.NotificationStaffId
			,CASE 
				WHEN S.Degree IS NULL
					THEN isnull(S.DisplayAs, '')
				ELSE isnull(S.DisplayAs, '') + ' ' + isnull(GC.CodeName, '')
				END AS StaffName
		FROM StaffNotificationPreferenceAdditionalStaff SN
		JOIN Staff S ON S.StaffId = SN.NotificationStaffId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.Degree
		WHERE SN.StaffId = @StaffID
			AND ISNULL(SN.RecordDeleted, 'N') = 'N'

		----StaffTimeSheetGenerals          
		SELECT STSG.StaffTimeSheetGeneralId
			,STSG.CreatedBy
			,STSG.CreatedDate
			,STSG.ModifiedBy
			,STSG.ModifiedDate
			,STSG.RecordDeleted
			,STSG.DeletedBy
			,STSG.DeletedDate
			,STSG.StaffId
			,STSG.EmploymentType
			,STSG.BeginningBalancePersonalLeaveDate
			,STSG.PersonalLeave
			,STSG.BeginningBalanceLongTermSickDate
			,STSG.LongTermSick
		FROM StaffTimeSheetGenerals STSG
		JOIN Staff S ON S.StaffId = STSG.StaffId
		WHERE STSG.StaffId = @StaffID
			AND ISNULL(STSG.RecordDeleted, 'N') = 'N'

		---------------StaffTimeSheetAccrualHistory          
		SELECT STSAH.StaffTimeSheetAccrualHistoryId
			,STSAH.CreatedBy
			,STSAH.CreatedDate
			,STSAH.ModifiedBy
			,STSAH.ModifiedDate
			,STSAH.RecordDeleted
			,STSAH.DeletedBy
			,STSAH.DeletedDate
			,STSAH.StaffId
			,STSAH.EffectiveDate
			,STSAH.EndDate
			,STSAH.AccrualRate
			,STSAH.FullTimeEquivalentPercentage
			,STSAH.ExpectedHours
			,STSAH.AccrualType
			,GC.CodeName AS AccrualTypeName
			,STSAH.AccrualRatePer
			,GCPer.CodeName AS AccrualRatePerName
			,STSAH.Comments
		FROM StaffTimeSheetAccrualHistory STSAH
		JOIN Staff S ON S.StaffId = STSAH.StaffId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STSAH.AccrualType
		LEFT JOIN GlobalCodes GCPer ON GCPer.GlobalCodeId = STSAH.AccrualRatePer
		WHERE STSAH.StaffId = @StaffID
			AND ISNULL(STSAH.RecordDeleted, 'N') = 'N'

		----StaffTimeSheetPersonalLeaveCashedOut          
		SELECT SPL.StaffTimeSheetPersonalLeaveCashedOutId
			,SPL.CreatedBy
			,SPL.CreatedDate
			,SPL.ModifiedBy
			,SPL.ModifiedDate
			,SPL.RecordDeleted
			,SPL.DeletedBy
			,SPL.DeletedDate
			,SPL.StaffId
			,SPL.AmountCashedOut
			,SPL.ReminingBalance
			,SPL.BeginningBalance
		FROM StaffTimeSheetPersonalLeaveCashedOut SPL
		JOIN Staff S ON S.StaffId = SPL.StaffId
		WHERE SPL.StaffId = @StaffID
			AND ISNULL(SPL.RecordDeleted, 'N') = 'N'

		-----StaffTimeSheetAdjustments          
		SELECT STSA.StaffTimeSheetAdjustmentId
			,STSA.CreatedBy
			,STSA.CreatedDate
			,STSA.ModifiedBy
			,STSA.ModifiedDate
			,STSA.RecordDeleted
			,STSA.DeletedBy
			,STSA.DeletedDate
			,STSA.StaffId
			,STSA.AdjustmentType
			,STSA.IncreaseOrDecrease
			,GC.CodeName AS AdjustmentTypeName
			,GC1.CodeName AS IncreaseOrDecreaseName
			,STSA.NumberOfHours
			,STSA.ReminingBalance
			,STSA.BeginningBalance
			,STSA.Comments
			,STSA.AdjustmentDate
		FROM StaffTimeSheetAdjustments STSA
		JOIN Staff S ON S.StaffId = STSA.StaffId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STSA.AdjustmentType
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = STSA.IncreaseOrDecrease
		WHERE STSA.StaffId = @StaffID
			AND ISNULL(STSA.RecordDeleted, 'N') = 'N'

		--PrescriberProxies                                          
		SELECT CASE 
				WHEN S.Degree IS NULL
					THEN isnull(S.DisplayAs, '') --isnull(S.LastName,'')+ ', ' + isnull(S.FirstName,'')  
				ELSE isnull(S.DisplayAs, '') + ' ' + isnull(GC.CodeName, '') --isnull(S.LastName,'')+ ', ' + isnull(S.FirstName,'') + ' ' + isnull(GC.CodeName,'')   
				END AS StaffName
			,SP.PrescriberProxyId
			,SP.PrescriberId
			,SP.ProxyStaffId
			,SP.RowIdentifier
			,SP.CreatedBy
			,SP.CreatedDate
			,SP.ModifiedBy
			,SP.ModifiedDate
			,SP.RecordDeleted
			,SP.DeletedDate
			,SP.DeletedBy
		FROM PrescriberProxies SP
		INNER JOIN Staff S ON S.StaffId = SP.ProxyStaffId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.Degree
		WHERE SP.PrescriberId = @StaffID
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(SP.RecordDeleted, 'N') = 'N'
		ORDER BY StaffName

		--03 OCT 2016   Pavani
		--StaffPrefernences      
		SELECT SP.StaffPreferenceId
			,SP.CreatedBy
			,SP.CreatedDate
			,SP.ModifiedBy
			,SP.ModifiedDate
			,SP.RecordDeleted
			,SP.DeletedBy
			,SP.DeletedDate
			,SP.StaffId
			,SP.DefaultMobileHomePageId
			,SP.DefaultMobileProgramId
			,SP.MobileCalendarEventsDaysLookUpInPast
			,SP.MobileCalendarEventsDaysLookUpInFuture
			,SP.TreatmentTeamRole
			,--12/12/2016   Arjun K R  
			sp.StreamlineStaff
			,SP.NotifyMeOfMyServices
			--Vishnu Narayanan Mobile#6
			,SP.RegisteredForMobileNotifications
			,SP.LastTFATimeStamp
			,SP.RegisteredForMobileNotificationsTimeStamp
			,SP.RegisteredForSMSNotifications
			,SP.RegisteredForEmailNotifications
			,SP.AlwaysDefaultCosigner
		FROM StaffPreferences SP
		INNER JOIN Staff s ON SP.staffID = s.StaffId
		WHERE SP.StaffId = @StaffId
			AND ISNULL(SP.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'

		--StaffSupervisors--    
		SELECT CASE 
				WHEN S.Degree IS NULL
					THEN isnull(S.DisplayAs, '') --isnull(S.LastName,'')+ ', ' + isnull(S.FirstName,'')          
				ELSE isnull(S.DisplayAs, '') + ' ' + isnull(GC.CodeName, '') --isnull(S.LastName,'')+ ', ' + isnull(S.FirstName,'') + ' ' + isnull(GC.CodeName,'')                 
				END AS StaffName
			,SS.StaffSupervisorId
			,SS.StaffId
			,SS.SupervisorId
			,SS.RowIdentifier
			,SS.CreatedBy
			,SS.CreatedDate
			,SS.ModifiedBy
			,SS.ModifiedDate
			,SS.RecordDeleted
			,SS.DeletedDate
			,SS.DeletedBy
		FROM StaffSupervisors SS
		INNER JOIN Staff S ON S.StaffId = SS.StaffId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.Degree
		WHERE SS.SupervisorId = @StaffId
			AND ISNULL(SS.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		ORDER BY StaffName

		

		SELECT [ProviderId]
			,[ProviderType]
			,[Active]
			,[NonNetwork]
			,[DataEntryComplete]
			,[ProviderName]
			,[FirstName]
			,[ExternalId]
			,[Website]
			,[Comment]
			,[PrimarySiteId]
			,[PrimaryContactId]
			,[ContractingContactId]
			,[ApplyTaxIDToAllSites]
			,[ProviderIdAppliesToAllSites]
			,[POSAppliesToAllSites]
			,[TaxonomyAppliesToAllSites]
			,[NPIAppliesToAllSites]
			,[DataEntryCompleteForAuthorization]
			,[UsesProviderAccess]
			,[SubstanceUseProvider]
			,[AccessAgency]
			,[CredentialApproachingExpiration]
			,[RowIdentifier]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[AssociatedClinicianId]
			,[RenderingProvider]
		FROM Providers --20/01/2016    Basudev Why : for CEI SGL   #364 AspenPointe Customizations.
		WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
			AND Active = 'Y'
			AND UsesProviderAccess = 'Y'
			AND Providerid = - 1

		--This temporary table is used to fill the AssociatedProviders in pop up  grid in the User Details screen.  [Added for Task #364 CEI SGL]                                            
		CREATE TABLE #AssociatedProviders (
			Selected INT
			,ProviderID INT
			,ProviderName VARCHAR(100)
			,PrimaryProvider INT
			,PrimaryColumn VARCHAR(10)
			,RecordDeleted CHAR(1)
			,RenderingProvider CHAR(1)
			)

		
		INSERT INTO #AssociatedProviders
		SELECT CASE ISNULL(SP.PROVIDERID, 0)
				WHEN 0
					THEN '0'
				ELSE '1'
				END AS Selected
			,p.ProviderID
			,p.ProviderName + CASE 
				WHEN p.ProviderType = 'I'
					THEN ', ' + isnull(p.FirstName, '')
				ELSE ''
				END
			,CASE isnull(s.PrimaryProviderId, 0)
				WHEN 0
					THEN '0'
				ELSE '1'
				END AS PrimaryProviderId
			,'Primary'
			,Isnull(p.RecordDeleted, 'N')
			,Isnull(p.RenderingProvider, 'N')
		FROM Providers P
		LEFT JOIN StaffProviders SP ON SP.ProviderID = P.ProviderID
			AND SP.StaffId = @StaffID
			AND isnull(SP.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff s ON S.StaffId = SP.StaffId
			AND s.PrimaryProviderId = P.ProviderID
			AND isnull(s.RecordDeleted, 'N') <> 'Y'
		WHERE isnull(p.RecordDeleted, 'N') <> 'Y'
			AND p.UsesProviderAccess = 'Y'
			AND p.Active = 'Y'

		SELECT *
		FROM #AssociatedProviders
		ORDER BY ProviderName

		DROP TABLE #AssociatedProviders
		
		--StaffWorkHours
		SELECT SH.StaffWorkHourId
			,SH.CreatedBy
			,SH.CreatedDate
			,SH.ModifiedBy
			,SH.ModifiedDate
			,SH.RecordDeleted
			,SH.DeletedDate
			,SH.DeletedBy
			,SH.StaffId
			,SH.Dayoftheweek
			,SH.StartTime
			,SH.EndTime
			,GC.CodeName AS DayoftheweekText
		FROM StaffWorkHours SH
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = SH.Dayoftheweek
		WHERE SH.StaffId = @StaffID
			AND (ISNULL(SH.RecordDeleted, 'N') = 'N')
			
			 ---Chita Ranjan 14-April-2018  
		 SELECT SHT.StaffHighlyQualifiedTeacherId  
			,SHT.CreatedBy  
			,SHT.CreatedDate  
			,SHT.ModifiedBy  
			,SHT.ModifiedDate  
			,SHT.RecordDeleted  
			,SHT.DeletedBy  
			,SHT.DeletedDate  
			,SHT.StaffId  
			,CT.TypeOfCourse AS CourseTypeName  
			,SHT.CourseGroup    
			,GC.CodeName AS CourseGroupText  
			,SHT.CourseType  
			,SHT.Points  
			,SHT.AsOfDate  
		    FROM  StaffHighlyQualifiedTeachers SHT   
		    INNER JOIN CourseTypes CT ON SHT.CourseType = CT.CourseTypeId 
		    INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = SHT.CourseGroup  
			WHERE SHT.StaffId = @StaffId   
			AND (ISNULL(SHT.RecordDeleted, 'N') = 'N') AND (ISNULL(CT.RecordDeleted, 'N') = 'N')   
		    AND (ISNULL(GC.RecordDeleted, 'N') = 'N')  
		   
		--Swatika 10-July-2018 
		--StaffUnits                                       
		SELECT U.DisplayAs AS DisplayAs
			,SU.StaffUnitId
			,SU.CreatedBy
			,SU.CreatedDate
			,SU.ModifiedBy
			,SU.ModifiedDate
			,SU.RecordDeleted
			,SU.DeletedDate
			,SU.DeletedBy
			,SU.StaffId
            ,SU.UnitId
		FROM StaffUnits SU
		INNER JOIN Units U ON SU.UnitId = U.UnitId
		WHERE SU.StaffID = @StaffID
			AND ISNULL(U.RecordDeleted, 'N') = 'N'
			AND ISNULL(SU.RecordDeleted, 'N') = 'N'
		ORDER BY DisplayAs
		

		  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMStaffDetail') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + 
			CONVERT(VARCHAR, ERROR_STATE())

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



