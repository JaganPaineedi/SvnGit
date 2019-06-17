/****** Object:  UserDefinedFunction [dbo].[sfn_GetLaboratoryId]    Script Date: 04/07/2016 17:24:59 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[sfn_GetLaboratoryId]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[sfn_GetLaboratoryId]
GO

/****** Object:  UserDefinedFunction [dbo].[sfn_GetLaboratoryId]    Script Date: 04/07/2016 17:24:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[sfn_GetLaboratoryId] (@ReferenceLabId VARCHAR(50))
RETURNS INT

BEGIN
	DECLARE @LaboratoryId INT

	SELECT @LaboratoryId = LaboratoryId
	FROM Laboratories
	WHERE ReferenceLabId = @ReferenceLabId
	
	RETURN @LaboratoryId
END
GO


