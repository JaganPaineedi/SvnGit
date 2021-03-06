/****** Object:  StoredProcedure [dbo].[csp_GetCustomHarborMedicationList]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomHarborMedicationList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomHarborMedicationList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomHarborMedicationList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure  [dbo].[csp_GetCustomHarborMedicationList]
	@ClientId as int,
	@DateOfService datetime = null
As

Begin
/****************************************************************************/
/* Stored Procedure: csp_GetCustomHarborMedicationList      */
/* Copyright: 2011 Streamline SmartCare          */
/* Creation Date:  07/13/2011            */
/* Purpose: Returns one-row, one-column data table w.r.f #179 in Harbor  */
/* Input Parameters: ClientId            */
/* Output Parameters:              */
/* Return:   Returns one-row, one-column data table w.r.f #179 in Harbor */
/* Called By: ServiceNote.GetCustomHarborMedicationList(int ClientId)  */
/*                   */
/* Calls:                 */
/*                   */
/* Data Modifications:              */
/*                   */
/*   Updates:                */
/*       Date              Author                  Purpose                                    */
/*     7/21/2011    Maninder    To Retrieve Harbor Medication List                                 */
/*		2012.09.04	Get medication list based on date of service (if specified).	*/
/****************************************************************************/

BEGIN TRY

declare @LastMedicationName varchar(100) = ''''
declare @MedicationList varchar(max) = ''''
declare @LastStartDate datetime = ''1/1/1900''

declare @MedicationName varchar(100), @StrengthDescription varchar(100),
	@Quantity decimal(10,2), @Unit varchar(100), @Schedule varchar(100),
	@StartDate datetime, @EndDate datetime, @Prescriber varchar(100)
	
declare cMeds cursor for
select mdm.MedicationName, med.StrengthDescription, cmi.Quantity, gcUnit.CodeName as Unit, gcSched.CodeName as Schedule,
	sc.StartDate, sc.EndDate, ISNULL(st.FirstName + '' '' + st.LastName 
		+ case when LEN(ISNULL(LTRIM(RTRIM(st.SigningSuffix)), '''')) > 0 then '', '' + st.SigningSuffix else '''' end, '''') as Prescriber
from dbo.ClientMedications as cm
join dbo.ClientMedicationInstructions as cmi on cmi.ClientMedicationId = cm.ClientMedicationId
join dbo.MDMedicationNames as mdm on mdm.MedicationNameId = cm.MedicationNameId
join dbo.MDMedications as med on med.MedicationId = cmi.StrengthId
join (
	select cmsd.ClientMedicationInstructionId, cms.OrderingPrescriberId, cmsd.StartDate, cmsd.EndDate
	from dbo.ClientMedicationScriptDrugs as cmsd
	join dbo.ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
	where cms.ClientId = @ClientId
		and ISNULL(cmsd.RecordDeleted, ''N'') <> ''Y''
		and ISNULL(cms.RecordDeleted, ''N'') <> ''Y''
		and not exists (
			select *
			from dbo.ClientMedicationScriptDrugs as cmsd2
			join dbo.ClientMedicationScripts as cms2 on cms2.ClientMedicationScriptId = cmsd2.ClientMedicationScriptId
			where cms2.ClientId = cms.ClientId
			and cmsd2.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
			and ISNULL(cmsd2.RecordDeleted, ''N'') <> ''Y''
			and ISNULL(cms2.RecordDeleted, ''N'') <> ''Y''
			and (
				(cms2.OrderDate > cms.OrderDate)
				or (
					(cms2.OrderDate = cms.OrderDate)
					and (cms2.ClientMedicationScriptId > cms.ClientMedicationScriptId)
				)
			)
	)
) as sc on sc.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
join dbo.Staff as st on st.StaffId = sc.OrderingPrescriberId
LEFT outer join dbo.GlobalCodes as gcUnit on gcUnit.GlobalCodeId = cmi.Unit
LEFT outer join dbo.GlobalCodes as gcSched on gcSched.GlobalCodeId = cmi.Schedule
where cm.ClientId = @ClientId
and cm.Ordered = ''Y''
and ISNULL(cm.Discontinued,''N'') <> ''Y''
and cmi.Active = ''Y''
and ISNULL(cm.RecordDeleted, ''N'') <> ''Y''
and ISNULL(cmi.RecordDeleted, ''N'') <> ''Y''
-- added to remove issue with old data creeping into the list
and exists (
	select * from dbo.ClientMedicationScriptDrugs as cmsd
	where cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
	and ISNULL(cmsd.RecordDeleted, ''N'') <> ''Y''
)
and (
	(@DateOfService is null)
	or exists (
		select *
		from dbo.ClientMedicationScripts as cms
		join dbo.ClientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId
		where cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
		and DATEDIFF(DAY, cms.OrderDate, @DateOfService) = 0
		and ISNULL(cms.RecordDeleted, ''N'') <> ''Y''
		and ISNULL(cmsd.RecordDeleted, ''N'') <> ''Y''
	)
	or (
		-- if requesting meds for a specific date of service AND none exist for that date, just bring in everything that was prescribed.
		@DateOfService is not null 
		and not exists (
			select *
			from dbo.ClientMedicationScripts as cms
			join dbo.ClientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId
			join dbo.ClientMedicationInstructions as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
			join dbo.ClientMedications as cm on cm.ClientMedicationId = cmi.ClientMedicationId
			where cms.ClientId = @ClientId
			and DATEDIFF(DAY, cms.OrderDate, @DateOfService) = 0
			and ISNULL(cm.Discontinued, ''N'') <> ''Y''
			and ISNULL(cms.RecordDeleted, ''N'') <> ''Y''
			and ISNULL(cmsd.RecordDeleted, ''N'') <> ''Y''
			and ISNULL(cmi.RecordDeleted, ''N'') <> ''Y''
			and ISNULL(cm.RecordDeleted, ''N'') <> ''Y''
		)
	)
)
order by mdm.MedicationName, sc.StartDate, sc.EndDate, cmi.ClientMedicationInstructionId

open cMeds

fetch cMeds into
	@MedicationName, @StrengthDescription, @Quantity, @Unit, @Schedule, @StartDate, @EndDate, @Prescriber

while @@fetch_status = 0
begin
	if (@MedicationName <> @LastMedicationName) or (@StartDate <> @LastStartDate)
	begin

		if LEN(@MedicationList) > 0
		begin
			set @MedicationList = @MedicationList + CHAR(13) --+ CHAR(10) -- + CHAR(13) + CHAR(10)
		end

		set @MedicationList = @MedicationList + @MedicationName + '' - '' + CONVERT(varchar, @StartDate, 101) + ''-'' + CONVERT(varchar, @EndDate, 101) + ''- '' + @Prescriber + CHAR(13) + CHAR(10)

		set @LastMedicationName = @MedicationName
		set @LastStartDate = @StartDate

	end

	set @MedicationList = @MedicationList + ''       '' + ISNULL(@StrengthDescription, '''') + '' - ''
		+ ISNULL(cast(@Quantity as varchar), '''') + '' - ''
		+ ISNULL(@Unit, '''') + '' - ''
		+ ISNULL(@Schedule, '''') + CHAR(13) + CHAR(10)

	fetch cMeds into
		@MedicationName, @StrengthDescription, @Quantity, @Unit, @Schedule, @StartDate, @EndDate, @Prescriber
end

close cMeds

deallocate cMeds

if @MedicationList = '''' set @MedicationList = ''None Prescribed''

select @MedicationList as [MedicationList]

END TRY
BEGIN CATCH
    DECLARE @Error varchar(8000)
         SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
         + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_GetCustomHarborMedicationList'')
         + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
         + ''*****'' + Convert(varchar,ERROR_STATE())
 RAISERROR
   (
  @Error, -- Message text.
     16,  -- Severity.
     1   -- State.
    );
END CATCH

End

' 
END
GO
