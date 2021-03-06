/****** Object:  StoredProcedure [dbo].[csp_SetClientPopulationFlags]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SetClientPopulationFlags]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SetClientPopulationFlags]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SetClientPopulationFlags]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure
[dbo].[csp_SetClientPopulationFlags]
AS


Begin Tran

--
-- Set all system determined flags to null (just in case a dx document gets deleted since the last run)
--
update CustomTimeliness set ServicePopulationMI = null, ServicePopulationDD = null

--
-- if the most recent diagnosis document for the episode has a DD diagnosis, set the flag
--
update ct set
   ServicePopulationDD = ''Y''
from CustomTimeliness as ct
join ClientEpisodes as ce on ce.ClientEpisodeId = ct.ClientEpisodeId
where isnull(ce.RecordDeleted, ''N'') <> ''Y''
and isnull(ct.RecordDeleted, ''N'') <> ''Y''
and exists (
   select *
   from Documents as d
   join DiagnosesIAndII as dx on dx.DocumentVersionId = d.CurrentDocumentVersionId 
   where d.ClientId = ce.ClientId
   and d.DocumentCodeId = 5
   and d.status = 22
   and (dx.DSMCode like ''317%'' or dx.DSMCode like ''318%'' or dx.DSMCode like ''319%'' or dx.DSMCode like ''299.%'')
   and isnull(dx.RuleOut, ''N'') <> ''Y''
   --and d.EffectiveDate >= ce.RegistrationDate
   and ((d.EffectiveDate <= ce.DischargeDate) or (ce.DischargeDate is null))
   and isnull(d.RecordDeleted, ''N'') <> ''Y''
   and isnull(dx.RecordDeleted, ''N'') <> ''Y''
   and not exists (
      select *
      from Documents as d2
       join DiagnosesIAndII as dx2 on dx2.DocumentVersionId = d2.CurrentDocumentVersionId 
      where d2.ClientId = ce.ClientId
      and d2.DocumentCodeId = 5
	  and d2.status = 22
      --and d2.EffectiveDate >= ce.RegistrationDate
      and ((d2.EffectiveDate <= ce.DischargeDate) or (ce.DischargeDate is null))
      and ((d2.EffectiveDate > d.EffectiveDate) or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))
      and isnull(d2.RecordDeleted, ''N'') <> ''Y''
      and isnull(dx2.RecordDeleted, ''N'') <> ''Y''
   )
)

--
-- if the most recent diagnosis document for the episode has an MI diagnosis, set the flag
--
update ct set
   ServicePopulationMI = ''Y''
from CustomTimeliness as ct
join ClientEpisodes as ce on ce.ClientEpisodeId = ct.ClientEpisodeId
where isnull(ce.RecordDeleted, ''N'') <> ''Y''
and isnull(ct.RecordDeleted, ''N'') <> ''Y''
and exists (
   select *
   from Documents as d
   join DiagnosesIAndII as dx on dx.DocumentVersionId = d.CurrentDocumentVersionId 
   where d.ClientId = ce.ClientId
   and d.DocumentCodeId = 5
   and d.status = 22
   and (dx.DSMCode like ''295%'' or dx.DSMCode like ''296%'' or dx.DSMCode like ''297%'' or dx.DSMCode like ''300%'' or dx.DSMCode like ''301%'' or dx.DSMCode like ''302%''
				or dx.DSMCode like ''307%'' or dx.DSMCode like ''309%'' or dx.DSMCode like ''312%'' or dx.DSMCode like ''313%'' or dx.DSMCode like ''314%'' or dx.DSMCode like ''308%''
				or dx.DSMCode like ''311%'' or dx.DSMCode like ''298%'' or dx.DSMCode like ''294%'' or dx.DSMCode like ''293%'')
   and isnull(dx.RuleOut, ''N'') <> ''Y''
   --and d.EffectiveDate >= ce.RegistrationDate
   and ((d.EffectiveDate <= ce.DischargeDate) or (ce.DischargeDate is null))
   and isnull(d.RecordDeleted, ''N'') <> ''Y''
   and isnull(dx.RecordDeleted, ''N'') <> ''Y''
   and not exists (
      select *
      from Documents as d2
      join DiagnosesIAndII as dx2 on dx2.DocumentVersionId = d2.CurrentDocumentVersionId 
      where d2.ClientId = ce.ClientId
      and d2.DocumentCodeId = 5
	  and d2.status = 22
      --and d2.EffectiveDate >= ce.RegistrationDate
      and ((d2.EffectiveDate <= ce.DischargeDate) or (ce.DischargeDate is null))
      and ((d2.EffectiveDate > d.EffectiveDate) or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))
      and isnull(d2.RecordDeleted, ''N'') <> ''Y''
      and isnull(dx2.RecordDeleted, ''N'') <> ''Y''
   )
)

update customTimeliness
set ServicePopulationDD = ''N'' where servicePopulationDD is null

update customTimeliness
set ServicePopulationMI = ''N'' where servicePopulationMI is null

if @@error <> 0
	Begin
		Rollback
	End

Commit Tran
' 
END
GO
