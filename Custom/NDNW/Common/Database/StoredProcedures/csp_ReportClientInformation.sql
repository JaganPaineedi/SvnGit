           /****** Object:  StoredProcedure [dbo].[csp_ReportClientInformation]        ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientInformation]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportClientInformation]        ******/
SET ANSI_NULLS ON
GO
 
 
 CREATE procedure [dbo].[csp_ReportClientInformation]  
@ClientId int = null,  
@ReceptionViewId int = null,  
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
-- 05.15.2008  avoss    modified for changed client demographic globalcodes  
-- 08.13.2008  avoss    modified for ParentGuardian field and mapped parent guardian correctly  
-- 03.30.2010  dharvey    modified for Employment Status changes required for DCH to be implemented 4.1.2010  
-- 02.29.2012  avoss    modified for Harbor Customization and do not filter on any intake procedure codes, this will have to be changed again for   
         any harbor customizations.  
--05 Nov 2015 Ravichandra	what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--							why:task #609, Network180 Customization  
*********************************************************************************/  
as  
Set ANSI_Warnings OFF  
declare @InfoSheetClients table (ClientId int null)  
  
declare @Results table (  
ReportingSection            decimal(8,2)          null,  
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
HomePhone                   varchar(14)  null,  
WorkPhone                   varchar(14)  null,  
SchoolPhone                 varchar(14)  null,  
NumberOfDependents          int          null,  
MaritalSingle               char(1)      null,  
MaritalMarried              char(1)      null,  
MaritalDivorced             char(1)      null,  
MaritalWidowed              char(1)      null,  
MaritalSeparated            char(1)      null,  
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
LanguageInterpreter   char(1)      null,  
LanguageAssisted            char(1)      null,  
LanguageOther               char(1)      null,  
LanguageJapanese   char(1)   null,--  
LanguageArabic    char(1)   null,--  
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
RaceOther      char(1)      null, --changed from hisp  
RaceMulti      char(1)      null,  
RaceArab      char(1)      null,  
RaceHawaii   char(1)   null,--  
RaceUnknown   char(1)   null,--  
RaceRefused   char(1)   null,--  
EducationLessThanHighSchool char(1)      null,  
EducationHighSchool     char(1)      null,  
EducationInK12      char(1)      null,  
EducationInTraining     char(1)      null,  
EducationSpecial            char(1)      null,  
EducationUndergraduate      char(1)      null,  
EducationGraduate           char(1)      null,  
EducationunReported         char(1)      null,  
InsuranceCOBOrder           smallint     null,  
InsuranceName               varchar(55)  null,  
InsuranceAddress            varchar(200) null,  
InsuranceSubscriberName     varchar(100) null,  
InsuranceSubscriberDOB      datetime     null,  
InsuranceInsuredId          varchar(30)  null,  
InsuranceGroupNumber        varchar(30)  null,  
InsuranceEmployer           varchar(30)  null,  
InsuranceFirstCoverage      tinyint      null,  
SecondaryInsuranceCOBOrder           smallint     null,  
SecondaryInsuranceName               varchar(55)  null,  
SecondaryInsuranceAddress            varchar(200) null,  
SecondaryInsuranceSubscriberName     varchar(100) null,  
SecondaryInsuranceSubscriberDOB      datetime     null,  
SecondaryInsuranceInsuredId          varchar(30)  null,  
SecondaryInsuranceGroupNumber        varchar(30)  null,  
SecondaryInsuranceEmployer           varchar(30)  null,  
SecondaryInsuranceFirstCoverage      tinyint      null,  
  
ClientSurveyYes             char(1)      null,  
ClientSurveyNo              char(1)      null,  
ReferralComment             text         null,   
CorrectionsArrested   char(1)   null, --av start  
CorrectionsAwaitSentance char(1)   null,  
CorrectionsAwaitTrial  char(1)   null,  
CorrectionsRefused   char(1)   null,  
CorrectionsDiverted   char(1)   null,  
CorrectionsInJail   char(1)   null,  
CorrectionsInPrison   char(1)   null,  
CorrectionsJuvenileDet  char(1)   null,  
CorrectionsMinorReferred char(1)   null,  
CorrectionsNoJurisdiction char(1)   null,  
CorrectionsParole   char(1)   null,  
CorrectionsProbation  char(1)   null,  
CorrectionsCourtSupervision char(1)   null,    
HispanicOriginYes   char(1)   null,  
HispanicOriginNo   char(1)   null,  
HispanicOriginUnknown  char(1)   null,  
StateAdoptionStudyYes  char(1)   null,  
StateAdoptionStudyNo  char(1)   null,  
StateSSIYes     char(1)   null,  
StateSSINo     char(1)   null,  
StateParentofYoungChildYes char(1)   null,  
StateParentofYoungChildNo char(1)   null,  
StateChildFIAAbuseYes  char(1)   null,  
StateChildFIAAbuseNo  char(1)   null,  
StateChildFIAOtherYes  char(1)   null,  
StateChildFIAOtherNo  char(1)   null,  
StateEarlyOnProgramYes  char(1)   null,  
StateEarlyOnProgramNo  char(1)   null,  
StateWrapAroundYes   char(1)   null,  
StateWrapAroundNo   char(1)   null,  
StateEPSDTYes    char(1)   null,  
StateEPSDTNo    char(1)   null, --av end  
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
    from Clients c with(nolock)  
   where isnull(RecordDeleted, 'N') = 'N'  
     and exists(select 1  
                  from Services s with(nolock)  
                       join ProcedureCodes pc with(nolock) on pc.ProcedureCodeId = s.ProcedureCodeId  
                       join ReceptionViews rv with(nolock) on rv.ReceptionViewId = @ReceptionViewId  
                       left join ReceptionViewStaff rs with(nolock) on rs.ReceptionViewId = rv.ReceptionViewId and  
                                                          isnull(rs.RecordDeleted, 'N') = 'N'  
                       left join ReceptionViewPrograms rp with(nolock) on rp.ReceptionViewId = rv.ReceptionViewId and  
                                                             isnull(rp.RecordDeleted, 'N') = 'N'  
                       left join ReceptionViewLocations rl with(nolock) on rl.ReceptionViewId = rv.ReceptionViewId and  
                                                              isnull(rl.RecordDeleted, 'N') = 'N'  
                 where s.ClientId = c.ClientId  
                   and s.Status = 70 -- Scheduled  
                   and isnull(s.RecordDeleted, 'N') = 'N'  
       --and s.procedurecodeid in (274, 752, 725, 740)  
  --                 and pc.ExternalCode1 = 'INT_INTAKE'  
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
       MaritalSeparated)  
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
       case when gcm.ExternalCode1 = 'S' then 'X' else null end,  
       case when gcm.ExternalCode1 = 'M' then 'X' else null end,  
       case when gcm.ExternalCode1 = 'D' then 'X' else null end,  
       case when gcm.ExternalCode1 = 'W' then 'X' else null end,  
       case when gcm.ExternalCode1 = 'P' then 'X' else null end  
  from @InfoSheetClients i  
       left join Clients c with(nolock) on c.ClientId = i.ClientId  
       left join Counties co with(nolock) on co.CountyFIPS = c.CountyOfResidence  
       left join GlobalCodes gcm with(nolock) on gcm.GlobalCodeId = c.MaritalStatus  
       left join ClientEpisodes ce with(nolock) on ce.ClientId = c.ClientId and  
                                      ce.EpisodeNumber = c.CurrentEpisodeNumber and  
                                      isnull(ce.RecordDeleted, 'N') = 'N'  
       left join GlobalCodes gcre with(nolock) on gcre.GlobalCodeId = ce.ReferralSource  
  
update r  
   set Address = ca.Address,  
       City = ca.City,  
       State = ca.State,  
       Zip = ca.Zip  
  from @Results r  
       join ClientAddresses ca with(nolock) on ca.ClientId = r.ClientId  
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
               from ClientPhones with(nolock)  
              where isnull(RecordDeleted, 'N') = 'N'  
              group by ClientId) as p on p.ClientId = r.ClientId  
  
  
insert into @results (  
       ReportingSection,  
       ClientId,  
       LanguageEnglish,  
       LanguageSpanish,  
       LanguageGerman,  
       LanguageFrench,  
       LanguageSign,  
  --     LanguageInterpreter,  
 --      LanguageAssisted,  
 --      LanguageOther,  
    LanguageArabic, --  
    LanguageJapanese,--  
    HispanicOriginYes, --  
    HispanicOriginNo, --  
    HispanicOriginUnknown,  --  
       LivingHomeless,  
       LivingPrivateFamily,  
       LivingPrivate,  
       LivingFoster,  
       LivingSpecialResidential,  
       LivingGeneralResidential,  
       LivingPrison,  
       LivingNursing,  
       LivingInstitutional,  
       LivingSupportedIndProgram,  
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
       EducationLessThanHighSchool,  
       EducationHighSchool,  
       EducationInK12,  
       EducationInTraining,  
       EducationSpecial,  
       EducationUndergraduate,  
       EducationGraduate)  
select 7,  
       c.ClientId,  
  
       case when gcln.ExternalCode1 = 'eng' then 'X' else null end,  
       case when gcln.ExternalCode1 = 'spa' then 'X' else null end,  
       case when gcln.ExternalCode1 = 'ger' then 'X' else null end,  
       case when gcln.ExternalCode1 = 'fre' then 'X' else null end,  
       case when gcln.ExternalCode1 = 'sgn' then 'X' else null end,  
       case when gcln.ExternalCode1 = 'ara' then 'X' else null end,  
       case when gcln.ExternalCode1 = 'jpn' then 'X' else null end,  
  
       case when gcho.ExternalCode1 = '1' then 'X' else null end,  
       case when gcho.ExternalCode1 = '2' then 'X' else null end,  
       case when gcho.ExternalCode1 = '3' then 'X' else null end,  
  
       case when gcla.ExternalCode1 = '1' then 'X' else null end,  
       case when gcla.ExternalCode1 = '2' then 'X' else null end,  
       case when gcla.ExternalCode1 = '3' then 'X' else null end,  
       case when gcla.ExternalCode1 = '5' then 'X' else null end,  
       case when gcla.ExternalCode1 = '6' then 'X' else null end,  
       case when gcla.ExternalCode1 = '8' then 'X' else null end,  
       case when gcla.ExternalCode1 = '10' then 'X' else null end,  
       case when gcla.ExternalCode1 = '12' then 'X' else null end,  
       case when gcla.ExternalCode1 = '13' then 'X' else null end,  
       case when gcla.ExternalCode1 = '16' then 'X' else null end,  
  
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
  
       case when gced.ExternalCode1 = '1' then 'X' else null end,  
       case when gced.ExternalCode1 = '2' then 'X' else null end,  
       case when gced.ExternalCode1 = '3' then 'X' else null end,  
       case when gced.ExternalCode1 = '4' then 'X' else null end,  
       case when gced.ExternalCode1 = '6' then 'X' else null end,  
       case when gced.ExternalCode1 = '7' then 'X' else null end,  
       case when gced.ExternalCode1 = '8' then 'X' else null end  
  from @InfoSheetClients i  
       left join Clients c with(nolock) on c.ClientId = i.ClientId  
       left join GlobalCodes gcms with(nolock) on gcms.GlobalCodeId = c.MilitaryStatus   
       left join GlobalCodes gcem with(nolock) on gcem.GlobalCodeId = c.EmploymentStatus  
       left join GlobalCodes gcln with(nolock) on gcln.GlobalCodeId = c.PrimaryLanguage  
       left join GlobalCodes gcla with(nolock) on gcla.GlobalCodeId = c.LivingArrangement  
       left join GlobalCodes gced with(nolock) on gced.GlobalCodeId = c.EducationalStatus  
    left join GlobalCodes gcho with(nolock) on gcho.GlobalCodeId = c.HispanicOrigin  
  
update r  
   set RaceNative = cr.RaceNative,  
       RaceAsian = cr.RaceAsian,  
       RaceAfrican = cr.RaceAfrican,  
       RaceWhite = cr.RaceWhite,  
       RaceOther = cr.RaceOther,--  
       RaceMulti = cr.RaceMulti,  
       RaceArab = cr.RaceArab,  
    RaceHawaii = cr.RaceHawaii,--  
    RaceUnknown = cr.RaceUnknown,--  
    RaceRefused = cr.RaceRefused--  
  from @Results r   
       join (select cr.ClientId,  
                    max(case when gc.ExternalCode1 = 'c' then 'X' else null end) as RaceNative,  
                    max(case when gc.ExternalCode1 = 'd' then 'X' else null end) as RaceAsian,  
                    max(case when gc.ExternalCode1 = 'b' then 'X' else null end) as RaceAfrican,  
                    max(case when gc.ExternalCode1 = 'a' then 'X' else null end) as RaceWhite,  
                    max(case when gc.ExternalCode1 In ('HISPANIC','ARAB','MULTIRACIA','f') then 'X' else null end) as RaceOther,  
                    max(case when gc.ExternalCode1 = 'MULTIRACIA' then 'X' else null end) as RaceMulti,  
                    max(case when gc.ExternalCode1 = 'ARAB' then 'X' else null end) as RaceArab,  
                    max(case when gc.ExternalCode1 = 'e' then 'X' else null end) as RaceHawaii,  
                    max(case when gc.ExternalCode1 = 'g' then 'X' else null end) as RaceUnknown,  
                    max(case when gc.ExternalCode1 = 'h' then 'X' else null end) as RaceRefused  
               from ClientRaces cr with(nolock)  
                    join GlobalCodes gc with(nolock) on gc.GlobalCodeId = cr.RaceId  
              where isnull(cr.RecordDeleted, 'N') = 'N'  
              group by cr.ClientId) cr on cr.ClientId = r.ClientId  
 where r.ReportingSection = 7  
  
  
--Set to null to not show in customer information sheet per Sandy Hall 5-19-2008  
update r  
   set ClientSurveyYes = null,--cs.ClientSurveyYes,  
       ClientSurveyNo = null--cs.ClientSurveyNo  
  from @Results r  
       join(select d.ClientId,  
                   max(case when dt.CustomerSatisfactionSurvey = 'Y' then 'X' else null end) as ClientSurveyYes,  
                   max(case when dt.CustomerSatisfactionSurvey = 'N' then 'X' else null end) as ClientSurveyNo  
              from Documents d with(nolock)  
                   join CustomDateTracking dt with(nolock) on dt.DocumentVersionId = d.CurrentDocumentVersionId  
             where DateDiff(dd, d.EffectiveDate, GetDate()) >= 0  
               and isnull(d.RecordDeleted, 'N') = 'N'  
               and not exists (select 1  
                                 from Documents d2  with(nolock)  
                                      join CustomDateTracking dt2 with(nolock) on dt2.DocumentVersionId = d2.CurrentDocumentVersionId  
                                  where d2.ClientId = d.ClientId   
                                    and DateDiff(dd, d2.EffectiveDate, GetDate()) >= 0  
                                    and d2.EffectiveDate < d2.EffectiveDate  
                                    and isnull(d2.RecordDeleted, 'N') = 'N')  
             group by d.ClientId) as cs on cs.ClientId = r.ClientId  
 where r.ReportingSection = 7  
  
  
--reporting section 6  
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
  IncomeAnnual,  
  IncomeMinimumWageYes,  
  IncomeMinimumWageNo  
  )--  
select 6,  
       c.ClientId,  
       case when gcms.ExternalCode1 in ('VE', 'AC') then 'X' else null end,  
       case when gcms.ExternalCode1 not in ('VE', 'AC') then 'X' else null end,  
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
       c.AnnualHouseholdIncome,  
       case when c.MinimumWage = 'Yes' then 'X'  else null end,  
       case when c.MinimumWage = 'No' then 'X'  else null end  
  
  
  from @InfoSheetClients i  
       left join Clients c with(nolock) on c.ClientId = i.ClientId  
       left join GlobalCodes gcms with(nolock) on gcms.GlobalCodeId = c.MilitaryStatus   
       left join GlobalCodes gcem with(nolock) on gcem.GlobalCodeId = c.EmploymentStatus  
  
  
  
  
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
       join ClientContacts cc with(nolock) on cc.ClientId = r.ClientId  
       join GlobalCodes gc with(nolock) on gc.GlobalCodeId = cc.Relationship and gc.ExternalCode1 = 'PCP'  
       left join ClientContactAddresses cca with(nolock) on cca.ClientContactId = cc.ClientContactId and   
                                               cca.AddressType = 90 and  
                                               isnull(cca.RecordDeleted, 'N') = 'N'  
       left join ClientContactPhones ccp with(nolock) on ccp.ClientContactId = cc.ClientContactId and   
                                            ccp.PhoneType = 30 and  
                                            isnull(ccp.RecordDeleted, 'N') = 'N'  
 where r.ReportingSection = 7  
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
       left join ClientContacts cc with(nolock) on cc.ClientId = i.ClientId and  
                                      cc.EmergencyContact = 'Y' and  
                                      isnull(cc.RecordDeleted, 'N') = 'N'  
  
  
update r   
   set EmergencyAddress = isnull(cca.Address, '') +  
                          case when cca.City is not null then ', ' + cca.City else '' end +   
                          case when cca.State is not null then ', ' + cca.State else '' end +   
                         case when cca.Zip is not null then ' ' + cca.Zip else '' end  
  from @Results r  
       join ClientContactAddresses cca with(nolock) on cca.ClientContactId = r.EmergencyContactId and cca.AddressType = 90  
 where r.ReportingSection = 2  
   and isnull(cca.RecordDeleted, 'N') = 'N'  
          
update r   
   set EmergencyPhone = ccp.PhoneNumber  
  from @Results r  
       join ClientContactPhones ccp with(nolock) on ccp.ClientContactId = r.EmergencyContactId and ccp.PhoneType = 30  
 where r.ReportingSection = 2  
   and isnull(ccp.RecordDeleted, 'N') = 'N'  
  
  
--  
-- get parent(s)  
--  
insert into @results (  
       ReportingSection,  
       ClientId,  
       ParentContactId,  
       ParentName,  
    ParentGuardian)  
select 3,  
       i.ClientId,  
       cc.ClientContactId,  
       cc.ContactName,  
    cc.Guardian  
  from @InfoSheetClients i  
       left join (select cc.ClientId,  
                         cc.ClientContactId,  
                         cc.LastName + ', ' + cc.FirstName as ContactName,  
       isnull(cc.Guardian,'N') as Guardian  
                    from ClientContacts cc with(nolock)  
                         join GLobalCodes gc with(nolock) on gc.GlobalCodeId = cc.Relationship and   
                                                gc.ExternalCode2 in ('FA', 'MO')   
                   where isnull(cc.RecordDeleted, 'N') = 'N') as cc on cc.ClientId = i.ClientID            
update r   
   set ParentAddress = isnull(cca.Address, '') +  
                       case when cca.City is not null then ', ' + cca.City else '' end +   
                       case when cca.State is not null then ', ' + cca.State else '' end +   
                       case when cca.Zip is not null then ' ' + cca.Zip else '' end  
  from @Results r  
       join ClientContactAddresses cca with(nolock) on cca.ClientContactId = r.ParentContactId and cca.AddressType = 90  
 where r.ReportingSection = 3  
   and isnull(cca.RecordDeleted, 'N') = 'N'  
          
update r   
   set ParentPhone = ccp.PhoneNumber  
  from @Results r  
       join ClientContactPhones ccp with(nolock) on ccp.ClientContactId = r.ParentContactId and ccp.PhoneType = 30  
 where r.ReportingSection = 3  
   and isnull(ccp.RecordDeleted, 'N') = 'N'  
  
--  
-- get guardian(s)  
--  
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
                    from ClientContacts cc with(nolock)  
                         join GLobalCodes gc with(nolock) on gc.GlobalCodeId = cc.Relationship   
                   where (gc.ExternalCode1 = 'G' or cc.Guardian = 'Y')  
                     and isnull(cc.RecordDeleted, 'N') = 'N') as cc on cc.ClientId = i.ClientID                  
  
update r   
   set GuardianAddress = isnull(cca.Address, '') +  
                         case when cca.City is not null then ', ' + cca.City else '' end +   
                         case when cca.State is not null then ', ' + cca.State else '' end +   
                         case when cca.Zip is not null then ' ' + cca.Zip else '' end  
  from @Results r  
       join ClientContactAddresses cca with(nolock) on cca.ClientContactId = r.GuardianContactId and cca.AddressType = 90  
 where r.ReportingSection = 4  
   and isnull(cca.RecordDeleted, 'N') = 'N'  
          
update r   
   set GuardianPhone = ccp.PhoneNumber  
  from @Results r  
       join ClientContactPhones ccp with(nolock) on ccp.ClientContactId = r.GuardianContactId and ccp.PhoneType = 30  
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
                    from ClientContacts cc with(nolock)  
                         join GLobalCodes gc with(nolock) on gc.GlobalCodeId = cc.Relationship   
                   where cc.FinanciallyResponsible = 'Y'  
                     and isnull(cc.RecordDeleted, 'N') = 'N') as cc on cc.ClientId = i.ClientID                  
  
update r   
   set PayeeAddress = isnull(cca.Address, '') +  
                      case when cca.City is not null then ', ' + cca.City else '' end +   
                      case when cca.State is not null then ', ' + cca.State else '' end +   
                      case when cca.Zip is not null then ' ' + cca.Zip else '' end  
  from @Results r  
       join ClientContactAddresses cca with(nolock) on cca.ClientContactId = r.PayeeContactId and cca.AddressType = 90  
 where r.ReportingSection = 5  
   and isnull(cca.RecordDeleted, 'N') = 'N'  
          
update r   
   set PayeePhone = ccp.PhoneNumber  
  from @Results r  
       join ClientContactPhones ccp with(nolock) on ccp.ClientContactId = r.PayeeContactId and ccp.PhoneType = 30  
 where r.ReportingSection = 5  
   and isnull(ccp.RecordDeleted, 'N') = 'N'  
  
  
--  
-- get coverage info  
--  
  
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
       case when ccp.ClientIsSubscriber = 'Y' then 
       CASE 
		WHEN ISNULL(C.ClientType, 'I') = 'I' THEN ISNULL(C.LastName, '') +', ' +ISNULL(C.FirstName, '')
		ELSE ISNULL(C.OrganizationName, '') END  --Added by Ravichandra 05 Nov 2015
       --c.LastName + ', ' + c.FirstName  
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
       join ClientCoveragePlans ccp with(nolock) on ccp.ClientId = i.ClientId  
       join ClientCoverageHistory cch with(nolock) on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId   
       join CoveragePlans cp with(nolock) on cp.CoveragePlanId = ccp.CoveragePlanId   
       join Clients c with(nolock) on c.ClientId = i.ClientId  
       left join ClientContacts cc with(nolock) on cc.ClientContactId = ccp.SubscriberContactId and isnull(cc.RecordDeleted, 'N') = 'N'  
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
 where not exists (select 1  
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
 where not exists (select 1  
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
select 8,  
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
  where InsuranceCOBOrder = 1  
  
  
  
insert into @Results (  
       ReportingSection,   
       ClientId,  
       SecondaryInsuranceCOBOrder,  
       SecondaryInsuranceName,  
       SecondaryInsuranceAddress,  
       SecondaryInsuranceSubscriberName,  
       SecondaryInsuranceSubscriberDOB,  
       SecondaryInsuranceInsuredId,  
       SecondaryInsuranceGroupNumber,  
       SecondaryInsuranceEmployer,  
       SecondaryInsuranceFirstCoverage)  
select 9,  
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
  where InsuranceCOBOrder = 2  
  
/*  
  
update r  
set        ClientId = ci.ClientId,  
       SecondaryInsuranceCOBOrder = ci.InsuranceCOBOrder,  
       SecondaryInsuranceName = ci.InsuranceName,  
       SecondaryInsuranceAddress = ci.InsuranceAddress,  
       SecondaryInsuranceSubscriberName = ci.InsuranceSubscriberName,  
       SecondaryInsuranceSubscriberDOB = ci.InsuranceSubscriberDOB,  
       SecondaryInsuranceInsuredId = ci.InsuranceInsuredId,  
       SecondaryInsuranceGroupNumber =ci.InsuranceGroupNumber,  
       SecondaryInsuranceEmployer = ci.InsuranceEmployer,  
SecondaryInsuranceFirstCoverage = ci.InsuranceFirstCoverage  
from  @Results r  
join   @CoverageInfo ci on ci.clientid = r.clientid  
  where ci.InsuranceCOBOrder = 2  
and r.ReportingSection = 8  
  
*/  
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
  select 12,  
         i.ClientId,  
         ce.ReferralComment,  
         2  
    from @InfoSheetClients i  
         join Clients c with(nolock) on c.ClientId = i.ClientId   
         join ClientEpisodes ce with(nolock) on ce.ClientId = c.ClientId and  
                                   ce.EpisodeNumber = c.CurrentEpisodeNumber  
   where ReferralComment is not null  
  
end  
  
  
--av Add The sections of data for page 3 (Clinician Asked Questions Here)  
insert into @Results (  
 ReportingSection,  
 ClientId,  
 CorrectionsInPrison,  
 CorrectionsInJail,  
 CorrectionsParole,  
 CorrectionsProbation,  
 CorrectionsJuvenileDet,  
 CorrectionsCourtSupervision,  
 CorrectionsNoJurisdiction,  
 CorrectionsAwaitTrial,  
 CorrectionsAwaitSentance,  
 CorrectionsRefused,  
 CorrectionsMinorReferred,  
 CorrectionsArrested,  
 CorrectionsDiverted,  
 StateAdoptionStudyYes,  
 StateAdoptionStudyNo,  
 StateSSIYes,  
 StateSSINo,  
 StateParentofYoungChildYes,  
 StateParentofYoungChildNo,  
 StateChildFIAAbuseYes,  
 StateChildFIAAbuseNo,  
 StateChildFIAOtherYes,  
 StateChildFIAOtherNo,  
 StateEarlyOnProgramYes,  
 StateEarlyOnProgramNo,  
 StateWrapAroundYes,  
 StateWrapAroundNo,  
 StateEPSDTYes,  
 StateEPSDTNo,   
 PageNumber  
 )  
select 11,  
 i.ClientId,  
 case when gcCS.ExternalCode1 = '1' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '2' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '3' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '4' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '5' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '6' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '7' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '8' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '9' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '10' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '11' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '12' then 'X' else null end,  
 case when gcCS.ExternalCode1 = '13' then 'X' else null end,  
--clinician completed customer info  
 case when isnull(csr.AdoptionStudy,'N') = 'Y' then 'X' else null end,  
 case when csr.AdoptionStudy = 'N' then 'X' else null end,  
 case when isnull(csr.SSI,'N') = 'Y' then 'X' else null end,  
 case when csr.SSI = 'N' then 'X' else null end,  
 case when isnull(csr.ParentofYoungChild,'N') = 'Y' then 'X' else null end,  
 case when csr.ParentofYoungChild = 'N' then 'X' else null end,  
 case when isnull(csr.ChildFIAAbuse,'N') = 'Y' then 'X' else null end,  
 case when csr.ChildFIAAbuse = 'N' then 'X' else null end,  
 case when isnull(csr.ChildFIAOther,'N') = 'Y' then 'X' else null end,  
 case when csr.ChildFIAOther = 'N' then 'X' else null end,  
 case when isnull(csr.EarlyOnProgram,'N') = 'Y' then 'X' else null end,  
 case when csr.EarlyOnProgram = 'N' then 'X' else null end,  
 case when isnull(csr.WrapAround,'N') = 'Y' then 'X' else null end,  
 case when csr.WrapAround = 'N' then 'X' else null end,  
 case when isnull(csr.EPSDT,'N') = 'Y' then 'X' else null end,  
 case when csr.EPSDT = 'N' then 'X' else null end,  
 3  
from @InfoSheetClients i  
left join Clients c with(nolock) on c.ClientId = i.ClientId  
left join GlobalCodes gcCS with(nolock) on gcCS.GlobalCodeId = c.CorrectionStatus   
left join CustomStateReporting as csr with(nolock) on csr.ClientId = c.ClientId and isnull(csr.RecordDeleted,'N')<>'Y'  
-- end av   
  
if not exists (select 1 from @Results where ReportingSection = 9)  
 begin  
  insert into @Results  
  (reportingsection)  
  values  
  (9)  
 end  
  
           
select r.*   
  from @Results r  
       left join Clients c on c.ClientId = r.ClientId  
 order by case r.ClientId when -1 then 1 when -2 then 3 else 2 end,  
          c.LastName, c.FirstName, r.ClientId, r.ReportingSection, r.InsuranceCOBOrder  
  