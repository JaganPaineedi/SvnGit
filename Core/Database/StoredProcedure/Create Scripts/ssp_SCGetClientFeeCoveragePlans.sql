/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeCoveragePlans]    Script Date: 07/24/2015 14:27:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFeeCoveragePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFeeCoveragePlans]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeCoveragePlans]    Script Date: 07/24/2015 14:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientFeeCoveragePlans]
	(@ClientId INT)
AS
-- =============================================    
-- Author      : Akwinass
-- Date        : 24 July 2015 
-- Purpose     : Get Client Coverage Plans. 
-- =============================================   
BEGIN
	BEGIN TRY
		SELECT DISTINCT CP.CoveragePlanName
			,CP.CoveragePlanId
			,CCP.ClientId
		FROM ClientCoveragePlans CCP
		JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		WHERE CCP.ClientId = @ClientId
			AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
	END CATCH
END

GO


