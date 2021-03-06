/****** Object:  StoredProcedure [dbo].[csp_Report_CBay_Client_List]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CBay_Client_List]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CBay_Client_List]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CBay_Client_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_CBay_Client_List]
	@date datetime
AS
--*/

/*
DECLARE	@date datetime
SELECT	@date = ''6/8/12''
*/

/********************************************************/
/* Stored Procedure: csp_Report_CBay_Client_List	*/
/* Creation Date:    03/24/2006				*/
/* Copyright:    Harbor Behavioral Healthcare		*/
/*							*/
/* Purpose: Clinical Reports				*/
/*							*/
/* Called By: CSH Patient List For C Bay.rpt		*/
/*							*/
/* Updates:						*/
/* Date		Author		Purpose			*/
/* 03/24/2006	Jess		Created - WO 		*/
/* 10/25/2006	Jess		Modified - WO 4630	*/
/* 02/22/2007	Jess		Modified - WO 5902	*/
/* 02/27/2007	Jess		Modified - WO 5926	*/
/* 04/19/2007	Jess		Modified - WO 6199	*/
/* 06/11/2007	Jess		Modified - WO 6905	*/
/* 08/07/2007	Jess		Modified - WO 7718	*/
/* 10/05/2007	Jess		Modified - WO 8387	*/
/* 12/06/2007	Jess		Modified - WO 8823	*/
/* 02/19/2008	Jess		Modified - WO 9280	*/
/* 03/26/2008	Jess		Modified - WO 9608	*/
/* 06/27/2008	Jess		Modified - WO 10315	*/
/* 07/28/2008	Jess		Modified - WO 10493	*/
/* 10/11/2010	Jess		Modified - WO 15871	*/
/* 12/02/2010	Jess		Modified - WO 16441	*/
/* 10/19/2011	Jess		Modified - WO 19605	*/
/* 01/05/2012	Jess		Modified - WO 20364	*/
/* 05/23/2012   BrianM		Convert from Psych	(csp_Report_CSH_patient_list_for_C_Bay)	*/
/************************************************/



select 
	C.ClientId,C.LastName + '', '' + C.FirstName AS ''Client'',
	S.DateOfService,S.ProcedureCodeId,PC.DisplayAs,S.ClinicianId,GC.CodeName AS STATUS,

CONVERT(varchar, S.DateOfService, 101) + '' '' +
	case
		when	substring(convert(varchar, S.DateOfService, 108), 1, 2) < 12
		then	substring(convert(varchar, S.DateOfService, 108), 1, 5) + ''AM''
		when	substring(convert(varchar, S.DateOfService, 108), 1, 2) = 12
		then	substring(convert(varchar, S.DateOfService, 108), 1, 5) + ''PM''
		else	convert(varchar(2), substring(convert(varchar, S.DateOfService, 108), 1, 2) - 12) +
				convert(varchar(3), substring(convert(varchar, S.DateOfService, 108), 3, 3)) + ''PM''
	END AS proc_chron,S.ServiceId,SF.LastName + '', '' + SF.FirstName as ''Staff'',
	
	CASE
		WHEN	PC.DisplayAs like ''PED_EST%''
		THEN	''DEVP_MED_I''
		WHEN	PC.DisplayAs like ''PED_CON%''
		THEN	''DEVP_CONSI''
		WHEN	PC.DisplayAs  like ''PSYCH_EVAL''
		THEN	''PSYCH EVAL''
	END AS ''Document Code''
FROM  Services S
JOIN ProcedureCodes PC
	ON (PC.ProcedureCodeId = S.ProcedureCodeId
	AND ISNULL(PC.RecordDeleted,''N'')<>''Y'') 
JOIN GlobalCodes GC
	ON (GC.GlobalCodeId = s.Status  
	AND ISNULL(GC.RecordDeleted,''N'')<>''Y'')
JOIN Clients C
	ON (C.ClientId = S.ClientId
	AND ISNULL(C.RecordDeleted,''N'')<>''Y'')
JOIN Staff SF
	ON (SF.StaffId = S.ClinicianId
	AND ISNULL(SF.RecordDeleted,''N'')<>''Y'') 

WHERE 
CONVERT(VARCHAR, DateOfService, 112)= @date
AND SF.StaffId in(
				''653'',	-- Khawaja Shahzad
				''678'',	-- Olatunde Fatinikun
				''614'',   -- Vishwas Mashalkar
				''774'',  -- J. Michael Walker
				''796'',  -- Bruce Pasch
				''189'',  -- Diane Hysell
				''156'',  -- Jaylata Patel
				''792'',  -- Wendy Bauer
				''153'',  -- Deborah Morgal
				''957'',  -- Tufal Khan
				''756'',  -- Paul Mitch
				''171'',  -- Pratap Torsekar
				''1092'', -- Amor Bouraoui-Karoui
				''1120'', -- Gayle Ruggiero
				''1095'', -- Sarah Adlakha
				''1124'', -- Carol Krieger
				''1094'', -- Chandan Nayak 
				''1100'', -- Lori Wilmarth
				''1033'', -- Tanvir Singh
				''1005'', -- Sreekanth Indurti
				''770'',  -- Coleen Shaw
				''797'',  -- Cuneyd Tolek
				''1199'', -- Sahaja Reddy
				''1210'', -- Jean Molitor
				''1244'', -- Afia Hussain
				''1245'', -- Irfan Ahmed
				''1307'', -- Bushra Qureishi
				''1395'', -- Lucia Coleman
				''755'',  -- Brad Olson
				''1119''  -- Wissam Hoteit
			)

AND	GC.CodeName in (''Complete'',''Show'',''Scheduled'')
AND	(	PC.DisplayAs like (''PED_EST%'')
	OR	PC.DisplayAs like (''PED_CON%'')
	OR	PC.DisplayAs like (''PSYCH_EVAL'')
	)
AND	NOT	(SF.StaffId in (''653'',''678'') --Khawaja Shahzad,Olatunde Fatinikun	
AND	PC.DisplayAs in (''med_ind'',''med_youth'')
	)
ORDER BY SF.LastName,SF.FirstName,S.DateOfService

' 
END
GO
