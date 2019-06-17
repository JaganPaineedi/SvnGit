IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetGlobalCodeNameById]')
			AND type IN (N'FN')
		)
	DROP FUNCTION [dbo].[ssf_GetGlobalCodeNameById]
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ssf_GetGlobalCodeNameById] (@GlobalCodeId INT)
RETURNS VARCHAR(250)
	/*********************************************************************************/
	/* FUNCTION: ssf_GetGlobalCodeNameById										*/
	/* Copyright: Streamline Healthcare Solutions									*/
	/* Date				Author        Purpose										*/
	/* 02-sep-2014     Revathi       What:  Get GlobalCodeNames
									  Why: #36 MeaningfulUse						*/
	/*********************************************************************************/
AS
BEGIN
	DECLARE @retval VARCHAR(250)

	SELECT @retval = CodeName
	FROM dbo.GlobalCodes
	WHERE GlobalCodeId = @GlobalCodeId

	RETURN @retval
END
GO

