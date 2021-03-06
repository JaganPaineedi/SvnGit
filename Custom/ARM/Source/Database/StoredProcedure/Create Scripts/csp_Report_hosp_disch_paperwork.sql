/****** Object:  StoredProcedure [dbo].[csp_Report_hosp_disch_paperwork]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_hosp_disch_paperwork]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_hosp_disch_paperwork]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_hosp_disch_paperwork]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_hosp_disch_paperwork] 
	-- Add the parameters for the stored procedure here
	@location	int,
	@start_date	datetime,
	@end_date	datetime
AS
--*/
/********************************************************************/
/* Stored Procedure: csp_Report_hosp_disch_paperwork				*/
/* Creation Date:    06/13/2006										*/
/*																	*/
/* Updates:															*/
/* Date			Author		Purpose									*/
/*  06/13/2012  Brian M		Coverted from PsychConsult				*/
/*  02/28/2013	MSR			Added Document Code 1000365	& 1000366	*/
/*	03/11/2013	MSR			Added Location temptable and link		*/
/********************************************************************/
/*
DECLARE	@location	int,
	@start_date	datetime,
	@end_date	datetime

SELECT	
	@location =	0,
	--@location = ''Secor'',
	@start_date = 	''12/27/12'',
	@end_date =	''2/28/13''
--*/

SET NOCOUNT ON;	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
   
-- ** Created 03/11/2013 to use Location drop down on report **    
declare @TempLocation table
(
	LocationId		Int,
	LocationName	Varchar(50)
)   

If @location = 0 begin
insert into @TempLocation 
select l.LocationId, l.LocationCode from Locations l where l.Active = ''Y''
end

if @location <> 0 begin
insert into @TempLocation 
select l.LocationId, l.LocationCode from Locations l where l.LocationId = @location
end
-- ************************************************************      
   
SELECT DISTINCT
	C.ClientId,
	C.LastName+ '', '' + C.FirstName AS ''Client'',
	PC.ProcedureCodeName,
	DC.DocumentName,
	Case When D.Status = ''22''
		Then
			convert(varchar,D.ModifiedDate, 101) --AS ''Document Completed Date'',-- Completed date = ModifiedDate and status signed???
		Else
			NULL
		End As ''Document Completed Date'',	
	L.LocationName,
	S.LastName + '', '' +	S.FirstName AS ''Clinician''
	
FROM Services SS 
	JOIN Locations L
		ON	(L.LocationId = SS.LocationId
		AND	L.LocationCode in (select t.LocationName from @TempLocation t) -- Changed 03/11/2013 to use location pulldown
		AND ISNULL(L.RecordDeleted,''N'')<>''Y'')
	JOIN ProcedureCodes PC
		ON (PC.ProcedureCodeId = SS.ProcedureCodeId
		AND PC.ProcedureCodeId = ''318''
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')
	JOIN Clients C
		ON	(C.ClientId = SS.ClientId
		--AND C.Active = ''Y''				Active Clients only???
		AND ISNULL(C.RecordDeleted,''N'')<>''Y'')
	LEFT JOIN Documents D				
		ON (SS.ClientId = D.ClientId	
		--AND (D.DocumentCodeId = ''1000115'' -- ''Hospital Discharge'' -- comment out 03/01/2013 per Jess Bringolf
		--OR	D.DocumentCodeId = ''1000129'' -- ''Rescue Discharge (Scanned)'' -- comment out 03/01/2013 per Jess Bringolf
		AND	(d.DocumentCodeId = ''1000365'' -- ''OR:I; Hospital Discharge''	-- Added 02/28/2013 per request by Donna Corsoe
		OR d.DocumentCodeId = ''1000366'') -- OR:I; Rescue Discharge Papers (Scanned)	-- Added 02/28/2013 per request by Donna Corsoe
		AND	D.Status <> ''23''			  --''ER'' Does Cancelled replace ER?
		AND ISNULL(D.RecordDeleted,''N'')<>''Y'')
	LEFT JOIN DocumentCodes DC
		ON (DC.DocumentCodeId  = D.DocumentCodeId	
		AND ISNULL(DC.RecordDeleted,''N'')<>''Y'')
	JOIN Staff S 
		ON	(S.StaffId = SS.ClinicianId
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
WHERE	SS.Status <>  ''76''  --''ER''
--	AND SS.Status <> ''73''  -- ''Cancelled''
--	AND SS.Status <> ''72'' -- no Show
	AND	SS.DateOfService >= @start_date
	AND SS.DateOfService < DATEADD (dd,1,@end_date)
	AND ISNULL(SS.RecordDeleted,''N'')<>''Y''

ORDER BY
	''Client''' 
END
GO
