/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeePopupList]    Script Date: 07/24/2015 14:27:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFeePopupList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFeePopupList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeePopupList]    Script Date: 07/24/2015 14:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientFeePopupList]
	(@ClientFeeId INT,@Mode VARCHAR(50),@AllSelected CHAR(1),@ArrayValue VARCHAR(MAX))
AS
-- =============================================    
-- Author      : Akwinass
-- Date        : 08 SEP 2015 
-- Purpose     : To Get Locations, Programs and Procedure Codes. 
-- History
-- Date				Author        Purpose
-- 20 Sep 2016		Vamsi		What: Added Code to get @ArrayValue from  Related tables instead of passing values from UI w.r.t Woods - Support Go Live#233 
-- 12/07/2016		Msood		Changed the ProcedureCodeName to DisplayAs  Valley - Support Go Live Task # 876
-- =============================================   
BEGIN
	BEGIN TRY
		
		IF @Mode = 'Locations'
		BEGIN
		-- 20 Sep 2016 Vamsi
		    SELECT @ArrayValue = COALESCE(@ArrayValue, '') + ',' + Cast(LocationId AS VARCHAR)
			FROM ClientFeeLocations
			WHERE ClientFeeId = @ClientFeeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			SELECT L.LocationId
				,L.LocationName
				,CASE WHEN CFL.LocationId IS NOT NULL OR ISNULL(@AllSelected,'N') = 'Y' THEN 'True' ELSE 'False' END IsChecked
			FROM Locations L
			LEFT JOIN (SELECT DISTINCT item AS LocationId FROM [dbo].[fnSplit](@ArrayValue, ',')) CFL ON L.LocationId = CFL.LocationId
			WHERE ISNULL(L.RecordDeleted, 'N') = 'N'
				AND ISNULL(L.Active, 'N') = 'Y'
			ORDER BY L.LocationCode ASC
		END
		ELSE IF @Mode = 'Programs'
		BEGIN
		-- 20 Sep 2016 Vamsi
		    SELECT @ArrayValue = COALESCE(@ArrayValue, '') + ',' + Cast(ProgramId AS VARCHAR)
			FROM ClientFeePrograms
			WHERE ClientFeeId = @ClientFeeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			SELECT P.ProgramId
				,P.ProgramName
				,CASE WHEN CFP.ProgramId IS NOT NULL OR ISNULL(@AllSelected,'N') = 'Y' THEN 'True' ELSE 'False' END IsChecked
			FROM Programs P
			LEFT JOIN (SELECT DISTINCT item AS ProgramId FROM [dbo].[fnSplit](@ArrayValue, ',')) CFP ON P.ProgramId = CFP.ProgramId				
			WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.Active, 'N') = 'Y'
			ORDER BY P.ProgramCode ASC
		END
		ELSE IF @Mode = 'ProcedureCodes'
		BEGIN
		-- 20 Sep 2016 Vamsi
		    SELECT @ArrayValue = COALESCE(@ArrayValue, '') + ',' + Cast(ProcedureCodeid AS VARCHAR)
			FROM ClientFeeProcedureCodes
			WHERE ClientFeeId = @ClientFeeId 
			AND ISNULL(RecordDeleted, 'N') = 'N'
			SELECT PC.ProcedureCodeId
			-- Msood 12/07/2016
				--,PC.ProcedureCodeName
				,PC.DisplayAs as ProcedureCodeName
				,CASE WHEN CFP.ProcedureCodeId IS NOT NULL OR ISNULL(@AllSelected,'N') = 'Y' THEN 'True' ELSE 'False' END IsChecked
			FROM ProcedureCodes PC
			LEFT JOIN (SELECT DISTINCT item AS ProcedureCodeId FROM [dbo].[fnSplit](@ArrayValue, ',')) CFP ON PC.ProcedureCodeId = CFP.ProcedureCodeId				
			WHERE ISNULL(PC.RecordDeleted, 'N') = 'N'
				AND ISNULL(PC.Active, 'N') = 'Y'
				-- Msood 12/07/2016
			--ORDER BY PC.ProcedureCodeName ASC
			ORDER BY PC.DisplayAs ASC
		END
	END TRY

	BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetClientFeePopupList]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


