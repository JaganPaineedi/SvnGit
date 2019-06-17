IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientMedicationForPrescriber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientMedicationForPrescriber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientMedicationForPrescriber]  
   @PrescriberId bigint,  
   @LastReviewTime datetime,  
   @ServerTime datetime  
as 

/* 25/4/2016		Anto		Harbor - Support #369,  Added the missed columns in the #ScriptOutput table and returning top 200 records to approve  */
/* 4/Jul/2016		Anto		Harbor - Support #369,  Modified the Column names of the Final result set with the RDLC to bind */
-- ========================================================================================== 
 
  
set nocount on  
  
-- only show activities that occurred on or after this date  
declare @goLiveDate datetime  
set @goLiveDate = '3/24/2009'  
  
-- Identify scripts/activities that need to be returned  
declare @ScriptActivities table (  
   ClientMedicationScriptActivityId int  
)  
  
-- Script Details  
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
   Comments varchar(max), 
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
   SureScriptsRefillRequestId INT,  
   SpecialSummary varchar(max),
   PageNumber INT
)  
  
  
insert into @ScriptActivities (ClientMedicationScriptActivityId)  
select top (200)cmsa.ClientMedicationScriptActivityId  
from ClientMedicationScriptActivities as cmsa  
join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId  
where cms.OrderingPrescriberId = @PrescriberId  
and datediff(day, cmsa.CreatedDate, @goLiveDate) <= 0  
and cmsa.PrescriberReviewDateTime is null  
and isnull(cmsa.RecordDeleted, 'N') <> 'Y'  
and isnull(cms.RecordDeleted, 'N') <> 'Y'  
  
  

declare @currScriptId int, @currLocationId int  
  
declare currScripts cursor for  
select distinct cmsa.ClientMedicationScriptId, cms.LocationId  
from ClientMedicationScriptActivities as cmsa  
join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId  
join @ScriptActivities as a on a.ClientMedicationScriptActivityId = cmsa.ClientMedicationScriptActivityId  
  
open currScripts  
  
fetch currScripts into @currScriptId, @currLocationid  
  
while @@fetch_status = 0  
begin  
     
   insert into #ScriptOutput  
   exec ssp_RDLClientPrescriptionMain  
      @ClientMedicationScriptIds = @currScriptId,  
      @OrderingMethod = 'P',  
      @OriginalData = 1,  
      @LocationId = @currLocationid,  
      @PrintChartCopy = 'no',  
      @SessionId = 'no-session'  
  
  
   fetch currScripts into @currScriptId, @currLocationid  
  
end  
  
close currScripts  
deallocate currScripts  
  
select so.PON,  
max(c.Lastname + ', ' + c.FirstName) as ClientName,  
max(so.MedicationName) as MedicationName,  
max(case when so.SpecialSummary is null then case when so.InstructionSummary is null then '' else 'Qty: ' + so.InstructionSummary end else 'Qty: ' + so.SpecialSummary end) as Quantity,  
max(so.PatientScheduleSummary) as PatientScheduleSummary,  
max(so.SpecialInstructions) as Instructions,  
max(cmsa.CreatedDate) as [Date],  
max(st.LastName + ', ' + st.FirstName) as PrescribedByName,  
max(st2.LastName + ', ' + st2.FirstName) as CreatedBy,  
max(case when cmsa.Method = 'P' then 'Printed' when cmsa.Method = 'F' then 'Fax' when cmsa.Method = 'C' then 'Chart Copy' end) as Method,  
cmsa.ClientMedicationScriptActivityId  
from @ScriptActivities as a  
join ClientMedicationScriptActivities as cmsa on cmsa.ClientMedicationScriptActivityId = a.ClientMedicationScriptActivityId  
join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId  
join Clients as c on c.ClientId = cms.ClientId  
join #ScriptOutput as so on so.ClientMedicationScriptId = cmsa.ClientMedicationScriptId  
join Staff as st on st.StaffId =  cms.OrderingPrescriberId  
left outer join Staff as st2 on st2.usercode = cmsa.CreatedBy  
group by cmsa.ClientMedicationScriptActivityId, so.PON  


GO


