/****** Object:  StoredProcedure [dbo].[csp_Report_non_medicaid_client_list]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_non_medicaid_client_list]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_non_medicaid_client_list]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_non_medicaid_client_list]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_non_medicaid_client_list]
	-- Add the parameters for the stored procedure here
	@StaffLastName varchar(30),
	@StaffFirstName varchar(20)
AS
--*/

/*
DECLARE	@StaffLastName varchar(30),
		@StaffFirstName varchar(20)

SELECT	@StaffLastName = ''paul'',
		@StaffFirstName = ''patricia''
--*/

SET NOCOUNT ON;	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/****************************************************************/
/* Stored Procedure: csp_Report_non_medicaid_client_list		*/
/* Creation Date:    06/22/2006									*/
/*																*/
/* Updates:														*/
/* Date			Author		Purpose								*/
/* 06/22/2006	Jess		Created	- WO 4217					*/
/* 06/13/2012   Brian M		Coverted from PsychConsult			*/
/****************************************************************/

DECLARE	@staff_id char(10),
		@last_name varchar(30),
		@first_name varchar(20),
		@message varchar(500)

IF (SELECT count(S.StaffId)
	FROM	Staff S
	WHERE	LastName  LIKE @StaffLastName
		AND	FirstName LIKE @StaffFirstName
		AND ISNULL(S.RecordDeleted,''N'')<>''Y''
	) > 1
	
	BEGIN
		SELECT	@message = ''Report can only be run for 1 staff member.  Please be more specific or contact Jess in the IT Dept. for more info.''
		SELECT	null as ''Client Name'',
				null as ''ClientId'',
				null as ''CurrentEpisodeNumber'',
				null as ''Staff'',
				@message as ''Message''
	END

ELSE
	BEGIN

SELECT	@staff_id =(SELECT	S.StaffId
					FROM	Staff S
					WHERE	LastName  LIKE @StaffLastName
						AND	FirstName LIKE @StaffFirstName
						AND ISNULL(S.RecordDeleted,''N'')<>''Y''
					)				
							
SELECT	@last_name =(SELECT	LastName
					FROM	Staff S
					WHERE	StaffId = @staff_id
					AND ISNULL(S.RecordDeleted,''N'')<>''Y''
					)			
Select	@first_name =(SELECT FirstName
					  FROM	Staff S
					  WHERE	StaffId = @staff_id
					  AND ISNULL(S.RecordDeleted,''N'')<>''Y''
					  )
Select	@message = ''''
		
SELECT DISTINCT
			C.LastName + '', '' + C.FirstName as ''Client Name'',
			C.ClientId,
			C.CurrentEpisodeNumber,
			@last_name + '', '' + @first_name as ''Staff'',
		--	@staff_id as ''Staffid'',
			@message as ''Message''
		FROM Clients C 
			JOIN Services SS 
				ON	(SS.ClientId = C.ClientId
					AND	SS.DateOfService >= ''1/1/07''
					AND	SS.ClinicianId = @staff_id
					AND	SS.Status NOT IN (''76'', ''73'', ''72'') --Error, Cancelled, No Show
					AND ISNULL(SS.RecordDeleted,''N'')<>''Y'')
			JOIN ClientCoveragePlans CCP
				ON (CCP.ClientId = C.ClientId
					AND ISNULL(CCP.RecordDeleted,''N'')<>''Y'')
			JOIN ClientCoverageHistory CCH	
				ON (CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId	
					AND CCH.StartDate <= SS.DateOfService
					AND ( CCH.EndDate IS NULL
					OR CCH.EndDate >= SS.DateOfService)
					AND ISNULL(CCH.RecordDeleted,''N'')<>''Y'')
			JOIN CoveragePlans CP
				ON (CP.CoveragePlanId = CCP.CoveragePlanId
					AND	(cp.DisplayAs LIKE ''DFNON%''
					OR cp.DisplayAs LIKE ''MHNON%''
					AND ISNULL(CP.RecordDeleted,''N'')<>''Y'')
				)
			
ORDER BY
	''Client Name''
END
' 
END
GO
