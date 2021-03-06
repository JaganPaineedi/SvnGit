/****** Object:  StoredProcedure [dbo].[csp_sql_job_default_passwords]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_sql_job_default_passwords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_sql_job_default_passwords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_sql_job_default_passwords]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE	[dbo].[csp_sql_job_default_passwords]
AS

--	Created by Jess 1/11/13 to use as a SQL Server Agent Job to manage default passwords
--	WO 26664

DECLARE	@CurrentDate datetime,
		@Script varchar(11)
SELECT	@CurrentDate = GETDATE(),
		@Script = ''Script26664''

--	Disable accounts with the default password that haven''t been used in 1 month
BEGIN	TRAN
UPDATE	Staff
SET		AccessSmartCare = ''N'',
		AccessPracticeManagement = ''N'',
		AccessCareManagement = ''N'',
		ModifiedBy = @Script,
		ModifiedDate = @CurrentDate
WHERE	Active = ''Y'' 
AND		UserPassword = ''OY4twqBxKBv3hTrEOg81iQ==''	-- Password123
--AND		ISNULL(passwordexpiresnextlogin, ''N'') <> ''Y''
AND		(	LastVisit <= DATEADD(mm, -1, GETDATE())
		OR	(	LastVisit IS NULL
			AND	CreatedDate <= DATEADD(mm, -1, GETDATE())
			)
		)
AND		AccessSmartCare = ''Y''
COMMIT	TRAN

--	Set all default passwords to expire next login
BEGIN	TRAN
UPDATE	Staff
SET		PasswordExpiresNextLogin = ''Y'',
		ModifiedBy = @Script,
		ModifiedDate = @CurrentDate
WHERE	UserPassword = ''OY4twqBxKBv3hTrEOg81iQ==''	-- Password123
AND		ISNULL(passwordexpiresnextlogin, ''N'') <> ''Y''
COMMIT	TRAN' 
END
GO
