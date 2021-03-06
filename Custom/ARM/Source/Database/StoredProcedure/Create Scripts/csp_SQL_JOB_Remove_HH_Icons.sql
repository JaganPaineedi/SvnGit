/****** Object:  StoredProcedure [dbo].[csp_SQL_JOB_Remove_HH_Icons]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SQL_JOB_Remove_HH_Icons]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SQL_JOB_Remove_HH_Icons]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SQL_JOB_Remove_HH_Icons]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE	[dbo].[csp_SQL_JOB_Remove_HH_Icons]
AS

/****************************************************************/
/* Stored Procedure: csp_SQL_JOB_Remove_HH_Icons				*/
/* Copyright Harbor												*/
/* Creation Date:    02/19/2013									*/
/*																*/
/* Purpose: SQL Server Agent Nightly Job						*/
/*																*/
/* Called By: Nightly Job: Remove HH House Icons				*/
/*																*/
/* Updates:														*/
/* Date			Author		Purpose								*/
/* 01/12/2013	Jess		Created - WO 27324					*/
/****************************************************************/

DECLARE	@CurrentDate datetime,
		@Script varchar(25)

SELECT	@CurrentDate = GETDATE(),
		@Script = ''Script27324''

DECLARE	@Icons TABLE
(
	ClientId int,
	ClientNoteId int
)

INSERT	@Icons
SELECT	ClientId,
		ClientNoteId
FROM	ClientNotes
WHERE	NoteType = 1009463	-- Enrolled in Medicaid Health Home
AND		(	EndDate IS NULL
		OR	EndDate > GETDATE()
		)
AND		ISNULL(RecordDeleted, ''N'') <> ''Y''

--	SELECT * FROM @Icons order by ClientId

DELETE
FROM	@Icons
WHERE	ClientId IN	(	SELECT	CP.ClientId
						FROM	ClientPrograms CP
						WHERE	CP.ProgramId in (445, 444) -- 6 HH Medicaid SED, 6 HH Medicaid SPMI
						AND		(	CP.DischargedDate IS NULL
								OR	CP.DischargedDate > GETDATE()
								)
						AND		ISNULL(CP.RecordDeleted, ''N'') <> ''Y''
					)

--SELECT * FROM @Icons order by ClientId

UPDATE	ClientNotes
SET		RecordDeleted = ''Y'',
		DeletedDate = @CurrentDate,
		DeletedBy = @Script
WHERE	ClientNoteId IN (SELECT ClientNoteId FROM @Icons)

' 
END
GO
