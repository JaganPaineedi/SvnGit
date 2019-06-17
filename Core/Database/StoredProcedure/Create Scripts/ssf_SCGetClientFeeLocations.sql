/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetClientFeeLocations]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetClientFeeLocations]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetClientFeeLocations]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetClientFeeLocations]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCGetClientFeeLocations] (@ClientFeeId INT,@Mode VARCHAR(20))
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetClientFeeLocations      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 27-JULY-2015	 Akwinass		What:Used in ssp_SCListPageClientFees.          
--								Why:Task #995 in Valley - Customizations
*********************************************************************************/ 
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @Return NVARCHAR(max)
	
	IF @Mode = 'TEXT'
	BEGIN
		SELECT @Return = COALESCE(@Return + ', ', '') + L.LocationCode
		FROM ClientFeeLocations CFC
		JOIN Locations L ON CFC.LocationId = L.LocationId
		WHERE CFC.ClientFeeId = @ClientFeeId
			AND isnull(L.RecordDeleted, 'N') = 'N'
			AND isnull(CFC.RecordDeleted, 'N') = 'N'
	END
	ELSE IF @Mode = 'ID'
	BEGIN
		SELECT @Return = COALESCE(@Return + ',', '') + CAST(L.LocationId AS VARCHAR(25))
		FROM ClientFeeLocations CFC
		JOIN Locations L ON CFC.LocationId = L.LocationId
		WHERE CFC.ClientFeeId = @ClientFeeId
			AND isnull(L.RecordDeleted, 'N') = 'N'
			AND isnull(CFC.RecordDeleted, 'N') = 'N'
	END
	

	RETURN ISNULL(@Return,'')
END

GO


