/****** Object:  StoredProcedure [dbo].[ssp_SCGetServicesDetailByServiceIds]    Script Date: 06/01/2012 12:36:27 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetServicesDetailByServiceIds]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetServicesDetailByServiceIds]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetServicesDetailByServiceIds]    Script Date: 06/01/2012 12:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetServicesDetailByServiceIds] 
@ServiceIds VARCHAR(MAX)
	,-- Here will be multiple services Ids concatinated with ',' sign 
	@ViewBy VARCHAR(20)
	/********************************************************************************                                                          
-- Stored Procedure: dbo.ssp_SCGetServicesDetailByServiceIds.sql                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: used by Team Scheduling list page's Service Hyper link to Open ServiceNote page
--                                                          
-- Updates:                                                                                                                 
-- Date			Author			Purpose                                                          
-- Jun 01,2012	Varinder Verma	Created. 
-- Jun 06,2012	Varinder Verma	Modified to set format to show in the PopUp
-- Jun 15,2012	Davinder kumar	Convert sv.Unit to CAST(CAST(Sv.Unit as int) as varchar) in table #TempServiceDetails
-- Jul 20,2012	Varinder Verma	Added Groupcode when view by Staff
-- Aug 07,2012	Varinder Verma	Show group-service in "Title" with "Group (GroupName)" 
-- 20 Oct 2015    Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.    
--								why:task #609, Network180 Customization
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @TempServiceIds TABLE (ServiceId INT)

		INSERT INTO @TempServiceIds
		SELECT *
		FROM [dbo].fnSplit(@ServiceIds, ',')

		SELECT SV.ServiceId
			,Doc.DocumentId
			,CASE 
				WHEN @ViewBy = 'Staff'
					THEN CASE 
							WHEN G.GroupCode IS NOT NULL
								THEN ' Group ' + G.GroupCode + ' '
							ELSE S.LastName + ', ' + S.FirstName
							END
				ELSE
					-- Modified by   Revathi   20 Oct 2015
					CASE 
						WHEN ISNULL(C.ClientType, 'I') = 'I'
							THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END
					--C.LastName+ ', ' + C.FirstName 
				END + ' - ' + PC.DisplayAs + ', ' + CONVERT(VARCHAR, CAST(SV.DateOfService AS TIME), 100) + ', ' + (CAST(CAST(Sv.Unit AS INT) AS VARCHAR) + ' ' + ISNULL(Gc.CodeName, '')) + ', ' + GC1.CodeName + CASE 
				WHEN SV.Comment IS NULL
					THEN ''
				ELSE ' (' + CAST(SV.Comment AS VARCHAR(MAX)) + ')'
				END AS Details
		FROM SERVICES SV
		INNER JOIN @TempServiceIds TmpS ON TmpS.ServiceId = SV.ServiceId
		LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = SV.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S ON S.StaffId = SV.ClinicianId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND S.Active = 'Y'
		LEFT JOIN Clients C ON C.ClientId = SV.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND C.Active = 'Y'
		LEFT JOIN Documents Doc ON Doc.ServiceId = SV.ServiceId
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SV.UnitType
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = SV.STATUS
		LEFT JOIN GroupServices GS ON GS.GroupServiceId = SV.GroupServiceId
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
		LEFT JOIN Groups G ON G.GroupId = GS.GroupId
			AND ISNULL(G.RecordDeleted, 'N') = 'N'
			AND G.Active = 'Y'
		WHERE ISNULL(SV.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetServicesDetailByServiceIds') 
		+ '*****' + CONVERT(VARCHAR, ERROR_LINE())
		 + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) 
		 + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

