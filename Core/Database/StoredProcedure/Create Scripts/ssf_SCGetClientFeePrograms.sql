/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetClientFeePrograms]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetClientFeePrograms]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetClientFeePrograms]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetClientFeePrograms]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCGetClientFeePrograms] (@ClientFeeId INT,@Mode VARCHAR(20))
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetClientFeePrograms      
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
		SELECT @Return = COALESCE(@Return + ', ', '') + P.ProgramCode
		FROM ClientFeePrograms CFP
		JOIN Programs P ON CFP.ProgramId = P.ProgramId
		WHERE CFP.ClientFeeId = @ClientFeeId
			AND isnull(P.RecordDeleted, 'N') = 'N'
			AND isnull(CFP.RecordDeleted, 'N') = 'N'
	END
	ELSE IF @Mode = 'ID'
	BEGIN
		SELECT @Return = COALESCE(@Return + ',', '') + CAST(P.ProgramId AS VARCHAR(25))
		FROM ClientFeePrograms CFP
		JOIN Programs P ON CFP.ProgramId = P.ProgramId
		WHERE CFP.ClientFeeId = @ClientFeeId
			AND isnull(P.RecordDeleted, 'N') = 'N'
			AND isnull(CFP.RecordDeleted, 'N') = 'N'
	END

	RETURN ISNULL(@Return,'')
END

GO


