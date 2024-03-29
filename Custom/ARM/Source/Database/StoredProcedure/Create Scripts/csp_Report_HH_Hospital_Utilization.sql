/****** Object:  StoredProcedure [dbo].[csp_Report_HH_Hospital_Utilization]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_HH_Hospital_Utilization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_HH_Hospital_Utilization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_HH_Hospital_Utilization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_HH_Hospital_Utilization]
	@ClientId	int
AS
--*/
/********************************************************************/
/* Stored Procedure: csp_Report_HH_Hospital_Utilization			   */
/* Copyright:        Harbor											*/
/*					           										*/
/* Author:		Ryan Mapes  									*/
/* Create date: 11/28/2012		    								*/
/* Description:	Generate report of clients from the                   */
/* Custom_HH_Data_Exchange_Hospital_Utilization table.              */
/*																	*/
/********************************************************************/
/*
	DECLARE
	@ClientId int
	SELECT
	@ClientId=''43687''
--*/

SELECT c.ClientId, pg.ProgramName, c.Hospital,c.ADMPRIICD9FMT, c.ADMPRIDXNM, c. ADMSECICD9FMT,c.ADMSECDXNM, c.DISPRIICD9FMT, c.DISPRIDXNM, c.DISSECICD9FMT, c.DISSECDXNM, CAST (c.DOA AS DateTime) AS ''DOA'', CAST(c.DISDATE AS DateTime)AS''DISDATE'', c.LOS 



From dbo.Custom_HH_Data_Exchange_Hospital_Utilization c



--LEFT JOIN dbo.Clients cl

--ON cl.SSN=c.SSN

----LEFT JOIN dbo.staff s

----ON cl.PrimaryClinicianId=s.StaffID


JOIN ClientPrograms cp

ON cp.ClientId = c.ClientId

JOIN Programs pg

ON pg.ProgramId = cp.ProgramId 



Where c.ClientId LIKE @ClientId


AND pg.ProgramId IN (444, 445) -- 6 HH Medicaid SPMI & 6 HH Medicaid SED Program Codes



' 
END
GO
