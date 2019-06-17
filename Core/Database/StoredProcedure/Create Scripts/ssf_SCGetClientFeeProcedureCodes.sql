/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetClientFeeProcedureCodes]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetClientFeeProcedureCodes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetClientFeeProcedureCodes]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetClientFeeProcedureCodes]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCGetClientFeeProcedureCodes] (@ClientFeeId INT,@Mode VARCHAR(20))
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetClientFeeProcedureCodes      
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
		SELECT @Return = COALESCE(@Return + ', ', '') + PC.DisplayAs
		FROM ClientFeeProcedureCodes CFPC
		JOIN ProcedureCodes PC ON CFPC.ProcedureCodeId = PC.ProcedureCodeId
		WHERE CFPC.ClientFeeId = @ClientFeeId
			AND isnull(PC.RecordDeleted, 'N') = 'N'
			AND isnull(CFPC.RecordDeleted, 'N') = 'N'
	END
	ELSE IF @Mode = 'ID'
	BEGIN
		SELECT @Return = COALESCE(@Return + ',', '') + CAST(PC.ProcedureCodeId AS VARCHAR(25))
		FROM ClientFeeProcedureCodes CFPC
		JOIN ProcedureCodes PC ON CFPC.ProcedureCodeId = PC.ProcedureCodeId
		WHERE CFPC.ClientFeeId = @ClientFeeId
			AND isnull(PC.RecordDeleted, 'N') = 'N'
			AND isnull(CFPC.RecordDeleted, 'N') = 'N'
	END
	

	RETURN ISNULL(@Return,'')
END

GO


