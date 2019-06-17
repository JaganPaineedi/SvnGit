if object_id('dbo.ssp_CMValidateClaimLineDiagnosisCodes') is not null 
  drop procedure dbo.ssp_CMValidateClaimLineDiagnosisCodes
go

create procedure dbo.ssp_CMValidateClaimLineDiagnosisCodes
  @InsurerId int,
  @FromDate date,
  @ClaimType int,
  @DiagnosisPrincipal varchar(20),
  @DiagnosisAdmission varchar(20),
  @Diagnosis1 varchar(20),
  @Diagnosis2 varchar(20),
  @Diagnosis3 varchar(20),
  @IsDiagnosis1 char(1),
  @IsDiagnosis2 char(1),
  @IsDiagnosis3 char(1)
/*********************************************************************            
-- Stored Procedure: dbo.ssp_CMValidateClaimLineDiagnosisCodes
-- 
-- Copyright: Streamline Healthcare Solutions
--                                                   
-- Purpose: validates claim line diagnosis codes
--                                                      
-- Modified Date    Modified By     Purpose  
-- 06.23.2015       SFarber         Created.  
-- 12.09.2016       SFarber         Added logic to validate against ICD10FiscalYearAvailability.
****************************************************************************/
as 
create table #DiagnosisCodes (
DiagnosisCodeId int identity
                    not null,
DiagnosisCode varchar(20),
IsValid char(1) default 'N',
LevelOfImportance char(1))

declare @ICD10StartDate date
declare @ValidationType varchar(10)
declare @CMSFiscalYear integer 
declare @EnforceICD10FiscalYearValidation char(1)

-- Get ICD10 start date 
select  @ICD10StartDate = isnull(i.ICD10StartDate, dateadd(day, 1, @FromDate))
from    Insurers i
where   i.InsurerId = @InsurerId

if @ClaimType = 2222 -- Institutional claim
  begin
    insert  into #DiagnosisCodes
            (DiagnosisCode,
             LevelOfImportance)
            select  @DiagnosisPrincipal,
                    'P'
            where   isnull(@DiagnosisPrincipal, '') <> ''
            union all
            select  @DiagnosisAdmission,
                    'A'
            where   isnull(@DiagnosisAdmission, '') <> ''
            union all
            select  @Diagnosis1,
                    '1'
            where   isnull(@Diagnosis1, '') <> ''
            union all
            select  @Diagnosis2,
                    '2'
            where   isnull(@Diagnosis2, '') <> ''
            union all
            select  @Diagnosis3,
                    '3'
            where   isnull(@Diagnosis3, '') <> ''
  end
else 
  if @ClaimType = 2221-- Professional claim
    begin
      insert  into #DiagnosisCodes
              (DiagnosisCode,
               LevelOfImportance)
              select  @Diagnosis1,
                      '1'
              where   isnull(@Diagnosis1, '') <> ''
                      and @IsDiagnosis1 = 'Y'
              union all
              select  @Diagnosis2,
                      '2'
              where   isnull(@Diagnosis2, '') <> ''
                      and @IsDiagnosis2 = 'Y'
              union all
              select  @Diagnosis3,
                      '3'
              where   isnull(@Diagnosis3, '') <> ''
                      and @IsDiagnosis3 = 'Y'
    end

if @FromDate >= @ICD10StartDate 
  begin
    set @ValidationType = 'ICD-10'

    select  @CMSFiscalYear = year(dateadd(dd, 92, @FromDate))

    select  @EnforceICD10FiscalYearValidation = sck.Value
    from    SystemConfigurationKeys sck
    where   sck.[Key] = 'EnforceICD10FiscalYearValidation'
            and sck.Value in ('Y', 'N')
            and isnull(sck.RecordDeleted, 'N') = 'N'

    set @EnforceICD10FiscalYearValidation = isnull(@EnforceICD10FiscalYearValidation, 'N')

    if @EnforceICD10FiscalYearValidation = 'Y' 
      begin
        update  dc
        set     IsValid = 'Y'
        from    #DiagnosisCodes dc
        where   exists ( select *
                         from   ICD10FiscalYearAvailability ifya
                         where  ifya.ICD10Code = dc.DiagnosisCode
                                and ifya.CMSFiscalYear = @CMSFiscalYear
                                and isnull(ifya.RecordDeleted, 'N') = 'N' )

      end
    else 
      begin
        update  dc
        set     IsValid = 'Y'
        from    #DiagnosisCodes dc
        where   exists ( select *
                         from   DiagnosisICD10Codes icd10
                         where  icd10.ICD10Code = dc.DiagnosisCode )

      end
  end
else 
  begin
    set @ValidationType = 'ICD-9'

    update  dc
    set     IsValid = 'Y'
    from    #DiagnosisCodes dc
    where   exists ( select *
                     from   DiagnosisDSMDescriptions dsm
                     where  dsm.DSMCode = dc.DiagnosisCode )
  
    -- 799.9 (Diagnosis Deferred) is not valid for Principal or Admission diagnosis code
    update  dc
    set     IsValid = 'N'
    from    #DiagnosisCodes dc
    where   dc.IsValid = 'Y'
            and dc.LevelOfImportance in ('P', 'A')
            and dc.DiagnosisCode = '799.9'

    -- 799.9 is not valid if it is the first diagnosis code specified for a claim line
    update  dc
    set     IsValid = 'N'
    from    #DiagnosisCodes dc
    where   dc.IsValid = 'Y'
            and dc.DiagnosisCodeId = 1
            and dc.DiagnosisCode = '799.9'

  end
 
select  DiagnosisCode,
        IsValid,
        LevelOfImportance,
        @ValidationType as ValidationType
from    #DiagnosisCodes 

return

go
