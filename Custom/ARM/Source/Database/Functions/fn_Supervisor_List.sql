/****** Object:  UserDefinedFunction [dbo].[fn_Supervisor_List]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Supervisor_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Supervisor_List]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Supervisor_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
--/*
CREATE FUNCTION [dbo].[fn_Supervisor_List] 
(
	-- Add the parameters for the function here
	@looptill	Int,
	@StaffId	varchar(10)
)
RETURNS 
@staff	TABLE
	(
	StaffId		INT,
	StaffName	Varchar(50)
	)
AS
--*/
/* =============================================================*/
/* Author:		<Michael Rowley>								*/
/*																*/
/*	Updates:													*/
/*	Date		Author	Purpose									*/
/*	10/14/2012	MSR		Create to return Table of StaffId		*/
/*						Based on tier in company (Staff/Super/VP*/
/*	11/14/2012	MSR		Added Staff Name to be return with table*/
/* =============================================================*/
/*	
DECLARE
	@looptill	Int,
	@StaffId	varchar(10)

DECLARE @staff	TABLE
	(
	StaffId		Int,
	StaffName	Varchar(50)
	)
	
SELECT	@StaffId = 159,
	@looptill = 1
--*/
BEGIN
	DECLARE 
		@loop		int	

	INSERT	INTO	@staff (StaffId, StaffName)
	SELECT	s.StaffId, s.LastName + '', '' + s.FirstName 
	FROM	Staff s
	WHERE	s.StaffId like @StaffId
	AND (ISNULL(s.RecordDeleted,''N'')<>''Y'')

	BEGIN
		SELECT	@loop =	0
		
		WHILE	@loop < @looptill 
		BEGIN
		
			INSERT	INTO	@staff (StaffId, StaffName)
			SELECT	s.StaffId, ts.LastName + '', '' + ts.FirstName 
			FROM	dbo.StaffSupervisors s
			JOIN Staff ts
			ON s.StaffId = ts.StaffId 
			--WHERE	s.super_id in	(
			WHERE	s.SupervisorId in	(
						SELECT	s2.StaffId
						FROM	@Staff s2
						)
			AND	s.StaffId not in	(
							SELECT	s2.StaffId
							FROM	@Staff s2
							)
			AND (ISNULL(s.RecordDeleted,''N'')<>''Y'')
			SELECT	@loop = @loop + 1
		END
	END
RETURN 
END
' 
END
GO
