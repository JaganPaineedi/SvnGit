/****** Object:  StoredProcedure [dbo].[csp_job_FillPrescriberApprovalStage]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_FillPrescriberApprovalStage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_job_FillPrescriberApprovalStage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_FillPrescriberApprovalStage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_job_FillPrescriberApprovalStage] as

declare @scriptsToGenerate table (
   ClientMedicationScriptId int primary key,
   LocationId int
)
set nocount on

create table #ScriptOutput (
   OrganizationName varchar(50),
   ClientMedicationScriptId int,
   OrderingMethod varchar(5),
   CopyType varchar(20),
   PON varchar(50),
   InsrtuctionMultipleStrengthGroupId int,
   AllergyList varchar(1000),
   ClientId int,
   ClientName varchar(300),   
   ClientAddress varchar(500),    
   ClientHomePhone varchar(20),    
   ClientDOB datetime,
   LocationAddress varchar(500),    
   LocationName varchar(200),    
   LocationPhone varchar(20),    
   LocationFax varchar(20),    
   PharmacyName varchar(700),    
   PharmacyAddress varchar(500),    
   PharmacyPhone varchar(20),    
   PharmacyFax varchar(20),
   ClientMedicationInstructionId int,
   ScriptOrderedDate datetime,
   MedicationName varchar(max),
   InstructionSummary varchar(max),
   PatientScheduleSummary varchar(max),
   OrderDate datetime,
   DrugStartDate datetime,
   DrugEndDate datetime,
   Refills varchar(100),
   DurationDays int,
   DAW varchar(max),
   SpecialInstructions varchar(max),
   OrderStatus varchar(max),
   Titration char(1),
   Multiples char(1),
   SingleLine char(1),
   PrescriberId int,
   Prescriber varchar(max),
   Creator varchar(500),
   CreatedBy varchar(30),
   SignatureFacsimile image,
   PrintDrugInformation char(1),
   OriginalData int,
   PrintChartCopy char(5),
   C2Meds varchar(1),
   Message1 varchar(max),
   Message2 varchar(max),
   ShowCoverLetter char(1),
   FaxFlag char(1),
   PharmacyCoverLetters int,
   OhioBoardCertDate datetime,
   SpecialSummary varchar(max),
   PageNumber int
)

declare @goLiveDate datetime
set @goLiveDate = ''5/3/2010''

insert into @scriptsToGenerate(ClientMedicationScriptId, LocationId)
select distinct cms.ClientMedicationScriptId, cms.LocationId
from ClientMedicationScriptActivities as cmsa
join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
where datediff(day, cmsa.CreatedDate, @goLiveDate) <= 0
and cmsa.PrescriberReviewDateTime is null
and isnull(cmsa.RecordDeleted, ''N'') <> ''Y''
and isnull(cms.RecordDeleted, ''N'') <> ''Y''
and datediff(second, cms.CreatedDate, getdate()) > 60 -- at least a minute old
and not exists (
   select * from CustomHarborPrescriberApprovalStage as s where s.ClientMedicationScriptId = cms.ClientMedicationScriptId
)

declare @currScriptId int, @currLocationId int

declare currScripts cursor for
select ClientMedicationScriptId, LocationId
from @scriptsToGenerate

open currScripts

fetch currScripts into @currScriptId, @currLocationid

while @@fetch_status = 0
begin
   
   insert into #ScriptOutput
   exec csp_RDLClientPrescriptionMain
      @ClientMedicationScriptIds = @currScriptId,
      @OrderingMethod = ''P'',
      @OriginalData = 1,
      @LocationId = @currLocationid,
      @PrintChartCopy = ''no'',
      @SessionId = ''no-session''


   fetch currScripts into @currScriptId, @currLocationid

end

close currScripts
deallocate currScripts


-- now populate the permanent table
insert into CustomHarborPrescriberApprovalStage (
   ClientMedicationScriptId,
   PON,
   MedicationName,
   InstructionSummary,
   PatientScheduleSummary,
   SpecialSummary,
   SpecialInstructions
)
select
   a.ClientMedicationScriptId,
   a.PON,
   max(a.MedicationName),
   max(a.InstructionSummary),
   a.PatientScheduleSummary,
   max(a.SpecialSummary),
   max(a.SpecialInstructions)
from #ScriptOutput as a
group by 
   a.ClientMedicationScriptId,
   a.PON,
   a.PatientScheduleSummary

' 
END
GO
