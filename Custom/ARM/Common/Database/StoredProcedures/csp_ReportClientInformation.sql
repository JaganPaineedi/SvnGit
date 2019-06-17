
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientInformation]
GO


/****** Object:  StoredProcedure [dbo].[csp_ReportClientInformation]    Script Date: 05/03/2013 11:22:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
CREATE procedure [dbo].[csp_ReportClientInformation]      
@ClientId int = null,      
@ReceptionViewId int,      
@SelectedDate datetime = null,      
@Status varchar(10) = null      
/********************************************************************************      
-- Stored Procedure: dbo.csp_ReportClientInformation        
--      
-- Copyright: 2007 Streamline Healthcate Solutions      
--      
-- Purpose: used for single Client Information Sheet and Intake Batch Print reports       
--      
-- Updates:                                                             
-- Date        Author      Purpose      
-- 01.29.2007  SFarber     Created.        
-- 11/9/2007   AVOSS    Started Modification for use at Barry          
--      
*********************************************************************************/      
as      
      
declare @InfoSheetClients table (ClientId int null)      
IF @ReceptionViewId=-1  
SET @ReceptionViewId=9  
      
declare @Results table (      
ReportingSection            int          null,      
ClientId                    char(10)     null,      
LastName                    varchar(50)  null,      
FirstName                   varchar(50)  null,      
SSN                         varchar(11)  null,      
DOB                         datetime     null,      
Sex                         char(1)      null,      
Address                     varchar(150) null,      
City                        varchar(30)  null,      
State                       char(2)      null,      
Zip                         char(12)     null,      
County                      varchar(30)  null,      
HomePhone                   type_PhoneNumberEncrypted  null,      
WorkPhone                   type_PhoneNumberEncrypted  null,      
SchoolPhone                 type_PhoneNumberEncrypted  null,      
NumberOfDependents          int          null,      
MaritalSingle               char(1)      null,      
MaritalMarried              char(1)      null,      
MaritalDivorced             char(1)      null,      
MaritalWidowed              char(1)      null,      
MaritalSeparated            char(1)      null,      
MaritalUnknown              char(1)      null,      
MaritalRemarried            char(1)      null,      
ReferralSource              varchar(50)  null,      
PCPContactId                int          null,      
PrimaryCarePhysician        varchar(150) null,      
PCPPhone                    varchar(14)  null,      
PCPAddress                  varchar(150) null,      
EmergencyContactId          int          null,      
EmergencyContactName        varchar(100) null,      
EmergencyAddress            varchar(200) null,      
EmergencyPhone              varchar(50)  null,      
ParentContactId             int          null,      
ParentName                  varchar(100) null,      
ParentAddress               varchar(200) null,      
ParentPhone                 varchar(50)  null,      
ParentGuardian    varchar(1)  null,      
GuardianContactId           int          null,      
GuardianName                varchar(100) null,      
GuardianAddress             varchar(200) null,      
GuardianPhone               varchar(50)  null,      
PayeeContactId              int          null,      
PayeeName                   varchar(100) null,      
PayeeAddress                varchar(200) null,      
PayeePhone                  varchar(50)  null,      
VeteranYes                  char(1)      null,      
VeteranNo                   char(1)      null,      
EmploymentFullTime          char(1)      null, --1      
EmploymentPartTime          char(1)      null, --2      
EmploymentUnemployed        char(1)      null, --3      
--EmploymentNotInWorkforce    char(1)      null, --4      
--EmploymentRetired           char(1)      null, --6      
EmploymentSheltered         char(1)      null, --7      
--EmploymentNotApplicable     char(1)      null, --8      
--EmploymentSupportedOnly     char(1)      null, --9      
--EmploymentSupportedComp     char(1)      null, --10      
EmploymentUnpaid   char(1)   null, --11      
EmploymentSelfEmployed  char(1)   null, --12      
EmploymentTransitional  char(1)   null, --13      
EmploymentFacilities  char(1)   null, --14      
EmploymentNotInWorkforce char(1)   null, --15      
EmploymentNull    char(1)   null, --Unreported      
LanguageEnglish             char(1)      null,      
LanguageSpanish             char(1)      null,      
LanguageGerman              char(1)      null,      
LanguageFrench              char(1)      null,      
LanguageSign                char(1)      null,      
LanguageInterpreter     char(1)      null,      
LanguageAssisted            char(1)      null,      
LanguageOther               char(1)      null,      
IncomeAdoptSubsidy          char(1)      null,      
IncomeAlimony               char(1)      null,      
IncomeWorkersComp           char(1)      null,      
IncomeSSI                   char(1)      null,      
IncomeSSDI                  char(1)      null,      
IncomeSSA                   char(1)      null,      
IncomeAnnual                money        null,      
IncomeMinimumWageYes        char(1)      null,      
IncomeMinimumWageNo         char(1)      null,      
LivingPrivate               char(1)      null,      
LivingPrivateFamily         char(1)      null,      
LivingSupportedIndProgram   char(1)      null,      
LivingFoster                char(1)      null,      
LivingSpecialResidential    char(1)      null,      
LivingGeneralResidential    char(1)      null,      
LivingPrison      char(1)      null,      
LivingNursing      char(1)      null,      
LivingInstitutional     char(1)      null,      
LivingHomeless      char(1)      null,      
RaceNative      char(1)      null,      
RaceAsian      char(1)      null,      
RaceAfrican      char(1)      null,      
RaceWhite      char(1)      null,      
RaceHispanic      char(1)      null,      
RaceMulti      char(1)      null,      
RaceArab      char(1)      null,      
EducationLessThanHighSchool char(1)      null,      
EducationHighSchool     char(1)      null,      
EducationInK12      char(1)      null,      
EducationInTraining     char(1)      null,      
EducationSpecial            char(1)      null,      
EducationUndergraduate      char(1)      null,      
EducationGraduate           char(1)      null,      
EducationunReported         char(1)      null,      
InsuranceCOBOrder           smallint     null,      
InsuranceName               varchar(50)  null,      
InsuranceAddress            varchar(200) null,      
InsuranceSubscriberName     varchar(100) null,      
InsuranceSubscriberDOB      datetime     null,      
InsuranceInsuredId          varchar(30)  null,      
InsuranceGroupNumber        varchar(30)  null,      
InsuranceEmployer           varchar(30)  null,      
InsuranceFirstCoverage      tinyint      null,      
ClientSurveyYes             char(1)      null,      
ClientSurveyNo              char(1)      null,      
ReferralComment             text         null,      
PageNumber                  int          null default 1)      
      
      
declare @CoverageInfo table (      
ClientId                int          null,       
InsuranceCOBOrder smallint     null,      
InsuranceName           varchar(50)  null,      
InsuranceAddress        varchar(150) null,      
InsuranceSubscriberName varchar(150) null,      
InsuranceSubscriberDOB datetime     null,      
InsuranceInsuredId      varchar(30)  null,      
InsuranceGroupNumber    varchar(30)  null,      
InsuranceEmployer       varchar(30)  null,      
InsuranceFirstCoverage tinyint      null)      
      
if @ReceptionViewId is not null      
  insert into @InfoSheetClients (      
         ClientId)      
  select ClientId      
    from Clients c      
   where isnull(RecordDeleted, 'N') = 'N'      
     and exists(select *      
                  from Services s      
                       join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId      
                       join ReceptionViews rv on rv.ReceptionViewId = @ReceptionViewId      
                       left join ReceptionViewStaff rs on rs.ReceptionViewId = rv.ReceptionViewId and      
                                                          isnull(rs.RecordDeleted, 'N') = 'N'      
                       left join ReceptionViewPrograms rp on rp.ReceptionViewId = rv.ReceptionViewId and      
                                                             isnull(rp.RecordDeleted, 'N') = 'N'      
                       left join ReceptionViewLocations rl on rl.ReceptionViewId = rv.ReceptionViewId and      
                                                              isnull(rl.RecordDeleted, 'N') = 'N'      
                 where s.ClientId = c.ClientId      
                   and s.Status = 70 -- Scheduled      
                   and isnull(s.RecordDeleted, 'N') = 'N'      
                   --and pc.ProcedureCodeId in (71,165,148)  --av changed for intake screening,intake jail,annual clinic = 'INT_INTAKE'      
                   and datediff(dd, s.DateOfService, @SelectedDate) = 0      
                   and (rv.AllStaff = 'Y' or rs.StaffId = s.ClinicianId)      
                   and (rv.AllPrograms = 'Y' or rp.ProgramId = s.ProgramId)      
                   and (rv.AllLocations = 'Y' or rl.LocationId = s.LocationId))      
else       
  insert into @InfoSheetClients (ClientId) values (@ClientId)      
      
      
      
      
insert into @Results(      
       ReportingSection,      
       ClientId,      
       LastName,      
       firstName,      
       SSN,      
       DOB,      
       Sex,      
       County,      
       NumberOfDependents,      
       ReferralSource,      
       MaritalSingle,      
       MaritalMarried,      
       MaritalDivorced,      
       MaritalWidowed,      
       MaritalSeparated,      
    MaritalUnknown,      
    MaritalRemarried)      
--Modified for Barry GlobalCodes 11/9/2007 avoss      
select 1,      
       c.ClientId,      
       isnull(c.LastName, ''),      
       isnull(c.FirstName, ''),      
       case when len(rtrim(c.SSN)) = 9 then substring(c.SSN, 1, 3) + '-' + substring(c.SSN, 4, 2) + '-' + substring(c.SSN, 6, 4) else isnull(c.SSN, '') end,       
       c.DOB,      
       c.Sex,      
       co.CountyName,      
       c.NumberOfDependents,      
       gcre.CodeName,      
       case when gcm.GlobalCodeId = 10096 then 'X' else null end, --Never Married      
       case when gcm.GlobalCodeId = 10085 then 'X' else null end, --Married      
       case when gcm.GlobalCodeId = 10035 then 'X' else null end, --Divorced / Annulled      
       case when gcm.GlobalCodeId = 10166 then 'X' else null end, --Widowed      
       case when gcm.GlobalCodeId = 10136 then 'X' else null end, --Seperated      
       case when gcm.GlobalCodeId = 10163 then 'X' else null end, --Unknown      
       case when gcm.GlobalCodeId = 10127 then 'X' else null end  --Remarried      
  from @InfoSheetClients i      
       left join Clients c on c.ClientId = i.ClientId      
       left join Counties co on co.CountyFIPS = c.CountyOfResidence      
       left join GlobalCodes gcm on gcm.GlobalCodeId = c.MaritalStatus      
       left join ClientEpisodes ce on ce.ClientId = c.ClientId and      
                                      ce.EpisodeNumber = c.CurrentEpisodeNumber and      
                                      isnull(ce.RecordDeleted, 'N') = 'N'      
       left join GlobalCodes gcre on gcre.GlobalCodeId = ce.ReferralSource      
      
Update r      
   set Address = ca.Address,      
       City = ca.City,      
       State = ca.State,      
       Zip = ca.Zip      
  from @Results r      
       join ClientAddresses ca on ca.ClientId = r.ClientId      
 where ca.AddressType = 90 --Home      
   and isnull(ca.RecordDeleted, 'N') = 'N'      
      
update r      
   set HomePhone = p.HomePhone,      
       WorkPhone = p.WorkPhone,      
       SchoolPhone = p.SchoolPhone      
  from @Results r      
       join (select ClientId,      
                    max(case when PhoneType = 30 then PhoneNumber else null end) as HomePhone,      
         max(case when PhoneType = 31 then PhoneNumber else null end) as WorkPhone,      
                    max(case when PhoneType = 37 then PhoneNumber else null end) as SchoolPhone      
               from ClientPhones      
              where isnull(RecordDeleted, 'N') = 'N'      
              group by ClientId) as p on p.ClientId = r.ClientId      
      
      
insert into @results (      
  ReportingSection,      
  ClientId,      
  VeteranYes,      
  VeteranNo,      
  EmploymentFullTime, --1      
  EmploymentPartTime, --2      
  EmploymentUnemployed, --3      
  --EmploymentNotInWorkforce, --4      
  --EmploymentRetired, --6      
  EmploymentSheltered, --7      
  --EmploymentNotApplicable, --8      
  --EmploymentSupportedOnly, --9      
  --EmploymentSupportedComp, --10      
  EmploymentUnpaid, --11      
  EmploymentSelfEmployed, --12      
  EmploymentTransitional, --13      
  EmploymentFacilities, --14      
  EmploymentNotInWorkforce, --15      
  EmploymentNull, --Unreported      
  LanguageEnglish,      
  LanguageSpanish,      
  LanguageGerman,      
  LanguageFrench,      
  LanguageSign,      
  LanguageInterpreter,      
  LanguageAssisted,      
  LanguageOther,      
  LivingPrivate,      
  LivingPrivateFamily,      
  LivingSupportedIndProgram,      
  LivingFoster,      
  LivingSpecialResidential,      
  LivingGeneralResidential,      
  LivingPrison,      
  LivingNursing,      
  LivingInstitutional,      
  LivingHomeless,      
  EducationLessThanHighSchool,      
  EducationHighSchool,      
  EducationInK12,      
  EducationInTraining,      
  EducationSpecial,      
  EducationUndergraduate,      
  EducationGraduate,      
  EducationUnreported,      
  IncomeAnnual,      
  IncomeMinimumWageYes,      
  IncomeMinimumWageNo)      
--Modified for Barry Global Codes 11/9/2007 avoss      
select 6,      
       c.ClientId,      
       case when gcms.ExternalCode1 not in ('NS') then 'X' else null end, --Service      
       case when gcms.ExternalCode1 = 'NS' then 'X' else null end, --No Service      
      
--       case when gcem.GlobalCodeId = 10048 then 'X' else null end, --Full Time      
--       case when gcem.GlobalCodeId = 10112 then 'X' else null end, --Part Time      
--       case when gcem.GlobalCodeId = 10161 then 'X' else null end, --Unemployed      
--       case when gcem.GlobalCodeId in (10102,10034,10161) then 'X' else null end,  --Not in work force, disabled, unemployed      
--       case when gcem.GlobalCodeId = 10128 then 'X' else null end, --Retired      
--       case when gcem.GlobalCodeId in (10137,10430) then 'X' else null end,  --Sheltered /Supported Employement,Unpaid Work *This may need changes Need to check with Deb Brice      
--       case when gcem.GlobalCodeId = 10101 then 'X' else null end,  --Not Applicable (under 18)        
--Employment Status update 4/1/2010 - djh      
       case when gcem.ExternalCode1 = '1' then 'X' else null end,      
       case when gcem.ExternalCode1 = '2' then 'X' else null end,      
       case when gcem.ExternalCode1 = '3' then 'X' else null end,      
--       case when gcem.ExternalCode1 = '4' then 'X' else null end,      
--       case when gcem.ExternalCode1 = '6' then 'X' else null end,      
       case when gcem.ExternalCode1 = '7' then 'X' else null end,      
--       case when gcem.ExternalCode1 = '8' then 'X' else null end,      
--       case when gcem.ExternalCode1 = '9' then 'X' else null end,      
--       case when gcem.ExternalCode1 = '10' then 'X' else null end,      
       case when gcem.ExternalCode1 = '11' then 'X' else null end,      
       case when gcem.ExternalCode1 = '12' then 'X' else null end,      
       case when gcem.ExternalCode1 = '13' then 'X' else null end,      
       case when gcem.ExternalCode1 = '14' then 'X' else null end,      
       case when gcem.ExternalCode1 = '15' then 'X' else null end,      
    case when gcem.ExternalCode1 is null then 'X' else null end,          
--Not all Languages are in Global Codes      
       case when gcln.ExternalCode1 = 'EN' then 'X' else null end,      
       case when gcln.ExternalCode1 = 'SP' then 'X' else null end,      
       case when gcln.ExternalCode1 = 'GE' then 'X' else null end,      
       case when gcln.ExternalCode1 = 'AR' then 'X' else null end, --Arabic      
       case when gcln.ExternalCode1 = 'JA' then 'X' else null end, --Japanese      
       case when gcln.ExternalCode1 = 'SIGN' then 'X' else null end,       
       case when gcln.ExternalCode1 = 'ASSIST' then 'X' else null end,      
       case when gcln.ExternalCode1 = 'OT' then 'X' else null end,       
--Living Arrangement      
       case when gcla.GlobalCodeId = 10118 then 'X' else null end, --Private Alone or w/spouse      
       case when gcla.GlobalCodeId = 10119 then 'X' else null end, --Private w/ Family      
       case when gcla.GlobalCodeId = 10155 then 'X' else null end, --Supported Independence Program      
       case when gcla.GlobalCodeId = 10044 then 'X' else null end, --Foster Family Home      
       case when gcla.GlobalCodeId = 10145 then 'X' else null end, --Specialized Residential Home      
       case when gcla.GlobalCodeId = 10050 then 'X' else null end, --General Residential Home      
       case when gcla.GlobalCodeId = 10117 then 'X' else null end, --Prison/Jail/Juvenile Detention Center      
       case when gcla.GlobalCodeId = 10104 then 'X' else null end, --Nursing Care Facility      
       case when gcla.GlobalCodeId = 10068 then 'X' else null end, --Institutional Setting      
       case when gcla.GlobalCodeId = 10064 then 'X' else null end, --Homeless/Homeless Shelter      
      
       case when gced.GlobalCodeId = 10022 then 'X' else null end, --Completed less than high school      
       case when gced.GlobalCodeId = 10169 then 'X' else null end, --Completed HS or Spec Ed or GED      
       case when gced.GlobalCodeId = 10176 then 'X' else null end, --In school - K through 12      
       case when gced.GlobalCodeId = 10179 then 'X' else null end, --Training program      
       case when gced.GlobalCodeId = 10182 then 'X' else null end, --Special Education      
       case when gced.GlobalCodeId = 10183 then 'X' else null end, --Attended or attending college      
       case when gced.GlobalCodeId = 10184 then 'X' else null end, --College Graduate      
       case when gced.GlobalCodeId = 10185 then 'X' else null end, --No Formal Education      
       c.AnnualHouseholdIncome,      
       case when c.MinimumWage = 'Yes' then 'X'  else null end,      
       case when c.MinimumWage = 'No' then 'X'  else null end      
  from @InfoSheetClients i      
       left join Clients c on c.ClientId = i.ClientId      
       left join GlobalCodes gcms on gcms.GlobalCodeId = c.MilitaryStatus       
       left join GlobalCodes gcem on gcem.GlobalCodeId = c.EmploymentStatus      
       left join GlobalCodes gcln on gcln.GlobalCodeId = c.PrimaryLanguage      
       left join GlobalCodes gcla on gcla.GlobalCodeId = c.LivingArrangement      
       left join GlobalCodes gced on gced.GlobalCodeId = c.EducationalStatus      
      
      
      
--Modified for Barry Global Codes 11/9/2007      
update r      
   set RaceNative = cr.RaceNative,      
       RaceAsian = cr.RaceAsian,      
       RaceAfrican = cr.RaceAfrican,      
       RaceWhite = cr.RaceWhite,      
       RaceHispanic = cr.RaceHispanic,      
       RaceMulti = cr.RaceMulti,      
       RaceArab = cr.RaceArab      
  from @Results r       
       join (select cr.ClientId,      
                    max(case when gc.GlobalCodeId = 10093 then 'X' else null end) as RaceNative,      
                    max(case when gc.GlobalCodeId = 10006 then 'X' else null end) as RaceAsian,      
                    max(case when gc.GlobalCodeId = 10011 then 'X' else null end) as RaceAfrican,      
                    max(case when gc.GlobalCodeId = 10165 then 'X' else null end) as RaceWhite,      
                    max(case when gc.GlobalCodeId = 10062 then 'X' else null end) as RaceHispanic,      
 max(case when gc.GlobalCodeId = 10092 then 'X' else null end) as RaceMulti,      
                    max(case when gc.GlobalCodeId = 10004 then 'X' else null end) as RaceArab      
               from ClientRaces cr      
                    join GlobalCodes gc on gc.GlobalCodeId = cr.RaceId      
              where isnull(cr.RecordDeleted, 'N') = 'N'      
              group by cr.ClientId) cr on cr.ClientId = r.ClientId      
 where r.ReportingSection = 6      
      
      
update r      
   set ClientSurveyYes = cs.ClientSurveyYes,      
       ClientSurveyNo = cs.ClientSurveyNo      
  from @Results r      
       join(select d.ClientId,      
                   max(case when dt.CustomerSatisfactionSurvey = 'Y' then 'X' else null end) as ClientSurveyYes,      
                   max(case when dt.CustomerSatisfactionSurvey = 'N' then 'X' else null end) as ClientSurveyNo      
              from Documents d      
              --Edit In Lines Below      
                   join CustomDateTracking dt on dt.DocumentVersionId = d.DocumentId and      
                                                 dt.DocumentVersionId = d.CurrentDocumentVersionId      
              --End Edit      
             where DateDiff(dd, d.EffectiveDate, GetDate()) >= 0      
               and isnull(d.RecordDeleted, 'N') = 'N'      
               and not exists (select *      
                                 from Documents d2       
                                 --Edits In the Lines Below      
                                      join CustomDateTracking dt2 on dt2.DocumentVersionId = d2.DocumentId and      
                                                                     dt2.DocumentVersionId = d2.CurrentDocumentVersionId      
                  --End Edits      
                                  where d2.ClientId = d.ClientId       
                                    and DateDiff(dd, d2.EffectiveDate, GetDate()) >= 0      
                                    and d2.EffectiveDate < d2.EffectiveDate      
                                    and isnull(d2.RecordDeleted, 'N') = 'N')      
             group by d.ClientId) as cs on cs.ClientId = r.ClientId      
 where r.ReportingSection = 6      
      
      
      
--      
-- get primary care physician      
--      
update r       
   set PCPContactId = cc.ClientContactId,      
       PrimaryCarePhysician = cc.LastName + ', ' + cc.FirstName,      
       PCPAddress = isnull(cca.Address, '') +      
                    case when cca.City is not null then ', ' + cca.City else '' end +       
                    case when cca.State is not null then ', ' + cca.State else '' end +       
                    case when cca.Zip is not null then ' ' + cca.Zip else '' end,      
       PCPPhone = ccp.PhoneNumber      
  from @Results r      
       join ClientContacts cc on cc.ClientId = r.ClientId      
       join GlobalCodes gc on gc.GlobalCodeId = cc.Relationship and gc.GlobalCodeId = 10410 --avoss personal care physician      
       left join ClientContactAddresses cca on cca.ClientContactId = cc.ClientContactId and       
                                               cca.AddressType = 90 and      
                                               isnull(cca.RecordDeleted, 'N') = 'N'      
       left join ClientContactPhones ccp on ccp.ClientContactId = cc.ClientContactId and       
                                            ccp.PhoneType = 30 and      
                                            isnull(ccp.RecordDeleted, 'N') = 'N'      
 where r.ReportingSection = 6      
   and isnull(cc.RecordDeleted, 'N') = 'N'      
      
--      
-- get emergency contact      
--      
insert into @Results(      
       ReportingSection,      
       ClientId,      
       EmergencyContactId,      
       EmergencyContactName)      
select 2,      
       i.ClientId,      
       cc.ClientContactId,      
       cc.LastName + ', ' + cc.FirstName      
  from @InfoSheetClients i      
       left join ClientContacts cc on cc.ClientId = i.ClientId and      
                            cc.EmergencyContact = 'Y' and      
                                      isnull(cc.RecordDeleted, 'N') = 'N'      
      
      
update r       
   set EmergencyAddress = isnull(cca.Address, '') +      
                          case when cca.City is not null then ', ' + cca.City else '' end +       
                          case when cca.State is not null then ', ' + cca.State else '' end +       
                         case when cca.Zip is not null then ' ' + cca.Zip else '' end      
  from @Results r      
       join ClientContactAddresses cca on cca.ClientContactId = r.EmergencyContactId and cca.AddressType = 90      
 where r.ReportingSection = 2      
   and isnull(cca.RecordDeleted, 'N') = 'N'      
              
update r       
   set EmergencyPhone = ccp.PhoneNumber      
  from @Results r      
       join ClientContactPhones ccp on ccp.ClientContactId = r.EmergencyContactId and ccp.PhoneType = 30      
 where r.ReportingSection = 2      
   and isnull(ccp.RecordDeleted, 'N') = 'N'      
      
      
--      
-- get parent(s)      
-- 11/9/2007 Modified for Barry External Global Codes      
insert into @results (      
       ReportingSection,      
       ClientId,      
       ParentContactId,      
       ParentName)      
select 3,      
       i.ClientId,      
       cc.ClientContactId,      
       cc.ContactName      
  from @InfoSheetClients i      
       left join (select cc.ClientId,      
                         cc.ClientContactId,      
                         cc.LastName + ', ' + cc.FirstName as ContactName      
                    from ClientContacts cc      
                         join GLobalCodes gc on gc.GlobalCodeId = cc.Relationship and       
                                                gc.ExternalCode1 in ('FOSTMOM', 'FOSTPAR','MOTHER','PARENT','FATHER')       
                   where isnull(cc.RecordDeleted, 'N') = 'N') as cc on cc.ClientId = i.ClientID                      
      
update r       
   set ParentAddress = isnull(cca.Address, '') +      
                       case when cca.City is not null then ', ' + cca.City else '' end +       
                       case when cca.State is not null then ', ' + cca.State else '' end +       
                       case when cca.Zip is not null then ' ' + cca.Zip else '' end      
  from @Results r      
       join ClientContactAddresses cca on cca.ClientContactId = r.ParentContactId and cca.AddressType = 90      
 where r.ReportingSection = 3      
   and isnull(cca.RecordDeleted, 'N') = 'N'      
              
update r       
   set ParentPhone = ccp.PhoneNumber      
  from @Results r      
       join ClientContactPhones ccp on ccp.ClientContactId = r.ParentContactId and ccp.PhoneType = 30      
 where r.ReportingSection = 3      
   and isnull(ccp.RecordDeleted, 'N') = 'N'      
      
--      
-- get guardian(s)      
-- 11/9/2007 Updated for Barry Global COdes       
insert into @results (      
       ReportingSection,      
       ClientId,      
       GuardianContactId,      
       GuardianName)      
select 4,      
       i.ClientId,      
       cc.ClientContactId,      
       cc.ContactName      
  from @InfoSheetClients i      
       left join (select cc.ClientId,      
                         cc.ClientContactId,      
                         cc.LastName + ', ' + cc.FirstName as ContactName      
                    from ClientContacts cc      
                         join GLobalCodes gc on gc.GlobalCodeId = cc.Relationship       
                   where (gc.GlobalCodeId in (10060,10408,10409) or cc.Guardian = 'Y')      
                     and isnull(cc.RecordDeleted, 'N') = 'N') as cc on cc.ClientId = i.ClientID                      
      
      
update r       
   set GuardianAddress = isnull(cca.Address, '') +      
                         case when cca.City is not null then ', ' + cca.City else '' end +       
                         case when cca.State is not null then ', ' + cca.State else '' end +       
                         case when cca.Zip is not null then ' ' + cca.Zip else '' end      
  from @Results r      
       join ClientContactAddresses cca on cca.ClientContactId = r.GuardianContactId and cca.AddressType = 90      
 where r.ReportingSection = 4      
   and isnull(cca.RecordDeleted, 'N') = 'N'      
              
update r       
   set GuardianPhone = ccp.PhoneNumber      
  from @Results r      
       join ClientContactPhones ccp on ccp.ClientContactId = r.GuardianContactId and ccp.PhoneType = 30      
 where r.ReportingSection = 4      
   and isnull(ccp.RecordDeleted, 'N') = 'N'      
      
--      
-- get financially responsible      
--      
insert into @results (      
       ReportingSection,      
       ClientId,      
       PayeeContactId,      
       PayeeName)      
select 5,      
       i.ClientId,      
       cc.ClientContactId,      
       cc.ContactName      
  from @InfoSheetClients i      
       left join (select cc.ClientId,      
                         cc.ClientContactId,      
                         cc.LastName + ', ' + cc.FirstName as ContactName      
                    from ClientContacts cc      
                         join GLobalCodes gc on gc.GlobalCodeId = cc.Relationship       
where cc.FinanciallyResponsible = 'Y'      
                     and isnull(cc.RecordDeleted, 'N') = 'N') as cc on cc.ClientId = i.ClientID                      
      
update r       
   set PayeeAddress = isnull(cca.Address, '') +      
                      case when cca.City is not null then ', ' + cca.City else '' end +       
                      case when cca.State is not null then ', ' + cca.State else '' end +       
                      case when cca.Zip is not null then ' ' + cca.Zip else '' end      
  from @Results r      
       join ClientContactAddresses cca on cca.ClientContactId = r.PayeeContactId and cca.AddressType = 90      
 where r.ReportingSection = 5      
   and isnull(cca.RecordDeleted, 'N') = 'N'      
              
update r       
   set PayeePhone = ccp.PhoneNumber      
  from @Results r      
       join ClientContactPhones ccp on ccp.ClientContactId = r.PayeeContactId and ccp.PhoneType = 30      
 where r.ReportingSection = 5      
   and isnull(ccp.RecordDeleted, 'N') = 'N'      
      
      
--      
-- get coverage info      
--  Left off HERE AVOSS 11/9/2007      
      
insert into @CoverageInfo (      
       ClientId,      
       InsuranceCOBOrder,      
       InsuranceName,      
       InsuranceAddress,      
       InsuranceSubscriberName,      
       InsuranceSubscriberDOB,      
       InsuranceInsuredId,      
       InsuranceGroupNumber,      
       InsuranceEmployer,      
       InsuranceFirstCoverage)      
select i.ClientId,      
       cch.COBOrder,      
       cp.CoveragePlanName,      
       isnull(cp.Address, '') +       
       case when cp.City is not null then ', ' + cp.City else '' end +       
       case when cp.State is not null then ', ' + cp.State else '' end +       
       case when cp.ZipCode is not null then ' ' + cp.ZipCode else '' end,      
       case when ccp.ClientIsSubscriber = 'Y' then c.LastName + ', ' + c.FirstName      
            else cc.LastName + ', ' + cc.FirstName       
       end,      
       case when ccp.ClientIsSubscriber = 'Y' then c.DOB      
            else cc.DOB      
       end,      
       ccp.InsuredId,      
       ccp.GroupNumber,      
       ccp.GroupName,      
       0      
  from @InfoSheetClients i      
       join ClientCoveragePlans ccp on ccp.ClientId = i.ClientId      
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId       
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId       
       join Clients c on c.ClientId = i.ClientId      
       left join ClientContacts cc on cc.ClientContactId = ccp.SubscriberContactId and isnull(cc.RecordDeleted, 'N') = 'N'      
 where cp.CoveragePlanName not like '% - IP%'      
   and cp.DisplayAs not in ('GF_POV', 'MED-SPDN')      
   and datediff(dd, cch.StartDate, GetDate())>= 0      
   and (datediff(dd, cch.EndDate, GetDate()) <= 0 or cch.EndDate is null)      
   and isnull(cch.RecordDeleted, 'N') = 'N'      
   and isnull(ccp.RecordDeleted, 'N') = 'N'      
   and isnull(cp.RecordDeleted, 'N') = 'N'      
      
      
--      
-- Add blank rows for report      
--      
insert into @CoverageInfo (      
       ClientId,      
       InsuranceCOBOrder,      
       InsuranceFirstCoverage)      
select i.ClientId,      
       1,      
       0      
  from @InfoSheetClients i      
 where not exists (select *       
                     from @CoverageInfo ci       
                    where ci.ClientId = i.ClientId)      
      
insert into @CoverageInfo (      
       ClientId,      
       InsuranceCOBOrder,      
       InsuranceFirstCoverage)      
select i.ClientId,      
       2,      
       0      
  from @InfoSheetClients i      
 where 1 = (select count(*) from @CoverageInfo ci where ci.ClientId = i.ClientId)      
      
update ci      
   set InsuranceFirstCoverage = 1      
  from @CoverageInfo ci      
 where not exists (select *      
       from @CoverageInfo ci2      
      where ci2.ClientId = ci.ClientId      
                      and ci2.InsuranceCOBOrder < ci.InsuranceCOBOrder)      
      
      
insert into @Results (      
       ReportingSection,       
       ClientId,      
       InsuranceCOBOrder,      
       InsuranceName,      
       InsuranceAddress,      
       InsuranceSubscriberName,      
       InsuranceSubscriberDOB,      
       InsuranceInsuredId,      
       InsuranceGroupNumber,      
       InsuranceEmployer,      
       InsuranceFirstCoverage)      
select 7,      
       ci.ClientId,      
       ci.InsuranceCOBOrder,      
       ci.InsuranceName,      
       ci.InsuranceAddress,      
       ci.InsuranceSubscriberName,      
       ci.InsuranceSubscriberDOB,      
       ci.InsuranceInsuredId,      
       ci.InsuranceGroupNumber,      
       ci.InsuranceEmployer,      
       ci.InsuranceFirstCoverage      
  from @CoverageInfo ci      
      
--      
-- Initial intake summary      
--      
if @ReceptionViewId is not null      
begin      
  insert into @Results (ReportingSection, ClientId) values(0, -1)      
  insert into @Results (ReportingSection, ClientId) values(0, -2)      
      
  insert into @Results (      
         ReportingSection,      
         ClientId,      
         ReferralComment,      
         PageNumber)      
  select 8,      
         i.ClientId,      
         ce.ReferralComment,      
         2      
    from @InfoSheetClients i      
         join Clients c on c.ClientId = i.ClientId       
         join ClientEpisodes ce on ce.ClientId = c.ClientId and      
                                   ce.EpisodeNumber = c.CurrentEpisodeNumber      
   where ReferralComment is not null      
      
end      
      
               
select r.*       
  from @Results r      
       left join Clients c on c.ClientId = r.ClientId      
 order by case r.ClientId when -1 then 1 when -2 then 3 else 2 end,      
          c.LastName, c.FirstName, r.ClientId, r.ReportingSection, r.InsuranceCOBOrder