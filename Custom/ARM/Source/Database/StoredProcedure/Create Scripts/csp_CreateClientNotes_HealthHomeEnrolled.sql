/****** Object:  StoredProcedure [dbo].[csp_CreateClientNotes_HealthHomeEnrolled]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateClientNotes_HealthHomeEnrolled]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateClientNotes_HealthHomeEnrolled]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateClientNotes_HealthHomeEnrolled]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_CreateClientNotes_HealthHomeEnrolled]
/********************************************************************************
-- Stored Procedure: csp_CreateClientNotes_HealthHomeEnrolled  
--
-- Copyright: 2012 Harbor 
--
-- Purpose: This code is called by an automated job.  It finds all clients that are enrolled in one of our Health Home Programs,
--			and adds a Health Home Enrollment client note to their record if they don''t already have one.  The client note will
--			cause a house icon to be displayed on the client record so that the client is quickly identifiable as being a HH client.
--			The icon is stored as a global code with category "CLIENTNOTETYPES"
--
-- Updates:                     		                                
-- Date			Author		Purpose
-- 10.31.2012	Jess		Created per WO 25367
*********************************************************************************/
as
set transaction isolation level read uncommitted
set nocount on

DECLARE	@CurrentDate datetime,
		@Script varchar(25)
SELECT	@CurrentDate = GETDATE(),
		@Script = ''Script25367''

INSERT	INTO	ClientNotes
(
	 ClientId,
	 NoteType,
	 NoteSubtype,
	 NoteLevel,
	 Note,
	 Active,
	 StartDate,
	 EndDate,
	 Comment,
	 CreatedBy,
	 CreatedDate,
	 ModifiedBy,
	 ModifiedDate
)
SELECT	CP.ClientId, 
		1009463,	-- Global Code - Enrolled in Medicaid Health Home
		NULL,
		NULL,
		''Client Enrolled in HH'',
		''Y'',
		CP.EnrolledDate,
		NULL,
		NULL,
		@Script,
		@CurrentDate,
		@Script,
		@CurrentDate
FROM	ClientPrograms CP
WHERE	CP.ProgramId in (444, 445)	-- "6 HH Medicaid SPMI" and "6 HH Medicaid SED"
AND		ISNULL(CP.RecordDeleted, ''N'') <> ''Y''
AND	NOT EXISTS	(	SELECT	CN.ClientNoteId
					FROM	dbo.ClientNotes CN
					WHERE	CN.ClientId = CP.ClientId
					AND		CN.NoteType = 1009463	-- Global Code - Enrolled in Medicaid Health Home
					AND		ISNULL(CN.RecordDeleted, ''N'') <> ''Y''
				)

return

' 
END
GO
