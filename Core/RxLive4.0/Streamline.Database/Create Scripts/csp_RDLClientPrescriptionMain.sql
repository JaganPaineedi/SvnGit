/****** Object:  StoredProcedure [dbo].[csp_RDLClientPrescriptionMain]    Script Date: 03/18/2009 08:18:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[csp_RDLClientPrescriptionMain]  
  
@ClientMedicationScriptIds int,     
 @OrderingMethod char(1),    
 @OriginalData int,    
 @LocationId int ,  
 @PrintChartCopy char(5),  
 @SessionId varchar(24)  
  
as  
/*  
--use summitStreamlineDev  
select * from ClientMedicationScripts  
where createddate >= '4/8/2008'  
order by createddate desc  
--138455 --Titrate and double order, 138461 --all  
  
exec csp_RDLClientPrescriptionMain   @ClientMedicationScriptIds = 138461 --138410 titration --116735 old script, --138409 new double script  
 ,@OrderingMethod = 'C'    
 ,@OriginalData =1     
 ,@LocationId = 57  
 ,@PrintChartCopy = 'True'  
,@SessionId = 'abcdefghijklmnopqrstuvwx'  
  
exec csp_RDLClientPrescriptionMainDev  
--select * from staff where lastname like 'perm%'  
  
declare   
 @ClientMedicationScriptIds int,     
 @OrderingMethod char(1),    
 @OriginalData int,    
 @LocationId int ,  
 @PrintChartCopy char(1),  
 @SessionId varchar(24)  
  
select    
  @ClientMedicationScriptIds = 138855--138850--138461 --138410 titration --116735 old script, --138409 new double script  
 ,@OrderingMethod = 'P'    
 ,@OriginalData =1     
 ,@LocationId = 98  
 ,@PrintChartCopy = 'Y'  
 ,@SessionId = 'abcdefghijklmnopqrstuvwx'  
*/  
/*exec csp_RDLClientPrescriptionMainTest 228, 'F'      
Purpose Main Dataset for Med. Management Precription       
--Testing      
declare @ClientMedicationScriptIds int, @OrderingMethod char(1)      
set @ClientMedicationScriptId = 5      
set @OrderingMethod = 'P'      
*/      
declare @DrDegree Table (Degree int)  
insert into @DrDegree  
select globalCodeId from globalCodes where globalcodeId in (10060, 10166, 10219, 10227)  
  
declare @PON int  
Declare @StartDate  Datetime    
Set @StartDate = '04/9/2008'   
  
if @PrintChartCopy in ('True', 'False')  
 begin set @PrintChartCopy = 'Y' end  
  
  
create table #ClientScriptInstructions (  
 ClientMedicationScriptId int  
,OrderingMethod varchar(5)  
,CopyType varchar(20)  
,ScriptOrderedDate datetime  
,PON int  
,ClientMedicationInstructionId int  
,MedicationName varchar(max)  
,StrengthId int  
,InstructionStrengthDescription varchar(max)   
,InstructionSummary varchar(max)  
,PatientScheduleSummary varchar(max)  
,DisbursedAmount dec(10,2)  
,UnitScheduleString varchar(max)  
,UnitValue varchar(max)  
,UnitValueString varchar(2)  
,ScheduleValue varchar(max)  
,TitrationStepNumber int  
,MedicationStartDate datetime  
,MedicationEndDate datetime  
,OrderDate datetime  
,Quantity decimal(10,2)  
,SchedValueMultiplier decimal(10,2)  
,TotalQuantity varchar(max) --decimal(10,2)  
,DrugStartDate datetime  
,DrugEndDate datetime  
,Refills decimal(10,2)  
,DurationDays int  
,Pharmacy decimal(10,2)  
,Sample decimal(10,2)  
,Stock decimal(10,2)  
,DAW varchar(max)  
,SpecialInstructions varchar(max)  
,OrderStatus varchar(max)  
)  
  
create table #ClientScriptInstructionResults (  
 ClientMedicationScriptId int  
,OrderingMethod varchar(5)  
,CopyType varchar(20)  
,ScriptOrderedDate datetime  
,PON int  
,InsrtuctionMultipleStrengthGroupId int  
,ClientMedicationInstructionId int  
,MedicationName varchar(max)  
,InstructionSummary varchar(max)  
,PatientScheduleSummary varchar(max)  
,OrderDate datetime  
,DrugStartDate datetime  
,DrugEndDate datetime  
,Refills decimal(10,2)  
,DurationDays int  
,DAW varchar(max)  
,SpecialInstructions varchar(max)  
,OrderStatus varchar(30)  
,Titration char(1)  
,Multiples char(1)  
,SingleLine char(1)  
)  
  
create table #QuantitySummary (  
InsrtuctionMultipleStrengthGroupId int,  
ClientMedicationInstructionId int,   
PON int,   
StrengthId int,   
TitrationStepNumber int,  
DurationDays int,   
Quantity decimal(10,2),   
Pharmacy decimal(10,2),   
TotalQuantity decimal(10,2),   
Sample decimal(10,2),   
Stock decimal(10,2),   
DisbursedAmount decimal(10,2),   
DisbursedTotal decimal(10,2),  
DisbursedFlag char(1),  
PharmacyTotal decimal(10,2),  
GroupTotal decimal(10,2),  
DrugStartDate datetime,   
DrugEndDate datetime,   
Refills decimal(10,2),   
Titration char(1),   
Multiples char(1),   
SingleLine char(1)  
)    
create Table #ScriptHeader (  
OrganizationName varchar(500),  
ClientMedicationScriptId int,  
OrderingMethod char(1),       
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
PharmacyFax varchar(20)   
)  
  
create table #ScriptSignatures (  
ClientMedicationScriptId int,      
OrderingMethod char(1),  
PrescriberId int,       
Prescriber varchar(500),       
Creator varchar(500),      
CreatedBy varchar(30),      
SignatureFacsimile image,      
PrintDrugInformation char(1)  
)  
  
  
declare @TitrationPONs table(PON int, Titration char(1))  
declare @StrengthGroupInstructionIds table (StrengthId int, ClientMedicationInstructionId int)  
declare  @TitrationInstructions Table (PON int, TitrationInstruction varchar(max), TitrationStartDate datetime, TitrationEndDate datetime, DurationDays int)  
declare @TitrationDays table (PON int, TitrationStepNumber int, DrugStartDate datetime, DrugEndDate datetime, DurationDays int, DayNumber int)  
  
declare @TitrationRecords char(1) ,@MultInstRecords char(1)  
-- Multiples cursor - variables  
declare @MultPON int ,@MultInsrtuctionMultipleStrengthGroupId int ,@MultClientMedicationInstructionId int ,@MultPharmInstructionString varchar(max)  
 ,@MultPatientInstructionSummaryString varchar(max)  
  
declare @TitrationId int  ,@MaxTitrationId int ,@TitrationInstructionString varchar(max)   
,@StepId int ,@MaxStepId int ,@StepNumber int ,@StepInstructionString varchar(max)   
,@TIPon int ,@TIString varchar(max)  
--Titration Tables  
declare @Titrations table (TitrationId int identity ,PON int ,TitrationString varchar(max))  
declare @TitrationSteps table (StepId int identity ,PON int ,StepNumber int ,StepString varchar(max))  
declare @TitrationSummary table (PON int, InsrtuctionMultipleStrengthGroupId int, StrengthId int, InstructionSummary varchar(max))  
  
--Multiple Lines - Titrations Cursor for Finding quantities and grouping  
Declare @PONCur1 int ,@StrengthIdCur1 int ,@TitrationCur1 char(1) ,@MultiplesCur1 char(1) ,@SingleLineCur1 char(1)  
,@IdxCur1 int  
  
--Allergy Loop  
Declare @AllergyList Varchar(1000) ,@AllergyId   int ,@MaxAllergyId int        
declare @AllergyListTable table ( AllergyId int identity, ConceptDescription varchar(200) )    
  
select @StartDate = '04/9/2008' ,@AllergyId = 1       
  
if(@OriginalData > 0)     
begin    
-- Get Client Alergy List      
    Insert into @AllergyListTable      
    (ConceptDescription)      
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009
    --select isnull(ConceptDescription, 'No Known Allergies')      
    select isnull(ConceptDescription, 'No Known Medication/Other Allergies')
    from ClientMedicationScripts as cms      
    join Clients as c on c.ClientId = cms.ClientId and isnull(c.RecordDeleted,'N')<>'Y'      
    left join ClientAllergies as cla on cla.ClientId = c.ClientId       
       and isnull(cla.RecordDeleted,'N')<>'Y'      
    left join MDAllergenConcepts as MDAl on MDAl.AllergenConceptId = cla.AllergenConceptId       
    where isnull(cms.RecordDeleted,'N')<>'Y'      
    and @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009    
    --order by isnull(ConceptDescription, 'No Known Allergies')      
    order by isnull(ConceptDescription, 'No Known Medication/Other Allergies')      
       
    --Find Max Allergy in temp table for while loop      
    Set @MaxAllergyId = (Select Max(AllergyId) From @AllergyListTable)      
       
    --Begin Loop to create Allergy List      
    While @AllergyId <= @MaxAllergyId      
    Begin      
       Set @AllergyList = isnull(@AllergyList, '') +       
       case when @AllergyId <> 1 then ', ' else '' end +       
       (select isnull(ConceptDescription, '')      
       From @AllergyListTable t Where t.AllergyId = @AllergyId)      
       Set @AllergyId = @AllergyId + 1      
    End       
    --End Loop      
        
 --get Client Info    
 insert into #ScriptHeader  
 select       
 (select OrganizationName from SystemConfigurations) as OrganizationName,       
 cms.ClientMedicationScriptId,      
 @OrderingMethod as OrderingMethod,       
 @AllergyList as AllergyList,      
 c.ClientId,       
 c.LastName + ', ' + c.FirstName as ClientName,      
 isnull(ca.Display,'') as ClientAddress,      
 isnull(cph.PhoneNumber,'             ') as ClientHomePhone,      
 c.DOB as ClientDOB,  
 l.Address as LocationAddress,      
 isnull(l.LocationName,'') as LocationName,      
 case when isnull(l.PhoneNumber,'             ') = '' then '             '      
  else isnull(l.PhoneNumber,'           ')+' ' end as LocationPhone,      
 case when isnull(l.FaxNumber,'             ') = '' then '             '       
  else isnull(l.FaxNumber,'             ')+ ' ' end as LocationFax,      
 isnull(p.PharmacyName,'') as PharmacyName,      
 isnull(p.AddressDisplay,'') as PharmacyAddress,      
 case when isnull(p.PhoneNumber,'             ') = '' then '             '      
  else isnull(p.PhoneNumber,'             ')+' ' end as PharmacyPhone,      
 case when isnull(p.FaxNumber,'             ') = '' then '             '       
  else isnull(p.FaxNumber,'             ')+ ' ' end as PharmacyFax    
 from ClientMedicationScripts as cms      
 join Clients as c on c.ClientId = cms.ClientId and isnull(c.RecordDeleted,'N')<>'Y'      
 left join ClientAddresses as ca on ca.ClientId = c.ClientId       
 and ca.AddressType = 90 and isnull(ca.RecordDeleted,'N')<>'Y'      
 left join ClientPhones as cph on cph.ClientId = c.ClientId      
 and cph.PhoneType = 30 and isnull(cph.RecordDeleted,'N')<>'Y'    
 join Locations as l on l.LocationId = cms.LocationId and isnull(l.RecordDeleted,'N')<>'Y'      
 left join Pharmacies as p on p.PharmacyId = cms.PharmacyId         
 where isnull(cms.RecordDeleted,'N')<>'Y'      
 and @ClientMedicationScriptIds = cms.ClientMedicationScriptId    
  
 --Get Signature Info   
 insert into #ScriptSignatures  
 Select distinct  
 cms.ClientMedicationScriptId,      
 @OrderingMethod as OrderingMethod,  
 cm.PrescriberId,       
 case when st.Degree in (select Degree from @DrDegree) then 'Dr. '       
  else case when isnull(st.Sex,'')='M' then 'Mr. '      
  when isnull(st.Sex,'')='F' then 'Ms. ' else '' end  end      
  + case when isnull(st.SigningSuffix,'') = ''       
   then st.FirstName +' '+ st.Lastname + ', ' + stDeg.CodeName       
   else st.FirstName +' '+ st.Lastname + ', ' + st.SigningSuffix end   
  + '     DEA #: ' + isnull(st.DEANumber,'') as Prescriber,       
 case when st.StaffId <> v.StaffId then 'V.O. to & Read Back by: ' +      
  case when isnull(v.Sex,'')='M' then 'Mr. ' +      
   case when isnull(v.SigningSuffix,'') = ''       
    then v.FirstName +' '+ v.Lastname + ', ' + vDeg.CodeName       
    else v.FirstName +' '+ v.Lastname + ', ' + v.SigningSuffix end      
   when isnull(v.Sex,'')='F' then 'Ms. ' +      
    case when isnull(v.SigningSuffix,'') = ''       
     then v.FirstName +' '+ v.Lastname + ', ' + vDeg.CodeName       
     else v.FirstName +' '+ v.Lastname + ', ' + v.SigningSuffix end      
   else case when isnull(v.SigningSuffix,'') = ''       
    then v.FirstName +' '+ v.Lastname + ', ' + vDeg.CodeName       
  else v.FirstName +' '+ v.Lastname + ', ' + v.SigningSuffix end end      
 else '' end as Creator,      
 cms.CreatedBy,      
 sf.SignatureFacsimile,      
 cms.PrintDrugInformation  
 from ClientMedicationScripts as cms      
 join ClientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId      
  and isnull(cmsd.RecordDeleted,'N')<>'Y'      
 join ClientMedicationInstructions as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId       
  and isnull(cmi.RecordDeleted,'N')<>'Y'      
 join ClientMedications as cm on cm.ClientMedicationId = cmi.ClientMedicationId      
  and isnull(cm.RecordDeleted,'N')<>'Y'      
 join Staff as v on v.UserCode = cms.CreatedBy and isnull(v.RecordDeleted,'N')<>'Y'      
 left join globalCodes as vDeg on vDeg.GlobalCodeId = v.Degree   
 join Staff as st on st.StaffId = cm.PrescriberId and isnull(st.RecordDeleted,'N')<>'Y'      
 left join globalCodes as stDeg on stDeg.GlobalCodeId = st.Degree      
 left join StaffSignatureFacsimiles as sf on sf.StaffId = cm.PrescriberId      
 where isnull(cms.RecordDeleted,'N')<>'Y'      
 and @ClientMedicationScriptIds = cms.ClientMedicationScriptId        
  
 /*main*/  
 insert into #ClientScriptInstructions   
 select  
 cms.ClientMedicationScriptId,      
 @OrderingMethod as OrderingMethod,  
 case when @OrderingMethod <> 'C' then 'Prescription' else 'Chart' end as CopyType,   
 cms.OrderDate as ScriptOrderedDate,  
 cm.ClientMedicationId as PON,      
 cmi.ClientMedicationInstructionId,      
 MedName.MedicationName,    
 cmi.StrengthId,   
 MDMeds.StrengthDescription as InstructionStrengthDescription,  
 null as InstructionSummary,   
 null as PatientScheduleSummary,  
 --null as StrengthInstructionSummary,  
 --case when cmsd.Sample + cmsd.Stock = 0 then 'N' else 'Y' end as DisbursedToClient,   
 --case when cmsd.Sample + cmsd.Stock = 0 then null   
 -- else space(2) + '(' + replace(cast((cmsd.Sample + cmsd.Stock) as varchar(10)),'.00','' )  + '  disbursed to client from samples)' end as SamplesToClient,  
 cmsd.Sample + cmsd.Stock as disbursedAmount,  
 gc1.codeName +' '+ gc2.codeName as UnitScheduleString,  
 gc1.codeName as UnitValue,   
 case when gc1.codeName  in ('units', 'each') then '#' else 'x ' end as UnitValueString,   
 gc2.codeName as ScheduleValue,    
 isnull(cmi.TitrationStepNumber,0) as TitrationStepNumber,  
 cm.MedicationStartDate,   
 cm.MedicationEndDate,  
 cms.OrderDate,   
 replace(cmi.Quantity,'.00','') as Quantity,        
 gc2.ExternalCode1 as SchedValueMultiplier,      
 case when cms.CreatedDate < @StartDate   
  then replace(cmi.Quantity,'.00','') * cmsd.Days * gc2.ExternalCode1  
  --else replace(cmsd.pharmacy,'.00','') end as TotalQuantity,      
  else CONVERT(int,cmsd.pharmacy) end as TotalQuantity,   
 cmsd.StartDate as DrugStartDate, --Titration Start (Drug)  
 cmsd.EndDate as DrugEndDate, --Titration End (Drug)     
 replace(cmsd.Refills,'.00','') as Refills,      
 cmsd.Days as DurationDays,      
 replace(cmsd.Pharmacy,'.00','') as Pharmacy,  
 replace(cmsd.Sample,'.00','') as Sample,  
 replace(cmsd.Stock,'.00','') as Stock,  
 case when isnull(cm.DAW,'N') = 'N' then 'Substitutions Allowed'       
  when isnull(cm.DAW,'N') = 'Y' then 'Dispense as Written' End as DAW,      
 cm.SpecialInstructions,  
 case when isnull(CM.Discontinued, 'N') = 'Y' and rtrim(CM.DiscontinuedReason) not in ('Re-Order', 'Change Order')   
  then 'Discontinued'             
  else Case CMS.ScriptEventType  
  When 'N' then 'New' When 'C' then 'Changed' When 'R' then 'Re-Ordered' end end as OrderStatus--,  
 from ClientMedicationScripts as cms     
 join ClientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId and isnull(cmsd.RecordDeleted,'N')<>'Y'      
 join ClientMedicationInstructions as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId and isnull(cmi.RecordDeleted,'N')<>'Y'      
 join ClientMedications as cm on cm.ClientMedicationId = cmi.ClientMedicationId and isnull(cm.RecordDeleted,'N')<>'Y'      
 join MDMedicationNames as MedName on MedName.MedicationNameId = cm.MedicationNameId and isnull(MedName.RecordDeleted,'N')<>'Y'      
 join MDMedications as MDMeds on MDMeds.MedicationId = cmi.StrengthId      
 join GlobalCodes as gc1 on gc1.GlobalCodeId = cmi.Unit      
 join GlobalCodes as gc2 on gc2.GlobalCodeId = cmi.Schedule         
 where isnull(cms.RecordDeleted,'N')<>'Y'      
 and @ClientMedicationScriptIds = cms.ClientMedicationScriptId     
  
end --End Original Data Select  
  
--Begin Preview Data Select  
if(isnull(@OriginalData,0) = 0)     
begin    
-- Get Client Alergy List      
    Insert into @AllergyListTable      
    (ConceptDescription)      
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009
    --select isnull(ConceptDescription, 'No Known Allergies') 
    select isnull(ConceptDescription, 'No Known Medication/Other Allergies')     
    from ClientMedicationScriptsPreview as cms      
    join Clients as c on c.ClientId = cms.ClientId and isnull(c.RecordDeleted,'N')<>'Y'      
    left join ClientAllergies as cla on cla.ClientId = c.ClientId       
       and isnull(cla.RecordDeleted,'N')<>'Y'      
    left join MDAllergenConcepts as MDAl on MDAl.AllergenConceptId = cla.AllergenConceptId       
    where isnull(cms.RecordDeleted,'N')<>'Y'      
    and @ClientMedicationScriptIds = cms.ClientMedicationScriptId 
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009     
--    order by isnull(ConceptDescription, 'No Known Allergies')      
	 order by isnull(ConceptDescription, 'No Known Medication/Other Allergies') 
       
    --Find Max Allergy in temp table for while loop      
    Set @MaxAllergyId = (Select Max(AllergyId) From @AllergyListTable)      
       
    --Begin Loop to create Allergy List      
    While @AllergyId <= @MaxAllergyId      
    Begin      
       Set @AllergyList = isnull(@AllergyList, '') +       
       case when @AllergyId <> 1 then ', ' else '' end +       
       (select isnull(ConceptDescription, '')      
       From @AllergyListTable t Where t.AllergyId = @AllergyId)      
       Set @AllergyId = @AllergyId + 1      
    End       
    --End Loop      
        
 --get Client Info      
 insert into #ScriptHeader  
 select       
 (select OrganizationName from SystemConfigurations) as OrganizationName,       
 cms.ClientMedicationScriptId,      
 @OrderingMethod as OrderingMethod,       
 @AllergyList as AllergyList,      
 c.ClientId,       
 c.LastName + ', ' + c.FirstName as ClientName,      
 isnull(ca.Display,'') as ClientAddress,      
 isnull(cph.PhoneNumber,'             ') as ClientHomePhone,      
 c.DOB as ClientDOB,  
 l.Address as LocationAddress,      
 isnull(l.LocationName,'') as LocationName,      
 case when isnull(l.PhoneNumber,'             ') = '' then '             '      
  else isnull(l.PhoneNumber,'           ')+' ' end as LocationPhone,      
 case when isnull(l.FaxNumber,'             ') = '' then '             '       
  else isnull(l.FaxNumber,'             ')+ ' ' end as LocationFax,      
 isnull(p.PharmacyName,'') as PharmacyName,      
 isnull(p.AddressDisplay,'') as PharmacyAddress,      
 case when isnull(p.PhoneNumber,'             ') = '' then '             '      
  else isnull(p.PhoneNumber,'             ')+' ' end as PharmacyPhone,      
 case when isnull(p.FaxNumber,'             ') = '' then '             '       
  else isnull(p.FaxNumber,'             ')+ ' ' end as PharmacyFax    
 from ClientMedicationScriptsPreview as cms      
 join Clients as c on c.ClientId = cms.ClientId and isnull(c.RecordDeleted,'N')<>'Y'      
 left join ClientAddresses as ca on ca.ClientId = c.ClientId       
 and ca.AddressType = 90 and isnull(ca.RecordDeleted,'N')<>'Y'      
 left join ClientPhones as cph on cph.ClientId = c.ClientId      
 and cph.PhoneType = 30 and isnull(cph.RecordDeleted,'N')<>'Y'    
 join Locations as l on l.LocationId = cms.LocationId and isnull(l.RecordDeleted,'N')<>'Y'      
 left join Pharmacies as p on p.PharmacyId = cms.PharmacyId         
 where isnull(cms.RecordDeleted,'N')<>'Y'      
 and @ClientMedicationScriptIds = cms.ClientMedicationScriptId    
  
 --Get Signature Info   
 insert into #ScriptSignatures   
 Select distinct  
 cms.ClientMedicationScriptId,      
 @OrderingMethod as OrderingMethod,  
 cm.PrescriberId,       
 case when st.Degree in (select Degree from @DrDegree) then 'Dr. '       
  else case when isnull(st.Sex,'')='M' then 'Mr. '      
  when isnull(st.Sex,'')='F' then 'Ms. ' else '' end  end      
  + case when isnull(st.SigningSuffix,'') = ''       
   then st.FirstName +' '+ st.Lastname + ', ' + stDeg.CodeName       
   else st.FirstName +' '+ st.Lastname + ', ' + st.SigningSuffix end   
  + '     DEA #: ' + isnull(st.DEANumber,'') as Prescriber,       
   case when st.StaffId <> v.StaffId then 'V.O. to & Read Back by: ' +      
    case when isnull(v.Sex,'')='M' then 'Mr. ' +      
     case when isnull(v.SigningSuffix,'') = ''       
     then v.FirstName +' '+ v.Lastname + ', ' + vDeg.CodeName       
     else v.FirstName +' '+ v.Lastname + ', ' + v.SigningSuffix end      
   when isnull(v.Sex,'')='F' then 'Ms. ' +   
    case when isnull(v.SigningSuffix,'') = ''       
    then v.FirstName +' '+ v.Lastname + ', ' + vDeg.CodeName       
    else v.FirstName +' '+ v.Lastname + ', ' + v.SigningSuffix end      
   else case when isnull(v.SigningSuffix,'') = ''       
    then v.FirstName +' '+ v.Lastname + ', ' + vDeg.CodeName       
    else v.FirstName +' '+ v.Lastname + ', ' + v.SigningSuffix end end      
    else '' end as Creator,      
 cms.CreatedBy,      
 sf.SignatureFacsimile,      
 cms.PrintDrugInformation  
 from ClientMedicationScriptsPreview as cms      
 join ClientMedicationScriptDrugsPreview as cmsd on cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId      
  and isnull(cmsd.RecordDeleted,'N')<>'Y'      
 join ClientMedicationInstructionsPreview as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId       
  and isnull(cmi.RecordDeleted,'N')<>'Y'      
 join ClientMedicationsPreview as cm on cm.ClientMedicationId = cmi.ClientMedicationId      
  and isnull(cm.RecordDeleted,'N')<>'Y'      
 join Staff as v on v.UserCode = cms.CreatedBy and isnull(v.RecordDeleted,'N')<>'Y'      
 left join globalCodes as vDeg on vDeg.GlobalCodeId = v.Degree      
 join Staff as st on st.StaffId = cm.PrescriberId and isnull(st.RecordDeleted,'N')<>'Y'      
 left join globalCodes as stDeg on stDeg.GlobalCodeId = st.Degree      
 left join StaffSignatureFacsimiles as sf on sf.StaffId = cm.PrescriberId      
 where isnull(cms.RecordDeleted,'N')<>'Y'      
 and @ClientMedicationScriptIds = cms.ClientMedicationScriptId        
  
 /*main*/  
 insert into #ClientScriptInstructions   
 select  
 cms.ClientMedicationScriptId,      
 @OrderingMethod as OrderingMethod,  
 case when @OrderingMethod <> 'C' then 'Prescription' else 'Chart' end as CopyType,   
 cms.OrderDate as ScriptOrderedDate,  
 cm.ClientMedicationId as PON,      
 cmi.ClientMedicationInstructionId,      
 MedName.MedicationName,    
 cmi.StrengthId,   
 MDMeds.StrengthDescription as InstructionStrengthDescription,  
 null as InstructionSummary,   
 null as PatientScheduleSummary,  
 --null as StrengthInstructionSummary,  
 --case when cmsd.Sample + cmsd.Stock = 0 then 'N' else 'Y' end as DisbursedToClient,   
 --case when cmsd.Sample + cmsd.Stock = 0 then null   
 -- else space(2) + '(' + replace(cast((cmsd.Sample + cmsd.Stock) as varchar(10)),'.00','' )  + '  disbursed to client from samples)' end as SamplesToClient,  
 cmsd.Sample + cmsd.Stock as disbursedAmount,  
 gc1.codeName +' '+ gc2.codeName as UnitScheduleString,  
 gc1.codeName as UnitValue,   
 case when gc1.codeName  in ('units', 'each') then '#' else 'x ' end as UnitValueString,   
 gc2.codeName as ScheduleValue,    
 isnull(cmi.TitrationStepNumber,0) as TitrationStepNumber,  
 cm.MedicationStartDate,   
 cm.MedicationEndDate,  
 cms.OrderDate,   
 replace(cmi.Quantity,'.00','') as Quantity,        
 gc2.ExternalCode1 as SchedValueMultiplier,      
 case when cms.CreatedDate < @StartDate   
  then replace(cmi.Quantity,'.00','') * cmsd.Days * gc2.ExternalCode1  
  --else replace(cmsd.pharmacy,'.00','') end as TotalQuantity,   
  else CONVERT(int,cmsd.pharmacy) end as TotalQuantity,      
 cmsd.StartDate as DrugStartDate, --Titration Start (Drug)  
 cmsd.EndDate as DrugEndDate, --Titration End (Drug)     
 replace(cmsd.Refills,'.00','') as Refills,      
 cmsd.Days as DurationDays,      
 replace(cmsd.Pharmacy,'.00','') as Pharmacy,  
 replace(cmsd.Sample,'.00','') as Sample,  
 replace(cmsd.Stock,'.00','') as Stock,  
 case when isnull(cm.DAW,'N') = 'N' then 'Substitutions Allowed'       
  when isnull(cm.DAW,'N') = 'Y' then 'Dispense as Written' End as DAW,      
 cm.SpecialInstructions,  
 case when isnull(CM.Discontinued, 'N') = 'Y' and rtrim(CM.DiscontinuedReason) not in ('Re-Order', 'Change Order')   
  then 'Discontinued'             
  else Case CMS.ScriptEventType  
  When 'N' then 'New' When 'C' then 'Changed' When 'R' then 'Re-Ordered' end end as OrderStatus--,  
 from ClientMedicationScriptsPreview as cms     
 join ClientMedicationScriptDrugsPreview as cmsd on cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId and isnull(cmsd.RecordDeleted,'N')<>'Y'      
 join ClientMedicationInstructionsPreview as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId and isnull(cmi.RecordDeleted,'N')<>'Y'      
 join ClientMedicationsPreview as cm on cm.ClientMedicationId = cmi.ClientMedicationId and isnull(cm.RecordDeleted,'N')<>'Y'      
 join MDMedicationNames as MedName on MedName.MedicationNameId = cm.MedicationNameId and isnull(MedName.RecordDeleted,'N')<>'Y'      
 join MDMedications as MDMeds on MDMeds.MedicationId = cmi.StrengthId      
 join GlobalCodes as gc1 on gc1.GlobalCodeId = cmi.Unit      
 join GlobalCodes as gc2 on gc2.GlobalCodeId = cmi.Schedule         
 where isnull(cms.RecordDeleted,'N')<>'Y'      
 and @ClientMedicationScriptIds = cms.ClientMedicationScriptId     
end --End Preview Data Select  
  
--Data Updates for the script  
 insert into #QuantitySummary  
 select null, ClientMedicationInstructionId, PON, StrengthId, TitrationStepNumber,  
  DurationDays, Quantity, Pharmacy, TotalQuantity, Sample, Stock, DisbursedAmount, null as DisbursedTotal,  
  null as DisbursedFlag, null as PharmacyTotal, null as GroupTotal, DrugStartDate, DrugEndDate, Refills,   
  null as Titration, null as Multiples, Null as SingleLine  
 from #ClientScriptInstructions  
 order by PON, StrengthId, TitrationStepNumber, DrugStartDate, DrugEndDate, Refills  
  
 insert into @TitrationPONs  
 select PON, case when sum((isnull(TitrationStepNumber,0))) >= 1 and count((isnull(TitrationStepNumber,0))) > 1  
  then 'Y' else 'N' end as Titration  
 from #QuantitySummary qs group by PON  
  
 update qs set titration = tp.titration from #QuantitySummary qs  
 join @TitrationPONs tp on tp.PON = qs.PON  
  
 update qs set Multiples = 'Y'  
 from #QuantitySummary qs  
 where exists ( select * from #QuantitySummary qs2 where qs2.PON = qs.PON and qs2.StrengthId = qs.StrengthId  
  and qs2.DrugStartDate = qs.DrugStartDate and qs2.DrugEndDate = qs.DrugEndDate and qs2.Refills = qs.Refills   
  and qs2.ClientMedicationInstructionId <> qs.ClientMedicationInstructionId and qs2.Titration <> 'Y' )  
  
 update qs set Multiples = 'N' from #QuantitySummary qs where Multiples is null  
 update qs set SingleLine = case when (Multiples <> 'Y' and Titration <> 'Y') then 'Y' else 'N' end from #QuantitySummary qs  
  
 insert into @StrengthGroupInstructionIds  
 select StrengthId, ClientMedicationInstructionId  
 from #QuantitySummary where ( Multiples = 'Y' or Titration = 'Y' )  
  
 update a  
 set DisbursedTotal = b.DisbursedTotal, PharmacyTotal = b.PharmacyTotal, GroupTotal = b.GroupTotal  
 from #QuantitySummary a  
 join ( select qs.StrengthId, sum(qs.DisbursedAmount) as DisbursedTotal  
  ,sum(qs.TotalQuantity) - sum(qs.DisbursedAmount) as PharmacyTotal ,sum(qs.TotalQuantity ) as GroupTotal  
  from #QuantitySummary qs  
  join @StrengthGroupInstructionIds sg on sg.StrengthId=qs.StrengthId  
   and sg.ClientMedicationInstructionId = qs.ClientMedicationInstructionId  
  group by qs.StrengthId ) b on b.StrengthId = a.StrengthId  
 join @StrengthGroupInstructionIds c on c.StrengthId=a.StrengthId  
  and c.ClientMedicationInstructionId = a.ClientMedicationInstructionId  
  
 update qs set DisbursedTotal = DisbursedAmount, PharmacyTotal = TotalQuantity - DisbursedAmount, GroupTotal = TotalQuantity  
 from #QuantitySummary qs where Singleline = 'Y' and GroupTotal is null  
  
 --Start Create Strength Groups For Multiple instruction orders    
 declare InsStrengthGroup cursor for   
 select PON, StrengthId, Titration, Multiples, SingleLine  
 from #QuantitySummary  
 group by PON, StrengthId, Titration, Multiples, SingleLine  
  
 open InsStrengthGroup   
 set @IdxCur1 = 1  
 Fetch next from InsStrengthGroup into @PONCur1 ,@StrengthIdCur1 ,@TitrationCur1 ,@MultiplesCur1 ,@SingleLineCur1  
 while (@@fetch_status = 0)  
  begin   
   update qs  
   set InsrtuctionMultipleStrengthGroupId = @IdxCur1  
   from #QuantitySummary qs  
   where qs.PON = @PONCur1 and qs.StrengthId = @StrengthIdCur1 and qs.Titration = @TitrationCur1   
   and qs.Multiples = @MultiplesCur1 and qs.SingleLine = @SingleLineCur1   
   set @IdxCur1 = @IdxCur1 + 1  
     
   Fetch next from InsStrengthGroup into @PONCur1 ,@StrengthIdCur1 ,@TitrationCur1 ,@MultiplesCur1 ,@SingleLineCur1  
  end  
 Close InsStrengthGroup   
 Deallocate InsStrengthGroup  
 --End Create Strength Groups For Multiple instruction orders    
  
  begin  
  --Set Titrations to same StrengthGroup for report purposes  
   update a  
   set InsrtuctionMultipleStrengthGroupId = b.InsrtuctionMultipleStrengthGroupId  
   from #QuantitySummary a  
   join ( select PON, min(InsrtuctionMultipleStrengthGroupId) as InsrtuctionMultipleStrengthGroupId  
    from #QuantitySummary where titration = 'Y'  
    group by PON ) b on b.PON = a.PON  
  
   select @TitrationRecords = case when exists (select * from #QuantitySummary where titration = 'Y') then 'Y' else 'N' end  
   select @MultInstRecords = case when exists (select * from #QuantitySummary where Multiples = 'Y') then 'Y' else 'N' end  
  end  
    
 --Update instructions for drugs that are not multiple instructions or titrations and set Disbursed Flag for multiples  
  begin  
  update csi set InstructionSummary = csi.InstructionStrengthDescription + ' (' + convert(varchar(16),replace(csi.Quantity,'.00','')) + ') '   
   + space(1) + convert(varchar(250),csi.UnitScheduleString)   
   + ' ' + csi.UnitValueString + convert(varchar(16),replace(qs.PharmacyTotal,'.00',''))  
   + case when isnull(csi.DisbursedAmount,0) = 0 then ''  
    else ' (' + replace(cast((qs.DisbursedTotal) as varchar(16)),'.00','' )  + '  disbursed to client from samples)' end  
  from  #ClientScriptInstructions csi  
  join #QuantitySummary qs on qs.PON = csi.PON   
   and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
   and qs.Titration = 'N' and qs.Multiples = 'N' and qs.SingleLine = 'Y'  
  
  update a   
  set a.DisbursedFlag = b.DisbursedFlag from #QuantitySummary a  
  join ( select InsrtuctionMultipleStrengthGroupId ,case when sum(qs2.disbursedAmount) > 0 then 'Y' else 'N' end as DisbursedFlag  
   from #QuantitySummary qs2   
   where qs2.multiples = 'Y' or qs2.SingleLine = 'Y'  
   group by qs2.InsrtuctionMultipleStrengthGroupId ) as b on b.InsrtuctionMultipleStrengthGroupId = a.InsrtuctionMultipleStrengthGroupId  
  where (a.Multiples = 'Y' or a.SingleLine = 'Y')  
  
  update a set a.disbursedFlag = b.disbursedFlag  
  from #QuantitySummary a  
  join ( select qs2.InsrtuctionMultipleStrengthGroupId ,qs2.StrengthId   
    ,case when sum(qs2.disbursedAmount) > 0 then 'Y' else 'N' end as DisbursedFlag  
   from #QuantitySummary qs2   
   where Titration = 'Y'   
   group by qs2.InsrtuctionMultipleStrengthGroupId, StrengthId ) as b   
   on b.InsrtuctionMultipleStrengthGroupId = a.InsrtuctionMultipleStrengthGroupId  
    and b.StrengthId = a.StrengthId  
  where a.titration = 'Y'  
  end  
  
 --Begin Multiple Instruction Logic  
 if @MultInstRecords = 'Y'   
 begin  
  declare MultCursor cursor For  
   select   
   csi.PON, qs.InsrtuctionMultipleStrengthGroupId, @MultPharmInstructionString --,@MultPatientInstructionSummaryString  
   from #ClientScriptInstructions csi  
   join #QuantitySummary qs on qs.PON = csi.PON   
    and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
    and qs.Titration = 'N' and qs.Multiples = 'Y' and qs.SingleLine = 'N'  
   group by csi.PON, qs.InsrtuctionMultipleStrengthGroupId  
  
  open MultCursor   
  Fetch next from MultCursor into @MultPON ,@MultInsrtuctionMultipleStrengthGroupId ,@MultPharmInstructionString   
  while (@@fetch_status = 0)  
   begin  
   update csi   
   set csi.InstructionSummary = csi.InstructionStrengthDescription + ' ' + csi.UnitValueString   
   + convert(varchar(16),replace(qs.PharmacyTotal,'.00',''))  
   + case when qs.DisbursedFlag = 'N' then ''  
    else ' (' + replace(cast((qs.DisbursedTotal) as varchar(16)),'.00','' )  + '  disbursed to client from samples)' end  
   from #ClientScriptInstructions csi  
   join #QuantitySummary qs on qs.PON = csi.PON   
    and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
    and qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
   where qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
  
   declare MultiPatientCursor cursor for   
   select qs.InsrtuctionMultipleStrengthGroupId, csi.ClientMedicationInstructionId ,@MultPatientInstructionSummaryString  
   from #ClientScriptInstructions csi  
   join #QuantitySummary qs on qs.PON = csi.PON   
   and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
    and qs.Titration = 'N' and qs.Multiples = 'Y' and qs.SingleLine = 'N'   
   where csi.PON = @MultPON and qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
   group by qs.InsrtuctionMultipleStrengthGroupId, csi.ClientMedicationInstructionId  
  
    open MultiPatientCursor   
    Fetch next from MultiPatientCursor into @MultInsrtuctionMultipleStrengthGroupId ,@MultClientMedicationInstructionId ,@MultPatientInstructionSummaryString  
    while (@@fetch_status = 0)  
    begin  
  
    select @MultPatientInstructionSummaryString = isnull(@MultPatientInstructionSummaryString,'')  
    + csi.InstructionStrengthDescription   
    + ' (' + convert(varchar(6),replace(csi.Quantity,'.00','')) + ') '   
    + csi.UnitScheduleString +char(13)+char(10)  
    from #ClientScriptInstructions csi  
    join #QuantitySummary qs on qs.PON = csi.PON   
    and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
     and qs.Titration = 'N' and qs.Multiples = 'Y' and qs.SingleLine = 'N'  
     and qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId   
    where csi.PON = @MultPON and qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
    and csi.ClientMedicationInstructionId = @MultClientMedicationInstructionId  
  
    update csi  
    set csi.PatientScheduleSummary = isnull(csi.PatientScheduleSummary,'') + @MultPatientInstructionSummaryString  
    from #ClientScriptInstructions csi  
    join #QuantitySummary qs on qs.PON = csi.PON   
     and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
     and qs.Titration = 'N' and qs.Multiples = 'Y' and qs.SingleLine = 'N'  
    where csi.PON = @MultPON   
    and qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
  
      
    Fetch next from MultiPatientCursor into @MultInsrtuctionMultipleStrengthGroupId ,@MultClientMedicationInstructionId ,@MultPatientInstructionSummaryString  
    set @MultPatientInstructionSummaryString = ''  
    end  
  close MultiPatientCursor  
  deallocate MultiPatientCursor  
  select @MultPharmInstructionString = ''   
    
  Fetch next from MultCursor into @MultPON ,@MultInsrtuctionMultipleStrengthGroupId ,@MultPharmInstructionString   
 end  
  
 close MultCursor  
 deallocate MultCursor  
  
 end  
--End Multiple Instruction Logic  
  
 --Begin Titration Instructions  
 if @TitrationRecords = 'Y'   
 begin  
  insert into @TitrationDays  
  select distinct csi.PON ,csi.TitrationStepNumber ,QS.DrugStartDate ,QS.DrugEndDate ,QS.DurationDays, null as DayNumber   
  from #ClientScriptInstructions csi  
  join #QuantitySummary qs on qs.PON = csi.PON   
   and qs.TitrationStepNumber = csi.TitrationStepNumber   
   and qs.titration = 'Y'  
  
  update td  
  set DayNumber = case when TitrationStepNumber = 1 then 1  
  else datediff(dd,(select a.DrugStartDate from @TitrationDays a where a.TitrationStepNumber=1 and a.PON = td.PON),td.DrugStartDate) end  
  from @TitrationDays td  
  
   insert into @Titrations  
   select distinct csi.PON, null   
   from #ClientScriptInstructions csi  
   join #QuantitySummary qs on qs.PON = csi.PON and qs.titration = 'Y'  
     
   select @TitrationId = 1 ,@StepId = 1  
   set @MaxTitrationId = (select max(titrationId) from @Titrations)  
     
   while @TitrationId <= @MaxTitrationId  
    begin  
    set @StepInstructionString = ''  
    select @PON = PON from @Titrations where TitrationId = @TitrationId  
     
    insert into @TitrationSteps  
    select   
    csi.PON   
    ,csi.TitrationStepNumber  
    ,'Day ' + convert(varchar(6),td.DayNumber) + space(5)   
    + csi.InstructionStrengthDescription   
    + ' (' + convert(varchar(6),replace(csi.Quantity,'.00','')) + ') '   
    + csi.UnitScheduleString   
    + space(2) + 'Start - End Date: ' + convert(varchar(12),csi.DrugStartDate,101) + ' - ' + convert(varchar(12),csi.DrugEndDate,101)  
    + space(5) + 'Duration: ' + convert(varchar(6),csi.DurationDays) + ' Days' --as TitrationInstruction  
    from #ClientScriptInstructions csi  
    join #QuantitySummary qs on qs.PON = csi.PON and qs.titration = 'Y'  
     and qs.TitrationStepNumber = csi.TitrationStepNumber  
     and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId   
    join @TitrationDays td on td.PON = csi.PON and td.TitrationStepNumber = csi.TitrationStepNumber   
    where csi.PON = @PON  
    order by csi.ClientMedicationScriptId ,csi.PON ,csi.TitrationStepNumber ,td.DayNumber   
      
    select @MaxStepId = @@Identity  
    while @StepId  <= @MaxStepId  
     begin   
      update t  
      set TitrationString = isnull(TitrationString,'') + isnull(StepString,'') + char(13) + char(10)  
      from @Titrations t  
      join @TitrationSteps ts on  @PON  = ts.PON  
      where ts.StepId = @StepId  
  
     set @StepId = @StepId + 1  
     end  
    select @TitrationInstructionString = TitrationString from @Titrations  
   set @TitrationInstructionString = @TitrationInstructionString + @StepInstructionString  
   set @TitrationId = @TitrationId + 1  
   end  
  
  insert into @TitrationInstructions  
  select t.PON, t.TitrationString, min(csi.drugStartDate), max(csi.drugEndDate), datediff( dd, min(csi.drugStartDate), max(csi.drugEndDate) )  
  from @Titrations t  
  join #ClientScriptInstructions csi on t.PON = csi.PON  
  where t.PON = @PON  
  and @TitrationId  = @TitrationId  
  group by t.PON, t.TitrationString  
 end  
  
 update csi  
 set PatientScheduleSummary = ti.TitrationInstruction   
 from #ClientScriptInstructions csi  
 join @TitrationInstructions ti on ti.PON = csi.PON  
  
 insert into @TitrationSummary  
    select csi.PON ,qs.InsrtuctionMultipleStrengthGroupId ,csi.StrengthId   
 ,csi.InstructionStrengthDescription + ' ' + csi.UnitValueString   
 + convert(varchar(16),replace(qs.PharmacyTotal,'.00',''))  
 + case when qs.DisbursedFlag = 'N' then ''  
  else ' (' + replace(cast((qs.DisbursedTotal) as varchar(16)),'.00','' )  + '  disbursed to client from samples)' end --as InstructionSummary  
 from #ClientScriptInstructions csi  
 join #QuantitySummary qs on qs.PON = csi.PON   
  and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId and qs.Titration = 'Y'  
  and qs.StrengthId = csi.StrengthId  
 group by csi.PON, qs.InsrtuctionMultipleStrengthGroupId ,csi.StrengthId ,csi.InstructionStrengthDescription ,csi.UnitValueString ,qs.PharmacyTotal ,qs.DisbursedFlag ,qs.DisbursedTotal  
  
 set @TIString = ''  
 --titration instruction summary logic  
 declare TitrationInst cursor For  
  select s.PON ,s.InstructionSummary  
  from @TitrationSummary s  
 open TitrationInst   
 Fetch next from TitrationInst into @TIPon ,@TIString   
 while (@@fetch_status = 0)  
 begin   
  update csi  
  set InstructionSummary = isnull(csi.InstructionSummary,'') + isnull(@TIString,'') +char(13) + char(10)  
  from #ClientScriptInstructions csi  
  join #QuantitySummary qs on qs.PON = csi.PON   
  where csi.PON = @TIPon   
  set @TIString = ''  
 Fetch next from TitrationInst into @TIPon ,@TIString   
 end  
 close TitrationInst  
 deallocate TitrationInst  
-- End Titration Logic  
  
  
--Create the Instruction Results for all drugs  
begin  
insert into #ClientScriptInstructionResults  
--Non Multiples, Non Titrations  
select distinct  
 csi.ClientMedicationScriptId  
 ,csi.OrderingMethod  
 ,csi.CopyType  
 ,csi.ScriptOrderedDate  
 ,csi.PON  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,csi.ClientmedicationInstructionId  
 ,csi.MedicationName  
 ,csi.InstructionSummary  
 ,csi.PatientScheduleSummary  
-- ,csi.StrengthInstructionSummary  
-- ,csi.DisbursedToClient  
-- ,csi.SamplesToClient  
 ,csi.OrderDate  
 ,csi.DrugStartDate  
 ,csi.DrugEndDate  
 ,replace(qs.Refills,'.00','')  
 ,qs.DurationDays  
-- ,replace(qs.PharmacyTotal,'.00','')  
-- ,replace(qs.Sample,'.00','')  
-- ,replace(qs.Stock,'.00','')  
 ,csi.DAW  
 ,csi.SpecialInstructions  
 ,csi.OrderStatus  
 ,qs.Titration  
 ,qs.Multiples  
 ,qs.SingleLine  
from #ClientScriptInstructions csi  
join #QuantitySummary qs on qs.PON = csi.PON and csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId and qs.SingleLine = 'Y'  
where  @OrderingMethod not in ('X', 'C')  
and qs.SingleLine = 'Y' --uncommented  
--and @PrintChartCopy = 'N'  
union  
select distinct  
 csi.ClientMedicationScriptId  
 ,'X' as OrderingMethod  
 ,'Chart' as CopyType  
 ,csi.ScriptOrderedDate  
 ,csi.PON  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,csi.ClientmedicationInstructionId  
 ,csi.MedicationName  
 ,csi.InstructionSummary  
 ,csi.PatientScheduleSummary  
-- ,csi.StrengthInstructionSummary  
-- ,csi.DisbursedToClient  
-- ,csi.SamplesToClient  
 ,csi.OrderDate  
 ,csi.DrugStartDate  
 ,csi.DrugEndDate  
 ,replace(qs.Refills,'.00','')  
 ,qs.DurationDays  
-- ,replace(qs.PharmacyTotal,'.00','')  
-- ,replace(qs.Sample,'.00','')  
-- ,replace(qs.Stock,'.00','')  
 ,csi.DAW  
 ,csi.SpecialInstructions  
 ,csi.OrderStatus  
 ,qs.Titration  
 ,qs.Multiples  
 ,qs.SingleLine  
from #ClientScriptInstructions csi  
join #QuantitySummary qs on qs.PON = csi.PON and csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId and qs.SingleLine = 'Y'  
where @OrderingMethod <> ('F')  
and qs.SingleLine = 'Y'  
and @PrintChartCopy = 'Y'  
/**/  
--multiple instructions  
union  
select distinct  
 csi.ClientMedicationScriptId  
 ,csi.OrderingMethod  
 ,csi.CopyType  
 ,csi.ScriptOrderedDate  
 ,csi.PON  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,csi.MedicationName  
 ,csi.InstructionSummary  
 ,csi.PatientScheduleSummary  
-- ,csi.StrengthInstructionSummary  
-- ,csi.DisbursedToClient  
-- ,csi.SamplesToClient  
 ,csi.OrderDate  
 ,csi.DrugStartDate  
 ,csi.DrugEndDate  
 ,replace(qs.Refills,'.00','')  
 ,qs.DurationDays  
-- ,replace(qs.PharmacyTotal,'.00','')  
-- ,replace(qs.Sample,'.00','')  
-- ,replace(qs.Stock,'.00','')  
 ,csi.DAW  
 ,csi.SpecialInstructions  
 ,csi.OrderStatus  
 ,qs.Titration  
 ,qs.Multiples  
 ,qs.SingleLine  
from #ClientScriptInstructions csi  
join #QuantitySummary qs on qs.PON = csi.PON and csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId and qs.Multiples = 'Y'  
where @OrderingMethod not in ('X', 'C')   
--and @PrintChartCopy = 'N'  
union  
select distinct  
 csi.ClientMedicationScriptId  
 ,'X' as OrderingMethod  
 ,'Chart' as CopyType  
 ,csi.ScriptOrderedDate  
 ,csi.PON  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,csi.MedicationName  
 ,csi.InstructionSummary  
 ,csi.PatientScheduleSummary  
-- ,csi.StrengthInstructionSummary  
-- ,csi.DisbursedToClient  
-- ,csi.SamplesToClient  
 ,csi.OrderDate  
 ,csi.DrugStartDate  
 ,csi.DrugEndDate  
 ,replace(qs.Refills,'.00','')  
 ,qs.DurationDays  
-- ,replace(qs.PharmacyTotal,'.00','')  
-- ,replace(qs.Sample,'.00','')  
-- ,replace(qs.Stock,'.00','')  
 ,csi.DAW  
 ,csi.SpecialInstructions  
 ,csi.OrderStatus  
 ,qs.Titration  
 ,qs.Multiples  
 ,qs.SingleLine  
from #ClientScriptInstructions csi  
join #QuantitySummary qs on qs.PON = csi.PON and csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId and qs.Multiples = 'Y'  
where @OrderingMethod <> 'F'  
and @PrintChartCopy = 'Y'  
--Titrations  
union  
select distinct  
 csi.ClientMedicationScriptId  
 ,csi.OrderingMethod  
 ,csi.CopyType  
 ,csi.ScriptOrderedDate  
 ,csi.PON  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,csi.MedicationName  
 ,csi.InstructionSummary  
 ,csi.PatientScheduleSummary  
-- ,csi.StrengthInstructionSummary  
-- ,csi.DisbursedToClient  
-- ,csi.SamplesToClient  
 ,csi.OrderDate  
 ,ti.TitrationStartDate  
 ,ti.TitrationEndDate  
 ,replace(qs.Refills,'.00','')  
 ,ti.DurationDays  
-- ,null as Pharmacy  
-- ,null as Sample  
-- ,null as Stock  
 ,csi.DAW  
 ,csi.SpecialInstructions  
 ,csi.OrderStatus  
 ,qs.Titration  
 ,qs.Multiples  
 ,qs.SingleLine  
from #ClientScriptInstructions csi  
join @TitrationInstructions ti on ti.PON = csi.PON  
join #QuantitySummary qs on qs.PON = csi.PON and csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId and qs.Titration = 'Y'  
where @OrderingMethod not in ('X', 'C')   
--and @PrintChartCopy = 'N'  
union  
select distinct  
 csi.ClientMedicationScriptId  
 ,'X' as OrderingMethod  
 ,'Chart' as CopyType  
 ,csi.ScriptOrderedDate  
 ,csi.PON  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,qs.InsrtuctionMultipleStrengthGroupId  
 ,csi.MedicationName  
 ,csi.InstructionSummary  
 ,csi.PatientScheduleSummary  
-- ,csi.StrengthInstructionSummary  
-- ,csi.DisbursedToClient  
-- ,csi.SamplesToClient  
 ,csi.OrderDate  
 ,ti.TitrationStartDate  
 ,ti.TitrationEndDate  
 ,replace(qs.Refills,'.00','')  
 ,ti.DurationDays  
-- ,null as Pharmacy  
-- ,null as Sample  
-- ,null as Stock  
 ,csi.DAW  
 ,csi.SpecialInstructions  
 ,csi.OrderStatus  
 ,qs.Titration  
 ,qs.Multiples  
 ,qs.SingleLine  
from #ClientScriptInstructions csi  
join @TitrationInstructions ti on ti.PON = csi.PON  
join #QuantitySummary qs on qs.PON = csi.PON and csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId and qs.Titration = 'Y'  
where @OrderingMethod <> 'F'  
and @PrintChartCopy = 'Y'  
--order by csi.ClientMedicationScriptId, csi.PON, CopyType  
end    
  
    
begin    
--this is the dataset    
select   
h.OrganizationName,  
h.ClientMedicationScriptId,  
m.OrderingMethod,  
m.CopyType,  
m.PON,  
m.InsrtuctionMultipleStrengthGroupId,  
h.AllergyList,  
h.ClientId,  
h.ClientName,  
h.ClientAddress,  
h.ClientHomePhone,  
h.ClientDOB,  
h.LocationAddress,  
h.LocationName,  
h.LocationPhone,  
h.LocationFax,  
h.PharmacyName,  
h.PharmacyAddress,  
h.PharmacyPhone,  
h.PharmacyFax,  
  
m.ClientMedicationInstructionId,  
m.ScriptOrderedDate,  
m.MedicationName,  
m.InstructionSummary,  
m.PatientScheduleSummary,  
--m.StrengthInstructionSummary,  
--m.DisbursedToClient,  
--replace(m.SamplesToClient,'.00','') as SamplesToClient,  
m.OrderDate,  
m.DrugStartDate,  
m.DrugEndDate,  
replace(m.Refills,'.00','') as Refills,  
m.DurationDays,  
--m.Pharmacy,  
--m.Sample,  
--m.Stock,  
m.DAW,  
m.SpecialInstructions,  
m.OrderStatus,  
m.Titration,  
m.Multiples,  
m.SingleLine,  
s.PrescriberId,  
s.Prescriber,  
s.Creator,  
s.CreatedBy,  
s.SignatureFacsimile,  
s.PrintDrugInformation   
from #ScriptHeader h  
join #ClientScriptInstructionResults m on m.ClientMedicationScriptId = h.ClientMedicationScriptId  
join #ScriptSignatures s on s.ClientMedicationScriptId = h.ClientMedicationScriptId  
order by h.ClientMedicationScriptId ,m.OrderingMethod ,m.PON ,m.InsrtuctionMultipleStrengthGroupId ,m.ClientmedicationInstructionId  
end  
  
  
drop table #ClientScriptInstructions  
drop table #ClientScriptInstructionResults  
drop table #QuantitySummary  
drop table #ScriptHeader  
drop table #ScriptSignatures  
  