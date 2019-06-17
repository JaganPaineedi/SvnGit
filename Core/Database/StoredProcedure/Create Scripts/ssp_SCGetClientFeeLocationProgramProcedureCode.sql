/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeLocationProgramProcedureCode]    Script Date: 07/24/2015 14:27:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFeeLocationProgramProcedureCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFeeLocationProgramProcedureCode]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeLocationProgramProcedureCode]    Script Date: 07/24/2015 14:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientFeeLocationProgramProcedureCode] (
	@AllLocations CHAR(1)
	,@AllPrograms CHAR(1)
	,@AllProcedureCodes CHAR(1)
	,@Locations VARCHAR(MAX)
	,@Programs VARCHAR(MAX)
	,@ProcedureCodes VARCHAR(MAX)
	)
AS
-- =============================================    
-- Author      : Akwinass
-- Date        : 09 SEP 2015 
-- Purpose     : To Get Locations, Programs and Procedure Codes. 
-- =============================================   
BEGIN
	BEGIN TRY		
		DECLARE @ResultLocations VARCHAR(2000)
		DECLARE @ResultPrograms VARCHAR(2000)
		DECLARE @ResultProcedureCodes VARCHAR(2000)
		DECLARE @RowCount INT

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

		SELECT @ResultLocations AS Locations
			,@ResultPrograms AS Programs
			,@ResultProcedureCodes AS ProcedureCodes		
	END TRY

	BEGIN CATCH
	END CATCH
END
GO



