if object_id('csp_ReportMedConsentsMMPatientEducationMonographSideEffects', 'P') is not null	
	drop proc csp_ReportMedConsentsMMPatientEducationMonographSideEffects
go

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[csp_ReportMedConsentsMMPatientEducationMonographSideEffects]
/*********************************************************************/
/* Procedure: scsp_MMPatientEducationMonographSideEffects            */
/*                                                                   */
/* Purpose: retrieve a formatted block of text describing the side-  */
/*    effects associated with a medication.                          */
/*                                                                   */
/* Parameters: @PatientEducationMonographId (int) - Monograph        */
/*    identifier which is associated with the medication.            */
/*                                                                   */
/* Returns/Results: returns a result set containing the              */
/*    PatientEducationMonographId and the FormattedSideEffectsText   */
/*                                                                   */
/* Created By: Tom Remisoski                                         */
/*                                                                   */
/* Created Date: 4/21/2009                                           */
/*                                                                   */
/* Revision History:                                                 */
/*********************************************************************/

   @PatientEducationMonographId int
as
set nocount on

declare @textSideEffects varchar(max)

set @textSideEffects = ''

declare @tabTerminators table
(
   TerminatorExpression varchar(500)
)


-- These expressions indicate the end of the "common side-effects" section of the monograph
insert into @tabTerminators (TerminatorExpression)
values ('   Remember that your doctor has prescribed%')

insert into @tabTerminators (TerminatorExpression)
values ('   Remember that your doctor or dentist has prescribed%')

insert into @tabTerminators (TerminatorExpression)
values ('   If your doctor has directed you to use this medication,%')

insert into @tabTerminators (TerminatorExpression)
values ('   If your doctor has prescribed this medication, remember%')

insert into @tabTerminators (TerminatorExpression)
values ('   This is not a complete list of possible side effects. If you%')

insert into @tabTerminators (TerminatorExpression)
values ('   Contact your doctor for medical advice about side effects. The%')

insert into @tabTerminators (TerminatorExpression)
values ('   If you notice side effects, contact your doctor or pharmacist.%')

insert into @tabTerminators (TerminatorExpression)
values ('   If you notice other effects not listed above, contact your%')

--select * from @tabTerminators

declare @tabReplacements table
(
   replaceWhat varchar(500),
   replaceWith varchar(500)
)

-- If any of these strings exist in the resulting text, replace them with the "replaceWith" value
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, tell your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these effects persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, contact your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these effects persist or become worse inform your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, tell your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If this effect persists or worsens, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these persist or worsen, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects continue or become bothersome, inform your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If they persist or become bothersome, inform your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, tell your doctor, pharmacist, or other medical professional promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, notify your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, notify the doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these symptoms persist or become severe, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any bothersome side effects occur, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these effects persist or worsen, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these effects persist or worsen, notify your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these symptoms persist or worsen, notify your doctor or pharmacist.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these symptoms persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, notify your doctor, dentist, or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these side effects persist or worsen, notify your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If either of these effects persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, notify your doctor or pharmacist immediately.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these symptoms persist or worsen, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these symptoms persist or become severe, notify your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If they persist or worsen, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects persist or worsen, notify your doctor or pharmacist immediately.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If this effect persists or worsens, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these side effects persist or worsen, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects continue or worsen, notify your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If they persist or become bothersome, notify your doctor promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If these symptoms continue or become bothersome notify your doctor.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If either of these changes persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these side effects persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these side effects persist or worsen, notify your doctor or pharmacist promptly.', '')
insert into @tabReplacements(replaceWhat, replaceWith) values('If any of these effects continue or worsen, notify your doctor or pharmacist.', '')
--insert into @tabReplacements(replaceWhat, replaceWith) values('', '')

insert into @tabReplacements(replaceWhat, replaceWith) values('SIDE EFFECTS:', '')



declare @maxTextSequenceNumber int

select @maxTextSequenceNumber = min(pemt.TextSequenceNumber)
from MDPatientEducationMonographText as pemt
join @tabTerminators as tt on pemt.MonographText like tt.TerminatorExpression
where pemt.PatientEducationMonographId = @PatientEducationMonographId
and pemt.LineIdentifier = 'S'
and isnull(pemt.RecordDeleted, 'N') <> 'Y'

--print @maxTextSequenceNumber

declare @MonographText varchar(250)
declare @textParagraph varchar(2)

-- retrieve all text up to the terminator text line
declare cMono cursor for
select pemt.MonographText
from MDPatientEducationMonographText as pemt
where pemt.PatientEducationMonographId = @PatientEducationMonographId
and pemt.LineIdentifier = 'S'
and isnull(pemt.RecordDeleted, 'N') <> 'Y'
and ((pemt.TextSequenceNumber < @maxTextSequenceNumber) or (@maxTextSequenceNumber is null))
order by pemt.TextSequenceNumber


open cMono

fetch cMono into @MonographText

-- skip past the "see also/also see" stuff
if (@@fetch_status = 0) and ((@MonographText like '%also see%') or (@MonographText like '%see also%'))
begin

   while @@fetch_status = 0 and @MonographText not like '   %'
   begin
      fetch cMono into @MonographText
   end
end

while @@fetch_status = 0
begin

   if (len(@textSideEffects) > 1) and (@MonographText like '   %')
      set @textParagraph = char(13) + char(10)
   else
      set @textParagraph = ''

   set @textSideEffects = @textSideEffects + @textParagraph + ltrim(@MonographText) + ' '

   fetch cMono into @MonographText

end

close cMono

deallocate cMono

-- apply replacement strings
declare @replaceWhat varchar(500), @replaceWith varchar(500)

declare cReplace cursor for
select replaceWhat, replaceWith
from @tabReplacements

open cReplace

fetch cReplace into @replaceWhat, @replaceWith

while @@fetch_status = 0
begin
   set @textSideEffects = replace(@textSideEffects, @replaceWhat, @replaceWith)

   fetch cReplace into @replaceWhat, @replaceWith
end

close cReplace

deallocate cReplace

set @textSideEffects = ltrim(rtrim(@textSideEffects))



update r
set SideEffects=@textSideEffects
from #Report r
where r.PatientEducationMonographId = @PatientEducationMonographId

-- return results
--select @PatientEducationMonographId as PatientEducationMonographId, @textSideEffects as FormattedSideEffectsText

GO
