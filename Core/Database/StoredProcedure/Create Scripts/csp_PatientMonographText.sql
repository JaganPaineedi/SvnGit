IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[csp_PatientMonographText]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[csp_PatientMonographText]
GO


/****** Object:  StoredProcedure [dbo].[csp_PatientMonographText]    Script Date: 11/22/2011 11:53:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
CREATE procedure [dbo].[csp_PatientMonographText]      
/************************************************************************************/      
/* Purpose:  Used by the medications management to collect the monograph text lines */      
/* for patient education monographs and format them into text blocks associated  */      
/* with each drug in the script.             */      
/*                     */      
/* Created By: Tom Remisoski              */      
/* Modified By: avoss --Set parameters and Conditions for returning results   */      
/************************************************************************************/      
(      
@ClientMedicationScriptIds int           
,@OrderingMethod char(1)          
,@OriginalData int       
,@LocationId int        
,@PrintChartCopy char(5)        
,@SessionId varchar(24),
 @RefillResponseType char(1) = null
       
)-- rename this to the parameter name used by med management      
 -- add the output method parameter      
as       
/*      
select       
null as ResultId,       
null as MedicationName,       
null as PatientEducationMonographText,      
'N' as PrintDrugInformation      
*/      
      
set nocount on      
      
--declare @ScriptId int set @ScriptId = @ClientMedicationScriptIds      
      
declare @results table      
(      
 ResultId int identity (1,1),      
 MedicationName varchar(100) null,      
 PatientEducationMonographId int null,      
 PatientEducationMonographText varchar(max),      
 PrintDrugInformation char(1)      
)      
      
      
declare @Create char(1)      
--declare @OriginalData int        
--      
--if @ClientMedicationScriptIds < 1000       
--begin       
--Set @OriginalData = 0       
--end      
--      
--if @ClientMedicationScriptIds > 1000       
--begin      
--set @OriginalData = 1       
--end      
      
      
      
--      
-- Get distinct monographs so only printing one per medication name      
--      
if ( @OriginalData >= 1 )      
begin      
insert into @results(MedicationName, PatientEducationMonographId, PatientEducationMonographText, PrintDrugInformation)      
select distinct mn.MedicationName, l.PatientEducationMonographId, '', cms.PrintDrugInformation      
from dbo.ClientMedicationScripts as cms      
join dbo.ClientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId      
join dbo.ClientMedicationInstructions as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId      
join dbo.ClientMedications as cm on cm.ClientMedicationId = cmi.ClientMedicationId      
join dbo.MDMedications as m on m.MedicationId = cmi.StrengthId      
join dbo.MDMedicationNames as mn on mn.MedicationNameId = m.MedicationNameId      
left join MDPatientEducationMonographFormulations as l on l.ClinicalFormulationId = m.ClinicalFormulationId      
--left join dbo.MDClinicalFormulationToPatientEducationMonographsLink as l on l.ClinicalFormulationId = m.ClinicalFormulationId      
where cms.ClientMedicationScriptId = @ClientMedicationScriptIds      
and isnull(cms.RecordDeleted, 'N') <> 'Y'      
and isnull(cmsd.RecordDeleted, 'N') <> 'Y'      
and isnull(cm.RecordDeleted, 'N') <> 'Y'      
and isnull(cmi.RecordDeleted, 'N') <> 'Y'      
and isnull(m.RecordDeleted, 'N') <> 'Y'      
and isnull(l.RecordDeleted, 'N') <> 'Y'      
      
select @Create = isnull(PrintDrugInformation,'N')      
from ClientMedicationScripts where ClientMedicationScriptId = @ClientMedicationScriptIds      
      
end      
      
if (isnull(@OriginalData,0) = 0)        
begin       
      
insert into @results(MedicationName, PatientEducationMonographId, PatientEducationMonographText, PrintDrugInformation)      
select distinct mn.MedicationName, l.PatientEducationMonographId, '', cms.PrintDrugInformation      
from dbo.ClientMedicationScriptsPreview as cms      
join dbo.ClientMedicationScriptDrugsPreview as cmsd on cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId      
join dbo.ClientMedicationInstructionsPreview as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId      
join dbo.ClientMedicationsPreview as cm on cm.ClientMedicationId = cmi.ClientMedicationId      
join dbo.MDMedications as m on m.MedicationId = cmi.StrengthId      
join dbo.MDMedicationNames as mn on mn.MedicationNameId = m.MedicationNameId      
left join MDPatientEducationMonographFormulations as l on l.ClinicalFormulationId = m.ClinicalFormulationId      
--left join dbo.MDClinicalFormulationToPatientEducationMonographsLink as l on l.ClinicalFormulationId = m.ClinicalFormulationId      
where cms.ClientMedicationScriptId = @ClientMedicationScriptIds      
and isnull(cms.RecordDeleted, 'N') <> 'Y'      
and isnull(cmsd.RecordDeleted, 'N') <> 'Y'      
and isnull(cm.RecordDeleted, 'N') <> 'Y'      
and isnull(cmi.RecordDeleted, 'N') <> 'Y'      
and isnull(m.RecordDeleted, 'N') <> 'Y'      
and isnull(l.RecordDeleted, 'N') <> 'Y'      
      
select @Create = isnull(PrintDrugInformation,'N')      
from ClientMedicationScriptsPreview where ClientMedicationScriptId = @ClientMedicationScriptIds      
      
end      
      
--if exists (select * from @Results where PrintDrugInformation = 'Y')       
if @Create = 'Y'      
begin       
--      
-- get the monograph text      
--      
declare @ResultId int, @PatientEducationMonographId int      
      
declare @PrefixString varchar(128)      
      
declare cRes cursor for      
select ResultId, PatientEducationMonographId      
from @results      
      
open cRes      
      
fetch cRes into @ResultId, @PatientEducationMonographId      
      
while @@fetch_status = 0      
begin      
      
 declare @MonographText varchar(250)      
      
 declare cMono cursor for      
 select MonographText      
 from dbo.MDPatientEducationMonographText      
 where PatientEducationMonographId = @PatientEducationMonographId      
 and LineIdentifier <> 'Z'      
 order by TextSequenceNumber      
      
 open cMono      
      
 fetch cMono into @MonographText      
      
 while @@fetch_status = 0      
 begin      
      
  -- text lines that begin with three spaces indicate a paragraph marker      
  if (@MonographText like '   %') set @PrefixString = char(13) + char(10)      
  -- text line that are completely empty indicate a "section break"      
  else if (len(@MonographText) = 0) set @PrefixString = char(13) + char(10) + char(13) + char(10)      
  else set @PrefixString = ' '      
      
  update @results set PatientEducationMonographText = PatientEducationMonographText + @PrefixString + @MonographText      
  where ResultId = @ResultId      
      
  fetch cMono into @MonographText      
 end      
      
 close cMono      
      
 deallocate cMono      
      
 fetch cRes into @ResultId, @PatientEducationMonographId      
      
end      
      
close cRes      
      
deallocate cRes      
end      
      
      
      
if @OrderingMethod <> 'F' and @Create = 'Y'      
Select       
ResultId,       
MedicationName,       
PatientEducationMonographText,      
PrintDrugInformation      
From @Results      
--if @OrderingMethod <> 'P' or @Create = 'N' select null      
if @OrderingMethod = 'F'       
select  '* End Transmission *' as PatientEducationMonographText, 'Y' as PrintDrugInformation      
      
if @Create = 'N' and @OrderingMethod <> 'F'       
select null      
      
return 
GO


