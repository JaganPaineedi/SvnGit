/****** Object:  UserDefinedFunction [dbo].[SSF_IsClientEnrolledInProgram]    Script Date: 10/12/2015 15:04:36 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSF_IsClientEnrolledInProgram]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[SSF_IsClientEnrolledInProgram]
GO

/****** Object:  UserDefinedFunction [dbo].[SSF_IsClientEnrolledInProgram]    Script Date: 10/12/2015 15:04:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SSF_IsClientEnrolledInProgram] (
	@ClientId INT
	,@ProgramId INT = NULL
	)
	--Updates
	/*  Date                  Author                 Purpose                                */
	-------------------------------------------------------------------------------------------
	/* 12/Oct/2015			Gautam			To get whether Client is enrolled in Program or not , For Woods Allies*/
	/* 12/Jan/2016			Shankha			Added Discharged status to the condition*/
	-------------------------------------------------------------------------------------------
RETURNS CHAR(1)

BEGIN
	DECLARE @Enrolled CHAR(1)

	IF EXISTS (
			SELECT TOP 1 ClientProgramId
			FROM ClientPrograms
			WHERE ClientId = @ClientId
				AND (
					@ProgramId IS NULL
					OR ProgramId = @ProgramId
					)
				AND [Status] IN (
					1
					,4
					,5
					)
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND (
					cast(EnrolledDate AS DATE) <= cast(GetDate() AS DATE)
					)
			ORDER BY ModifiedDate desc
			)
	BEGIN
		SET @Enrolled = 'Y'
	END
	ELSE
	BEGIN
		SET @Enrolled = 'N'
	END

	-- return
	RETURN @Enrolled
END
GO


