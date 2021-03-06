/****** Object:  StoredProcedure [dbo].[csp_conv_GlobalCodes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_GlobalCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_GlobalCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_GlobalCodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_conv_GlobalCodes]
as


--
-- Global codes
--

if not exists(select * from GlobalCodeCategories where Category = ''PAYERTYPE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''PAYERTYPE'', ''Payer Type'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''LIVINGARRANGEMENT'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''LIVINGARRANGEMENT'', ''Living Arrangement'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''MARITALSTATUS'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''MARITALSTATUS'', ''Marital Status'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''MILITARYSTATUS'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''MILITARYSTATUS'', ''Military Status'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''EDUCATIONALSTATUS'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''EDUCATIONALSTATUS'', ''Educational Status'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''LANGUAGE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''LANGUAGE'', ''Language'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''EMPLOYMENTSTATUS'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''EMPLOYMENTSTATUS'', ''Employment Status'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''RACE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''RACE'', ''Race'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''DEGREE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''DEGREE'', ''Degree'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''STAFFTAXONOMY'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''STAFFTAXONOMY'', ''Staff Taxonomy'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''REFERRALTYPE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''REFERRALTYPE'', ''Referral Type'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''REFERRALSOURCE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''REFERRALSOURCE'', ''Referral Source'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''ALIASTYPE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''ALIASTYPE'', ''Alias Type'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''RELATIONSHIP'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''RELATIONSHIP'', ''Relationship'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''CANCELREASON'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''CANCELREASON'', ''Cancel Reason'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''APPOINTMENTTYPE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''APPOINTMENTTYPE'', ''Appointment Type'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''PAYMENTMETHOD'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''PAYMENTMETHOD'', ''Payment Method'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''PAYMENTSOURCE'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''PAYMENTSOURCE'', ''Payment Source'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
--if not exists(select * from GlobalCodeCategories where Category = ''XDISPOSITIONREASONS'')
--begin
--  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
--                            values (''XDISPOSITIONREASONS'', ''Disposition Reasons'', ''Y'', ''Y'', ''Y'', ''Y'')
--
--  if @@error <> 0 goto error
--end
if not exists(select * from GlobalCodeCategories where Category = ''CORRECTIONSTATUS'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''CORRECTIONSTATUS'', ''Correction Status'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''ASSESSMENTDECLINED'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''ASSESSMENTDECLINED'', ''Assessment Declined Reason'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''TREATMENTDECLINED'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''TREATMENTDECLINED'', ''Treatment Declined  Reason'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end

--Custom Signing Suffix 
if not exists(select * from GlobalCodeCategories where Category = ''XSIGNINGSUFFIX'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''XSIGNINGSUFFIX'', ''Degree Signing Suffix Map'', ''Y'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end

-- Rx categories for Medication Management Note
if not exists(select * from GlobalCodeCategories where Category = ''XRXUNIT'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''XRXUNIT'', ''Rx Unit'', ''N'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''XRXADMINMETHOD'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''XRXADMINMETHOD'', ''Rx Admin Method'', ''N'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''XRXDRUGFORM'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''XRXDRUGFORM'', ''Rx Dosage Form'', ''N'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end
if not exists(select * from GlobalCodeCategories where Category = ''XRXFREQUENCY'')
begin
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
                            values (''XRXFREQUENCY'', ''Rx Frequency'', ''N'', ''Y'', ''Y'', ''Y'')

  if @@error <> 0 goto error
end


--if not exists(select * from GlobalCodeCategories where Category = ''XDDCOMMSTYLE'')
--begin
--  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
--                            values (''XDDCOMMSTYLE'', ''DD Assessment Communication Style'', ''Y'', ''Y'', ''Y'', ''Y'')
--
--  if @@error <> 0 goto error
--end
--if not exists(select * from GlobalCodeCategories where Category = ''XDDSUPPORTNATURE'')
--begin
--  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
--                            values (''XDDSUPPORTNATURE'', ''DD Assessment Natural Support'', ''Y'', ''Y'', ''Y'', ''Y'')
--
--  if @@error <> 0 goto error
---end
--if not exists(select * from GlobalCodeCategories where Category = ''XDDSUPPORTSTATUS'')
--begin
--  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
--                            values (''XDDSUPPORTSTATUS'', ''DD Assessment Status Support'', ''Y'', ''Y'', ''Y'', ''Y'')
--
--  if @@error <> 0 goto error
--end
--if not exists(select * from GlobalCodeCategories where Category = ''XDDLEVELNEEDED'')
--begin
--  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
--                            values (''XDDLEVELNEEDED'', ''DD Assessment Problem Level'', ''Y'', ''Y'', ''Y'', ''Y'')
--
--  if @@error <> 0 goto error
--end
--if not exists(select * from GlobalCodeCategories where Category = ''XBASIS32INTEVAL'')
--begin
--  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit)
--                            values (''XBASIS32INTEVAL'', ''Basis32 Interval'', ''Y'', ''Y'', ''Y'', ''Y'')
--
--  if @@error <> 0 goto error
--end

/*
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name) 
select distinct
       -1, 
       case cl.category
            when ''disposition'' then ''XDISPOSITIONREASONS''
            when ''correction'' then ''CORRECTIONSTATUS''
            when ''outlier'' then ''ASSESSMENTDECLINED''
            when ''dd_comm'' then ''XDDCOMMSTYLE''
            when ''dd_support'' then ''XDDSUPPORTNATURE''      
            when ''dd_supp_status'' then ''XDDSUPPORTSTATUS''
            when ''dd_prob_sev'' then ''XDDLEVELNEEDED''
            when ''interval'' then ''XBASIS32INTEVAL''
       end,
       data_value,
       display_value
  from Psych..cstm_list cl
 where category in (''disposition'', ''correction'', ''outlier'', ''dd_comm'', ''dd_support'', ''dd_supp_status'', ''dd_prob_sev'', ''interval'')
   and not exists(select *
                   from Cstm_Conv_Map_GlobalCodes gc
                  where gc.Category = case cl.category
                                           when ''disposition'' then ''XDISPOSITIONREASONS''
                                           when ''correction'' then ''CORRECTIONSTATUS''
                                           when ''outlier'' then ''ASSESSMENTDECLINED''
                                           when ''dd_comm'' then ''XDDCOMMSTYLE''
                                           when ''dd_support'' then ''XDDSUPPORTNATURE''      
                                           when ''dd_supp_status'' then ''XDDSUPPORTSTATUS''
                                           when ''dd_prob_sev'' then ''XDDLEVELNEEDED''
                                           when ''interval'' then ''XBASIS32INTEVAL''
                                      end
                    and gc.code = cl.data_value)
union
select distinct
       -1, 
       case cl.category
            when ''outlier'' then ''TREATMENTDECLINED''
       end,
       data_value,
       display_value
  from Psych..cstm_list cl
 where category in (''outlier'')
   and not exists(select *
                   from Cstm_Conv_Map_GlobalCodes gc
                  where gc.Category = case cl.category
                                           when ''outlier'' then ''TREATMENTDECLINED''
                                      end
                    and gc.code = cl.data_value)


insert into GlobalCodes (Category, CodeName, Active, CannotModifyNameorDelete, SortOrder, ExternalCode1)
select case cl.category
            when ''disposition'' then ''XDISPOSITIONREASONS''
            when ''correction'' then ''CORRECTIONSTATUS''
            when ''outlier'' then ''ASSESSMENTDECLINED''
            when ''dd_comm'' then ''XDDCOMMSTYLE''
            when ''dd_support'' then ''XDDSUPPORTNATURE''      
            when ''dd_supp_status'' then ''XDDSUPPORTSTATUS''
            when ''dd_prob_sev'' then ''XDDLEVELNEEDED''
            when ''interval'' then ''XBASIS32INTEVAL''
       end,
       display_value,
       ''Y'',
       ''N'',
       null,
       data_value
  from Psych..cstm_list cl
 where category in (''disposition'', ''correction'', ''outlier'', ''dd_comm'', ''dd_support'', ''dd_supp_status'', ''dd_prob_sev'', ''interval'')
   and not exists(select *
                   from GlobalCodes gc
                  where gc.Category = case cl.category
                                           when ''disposition'' then ''XDISPOSITIONREASONS''
                                           when ''correction'' then ''CORRECTIONSTATUS''
                                           when ''outlier'' then ''ASSESSMENTDECLINED''
                                           when ''dd_comm'' then ''XDDCOMMSTYLE''
                                           when ''dd_support'' then ''XDDSUPPORTNATURE''      
                                           when ''dd_supp_status'' then ''XDDSUPPORTSTATUS''
                                           when ''dd_prob_sev'' then ''XDDLEVELNEEDED''
                                           when ''interval'' then ''XBASIS32INTEVAL''
                                      end
                    and gc.CodeName = cl.display_value)
union
select case cl.category
            when ''outlier'' then ''TREATMENTDECLINED''
       end,
       display_value,
       ''Y'',
       ''N'',
       null,
       data_value
  from Psych..cstm_list cl
 where category in (''outlier'')
   and not exists(select *
                   from GlobalCodes gc
                  where gc.Category = case cl.category
                                           when ''outlier'' then ''TREATMENTDECLINED''
                                      end
                    and gc.CodeName = cl.display_value)
 order by 6, 2

*/

insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name)
select -1,
       case gc.category
            when ''PY'' then ''PAYERTYPE''
            when ''LA'' then ''LIVINGARRANGEMENT''
            when ''MS'' then ''MARITALSTATUS''
            when ''MI'' then ''MILITARYSTATUS''
            when ''ED'' then ''EDUCATIONALSTATUS''
            when ''LG'' then ''LANGUAGE''
            when ''OS'' then ''EMPLOYMENTSTATUS''
            when ''R''  then ''RACE''
            when ''DG'' then ''XSIGNINGSUFFIX'' 
            --when ''DG'' then ''DEGREE''
            when ''TAXONOMY'' then ''STAFFTAXONOMY''
            when ''RT'' then ''REFERRALTYPE''
            when ''RS'' then ''REFERRALSOURCE''
            when ''PA'' then ''ALIASTYPE''
            when ''RE'' then ''RELATIONSHIP''
            when ''CLINTRNCAN'' then ''CANCELREASON''
            when ''SC'' then ''APPOINTMENTTYPE''
       end,
       gc.code,
       ltrim(rtrim(gc.name))
  from Psych..Global_Code gc 
 where gc.category in (''PY'', ''LA'', ''MS'', ''MI'', ''ED'', ''LG'', ''OS'', ''R'', ''DG'', ''TAXONOMY'', ''RT'', ''RS'', ''PA'', ''RE'',  ''CLINTRNCAN'', ''SC'')
   and not exists(select *
                    from Cstm_Conv_Map_GlobalCodes gcm 
                   where gcm.Category = case gc.category
                                             when ''PY'' then ''PAYERTYPE''
                                             when ''LA'' then ''LIVINGARRANGEMENT''
                                             when ''MS'' then ''MARITALSTATUS''
                                             when ''MI'' then ''MILITARYSTATUS''
                                             when ''ED'' then ''EDUCATIONALSTATUS''
                                             when ''LG'' then ''LANGUAGE''
                                             when ''OS'' then ''EMPLOYMENTSTATUS''
                                             when ''R''  then ''RACE''
                                             when ''DG'' then ''XSIGNINGSUFFIX'' 
                                             --when ''DG'' then ''DEGREE''
                                             when ''TAXONOMY'' then ''STAFFTAXONOMY''
                                             when ''RT'' then ''REFERRALTYPE''
                                             when ''RS'' then ''REFERRALSOURCE''
                                             when ''PA'' then ''ALIASTYPE''
                                             when ''RE'' then ''RELATIONSHIP''
                                             when ''CLINTRNCAN'' then ''CANCELREASON''
                                             when ''SC'' then ''APPOINTMENTTYPE''
                                         end
                     and gcm.code = gc.code)

if @@error <> 0 goto error


insert into GlobalCodes (Category, CodeName, Active, CannotModifyNameorDelete, SortOrder, ExternalCode1, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
select case gc.category
            when ''PY'' then ''PAYERTYPE''
            when ''LA'' then ''LIVINGARRANGEMENT''
            when ''MS'' then ''MARITALSTATUS''
            when ''MI'' then ''MILITARYSTATUS''
            when ''ED'' then ''EDUCATIONALSTATUS''
            when ''LG'' then ''LANGUAGE''
            when ''OS'' then ''EMPLOYMENTSTATUS''
            when ''R''  then ''RACE''
            when ''DG'' then ''XSIGNINGSUFFIX'' 
            --when ''DG'' then ''DEGREE''
            when ''TAXONOMY'' then ''STAFFTAXONOMY''
            when ''RT'' then ''REFERRALTYPE''
            when ''RS'' then ''REFERRALSOURCE''
            when ''PA'' then ''ALIASTYPE''
            when ''RE'' then ''RELATIONSHIP''
            when ''CLINTRNCAN'' then ''CANCELREASON''
            when ''SC'' then ''APPOINTMENTTYPE''
       end,
       ltrim(rtrim(gc.name)) as CodeName,
       ''Y'',
       case when IsNull(gc.sensitivity_index, 0) > 5 then ''Y'' else ''N'' end,
       case when IsNull(gc.order_num, 0) < 1 then 1 else gc.order_num end as SortOrder,
       gc.code,
       isnull(gc.user_id,''System''),
       isnull(gc.entry_chron,''01/01/1900''),
       isnull(gc.user_id,''System''),
       isnull(gc.entry_chron,''01/01/1900'')
  from Psych..Global_Code gc
 where gc.category in (''PY'', ''LA'', ''MS'', ''MI'', ''ED'', ''LG'', ''OS'', ''R'', ''DG'', ''TAXONOMY'', ''RT'', ''RS'', ''PA'', ''RE'', ''CLINTRNCAN'', ''SC'')
   and not exists(select *
                    from GlobalCodes gcm 
                   where gcm.Category = case gc.category 
                                             when ''PY'' then ''PAYERTYPE''
                                             when ''LA'' then ''LIVINGARRANGEMENT''
                                             when ''MS'' then ''MARITALSTATUS''
                                             when ''MI'' then ''MILITARYSTATUS''
                                             when ''ED'' then ''EDUCATIONALSTATUS''
                                             when ''LG'' then ''LANGUAGE''
                                             when ''OS'' then ''EMPLOYMENTSTATUS''
                                             when ''R''  then ''RACE''
                                             when ''DG'' then ''XSIGNINGSUFFIX'' 
                                             --when ''DG'' then ''DEGREE''
                                             when ''TAXONOMY'' then ''STAFFTAXONOMY''
                                             when ''RT'' then ''REFERRALTYPE''
                                             when ''RS'' then ''REFERRALSOURCE''
                                             when ''PA'' then ''ALIASTYPE''
                                             when ''RE'' then ''RELATIONSHIP''
                                             when ''CLINTRNCAN'' then ''CANCELREASON''
                                             when ''SC'' then ''APPOINTMENTTYPE''
                                        end

                     and gcm.CodeName = ltrim(rtrim(gc.name)))
order by SortOrder, CodeName

if @@error <> 0 goto error


--Harbor Uses staff_custom for degree codes --
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name)
select -1
	  ,''DEGREE''
	  ,cd.field_value
	  ,cd.field_description
  from Psych.dbo.Custom_Dropdowns cd
 where dropdown_code like ''%degree%''
   and not exists(select *
                    from Cstm_Conv_Map_GlobalCodes gc
	               where gc.Category = ''DEGREE''
	                 and gc.code = cd.field_value)

if @@error <> 0 goto error

insert into GlobalCodes (Category, CodeName, Active, CannotModifyNameorDelete, SortOrder, ExternalCode1, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
select ''DEGREE''
      ,cd.field_description 
      ,''Y''
      ,''N''
      ,ROW_NUMBER() OVER(ORDER BY cd.field_description asc) as SortOrder
      ,cd.field_value
      ,cd.user_id
      ,cd.entry_chron
      ,cd.user_id
      ,cd.entry_chron
  from Psych.dbo.Custom_Dropdowns cd
  where dropdown_code like ''%degree%''
    and not exists(select *
                    from GlobalCodes gcm 
                   where gcm.Category = ''DEGREE''
                     and gcm.CodeName = cd.field_description)
 order by SortOrder                     

if @@error <> 0 goto error
--end Degree


--Add Referring Clinician
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name)
select -1,
	''REFERRINGCLINICIAN'',
	UPPER(SUBSTRING(IsNull(u.lname,s.lname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.lname,s.lname), 2, 100)) + '', '' +UPPER(SUBSTRING(IsNull(u.fname,s.fname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.fname,s.fname), 2, 100)),
	UPPER(SUBSTRING(IsNull(u.lname,s.lname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.lname,s.lname), 2, 100)) + '', '' +UPPER(SUBSTRING(IsNull(u.fname,s.fname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.fname,s.fname), 2, 100))
 from Psych..Staff s 
      left join Psych..user_profile u on u.user_code = s.staff_id 
where s.type like ''REFERRING%''
  and not exists(select *
                    from Cstm_Conv_Map_GlobalCodes gc
	               where gc.Category = ''REFERRINGCLINICIAN''
	                 and gc.code = UPPER(SUBSTRING(IsNull(u.lname,s.lname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.lname,s.lname), 2, 100)) + '', '' +UPPER(SUBSTRING(IsNull(u.fname,s.fname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.fname,s.fname), 2, 100)))


insert into GlobalCodes (Category, CodeName, Active, CannotModifyNameorDelete, SortOrder, ExternalCode1, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
select 
	''REFERRINGCLINICIAN'',
	UPPER(SUBSTRING(IsNull(u.lname,s.lname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.lname,s.lname), 2, 100)) 
		+ '', '' + UPPER(SUBSTRING(IsNull(u.fname,s.fname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.fname,s.fname), 2, 100)),
	''Y'',
	''N'',
	ROW_NUMBER() OVER(ORDER BY IsNull(u.lname,s.lname), isnull(u.fname,s.fname) asc) as SortOrder,
	isnull(s.staff_id,''00000000''),
	isnull(IsNull(s.orig_user_id, u.orig_user_id), ''psych_conv''),
    isnull(IsNull(s.orig_entry_chron, u.orig_entry_chron), GetDate()),
    isnull(IsNull(s.user_id, u.user_id), ''psych_conv''), 
    isnull(IsNull(s.entry_chron, u.entry_chron), GetDate())
from Psych..Staff s
left join Psych..user_profile u on u.user_code = s.user_code 
where s.type like ''REFERRING%''
   and not exists(select *
                    from GlobalCodes gcm 
                   where gcm.Category = ''REFERRINGCLINICIAN''
                     and gcm.ExternalCode1 = isnull(s.staff_id,''00000000''))

order by SortOrder

--Done Referrring

--
-- Procedure Durations
--
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name)
select distinct
-1, ''UNITTYPE'',duration_type,
	case duration_type 	when ''MI'' then ''Minutes''
				when ''HO'' then ''Hours''
				when ''IT'' then ''Items''
				when ''DA'' then ''Days''
	else duration_type
	end
	from Psych..Procedure_code pc
where duration_type is not null
and not exists(select *
		from Cstm_Conv_Map_GlobalCodes gc
		where gc.Category = ''UNITTYPE''
			and gc.code = pc.duration_type)

if @@error <> 0 goto error

--
-- Payment
--

insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name) 
select distinct
       -1, ''PAYMENTMETHOD'', instrument, 
      case instrument when ''MO'' then ''Money Order''
                      when ''CH'' then ''Check''
                      when ''CA'' then ''Cash''
                      else instrument
      end
 from Psych..Payment p
where instrument is not null
  and not exists(select *
                   from Cstm_Conv_Map_GlobalCodes gc
                  where gc.Category = ''PAYMENTMETHOD'' 
                    and gc.code = p.instrument)

if @@error <> 0 goto error

insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name) 
select distinct
       -1, ''PAYMENTSOURCE'', source_type, 
      case source_type when ''SY'' then ''System''
                      when ''TV'' then ''Transfer Voucher''
                      when ''DR'' then ''Deposit Report''
                      when ''CR'' then ''Cash Receipt''
                      else source_type
      end
 from Psych..Payment p
where source_type is not null
  and not exists(select *
                   from Cstm_Conv_Map_GlobalCodes gc
                  where gc.Category = ''PAYMENTSOURCE''
                    and gc.code = p.source_type)

if @@error <> 0 goto error

insert into GlobalCodes (Category, CodeName, Active, CannotModifyNameorDelete, SortOrder, ExternalCode1)
select gc.Category,
       gc.Name,
       ''Y'',
       ''N'',
       null,
       gc.code
  from Cstm_Conv_Map_GlobalCodes gc
 where gc.category in (''PAYMENTMETHOD'', ''PAYMENTSOURCE'')
   and not exists(select *
                    from GlobalCodes gcm 
                   where gcm.Category = gc.category
                     and gcm.CodeName = ltrim(rtrim(gc.name)))
order by gc.Category, gc.name

if @@error <> 0 goto error

--
-- Rx codes for Medication Management Note
-- 
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name) 
select distinct
       -1, 
       ''XRXUNIT'',
       rx.unit_code,
       rx.unit_name
  from Psych..Rx_Unit rx
 where not exists(select *
	                from Cstm_Conv_Map_GlobalCodes gc
		           where gc.Category = ''XRXUNIT''
			         and gc.code = rx.unit_code)
			
-----
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name) 
select distinct
       -1, 
       ''XRXADMINMETHOD'',
       rx.method_code,
       rx.method_desc
  from Psych..Rx_Admin_Method rx
 where not exists(select *
	                from Cstm_Conv_Map_GlobalCodes gc
		           where gc.Category = ''XRXADMINMETHOD''
			         and gc.code = rx.method_code)
------
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name) 
select distinct
       -1, 
       ''XRXDRUGFORM'',
       rx.form_code,
       rx.form_desc
  from Psych..Rx_Dosage_Form rx
 where not exists(select *
	                from Cstm_Conv_Map_GlobalCodes gc
		           where gc.Category = ''XRXDRUGFORM''
			         and gc.code = rx.form_code)

-------
insert into Cstm_Conv_Map_GlobalCodes (GlobalCodeId, Category, code, name) 
select distinct
       -1, 
       ''XRXFREQUENCY'',
       rx.freq_code,
       rx.freq_desc
  from Psych..Rx_Freq rx
 where not exists(select *
	                from Cstm_Conv_Map_GlobalCodes gc
		           where gc.Category = ''XRXFREQUENCY''
			         and gc.code = rx.freq_code)
			
insert into GlobalCodes (Category, CodeName, Active, CannotModifyNameorDelete, SortOrder, ExternalCode1)
select gc.Category,
       gc.Name,
       ''Y'',
       ''N'',
       null,
       gc.code
  from Cstm_Conv_Map_GlobalCodes gc
 where gc.category in (''XRXUNIT'', ''XRXADMINMETHOD'', ''XRXDRUGFORM'', ''XRXFREQUENCY'')
   and not exists(select *
                    from GlobalCodes gcm 
                   where gcm.Category = gc.category
                     and gcm.CodeName = ltrim(rtrim(gc.name)))
 order by gc.Category, gc.Name
 

--
-- Update mapping table with the global code IDs
--
update m
   set GlobalCodeId = gc.GlobalCodeid
  from Cstm_Conv_Map_GlobalCodes m
       join GlobalCodes gc on gc.Category = m.Category and
                              gc.CodeName = m.name
	--Don''t overwrite service change
	where m.globalCodeId not in (4761)	

if @@error <> 0 goto error




return

error:

raiserror 50001 ''csp_conv_GlobalCodes failed''

return


' 
END
GO
