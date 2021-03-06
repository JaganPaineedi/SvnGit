/****** Object:  StoredProcedure [dbo].[csp_ReportMMClientsByDrugCategory]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMMClientsByDrugCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMMClientsByDrugCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMMClientsByDrugCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ReportMMClientsByDrugCategory]
(
@StartDate datetime,
@EndDate datetime
)
as 
/*
/	Purpose: 
/	Created Date		Created BY
/
/   modified date		Modified by
/	7/22/2008			avoss
/   added joins for cmsd and cms for order date 
/
*/


select Distinct
dc.DrugCategory,
dc.SecondaryGrouping,
cm.ClientId,
c.LastName + '', '' + c.Firstname as ClientName,
mn.MedicationName, --cm.MedicationNameId,
cm.PrescriberName

from ClientMedications as cm
join ClientMedicationInstructions as cmi on cmi.ClientMedicationId = cm.ClientMedicationId
	and isnull(cmi.RecordDeleted,''N'') <> ''Y''
left join GlobalCodes as gcU on gcU.GlobalCodeId = cmi.Unit and isnull(gcU.RecordDeleted,''N'') <> ''Y''
left join GlobalCodes as gcS on gcS.GlobalCodeId = cmi.Schedule and isnull(gcS.RecordDeleted,''N'') <> ''Y''
left join MDMedications m on m.MedicationId = cmi.StrengthID and isnull(m.RecordDeleted, ''N'')<> ''Y''
join MDMedicationNames as mn on mn.MedicationNameId = cm.MedicationNameId
	and isnull(mn.RecordDeleted,''N'') <> ''Y''
join clientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
	and isnull(cmsd.RecordDeleted,''N'') <> ''Y''  --av
join clientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
	and isnull(cms.RecordDeleted,''N'') <> ''Y'' --av
join CustomReportMMClientByDrugCategory dc on mn.medicationname like '''' + dc.namelike + ''%''
join Clients c on c.clientid = cm.ClientId

where isnull(cm.RecordDeleted,''N'') <> ''Y''
and cms.OrderDate >= @StartDate --av
and (cms.OrderDate <= @EndDate or cms.OrderDate is null) --av

order by dc.DrugCategory, c.LastName +'', '' + c.FirstName, mn.MedicationName


select top 1 * from clientMedications
select top 1 * from clientMedicationScripts
select top 1 * from clientMedicationScriptDrugs
select top 1 * from clientMedicationInstructions
' 
END
GO
