/****** Object:  StoredProcedure [dbo].[ssp_RDLGetClientFeeDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLGetClientFeeDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLGetClientFeeDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLGetClientFeeDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLGetClientFeeDetails] @PrimaryKeyId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_RDLGetClientFeeDetails   137           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    20/JAN/2016                                    */
/*                                                                   */
/* Purpose:  Used in RDL for ClientFees Detail Page  */
/*                                                                   */
/* Input Parameters: @PrimaryKeyId   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   
** Updates:                                                                                                         
** Date            Author              Purpose   
** 22-JAN-2016	   Akwinass			   What: "None" included for no records    
**									   Why: Task #16.4 in Camino - SmartCare Setup */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @OrganizationName VARCHAR(250)	
		DECLARE @ScreenName VARCHAR(100)
		DECLARE @ShowCustomRDL CHAR(1) = 'N'
		DECLARE @ClientId INT

		SELECT TOP 1 @OrganizationName = OrganizationName
		FROM SystemConfigurations
		
		SELECT TOP 1 @ScreenName = ScreenName
		FROM Screens
		WHERE ScreenId = 1146
		
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_RDLGetClientFeeDetails]') AND type in (N'P', N'PC'))
		BEGIN
			EXEC [dbo].[scsp_RDLGetClientFeeDetails] @ClientFeeId = @PrimaryKeyId, @ShowRDL = @ShowCustomRDL OUTPUT
		END
		
		DECLARE @ResultLocations VARCHAR(MAX)
		DECLARE @ResultPrograms VARCHAR(MAX)
		DECLARE @ResultProcedureCodes VARCHAR(MAX)
		DECLARE @AllLocations CHAR(1)
		DECLARE @AllPrograms CHAR(1)
		DECLARE @AllProcedureCodes CHAR(1)
		DECLARE @Locations VARCHAR(MAX)
		DECLARE @Programs VARCHAR(MAX)
		DECLARE @ProcedureCodes VARCHAR(MAX)
		DECLARE @PerSessionRatePercentage VARCHAR(100)
		DECLARE @PerSessionRateAmount VARCHAR(100)
		DECLARE @StandardRate VARCHAR(250)
		
		SELECT TOP 1@AllLocations = ISNULL(CF.AllLocations, 'N')
			,@AllPrograms = ISNULL(CF.AllPrograms, 'N')
			,@AllProcedureCodes = ISNULL(CF.AllProcedureCodes, 'N')
			,@Locations = ISNULL([dbo].[ssf_SCGetClientFeeLocations](ClientFeeId, 'ID'), '')
			,@Programs = ISNULL([dbo].[ssf_SCGetClientFeePrograms](ClientFeeId, 'ID'), '')
			,@ProcedureCodes = ISNULL([dbo].[ssf_SCGetClientFeeProcedureCodes](ClientFeeId, 'ID'), '')
			,@ClientId = CF.ClientId
			,@PerSessionRatePercentage = CASE WHEN CF.PerSessionRatePercentage IS NULL THEN '' ELSE CAST(CF.PerSessionRatePercentage AS VARCHAR(25)) + '%' END
			,@PerSessionRateAmount = CASE WHEN CF.PerSessionRateAmount IS NULL THEN '' ELSE '$' + CAST(CF.PerSessionRateAmount AS VARCHAR(25)) END
		FROM ClientFees CF
		WHERE CF.ClientFeeId = @PrimaryKeyId
			AND ISNULL(CF.RecordDeleted, 'N') = 'N'
			
		IF ISNULL(@PerSessionRatePercentage, '') <> '' AND ISNULL(@PerSessionRateAmount, '') <> ''
		BEGIN
			SET @StandardRate = @PerSessionRatePercentage + ' / ' + @PerSessionRateAmount
		END
		ELSE
		BEGIN
			IF ISNULL(@PerSessionRatePercentage, '') <> ''
			BEGIN
				SET @StandardRate = @PerSessionRatePercentage
			END
			IF ISNULL(@PerSessionRateAmount, '') <> ''
			BEGIN
				SET @StandardRate = @PerSessionRateAmount
			END
		END
		
		IF @AllLocations = 'Y'
		BEGIN
			SET @ResultLocations = 'All Selected'
		END
		ELSE
		BEGIN
			;WITH T1 AS (
			SELECT TOP 10 L.LocationName
			FROM Locations L
			JOIN (SELECT DISTINCT item AS LocationId FROM [dbo].[fnSplit](@Locations, ',')) CFL ON L.LocationId = CFL.LocationId
			WHERE ISNULL(L.RecordDeleted, 'N') = 'N' AND ISNULL(L.Active, 'N') = 'Y'
			ORDER BY L.LocationCode ASC)
			SELECT @ResultLocations = COALESCE(@ResultLocations + ', ', '') + ISNULL(LocationName,'')
			FROM T1
		END

		IF @AllPrograms = 'Y'
		BEGIN
			SET @ResultPrograms = 'All Selected'
		END
		ELSE
		BEGIN
			;WITH T2 AS (
			SELECT TOP 10 P.ProgramName
			FROM Programs P
			JOIN (SELECT DISTINCT item AS ProgramId FROM [dbo].[fnSplit](@Programs, ',')) CFP ON P.ProgramId = CFP.ProgramId				
			WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.Active, 'N') = 'Y'
			ORDER BY P.ProgramCode ASC)
			SELECT @ResultPrograms = COALESCE(@ResultPrograms + ', ', '') + ISNULL(ProgramName,'')
			FROM T2
		END

		IF @AllProcedureCodes = 'Y'
		BEGIN
			SET @ResultProcedureCodes = 'All Selected'
		END
		ELSE
		BEGIN
			;WITH T3 AS (
			SELECT TOP 10 PC.ProcedureCodeName
			FROM ProcedureCodes PC
			JOIN (SELECT DISTINCT item AS ProcedureCodeId FROM [dbo].[fnSplit](@ProcedureCodes, ',')) CFP ON PC.ProcedureCodeId = CFP.ProcedureCodeId				
			WHERE ISNULL(PC.RecordDeleted, 'N') = 'N'
				AND ISNULL(PC.Active, 'N') = 'Y'
			ORDER BY PC.ProcedureCodeName ASC)
			SELECT @ResultProcedureCodes = COALESCE(@ResultProcedureCodes + ', ', '') + ISNULL(ProcedureCodeName,'')
			FROM T3
		END
		
		DECLARE @OtherFamilyMembers VARCHAR(MAX);
		WITH OFM (ClientName)
		AS (
			SELECT C.LastName + ', ' + C.FirstName + ' (' + CAST(C.ClientId AS VARCHAR(25)) + ')' ClientName
			FROM ClientContacts CC
			JOIN Clients C ON CC.AssociatedClientId = C.ClientId
			WHERE CC.ClientId = @ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(CC.Active, 'N') = 'Y'
				AND ISNULL(C.Active, 'N') = 'Y'
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND CC.AssociatedClientId IS NOT NULL
			)
		SELECT @OtherFamilyMembers = COALESCE(@OtherFamilyMembers + ', ', '') + ISNULL(ClientName,'')
		FROM OFM
		ORDER BY ClientName ASC
		
		IF ISNULL(@ResultLocations,'') = ''
		BEGIN
			SET @ResultLocations = 'None'
		END
		
		IF ISNULL(@ResultPrograms,'') = ''
		BEGIN
			SET @ResultPrograms = 'None'
		END
		
		IF ISNULL(@ResultProcedureCodes,'') = ''
		BEGIN
			SET @ResultProcedureCodes = 'None'
		END
		
		IF ISNULL(@OtherFamilyMembers,'') = ''
		BEGIN
			SET @OtherFamilyMembers = 'None'
		END
			
		SELECT @OrganizationName AS OrganizationName			
			,C.LastName + ', ' + C.FirstName AS ClientName
			,CASE WHEN C.DOB IS NOT NULL THEN CONVERT(VARCHAR(10), C.DOB, 101) ELSE '' END AS DOB
			,@ScreenName AS ScreenName
			,CF.ClientFeeId
			,CF.CreatedBy
			,CF.CreatedDate
			,CF.ModifiedBy
			,CF.ModifiedDate
			,CF.RecordDeleted
			,CF.DeletedBy
			,CF.DeletedDate
			,CF.ClientId
			,CF.CoveragePlanId
			,ISNULL(CP.CoveragePlanName,'') AS CoveragePlanName
			,CF.ClientFeeType
			,ISNULL(GC1.CodeName,'') AS ClientFeeTypeText
			,CASE WHEN CF.StartDate IS NULL THEN '' ELSE CONVERT(VARCHAR(10), CF.StartDate, 101) END AS StartDate
			,CASE WHEN CF.EndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(10), CF.EndDate, 101) END AS EndDate
			,@StandardRate AS StandardRate
			,CASE WHEN CF.PerDayRateAmount IS NULL THEN '' ELSE '$' + CAST(CF.PerDayRateAmount AS VARCHAR(25)) END PerDayRateAmount
			,CASE WHEN CF.PerWeekRateAmount IS NULL THEN '' ELSE '$' + CAST(CF.PerWeekRateAmount AS VARCHAR(25)) END PerWeekRateAmount
			,CASE WHEN CF.PerMonthRateAmount IS NULL THEN '' ELSE '$' + CAST(CF.PerMonthRateAmount AS VARCHAR(25)) END PerMonthRateAmount
			,CASE WHEN CF.PerYearRateAmount IS NULL THEN '' ELSE '$' + CAST(CF.PerYearRateAmount AS VARCHAR(25)) END PerYearRateAmount
			,ISNULL(CF.Comments,'') AS Comments
			,ISNULL(CF.SetCopayment,'N') AS SetCopayment
			,ISNULL(CF.CollectUpfront,'N') AS CollectUpfront
			,CAST(CF.Priority AS VARCHAR(25)) AS Priority			
			,ISNULL(@ShowCustomRDL,'N') AS ShowCustomRDL
			,@ResultLocations AS Locations
			,@ResultPrograms AS Programs
			,@ResultProcedureCodes AS ProcedureCodes
			,@OtherFamilyMembers AS OtherFamilyMembers
		FROM ClientFees CF
		JOIN Clients C ON CF.ClientId = C.ClientId
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CF.ClientFeeType
		LEFT JOIN CoveragePlans CP ON CF.CoveragePlanId = CP.CoveragePlanId
		WHERE CF.ClientFeeId = @PrimaryKeyId
			AND ISNULL(CF.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_RDLGetClientFeeDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


