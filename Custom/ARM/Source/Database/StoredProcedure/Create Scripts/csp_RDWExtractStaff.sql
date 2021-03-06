/****** Object:  StoredProcedure [dbo].[csp_RDWExtractStaff]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractStaff]
@AffiliateId int
as

set nocount on
set ansi_warnings off

delete from CustomRDWExtractStaff

if @@error <> 0 goto error

insert into CustomRDWExtractStaff (
       AffiliateId,
       StaffId,
       LastName,
       FirstName,
       MiddleName,
       SSN,
       Status,
       DOB,
       Sex,
       EmploymentStart,
       EmploymentEnd,
       Title,
       OfficePhone,
       Email,
       OfficeAddress1,
       OfficeAddress2,
       OfficeCity,
       OfficeState,
       OfficeZip,
       Degree,
       LicenseNumber,
       PagerNumber,
       TaxonomyCode,
       Comment)
select @AffiliateId,
       s.StaffId,
       s.LastName,
       s.FirstName,
       s.MiddleName,
       s.SSN,
       case s.Active when ''Y'' then ''Active'' else ''Inactive'' end,
       s.DOB,
       case s.Sex when ''M'' then ''Male'' when ''F'' then ''Female'' else s.Sex end,
       s.EmploymentStart,
       s.EmploymentEnd,
       s.SigningSuffix,
       replace(replace(replace(replace(s.OfficePhone1, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', ''''),
       s.Email,
       case when charindex(char(13) + char(10), s.Address) > 0 
            then left(s.Address, charindex(char(13) + char(10), s.Address) - 1)
            else s.Address
       end, 
       case when charindex(char(13) + char(10), s.Address) > 0 
            then substring(s.Address, charindex(char(13) + char(10), s.Address) + 2, len(s.Address) - charindex(char(13) + char(10), s.Address) + 2)
            else null
       end,
       City,
       State,
       Zip,
       gcd.CodeName,
       s.LicenseNumber,
       replace(replace(replace(replace(s.PagerNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', ''''),
       gct.ExternalCode1,
       case when len(convert(varchar, s.Comment)) = 0 then null else s.Comment end
  from Staff s
       left join GlobalCodes gcd on gcd.GlobalCodeId = s.Degree
       left join GlobalCodes gct on gct.GlobalCodeId = s.TaxonomyCode
 where isnull(s.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

-- Race
update s
   set Race = gc.CodeName
  from CustomRDWExtractStaff s
       join StaffRaces sr on sr.StaffId = s.StaffId
       join GlobalCodes gc on gc.GlobalCodeId = sr.RaceId
 where isnull(sr.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from StaffRaces sr2
                   where sr2.StaffId = s.StaffId
                     and isnull(sr2.RecordDeleted, ''N'') = ''N''
                     and sr2.StaffRaceId < sr.StaffRaceId)

if @@error <> 0 goto error

-- Primary Language
update s
   set PrimaryLanguage = gc.CodeName
  from CustomRDWExtractStaff s
       join StaffLanguages sl on sl.StaffId = s.StaffId
       join GlobalCodes gc on gc.GlobalCodeId = sl.LanguageId
 where isnull(sl.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from StaffLanguages sl2
                   where sl2.StaffId = s.StaffId
                     and isnull(sl2.RecordDeleted, ''N'') = ''N''
                     and sl2.StaffLanguageId < sl.StaffLanguageId)

if @@error <> 0 goto error

-- Secondary Language
update s
   set SecondaryLanguage = gc.CodeName
  from CustomRDWExtractStaff s
       join StaffLanguages sl on sl.StaffId = s.StaffId
       join GlobalCodes gc on gc.GlobalCodeId = sl.LanguageId
 where isnull(sl.RecordDeleted, ''N'') = ''N''
   and s.PrimaryLanguage <> gc.CodeName
   and not exists(select *
                    from StaffLanguages sl2
                         join GlobalCodes gc2 on gc2.GlobalCodeId = sl2.LanguageId
                   where sl2.StaffId = s.StaffId
                     and isnull(sl2.RecordDeleted, ''N'') = ''N''
                     and gc2.CodeName <> s.PrimaryLanguage
                     and sl2.StaffLanguageId < sl.StaffLanguageId)

if @@error <> 0 goto error

-- Location
update s
   set Location = l.LocationName
  from CustomRDWExtractStaff s
       join StaffLocations sl on sl.StaffId = s.StaffId
       join Locations l on l.LocationId = sl.LocationId
 where isnull(sl.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from StaffLocations sl2
                   where sl2.StaffId = s.StaffId
                     and isnull(sl2.RecordDeleted, ''N'') = ''N''
                     and sl2.StaffLocationsId < sl.StaffLocationsId)

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractStaff''
' 
END
GO
